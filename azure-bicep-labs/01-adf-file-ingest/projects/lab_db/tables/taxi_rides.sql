CREATE TABLE [dbo].[taxi_rides]
(
  [unique_key]            NVARCHAR(40)  NOT NULL PRIMARY KEY,
  [taxi_id]               NVARCHAR(128) NOT NULL,
  [trip_start_timestamp]  DATETIME2     NOT NULL,
  [trip_end_timestamp]    DATETIME2     NOT NULL,
  [trip_seconds]          INT           NULL,
  [trip_miles]            FLOAT         NULL,
  [fare]                  DECIMAL       NULL,
  [tips]                  DECIMAL       NULL,
  [tolls]                 DECIMAL       NULL,
  [extras]                DECIMAL       NULL,
  [trip_total]            DECIMAL       NULL,
  [payment_type]          NVARCHAR(30)  NULL,
  [company]               NVARCHAR(200) NULL,
  [pickup_latitude]       NVARCHAR(30)  NULL,
  [pickup_longitude]      NVARCHAR(30)  NULL,
  [record_created_at]     DATETIME      NOT NULL DEFAULT(GETUTCDATE())
)
