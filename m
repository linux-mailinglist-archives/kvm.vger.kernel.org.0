Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62FF313ADAA
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2020 16:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727331AbgANPbL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jan 2020 10:31:11 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46584 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726491AbgANPbL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Jan 2020 10:31:11 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00EFRlML098116
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2020 10:31:10 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xhfex2q5a-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2020 10:31:09 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Tue, 14 Jan 2020 15:31:07 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 14 Jan 2020 15:31:05 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00EFV4eP14286954
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jan 2020 15:31:04 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9EED511C05B;
        Tue, 14 Jan 2020 15:31:04 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 14B0511C054;
        Tue, 14 Jan 2020 15:31:03 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.165.115])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Jan 2020 15:31:02 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, david@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH 1/4] s390x: smp: Cleanup smp.c
Date:   Tue, 14 Jan 2020 10:30:50 -0500
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200114153054.77082-1-frankja@linux.ibm.com>
References: <20200114153054.77082-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20011415-4275-0000-0000-000003977E09
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20011415-4276-0000-0000-000038AB776B
Message-Id: <20200114153054.77082-2-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-14_04:2020-01-14,2020-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 mlxlogscore=951 clxscore=1015
 suspectscore=1 malwarescore=0 mlxscore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-2001140133
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's remove a lot of badly formatted code by introducing the
wait_for_flag() function.

Also let's remove some stray spaces.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/smp.c | 41 +++++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff --git a/s390x/smp.c b/s390x/smp.c
index ab7e46c..4dee43e 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -22,6 +22,13 @@
 
 static int testflag = 0;
 
+static void wait_for_flag(void)
+{
+	while (!testflag) {
+		mb();
+	}
+}
+
 static void cpu_loop(void)
 {
 	for (;;) {}
@@ -37,13 +44,11 @@ static void test_func(void)
 static void test_start(void)
 {
 	struct psw psw;
-	psw.mask =  extract_psw_mask();
+	psw.mask = extract_psw_mask();
 	psw.addr = (unsigned long)test_func;
 
 	smp_cpu_setup(1, psw);
-	while (!testflag) {
-		mb();
-	}
+	wait_for_flag();
 	report(1, "start");
 }
 
@@ -115,24 +120,24 @@ static void ecall(void)
 	testflag = 1;
 	while (lc->ext_int_code != 0x1202) { mb(); }
 	report(1, "ecall");
-	testflag= 1;
+	testflag = 1;
 }
 
 static void test_ecall(void)
 {
 	struct psw psw;
-	psw.mask =  extract_psw_mask();
+	psw.mask = extract_psw_mask();
 	psw.addr = (unsigned long)ecall;
 
 	report_prefix_push("ecall");
-	testflag= 0;
+	testflag = 0;
 	smp_cpu_destroy(1);
 
 	smp_cpu_setup(1, psw);
-	while (!testflag) { mb(); }
-	testflag= 0;
+	wait_for_flag();
+	testflag = 0;
 	sigp(1, SIGP_EXTERNAL_CALL, 0, NULL);
-	while(!testflag) {mb();}
+	wait_for_flag();
 	smp_cpu_stop(1);
 	report_prefix_pop();
 }
@@ -147,7 +152,7 @@ static void emcall(void)
 	mask = extract_psw_mask();
 	mask |= PSW_MASK_EXT;
 	load_psw_mask(mask);
-	testflag= 1;
+	testflag = 1;
 	while (lc->ext_int_code != 0x1201) { mb(); }
 	report(1, "ecall");
 	testflag = 1;
@@ -156,18 +161,18 @@ static void emcall(void)
 static void test_emcall(void)
 {
 	struct psw psw;
-	psw.mask =  extract_psw_mask();
+	psw.mask = extract_psw_mask();
 	psw.addr = (unsigned long)emcall;
 
 	report_prefix_push("emcall");
-	testflag= 0;
+	testflag = 0;
 	smp_cpu_destroy(1);
 
 	smp_cpu_setup(1, psw);
-	while (!testflag) { mb(); }
-	testflag= 0;
+	wait_for_flag();
+	testflag = 0;
 	sigp(1, SIGP_EMERGENCY_SIGNAL, 0, NULL);
-	while(!testflag) { mb(); }
+	wait_for_flag();
 	smp_cpu_stop(1);
 	report_prefix_pop();
 }
@@ -177,7 +182,7 @@ static void test_reset_initial(void)
 	struct cpu_status *status = alloc_pages(0);
 	struct psw psw;
 
-	psw.mask =  extract_psw_mask();
+	psw.mask = extract_psw_mask();
 	psw.addr = (unsigned long)test_func;
 
 	report_prefix_push("reset initial");
@@ -208,7 +213,7 @@ static void test_reset(void)
 {
 	struct psw psw;
 
-	psw.mask =  extract_psw_mask();
+	psw.mask = extract_psw_mask();
 	psw.addr = (unsigned long)test_func;
 
 	report_prefix_push("cpu reset");
-- 
2.20.1

