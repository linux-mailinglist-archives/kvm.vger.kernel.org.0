Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E96360B296
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 18:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbiJXQuV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 12:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234816AbiJXQsy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 12:48:54 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48FC95E579;
        Mon, 24 Oct 2022 08:31:59 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29ODaSSb009613;
        Mon, 24 Oct 2022 14:20:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=4Y++Kob0rReVAjonbUQ9wtbGu2bfv8RuukSnT81rxpM=;
 b=DfFWMo+fTuZonZZn3dupPRZvkG2ww3LK+nl7lK0l1p42fZDADX0TMOi5A0tzQNpqSf/e
 GrWbLUb6cQ36LDyt3J7KRcpeESiHcTe+YfhaOEKEnzo2MinXu7FM4zdynLzSDvhH79Pb
 GePtrzY9EJtnNa36YEctF8/AEp+PoIb85c/Jxoei3Hn7CxygGS3UTmsj0z+QKx854a6V
 VEHU0POmOIEaiCpqwHuD95XWfIW3wGWS38x2zSzfiUpE4pbEvrbeK3bjEOYxlZN7MLbm
 N/wIxpC42tt3beR+WApBIOK3K32dWv3CW40VHllfdFqZTr31+S/WkyUBFqsEhiSv45uP GA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kduhg1wu6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Oct 2022 14:20:43 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29ODasae010735;
        Mon, 24 Oct 2022 14:20:43 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kduhg1wt7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Oct 2022 14:20:42 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29OE7DEt004516;
        Mon, 24 Oct 2022 14:20:40 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3kc7sj3e6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Oct 2022 14:20:40 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29OEKb1n41353516
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 14:20:37 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 944F95204E;
        Mon, 24 Oct 2022 14:20:37 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.20.45])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 1914D52051;
        Mon, 24 Oct 2022 14:20:37 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        cohuck@redhat.com, imbrenda@linux.ibm.com, david@redhat.com,
        nrb@linux.ibm.com, scgl@linux.ibm.com
Subject: [kvm-unit-tests PATCH v5 1/2] s390x: topology: Check the Perform Topology Function
Date:   Mon, 24 Oct 2022 16:20:34 +0200
Message-Id: <20221024142035.22668-2-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221024142035.22668-1-pmorel@linux.ibm.com>
References: <20221024142035.22668-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2CT3gytEfUj-kRvQmsmppKIEUg5MAhiD
X-Proofpoint-ORIG-GUID: wS96nJQxpthy6htSJ-LC52tLecH4k_B_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-24_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 priorityscore=1501 adultscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210240086
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We check the PTF instruction.

- We check polarization only for KVM.
- We do not expect KVM to support vertical polarization.
- We do not expect the Topology Change Report to be pending
or not at the moment the first PTF instruction with
PTF_CHECK function code is done as some code already did run
a polarization change may have occur.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 s390x/Makefile      |   1 +
 s390x/topology.c    | 132 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   3 +
 3 files changed, 136 insertions(+)
 create mode 100644 s390x/topology.c

diff --git a/s390x/Makefile b/s390x/Makefile
index bf1504f9..4b9a21a7 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -39,6 +39,7 @@ tests += $(TEST_DIR)/panic-loop-extint.elf
 tests += $(TEST_DIR)/panic-loop-pgm.elf
 tests += $(TEST_DIR)/migration-sck.elf
 tests += $(TEST_DIR)/exittime.elf
+tests += $(TEST_DIR)/topology.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
 
diff --git a/s390x/topology.c b/s390x/topology.c
new file mode 100644
index 00000000..ae146d16
--- /dev/null
+++ b/s390x/topology.c
@@ -0,0 +1,132 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * CPU Topology
+ *
+ * Copyright IBM Corp. 2022
+ *
+ * Authors:
+ *  Pierre Morel <pmorel@linux.ibm.com>
+ */
+
+#include <libcflat.h>
+#include <asm/page.h>
+#include <asm/asm-offsets.h>
+#include <asm/interrupt.h>
+#include <asm/facility.h>
+#include <smp.h>
+#include <sclp.h>
+#include <s390x/vm.h>
+
+#define PTF_REQ_HORIZONTAL	0
+#define PTF_REQ_VERTICAL	1
+#define PTF_REQ_CHECK		2
+
+#define PTF_ERR_NO_REASON	0
+#define PTF_ERR_ALRDY_POLARIZED	1
+#define PTF_ERR_IN_PROGRESS	2
+
+static int ptf(unsigned long fc, unsigned long *rc)
+{
+	int cc;
+
+	asm volatile(
+		"       .insn   rre,0xb9a20000,%1,0\n"
+		"       ipm     %0\n"
+		"       srl     %0,28\n"
+		: "=d" (cc), "+d" (fc)
+		:
+		: "cc");
+
+	*rc = fc >> 8;
+	return cc;
+}
+
+static void test_ptf(void)
+{
+	unsigned long rc;
+	int cc;
+
+	/* PTF is a privilege instruction */
+	report_prefix_push("Privilege");
+	enter_pstate();
+	expect_pgm_int();
+	ptf(PTF_REQ_CHECK, &rc);
+	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
+	report_prefix_pop();
+
+	report_prefix_push("Wrong fc");
+	expect_pgm_int();
+	ptf(0xff, &rc);
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	report_prefix_pop();
+
+	report_prefix_push("Reserved bits");
+	expect_pgm_int();
+	ptf(0xffffffffffffff00UL, &rc);
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	report_prefix_pop();
+
+	report_prefix_push("Topology Report pending");
+	/*
+	 * At this moment the topology may already have changed
+	 * since the VM has been started.
+	 * However, we can test if a second PTF instruction
+	 * reports that the topology did not change since the
+	 * preceding PFT instruction.
+	 */
+	ptf(PTF_REQ_CHECK, &rc);
+	cc = ptf(PTF_REQ_CHECK, &rc);
+	report(cc == 0, "PTF check should clear topology report");
+	report_prefix_pop();
+
+	report_prefix_push("Topology polarisation check");
+	/*
+	 * We can not assume the state of the polarization for
+	 * any Virtual Machine but KVM.
+	 * Let's skip the polarisation tests for other VMs.
+	 */
+	if (!vm_is_kvm()) {
+		report_skip("Topology polarisation check is done for KVM only");
+		goto end;
+	}
+	cc = ptf(PTF_REQ_HORIZONTAL, &rc);
+	report(cc == 2 && rc == PTF_ERR_ALRDY_POLARIZED,
+	       "KVM always provides horizontal polarization");
+	cc = ptf(PTF_REQ_VERTICAL, &rc);
+	report(cc == 2 && rc == PTF_ERR_NO_REASON,
+	       "KVM doesn't support vertical polarization.");
+end:
+	report_prefix_pop();
+}
+
+static struct {
+	const char *name;
+	void (*func)(void);
+} tests[] = {
+	{ "PTF", test_ptf},
+	{ NULL, NULL }
+};
+
+int main(int argc, char *argv[])
+{
+	int i;
+
+	report_prefix_push("CPU Topology");
+
+	if (!test_facility(11)) {
+		report_skip("Topology facility not present");
+		goto end;
+	}
+
+	report_info("Machine level %ld", stsi_get_fc());
+
+	for (i = 0; tests[i].name; i++) {
+		report_prefix_push(tests[i].name);
+		tests[i].func();
+		report_prefix_pop();
+	}
+
+end:
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 3caf81ed..3530cc4c 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -208,3 +208,6 @@ groups = migration
 [exittime]
 file = exittime.elf
 smp = 2
+
+[topology]
+file = topology.elf
-- 
2.31.1

