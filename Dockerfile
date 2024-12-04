# Step 1: Specify the base image you want to use
# You can choose a different base image based on your application needs.
# For example, here we use Python as the base image.
FROM python:3.9-slim

# Step 2: Set the working directory inside the container
WORKDIR /app

# Step 3: Copy the local code to the container
# Copy your application code into the container’s working directory
COPY . /app

# Step 4: Install any dependencies your application needs
# For example, install Python dependencies from requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Step 5: Expose the necessary port (if your app runs on a port)
# This step can be omitted if not needed
EXPOSE 8080

# Step 6: Set the command to run your application
# For example, if you're running a Python application, it could be:
CMD ["python3", "app.py"]

