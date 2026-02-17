Return-Path: <kvm+bounces-71150-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KJ5MJMMulGnQAQIAu9opvQ
	(envelope-from <kvm+bounces-71150-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 10:02:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 500EA14A264
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 10:02:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B22C43018768
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 09:02:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F7C32FBDF0;
	Tue, 17 Feb 2026 09:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Dkdd1tFm"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D30E2D7397;
	Tue, 17 Feb 2026 09:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771318969; cv=none; b=HDas4uVLrPGHmVSjYqQhvm8VnT67hfHKyZKDqRSEYCef2wNXIxkFk5eU57gqSKlWqozYPjKVA2+7jmLePOd6wbZLrwqWLMFWkwK0WYo0M7jKuHHuwDiuLA6Qef720xgfc8NLoPCAKFxEZn9UIrUoUjykcvZNckZkuwQznspVRWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771318969; c=relaxed/simple;
	bh=qiVeohC0yLT25HLMgWbzmgwVcAtjmDj7vlR+jozHZn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXrv0A+AKCOm8sAoli/dkeqbnulH6rO6K1sbgMZH9dXaYpUNdZ4sGdl1GzgjqJINhXpcPoVDs18Zu3Sccn2zYWYr12VvUvkayFve9kzsorTapJeEAlGsJme3OsGg2fCcD5stoz7191fvsGkwedHlkR+CfrfZX1OPIYwvYcCZHl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Dkdd1tFm; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61GGdtMx3855186;
	Tue, 17 Feb 2026 09:02:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=fhP7thMkX1mRywxXa
	M3698nxv/sPPhTh1r+J2jZvVBA=; b=Dkdd1tFmzzfcdPYDxRocxsj+gf3A3nFrS
	dcb6+g01QAgvghIpOGsbvxIM5D+JGLM6Gl4p19KAPTsyUz9inNUP50ns9QdTp5wj
	xn38gmhZ7zzW/Gss2EMEPvGdcL4rIG4i0bzVvMqlIgua344ATp42MSv4P4mqwsqz
	2sMMbqk9HuocPHRawkhWcPT9P23jm0ogamDOzijxLzBV5wjVKR/y83SYP5VnhzjW
	lAU+d4G6kKXnRAcFavFXrzOhFN7mSLWPKKXfIacGGfR2kfe7YqNp0cMh35Dzegw+
	CgBn6Xpz4htDDDBCMBenT+27wL9cnUVr1T2m5C0TzQKKGrs9ufXAg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cajcjadp5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Feb 2026 09:02:47 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61H8npuX015679;
	Tue, 17 Feb 2026 09:02:47 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ccb451skv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Feb 2026 09:02:46 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61H92gvh28836138
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Feb 2026 09:02:43 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DF4652004E;
	Tue, 17 Feb 2026 09:02:42 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AB79E2004B;
	Tue, 17 Feb 2026 09:02:42 +0000 (GMT)
Received: from b46lp25.lnxne.boe (unknown [9.87.84.240])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 17 Feb 2026 09:02:42 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        borntraeger@linux.ibm.com, freimuth@linux.ibm.com,
        mjrosato@linux.ibm.com
Subject: [PATCH 2/2] KVM: s390: selftests: Add IRQ routing address offset tests
Date: Tue, 17 Feb 2026 09:54:23 +0100
Message-ID: <20260217090230.8116-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217090230.8116-1-frankja@linux.ibm.com>
References: <20260217090230.8116-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: DEZF3-oerF-BMekCez1xox1biYc5uPLM
X-Authority-Analysis: v=2.4 cv=Md9hep/f c=1 sm=1 tr=0 ts=69942eb7 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=nmqUFfGTdH_2drHDQF0A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE3MDA3MSBTYWx0ZWRfXwJyIjh72+1RD
 II0FqBIA/W7nmNXGviKJFGIfC8cLrFgRzJ14n2cEu2RZocLLXtaxWrFX9zNETT3h9Ac7t6n80ZV
 bvKFYFz7PLN+E1kGlYToCxtFRPzsyRn3m13BJVm8dbqCcU+IF4Sfu45IDl2tq9KVbHhvdFB7uEk
 DeVNLGeLzpURa2/eiGbesWJWCAvTPSn1mKxHiWzdS6nQmxX6ibxNeR3IipUAAY5Sji9OoUj9n8c
 k4ztK/QYh4ByFqBLTr64eW72jyokY8AVOSThU/OQK02Po18xCE0TrbhcuzMVdd3QbrNzP+GPFab
 qXYLIpNuHBRXuLURA3ccdKaXtCwNj8jEhXLy36zc0JvgSHc/6+hPbXcgz1YrYyHVGTnj7RypdHu
 4igoKrlIiFfk2DcsBrMgkzIRuABzLtg6Q9Gfbx+ht3EjBRNiOBfvXTGZuQmQXw3Me8xyO/4rsy4
 b4f9lEATBjeJR0uL7tg==
X-Proofpoint-GUID: DEZF3-oerF-BMekCez1xox1biYc5uPLM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-17_01,2026-02-16_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 spamscore=0 adultscore=0
 priorityscore=1501 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602170071
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71150-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[frankja@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 500EA14A264
X-Rspamd-Action: no action

This test tries to setup routes which have address + offset
combinations which cross a page.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |  1 +
 .../testing/selftests/kvm/s390/irq_routing.c  | 75 +++++++++++++++++++
 2 files changed, 76 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/s390/irq_routing.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 7cfdfe7edfbf..c757704a0cb7 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -201,6 +201,7 @@ TEST_GEN_PROGS_s390 += s390/ucontrol_test
 TEST_GEN_PROGS_s390 += s390/user_operexec
 TEST_GEN_PROGS_s390 += s390/keyop
 TEST_GEN_PROGS_s390 += rseq_test
+TEST_GEN_PROGS_s390 += s390/irq_routing
 
 TEST_GEN_PROGS_riscv = $(TEST_GEN_PROGS_COMMON)
 TEST_GEN_PROGS_riscv += riscv/sbi_pmu_test
diff --git a/tools/testing/selftests/kvm/s390/irq_routing.c b/tools/testing/selftests/kvm/s390/irq_routing.c
new file mode 100644
index 000000000000..4d9b5df2e456
--- /dev/null
+++ b/tools/testing/selftests/kvm/s390/irq_routing.c
@@ -0,0 +1,75 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * IRQ routing offset tests.
+ *
+ * Copyright IBM Corp. 2026
+ *
+ * Authors:
+ *  Janosch Frank <frankja@linux.ibm.com>
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "kselftest.h"
+#include "ucall_common.h"
+
+extern char guest_code[];
+asm("guest_code:\n"
+    "diag %r0,%r0,0\n"
+    "j .\n");
+
+static void test(void)
+{
+	struct kvm_irq_routing *routing;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	vm_paddr_t mem;
+	int ret;
+
+	struct kvm_irq_routing_entry ue = {
+		.type = KVM_IRQ_ROUTING_S390_ADAPTER,
+		.gsi = 1,
+	};
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	mem = vm_phy_pages_alloc(vm, 2, 4096 * 42, 0);
+
+	routing = kvm_gsi_routing_create();
+	routing->nr = 1;
+	routing->entries[0] = ue;
+	routing->entries[0].u.adapter.summary_addr = (uintptr_t)mem;
+	routing->entries[0].u.adapter.ind_addr = (uintptr_t)mem;
+
+	routing->entries[0].u.adapter.summary_offset = 4096 * 8;
+	ret = __vm_ioctl(vm, KVM_SET_GSI_ROUTING, routing);
+	ksft_test_result(ret == -1 && errno == EINVAL, "summary offset outside of page\n");
+
+	routing->entries[0].u.adapter.summary_offset -= 8;
+	ret = __vm_ioctl(vm, KVM_SET_GSI_ROUTING, routing);
+	ksft_test_result(ret == 0, "summary offset inside of page\n");
+
+	routing->entries[0].u.adapter.ind_offset = 4096 * 8;
+	ret = __vm_ioctl(vm, KVM_SET_GSI_ROUTING, routing);
+	ksft_test_result(ret == -1 && errno == EINVAL, "ind offset outside of page\n");
+
+	routing->entries[0].u.adapter.ind_offset -= 8;
+	ret = __vm_ioctl(vm, KVM_SET_GSI_ROUTING, routing);
+	ksft_test_result(ret == 0, "ind offset inside of page\n");
+
+	kvm_vm_free(vm);
+}
+
+int main(int argc, char *argv[])
+{
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_IRQ_ROUTING));
+
+	ksft_print_header();
+	ksft_set_plan(4);
+	test();
+
+	ksft_finished();	/* Print results and exit() accordingly */
+}
-- 
2.53.0


