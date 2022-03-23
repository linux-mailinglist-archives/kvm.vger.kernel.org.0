Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B06C4E5719
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 18:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245657AbiCWRFN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 13:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245624AbiCWRFG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 13:05:06 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCE94ECD7;
        Wed, 23 Mar 2022 10:03:35 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22NGt2T1016744;
        Wed, 23 Mar 2022 17:03:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=b9rgkHJbHKZ27YCfeW4MQUexcpse6aSh3Py6GAPryYk=;
 b=QQfO2pOFQzEgDqHIkVle2ZEQ8f6MFCy9Y0y1+r8+aSUW9Z/pLil33LgqDXsn2q7688OG
 MTaD9PpBFFWZKGNl/SS4mF3nwfpN6wjBrslCVktnTId3qXxZb8EF+eMEFpkT8noEjEqx
 Txie2b8duXhb2acGnHfutJN6PS9r5iLu2P64bVLaRN13/XvOmlBZHieRrey/K7uGYThu
 Qv7RO3hAjg4ak40MvaAOc/693qCJbAJeD6sc2OsCLorusvkX4lYe42cNrNVQTldCI4e9
 FzPEQrdusStHYMtOPMLB3o6DoWiACX7UqWe27tQXzjK2LWGK0vtQ7OaRfu+vosxUC0ff 5Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f07g7r5xb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 17:03:35 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22NGsvOt015637;
        Wed, 23 Mar 2022 17:03:34 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f07g7r5wu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 17:03:34 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22NGxGTq012253;
        Wed, 23 Mar 2022 17:03:32 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3ew6t8qrey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 17:03:32 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22NH3WfQ37093818
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Mar 2022 17:03:32 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D462F4C046;
        Wed, 23 Mar 2022 17:03:28 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8ECC44C04E;
        Wed, 23 Mar 2022 17:03:28 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Mar 2022 17:03:28 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, farman@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 9/9] s390x: stsi: check zero and ignored bits in r0 and r1
Date:   Wed, 23 Mar 2022 18:03:25 +0100
Message-Id: <20220323170325.220848-10-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220323170325.220848-1-nrb@linux.ibm.com>
References: <20220323170325.220848-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: O_U4xfgruwTm_yUaebkfJ01kU09goG9B
X-Proofpoint-ORIG-GUID: cLLVVKFsqDXSc_Y9PzB4HBR91CvvqqH4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-23_07,2022-03-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501
 clxscore=1015 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2203230091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We previously only checked for two zero bits, one in r0 and one in r1.
Let's check all the bits which must be zero and which are ignored
to extend the coverage.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/stsi.c | 42 ++++++++++++++++++++++++++++++++----------
 1 file changed, 32 insertions(+), 10 deletions(-)

diff --git a/s390x/stsi.c b/s390x/stsi.c
index dccc53e7a816..94a579dc3b58 100644
--- a/s390x/stsi.c
+++ b/s390x/stsi.c
@@ -9,6 +9,7 @@
  */
 
 #include <libcflat.h>
+#include <bitops.h>
 #include <asm/page.h>
 #include <asm/asm-offsets.h>
 #include <asm/interrupt.h>
@@ -19,19 +20,40 @@ static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));
 
 static void test_specs(void)
 {
+	int i;
+	int cc;
+
 	report_prefix_push("specification");
 
-	report_prefix_push("inv r0");
-	expect_pgm_int();
-	stsi(pagebuf, 0, 1 << 8, 0);
-	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
-	report_prefix_pop();
+	for (i = 36; i <= 55; i++) {
+		report_prefix_pushf("set invalid r0 bit %d", i);
+		expect_pgm_int();
+		stsi(pagebuf, 0, BIT(63 - i), 0);
+		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+		report_prefix_pop();
+	}
 
-	report_prefix_push("inv r1");
-	expect_pgm_int();
-	stsi(pagebuf, 1, 0, 1 << 16);
-	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
-	report_prefix_pop();
+	for (i = 32; i <= 47; i++) {
+		report_prefix_pushf("set invalid r1 bit %d", i);
+		expect_pgm_int();
+		stsi(pagebuf, 1, 0, BIT(63 - i));
+		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+		report_prefix_pop();
+	}
+
+	for (i = 0; i < 32; i++) {
+		report_prefix_pushf("r0 bit %d ignored", i);
+		cc = stsi(pagebuf, 3, 2 | BIT(63 - i), 2);
+		report(!cc, "CC = 0");
+		report_prefix_pop();
+	}
+
+	for (i = 0; i < 32; i++) {
+		report_prefix_pushf("r1 bit %d ignored", i);
+		cc = stsi(pagebuf, 3, 2, 2 | BIT(63 - i));
+		report(!cc, "CC = 0");
+		report_prefix_pop();
+	}
 
 	report_prefix_push("unaligned");
 	expect_pgm_int();
-- 
2.31.1

