Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4136657C969
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 12:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbiGUK4y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 06:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232345AbiGUK4w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 06:56:52 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3A051A3F;
        Thu, 21 Jul 2022 03:56:51 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LACHEG009611;
        Thu, 21 Jul 2022 10:56:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=/1yHICIKGD+aOsm2oJeJSUP/DWPTALOHpl5ubCHD75A=;
 b=DsFHyuoXEMM3CPo3HtJITE4pL+vrE3exMblA9aCd1NlRXfOFKKE8g0bFTibqDKW73+N7
 m4I0me7Mr2irwt0+twILWzZzdQZ4ho1uxKnYjbw05tVMm94K27sdigvsKqVzi8p0VKRJ
 81GrLv7jByXNjBZoSD5qyaIhKt0uxIvrVP7qJNpXRpFl3Br4A310p4oaRhasfQz/O8fa
 4mZU+RLaOgThT6n9o4drNSC2+syk8lzBRPkod1j1Yj7u33Cd1WWV8ugEEwEXHOd9Z4Yt
 9Hsi/6ucMB+BblYrjWnrwpPCdICeZaBCu2FMPpN621Qc/bhUSnzKni2000b/mOgXGMFi 7w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf4jv19eg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 10:56:47 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LAaoK1006705;
        Thu, 21 Jul 2022 10:56:46 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf4jv19dy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 10:56:46 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LApbhi013343;
        Thu, 21 Jul 2022 10:56:44 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3hbmy8w67k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 10:56:44 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LAugZI23527820
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 10:56:42 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B250AE04D;
        Thu, 21 Jul 2022 10:56:42 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 08A4FAE053;
        Thu, 21 Jul 2022 10:56:42 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.4.232])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 10:56:41 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        qemu-s390x@nongnu.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com
Subject: [PATCH] s390x: intercept: fence one test when using TCG
Date:   Thu, 21 Jul 2022 12:56:41 +0200
Message-Id: <20220721105641.131710-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 30Zp4SWCc8S5SnrOk8TQb3MILBtXunhw
X-Proofpoint-ORIG-GUID: JwRSAczY7ODC902BYwosKCZ3_Or96J4M
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_14,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 clxscore=1011 mlxlogscore=999 phishscore=0 adultscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207210041
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

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/intercept.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/s390x/intercept.c b/s390x/intercept.c
index 54bed5a4..c48818c2 100644
--- a/s390x/intercept.c
+++ b/s390x/intercept.c
@@ -14,6 +14,7 @@
 #include <asm/page.h>
 #include <asm/facility.h>
 #include <asm/time.h>
+#include <hardware.h>
 
 static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));
 
@@ -76,7 +77,7 @@ static void test_spx(void)
 	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
 
 	new_prefix = get_ram_size() & 0x7fffe000;
-	if (get_ram_size() - new_prefix < 2 * PAGE_SIZE) {
+	if (!host_is_tcg() && (get_ram_size() - new_prefix < 2 * PAGE_SIZE)) {
 		expect_pgm_int();
 		asm volatile("spx	%0 " : : "Q"(new_prefix));
 		check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
-- 
2.36.1

