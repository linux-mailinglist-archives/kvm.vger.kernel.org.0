Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 695862F3183
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 14:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733062AbhALNWC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 08:22:02 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23966 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729886AbhALNWA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Jan 2021 08:22:00 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10CD4CFs041999;
        Tue, 12 Jan 2021 08:21:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=m0k3f7bFzGurrGkPGQ/GE6kJKwkkGBRgc9Ll7yqhDzw=;
 b=MYH9OxuLP7DhrlpCENLh8A9guzt9kprzRhiPacLgYJpUVG9WOwuIcvfxDmUdkarI6Zp2
 B7bV96woSkb0Lzh4p2rIzI2qycTOJJwa+xmUTI6LITGBCg6hSqd0Hon24+InjWdfxjGW
 67/maA69NTrdwLd8kMuBhcSn0+DHAexR1TxiTRT+OuHWGxTzBuuEjVErlw1IKXyuOrba
 KuIugefOzYWxE5Z30M9hFbADOwgONfvVlxvqxkH1JDKL9WHkIzlvQBqF8JBvail4LbyH
 gqlxbuum2xO2qfUda8gC1qbXxjQNuTqooeHjBi8Q4U6lcWgUHzATpC8EWY/j+R+Yp8Sz bQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361b8htt68-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 08:21:20 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10CD4I7E042316;
        Tue, 12 Jan 2021 08:21:20 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361b8htt5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 08:21:19 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10CDI18L023615;
        Tue, 12 Jan 2021 13:21:17 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 35ydrdb8vy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 13:21:17 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10CDLEYc37290472
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 13:21:15 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D94854C050;
        Tue, 12 Jan 2021 13:21:14 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1DD744C044;
        Tue, 12 Jan 2021 13:21:14 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Jan 2021 13:21:14 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, borntraeger@de.ibm.com,
        imbrenda@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 6/9] s390x: sie: Add first SIE test
Date:   Tue, 12 Jan 2021 08:20:51 -0500
Message-Id: <20210112132054.49756-7-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210112132054.49756-1-frankja@linux.ibm.com>
References: <20210112132054.49756-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_07:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 mlxscore=0 phishscore=0 adultscore=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 spamscore=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120073
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's check if we get the correct interception data on a few
diags. This commit is more of an addition of boilerplate code than a
real test.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 s390x/Makefile      |   1 +
 s390x/sie.c         | 113 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   3 ++
 3 files changed, 117 insertions(+)
 create mode 100644 s390x/sie.c

diff --git a/s390x/Makefile b/s390x/Makefile
index e0bccc8..9e6e60d 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -19,6 +19,7 @@ tests += $(TEST_DIR)/smp.elf
 tests += $(TEST_DIR)/sclp.elf
 tests += $(TEST_DIR)/css.elf
 tests += $(TEST_DIR)/uv-guest.elf
+tests += $(TEST_DIR)/sie.elf
 
 tests_binary = $(patsubst %.elf,%.bin,$(tests))
 ifneq ($(HOST_KEY_DOCUMENT),)
diff --git a/s390x/sie.c b/s390x/sie.c
new file mode 100644
index 0000000..cfc746f
--- /dev/null
+++ b/s390x/sie.c
@@ -0,0 +1,113 @@
+#include <libcflat.h>
+#include <asm/asm-offsets.h>
+#include <asm/arch_def.h>
+#include <asm/interrupt.h>
+#include <asm/page.h>
+#include <alloc_page.h>
+#include <vmalloc.h>
+#include <asm/facility.h>
+#include <mmu.h>
+#include <sclp.h>
+#include <sie.h>
+
+static u8 *guest;
+static u8 *guest_instr;
+static struct vm vm;
+
+static void handle_validity(struct vm *vm)
+{
+	report(0, "VALIDITY: %x", vm->sblk->ipb >> 16);
+}
+
+static void sie(struct vm *vm)
+{
+	while (vm->sblk->icptcode == 0) {
+		sie64a(vm->sblk, &vm->save_area);
+		if (vm->sblk->icptcode == ICPT_VALIDITY)
+			handle_validity(vm);
+	}
+	vm->save_area.guest.grs[14] = vm->sblk->gg14;
+	vm->save_area.guest.grs[15] = vm->sblk->gg15;
+}
+
+static void sblk_cleanup(struct vm *vm)
+{
+	vm->sblk->icptcode = 0;
+}
+
+static void test_diag(u32 instr)
+{
+	vm.sblk->gpsw.addr = PAGE_SIZE * 2;
+	vm.sblk->gpsw.mask = 0x0000000180000000ULL;
+
+	memset(guest_instr, 0, PAGE_SIZE);
+	memcpy(guest_instr, &instr, 4);
+	sie(&vm);
+	report(vm.sblk->icptcode == ICPT_INST &&
+	       vm.sblk->ipa == instr >> 16 && vm.sblk->ipb == instr << 16,
+	       "Intercept data");
+	sblk_cleanup(&vm);
+}
+
+static struct {
+	const char *name;
+	u32 instr;
+} tests[] = {
+	{ "10", 0x83020010 },
+	{ "44", 0x83020044 },
+	{ "9c", 0x8302009c },
+	{ NULL, 0 }
+};
+
+static void test_diags(void)
+{
+	int i;
+
+	for (i = 0; tests[i].name; i++) {
+		report_prefix_push(tests[i].name);
+		test_diag(tests[i].instr);
+		report_prefix_pop();
+	}
+}
+
+static void setup_guest(void)
+{
+	setup_vm();
+
+	/* Allocate 1MB as guest memory */
+	guest = alloc_pages(8);
+	/* The first two pages are the lowcore */
+	guest_instr = guest + PAGE_SIZE * 2;
+
+	vm.sblk = alloc_page();
+
+	vm.sblk->cpuflags = CPUSTAT_ZARCH | CPUSTAT_RUNNING;
+	vm.sblk->prefix = 0;
+	/*
+	 * Pageable guest with the same ASCE as the test programm, but
+	 * the guest memory 0x0 is offset to start at the allocated
+	 * guest pages and end after 1MB.
+	 *
+	 * It's not pretty but faster and easier than managing guest ASCEs.
+	 */
+	vm.sblk->mso = (u64)guest;
+	vm.sblk->msl = (u64)guest;
+	vm.sblk->ihcpu = 0xffff;
+
+	vm.sblk->crycbd = (uint64_t)alloc_page();
+}
+
+int main(void)
+{
+	report_prefix_push("sie");
+	if (!sclp_facilities.has_sief2) {
+		report_skip("SIEF2 facility unavailable");
+		goto done;
+	}
+
+	setup_guest();
+	test_diags();
+done:
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 3feb8bc..2298be6 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -96,3 +96,6 @@ smp = 2
 
 [uv-guest]
 file = uv-guest.elf
+
+[sie]
+file = sie.elf
-- 
2.25.1

