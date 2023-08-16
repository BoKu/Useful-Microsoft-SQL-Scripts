/*
 * David Chamberlain
 * This is really a "quantity" generator. It can technically be used to generate anything x number of times.
 * This example will generate 10,000,000 numbers
 *
 * Date: 2022-11-25
*/
DECLARE @HowManyRecordsDoYouWant BIGINT = 10000000;

DECLARE @MaxLimit BIGINT = 10000000;
IF(@HowManyRecordsDoYouWant > @MaxLimit) BEGIN
	DECLARE @MaxLimitText NVARCHAR(26) = FORMAT(@MaxLimit+1,'#,###')
	RAISERROR ( N'Let''s be "sane" shall we? %s rows is just too many records!', 11, 1, @MaxLimitText) WITH NOWAIT;
	RETURN;
END ELSE BEGIN 
	SET NOCOUNT ON;
	SELECT
		TOP (@HowManyRecordsDoYouWant)
		ROW_NUMBER() OVER(ORDER BY T1.NUMBER) "NUMBER"
	FROM
		MASTER..SPT_VALUES T1 WITH(NOLOCK)
	CROSS JOIN
		MASTER..SPT_VALUES T2 WITH(NOLOCK)
	CROSS JOIN
		MASTER..SPT_VALUES T3 WITH(NOLOCK)
	ORDER BY 
		ROW_NUMBER() OVER(ORDER BY T1.NUMBER)
	SET NOCOUNT OFF;
END 
