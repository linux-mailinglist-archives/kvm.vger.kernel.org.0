Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECBB95654A5
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 14:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233988AbiGDMNl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 08:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233688AbiGDMNi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 08:13:38 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CAF8DC7;
        Mon,  4 Jul 2022 05:13:36 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 264BGZvi005285;
        Mon, 4 Jul 2022 12:13:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Xs9BwbqR71GXVeL+iz6ZX2fw0aSrb1rik6PUNblwiYY=;
 b=g2PA/5OjkaNsd0quM9jHho/RnhqqMbx8Kx4Q9KuDcADLjaQpAOWRi1+Nr2H9XWYyAyjt
 vRt2RQRMu12USdqcApgRJTKUmaX60ZvOtBWtC5WxcuZBQEwqO375pVo5W1GRhFDZaRW+
 zBhnqScP/22LoaRe6A2jzTxaBYBZ2xohibNDQi8xfT8i+C9OBg3r33qaxHbtTTKRXJw1
 zB0d8iFIMAwptxHrZYV/DW3MGMYWE7PO+pRfl/HoigRjlq1VP6SbiK/qvI/1YXMteeBV
 AQbL/suRxCXvL1UjbErSvISTVFsoYMM+Oq3EnrQHbhFBpFaZxQa3uiOI0K4YZqbyv+et 7g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h3y6kh74f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jul 2022 12:13:35 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 264BW8WP004512;
        Mon, 4 Jul 2022 12:13:35 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h3y6kh73r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jul 2022 12:13:35 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 264C6kH5019242;
        Mon, 4 Jul 2022 12:13:32 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3h2dn8t0am-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jul 2022 12:13:32 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 264CDTtI21889326
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Jul 2022 12:13:29 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A08055204E;
        Mon,  4 Jul 2022 12:13:29 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6BD8E52050;
        Mon,  4 Jul 2022 12:13:29 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 4/4] s390x: add pgm spec interrupt loop test
Date:   Mon,  4 Jul 2022 14:13:28 +0200
Message-Id: <20220704121328.721841-5-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220704121328.721841-1-nrb@linux.ibm.com>
References: <20220704121328.721841-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0HlcWoQHg6Yoil7VPzEHWUrEmOkJpgZT
X-Proofpoint-GUID: h4Zstar_VnTQ0Ji7XjiwjnZUSNDQTzTw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-04_11,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 bulkscore=0 adultscore=0 clxscore=1015 priorityscore=1501
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=0 malwarescore=0
 mlxlogscore=934 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2207040052
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

An invalid PSW causes a program interrupt. When an invalid PSW is
introduced in the pgm_new_psw, an interrupt loop occurs as soon as a
program interrupt is caused.

QEMU should detect that and panic the guest, hence add a test for it.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile         |  1 +
 s390x/panic-loop-pgm.c | 53 ++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg    |  6 +++++
 3 files changed, 60 insertions(+)
 create mode 100644 s390x/panic-loop-pgm.c

diff --git a/s390x/Makefile b/s390x/Makefile
index e4649da50d9d..66415d0b588d 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -35,6 +35,7 @@ tests += $(TEST_DIR)/pv-attest.elf
 tests += $(TEST_DIR)/migration-cmm.elf
 tests += $(TEST_DIR)/migration-skey.elf
 tests += $(TEST_DIR)/panic-loop-extint.elf
+tests += $(TEST_DIR)/panic-loop-pgm.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
 
diff --git a/s390x/panic-loop-pgm.c b/s390x/panic-loop-pgm.c
new file mode 100644
index 000000000000..68934057a251
--- /dev/null
+++ b/s390x/panic-loop-pgm.c
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Program interrupt loop test
+ *
+ * Copyright IBM Corp. 2022
+ *
+ * Authors:
+ *  Nico Boehr <nrb@linux.ibm.com>
+ */
+#include <libcflat.h>
+#include <bitops.h>
+#include <asm/interrupt.h>
+#include <asm/barrier.h>
+#include <hardware.h>
+
+static void pgm_int_handler(void)
+{
+	/*
+	 * return to pgm_old_psw. This gives us the chance to print the return_fail
+	 * in case something goes wrong.
+	 */
+	asm volatile (
+		"lpswe %[pgm_old_psw]\n"
+		:
+		: [pgm_old_psw] "Q"(lowcore.pgm_old_psw)
+		: "memory"
+	);
+}
+
+int main(void)
+{
+	report_prefix_push("panic-loop-pgm");
+
+	if (!host_is_qemu() || host_is_tcg()) {
+		report_skip("QEMU-KVM-only test");
+		goto out;
+	}
+
+	lowcore.pgm_new_psw.addr = (uint64_t) pgm_int_handler;
+	/* bit 12 set is invalid */
+	lowcore.pgm_new_psw.mask = extract_psw_mask() | BIT(63 - 12);
+	mb();
+
+	/* cause a pgm int */
+	*((int *)-4) = 0x42;
+	mb();
+
+	report_fail("survived pgmint loop");
+
+out:
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 53aeb94f382c..0f7d830220d7 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -190,3 +190,9 @@ file = panic-loop-extint.elf
 groups = panic
 accel = kvm
 timeout = 5
+
+[panic-loop-pgm]
+file = panic-loop-pgm.elf
+groups = panic
+accel = kvm
+timeout = 5
-- 
2.36.1

