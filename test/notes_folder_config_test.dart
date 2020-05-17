import 'dart:io';

import 'package:gitjournal/core/notes_folder_config.dart';
import 'package:gitjournal/core/notes_folder_fs.dart';
import 'package:gitjournal/core/sorting_mode.dart';
import 'package:gitjournal/folder_views/common.dart';
import 'package:gitjournal/folder_views/standard_view.dart';
import 'package:gitjournal/screens/note_editor.dart';
import 'package:gitjournal/settings.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  group('Notes Folder Config', () {
    Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('__notes_config_test__');
    });

    tearDown(() async {
      tempDir.deleteSync(recursive: true);
    });

    test('Should load from FS correctly', () async {
      var folder = NotesFolderFS(null, tempDir.path);
      var config = NotesFolderConfig(
        defaultEditor: EditorType.Checklist,
        defaultView: FolderViewType.Standard,
        showNoteSummary: true,
        sortingMode: SortingMode.Modified,
        viewHeader: StandardViewHeader.TitleOrFileName,
        fileNameFormat: NoteFileNameFormat.Default,
        folder: folder,
      );

      await config.saveToFS();
      var file = File(p.join(tempDir.path, NotesFolderConfig.FILENAME));
      expect(file.existsSync(), true);

      var config2 = await NotesFolderConfig.fromFS(folder);
      expect(config, config2);
    });
  });
}
