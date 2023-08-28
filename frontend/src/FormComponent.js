import React, { useState } from 'react';

function FormComponent() {
  const [inputValue, setInputValue] = useState('');
  const [idempotencyKey, setIdempotencyKey] = useState('');
  const [result, setResult] = useState(null);

  const handleSubmit = async (e) => {
    e.preventDefault();
  
    try {
      const response = await fetch(process.env.REACT_APP_API_URL || 'http://localhost:3000/api/v1/total_amount/increment', {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ value: inputValue, idempotency_key: idempotencyKey })
      });

        const data = await response.json();
        setResult(data);


    } catch (error) {
      setResult({ error: error.message });
    }
  };
  

  const resultClass = result && result.error ? 'error' : ''; // Determine the CSS class based on the presence of error

  return (
    <div className="container mt-5">
      <div className="row justify-content-center">
        <div className="col-md-6">
          <form className="card p-4" onSubmit={handleSubmit}>
            <div className="mb-3">
              <label htmlFor="inputValue" className="form-label">Input Value</label>
              <input
                type="text"
                className="form-control"
                id="inputValue"
                value={inputValue}
                onChange={(e) => setInputValue(e.target.value)}
              />
            </div>
            <div className="mb-3">
              <label htmlFor="idempotencyKey" className="form-label">Idempotency Key</label>
              <input
                type="text"
                className="form-control"
                id="idempotencyKey"
                value={idempotencyKey}
                onChange={(e) => setIdempotencyKey(e.target.value)}
              />
            </div>
            <button type="submit" className="btn btn-primary">Submit</button>
          </form>
          {result && (
            <div className="card mt-4">
              <div className="card-body">
                <h5 className="card-title">Result</h5>
                <pre className={resultClass}>{JSON.stringify(result, null, 2)}</pre>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

export default FormComponent;
