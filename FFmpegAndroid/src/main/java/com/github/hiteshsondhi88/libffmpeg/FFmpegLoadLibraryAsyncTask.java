package com.github.hiteshsondhi88.libffmpeg;

import android.content.Context;
import android.os.AsyncTask;

import java.io.File;

class FFmpegLoadLibraryAsyncTask extends AsyncTask<Void, Void, Boolean> {

    private final String cpuArchNameFromAssets;
    private final Context context;
    private FFmpegLoadBinaryResponseHandler ffmpegLoadBinaryResponseHandler;

    FFmpegLoadLibraryAsyncTask(Context context, String cpuArchNameFromAssets, FFmpegLoadBinaryResponseHandler ffmpegLoadBinaryResponseHandler) {
        this.context = context;
        this.cpuArchNameFromAssets = cpuArchNameFromAssets;
        this.ffmpegLoadBinaryResponseHandler = ffmpegLoadBinaryResponseHandler;
    }

    public FFmpegLoadBinaryResponseHandler getFfmpegLoadBinaryResponseHandler() {
        return ffmpegLoadBinaryResponseHandler;
    }

    public void setFfmpegLoadBinaryResponseHandler(FFmpegLoadBinaryResponseHandler ffmpegLoadBinaryResponseHandler) {
        this.ffmpegLoadBinaryResponseHandler = ffmpegLoadBinaryResponseHandler;
    }

    @Override
    protected Boolean doInBackground(Void... params) {
        File ffmpegFile = new File(FileUtils.getFFmpeg(context));
        Log.d("------" + ffmpegFile.getAbsolutePath());
        if (ffmpegFile.exists() && isDeviceFFmpegVersionOld() && !ffmpegFile.delete()) {
            return false;
        }
        if (!ffmpegFile.exists()) {
            boolean isFileCopied = FileUtils.copyBinaryFromAssetsToData(context,
                    cpuArchNameFromAssets + File.separator + FileUtils.ffmpegFileName,
                    FileUtils.ffmpegFileName);

            // make file executable
            if (isFileCopied) {
                if (!ffmpegFile.canExecute()) {
                    Log.d("-------FFmpeg is not executable, trying to make it executable ...");
                    if (ffmpegFile.setExecutable(true)) {
                        return true;
                    }
                } else {
                    Log.d("--------FFmpeg is executable");
                    return true;
                }
            }
        }
        return ffmpegFile.exists() && ffmpegFile.canExecute();
    }

    @Override
    protected void onPostExecute(Boolean isSuccess) {
        super.onPostExecute(isSuccess);
        if (ffmpegLoadBinaryResponseHandler != null) {
            if (isSuccess) {
                ffmpegLoadBinaryResponseHandler.onSuccess();
            } else {
                ffmpegLoadBinaryResponseHandler.onFailure();
            }
            ffmpegLoadBinaryResponseHandler.onFinish();
        }
    }

    private boolean isDeviceFFmpegVersionOld() {
        boolean isDeviceFFmpegVersionOld = CpuArch.fromString(FileUtils.SHA1(FileUtils.getFFmpeg(context))).equals(CpuArch.NONE);
        Log.d("--------isDeviceFFmpegVersionOld=" + isDeviceFFmpegVersionOld);
        return isDeviceFFmpegVersionOld;
    }
}
