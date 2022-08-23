Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE57059EFEB
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 01:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbiHWXr7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 19:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232047AbiHWXr4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 19:47:56 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BEF88B2DA
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 16:47:51 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-333f0d49585so261435647b3.9
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 16:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:references
         :mime-version:message-id:in-reply-to:date:from:to:cc;
        bh=I8Zr0fHjs6tFdVuc2VGI95RBpJqerxBwW9Fm5Y2BygA=;
        b=EiU5tVjl8Hv2w237lwt8zmb03IoBeANwoHjaXtwRU+s+UPJEo3P4MzbCOKRBZQx0mi
         yhcVMwxhIWmVY/t9/h9FLQCa+kJwvZ8XHzeuR0rvWf31ye61GACKDOJsXnpwd80AfPaw
         3FT2u05D2Zfiflj6Kvsvz9T0+xoBlFiEg+HF2YkoMHL3P6p2mEDYIkgaO9KDeXhn7AjE
         WuwgJ/jDlbOhtugeCbd2NTKQXuT1ggKiYc55zoabUJTj2Ml1stf8zOOskzaBFXTVCI1W
         BQHHF3Q9S+LJmOeXf3ZN92QZ25FFwxPGMR0TfDTPUG4cmjxULixU/tk5cZDHqcDBdO5/
         /keA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:references
         :mime-version:message-id:in-reply-to:date:x-gm-message-state:from:to
         :cc;
        bh=I8Zr0fHjs6tFdVuc2VGI95RBpJqerxBwW9Fm5Y2BygA=;
        b=NY5QTYASOlzD5SjEUNbU8LTqdvJ2UYFsrBuD1iT5cOmD/2mk8gjaq92rF3BiGR83xt
         XEBmtZZlPZ/941GSTkCkSo6KmXRBnfZaUY9AMPGE20DABdf8QAJCzrHVpvtYSq0czowW
         kgI7rkhYzhHlrjt5b4CKVp5Fa6nHm51o8IKu1PNVAJs1ugCgHcUN2GzS46qiIV7rIZ9Z
         Q40QIcyIXFQokKsdvTBF+dhbaMBreKNSIC2dtzsjeXQmUZxKETfNDKKAPC/VTitchWv+
         7IvAc6wJGGzIFOco9/bF2CpAFUQb5bCsrA5jSemwp2fcppp0UnOy/KgNUTrCmWstHSJ9
         Wybw==
X-Gm-Message-State: ACgBeo2LlOjDkCyeZer0jwbqUaC3iHCN72BMBkyI0LN0gsuP+Zy2ROgB
        Gk2PUri87M+f8NWqPKnNr80R0olYIJPaKLrMujF9qyd/gLTFmg/yneB0OKGnOAzHBEdTE9nZ1zx
        +03hLCOKGYNbtaxb1rkJ6ApxPfwQgzHAb1NSzkM4xyimJmmcPz8NEEDVQLpqAiUo=
X-Google-Smtp-Source: AA6agR6YkHJNNfCXQUDUxyUQ4dQnPUA+kqX4y7zmYkg4gCENtX1KbPmnqdE0XVbew0OZzwKYmNx16gfkdnNmaA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:4b57:0:b0:338:16a:7a01 with SMTP id
 y84-20020a814b57000000b00338016a7a01mr23535425ywa.362.1661298470734; Tue, 23
 Aug 2022 16:47:50 -0700 (PDT)
Date:   Tue, 23 Aug 2022 23:47:23 +0000
In-Reply-To: <20220823234727.621535-1-ricarkol@google.com>
Message-Id: <20220823234727.621535-10-ricarkol@google.com>
Mime-Version: 1.0
References: <20220823234727.621535-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v5 09/13] KVM: selftests: aarch64: Add aarch64/page_fault_test
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatclack@google.com, axelrasmussen@google.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a new test for stage 2 faults when using different combinations of
guest accesses (e.g., write, S1PTW), backing source type (e.g., anon)
and types of faults (e.g., read on hugetlbfs with a hole). The next
commits will add different handling methods and more faults (e.g., uffd
and dirty logging). This first commit starts by adding two sanity checks
for all types of accesses: AF setting by the hw, and accessing memslots
with holes.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/page_fault_test.c   | 620 ++++++++++++++++++
 .../selftests/kvm/include/aarch64/processor.h |   8 +
 3 files changed, 629 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/aarch64/page_fault_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests=
/kvm/Makefile
index 1bb471aeb103..850e317b9e82 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -149,6 +149,7 @@ TEST_GEN_PROGS_aarch64 +=3D aarch64/arch_timer
 TEST_GEN_PROGS_aarch64 +=3D aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 +=3D aarch64/get-reg-list
 TEST_GEN_PROGS_aarch64 +=3D aarch64/hypercalls
+TEST_GEN_PROGS_aarch64 +=3D aarch64/page_fault_test
 TEST_GEN_PROGS_aarch64 +=3D aarch64/psci_test
 TEST_GEN_PROGS_aarch64 +=3D aarch64/vcpu_width_config
 TEST_GEN_PROGS_aarch64 +=3D aarch64/vgic_init
diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/=
testing/selftests/kvm/aarch64/page_fault_test.c
new file mode 100644
index 000000000000..6869b06facf9
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -0,0 +1,620 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * page_fault_test.c - Test stage 2 faults.
+ *
+ * This test tries different combinations of guest accesses (e.g., write,
+ * S1PTW), backing source type (e.g., anon) and types of faults (e.g., rea=
d on
+ * hugetlbfs with a hole). It checks that the expected handling method is
+ * called (e.g., uffd faults with the right address and write/read flag).
+ */
+
+#define _GNU_SOURCE
+#include <linux/bitmap.h>
+#include <fcntl.h>
+#include <test_util.h>
+#include <kvm_util.h>
+#include <processor.h>
+#include <asm/sysreg.h>
+#include <linux/bitfield.h>
+#include "guest_modes.h"
+#include "userfaultfd_util.h"
+
+/* Guest virtual addresses that point to the test page and its PTE. */
+#define TEST_GVA				0xc0000000
+#define TEST_EXEC_GVA				0xc0000008
+#define TEST_PTE_GVA				0xb0000000
+#define TEST_DATA				0x0123456789ABCDEF
+
+static uint64_t *guest_test_memory =3D (uint64_t *)TEST_GVA;
+
+#define CMD_NONE				(0)
+#define CMD_SKIP_TEST				(1ULL << 1)
+#define CMD_HOLE_PT				(1ULL << 2)
+#define CMD_HOLE_DATA				(1ULL << 3)
+
+#define PREPARE_FN_NR				10
+#define CHECK_FN_NR				10
+
+struct test_desc {
+	const char *name;
+	uint64_t mem_mark_cmd;
+	/* Skip the test if any prepare function returns false */
+	bool (*guest_prepare[PREPARE_FN_NR])(void);
+	void (*guest_test)(void);
+	void (*guest_test_check[CHECK_FN_NR])(void);
+	void (*dabt_handler)(struct ex_regs *regs);
+	void (*iabt_handler)(struct ex_regs *regs);
+	uint32_t pt_memslot_flags;
+	uint32_t data_memslot_flags;
+	bool skip;
+};
+
+struct test_params {
+	enum vm_mem_backing_src_type src_type;
+	struct test_desc *test_desc;
+};
+
+static inline void flush_tlb_page(uint64_t vaddr)
+{
+	uint64_t page =3D vaddr >> 12;
+
+	dsb(ishst);
+	asm volatile("tlbi vaae1is, %0" :: "r" (page));
+	dsb(ish);
+	isb();
+}
+
+static void guest_write64(void)
+{
+	uint64_t val;
+
+	WRITE_ONCE(*guest_test_memory, TEST_DATA);
+	val =3D READ_ONCE(*guest_test_memory);
+	GUEST_ASSERT_EQ(val, TEST_DATA);
+}
+
+/* Check the system for atomic instructions. */
+static bool guest_check_lse(void)
+{
+	uint64_t isar0 =3D read_sysreg(id_aa64isar0_el1);
+	uint64_t atomic;
+
+	atomic =3D FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR0_ATOMICS), isar0);
+	return atomic >=3D 2;
+}
+
+static bool guest_check_dc_zva(void)
+{
+	uint64_t dczid =3D read_sysreg(dczid_el0);
+	uint64_t dzp =3D FIELD_GET(ARM64_FEATURE_MASK(DCZID_DZP), dczid);
+
+	return dzp =3D=3D 0;
+}
+
+/* Compare and swap instruction. */
+static void guest_cas(void)
+{
+	uint64_t val;
+
+	GUEST_ASSERT(guest_check_lse());
+	asm volatile(".arch_extension lse\n"
+		     "casal %0, %1, [%2]\n"
+			:: "r" (0), "r" (TEST_DATA), "r" (guest_test_memory));
+	val =3D READ_ONCE(*guest_test_memory);
+	GUEST_ASSERT_EQ(val, TEST_DATA);
+}
+
+static void guest_read64(void)
+{
+	uint64_t val;
+
+	val =3D READ_ONCE(*guest_test_memory);
+	GUEST_ASSERT_EQ(val, 0);
+}
+
+/* Address translation instruction */
+static void guest_at(void)
+{
+	uint64_t par;
+
+	asm volatile("at s1e1r, %0" :: "r" (guest_test_memory));
+	par =3D read_sysreg(par_el1);
+	isb();
+
+	/* Bit 1 indicates whether the AT was successful */
+	GUEST_ASSERT_EQ(par & 1, 0);
+}
+
+/*
+ * The size of the block written by "dc zva" is guaranteed to be between (=
2 <<
+ * 0) and (2 << 9), which is safe in our case as we need the write to happ=
en
+ * for at least a word, and not more than a page.
+ */
+static void guest_dc_zva(void)
+{
+	uint16_t val;
+
+	asm volatile("dc zva, %0" :: "r" (guest_test_memory));
+	dsb(ish);
+	val =3D READ_ONCE(*guest_test_memory);
+	GUEST_ASSERT_EQ(val, 0);
+}
+
+/*
+ * Pre-indexing loads and stores don't have a valid syndrome (ESR_EL2.ISV=
=3D=3D0).
+ * And that's special because KVM must take special care with those: they
+ * should still count as accesses for dirty logging or user-faulting, but
+ * should be handled differently on mmio.
+ */
+static void guest_ld_preidx(void)
+{
+	uint64_t val;
+	uint64_t addr =3D TEST_GVA - 8;
+
+	/*
+	 * This ends up accessing "TEST_GVA + 8 - 8", where "TEST_GVA - 8" is
+	 * in a gap between memslots not backing by anything.
+	 */
+	asm volatile("ldr %0, [%1, #8]!"
+			: "=3Dr" (val), "+r" (addr));
+	GUEST_ASSERT_EQ(val, 0);
+	GUEST_ASSERT_EQ(addr, TEST_GVA);
+}
+
+static void guest_st_preidx(void)
+{
+	uint64_t val =3D TEST_DATA;
+	uint64_t addr =3D TEST_GVA - 8;
+
+	asm volatile("str %0, [%1, #8]!"
+			: "+r" (val), "+r" (addr));
+
+	GUEST_ASSERT_EQ(addr, TEST_GVA);
+	val =3D READ_ONCE(*guest_test_memory);
+}
+
+static bool guest_set_ha(void)
+{
+	uint64_t mmfr1 =3D read_sysreg(id_aa64mmfr1_el1);
+	uint64_t hadbs, tcr;
+
+	/* Skip if HA is not supported. */
+	hadbs =3D FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR1_HADBS), mmfr1);
+	if (hadbs =3D=3D 0)
+		return false;
+
+	tcr =3D read_sysreg(tcr_el1) | TCR_EL1_HA;
+	write_sysreg(tcr, tcr_el1);
+	isb();
+
+	return true;
+}
+
+static bool guest_clear_pte_af(void)
+{
+	*((uint64_t *)TEST_PTE_GVA) &=3D ~PTE_AF;
+	flush_tlb_page(TEST_GVA);
+
+	return true;
+}
+
+static void guest_check_pte_af(void)
+{
+	dsb(ish);
+	GUEST_ASSERT_EQ(*((uint64_t *)TEST_PTE_GVA) & PTE_AF, PTE_AF);
+}
+
+static void guest_exec(void)
+{
+	int (*code)(void) =3D (int (*)(void))TEST_EXEC_GVA;
+	int ret;
+
+	ret =3D code();
+	GUEST_ASSERT_EQ(ret, 0x77);
+}
+
+static bool guest_prepare(struct test_desc *test)
+{
+	bool (*prepare_fn)(void);
+	int i;
+
+	for (i =3D 0; i < PREPARE_FN_NR; i++) {
+		prepare_fn =3D test->guest_prepare[i];
+		if (prepare_fn && !prepare_fn())
+			return false;
+	}
+
+	return true;
+}
+
+static void guest_test_check(struct test_desc *test)
+{
+	void (*check_fn)(void);
+	int i;
+
+	for (i =3D 0; i < CHECK_FN_NR; i++) {
+		check_fn =3D test->guest_test_check[i];
+		if (check_fn)
+			check_fn();
+	}
+}
+
+static void guest_code(struct test_desc *test)
+{
+	if (!guest_prepare(test))
+		GUEST_SYNC(CMD_SKIP_TEST);
+
+	GUEST_SYNC(test->mem_mark_cmd);
+
+	if (test->guest_test)
+		test->guest_test();
+
+	guest_test_check(test);
+	GUEST_DONE();
+}
+
+static void no_dabt_handler(struct ex_regs *regs)
+{
+	GUEST_ASSERT_1(false, read_sysreg(far_el1));
+}
+
+static void no_iabt_handler(struct ex_regs *regs)
+{
+	GUEST_ASSERT_1(false, regs->pc);
+}
+
+/* Returns true to continue the test, and false if it should be skipped. *=
/
+static bool punch_hole_in_memslot(struct kvm_vm *vm,
+				  struct userspace_mem_region *region)
+{
+	void *hva =3D (void *)region->region.userspace_addr;
+	uint64_t paging_size =3D region->region.memory_size;
+	int ret, fd =3D region->fd;
+
+	if (fd !=3D -1) {
+		ret =3D fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+				0, paging_size);
+		TEST_ASSERT(ret =3D=3D 0, "fallocate failed, errno: %d\n", errno);
+	} else {
+		if (is_backing_src_hugetlb(region->backing_src_type))
+			return false;
+
+		ret =3D madvise(hva, paging_size, MADV_DONTNEED);
+		TEST_ASSERT(ret =3D=3D 0, "madvise failed, errno: %d\n", errno);
+	}
+
+	return true;
+}
+
+/* Returns true to continue the test, and false if it should be skipped. *=
/
+static bool handle_cmd(struct kvm_vm *vm, int cmd)
+{
+	struct userspace_mem_region *data_region, *pt_region;
+	bool continue_test =3D true;
+
+	data_region =3D vm_get_data_region(vm);
+	pt_region =3D vm_get_pt_region(vm);
+
+	if (cmd =3D=3D CMD_SKIP_TEST)
+		continue_test =3D false;
+
+	if (cmd & CMD_HOLE_PT)
+		continue_test =3D punch_hole_in_memslot(vm, pt_region);
+	if (cmd & CMD_HOLE_DATA)
+		continue_test =3D punch_hole_in_memslot(vm, data_region);
+
+	return continue_test;
+}
+
+extern unsigned char __exec_test;
+
+void noinline __return_0x77(void)
+{
+	asm volatile("__exec_test: mov x0, #0x77\n"
+			"ret\n");
+}
+
+/*
+ * Note that this function runs on the host before the test VM starts: the=
re's
+ * no need to sync the D$ and I$ caches.
+ */
+static void load_exec_code_for_test(struct kvm_vm *vm)
+{
+	uint64_t *code, *c;
+	struct userspace_mem_region *region =3D vm_get_data_region(vm);
+	void *hva =3D (void *)region->region.userspace_addr;
+
+	assert(TEST_EXEC_GVA - TEST_GVA);
+	code =3D hva + 8;
+
+	/*
+	 * We need the cast to be separate in order for the compiler to not
+	 * complain with: "=E2=80=98memcpy=E2=80=99 forming offset [1, 7] is out =
of the bounds
+	 * [0, 1] of object =E2=80=98__exec_test=E2=80=99 with type =E2=80=98unsi=
gned char=E2=80=99"
+	 */
+	c =3D (uint64_t *)&__exec_test;
+	memcpy(code, c, 8);
+}
+
+static void setup_abort_handlers(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
+		struct test_desc *test)
+{
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vcpu);
+
+	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
+			ESR_EC_DABT, no_dabt_handler);
+	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
+			ESR_EC_IABT, no_iabt_handler);
+}
+
+static void setup_gva_maps(struct kvm_vm *vm)
+{
+	struct userspace_mem_region *region =3D vm_get_data_region(vm);
+	uint64_t pte_gpa;
+
+	/* Map TEST_GVA first. This will install a new PTE. */
+	virt_pg_map(vm, TEST_GVA, region->region.guest_phys_addr);
+	/* Then map TEST_PTE_GVA to the above PTE. */
+	pte_gpa =3D addr_hva2gpa(vm, virt_get_pte_hva(vm, TEST_GVA));
+	virt_pg_map(vm, TEST_PTE_GVA, pte_gpa);
+}
+
+unsigned long get_max_gfn(enum vm_guest_mode mode)
+{
+	unsigned int pa_bits =3D vm_guest_mode_params[mode].pa_bits;
+	unsigned int page_shift =3D vm_guest_mode_params[mode].page_shift;
+
+	return ((1ULL << pa_bits) >> page_shift) - 1;
+}
+
+/* Create a code memslot at pfn=3D0, and data and PT ones at max_gfn. */
+static struct kvm_vm_mem_params setup_memslots(enum vm_guest_mode mode,
+					       struct test_params *p)
+{
+	uint64_t backing_src_pagesz =3D get_backing_src_pagesz(p->src_type);
+	uint64_t guest_page_size =3D vm_guest_mode_params[mode].page_size;
+	uint64_t max_gfn =3D get_max_gfn(mode);
+	/* Enough for 2M of code when using 4K guest pages. */
+	uint64_t code_npages =3D 512;
+	uint64_t pt_size, data_size, data_gpa;
+
+	/*
+	 * This test requires 1 pgd, 2 pud, 4 pmd, and 6 pte pages when using
+	 * VM_MODE_P48V48_4K. Note that the .text takes ~1.6MBs.  That's 13
+	 * pages. VM_MODE_P48V48_4K is the mode with most PT pages; let's use
+	 * twice that just in case.
+	 */
+	pt_size =3D 26 * guest_page_size;
+
+	/* memslot sizes and gpa's must be aligned to the backing page size */
+	pt_size =3D align_up(pt_size, backing_src_pagesz);
+	data_size =3D align_up(guest_page_size, backing_src_pagesz);
+	data_gpa =3D (max_gfn * guest_page_size) - data_size;
+	data_gpa =3D align_down(data_gpa, backing_src_pagesz);
+
+	struct kvm_vm_mem_params mem_params =3D {
+		.region[0] =3D {
+			.src_type =3D VM_MEM_SRC_ANONYMOUS,
+			.guest_paddr =3D 0,
+			.slot =3D 0,
+			.npages =3D code_npages,
+			.flags =3D 0,
+			.enabled =3D true,
+		},
+		.region[1] =3D {
+			.src_type =3D p->src_type,
+			.guest_paddr =3D data_gpa - pt_size,
+			.slot =3D 1,
+			.npages =3D pt_size / guest_page_size,
+			.flags =3D p->test_desc->pt_memslot_flags,
+			.enabled =3D true,
+		},
+		.region[2] =3D {
+			.src_type =3D p->src_type,
+			.guest_paddr =3D data_gpa,
+			.slot =3D 2,
+			.npages =3D data_size / guest_page_size,
+			.flags =3D p->test_desc->data_memslot_flags,
+			.enabled =3D true,
+		},
+		.region_idx =3D {
+			.code =3D 0,
+			.pt =3D 1,
+			.data =3D 2,
+		},
+		.mode =3D mode,
+	};
+
+	return mem_params;
+}
+
+static void print_test_banner(enum vm_guest_mode mode, struct test_params =
*p)
+{
+	struct test_desc *test =3D p->test_desc;
+
+	pr_debug("Test: %s\n", test->name);
+	pr_debug("Testing guest mode: %s\n", vm_guest_mode_string(mode));
+	pr_debug("Testing memory backing src type: %s\n",
+			vm_mem_backing_src_alias(p->src_type)->name);
+}
+
+/*
+ * This function either succeeds, skips the test (after setting test->skip=
), or
+ * fails with a TEST_FAIL that aborts all tests.
+ */
+static void vcpu_run_loop(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
+			  struct test_desc *test)
+{
+	struct ucall uc;
+
+	for (;;) {
+		vcpu_run(vcpu);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_SYNC:
+			if (!handle_cmd(vm, uc.args[1])) {
+				test->skip =3D true;
+				goto done;
+			}
+			break;
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT_2(uc, "values: %#lx, %#lx");
+			break;
+		case UCALL_DONE:
+			goto done;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
+	}
+
+done:
+	pr_debug(test->skip ? "Skipped.\n" : "Done.\n");
+	return;
+}
+
+static void run_test(enum vm_guest_mode mode, void *arg)
+{
+	struct test_params *p =3D (struct test_params *)arg;
+	struct test_desc *test =3D p->test_desc;
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm_mem_params mem_params;
+
+	print_test_banner(mode, p);
+
+	mem_params =3D setup_memslots(mode, p);
+	vm =3D ____vm_create(&mem_params);
+	kvm_vm_elf_load(vm, program_invocation_name);
+	vcpu =3D vm_vcpu_add(vm, 0, guest_code);
+
+	setup_gva_maps(vm);
+
+	ucall_init(vm, NULL);
+
+	load_exec_code_for_test(vm);
+	setup_abort_handlers(vm, vcpu, test);
+	vcpu_args_set(vcpu, 1, test);
+
+	vcpu_run_loop(vm, vcpu, test);
+
+	ucall_uninit(vm);
+	kvm_vm_free(vm);
+}
+
+static void help(char *name)
+{
+	puts("");
+	printf("usage: %s [-h] [-s mem-type]\n", name);
+	puts("");
+	guest_modes_help();
+	backing_src_help("-s");
+	puts("");
+}
+
+#define SNAME(s)			#s
+#define SCAT2(a, b)			SNAME(a ## _ ## b)
+#define SCAT3(a, b, c)			SCAT2(a, SCAT2(b, c))
+
+#define _CHECK(_test)			_CHECK_##_test
+#define _PREPARE(_test)			_PREPARE_##_test
+#define _PREPARE_guest_read64		NULL
+#define _PREPARE_guest_ld_preidx	NULL
+#define _PREPARE_guest_write64		NULL
+#define _PREPARE_guest_st_preidx	NULL
+#define _PREPARE_guest_exec		NULL
+#define _PREPARE_guest_at		NULL
+#define _PREPARE_guest_dc_zva		guest_check_dc_zva
+#define _PREPARE_guest_cas		guest_check_lse
+
+/* With or without access flag checks */
+#define _PREPARE_with_af		guest_set_ha, guest_clear_pte_af
+#define _PREPARE_no_af			NULL
+#define _CHECK_with_af			guest_check_pte_af
+#define _CHECK_no_af			NULL
+
+/* Performs an access and checks that no faults were triggered. */
+#define TEST_ACCESS(_access, _with_af, _mark_cmd)				\
+{										\
+	.name			=3D SCAT3(_access, _with_af, #_mark_cmd),		\
+	.guest_prepare		=3D { _PREPARE(_with_af),				\
+				    _PREPARE(_access) },			\
+	.mem_mark_cmd		=3D _mark_cmd,					\
+	.guest_test		=3D _access,					\
+	.guest_test_check	=3D { _CHECK(_with_af) },				\
+}
+
+static struct test_desc tests[] =3D {
+
+	/* Check that HW is setting the Access Flag (AF) (sanity checks). */
+	TEST_ACCESS(guest_read64, with_af, CMD_NONE),
+	TEST_ACCESS(guest_ld_preidx, with_af, CMD_NONE),
+	TEST_ACCESS(guest_cas, with_af, CMD_NONE),
+	TEST_ACCESS(guest_write64, with_af, CMD_NONE),
+	TEST_ACCESS(guest_st_preidx, with_af, CMD_NONE),
+	TEST_ACCESS(guest_dc_zva, with_af, CMD_NONE),
+	TEST_ACCESS(guest_exec, with_af, CMD_NONE),
+
+	/*
+	 * Accessing a hole in the data memslot (punched with fallocate or
+	 * madvise) shouldn't fault (more sanity checks).
+	 */
+	TEST_ACCESS(guest_read64, no_af, CMD_HOLE_DATA),
+	TEST_ACCESS(guest_cas, no_af, CMD_HOLE_DATA),
+	TEST_ACCESS(guest_ld_preidx, no_af, CMD_HOLE_DATA),
+	TEST_ACCESS(guest_write64, no_af, CMD_HOLE_DATA),
+	TEST_ACCESS(guest_st_preidx, no_af, CMD_HOLE_DATA),
+	TEST_ACCESS(guest_at, no_af, CMD_HOLE_DATA),
+	TEST_ACCESS(guest_dc_zva, no_af, CMD_HOLE_DATA),
+
+	{ 0 }
+};
+
+static void for_each_test_and_guest_mode(
+		void (*func)(enum vm_guest_mode m, void *a),
+		enum vm_mem_backing_src_type src_type)
+{
+	struct test_desc *t;
+
+	for (t =3D &tests[0]; t->name; t++) {
+		if (t->skip)
+			continue;
+
+		struct test_params p =3D {
+			.src_type =3D src_type,
+			.test_desc =3D t,
+		};
+
+		for_each_guest_mode(run_test, &p);
+	}
+}
+
+int main(int argc, char *argv[])
+{
+	enum vm_mem_backing_src_type src_type;
+	int opt;
+
+	setbuf(stdout, NULL);
+
+	src_type =3D DEFAULT_VM_MEM_SRC;
+
+	guest_modes_append_default();
+
+	while ((opt =3D getopt(argc, argv, "hm:s:")) !=3D -1) {
+		switch (opt) {
+		case 'm':
+			guest_modes_cmdline(optarg);
+			break;
+		case 's':
+			src_type =3D parse_backing_src_type(optarg);
+			break;
+		case 'h':
+		default:
+			help(argv[0]);
+			exit(0);
+		}
+	}
+
+	for_each_test_and_guest_mode(run_test, src_type);
+	return 0;
+}
diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tool=
s/testing/selftests/kvm/include/aarch64/processor.h
index c1ddca8db225..5f977528e09c 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -105,11 +105,19 @@ enum {
 #define ESR_EC_MASK		(ESR_EC_NUM - 1)
=20
 #define ESR_EC_SVC64		0x15
+#define ESR_EC_IABT		0x21
+#define ESR_EC_DABT		0x25
 #define ESR_EC_HW_BP_CURRENT	0x31
 #define ESR_EC_SSTEP_CURRENT	0x33
 #define ESR_EC_WP_CURRENT	0x35
 #define ESR_EC_BRK_INS		0x3c
=20
+/* Access flag */
+#define PTE_AF			(1ULL << 10)
+
+/* Access flag update enable/disable */
+#define TCR_EL1_HA		(1ULL << 39)
+
 void aarch64_get_supported_page_sizes(uint32_t ipa,
 				      bool *ps4k, bool *ps16k, bool *ps64k);
=20
--=20
2.37.1.595.g718a3a8f04-goog

