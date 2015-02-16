SELECT ROUND ( (COUNT (DISTINCT bno) * 32) / 1024) AS "MBs changed"
  FROM x$krcbit b
 WHERE     b.fno = &&1
       AND b.vercnt >=
              (SELECT MIN (ver)
                 FROM (SELECT curr_vercnt ver,
                              curr_highscn high,
                              curr_lowscn low
                         FROM x$krcfde
                        WHERE fno = &&1
                       UNION ALL
                       SELECT vercnt ver, high, low
                         FROM x$krcfbh
                        WHERE fno = &&1)
                WHERE (SELECT MAX (bd.checkpoint_change#)
                         FROM v$backup_datafile bd
                        WHERE bd.file# = &&1 AND bd.incremental_level <= 1) BETWEEN low
                                                                                AND high);
                                                                                
