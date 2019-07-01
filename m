Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 926035BC46
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2019 14:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727665AbfGAM65 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jul 2019 08:58:57 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25756 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727685AbfGAM64 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Jul 2019 08:58:56 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x61CvSJ4138694
        for <kvm@vger.kernel.org>; Mon, 1 Jul 2019 08:58:56 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tfgmsykf1-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 01 Jul 2019 08:58:56 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 1 Jul 2019 13:58:54 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 1 Jul 2019 13:58:51 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x61CwoJK27001038
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Jul 2019 12:58:50 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A290A4057;
        Mon,  1 Jul 2019 12:58:50 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 68D6CA404D;
        Mon,  1 Jul 2019 12:58:50 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon,  1 Jul 2019 12:58:50 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 30017E0506; Mon,  1 Jul 2019 14:58:50 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>
Subject: [GIT PULL 4/7] KVM: selftests: Add processor code for s390x
Date:   Mon,  1 Jul 2019 14:58:45 +0200
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190701125848.276133-1-borntraeger@de.ibm.com>
References: <20190701125848.276133-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19070112-0008-0000-0000-000002F8CD2E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19070112-0009-0000-0000-00002266120B
Message-Id: <20190701125848.276133-5-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-01_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907010160
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Huth <thuth@redhat.com>

Code that takes care of basic CPU setup, page table walking, etc.

Signed-off-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20190523164309.13345-7-thuth@redhat.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 MAINTAINERS                                   |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/s390x/processor.h   |  22 ++
 .../selftests/kvm/lib/s390x/processor.c       | 286 ++++++++++++++++++
 4 files changed, 310 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/include/s390x/processor.h
 create mode 100644 tools/testing/selftests/kvm/lib/s390x/processor.c

diff --git a/MAINTAINERS b/MAINTAINERS
index a6954776a37e7..68ce91fffeaf9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8674,6 +8674,7 @@ F:	arch/s390/include/asm/gmap.h
 F:	arch/s390/include/asm/kvm*
 F:	arch/s390/kvm/
 F:	arch/s390/mm/gmap.c
+F:	tools/testing/selftests/kvm/*/s390x/
 
 KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)
 M:	Paolo Bonzini <pbonzini@redhat.com>
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 41280dc062974..b4a07cd0b48e8 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -10,6 +10,7 @@ UNAME_M := $(shell uname -m)
 LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/ucall.c lib/sparsebit.c
 LIBKVM_x86_64 = lib/x86_64/processor.c lib/x86_64/vmx.c
 LIBKVM_aarch64 = lib/aarch64/processor.c
+LIBKVM_s390x = lib/s390x/processor.c
 
 TEST_GEN_PROGS_x86_64 = x86_64/platform_info_test
 TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
diff --git a/tools/testing/selftests/kvm/include/s390x/processor.h b/tools/testing/selftests/kvm/include/s390x/processor.h
new file mode 100644
index 0000000000000..e0e96a5f608c1
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/s390x/processor.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * s390x processor specific defines
+ */
+#ifndef SELFTEST_KVM_PROCESSOR_H
+#define SELFTEST_KVM_PROCESSOR_H
+
+/* Bits in the region/segment table entry */
+#define REGION_ENTRY_ORIGIN	~0xfffUL /* region/segment table origin	   */
+#define REGION_ENTRY_PROTECT	0x200	 /* region protection bit	   */
+#define REGION_ENTRY_NOEXEC	0x100	 /* region no-execute bit	   */
+#define REGION_ENTRY_OFFSET	0xc0	 /* region table offset		   */
+#define REGION_ENTRY_INVALID	0x20	 /* invalid region table entry	   */
+#define REGION_ENTRY_TYPE	0x0c	 /* region/segment table type mask */
+#define REGION_ENTRY_LENGTH	0x03	 /* region third length		   */
+
+/* Bits in the page table entry */
+#define PAGE_INVALID	0x400		/* HW invalid bit    */
+#define PAGE_PROTECT	0x200		/* HW read-only bit  */
+#define PAGE_NOEXEC	0x100		/* HW no-execute bit */
+
+#endif
diff --git a/tools/testing/selftests/kvm/lib/s390x/processor.c b/tools/testing/selftests/kvm/lib/s390x/processor.c
new file mode 100644
index 0000000000000..c8759445e7d33
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/s390x/processor.c
@@ -0,0 +1,286 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * KVM selftest s390x library code - CPU-related functions (page tables...)
+ *
+ * Copyright (C) 2019, Red Hat, Inc.
+ */
+
+#define _GNU_SOURCE /* for program_invocation_name */
+
+#include "processor.h"
+#include "kvm_util.h"
+#include "../kvm_util_internal.h"
+
+#define KVM_GUEST_PAGE_TABLE_MIN_PADDR		0x180000
+
+#define PAGES_PER_REGION 4
+
+void virt_pgd_alloc(struct kvm_vm *vm, uint32_t memslot)
+{
+	vm_paddr_t paddr;
+
+	TEST_ASSERT(vm->page_size == 4096, "Unsupported page size: 0x%x",
+		    vm->page_size);
+
+	if (vm->pgd_created)
+		return;
+
+	paddr = vm_phy_pages_alloc(vm, PAGES_PER_REGION,
+				   KVM_GUEST_PAGE_TABLE_MIN_PADDR, memslot);
+	memset(addr_gpa2hva(vm, paddr), 0xff, PAGES_PER_REGION * vm->page_size);
+
+	vm->pgd = paddr;
+	vm->pgd_created = true;
+}
+
+/*
+ * Allocate 4 pages for a region/segment table (ri < 4), or one page for
+ * a page table (ri == 4). Returns a suitable region/segment table entry
+ * which points to the freshly allocated pages.
+ */
+static uint64_t virt_alloc_region(struct kvm_vm *vm, int ri, uint32_t memslot)
+{
+	uint64_t taddr;
+
+	taddr = vm_phy_pages_alloc(vm,  ri < 4 ? PAGES_PER_REGION : 1,
+				   KVM_GUEST_PAGE_TABLE_MIN_PADDR, memslot);
+	memset(addr_gpa2hva(vm, taddr), 0xff, PAGES_PER_REGION * vm->page_size);
+
+	return (taddr & REGION_ENTRY_ORIGIN)
+		| (((4 - ri) << 2) & REGION_ENTRY_TYPE)
+		| ((ri < 4 ? (PAGES_PER_REGION - 1) : 0) & REGION_ENTRY_LENGTH);
+}
+
+/*
+ * VM Virtual Page Map
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   gva - VM Virtual Address
+ *   gpa - VM Physical Address
+ *   memslot - Memory region slot for new virtual translation tables
+ *
+ * Output Args: None
+ *
+ * Return: None
+ *
+ * Within the VM given by vm, creates a virtual translation for the page
+ * starting at vaddr to the page starting at paddr.
+ */
+void virt_pg_map(struct kvm_vm *vm, uint64_t gva, uint64_t gpa,
+		 uint32_t memslot)
+{
+	int ri, idx;
+	uint64_t *entry;
+
+	TEST_ASSERT((gva % vm->page_size) == 0,
+		"Virtual address not on page boundary,\n"
+		"  vaddr: 0x%lx vm->page_size: 0x%x",
+		gva, vm->page_size);
+	TEST_ASSERT(sparsebit_is_set(vm->vpages_valid,
+		(gva >> vm->page_shift)),
+		"Invalid virtual address, vaddr: 0x%lx",
+		gva);
+	TEST_ASSERT((gpa % vm->page_size) == 0,
+		"Physical address not on page boundary,\n"
+		"  paddr: 0x%lx vm->page_size: 0x%x",
+		gva, vm->page_size);
+	TEST_ASSERT((gpa >> vm->page_shift) <= vm->max_gfn,
+		"Physical address beyond beyond maximum supported,\n"
+		"  paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
+		gva, vm->max_gfn, vm->page_size);
+
+	/* Walk through region and segment tables */
+	entry = addr_gpa2hva(vm, vm->pgd);
+	for (ri = 1; ri <= 4; ri++) {
+		idx = (gva >> (64 - 11 * ri)) & 0x7ffu;
+		if (entry[idx] & REGION_ENTRY_INVALID)
+			entry[idx] = virt_alloc_region(vm, ri, memslot);
+		entry = addr_gpa2hva(vm, entry[idx] & REGION_ENTRY_ORIGIN);
+	}
+
+	/* Fill in page table entry */
+	idx = (gva >> 12) & 0x0ffu;		/* page index */
+	if (!(entry[idx] & PAGE_INVALID))
+		fprintf(stderr,
+			"WARNING: PTE for gpa=0x%"PRIx64" already set!\n", gpa);
+	entry[idx] = gpa;
+}
+
+/*
+ * Address Guest Virtual to Guest Physical
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   gpa - VM virtual address
+ *
+ * Output Args: None
+ *
+ * Return:
+ *   Equivalent VM physical address
+ *
+ * Translates the VM virtual address given by gva to a VM physical
+ * address and then locates the memory region containing the VM
+ * physical address, within the VM given by vm.  When found, the host
+ * virtual address providing the memory to the vm physical address is
+ * returned.
+ * A TEST_ASSERT failure occurs if no region containing translated
+ * VM virtual address exists.
+ */
+vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
+{
+	int ri, idx;
+	uint64_t *entry;
+
+	TEST_ASSERT(vm->page_size == 4096, "Unsupported page size: 0x%x",
+		    vm->page_size);
+
+	entry = addr_gpa2hva(vm, vm->pgd);
+	for (ri = 1; ri <= 4; ri++) {
+		idx = (gva >> (64 - 11 * ri)) & 0x7ffu;
+		TEST_ASSERT(!(entry[idx] & REGION_ENTRY_INVALID),
+			    "No region mapping for vm virtual address 0x%lx",
+			    gva);
+		entry = addr_gpa2hva(vm, entry[idx] & REGION_ENTRY_ORIGIN);
+	}
+
+	idx = (gva >> 12) & 0x0ffu;		/* page index */
+
+	TEST_ASSERT(!(entry[idx] & PAGE_INVALID),
+		    "No page mapping for vm virtual address 0x%lx", gva);
+
+	return (entry[idx] & ~0xffful) + (gva & 0xffful);
+}
+
+static void virt_dump_ptes(FILE *stream, struct kvm_vm *vm, uint8_t indent,
+			   uint64_t ptea_start)
+{
+	uint64_t *pte, ptea;
+
+	for (ptea = ptea_start; ptea < ptea_start + 0x100 * 8; ptea += 8) {
+		pte = addr_gpa2hva(vm, ptea);
+		if (*pte & PAGE_INVALID)
+			continue;
+		fprintf(stream, "%*spte @ 0x%lx: 0x%016lx\n",
+			indent, "", ptea, *pte);
+	}
+}
+
+static void virt_dump_region(FILE *stream, struct kvm_vm *vm, uint8_t indent,
+			     uint64_t reg_tab_addr)
+{
+	uint64_t addr, *entry;
+
+	for (addr = reg_tab_addr; addr < reg_tab_addr + 0x400 * 8; addr += 8) {
+		entry = addr_gpa2hva(vm, addr);
+		if (*entry & REGION_ENTRY_INVALID)
+			continue;
+		fprintf(stream, "%*srt%lde @ 0x%lx: 0x%016lx\n",
+			indent, "", 4 - ((*entry & REGION_ENTRY_TYPE) >> 2),
+			addr, *entry);
+		if (*entry & REGION_ENTRY_TYPE) {
+			virt_dump_region(stream, vm, indent + 2,
+					 *entry & REGION_ENTRY_ORIGIN);
+		} else {
+			virt_dump_ptes(stream, vm, indent + 2,
+				       *entry & REGION_ENTRY_ORIGIN);
+		}
+	}
+}
+
+void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
+{
+	if (!vm->pgd_created)
+		return;
+
+	virt_dump_region(stream, vm, indent, vm->pgd);
+}
+
+/*
+ * Create a VM with reasonable defaults
+ *
+ * Input Args:
+ *   vcpuid - The id of the single VCPU to add to the VM.
+ *   extra_mem_pages - The size of extra memories to add (this will
+ *                     decide how much extra space we will need to
+ *                     setup the page tables using mem slot 0)
+ *   guest_code - The vCPU's entry point
+ *
+ * Output Args: None
+ *
+ * Return:
+ *   Pointer to opaque structure that describes the created VM.
+ */
+struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_pages,
+				 void *guest_code)
+{
+	/*
+	 * The additional amount of pages required for the page tables is:
+	 * 1 * n / 256 + 4 * (n / 256) / 2048 + 4 * (n / 256) / 2048^2 + ...
+	 * which is definitely smaller than (n / 256) * 2.
+	 */
+	uint64_t extra_pg_pages = extra_mem_pages / 256 * 2;
+	struct kvm_vm *vm;
+
+	vm = vm_create(VM_MODE_DEFAULT,
+		       DEFAULT_GUEST_PHY_PAGES + extra_pg_pages, O_RDWR);
+
+	kvm_vm_elf_load(vm, program_invocation_name, 0, 0);
+	vm_vcpu_add_default(vm, vcpuid, guest_code);
+
+	return vm;
+}
+
+/*
+ * Adds a vCPU with reasonable defaults (i.e. a stack and initial PSW)
+ *
+ * Input Args:
+ *   vcpuid - The id of the VCPU to add to the VM.
+ *   guest_code - The vCPU's entry point
+ */
+void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
+{
+	size_t stack_size =  DEFAULT_STACK_PGS * getpagesize();
+	uint64_t stack_vaddr;
+	struct kvm_regs regs;
+	struct kvm_sregs sregs;
+	struct kvm_run *run;
+
+	TEST_ASSERT(vm->page_size == 4096, "Unsupported page size: 0x%x",
+		    vm->page_size);
+
+	stack_vaddr = vm_vaddr_alloc(vm, stack_size,
+				     DEFAULT_GUEST_STACK_VADDR_MIN, 0, 0);
+
+	vm_vcpu_add(vm, vcpuid, 0, 0);
+
+	/* Setup guest registers */
+	vcpu_regs_get(vm, vcpuid, &regs);
+	regs.gprs[15] = stack_vaddr + (DEFAULT_STACK_PGS * getpagesize()) - 160;
+	vcpu_regs_set(vm, vcpuid, &regs);
+
+	vcpu_sregs_get(vm, vcpuid, &sregs);
+	sregs.crs[1] = vm->pgd | 0xf;		/* Primary region table */
+	vcpu_sregs_set(vm, vcpuid, &sregs);
+
+	run = vcpu_state(vm, vcpuid);
+	run->psw_mask = 0x0400000180000000ULL;  /* DAT enabled + 64 bit mode */
+	run->psw_addr = (uintptr_t)guest_code;
+}
+
+void vcpu_setup(struct kvm_vm *vm, int vcpuid, int pgd_memslot, int gdt_memslot)
+{
+	struct kvm_sregs sregs;
+
+	vcpu_sregs_get(vm, vcpuid, &sregs);
+	sregs.crs[0] |= 0x00040000;		/* Enable floating point regs */
+	vcpu_sregs_set(vm, vcpuid, &sregs);
+}
+
+void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
+{
+	struct vcpu *vcpu = vm->vcpu_head;
+
+	fprintf(stream, "%*spstate: psw: 0x%.16llx:0x%.16llx\n",
+		indent, "", vcpu->state->psw_mask, vcpu->state->psw_addr);
+}
-- 
2.21.0

