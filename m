Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75CE525168B
	for <lists+kvm@lfdr.de>; Tue, 25 Aug 2020 12:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729813AbgHYKVC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Aug 2020 06:21:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6380 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729785AbgHYKVA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Aug 2020 06:21:00 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07PA2NR7032213
        for <kvm@vger.kernel.org>; Tue, 25 Aug 2020 06:20:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=iXGQiCsj/iZ6TkRCiKyFTECVMQvEu6ZG2QSUuZeqDO4=;
 b=LedAgo201ZhfW9xSsM9PBl3kc5LEiwn4wqkdVVgdbAY09h4Zcip5S/tt49H1fvi6kSZT
 +S+e5KOdWbdQJuHQqs8webOUPDEpvNoje3GVLL+adjWxEsI2k4Ip1tpu7fFQcONTrBlk
 fRy+maD7s88rSXhEzVBbiNky/WXKdYoM6gK2sExfrA+qcsR4LtBxPEYNt6eds4N245lf
 Uu7qIE02aX+hPoXm6TNQuhYpYmZhW+wyjWJhjyxj8d9nZd7ws+Fn1o/ymK3i4WgfDJCn
 0fFopHi9j1BHavWhDETN7efmltza+XJjhFyeWi2jStxgoPYJtLIvvzUO/CNzt4Kth56b aQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33508js4av-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 25 Aug 2020 06:20:59 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07PA5SU2042992
        for <kvm@vger.kernel.org>; Tue, 25 Aug 2020 06:20:59 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33508js4ac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Aug 2020 06:20:59 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07PAG17n001194;
        Tue, 25 Aug 2020 10:20:57 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 332ujkua9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Aug 2020 10:20:57 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07PAKsYi31850772
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Aug 2020 10:20:54 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A43E9A405B;
        Tue, 25 Aug 2020 10:20:54 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45EE2A4053;
        Tue, 25 Aug 2020 10:20:54 +0000 (GMT)
Received: from marcibm.ibmuc.com (unknown [9.145.56.167])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 Aug 2020 10:20:54 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     <kvm@vger.kernel.org>
Cc:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH v2 2/2] Use same test names in the default and the TAP13 output format
Date:   Tue, 25 Aug 2020 12:20:36 +0200
Message-Id: <20200825102036.17232-3-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200825102036.17232-1-mhartmay@linux.ibm.com>
References: <20200825102036.17232-1-mhartmay@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-25_02:2020-08-24,2020-08-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=999 phishscore=0 adultscore=0 suspectscore=1 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008250073
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
ok 1 - selftest-setup: selftest: true
ok 2 - selftest-setup: selftest: argc == 3
...

While at it, introduce a local variable `kernel` in
`RUNTIME_log_stdout` since this makes the function easier to read.

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
---
 run_tests.sh         | 15 +++++++++------
 scripts/runtime.bash |  6 +++---
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/run_tests.sh b/run_tests.sh
index 01e36dcfa06e..f49dd864524e 100755
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
+                    echo "ok TEST_NUMBER - ${testname}: ${line#??????}" >&3
                     ;;
                 FAIL)
-                    echo "not ok TEST_NUMBER - ${line#??????}" >&3
+                    echo "not ok TEST_NUMBER - ${testname}: ${line#??????}" >&3
                     ;;
                 SKIP)
-                    echo "ok TEST_NUMBER - ${line#??????} # skip" >&3
+                    echo "ok TEST_NUMBER - ${testname}: ${line#??????} # skip" >&3
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

