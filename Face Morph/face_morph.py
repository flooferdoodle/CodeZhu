from scipy.spatial import distance as dist
from scipy.spatial import Delaunay
from imutils.video import VideoStream, FPS
from imutils import face_utils
import imutils
import numpy as np
import time
import dlib
import cv2
from PIL import Image
import random

shape_predictor = "shape_predictor_68_face_landmarks.dat"
detector = dlib.get_frontal_face_detector()
predictor = dlib.shape_predictor(shape_predictor)

vs = VideoStream(src = 0).start()
fileStream = False
time.sleep(1.0)
fps = FPS().start()
#cv2.namedWindow("Smile Detector")

#obama_img = cv2.imread("lober.png")
obama_img = cv2.imread("obama face.jpg")
#obama_img = cv2.imread("mark face.png")

manual_points = True

lober_points_orig = [(108,178),(159,230),(192,291),(194,353),(196,445),(197,527),(162,581),(190,607),(242,613),(301,610),(337,581),(304,527),(303,448),(317,358),(322,294),(353,240),(402,210),(104,138),(131,88),(169,46),(220,18),(288,26),(334,41),(387,60),(415,100),(422,151),(412,184),(260,265),(260,303),(260,352),(257,406),(208,430),(234,428),(258,427),(282,427),(298,429),(234,195),(237,186),(147,186),(250,195),(245,204),(235,202),(266,193),(272,186),(280,188),(285,197),(278,204),(269,203),(171,562),(184,545),(205,530),(246,528),(293,530),(316,550),(329,571),(313,596),(279,607),(242,604),(201,602),(170,587),(188,567),(210,553),(246,551),(277,556),(299,567),(276,574),(246,576),(214,573)]
lober_scale = (1.0/530, 1.0/621)
lober_points_scaled = np.multiply(lober_points_orig, lober_scale)

def drawTriangle(image, vertices, simplices, color, thickness):
    cv2.line(image, tuple(vertices[simplices[0]]), tuple(vertices[simplices[1]]), color, thickness)
    cv2.line(image, tuple(vertices[simplices[1]]), tuple(vertices[simplices[2]]), color, thickness)
    cv2.line(image, tuple(vertices[simplices[2]]), tuple(vertices[simplices[0]]), color, thickness)
def drawTriangle(image, vertices, color, thickness):
    cv2.line(image, tuple(vertices[0]), tuple(vertices[1]), color, thickness)
    cv2.line(image, tuple(vertices[1]), tuple(vertices[2]), color, thickness)
    cv2.line(image, tuple(vertices[0]), tuple(vertices[2]), color, thickness)

def cv2ToPilImg(cv2_img):
    cv2_im = cv2.cvtColor(cv2_img,cv2.COLOR_BGR2RGB)
    pil_img = Image.fromarray(cv2_im)
    return pil_img
def PilToCv2Img(pil_img):
    imcv = cv2.cvtColor(np.asarray(pil_img), cv2.COLOR_RGB2BGR)
    return imcv

def getBoundingBox(tri):
    #print(tri)
    left = min(min(tri[0][0], tri[1][0]), tri[2][0])
    right = max(max(tri[0][0], tri[1][0]), tri[2][0])
    top = min(min(tri[0][1], tri[1][1]), tri[2][1])
    bot = max(max(tri[0][1], tri[1][1]), tri[2][1])
##    if left == right or top == bot:
##        print("Degenerate bounding box:", (left,top,right,bot)) #occurs when bounding box has a dimension of size 0
##        print("from triangle:", tri)
    return (int(left), int(top), int(right-left), int(bot-top))

def getBoundaryPoints(width, height):
    return [[0, 0],[int(width/2), 0],[width, 0],[0, int(height/2)],[width, int(height/2)],[0, height],[int(width/2), height],[width, height]]

def lerpPoints(points1, points2, alpha):
    #points is a (nx2) array, where n is number of points and each points is 2 dimensional
    #alpha is a float between 0.0 and 1.0
    if not points1.shape == points2.shape:
        print("shapes of lerping arrays do not match:", points1.shape, "vs.", points2.shape)
        return None
    
    out = np.empty_like(points1)
    for i in range(0, len(points1)):
        out[i][0] = (1-alpha)*points1[i][0] + alpha*points2[i][0]
        out[i][1] = (1-alpha)*points1[i][1] + alpha*points2[i][1]
    return out

def getWarpedFace(img, src_points, dest_points, triangles):
    img2 = 255 * np.ones(img.shape, dtype = cropped_face.dtype)
    for triangle in triangles:
        img1 = img[:,:,:]

        tri1 = np.float32([[src_points[triangle[0]], src_points[triangle[1]], src_points[triangle[2]]]])
        tri2 = np.float32([[dest_points[triangle[0]], dest_points[triangle[1]], dest_points[triangle[2]]]])

        r1 = getBoundingBox(tri1[0])
        r2 = getBoundingBox(tri2[0])
        if r1[2] == 0 or r1[3] == 0 or r2[2] == 0 or r2[3] == 0:
            #print("Degenerate triangles of zero width or length")
            #drawTriangle(img2, tri1[0], (255,0,0), 1)
            continue #if a triangle is basically a line, then there is no reason to perform a transformation on it

        tri1Cropped = []
        tri2Cropped = []
        for i in range(0,3):
            tri1Cropped.append(((tri1[0][i][0] - r1[0]),(tri1[0][i][1] - r1[1])))
            tri2Cropped.append(((tri2[0][i][0] - r2[0]),(tri2[0][i][1] - r2[1])))

        img1Cropped = img1[r1[1]:r1[1] + r1[3], r1[0]:r1[0] + r1[2]]
        
        warpMat = cv2.getAffineTransform( np.float32(tri1Cropped), np.float32(tri2Cropped) )
        img2Cropped = cv2.warpAffine( img1Cropped, warpMat, (r2[2], r2[3]), None, flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REFLECT_101 )

        #literally have no idea why but it will on occasion not warp to correct size so I'm just gonna force you out
        #THEORY: occurs because of degenerate triangles/bounding boxes
        #above theory is 95% most likely true since code works fine
##        if not img2Cropped.shape == (r2[3], r2[2], 3):
##            print(img2Cropped.shape, "does not match", (r2[3], r2[2], 3))
##            return None
                
        # Get mask by filling triangle
        mask = np.zeros((r2[3], r2[2], 3), dtype = np.float32) #replace this with the updated mask in which the triangles are procedurally added
        cv2.fillConvexPoly(mask, np.int32(tri2Cropped), (1.0, 1.0, 1.0), 16, 0);

        # Apply mask to cropped region
        img2Cropped = img2Cropped * mask

        h,w,c = mask.shape
        img2_range = img2[r2[1]:r2[1]+h, r2[0]:r2[0]+w]

        # Composite onto destination image
        img2[r2[1]:r2[1]+r2[3], r2[0]:r2[0]+r2[2]] = img2_range * ((1.0, 1.0, 1.0) - mask)
        img2[r2[1]:r2[1]+r2[3], r2[0]:r2[0]+r2[2]] = img2[r2[1]:r2[1]+r2[3], r2[0]:r2[0]+r2[2]] + img2Cropped

    #draw delaunay triangles
##    for triangle in triangles:
##        tri2 = np.float32([[dest_points[triangle[0]], dest_points[triangle[1]], dest_points[triangle[2]]]])
##        drawTriangle(img2, tri2[0], (255,0,0), 1)

    #draw detection points
##    for point in dest_points:
##        cv2.circle(img2, tuple(point), 2, (0,255,0), 1)
    
    return img2

def drawDelaunay(img, points, triangles):
    img_copy = img[:,:,:]
    #draw delaunay triangles
    for triangle in triangles:
        tri = np.float32([[points[triangle[0]], points[triangle[1]], points[triangle[2]]]])
        drawTriangle(img_copy, tri[0], (255,0,0), 1)

    #draw detection points
    for point in points:
        cv2.circle(img_copy, tuple(point), 1, (0,255,255), 1)
    
    return img_copy


freeze_frame = None

facemorph = False
validFace = False

face_points = None
obama_points = None
tri_indices = None
cropped_face = None
obama_resized = None

croppedBounds = None
alpha = 0.0
step_size = 0.1
while True:
    if not facemorph:
        frame = vs.read()
        frame = imutils.resize(frame, width=450)

        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        rects = detector(gray, 0)
        #for now only consider a single face:
        if len(rects) < 1:
            validFace = False
        else:
            rect = rects[0]
        
            #for rect in rects:
            #cut out face region
            left = int(rect.left() - rect.width()*0.3)
            top = int(rect.top() - rect.height()*0.6)
            right = int(rect.right() + rect.width()*0.3)
            bot = int(rect.bottom() + rect.height()*0.3)
            midW = int((right+left)/2)
            midH = int((top+bot)/2)
            width = int(right - left)
            height = int(bot - top)
            #print((width, height))

            #since we need a region larger than the detected face region, check if total region is outside of the screen
            if left < 0 or top < 0 or right > frame.shape[1] or bot > frame.shape[0]:
                validFace = False
                cv2.rectangle(frame, (left, top), (right, bot), (0,0,255), 3)
                #print("rect out of bounds")
            else:
                cv2.rectangle(frame, (left, top), (right, bot), (0,255,0), 3)
                croppedBounds = {"left":left,"top":top,"right":right,"bot":bot,"midW":midW,"midH":midH,"width":width,"height":height}
                validFace = True

        
        #draw frame
        cv2.imshow("Face Morph", frame)
        fps.update()

        key2 = cv2.waitKey(1) & 0xFF
        if key2 == ord('q'):
            break
        elif key2 == ord(' ') and not facemorph and validFace:
            #Calculate for transformation
            facemorph = True

            freeze_frame = frame[:, :, :]
            cropped_face = frame[croppedBounds["top"]:croppedBounds["bot"], croppedBounds["left"]:croppedBounds["right"]]
            
            h, w, c = cropped_face.shape
            if not h == height or not w == width: #redundant check to make sure size matches and nothing is offscreen
                print("copied frame is incorrect:", (h,w), "vs.", (height, width))
                continue

            face_points = predictor(gray, rect)
            face_points = face_utils.shape_to_np(face_points)
            for i in range(len(face_points)): #move all the points to the correct scaled locations in the cropped face
                face_points[i][0] = face_points[i][0] - left
                face_points[i][1] = face_points[i][1] - top
            #add in corner points
            face_points = np.append(face_points, getBoundaryPoints(width, height), axis=0)

            #delaunay triangulation
            tri = Delaunay(face_points)
            tri_indices = tri.simplices

            #detect obama facial structure
            obama_cv2 = cv2.resize(obama_img, (width,height))
            obama_resized = obama_cv2
            if not manual_points:
                obama_gray_cv2 = cv2.cvtColor(obama_cv2, cv2.COLOR_BGR2GRAY)
                obama_rect = detector(obama_gray_cv2, 0)[0]
                obama_shape = predictor(obama_gray_cv2, obama_rect)
                obama_shape = face_utils.shape_to_np(obama_shape)
                obama_points = obama_shape[0:obama_shape.size]
                obama_points = np.append(obama_points, getBoundaryPoints(width, height), axis=0)
            

            #lober
            if manual_points:
                obama_points = np.multiply(lober_points_scaled, (width, height))
                obama_points = np.append(obama_points, getBoundaryPoints(width, height), axis=0)


    if facemorph:
        #calculate in between points based on alpha value
        dest_points = lerpPoints(face_points, obama_points, alpha)

        face_warp = getWarpedFace(cropped_face, face_points, dest_points, tri_indices)
        obama_warp = getWarpedFace(obama_resized, obama_points, dest_points, tri_indices)

        
        # one or more dimensions didn't match, skip loop
        if face_warp is None or obama_warp is None:
            facemorph = False
            continue


        #overlay image
        pil_frame = cv2ToPilImg(freeze_frame)
        blended = cv2.addWeighted(face_warp, 1.0 - alpha, obama_warp, alpha, 0.0)
        blended = cv2ToPilImg(blended)
        pil_frame.paste(blended, (left, top))
        pil_frame.paste(cv2ToPilImg(drawDelaunay(face_warp, dest_points, tri_indices)), (left-width, top))
        pil_frame.paste(cv2ToPilImg(drawDelaunay(obama_warp, dest_points, tri_indices)), (right, top))
        freeze_frame = PilToCv2Img(pil_frame)
        
        
        #show image
        cv2.imshow("Face Morph", freeze_frame)
        fps.update()

        key2 = cv2.waitKey(1) & 0xFF
        if key2 == ord('q'):
            break
        elif key2 == ord('d'):
            alpha = min(1.0, alpha + step_size)
        elif key2 == ord('a'):
            alpha = max(0.0, alpha - step_size)
        elif key2 == ord(' '):
            alpha = 0.0
            facemorph = False
            validFace = False



'''
Workflow of morphing:

0 <= alpha <= 1
for each pair of points (in face1 and face2):
    find in between point:
        dirToFace2 = (face2-face1)
        destination = face1 + dirToFace2 * alpha
    affine transform face1 to all calculated destinations
    

'''
    

fps.stop()
cv2.destroyAllWindows()
vs.stop()
