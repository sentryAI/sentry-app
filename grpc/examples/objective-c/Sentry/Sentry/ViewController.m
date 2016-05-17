//
//  ViewController.m
//  Sentry
//
//  Created by Cathy Wong on 4/20/16.
//  Copyright © 2016 Thrun Lab. All rights reserved.
//

#import "ViewController.h"
#import <Sentry/InceptionInference.pbrpc.h>
#import <GRPCClient/GRPCCall+Tests.h>
#import <AVFoundation/AVFoundation.h>

// Define the service host address
static NSString *const kHostAddress = @"104.197.50.236:9000";
//static NSString *const kHostAddress = @"130.211.115.226:9000"; // image classifier

//static NSString *const kHostAddress = @"mjolnir-collect.stanford.edu:8000";
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [self turnTorchOn:true];
    // Create a step
    ORKInstructionStep *instructionStep =
    [[ORKInstructionStep alloc] initWithIdentifier:@"intro"];
    instructionStep.title = @"Welcome to the Sentry ResearchKit classifier app.";
    instructionStep.detailText = @"To record a lesion, please have the patient identifier number ready.";
    
    // Gather patient identifier number
    ORKNumericAnswerFormat *identifierFormat =
    [ORKNumericAnswerFormat integerAnswerFormatWithUnit:@""];
    identifierFormat.minimum = @(0);
    identifierFormat.maximum = @(99999999);
    ORKQuestionStep *patientIdentifierStep = [ORKQuestionStep questionStepWithIdentifier:@"patientIdentifierStep"
                                                                                   title:@"Enter the patient MRN:"
                                                                                  answer:identifierFormat];
    
    // Capture the clinical impression
    ORKFormStep *clinicalImpressionForm = [[ORKFormStep alloc] initWithIdentifier:@"clinicalImpressionFormstep"
                                                                            title:@"Lesion Clinical Impression" text:@"Record your primary impression of this lesion. Keep answers concise."];
    NSMutableArray *clinicalImpressionFormItems = [NSMutableArray new];
    [clinicalImpressionFormItems addObject:[[ORKFormItem alloc] initWithSectionTitle:@"Top 3 Potential Diagnoses"]];
    ORKTextAnswerFormat *impressionAnswerFormat = [ORKTextAnswerFormat textAnswerFormatWithMaximumLength:@(150)];
    
    // Top 3 clinical impressions
    ORKFormItem *firstImpression = [[ORKFormItem alloc] initWithIdentifier:@"firstImpression" text:@"First impression?" answerFormat:impressionAnswerFormat];
    firstImpression.placeholder = @"Example: Melanoma";
    
    ORKFormItem *secondImpression = [[ORKFormItem alloc] initWithIdentifier:@"secondImpression" text:@"Second impression?" answerFormat:impressionAnswerFormat];
    secondImpression.placeholder = @"Example: Dermal benign lesion";
    
    ORKFormItem *thirdImpression = [[ORKFormItem alloc] initWithIdentifier:@"thirdImpression" text:@"Third impression?" answerFormat:impressionAnswerFormat];
    thirdImpression.placeholder = @"Example: Dermal benign lesion";
    
    [clinicalImpressionFormItems addObjectsFromArray:@[firstImpression, secondImpression, thirdImpression]];
    
    clinicalImpressionForm.formItems = clinicalImpressionFormItems;
    clinicalImpressionForm.optional = false;
    
    // Patient skin lesion predictive factors
    ORKFormStep *patientFactorsForm = [[ORKFormStep alloc] initWithIdentifier:@"patientFactorsFormstep"
                                                                            title:@"Additional Patient Information" text:@"Please let us know some additional basic information about the patient's history."];
    NSMutableArray *patientFactorFormItems = [NSMutableArray new];
    // 1. Gender
    ORKAnswerFormat *genderFormat = [ORKHealthKitCharacteristicTypeAnswerFormat answerFormatWithCharacteristicType:[ HKCharacteristicType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex]];
    [patientFactorFormItems addObject:
     [[ORKFormItem alloc] initWithIdentifier:@"genderIdentifier"
                                        text:@"Gender"
                                answerFormat:genderFormat]];
    
    // 2. Age
    ORKNumericAnswerFormat *ageFormat = [ORKNumericAnswerFormat integerAnswerFormatWithUnit:@"years"];
    ageFormat.minimum = @(0);
    ageFormat.maximum = @(120);
    [patientFactorFormItems addObject:
     [[ORKFormItem alloc] initWithIdentifier:@"ageIdentifier"
                                        text:@"Age"
                                answerFormat:ageFormat]];
    
    // 4. History of any skin cancer
    [patientFactorFormItems addObject:
     [[ORKFormItem alloc] initWithIdentifier:@"historyAnySkinCancerIdentifier"
                                        text:@"Does the patient have a history of any type of skin cancer?"
                                answerFormat:[ORKBooleanAnswerFormat new]]];
    // 5. History of melanoma
    [patientFactorFormItems addObject:
     [[ORKFormItem alloc] initWithIdentifier:@"historyMelanomaIdentifier"
                                        text:@"Does the patient have a history of melanoma?"
                                answerFormat:[ORKBooleanAnswerFormat new]]];
    
    // 6. History of tanning bed use
    [patientFactorFormItems addObject:
     [[ORKFormItem alloc] initWithIdentifier:@"tanningBedUseIdentifier"
                                        text:@"Has the patient ever used a tanning bed?"
                                answerFormat:[ORKBooleanAnswerFormat new]]];
    
    // 7. Blistering sun burns, with water blisters
    [patientFactorFormItems addObject:
     [[ORKFormItem alloc] initWithIdentifier:@"sunBurnIdentifier"
                                        text:@"Any blistering sun burns, with water blisters?"
                                answerFormat:[ORKBooleanAnswerFormat new]]];
    // 8. Family history
    [patientFactorFormItems addObject:
     [[ORKFormItem alloc] initWithIdentifier:@"familyHistoryIdentifier"
                                        text:@"Any first degree family members with melanoma?"
                                answerFormat:[ORKBooleanAnswerFormat new]]];
    
    //9. Number of moles on the patient's body
    NSArray<NSString *> *numberMolesLabels = @[@"More than 50", @"Less than 50"];
    NSMutableArray *numberMolesTextChoices = [NSMutableArray new];
    for (int i=0; i < [numberMolesLabels count]; i++) {
        [numberMolesTextChoices addObject:[[ORKTextChoice alloc] initWithText:numberMolesLabels[i] detailText:nil value:@(i) exclusive:YES]];
    }
    ORKTextChoiceAnswerFormat *numberMolesFormat = [ORKTextChoiceAnswerFormat choiceAnswerFormatWithStyle: ORKChoiceAnswerStyleSingleChoice textChoices:numberMolesTextChoices];
    [patientFactorFormItems addObject:
     [[ORKFormItem alloc] initWithIdentifier:@"numberMolesIdentifier"
                                        text:@"Approximately how many moles does the patient have?"
                                answerFormat:numberMolesFormat]];
    
    patientFactorsForm.formItems = patientFactorFormItems;
    
    
    
    // Patient skin Fitzpatrick type
    NSArray<NSString *> *fitzpatrickLabels = @[@"Type I", @"Type II", @"Type III", @"Type IV", @"Type V", @"Type VI"];
    NSMutableArray *fitzpatrickTextChoices = [NSMutableArray new];
    for (int i=0; i < [fitzpatrickLabels count]; i++) {
        [fitzpatrickTextChoices addObject:[[ORKTextChoice alloc] initWithText:fitzpatrickLabels[i] detailText:nil value:@(i) exclusive:YES]];
    }
    ORKValuePickerAnswerFormat *fitzpatrickFormat = [[ORKValuePickerAnswerFormat alloc] initWithTextChoices:fitzpatrickTextChoices];
    ORKQuestionStep *fitzpatrickStep = [ORKQuestionStep questionStepWithIdentifier:@"fitzpatrickStep"
                                                                                   title:@"What is the patient's Fitzpatrick skin type?"
                                                                                  answer:fitzpatrickFormat];
    
    // Lesion capture instruction step
    ORKInstructionStep *skinLesionInstructionStep = [[ORKInstructionStep alloc] initWithIdentifier:@"skinLesionInstructionStep"];
    skinLesionInstructionStep.title = @"Next, you will need to take a photo of the lesion";
    skinLesionInstructionStep.text = @"Zoom in on the lesion as much as possible, and ensure that the photo is in focus. Avoid capturing identifying marks, like tattoos and faces, where possible.";
 
    // Lesion capture step
    ORKImageCaptureStep *skinLesionCaptureStep =
    [[ORKImageCaptureStep alloc] initWithIdentifier:@"imageCaptureStep"];
    skinLesionCaptureStep.optional = false;
    
    
    // Add all steps to task
    ORKOrderedTask *task =
    [[ORKOrderedTask alloc] initWithIdentifier:@"task" steps:@[instructionStep,patientIdentifierStep, patientFactorsForm, fitzpatrickStep, clinicalImpressionForm,  skinLesionInstructionStep, skinLesionCaptureStep]];
    
    ORKTaskViewController *taskViewController =
    [[ORKTaskViewController alloc] initWithTask:task taskRunUUID:nil];
    taskViewController.delegate = self;
    
    // Get the output directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    taskViewController.outputDirectory = [[NSURL alloc] initFileURLWithPath:documentsDirectory];
    [self presentViewController:taskViewController animated:YES completion:nil];
}

- (void)taskViewController:(ORKTaskViewController *)taskViewController
       didFinishWithReason:(ORKTaskViewControllerFinishReason)reason
                     error:(NSError *)error {
    
    ORKTaskResult *taskResult = [taskViewController result];
    
    NSLog(@"%@", taskResult);
    NSData* imageData = nil;
    for(ORKResult* stepResult in taskResult.results) {
        if ([stepResult.identifier isEqualToString:@"imageCaptureStep"]) {
            for (ORKResult* imageStepResult in((ORKStepResult*)stepResult).results){
                if([imageStepResult isKindOfClass:[ORKFileResult class]]) {
                    ORKFileResult* fileResult = (ORKFileResult*) imageStepResult;
                    NSURL* fileURL = fileResult.fileURL;
                    imageData = [[NSData alloc] initWithContentsOfURL:fileURL];
                }
            }
        }
    }
    NSArray *labelArray = @[@"Dermal benign", @"Dermal malignant", @"Epidermal benign", @"Epidermal malignant", @"Genodermatosis", @"Inflammatory", @"Lymphoma", @"Not skin", @"Pigmented benign", @"Pigmented malignant"];
    
    
    if (imageData != nil) {
        NSLog(@"%@", @"Calling the inception service...");
    
        
        [GRPCCall useInsecureConnectionsForHost:kHostAddress];
        
        InceptionService *inceptionService = [[InceptionService alloc] initWithHost:kHostAddress];
        
        InceptionRequest *inceptionRequest = [InceptionRequest message];
        inceptionRequest.jpegEncoded = imageData;
        
        [inceptionService classifyWithRequest:inceptionRequest handler:
         ^(InceptionResponse *response, NSError *error) {
             
             if (response) {
                 NSLog(@"%@", @"Response");
                 NSLog(@"%@", response);
                 NSString* classLabel = labelArray[[response.classesArray valueAtIndex:0]];
                 NSLog(@"%@", classLabel);
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Top skin result!"
                                                        message:classLabel
                                                        delegate:self
                                                        cancelButtonTitle:@"Whoop de doo!"
                                                       otherButtonTitles:nil];
                 [alert show];
                 
                 // Then, dismiss the task view controller.
                 [self dismissViewControllerAnimated:YES completion:nil];
             } else {
                 NSLog(@"%@", @"Error");
                 NSLog(@"%@", error);
                 // Show an error
                 UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error classifying image!"
                    message:error.localizedDescription
                    delegate:self
                    cancelButtonTitle:@"Aw, shucks!"
                    otherButtonTitles:nil];
                 [errorAlert show];

                 // Then, dismiss the task view controller.
                 [self dismissViewControllerAnimated:YES completion:nil];
             }
         }];
    }

    
}

// Turns on the flashlight
- (void) turnTorchOn: (bool) on {
    
    // check if flashlight available
    NSLog(@"%@", @"turning torch on");
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash]){
            NSLog(@"%@", @"Flash available");
            [device lockForConfiguration:nil];
            if (on) {
                [device setTorchMode:AVCaptureTorchModeOn];
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
            }
            [device unlockForConfiguration];
        }
    } }


@end
