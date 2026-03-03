Return-Path: <kvm+bounces-72528-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IJq9D6rqpmnjZgAAu9opvQ
	(envelope-from <kvm+bounces-72528-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 15:05:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D4EBA1F1071
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 15:05:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 1190730A9041
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 13:55:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EA4235773F;
	Tue,  3 Mar 2026 13:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fwzz3XQE"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9A135836C;
	Tue,  3 Mar 2026 13:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772546050; cv=none; b=Z6HTRZxywtkGPvMWdMB3Q9kF+u6ufReNO2vbdnS0k+Z2E/ZuHuYnzTmDnF3oeukFKJczedplqEyEOLSlkCyrcAdIXuqy8OZEMXm5uIPZr11l5jnPvt79DadWynAcpKHtppVctGGRWZ9CI7eB1NruVP7DoTN47AJNMHDgBWfjG7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772546050; c=relaxed/simple;
	bh=YXasIYVoXiApJJEaO4bL2F5lmFJDAz7dcNZF1wv0rQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OURYF5o3Q0lJ0sZ1xW0mWuGTkFj3R0okW4SPFiGVDKnchGT6luc5YE5xbh7wvjlvLcE7RnuAVCryRPFQKnu13kUdv8l3nPyr4rS450PweOwfPHct2rINgZj7xXfd+53r/hdurde1Q4Pn7OhoHraUNVzORIZNEiDFPnKnIZxXQsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fwzz3XQE; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6231vMl3859950;
	Tue, 3 Mar 2026 13:54:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=AUl41te4x8oHbWKw1
	OCUL3jblwtI/MdrKjlyRJc7Wfs=; b=fwzz3XQEX/t60iOo4Xb+ApQArS3BrA2aT
	uHZVkPzzzaZrvHhPvqoP2wTy48dSUuXetmElWBk7ZEM7flb6CxTdNiIb4IgmgLnv
	vFMMFgDhO6/biY9dUIwsTOGVP1PxS5JN4b6obbzzExUAL4wASx92H/RtcUkzrJKW
	J6Ct152WUDSNazcpPfLezUDmgrvmd8uLiY4/yk5PhbmIOGscee1SrTLBb0xJtX+p
	o3zTPSCu8YXVSo5IATzCEzEI4e9fbCnIe7X6u4E2fpRDBdK2/NFPrTnE63oaUBdl
	+o5gGjW5TxfUXSkqjXYks/RUyrosCaOUU/0t5GU/rvfy7Jo10nQdA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ckskbtw4y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Mar 2026 13:54:08 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 623AFERU016802;
	Tue, 3 Mar 2026 13:54:07 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cmbpn2gxn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Mar 2026 13:54:07 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 623Ds3JH61342142
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 3 Mar 2026 13:54:03 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 94A7C20040;
	Tue,  3 Mar 2026 13:54:03 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 768FA2004B;
	Tue,  3 Mar 2026 13:54:03 +0000 (GMT)
Received: from b46lp25.lnxne.boe (unknown [9.87.84.240])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  3 Mar 2026 13:54:03 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, mjrosato@linux.ibm.com, freimuth@linux.ibm.com,
        imbrenda@linux.ibm.com, borntraeger@linux.ibm.com
Subject: [PATCH v2 2/2] KVM: s390: selftests: Add IRQ routing address offset tests
Date: Tue,  3 Mar 2026 13:46:35 +0000
Message-ID: <20260303135250.3665-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260303135250.3665-1-frankja@linux.ibm.com>
References: <20260303135250.3665-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hu8jThj64-NmMvihnyO_7Zsnclwxtaso
X-Authority-Analysis: v=2.4 cv=b66/I9Gx c=1 sm=1 tr=0 ts=69a6e800 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=nmqUFfGTdH_2drHDQF0A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDEwOCBTYWx0ZWRfX6bkAz4f4Mxwf
 7/4Emo/uEJBNqN4a5/y1iDFjnaVlqW6JUnFQ0IjVhyJ/qW9OpGtZQW0ZUs4PQdA4Rn2DislZowR
 M43oSk3b0A7k8NF3+Lz0x8PH9288YYJ4pEZndjTXGmFTb8CkKs0aSpsLblDS1P1WytsRmgioD0o
 WyvnTjpGxgdptNOFolXCZXTcFaMMHHMZ5fBNtab8f6vTxqDzjNqGYu454PVZHXe4rRLJNtMtwWF
 jRmpsi/22TkozVpkWWMH8aJMbvMko2LtDk67Hcy5tf/UihNu7jpW3bJW/YR9wE/4FQygN/12qs7
 4+FKLJ9rGLkU4oYdvdks5I+CNOAkXsD+Rsd1hdzk5/QbAsxY/6oFtNkQRfUTZ86WFGpdRw6Nwfi
 yHZRZyqP4Gm7+k99od9tIWr/Ex30CqontT5iuKKCPTLuCpNJDCW9WnEMtHFln1bQRwvd4pMWpxm
 jT2EIvrFo9hI+muJ5CA==
X-Proofpoint-GUID: hu8jThj64-NmMvihnyO_7Zsnclwxtaso
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015 adultscore=0
 bulkscore=0 impostorscore=0 malwarescore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603030108
X-Rspamd-Queue-Id: D4EBA1F1071
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72528-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[frankja@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,linux.ibm.com:mid];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_SEVEN(0.00)[11]
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
index fdec90e85467..271cbb63af36 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -205,6 +205,7 @@ TEST_GEN_PROGS_s390 += s390/ucontrol_test
 TEST_GEN_PROGS_s390 += s390/user_operexec
 TEST_GEN_PROGS_s390 += s390/keyop
 TEST_GEN_PROGS_s390 += rseq_test
+TEST_GEN_PROGS_s390 += s390/irq_routing
 
 TEST_GEN_PROGS_riscv = $(TEST_GEN_PROGS_COMMON)
 TEST_GEN_PROGS_riscv += riscv/sbi_pmu_test
diff --git a/tools/testing/selftests/kvm/s390/irq_routing.c b/tools/testing/selftests/kvm/s390/irq_routing.c
new file mode 100644
index 000000000000..7819a0af19a8
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
+	routing->entries[0].u.adapter.summary_offset -= 4;
+	ret = __vm_ioctl(vm, KVM_SET_GSI_ROUTING, routing);
+	ksft_test_result(ret == 0, "summary offset inside of page\n");
+
+	routing->entries[0].u.adapter.ind_offset = 4096 * 8;
+	ret = __vm_ioctl(vm, KVM_SET_GSI_ROUTING, routing);
+	ksft_test_result(ret == -1 && errno == EINVAL, "ind offset outside of page\n");
+
+	routing->entries[0].u.adapter.ind_offset -= 4;
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
2.51.0


