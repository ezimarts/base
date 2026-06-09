exports.handler = async (event) => {
    let envValue = process.env.Video_Name || 'Environment variable not set';

    const response = {
        statusCode: 200,
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            message: 'Lambda API is working',
            videoName: envValue
        })
    };

    return response;
};