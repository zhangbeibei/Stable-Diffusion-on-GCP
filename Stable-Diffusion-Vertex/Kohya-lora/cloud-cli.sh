# cloud build image
gcloud builds submit --config cloud-build-config-kohya.yaml .

# create vertex ai customer training job
# args format:
# --model_name: Huggingface repo id, or "/gcs/bucket_name/model_folder". I only test the models downloaded from HF, with standard diffusers format. Safetensors has not been test.
# --input_storage: /gcs/bucket_name/input_image_folder
#     images put in subfolder, with foder name repeat num per image_prompt name, eg. 10_aki
# --output_storage: /gcs/bucket_name/output_folder
# --display_name: prompt name
gcloud ai custom-jobs create  \
  --region=us-central1   \
  --display-name=sd-kohya   \
  --config=vertex-config-nfs.yaml   \
  --args="--method=kohya_lora,--model_name=CompVis/stable-diffusion-v1-4,--input_storage=/gcs/sd_lsj/input_dog_kohya,--output_storage=/gcs/sd_lsj/kohya_output,--display_name=sks_dog,--save_nfs=True"
  --command="python3,train_kohya.py"

# only save the models in GCS to Filestore
gcloud ai custom-jobs create  \
  --region=us-central1   \
  --display-name=sd-kohya   \
  --config=vertex-config-nfs.yaml   \
  --args="--output_storage=/gcs/sd_lsj/kohya_output,--save_nfs_only=True"
  --command="python3,train_kohya.py"