Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4779727590E
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 15:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgIWNsO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 09:48:14 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7640 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726504AbgIWNsO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Sep 2020 09:48:14 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08NDXC84169216;
        Wed, 23 Sep 2020 09:48:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=uFqSzS8d52K8BKRJGWGm9lEoGlzK7xsvYKmeKqlNQ4k=;
 b=SYszFwl8dBqhWHP/EG82THOLEqlwgqamfZEBCTIW/b2qB8vWccBf6lsNY7by4PBDoGH0
 w84mEIop/w3VwMKP7f3mH52YzAgEs/fccqAquZS5hOPmsopNSN6ZwDbjuLaEOl2Zrmct
 ursMCFNtOk2TjUk1jC6tmcD0hcXQokgZUpjytcom/BPfb8DWY3gjG0/sHGsJsw0gm1ed
 Lwxq5vxbnoQ96rfZcHCfg6/LR7HZvV2MuMR+3fJ4kclwHoZuYkcX/YP58yBY9H5diw2o
 lshjktH6+Wd1Kgt2CFDsw0gtubMj3oxLDRQT/ccnZNoa917qPH/6Ld+qZmRJyWEUxkJn FQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33r5bnmx0u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Sep 2020 09:48:13 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08NDYESs173368;
        Wed, 23 Sep 2020 09:48:13 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33r5bnmwyq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Sep 2020 09:48:12 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08NDgHBx029999;
        Wed, 23 Sep 2020 13:48:10 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 33payuay7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Sep 2020 13:48:10 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08NDm8VY12190132
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 13:48:08 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 500074C04A;
        Wed, 23 Sep 2020 13:48:08 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F227C4C046;
        Wed, 23 Sep 2020 13:48:07 +0000 (GMT)
Received: from marcibm.ibmuc.com (unknown [9.145.64.218])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Sep 2020 13:48:07 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     <kvm@vger.kernel.org>
Cc:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, linux-s390@vger.kernel.org
Subject: [PATCH kvm-unit-tests v2 1/4] common.bash: run `cmd` only if a test case was found
Date:   Wed, 23 Sep 2020 15:47:55 +0200
Message-Id: <20200923134758.19354-2-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200923134758.19354-1-mhartmay@linux.ibm.com>
References: <20200923134758.19354-1-mhartmay@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-23_09:2020-09-23,2020-09-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 lowpriorityscore=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 impostorscore=0 clxscore=1015 suspectscore=15
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230108
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's only useful to run `cmd` in `for_each_unittest` if a test case
was found. This change allows us to remove the guards from the
functions `run_task` and `mkstandalone`.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
---
 run_tests.sh            | 3 ---
 scripts/common.bash     | 8 ++++++--
 scripts/mkstandalone.sh | 4 ----
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/run_tests.sh b/run_tests.sh
index fc4b3c23d886..12b63954721d 100755
--- a/run_tests.sh
+++ b/run_tests.sh
@@ -133,9 +133,6 @@ RUNTIME_log_stdout () {
 function run_task()
 {
 	local testname="$1"
-	if [ -z "$testname" ]; then
-		return
-	fi
 
 	while (( $(jobs | wc -l) == $unittest_run_queues )); do
 		# wait for any background test to finish
diff --git a/scripts/common.bash b/scripts/common.bash
index 9a6ebbd7f287..96655c9ffd1f 100644
--- a/scripts/common.bash
+++ b/scripts/common.bash
@@ -17,7 +17,9 @@ function for_each_unittest()
 
 	while read -r -u $fd line; do
 		if [[ "$line" =~ ^\[(.*)\]$ ]]; then
-			"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+			if [ -n "${testname}" ]; then
+				"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+			fi
 			testname=${BASH_REMATCH[1]}
 			smp=1
 			kernel=""
@@ -45,6 +47,8 @@ function for_each_unittest()
 			timeout=${BASH_REMATCH[1]}
 		fi
 	done
-	"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+	if [ -n "${testname}" ]; then
+		"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+	fi
 	exec {fd}<&-
 }
diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
index 9d506cc95072..cefdec30cb33 100755
--- a/scripts/mkstandalone.sh
+++ b/scripts/mkstandalone.sh
@@ -83,10 +83,6 @@ function mkstandalone()
 {
 	local testname="$1"
 
-	if [ -z "$testname" ]; then
-		return
-	fi
-
 	if [ -n "$one_testname" ] && [ "$testname" != "$one_testname" ]; then
 		return
 	fi
-- 
2.25.4

