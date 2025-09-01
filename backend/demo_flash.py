from flask import Flask, request, jsonify
import json
import cv2
import math
import numpy as np
import mediapipe as mp
from mediapipe.tasks import python
from mediapipe.tasks.python import vision
from mediapipe.python import ImageFormat
from PIL import Image
import io
import base64


app = Flask(__name__)

index_color = (0, 255, 0)      
thumb_color = (255, 255, 0)    
pinkie_color = (255, 0, 255)   
midle_color = (0, 0, 255)     
ring_color = (255, 165, 0)    

def angle_between_points(A, B, C):
    """
    Angle is determined at A
    The angle is returned in degrees
    NOTE: cos(θ) = (a x b) / (||a|| ||b||)
    """


    # Get xyz coordinates relative to point A
    AB = (B[0]-A[0], B[1]-A[1], B[2]-A[2])
    AC = (C[0]-A[0], C[1]-A[1], C[2]-A[2])

    # Calculate the dot product
    dot_product = AB[0]*AC[0] + AB[1]*AC[1] + AB[2]*AC[2]

    # Caluclate the magnitudes
    mag_AB = math.sqrt(AB[0]**2 + AB[1]**2 + AB[2]**2)
    mag_AC = math.sqrt(AC[0]**2 + AC[1]**2 + AC[2]**2)

    # Calculate cos theta
    cos_theta = dot_product / (mag_AB * mag_AC)

    # Solve for theta
    theta = math.acos(cos_theta)

    return math.degrees(theta)

def get_position_from_landmark(landmark):
   return (landmark.x, landmark.y, landmark.z)

def calculate_finger_angles(A,B,C,D):
   '''
   ABCD are the position from each landmark of the finger
   Note the C is ommited for simplicity
   '''
   angle1 = angle_between_points(A,B,D)
   angle2 = angle_between_points(B,A,D)
   return angle1, angle2

def correct_hand_posture(hand_world_landmarks, failing_angle_l = 102, failing_angle_u = 139, passing_score = 3, debug = False):
  '''
  Each finger is checked to see if it is in the correct posture.
  passing_score is the number of each correct fingers needed to pass
  failing_angle is the angle at which we say there is bad posture
  '''

  # used to count the number of incorrect finger postures
  fail = 0
  failedfingers = []

  # thumb landmarks 1 2 3 4
  angle1, angle2 = calculate_finger_angles(
     get_position_from_landmark(hand_world_landmarks[1]),
     get_position_from_landmark(hand_world_landmarks[2]),
     get_position_from_landmark(hand_world_landmarks[3]),
     get_position_from_landmark(hand_world_landmarks[4])
    )

  if debug:
    print('Thumb', angle1, angle2)
  if angle2 > failing_angle_u or angle2 < failing_angle_l:
     fail += 1
     failedfingers.append("Thumb")

  # index landmarks 5 6 7 8
  angle1, angle2 = calculate_finger_angles(
     get_position_from_landmark(hand_world_landmarks[5]),
     get_position_from_landmark(hand_world_landmarks[6]),
     get_position_from_landmark(hand_world_landmarks[7]),
     get_position_from_landmark(hand_world_landmarks[8])
    )

  if debug:
    print('Index', angle1, angle2)
  if angle2 > failing_angle_u or angle2 < failing_angle_l:
     fail += 1
     failedfingers.append("Index")

  # middle landmarks 9 10 11 12
  angle1, angle2 = calculate_finger_angles(
     get_position_from_landmark(hand_world_landmarks[9]),
     get_position_from_landmark(hand_world_landmarks[10]),
     get_position_from_landmark(hand_world_landmarks[11]),
     get_position_from_landmark(hand_world_landmarks[12])
    )


  if debug:
    print('Middle', angle1, angle2)
  if angle2 > failing_angle_u or angle2 < failing_angle_l:
    fail += 1
    failedfingers.append("Middle")

  # Ring landmarks 13 14 15 16
  angle1, angle2 = calculate_finger_angles(
     get_position_from_landmark(hand_world_landmarks[13]),
     get_position_from_landmark(hand_world_landmarks[14]),
     get_position_from_landmark(hand_world_landmarks[15]),
     get_position_from_landmark(hand_world_landmarks[16])
    )

  if debug:
    print('Ring', angle1, angle2)
  if angle2 > failing_angle_u or angle2 < failing_angle_l:
    fail += 1
    failedfingers.append("Ring")

  # Pinkie landmarks 17 18 19 20
  angle1, angle2 = calculate_finger_angles(
     get_position_from_landmark(hand_world_landmarks[17]),
     get_position_from_landmark(hand_world_landmarks[18]),
     get_position_from_landmark(hand_world_landmarks[19]),
     get_position_from_landmark(hand_world_landmarks[20])
    )


  if debug:
    print('Pinkie', angle1, angle2)
  if angle2 > failing_angle_u or angle2 < failing_angle_l:
    fail += 1
    failedfingers.append("Pinkie")

  return fail < passing_score, fail, failedfingers

def draw_lines(image, landmark_1, landmark_2, color = (0,0,0)):
   """
   Draw lines on the image
   """

   # Get the height and width of the image
   height, width, channels = image.shape

   # landmarks are given as percentages relative to an image so we
   # convert them to positions on the image
   x1 = int(landmark_1.x * width)
   y1 = int(landmark_1.y * height)
   x2 = int(landmark_2.x * width)
   y2 = int(landmark_2.y * height)
   cv2.line(image, (x1,y1), (x2,y2), color, 3)

def draw_landmarks_on_image(image, detection_result):
    # Make a deep copy of the image
    annotated_image = image.copy()

    # count the number of hands
    hands = len(detection_result.hand_landmarks)

    height, width, channels = image.shape

    for i in range(hands):
      # Draw lines for each finger on the image

      handLandmarks = detection_result.hand_landmarks[i]
      draw_lines(annotated_image, handLandmarks[0], handLandmarks[1])
      draw_lines(annotated_image, handLandmarks[0], handLandmarks[5])
      draw_lines(annotated_image, handLandmarks[0], handLandmarks[17])

      draw_lines(annotated_image, handLandmarks[1], handLandmarks[2], thumb_color)
      draw_lines(annotated_image, handLandmarks[2], handLandmarks[3], thumb_color)
      draw_lines(annotated_image, handLandmarks[3], handLandmarks[4], thumb_color)

      draw_lines(annotated_image, handLandmarks[5], handLandmarks[9], index_color)
      draw_lines(annotated_image, handLandmarks[5], handLandmarks[6], index_color)
      draw_lines(annotated_image, handLandmarks[6], handLandmarks[7], index_color)
      draw_lines(annotated_image, handLandmarks[7], handLandmarks[8], index_color)

      draw_lines(annotated_image, handLandmarks[9], handLandmarks[13], midle_color)
      draw_lines(annotated_image, handLandmarks[9], handLandmarks[10], midle_color)
      draw_lines(annotated_image, handLandmarks[10], handLandmarks[11], midle_color)
      draw_lines(annotated_image, handLandmarks[11], handLandmarks[12], midle_color)

      draw_lines(annotated_image, handLandmarks[13], handLandmarks[17], ring_color)
      draw_lines(annotated_image, handLandmarks[13], handLandmarks[14], ring_color)
      draw_lines(annotated_image, handLandmarks[14], handLandmarks[15], ring_color)
      draw_lines(annotated_image, handLandmarks[15], handLandmarks[16], ring_color)

      draw_lines(annotated_image, handLandmarks[17], handLandmarks[18], pinkie_color)
      draw_lines(annotated_image, handLandmarks[18], handLandmarks[19], pinkie_color)
      draw_lines(annotated_image, handLandmarks[19], handLandmarks[20], pinkie_color)

      # Draw dots for each land mark

      for landmark in handLandmarks:
         x = int(landmark.x * width)
         y = int(landmark.y * height)
         center_coordinates = (x, y)

         cv2.circle(annotated_image, center_coordinates, 4, (0, 0, 255), 4)
         cv2.circle(annotated_image, center_coordinates, 2, (0, 255, 0), 2)


    return annotated_image


@app.route("/checkhands",methods=["POST"])
def check_hands_final():
  file = request.files["image"]
  image = Image.open(file.stream)
  # STEP 2: Create an HandLandmarker object.
  base_options = python.BaseOptions(model_asset_path='hand_landmarker.task')
  options = vision.HandLandmarkerOptions(base_options=base_options,
                                        num_hands=2)
  detector = vision.HandLandmarker.create_from_options(options)

  # STEP 3: Load the input image.
  npimg = np.array(image, np.uint8)
  image = mp.Image(image_format=ImageFormat.SRGB,data=npimg)
  # image = mp.Image.create_from_file("correct_1.jpeg")
  # STEP 4: Detect hand landmarks from the input image.
  detection_result = detector.detect(image)

  result = {"NumHandsFound":0, "NumHandsCorrect" :0, "FailedFingers0":[], "FailedFingers1": []}
  
  # count the number of hands
  hands = len(detection_result.hand_landmarks)
  numCorrect = 0
  if(hands < 1):
    result["NumHandsFound"] = 0
  else:
    result["NumHandsFound"] = hands

    for i in range(hands):
        correct,fails,failedfingers = correct_hand_posture(detection_result.hand_world_landmarks[i])
        
    if(correct):
        numCorrect += 1
    result[f"FailedFingers{i}"] = failedfingers

    annotated_image = draw_landmarks_on_image(npimg, detection_result)
    result["NumHandsCorrect"] = numCorrect
    result["image"] = str(base64.b64encode(annotated_image))
  return json.dumps(result)



@app.route("/test")
def test1():
    return json.dumps(np.sin(2))

