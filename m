Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31162338D64
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 13:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbhCLMrb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 07:47:31 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:16258 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229900AbhCLMrH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Mar 2021 07:47:07 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12CCYFjf019596
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 07:47:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=fuFxI0zE17AgK4O8TVsv8+frJRvi6NDBOTC0fETYWtc=;
 b=GpIp7LLIr2yir5PF74yeUwgzeMbbxZ2l17mqcpgbXRucAEKGhGvphicz88JJ7THh5YhR
 YTkGaYOLz4EiAUy38nXUjzhozKMwsINYm7HTjgg261oLBuN77iZ8lr8hvg4uVG94hPtU
 MqnG/69rEsyhmRPEnyHYGbIBfKfp5adauDr7/Jr6YVB0wTA8pf0+csbb2csFPOB6lXof
 UXo3KwFZN8I/Dz/yKwONPrpF+rwgXyCrpNPvPo4ikyR2WEEBkSN8UYDJr45nhXgqZCGp
 jTYtdaLR75EwOdE05+lV6CRdlQbKE1iJ8IFCffSLv3Ols+1BNs/qwM0z7JZlVRYG/8yF Mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3774m3xud6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 07:47:07 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12CCZcjH024820
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 07:47:07 -0500
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3774m3xuca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Mar 2021 07:47:06 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12CCgVOf020062;
        Fri, 12 Mar 2021 12:47:04 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 376agr1fmw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Mar 2021 12:47:04 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12CCl1Gu36766182
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Mar 2021 12:47:01 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79E83A405F;
        Fri, 12 Mar 2021 12:47:01 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 289E4A4066;
        Fri, 12 Mar 2021 12:47:01 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.13.246])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 12 Mar 2021 12:47:01 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, frankja@linux.ibm.com,
        cohuck@redhat.com, pmorel@linux.ibm.com
Subject: [kvm-unit-tests PATCH v1 1/1] s390x: mvpg: add checks for op_acc_id
Date:   Fri, 12 Mar 2021 13:47:00 +0100
Message-Id: <20210312124700.142269-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-12_03:2021-03-10,2021-03-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 impostorscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 clxscore=1015 suspectscore=0 phishscore=0 adultscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103120088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check the operand access identification when MVPG causes a page fault.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/mvpg.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/s390x/mvpg.c b/s390x/mvpg.c
index 5743d5b6..2b7c6cc9 100644
--- a/s390x/mvpg.c
+++ b/s390x/mvpg.c
@@ -36,6 +36,7 @@
 
 static uint8_t source[PAGE_SIZE]  __attribute__((aligned(PAGE_SIZE)));
 static uint8_t buffer[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
+static struct lowcore * const lc;
 
 /* Keep track of fresh memory */
 static uint8_t *fresh;
@@ -77,6 +78,21 @@ static int page_ok(const uint8_t *p)
 	return 1;
 }
 
+/*
+ * Check that the Operand Access Identification matches with the values of
+ * the r1 and r2 fields in the instruction format. The r1 and r2 fields are
+ * in the last byte of the instruction, and the Program Old PSW will point
+ * to the beginning of the instruction after the one that caused the fault
+ * (the fixup code in the interrupt handler takes care of that for
+ * nullifying instructions). Therefore it is enough to compare the byte
+ * before the one contained in the Program Old PSW with the value of the
+ * Operand Access Identification.
+ */
+static inline bool check_oai(void)
+{
+	return *(uint8_t *)(lc->pgm_old_psw.addr - 1) == lc->op_acc_id;
+}
+
 static void test_exceptions(void)
 {
 	int i, expected;
@@ -201,17 +217,25 @@ static void test_mmu_prot(void)
 	report(clear_pgm_int() == PGM_INT_CODE_PROTECTION, "destination read only");
 	fresh += PAGE_SIZE;
 
+	report_prefix_push("source invalid");
 	protect_page(source, PAGE_ENTRY_I);
+	lc->op_acc_id = 0;
 	expect_pgm_int();
 	mvpg(0, fresh, source);
-	report(clear_pgm_int() == PGM_INT_CODE_PAGE_TRANSLATION, "source invalid");
+	report(clear_pgm_int() == PGM_INT_CODE_PAGE_TRANSLATION, "exception");
 	unprotect_page(source, PAGE_ENTRY_I);
+	report(check_oai(), "operand access ident");
+	report_prefix_pop();
 	fresh += PAGE_SIZE;
 
+	report_prefix_push("destination invalid");
 	protect_page(fresh, PAGE_ENTRY_I);
+	lc->op_acc_id = 0;
 	expect_pgm_int();
 	mvpg(0, fresh, source);
-	report(clear_pgm_int() == PGM_INT_CODE_PAGE_TRANSLATION, "destination invalid");
+	report(clear_pgm_int() == PGM_INT_CODE_PAGE_TRANSLATION, "exception");
+	report(check_oai(), "operand access ident");
+	report_prefix_pop();
 	fresh += PAGE_SIZE;
 
 	report_prefix_pop();
-- 
2.26.2

