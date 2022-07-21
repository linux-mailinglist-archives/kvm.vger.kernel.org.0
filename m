Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53D8C57CBEE
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 15:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbiGUNaR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 09:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiGUNaO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 09:30:14 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 858CBA1B4;
        Thu, 21 Jul 2022 06:30:11 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LDE00J002130;
        Thu, 21 Jul 2022 13:30:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=aD5BAjGIo2kKwPAmxR3930VP2lTHyak0DsahWHGs7Q0=;
 b=LAEaTIWTONcWDI1ML4Hbahm3ZJ61y8Z/Qtxmom+eqAqphwYq1iBin3trfHye2b7bLrq8
 1p0HfVgrgb2EwaFXqxdadbRcClBShAOy2vletwQ2uDQSsVzpPcG/Nu3rf6lg4J5/BG4c
 AWuJ7G+2du7A/Y/AkoGlhb0dNJKjpxrlUInbL8aFGoGRGCvaN2h5fBURPH3HO/8SOfsC
 B75B7SE6ZA50rX0FHwiibn4H9uAaE4mtMFDErNoqelWaJpb3qF+TuzE5WxYtUikDRijr
 GeHtQX9EqBxYj9yUAGgXpWWU3tsyiXHxsUUaky4A2G8YH1mAnaCEmhXvNEIRXdo5wz++ Bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf74q9h1e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 13:30:08 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LDE0Ro002189;
        Thu, 21 Jul 2022 13:30:07 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf74q9h09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 13:30:07 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LDOlB2020255;
        Thu, 21 Jul 2022 13:30:05 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3hbmy8xypc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 13:30:05 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LDU3lr20840940
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 13:30:03 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 67CDE42047;
        Thu, 21 Jul 2022 13:30:03 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1D8F242041;
        Thu, 21 Jul 2022 13:30:03 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.4.232])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 13:30:03 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        qemu-s390x@nongnu.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com
Subject: [PATCH v2 1/2] s390x: intercept: fence one test when using TCG
Date:   Thu, 21 Jul 2022 15:30:01 +0200
Message-Id: <20220721133002.142897-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721133002.142897-1-imbrenda@linux.ibm.com>
References: <20220721133002.142897-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Lpv5Dvk3-IXVxAsStvlLBiIoOVA_85uX
X-Proofpoint-ORIG-GUID: 362NphtGP7zf_q3hF-x8SKSYFiSfTfGU
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_16,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 mlxscore=0 priorityscore=1501
 bulkscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207210053
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Qemu commit f8333de2793 ("target/s390x/tcg: SPX: check validity of new prefix")
fixes a TCG bug discovered with a new testcase in the intercept test.

The gitlab pipeline for the KVM unit tests uses TCG and it will keep
failing every time as long as the pipeline uses a version of Qemu
without the aforementioned patch.

Fence the specific testcase for now. Once the pipeline is fixed, this
patch can safely be reverted.

This patch is meant to go on top this already queued patch from Janis:
"s390x/intercept: Test invalid prefix argument to SET PREFIX"
https://lore.kernel.org/all/20220627152412.2243255-1-scgl@linux.ibm.com/

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/intercept.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/s390x/intercept.c b/s390x/intercept.c
index 54bed5a4..656b8adb 100644
--- a/s390x/intercept.c
+++ b/s390x/intercept.c
@@ -14,6 +14,7 @@
 #include <asm/page.h>
 #include <asm/facility.h>
 #include <asm/time.h>
+#include <hardware.h>
 
 static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));
 
@@ -76,7 +77,8 @@ static void test_spx(void)
 	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
 
 	new_prefix = get_ram_size() & 0x7fffe000;
-	if (get_ram_size() - new_prefix < 2 * PAGE_SIZE) {
+	/* TODO: Remove host_is_tcg() checks once CIs are using QEMU >= 7.1 */
+	if (!host_is_tcg() && (get_ram_size() - new_prefix < 2 * PAGE_SIZE)) {
 		expect_pgm_int();
 		asm volatile("spx	%0 " : : "Q"(new_prefix));
 		check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
@@ -88,7 +90,10 @@ static void test_spx(void)
 		 * the address to 8k we have a completely accessible area.
 		 */
 	} else {
-		report_skip("inaccessible prefix area");
+		if (host_is_tcg())
+			report_skip("inaccessible prefix area (workaround for TCG bug)");
+		else
+			report_skip("inaccessible prefix area");
 	}
 }
 
-- 
2.36.1

