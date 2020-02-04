import PropTypes from 'prop-types';
import React from 'react';
import MicIcon from 'images/svg_icons/mic.svg'

const EpisodeMenuItem = ({episode}) => (
  <div>
    <object 
      type="image/svg+xml" 
      data={ MicIcon }
      style={{
        height: '17px',
        marginRight: '10px',
        width: '17px',
      }}
    >Episode icon</object>
    <span>{episode.title}</span>
  </div>
);

EpisodeMenuItem.propTypes = {
  episode: PropTypes.shape({
    title: PropTypes.string.isRequired,
  }).isRequired,
};

export default EpisodeMenuItem;
