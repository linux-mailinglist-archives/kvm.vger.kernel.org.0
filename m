Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEE1D567ECB
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 08:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiGFGlZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 02:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbiGFGlW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 02:41:22 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03438193D0;
        Tue,  5 Jul 2022 23:41:22 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 266692KH031457;
        Wed, 6 Jul 2022 06:41:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=bXbSn5ZS2gOoNPdjDflbyAgbpc4DN25rTeOke7/uth8=;
 b=lTzg8IYb+atX2zgFNDhdo/OSU76P2FBN7zgl6uqQBDQHTrkuJhI4i8Ct5tbQoOfWSe/4
 pyQfC/mDEvvySLOWlejXiKHAiLXlncZrzueWiRd2nnV8dCNqyS8j9LysBbT0Gai9itzT
 uSspY9GeelAHBPl309q+IvyyS4wqFY/0lgJcO5OxUtmz5DGU3QOW5pk4thNSqeibbsXm
 H9BA4KOEL0B4TvLpJ2200YBki/rQEAb9ZiT38TL+PXKxDItBRY1yssFMHmOH9wUIe6WY
 q1LnXicXb+Kl8nycl//0ust1QoGuwyQLMy2HlwikaOa3k64wz1NcVJVuR7quRkQmpZw3 Gg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h52bj3wf1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 06:41:21 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2666T684019033;
        Wed, 6 Jul 2022 06:41:21 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h52bj3wej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 06:41:21 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2666KCxB029748;
        Wed, 6 Jul 2022 06:41:18 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3h4ukw0drx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 06:41:18 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2666fFkn24117700
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 Jul 2022 06:41:15 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6EF6E4C040;
        Wed,  6 Jul 2022 06:41:15 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8BA5B4C044;
        Wed,  6 Jul 2022 06:41:14 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  6 Jul 2022 06:41:14 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm390 mailing list <kvm390-list@tuxmaker.boeblingen.de.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com, scgl@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 4/8] s390x: uv-host: Add access exception test
Date:   Wed,  6 Jul 2022 06:40:20 +0000
Message-Id: <20220706064024.16573-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220706064024.16573-1-frankja@linux.ibm.com>
References: <20220706064024.16573-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MJEo-B-sIcdqz--xZrNWZ9oGCE2LARmW
X-Proofpoint-ORIG-GUID: dlWsL7czKa9fE-o8_a6-p32W-X0Fs3Kl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-06_02,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 lowpriorityscore=0 phishscore=0
 malwarescore=0 clxscore=1015 spamscore=0 bulkscore=0 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207060022
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's check that we get access exceptions if the UVCB is on an invalid
page or starts at a valid page and crosses into an invalid one.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/uv-host.c | 52 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 0762e690..a626a651 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -15,12 +15,14 @@
 #include <sclp.h>
 #include <smp.h>
 #include <uv.h>
+#include <mmu.h>
 #include <asm/page.h>
 #include <asm/sigp.h>
 #include <asm/pgtable.h>
 #include <asm/asm-offsets.h>
 #include <asm/interrupt.h>
 #include <asm/facility.h>
+#include <asm/pgtable.h>
 #include <asm/uv.h>
 #include <asm-generic/barrier.h>
 
@@ -142,6 +144,54 @@ static void test_uv_uninitialized(void)
 	report_prefix_pop();
 }
 
+static void test_access(void)
+{
+	struct uv_cb_header *uvcb;
+	void *pages =  alloc_pages(1);
+	uint16_t pgm;
+	int i;
+
+	/* Put UVCB on second page which we will protect later */
+	uvcb = pages + PAGE_SIZE;
+
+	report_prefix_push("access");
+
+	report_prefix_push("non-crossing");
+	protect_page(uvcb, PAGE_ENTRY_I);
+	for (i = 0; cmds[i].name; i++) {
+		expect_pgm_int();
+		mb();
+		uv_call_once(0, (uint64_t)uvcb);
+		pgm = clear_pgm_int();
+		report(pgm == PGM_INT_CODE_PAGE_TRANSLATION, "%s", cmds[i].name);
+	}
+	report_prefix_pop();
+
+	report_prefix_push("crossing");
+	/*
+	 * Put the header into the readable page 1, everything after
+	 * the header will be on the second, invalid page.
+	 */
+	uvcb -= 1;
+	for (i = 0; cmds[i].name; i++) {
+		uvcb->cmd = cmds[i].cmd;
+		uvcb->len = cmds[i].len;
+
+		expect_pgm_int();
+		mb();
+		uv_call_once(0, (uint64_t)uvcb);
+		pgm = clear_pgm_int();
+		report(pgm == PGM_INT_CODE_PAGE_TRANSLATION, "%s", cmds[i].name);
+	}
+	report_prefix_pop();
+
+	uvcb += 1;
+	unprotect_page(uvcb, PAGE_ENTRY_I);
+
+	free_pages(pages);
+	report_prefix_pop();
+}
+
 static void test_config_destroy(void)
 {
 	int rc;
@@ -607,6 +657,8 @@ int main(void)
 	test_init();
 
 	setup_vmem();
+	test_access();
+
 	test_config_create();
 	test_cpu_create();
 	test_cpu_destroy();
-- 
2.34.1

