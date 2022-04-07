Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3AC24F7A14
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 10:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243272AbiDGIqt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 04:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243251AbiDGIql (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 04:46:41 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC73018425B;
        Thu,  7 Apr 2022 01:44:39 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2376LSit014311;
        Thu, 7 Apr 2022 08:44:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=oxUwuhd5i26ivx4MkHskH9Qdx2oH2sebwjv+Uq2yqz8=;
 b=AVfpVaGDsbq9h3F3ZliEtImpr5Fqc98tnLMOq+3GZ6cLiiqvXGRPPLfdpVM93j8XHcI3
 U/a6qE4KHtvuyIlnLJ7k3gThQaVMVzHjM0OpJDuC4J/LiaK1j5Ksk67TMbBV2mtGNT5k
 n74JHiAG2NCP2IPaiUJqb7PBEPgo5VoCgB/8/bzydRC1+RX5C0exv9zqAISW4PqrogDa
 1CnZZBLyDiP6Lx7i4gculo3ueIG+RPEH/kF1Xx3MP5gJKNY6gx37UtPDfu1bnNnfbBR3
 jWnryyssRq4bZdd62+P9sA4Zyvgc/jZbv50faA1r4UDlCYH8dgt7SgFBzvJH+j7Kbepd Fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f9tm4tpk2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 08:44:38 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2378YPgP013101;
        Thu, 7 Apr 2022 08:44:38 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f9tm4tpjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 08:44:38 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2378X85d001056;
        Thu, 7 Apr 2022 08:44:36 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3f6e491efy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 08:44:36 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2378iX8E43516200
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Apr 2022 08:44:33 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F29ADAE051;
        Thu,  7 Apr 2022 08:44:32 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D367AE053;
        Thu,  7 Apr 2022 08:44:32 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Apr 2022 08:44:32 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 4/9] s390x: pfmf: Initialize pfmf_r1 union on declaration
Date:   Thu,  7 Apr 2022 08:44:16 +0000
Message-Id: <20220407084421.2811-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220407084421.2811-1-frankja@linux.ibm.com>
References: <20220407084421.2811-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oWAKHVDH6SLP5h3B-nMq8MIhq0LFdjLN
X-Proofpoint-ORIG-GUID: bKXTxJR9YSzfHWWI-jFqFy2qsNxEXdOz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-06_13,2022-04-06_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070043
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's make this test look a bit nicer.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 s390x/pfmf.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/s390x/pfmf.c b/s390x/pfmf.c
index aa130529..178abb5a 100644
--- a/s390x/pfmf.c
+++ b/s390x/pfmf.c
@@ -28,7 +28,11 @@ static void test_priv(void)
 
 static void test_4k_key(void)
 {
-	union pfmf_r1 r1;
+	union pfmf_r1 r1 = {
+		.reg.sk = 1,
+		.reg.fsc = PFMF_FSC_4K,
+		.reg.key = 0x30,
+	};
 	union skey skey;
 
 	report_prefix_push("4K");
@@ -36,10 +40,6 @@ static void test_4k_key(void)
 		report_skip("storage key removal facility is active");
 		goto out;
 	}
-	r1.val = 0;
-	r1.reg.sk = 1;
-	r1.reg.fsc = PFMF_FSC_4K;
-	r1.reg.key = 0x30;
 	pfmf(r1.val, pagebuf);
 	skey.val = get_storage_key(pagebuf);
 	skey.val &= SKEY_ACC | SKEY_FP;
@@ -52,18 +52,19 @@ static void test_1m_key(void)
 {
 	int i;
 	bool rp = true;
-	union pfmf_r1 r1;
 	union skey skey;
+	union pfmf_r1 r1 = {
+		.reg.fsc = PFMF_FSC_1M,
+		.reg.key = 0x30,
+		.reg.sk = 1,
+	};
 
 	report_prefix_push("1M");
 	if (test_facility(169)) {
 		report_skip("storage key removal facility is active");
 		goto out;
 	}
-	r1.val = 0;
-	r1.reg.sk = 1;
-	r1.reg.fsc = PFMF_FSC_1M;
-	r1.reg.key = 0x30;
+
 	pfmf(r1.val, pagebuf);
 	for (i = 0; i < 256; i++) {
 		skey.val = get_storage_key(pagebuf + i * PAGE_SIZE);
@@ -80,11 +81,10 @@ out:
 
 static void test_4k_clear(void)
 {
-	union pfmf_r1 r1;
-
-	r1.val = 0;
-	r1.reg.cf = 1;
-	r1.reg.fsc = PFMF_FSC_4K;
+	union pfmf_r1 r1 = {
+		.reg.cf = 1,
+		.reg.fsc = PFMF_FSC_4K,
+	};
 
 	report_prefix_push("4K");
 	memset(pagebuf, 42, PAGE_SIZE);
@@ -97,13 +97,12 @@ static void test_4k_clear(void)
 static void test_1m_clear(void)
 {
 	int i;
-	union pfmf_r1 r1;
+	union pfmf_r1 r1 = {
+		.reg.cf = 1,
+		.reg.fsc = PFMF_FSC_1M,
+	};
 	unsigned long sum = 0;
 
-	r1.val = 0;
-	r1.reg.cf = 1;
-	r1.reg.fsc = PFMF_FSC_1M;
-
 	report_prefix_push("1M");
 	memset(pagebuf, 42, PAGE_SIZE * 256);
 	pfmf(r1.val, pagebuf);
-- 
2.32.0

