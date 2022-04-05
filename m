Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB1494F26CF
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 10:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232898AbiDEIEj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 04:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235574AbiDEH7v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 03:59:51 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86DCC40E7F;
        Tue,  5 Apr 2022 00:55:45 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23575vm0029363;
        Tue, 5 Apr 2022 07:55:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Dr6VjIBhLnIVd9CMktJ8F3AQ+OqLtvGZqtc7TJQcmS0=;
 b=amLmgD5GvgysAEOWJ/40KONA1FlLHAPByQrf2EjiQIcNVkPTjz11JCyx4ENzXCqgtfAh
 U00JxMHN0EF9BpUKTW8G33lY+T42CikV8B9enHzeUJJg7NQFPLIxE0m+OeSDDAlRg9NN
 CEkvtl+vWTdWJTJLUjNecnjmU4DjbF1Ons1Xoxe9cYXnmCO6ILxUYF5djeBszFDE8WwS
 0CW87Vco1V8CBADz9R0ZqapyibNgpJdlbtOXMOxMAkFFwuctRaZogD7jbnicgBALYqsw
 LUVEhdhxNFYP0nWIW94NErnekyKnpIM3pM5Pb5P2otZ5pLPD0gVrN8y9UBKno9BAzmWb yQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f86pjx6by-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 07:55:45 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2357eaFq016087;
        Tue, 5 Apr 2022 07:55:44 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f86pjx6bc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 07:55:44 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2357gtJB000922;
        Tue, 5 Apr 2022 07:55:42 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3f6e48w71a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 07:55:42 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2357tdt140501596
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Apr 2022 07:55:39 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32A084203F;
        Tue,  5 Apr 2022 07:55:39 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 706E642042;
        Tue,  5 Apr 2022 07:55:38 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Apr 2022 07:55:38 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com
Subject: [kvm-unit-tests PATCH 2/8] s390x: diag308: Only test subcode 2 under QEMU
Date:   Tue,  5 Apr 2022 07:52:19 +0000
Message-Id: <20220405075225.15903-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220405075225.15903-1-frankja@linux.ibm.com>
References: <20220405075225.15903-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0IEmy27L4gH32vi0KAUDI69b3kHvZ2_C
X-Proofpoint-ORIG-GUID: 0NAK4XcMYecPfB_hqs0MKoPzA7lFU5hR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-04_09,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 bulkscore=0 lowpriorityscore=0
 mlxlogscore=821 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204050044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
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
 s390x/diag308.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/s390x/diag308.c b/s390x/diag308.c
index c9d6c499..9614f9a9 100644
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
@@ -85,6 +86,18 @@ static void test_unsupported_subcode(void)
 		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
 		report_prefix_pop();
 	}
+
+	/*
+	 * Subcode 2 is not available under QEMU but might be on other
+	 * hypervisors.
+	 */
+	if (detect_host() != HOST_IS_TCG && detect_host() != HOST_IS_KVM) {
+		report_prefix_pushf("0x%04x", 2);
+		expect_pgm_int();
+		asm volatile ("diag %0,%1,0x308" :: "d"(0), "d"(2));
+		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+		report_prefix_pop();
+	}
 }
 
 static struct {
-- 
2.32.0

