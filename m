Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0CCD509D3F
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 12:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388240AbiDUKQt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 06:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388214AbiDUKQc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 06:16:32 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEEC7B7CB;
        Thu, 21 Apr 2022 03:13:36 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23L9BR0s017587;
        Thu, 21 Apr 2022 10:13:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=oxUwuhd5i26ivx4MkHskH9Qdx2oH2sebwjv+Uq2yqz8=;
 b=ONvCRnOI9YmEwM7ctffRc8KvevDFHR9wMwadnc26Vt3ncewBNxkJ0v4gHxjuIJnV8ukp
 fI4vth36eocrPvCzUPphYOEa5eFL8z3d2bo72LqEdfRtCsCY8voSrlR4k0hrs5Gq6eL6
 hcE9xaBpZ5+CEKGTP+wyqG8aWl267EvcPQXOototOXUnvWietQW3WlBxhDmaj8YZ3/96
 Slj4yNs7dR1IyKZDMalTsGUMV7JywKfY0qOOTi1C92qmAzJtvwvCFyNN7Tzy8f1AvEDH
 QFO3uDyj/432Scy+36qquAZk4O6D/Z7UnHUwxhWUe7p3/IK0kg44alYHVO45ih4A8Sep QA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjm2hv30g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 10:13:36 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23L9RYJQ029106;
        Thu, 21 Apr 2022 10:13:35 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjm2hv2yt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 10:13:35 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23LA3vJL001680;
        Thu, 21 Apr 2022 10:13:33 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 3ffvt9dp3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 10:13:33 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23LADURZ41025844
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 10:13:30 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA06AAE051;
        Thu, 21 Apr 2022 10:13:29 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3393EAE045;
        Thu, 21 Apr 2022 10:13:29 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Apr 2022 10:13:29 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 04/11] s390x: pfmf: Initialize pfmf_r1 union on declaration
Date:   Thu, 21 Apr 2022 10:11:23 +0000
Message-Id: <20220421101130.23107-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220421101130.23107-1-frankja@linux.ibm.com>
References: <20220421101130.23107-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XFyunxp8p_xbi6XQumzeQEZv3VNzjpVo
X-Proofpoint-ORIG-GUID: J5wMkrwLHZQu9qqtnFEsUh8_QZFu7or6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210056
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

