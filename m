Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A9524D525
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 14:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728644AbgHUMil (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 08:38:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9648 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728570AbgHUMig (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Aug 2020 08:38:36 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07LCZ0jN064077
        for <kvm@vger.kernel.org>; Fri, 21 Aug 2020 08:38:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=0xJWh1SRE2g5KAH6f/ZgdLqFd0PQlVheqF0a1wd2OUs=;
 b=NxCpapQEHDJo3r/OZNhhskNU8w3mNHztj/qDrSEBjVNnot3JtJGAdPL8WyKF/9gMMQmw
 Jo2tT6jWNV/l6PvcbBiiTnbt3hS8KqYIbm2RPB+zSwGEzlkjcJLRalJ85sm4HbaK/EmC
 5zOrOfPFv5d+H1x7PbmqcXJpGaMImMX7uAiND32Nzg/vsonP7eijXGXN/LUJcPtrr5US
 fBjN0putywOK76t1+bEtiXfAmcAWwGo1Wg3OFWQva9hybpBjfrQ0VTOE+3msnXQCZ4G3
 0RI7zu9m9219gn/EeZ9Ge7B5DT1ybMM/IHhbu4TbQU68WsJ6AxYzXJEJmVs8538ombyg ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 332b8an839-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 21 Aug 2020 08:38:35 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07LCZ0LO064094
        for <kvm@vger.kernel.org>; Fri, 21 Aug 2020 08:38:35 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 332b8an82f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Aug 2020 08:38:35 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07LCWDtR027238;
        Fri, 21 Aug 2020 12:38:33 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 330tbvu2ch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Aug 2020 12:38:32 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07LCcUt921758230
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Aug 2020 12:38:30 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B65664C040;
        Fri, 21 Aug 2020 12:38:30 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5908D4C064;
        Fri, 21 Aug 2020 12:38:30 +0000 (GMT)
Received: from marcibm.ibmuc.com (unknown [9.145.60.23])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 21 Aug 2020 12:38:30 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     <kvm@vger.kernel.org>
Cc:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH 2/2] Use same test names in the default and the TAP13 output format
Date:   Fri, 21 Aug 2020 14:37:44 +0200
Message-Id: <20200821123744.33173-3-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200821123744.33173-1-mhartmay@linux.ibm.com>
References: <20200821123744.33173-1-mhartmay@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-21_06:2020-08-21,2020-08-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 suspectscore=1 mlxscore=0 bulkscore=0 mlxlogscore=999 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008210115
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the same test names in the TAP13 output as in the default output
format. This makes the output more consistent. To achieve this, we
need to pass the test name as an argument to the function
`process_test_output`.

Before this change:
$ ./run_tests.sh
PASS selftest-setup (14 tests)
...

vs.

$ ./run_tests.sh -t
TAP version 13
ok 1 - selftest: true
ok 2 - selftest: argc == 3
...

After this change:
$ ./run_tests.sh
PASS selftest-setup (14 tests)
...

vs.

$ ./run_tests.sh -t
TAP version 13
ok 1 - selftest-setup: true
ok 2 - selftest-setup: argc == 3
...

While at it, introduce a local variable `kernel` in
`RUNTIME_log_stdout` since this makes the function easier to read.

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
---
 run_tests.sh         | 15 +++++++++------
 scripts/runtime.bash |  6 +++---
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/run_tests.sh b/run_tests.sh
index 01e36dcfa06e..b5812336866f 100755
--- a/run_tests.sh
+++ b/run_tests.sh
@@ -81,18 +81,19 @@ if [[ $tap_output == "no" ]]; then
     postprocess_suite_output() { cat; }
 else
     process_test_output() {
+        local testname="$1"
         CR=$'\r'
         while read -r line; do
             line="${line%$CR}"
             case "${line:0:4}" in
                 PASS)
-                    echo "ok TEST_NUMBER - ${line#??????}" >&3
+                    echo "ok TEST_NUMBER - ${testname}:${line#*:*:}" >&3
                     ;;
                 FAIL)
-                    echo "not ok TEST_NUMBER - ${line#??????}" >&3
+                    echo "not ok TEST_NUMBER - ${testname}:${line#*:*:}" >&3
                     ;;
                 SKIP)
-                    echo "ok TEST_NUMBER - ${line#??????} # skip" >&3
+                    echo "ok TEST_NUMBER - ${testname}:${line#*:*:} # skip" >&3
                     ;;
                 *)
                     ;;
@@ -114,12 +115,14 @@ else
     }
 fi
 
-RUNTIME_log_stderr () { process_test_output; }
+RUNTIME_log_stderr () { process_test_output "$1"; }
 RUNTIME_log_stdout () {
+    local testname="$1"
     if [ "$PRETTY_PRINT_STACKS" = "yes" ]; then
-        ./scripts/pretty_print_stacks.py $1 | process_test_output
+        local kernel="$2"
+        ./scripts/pretty_print_stacks.py "$kernel" | process_test_output "$testname"
     else
-        process_test_output
+        process_test_output "$testname"
     fi
 }
 
diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index caa4c5ba18cc..294e6b15a5e2 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -140,10 +140,10 @@ function run()
     # extra_params in the config file may contain backticks that need to be
     # expanded, so use eval to start qemu.  Use "> >(foo)" instead of a pipe to
     # preserve the exit status.
-    summary=$(eval $cmdline 2> >(RUNTIME_log_stderr) \
-                             > >(tee >(RUNTIME_log_stdout $kernel) | extract_summary))
+    summary=$(eval $cmdline 2> >(RUNTIME_log_stderr $testname) \
+                             > >(tee >(RUNTIME_log_stdout $testname $kernel) | extract_summary))
     ret=$?
-    [ "$STANDALONE" != "yes" ] && echo > >(RUNTIME_log_stdout $kernel)
+    [ "$STANDALONE" != "yes" ] && echo > >(RUNTIME_log_stdout $testname $kernel)
 
     if [ $ret -eq 0 ]; then
         print_result "PASS" $testname "$summary"
-- 
2.25.4

