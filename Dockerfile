# Base image - guna Nginx sebab lightweight dan efficient untuk static sites
FROM nginx:alpine

# Copy application files ke Nginx default directory
COPY app/ /usr/share/nginx/html/

# Expose port 80 untuk HTTP traffic
EXPOSE 80

# Command untuk start Nginx (already defined in base image, tapi good practice tulis)
CMD ["nginx", "-g", "daemon off;"]