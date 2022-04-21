Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3235509D42
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 12:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387209AbiDUKQm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 06:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388192AbiDUKQc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 06:16:32 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B0B41080;
        Thu, 21 Apr 2022 03:13:35 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23L7TF4K030056;
        Thu, 21 Apr 2022 10:13:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=6kQVJE0ZSX45/9AVJGtYDJSalMqL616n0AzcHDa1EkI=;
 b=FGW3CzM5WF9FGa3ewfKo8WtqcJA0gLQ246/zhzaT50Mzq1+S4/AxKa1thioKdBJMvAO1
 tL2NnjsgMkGP7E0Y5xM/72WcHWQaqyW24MIo+euKlVzXIZ6IlBwCzOSG6gXG5IJY54U9
 pcppGUdkeKjCCnSgS5qmufpz4yhLC1+So24ni6CgZmoQHZNnsrpDsNt1Rv5pYRLAPnAo
 u4Y1fLfOC5dGcwHcxeJ6geBZW3Baj1EYiFM8wjdu3vJUnvH40Slt5Zp8SRiTzsGT+G9b
 iHpnjm3GA72hwaOOwC/LydkqVJ1xZC6JUHPxOBhoAw1JE4HCa2XXE+r23YoYWnHi2cEv /w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjdn4cwtc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 10:13:34 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23L9gmvS015455;
        Thu, 21 Apr 2022 10:13:34 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjdn4cwsv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 10:13:34 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23LADMEJ024255;
        Thu, 21 Apr 2022 10:13:32 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3ffne8qnau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 10:13:32 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23LA0dso29163790
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 10:00:39 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0D345AE045;
        Thu, 21 Apr 2022 10:13:29 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B618AE053;
        Thu, 21 Apr 2022 10:13:28 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Apr 2022 10:13:28 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 03/11] s390x: diag308: Only test subcode 2 under QEMU
Date:   Thu, 21 Apr 2022 10:11:22 +0000
Message-Id: <20220421101130.23107-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220421101130.23107-1-frankja@linux.ibm.com>
References: <20220421101130.23107-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FsZ9UMPHydHYYHSLTXIOPBjGMHZ7EuuM
X-Proofpoint-GUID: pqNv2NjQ_A_uYw9qPMNLZNMe8VwOldv0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 mlxlogscore=999 phishscore=0 lowpriorityscore=0
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210056
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Other hypervisors might implement it and therefore not send a
specification exception.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
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

