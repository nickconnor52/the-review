import React, { useState } from 'react'
import ReactMde from 'react-mde';
import ReactMarkdown from 'react-markdown';
import 'react-mde/lib/styles/css/react-mde-all.css';


function MarkdownEditor(props) {
  const { content, onChange } = props;
  const [selectedTab, setSelectedTab] = useState("write");

  return (
    <div className="container">
      <ReactMde
        value={content}
        onChange={onChange}
        selectedTab={selectedTab}
        onTabChange={setSelectedTab}
        generateMarkdownPreview={(markdown) =>
          Promise.resolve(<ReactMarkdown source={markdown} />)
        }
      />
    </div>
  );
}

export default MarkdownEditor;
