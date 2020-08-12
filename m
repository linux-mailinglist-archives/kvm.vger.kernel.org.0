Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B92F242792
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 11:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbgHLJ1Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Aug 2020 05:27:25 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:26044 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727771AbgHLJ1V (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Aug 2020 05:27:21 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07C94Q3o140995;
        Wed, 12 Aug 2020 05:27:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=CwGt+RGQN2Ly6SujhwnS+lukDsTIh0VYLUDOwGoQr90=;
 b=K/NBkjSh0K4N7+cxqZgP2NhY/lk7AJfE0P6A/38Ir1tefXMM0Cd4aTxUw8gGkBiiDybw
 Iks1W4UfeFEboHA+VecITVeppyLqq5F+8C/ghIsIZw1tWBdmzUHuBaULpjLmbBhzTJww
 tjUA7/dgBPVaXK3IFTLd9Kdwrv0CFbvWGoBWiSBpoefRptTY4kNMdWJOXWs4bi0QXMG1
 nXbHFjBFilaZjL8I0yZSqLp8lnDMmEVsmXqApdLEnpSMx+3soj2F8KmPClmV7BpelrO7
 dLlhf+FoKwK0mJucevn0Hd0qI6pHP4VvmURoFJeggtYp8b5sFDqbqP27r5hnyqu6s0Tr Bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32vbcycdsd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Aug 2020 05:27:20 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07C94bUU141866;
        Wed, 12 Aug 2020 05:27:19 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32vbcycdrq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Aug 2020 05:27:19 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07C9KnQX016717;
        Wed, 12 Aug 2020 09:27:18 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 32skp8c8bp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Aug 2020 09:27:18 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07C9RFqT28180860
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Aug 2020 09:27:15 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1CD0452052;
        Wed, 12 Aug 2020 09:27:15 +0000 (GMT)
Received: from marcibm.ibmuc.com (unknown [9.145.75.196])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A6EC552057;
        Wed, 12 Aug 2020 09:27:14 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     <kvm@vger.kernel.org>
Cc:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests RFC v2 3/4] run_tests/mkstandalone: add arch dependent function to `for_each_unittest`
Date:   Wed, 12 Aug 2020 11:27:04 +0200
Message-Id: <20200812092705.17774-4-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200812092705.17774-1-mhartmay@linux.ibm.com>
References: <20200812092705.17774-1-mhartmay@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-12_02:2020-08-11,2020-08-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=1
 adultscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 impostorscore=0
 mlxlogscore=879 clxscore=1015 mlxscore=0 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008120064
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This allows us, for example, to auto generate a new test case based on
an existing test case.

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
---
 run_tests.sh            |  2 +-
 scripts/common.bash     | 13 +++++++++++++
 scripts/mkstandalone.sh |  2 +-
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/run_tests.sh b/run_tests.sh
index 24aba9cc3a98..23658392c488 100755
--- a/run_tests.sh
+++ b/run_tests.sh
@@ -160,7 +160,7 @@ trap "wait; exit 130" SIGINT
    # preserve stdout so that process_test_output output can write TAP to it
    exec 3>&1
    test "$tap_output" == "yes" && exec > /dev/null
-   for_each_unittest $config run_task
+   for_each_unittest $config run_task arch_cmd
 ) | postprocess_suite_output
 
 # wait until all tasks finish
diff --git a/scripts/common.bash b/scripts/common.bash
index f9c15fd304bd..62931a40b79a 100644
--- a/scripts/common.bash
+++ b/scripts/common.bash
@@ -1,8 +1,15 @@
+function arch_cmd()
+{
+	# Dummy function, can be overwritten by architecture dependent
+	# code
+	return
+}
 
 function for_each_unittest()
 {
 	local unittests="$1"
 	local cmd="$2"
+	local arch_cmd="${3-}"
 	local testname
 	local smp
 	local kernel
@@ -19,6 +26,9 @@ function for_each_unittest()
 		if [[ "$line" =~ ^\[(.*)\]$ ]]; then
 			if [ -n "${testname}" ]; then
 				"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+				if [ "${arch_cmd}" ]; then
+					"${arch_cmd}" "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+				fi
 			fi
 			testname=${BASH_REMATCH[1]}
 			smp=1
@@ -49,6 +59,9 @@ function for_each_unittest()
 	done
 	if [ -n "${testname}" ]; then
 		"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+		if [ "${arch_cmd}" ]; then
+			"${arch_cmd}" "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+		fi
 	fi
 	exec {fd}<&-
 }
diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
index cefdec30cb33..3b18c0cf090b 100755
--- a/scripts/mkstandalone.sh
+++ b/scripts/mkstandalone.sh
@@ -128,4 +128,4 @@ fi
 
 mkdir -p tests
 
-for_each_unittest $cfg mkstandalone
+for_each_unittest $cfg mkstandalone arch_cmd
-- 
2.25.4

