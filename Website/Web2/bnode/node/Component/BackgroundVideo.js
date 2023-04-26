import React from "react";

const BackgroundVideo = () => {
  return (
    <video autoPlay muted loop id="background-video" className="absolute top-0 left-0 w-full h-full object-cover z-0">
      <source src="/public/vd.mp4"  />
      Your browser does not support the video tag.
    </video>
  );
};

export default BackgroundVideo;
