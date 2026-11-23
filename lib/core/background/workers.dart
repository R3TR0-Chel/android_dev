import "package:material_ui/material_ui.dart";
import "package:workmanager/workmanager.dart";
import "notifications.dart";

abstract class BackgroundTasks{
  static const likeDigest = "likesDigest";
  static const likeDigestOnce = "likeDigestOnce";
  static const likeDigestPeriodic = "likeDigestPeriodic";
}

@pragma("vm:entry-point")
void callbackDispatcher(){
  Workmanager().executeTask((taskName, inputData) async {
    debugPrint("[Workmanager] running task $taskName with data: $inputData");
    try{
    switch(taskName){
      case BackgroundTasks.likeDigest:
        await runLikeDigest();
    }
    return true;

    }catch(error, stack){
      debugPrint("[Workmanager] failed eror: $error and $stack");
      return false;
    }

  });
}

Future <void> runLikeDigest() async {
  await AppNotifications.showLikesDigest(title: "Your post was liked", body: "Someone liked your post");
}

abstract final class LikeDigestScheduler{

  static Future<void> start()=> Workmanager().registerPeriodicTask(
    BackgroundTasks.likeDigestPeriodic, 
    BackgroundTasks.likeDigest,
    frequency: Duration(minutes: 15),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.update
  );

  static Future<void> stop() => Workmanager().cancelByUniqueName(BackgroundTasks.likeDigestPeriodic);

  static Future <bool> isRunning() => Workmanager().isScheduledByUniqueName(BackgroundTasks.likeDigestPeriodic);

  static Future <void> runOnce({Duration delay = const Duration(seconds: 10)}) =>
    Workmanager().registerOneOffTask(BackgroundTasks.likeDigestOnce, BackgroundTasks.likeDigest,
    initialDelay: delay,
    existingWorkPolicy: ExistingWorkPolicy.replace
    );
}