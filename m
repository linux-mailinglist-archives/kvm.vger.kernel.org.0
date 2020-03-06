Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68C3617BBE2
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 12:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbgCFLm7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 06:42:59 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:14564 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726025AbgCFLm7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Mar 2020 06:42:59 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 026Bd4b8160103
        for <kvm@vger.kernel.org>; Fri, 6 Mar 2020 06:42:58 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yk33mwx3k-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2020 06:42:58 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <raspl@linux.ibm.com>;
        Fri, 6 Mar 2020 11:42:56 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 6 Mar 2020 11:42:53 -0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 026Bgq2P59310256
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Mar 2020 11:42:52 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 755AA42041;
        Fri,  6 Mar 2020 11:42:52 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C96542042;
        Fri,  6 Mar 2020 11:42:52 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  6 Mar 2020 11:42:52 +0000 (GMT)
From:   Stefan Raspl <raspl@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, pbonzini@redhat.com
Subject: [PATCH 1/7] tools/kvm_stat: rework command line sequence and message texts
Date:   Fri,  6 Mar 2020 12:42:44 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200306114250.57585-1-raspl@linux.ibm.com>
References: <20200306114250.57585-1-raspl@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20030611-0016-0000-0000-000002EDC083
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030611-0017-0000-0000-000033511847
Message-Id: <20200306114250.57585-2-raspl@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-06_03:2020-03-06,2020-03-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 mlxscore=0 priorityscore=1501 suspectscore=1 lowpriorityscore=0
 clxscore=1015 malwarescore=0 impostorscore=0 phishscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003060084
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Stefan Raspl <raspl@de.ibm.com>

Make sure command line arguments are sorted alphabetically
everywhere, and adjusted existing texts for interactive command 's' to
become consistent with the long form --set-delay.
Throwing in some PEP8 fixes (all cosmetics) for good measure.

Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
---
 tools/kvm/kvm_stat/kvm_stat     |  9 ++++----
 tools/kvm/kvm_stat/kvm_stat.txt | 40 ++++++++++++++++-----------------
 2 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
index ad1b9e646c49..8fa39eb43f64 100755
--- a/tools/kvm/kvm_stat/kvm_stat
+++ b/tools/kvm/kvm_stat/kvm_stat
@@ -1179,7 +1179,7 @@ class Tui(object):
 
         if not self._is_running_guest(self.stats.pid_filter):
             if self._gname:
-                try: # ...to identify the guest by name in case it's back
+                try:  # ...to identify the guest by name in case it's back
                     pids = self.get_pid_from_gname(self._gname)
                     if len(pids) == 1:
                         self._refresh_header(pids[0])
@@ -1332,8 +1332,8 @@ class Tui(object):
         msg = ''
         while True:
             self.screen.erase()
-            self.screen.addstr(0, 0, 'Set update interval (defaults to %.1fs).' %
-                               DELAY_DEFAULT, curses.A_BOLD)
+            self.screen.addstr(0, 0, 'Set update interval (defaults to %.1fs).'
+                               % DELAY_DEFAULT, curses.A_BOLD)
             self.screen.addstr(4, 0, msg)
             self.screen.addstr(2, 0, 'Change delay from %.1fs to ' %
                                self._delay_regular)
@@ -1541,7 +1541,7 @@ Interactive Commands:
    p     filter by PID
    q     quit
    r     reset stats
-   s     set update interval
+   s     set update interval (value range: 0.1-25.5 secs)
    x     toggle reporting of stats for individual child trace events
 Press any other key to refresh statistics immediately.
 """ % (PATH_DEBUGFS_KVM, PATH_DEBUGFS_TRACING)
@@ -1707,5 +1707,6 @@ def main():
     else:
         batch(stats)
 
+
 if __name__ == "__main__":
     main()
diff --git a/tools/kvm/kvm_stat/kvm_stat.txt b/tools/kvm/kvm_stat/kvm_stat.txt
index c057ba52364e..8e0658e79eb7 100644
--- a/tools/kvm/kvm_stat/kvm_stat.txt
+++ b/tools/kvm/kvm_stat/kvm_stat.txt
@@ -49,7 +49,7 @@ INTERACTIVE COMMANDS
 
 *r*::	reset stats
 
-*s*::   set update interval
+*s*::   set delay between refreshs
 
 *x*::	toggle reporting of stats for child trace events
  ::     *Note*: The stats for the parents summarize the respective child trace
@@ -64,37 +64,37 @@ OPTIONS
 --batch::
 	run in batch mode for one second
 
--l::
---log::
-	run in logging mode (like vmstat)
-
--t::
---tracepoints::
-	retrieve statistics from tracepoints
-
 -d::
 --debugfs::
 	retrieve statistics from debugfs
 
+-f<fields>::
+--fields=<fields>::
+        fields to display (regex), "-f help" for a list of available events
+
+-g<guest>::
+--guest=<guest_name>::
+        limit statistics to one virtual machine (guest name)
+
+-h::
+--help::
+        show help message
+
 -i::
 --debugfs-include-past::
 	include all available data on past events for debugfs
 
+-l::
+--log::
+        run in logging mode (like vmstat)
+
 -p<pid>::
 --pid=<pid>::
 	limit statistics to one virtual machine (pid)
 
--g<guest>::
---guest=<guest_name>::
-	limit statistics to one virtual machine (guest name)
-
--f<fields>::
---fields=<fields>::
-	fields to display (regex), "-f help" for a list of available events
-
--h::
---help::
-	show help message
+-t::
+--tracepoints::
+        retrieve statistics from tracepoints
 
 SEE ALSO
 --------
-- 
2.17.1

