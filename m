Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6722A3BE93E
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 16:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbhGGOGR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 10:06:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28910 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231947AbhGGOGP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Jul 2021 10:06:15 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 167E3WAH124474;
        Wed, 7 Jul 2021 10:03:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=7BX5hVaXv0O/ZmiTpN2TU2wtw3Z/cEVCUq781yoy794=;
 b=FKbZCW2iGnzJZfCy8V2iztoQl4N0QbtjHrx/XKVQimrsH4urftqgH9HCW12IXquagEv9
 NFL5uXX9WB+27X231oT0bPFvcnOEaIR9Rpoz8wvzcEIO62A7R8+MsvFLY3q/FTHI8FoM
 ol8EeLhHh1dDJpL76mQ7sj4pkFWWkSs/ghyimjdfXEgC04wZFYTKHdTv2kpUjqdgHF+v
 KJWDgGvoSEacRswAcPH+glzjEpoO2P7CS3e22ieb9t23ABRomKzXFA76GXLKbLtHpM8z
 eA01l53CY5IFa/87VUfhEm71JrdIfiZCZlKk87KEf4uAoQDbeniscTtmMm6S80nx4IFm MQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39mbkf4df6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 10:03:34 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 167E3XpY124647;
        Wed, 7 Jul 2021 10:03:34 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39mbkf4de0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 10:03:34 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 167E2gPP005808;
        Wed, 7 Jul 2021 14:03:32 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 39jf5hgycw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 14:03:31 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 167E1bZs16843178
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Jul 2021 14:01:37 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D1120A4053;
        Wed,  7 Jul 2021 14:03:28 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58BE5A4040;
        Wed,  7 Jul 2021 14:03:28 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.29.241])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  7 Jul 2021 14:03:28 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 3/8] s390x: mvpg: Add SIE mvpg test
Date:   Wed,  7 Jul 2021 16:03:13 +0200
Message-Id: <20210707140318.44255-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210707140318.44255-1-frankja@linux.ibm.com>
References: <20210707140318.44255-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VHpoPwYD0WUqZF3oerj9oy7k4n2KITtu
X-Proofpoint-ORIG-GUID: 3Au77Z5FC82tb2j_6Oj11BmzlXt4QU60
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-07_06:2021-07-06,2021-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 clxscore=1015 mlxlogscore=999 phishscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107070084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's also check the PEI values to make sure our VSIE implementation
is correct.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Acked-by: Thomas Huth <thuth@redhat.com>
---
 s390x/Makefile                  |   2 +
 s390x/mvpg-sie.c                | 149 ++++++++++++++++++++++++++++++++
 s390x/snippets/c/mvpg-snippet.c |  33 +++++++
 s390x/unittests.cfg             |   3 +
 4 files changed, 187 insertions(+)
 create mode 100644 s390x/mvpg-sie.c
 create mode 100644 s390x/snippets/c/mvpg-snippet.c

diff --git a/s390x/Makefile b/s390x/Makefile
index ba32f4c2..07af26d0 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -23,6 +23,7 @@ tests += $(TEST_DIR)/sie.elf
 tests += $(TEST_DIR)/mvpg.elf
 tests += $(TEST_DIR)/uv-host.elf
 tests += $(TEST_DIR)/edat.elf
+tests += $(TEST_DIR)/mvpg-sie.elf
 
 tests_binary = $(patsubst %.elf,%.bin,$(tests))
 ifneq ($(HOST_KEY_DOCUMENT),)
@@ -82,6 +83,7 @@ snippet_asmlib = $(SNIPPET_DIR)/c/cstart.o
 
 # perquisites (=guests) for the snippet hosts.
 # $(TEST_DIR)/<snippet-host>.elf: snippets = $(SNIPPET_DIR)/<c/asm>/<snippet>.gbin
+$(TEST_DIR)/mvpg-sie.elf: snippets = $(SNIPPET_DIR)/c/mvpg-snippet.gbin
 
 $(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o $(FLATLIBS)
 	$(OBJCOPY) -O binary $(patsubst %.gbin,%.o,$@) $@
diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
new file mode 100644
index 00000000..9bcd15a2
--- /dev/null
+++ b/s390x/mvpg-sie.c
@@ -0,0 +1,149 @@
+#include <libcflat.h>
+#include <asm/asm-offsets.h>
+#include <asm-generic/barrier.h>
+#include <asm/pgtable.h>
+#include <mmu.h>
+#include <asm/page.h>
+#include <asm/facility.h>
+#include <asm/mem.h>
+#include <alloc_page.h>
+#include <vm.h>
+#include <sclp.h>
+#include <sie.h>
+
+static u8 *guest;
+static u8 *guest_instr;
+static struct vm vm;
+
+static uint8_t *src;
+static uint8_t *dst;
+static uint8_t *cmp;
+
+extern const char _binary_s390x_snippets_c_mvpg_snippet_gbin_start[];
+extern const char _binary_s390x_snippets_c_mvpg_snippet_gbin_end[];
+int binary_size;
+
+static void sie(struct vm *vm)
+{
+	/* Reset icptcode so we don't trip over it below */
+	vm->sblk->icptcode = 0;
+
+	while (vm->sblk->icptcode == 0) {
+		sie64a(vm->sblk, &vm->save_area);
+		assert(vm->sblk->icptcode != ICPT_VALIDITY);
+	}
+	vm->save_area.guest.grs[14] = vm->sblk->gg14;
+	vm->save_area.guest.grs[15] = vm->sblk->gg15;
+}
+
+static void test_mvpg_pei(void)
+{
+	uint64_t **pei_dst = (uint64_t **)((uintptr_t) vm.sblk + 0xc0);
+	uint64_t **pei_src = (uint64_t **)((uintptr_t) vm.sblk + 0xc8);
+
+	report_prefix_push("pei");
+
+	report_prefix_push("src");
+	memset(dst, 0, PAGE_SIZE);
+	protect_page(src, PAGE_ENTRY_I);
+	sie(&vm);
+	report(vm.sblk->icptcode == ICPT_PARTEXEC, "Partial execution");
+	report((uintptr_t)**pei_src == (uintptr_t)src + PAGE_ENTRY_I, "PEI_SRC correct");
+	report((uintptr_t)**pei_dst == (uintptr_t)dst, "PEI_DST correct");
+	unprotect_page(src, PAGE_ENTRY_I);
+	report(!memcmp(cmp, dst, PAGE_SIZE), "Destination intact");
+	/*
+	 * We need to execute the diag44 which is used as a blocker
+	 * behind the mvpg. It makes sure we fail the tests above if
+	 * the mvpg wouldn't have intercepted.
+	 */
+	sie(&vm);
+	/* Make sure we intercepted for the diag44 and nothing else */
+	assert(vm.sblk->icptcode == ICPT_INST &&
+	       vm.sblk->ipa == 0x8300 && vm.sblk->ipb == 0x440000);
+	report_prefix_pop();
+
+	/* Clear PEI data for next check */
+	report_prefix_push("dst");
+	memset((uint64_t *)((uintptr_t) vm.sblk + 0xc0), 0, 16);
+	memset(dst, 0, PAGE_SIZE);
+	protect_page(dst, PAGE_ENTRY_I);
+	sie(&vm);
+	report(vm.sblk->icptcode == ICPT_PARTEXEC, "Partial execution");
+	report((uintptr_t)**pei_src == (uintptr_t)src, "PEI_SRC correct");
+	report((uintptr_t)**pei_dst == (uintptr_t)dst + PAGE_ENTRY_I, "PEI_DST correct");
+	/* Needed for the memcmp and general cleanup */
+	unprotect_page(dst, PAGE_ENTRY_I);
+	report(!memcmp(cmp, dst, PAGE_SIZE), "Destination intact");
+	report_prefix_pop();
+
+	report_prefix_pop();
+}
+
+static void test_mvpg(void)
+{
+	int binary_size = ((uintptr_t)_binary_s390x_snippets_c_mvpg_snippet_gbin_end -
+			   (uintptr_t)_binary_s390x_snippets_c_mvpg_snippet_gbin_start);
+
+	memcpy(guest, _binary_s390x_snippets_c_mvpg_snippet_gbin_start, binary_size);
+	memset(src, 0x42, PAGE_SIZE);
+	memset(dst, 0x43, PAGE_SIZE);
+	sie(&vm);
+	report(!memcmp(src, dst, PAGE_SIZE) && *dst == 0x42, "Page moved");
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
+
+	vm.sblk->gpsw.addr = PAGE_SIZE * 4;
+	vm.sblk->gpsw.mask = 0x0000000180000000ULL;
+	vm.sblk->ictl = ICTL_OPEREXC | ICTL_PINT;
+	/* Enable MVPG interpretation as we want to test KVM and not ourselves */
+	vm.sblk->eca = ECA_MVPGI;
+
+	src = guest + PAGE_SIZE * 6;
+	dst = guest + PAGE_SIZE * 5;
+	cmp = alloc_page();
+	memset(cmp, 0, PAGE_SIZE);
+}
+
+int main(void)
+{
+	report_prefix_push("mvpg-sie");
+	if (!sclp_facilities.has_sief2) {
+		report_skip("SIEF2 facility unavailable");
+		goto done;
+	}
+
+	setup_guest();
+	test_mvpg();
+	test_mvpg_pei();
+
+done:
+	report_prefix_pop();
+	return report_summary();
+
+}
diff --git a/s390x/snippets/c/mvpg-snippet.c b/s390x/snippets/c/mvpg-snippet.c
new file mode 100644
index 00000000..c1eb5d77
--- /dev/null
+++ b/s390x/snippets/c/mvpg-snippet.c
@@ -0,0 +1,33 @@
+#include <libcflat.h>
+
+static inline void force_exit(void)
+{
+	asm volatile("	diag	0,0,0x44\n");
+}
+
+static inline int mvpg(unsigned long r0, void *dest, void *src)
+{
+	register unsigned long reg0 asm ("0") = r0;
+	int cc;
+
+	asm volatile("	mvpg    %1,%2\n"
+		     "	ipm     %0\n"
+		     "	srl     %0,28"
+		     : "=d" (cc) : "a" (dest), "a" (src), "d" (reg0)
+		     : "memory", "cc");
+	return cc;
+}
+
+static void test_mvpg_real(void)
+{
+	mvpg(0, (void *)0x5000, (void *)0x6000);
+	force_exit();
+}
+
+__attribute__((section(".text"))) int main(void)
+{
+	test_mvpg_real();
+	test_mvpg_real();
+	test_mvpg_real();
+	return 0;
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index a0ec8864..9e1802fd 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -106,3 +106,6 @@ timeout = 10
 
 [edat]
 file = edat.elf
+
+[mvpg-sie]
+file = mvpg-sie.elf
-- 
2.31.1

