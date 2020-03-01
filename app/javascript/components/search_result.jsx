import React from 'react';
import PropTypes from 'prop-types';

class SearchResult extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return(
      <React.Fragment>
        <div className="media text-muted pt-3">
          <svg className="bd-placeholder-img mr-2 rounded" width="32" height="32" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid slice" focusable="false" role="img" aria-label="Placeholder: 32x32"><title>Placeholder</title><rect width="100%" height="100%" fill="#007bff"></rect><text x="50%" y="50%" fill="#007bff" dy=".3em">32x32</text></svg>
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
