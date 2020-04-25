import React from 'react';
import PropTypes from 'prop-types';
import MicIcon from 'images/svg_icons/mic.svg'

class SearchResult extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return(
      <React.Fragment>
        <div className="media text-muted pt-3">

          <object
            type="image/svg+xml"
            data={ MicIcon }
            style={{
              height: '17px',
              marginRight: '10px',
              width: '17px',
            }}
          >Episode icon</object>

          <p className="media-body pb-3 mb-0 small lh-125 border-bottom border-gray">
            <a href={`/episodes/${this.props.episode_id}`}>
              <strong className="d-block text-gray-dark">{ this.props.title }</strong>
            </a>
              { this.props.description }
          </p>
        </div>
      </React.Fragment>
    );
  }
}

SearchResult.propTypes = {
  title: PropTypes.string.isRequired,
  description: PropTypes.string.isRequired,
  episode_id: PropTypes.number.isRequired,
};

export default SearchResult;
