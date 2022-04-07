Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE1574F7FF6
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 15:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343500AbiDGNFq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 09:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343625AbiDGNF3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 09:05:29 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF56325C585;
        Thu,  7 Apr 2022 06:03:08 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 237COl6q022903;
        Thu, 7 Apr 2022 13:03:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=50XPBYIJIPMdXdNe5V2X8VtGX8E1k9sdipBI7RjpoRc=;
 b=fVEAa+12KgPOiG+R2654kxm00JNsjcqhGF8lLNjom5+m6EVW1aVHLBBbzaLGMiqxbXci
 JAPyQJ+qCS6xMbmIGMA7Lmy+a3l07E+4eVpPLwEtO6WkxYrjHewum3ls3WI3L/RD37a+
 Beep+MsRJ5IAfPdOSnfOB7ONp+7rq87zYT8brFynE8JXDNOp6r7asBUZQoAQNBnqDelE
 f6CVfDpnvIopaoqvQ4tFbhpVAzJvRviBUwjg84k/2F/4LPX1Nb4hN3/fYv2YVkCbV7b0
 V8OsblANjwzL3qLMw4DZPiERSEtfGqXUVeLgQ2If0P8iv5rdy/Q7cS+9DswsRxDwR/9v Kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f8ya1ygyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 13:03:07 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 237D1xfF015188;
        Thu, 7 Apr 2022 13:03:07 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f8ya1ygxd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 13:03:07 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 237CvdM6020442;
        Thu, 7 Apr 2022 13:03:04 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3f6e491x7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 13:03:03 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 237D30Qt41681154
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Apr 2022 13:03:00 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0685811C04A;
        Thu,  7 Apr 2022 13:03:00 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3CC1411C058;
        Thu,  7 Apr 2022 13:02:59 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Apr 2022 13:02:59 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3] s390x: diag308: Only test subcode 2 under QEMU
Date:   Thu,  7 Apr 2022 13:02:52 +0000
Message-Id: <20220407130252.15603-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220407114253.5cb6f2aa@p-imbrenda>
References: <20220407114253.5cb6f2aa@p-imbrenda>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6dC-3WwOLcHNL1H879tZm3BAAw9NqNCs
X-Proofpoint-ORIG-GUID: XwXfno73Hb6mKlDmiR_JzkaHeHJc9q3N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-07_01,2022-04-07_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 suspectscore=0 bulkscore=0
 phishscore=0 clxscore=1015 impostorscore=0 spamscore=0 mlxscore=0
 mlxlogscore=970 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Other hypervisors might implement it and therefore not send a
specification exception.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/diag308.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/s390x/diag308.c b/s390x/diag308.c
index c9d6c499..ea41b455 100644
--- a/s390x/diag308.c
+++ b/s390x/diag308.c
@@ -8,6 +8,7 @@
 #include <libcflat.h>
 #include <asm/asm-offsets.h>
 #include <asm/interrupt.h>
+#include <hardware.h>
 
 /* The diagnose calls should be blocked in problem state */
 static void test_priv(void)
@@ -75,7 +76,7 @@ static void test_subcode6(void)
 /* Unsupported subcodes should generate a specification exception */
 static void test_unsupported_subcode(void)
 {
-	int subcodes[] = { 2, 0x101, 0xffff, 0x10001, -1 };
+	int subcodes[] = { 0x101, 0xffff, 0x10001, -1 };
 	int idx;
 
 	for (idx = 0; idx < ARRAY_SIZE(subcodes); idx++) {
@@ -85,6 +86,21 @@ static void test_unsupported_subcode(void)
 		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
 		report_prefix_pop();
 	}
+
+	/*
+	 * Subcode 2 is not available under QEMU but might be on other
+	 * hypervisors so we only check for the specification
+	 * exception on QEMU.
+	 */
+	report_prefix_pushf("0x%04x", 2);
+	if (host_is_qemu()) {
+		expect_pgm_int();
+		asm volatile ("diag %0,%1,0x308" :: "d"(0), "d"(2));
+		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	} else {
+		report_skip("subcode is supported");
+	}
+	report_prefix_pop();
 }
 
 static struct {
-- 
2.32.0

