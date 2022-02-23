Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 540CE4C142E
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 14:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240938AbiBWNaU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 08:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240920AbiBWNaR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 08:30:17 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC42AB463;
        Wed, 23 Feb 2022 05:29:49 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21NBIW4H008911;
        Wed, 23 Feb 2022 13:29:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Zqbky2/cC7AetT8vZX04ajXKKos844KHqybipcQnzXo=;
 b=qKGerMP1jLXaZNgkWKAS8GthXm/gaSug3hNvLm4bcP3iYYPYTXObuaIwAtFBsJNFQvgU
 Df+Zx9AqYytRw+Z2sFffC4R6zteJ+8TF2YFhUJ6C8xpvoMsbDpUCTBSXPTavqAjHiwek
 rbGj7B7F9P2n++s5dNo4gFN5p7JVbTC0Q5Fh91k4LajLeJ5S1PtGR6mfFVwL8dWUWICk
 ZbME1EwEtoVIuBhGQKfk8LCahojLY4zkwV4DlDKv2TmRftj8JiQPgrKDB8HYxcUPKHAR
 CEIhgk/SyATjC+6Xz9gRfNXCvSNLIkn4b6BkE2UUxSzqf9eavJ5zq3Wn56AqHtCAloI6 rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edkxftgq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 13:29:49 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21NCZQXZ011097;
        Wed, 23 Feb 2022 13:29:49 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edkxftgpm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 13:29:49 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21NDP4JO022367;
        Wed, 23 Feb 2022 13:29:46 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3ear698njd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 13:29:46 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21NDThm556099190
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 13:29:43 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 791F6A4051;
        Wed, 23 Feb 2022 13:29:43 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3848BA405E;
        Wed, 23 Feb 2022 13:29:43 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Feb 2022 13:29:43 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com
Subject: [kvm-unit-tests PATCH v3 8/8] s390x: Add EPSW test
Date:   Wed, 23 Feb 2022 14:29:40 +0100
Message-Id: <20220223132940.2765217-9-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220223132940.2765217-1-nrb@linux.ibm.com>
References: <20220223132940.2765217-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: KY1snYJtd_AQiTJe0LLqT5UKhbWBVrq_
X-Proofpoint-ORIG-GUID: suFMqQRZ8sY1qtFyrsU16_TvigHNAjYu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-23_05,2022-02-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 phishscore=0 priorityscore=1501 mlxscore=0 clxscore=1015
 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202230075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

EPSW is only intercepted in certain cases. One of these cases is if we
have a CRW pending and machine check interrupts are masked. This can be
achieved by issuing a RCHP on a valid channel path. This is why we need
the CSS lib and an IO device in this test and hence need to skip it
when not running under QEMU.

Three special cases deserve our attention:

- upper 32 bits of both operands are never modified,
- second operand is not modified if it is zero.
- when both operands are zero, bits 0-11 and 13-31 of the PSW are
  stored in r0.

We also verify we get the correct contents when the second operand is
zero. To do so, we save the data stored at the first operand in the
first case as a reference. As we don't mess with the PSW, the only thing
that might change is the Condition Code (CC) due to some instruction in
between, so we zero it out using zero_out_cc_from_epsw_op1().

This test must be fenced when running in non-QEMU.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/Makefile      |   1 +
 s390x/epsw.c        | 113 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   4 ++
 3 files changed, 118 insertions(+)
 create mode 100644 s390x/epsw.c

diff --git a/s390x/Makefile b/s390x/Makefile
index a76b78e5a011..25449708da0d 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -27,6 +27,7 @@ tests += $(TEST_DIR)/edat.elf
 tests += $(TEST_DIR)/mvpg-sie.elf
 tests += $(TEST_DIR)/spec_ex-sie.elf
 tests += $(TEST_DIR)/firq.elf
+tests += $(TEST_DIR)/epsw.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
 
diff --git a/s390x/epsw.c b/s390x/epsw.c
new file mode 100644
index 000000000000..192115cf2fac
--- /dev/null
+++ b/s390x/epsw.c
@@ -0,0 +1,113 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * EPSW Interception Tests
+ *
+ * Copyright IBM Corp. 2022
+ *
+ * Authors:
+ *  Nico Boehr <nrb@linux.ibm.com>
+ */
+#include <libcflat.h>
+#include <css.h>
+#include <vm.h>
+
+static uint32_t zero_out_cc_from_epsw_op1(uint32_t epsw_op1)
+{
+	return epsw_op1 & ~GENMASK(31 - 18, 31 - 20);
+}
+
+static void generate_crw(void)
+{
+	int test_device_sid = css_enumerate();
+	int cc, ret;
+
+	if (!(test_device_sid & SCHID_ONE)) {
+		report_fail("No I/O device found");
+		return;
+	}
+
+	cc = css_enable(test_device_sid, IO_SCH_ISC);
+	report(cc == 0, "Enable subchannel %08x", test_device_sid);
+
+	ret = css_generate_crw(test_device_sid);
+	if (ret)
+		report_fail("Couldn't generate CRW");
+}
+
+static void test_epsw(void)
+{
+	const uint64_t MAGIC1 = 0x1234567890abcdefUL;
+	const uint64_t MAGIC2 = 0xcafedeadbeeffaceUL;
+
+	uint64_t op1 = MAGIC1;
+	uint64_t op2 = MAGIC2;
+	uint32_t prev_epsw_op1;
+
+	/*
+	 * having machine check interrupts masked and pending CRW ensures
+	 * EPSW is intercepted under KVM
+	 */
+	generate_crw();
+
+	report_prefix_push("both operands given");
+	asm volatile(
+		"epsw %0, %1\n"
+		: "+&d" (op1), "+&a" (op2));
+	report(upper_32_bits(op1) == upper_32_bits(MAGIC1) &&
+	       upper_32_bits(op2) == upper_32_bits(MAGIC2),
+	       "upper 32 bits unmodified");
+	report(lower_32_bits(op1) != lower_32_bits(MAGIC1) &&
+	       lower_32_bits(op2) != lower_32_bits(MAGIC2),
+	       "lower 32 bits modified");
+	prev_epsw_op1 = zero_out_cc_from_epsw_op1(lower_32_bits(op1));
+	report_prefix_pop();
+
+	report_prefix_push("second operand 0");
+	op1 = MAGIC1;
+	op2 = MAGIC2;
+	asm volatile(
+		"	lgr 0,%[op2]\n"
+		"	epsw %[op1], 0\n"
+		"	lgr %[op2],0\n"
+		: [op2] "+&d" (op2), [op1] "+&a" (op1)
+		:
+		: "0");
+	report(upper_32_bits(op1) == upper_32_bits(MAGIC1),
+	       "upper 32 bits of first operand unmodified");
+	report(zero_out_cc_from_epsw_op1(lower_32_bits(op1)) == prev_epsw_op1,
+	       "first operand matches previous reading");
+	report(op2 == MAGIC2, "r0 unmodified");
+	report_prefix_pop();
+
+	report_prefix_push("both operands 0");
+	op1 = MAGIC1;
+	asm volatile(
+		"	lgr 0,%[op1]\n"
+		"	epsw 0, 0\n"
+		"	lgr %[op1],0\n"
+		: [op1] "+&d" (op1)
+		:
+		: "0");
+	report(upper_32_bits(op1) == upper_32_bits(MAGIC1),
+	       "upper 32 bits of first operand unmodified");
+	report(zero_out_cc_from_epsw_op1(lower_32_bits(op1)) == prev_epsw_op1,
+	       "first operand matches previous reading");
+	report_prefix_pop();
+}
+
+int main(int argc, char **argv)
+{
+	if (!vm_is_kvm() && !vm_is_tcg()) {
+		report_skip("Not running under QEMU");
+		goto done;
+	}
+
+	report_prefix_push("epsw");
+
+	test_epsw();
+
+done:
+	report_prefix_pop();
+
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 8b148fe31ac0..aeb82246dddf 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -139,3 +139,7 @@ accel = tcg
 
 [sck]
 file = sck.elf
+
+[epsw]
+file = epsw.elf
+extra_params = -device virtio-net-ccw
-- 
2.31.1

