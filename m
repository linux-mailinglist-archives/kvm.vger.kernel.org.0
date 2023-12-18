Return-Path: <kvm+bounces-4739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AC8A81771C
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 17:13:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D7EC52852D4
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 16:13:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84F343D54B;
	Mon, 18 Dec 2023 16:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ty+ORmHh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA3442388
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 16:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--pgonda.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5c1b986082dso2250900a12.0
        for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 08:12:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702915959; x=1703520759; darn=vger.kernel.org;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6cslIywLm7lf5nZPMneVBjRtiwvItz2ktN/qxGpXzvk=;
        b=Ty+ORmHh4l/btXuS0fkmuAO11attHIyF0eXwlOhXXIzAiO2FZIAZvL4UTDZ2UqhULo
         QOm3djnAzZ9ra4MaqsHA3OeTb5c/x/yvqAGnq1flK6j3ahJJQAcsDm6lqVv4DM3qt+cx
         UvhinLOmWkMNrVBv/yAyGX3Bj20x9FjOj2xhggNaykk7g0g+ON2wzSX88iihoezsb/rk
         K+hMeo0lRu7u+W8pC9g2vq4/NpYjyCykU2XZQNha+2gDZAqUvi5SyrAj8sR/PU5lQ0hh
         jmHqHbwlv3zGKprtGiopE/fGynJXkaXiMF+FTC94h/0P72Q1nUVYviQ7R5R8AF3/xXPZ
         1E4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702915959; x=1703520759;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6cslIywLm7lf5nZPMneVBjRtiwvItz2ktN/qxGpXzvk=;
        b=wpdmvFz7JbHVJI81wV306eC2GWweCfoaZwtIH1Qh4vluhsIzJtDYETNntnbO2NBfRK
         nRWgSmvVvnVXXQMxpbEwaEVdyezF30SD+zZ8prBsLYKkZ1PZq0NZk3AETCPEAvJ+AVlN
         tgt20K6aHMIDqciXYA9TRyMQqgff7b3FVDh6uergSOphtR1CVgVwpuEK67kQtGbBlODB
         fdjgqtKCV57aPSmD9sVl+n2E7dPawCPugsyMmSqHmd0PUJeDY3UcI2s22obpO/NHr8Hq
         uOuWnfkS78aF0SoUm3Vb8/59FqVGfnuO8TtS9I68fKnHgWG62kIXtxfULsTbQ1840Hxw
         nC1A==
X-Gm-Message-State: AOJu0Yx94oMTkr1GFZKa5Gse5l1F9hgikeYrF+G9OgZQdqin8cHur9jh
	D6hab/RoPGluwc0O3+2Iwll/q4o5ReGb0gbCJeO0GgxPI9U65w4SUA/pJFV7tB34QmmbTTS5FpF
	zUvToqSRhuiEhdX/lrfuD+PT5Id5j04MQFDMT+G8ykShqskbf7e/0Qpm5lA==
X-Google-Smtp-Source: AGHT+IE2MI9NE3j2NMpTi9L9wDZ/EVwNklb6uZ0kOW2FKofzrHntq75jiSF3MKPCgHvCMJv8QwT4W2eDAis=
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:15:8aeb:e3fa:237c:63a5])
 (user=pgonda job=sendgmr) by 2002:a65:63d4:0:b0:5c6:27fc:1155 with SMTP id
 n20-20020a6563d4000000b005c627fc1155mr952713pgv.3.1702915958193; Mon, 18 Dec
 2023 08:12:38 -0800 (PST)
Date: Mon, 18 Dec 2023 08:11:44 -0800
In-Reply-To: <20231218161146.3554657-1-pgonda@google.com>
Message-Id: <20231218161146.3554657-7-pgonda@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231218161146.3554657-1-pgonda@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Subject: [PATCH V7 6/8] KVM: selftests: add library for creating/interacting
 with SEV guests
From: Peter Gonda <pgonda@google.com>
To: kvm@vger.kernel.org
Cc: Peter Gonda <pgonda@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerly Tng <ackerleytng@google.com>, Andrew Jones <andrew.jones@linux.dev>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="UTF-8"

Add interfaces to allow tests to create SEV guests. The additional
requirements for SEV guests PTs and other state is encapsulated by the
new vm_sev_create_with_one_vcpu() function. This can future be
generalized for more vCPUs but the first set of SEV selftests in this
series only uses a single vCPU.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Ackerly Tng <ackerleytng@google.com>
cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Michael Roth <michael.roth@amd.com>
Originally-by: Michael Roth <michael.roth@amd.com>
Co-developed-by: Ackerly Tng <ackerleytng@google.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 include/uapi/linux/kvm.h                      |   2 +-
 tools/arch/x86/include/asm/kvm_host.h         |   2 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/include/sparsebit.h |  22 ++
 .../selftests/kvm/include/x86_64/processor.h  |   2 +
 .../selftests/kvm/include/x86_64/sev.h        |  27 +++
 tools/testing/selftests/kvm/lib/kvm_util.c    |   1 +
 .../selftests/kvm/lib/x86_64/processor.c      |  16 ++
 tools/testing/selftests/kvm/lib/x86_64/sev.c  | 202 ++++++++++++++++++
 9 files changed, 274 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/sev.h
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/sev.c

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 13065dd96132..251f422bcaa7 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1660,7 +1660,7 @@ struct kvm_s390_ucas_mapping {
 #define KVM_S390_GET_CMMA_BITS      _IOWR(KVMIO, 0xb8, struct kvm_s390_cmma_log)
 #define KVM_S390_SET_CMMA_BITS      _IOW(KVMIO, 0xb9, struct kvm_s390_cmma_log)
 /* Memory Encryption Commands */
-#define KVM_MEMORY_ENCRYPT_OP      _IOWR(KVMIO, 0xba, unsigned long)
+#define KVM_MEMORY_ENCRYPT_OP      _IOWR(KVMIO, 0xba, struct kvm_sev_cmd)
 
 struct kvm_enc_region {
 	__u64 addr;
diff --git a/tools/arch/x86/include/asm/kvm_host.h b/tools/arch/x86/include/asm/kvm_host.h
index d8f48fe835fb..12a7902216be 100644
--- a/tools/arch/x86/include/asm/kvm_host.h
+++ b/tools/arch/x86/include/asm/kvm_host.h
@@ -8,6 +8,8 @@
 struct kvm_vm_arch {
 	uint64_t c_bit;
 	uint64_t s_bit;
+	int sev_fd;
+	bool is_pt_protected;
 };
 
 #endif  // _TOOLS_LINUX_ASM_X86_KVM_HOST_H
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index a3bb36fb3cfc..c932bcea4198 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -37,6 +37,7 @@ LIBKVM_x86_64 += lib/x86_64/handlers.S
 LIBKVM_x86_64 += lib/x86_64/hyperv.c
 LIBKVM_x86_64 += lib/x86_64/memstress.c
 LIBKVM_x86_64 += lib/x86_64/processor.c
+LIBKVM_x86_64 += lib/x86_64/sev.c
 LIBKVM_x86_64 += lib/x86_64/svm.c
 LIBKVM_x86_64 += lib/x86_64/ucall.c
 LIBKVM_x86_64 += lib/x86_64/vmx.c
diff --git a/tools/testing/selftests/kvm/include/sparsebit.h b/tools/testing/selftests/kvm/include/sparsebit.h
index fb5170d57fcb..a63577e53919 100644
--- a/tools/testing/selftests/kvm/include/sparsebit.h
+++ b/tools/testing/selftests/kvm/include/sparsebit.h
@@ -66,6 +66,28 @@ void sparsebit_dump(FILE *stream, const struct sparsebit *sbit,
 		    unsigned int indent);
 void sparsebit_validate_internal(const struct sparsebit *sbit);
 
+/*
+ * Iterate over set ranges within sparsebit @s. In each iteration,
+ * @range_begin and @range_end will take the beginning and end of the set
+ * range, which are of type sparsebit_idx_t.
+ *
+ * For example, if the range [3, 7] (inclusive) is set, within the
+ * iteration,@range_begin will take the value 3 and @range_end will take
+ * the value 7.
+ *
+ * Ensure that there is at least one bit set before using this macro with
+ * sparsebit_any_set(), because sparsebit_first_set() will abort if none
+ * are set.
+ */
+#define sparsebit_for_each_set_range(s, range_begin, range_end)         \
+	for (range_begin = sparsebit_first_set(s),                      \
+	     range_end =						\
+	     sparsebit_next_clear(s, range_begin) - 1;		\
+	     range_begin && range_end;                                  \
+	     range_begin = sparsebit_next_set(s, range_end),            \
+	     range_end =						\
+	     sparsebit_next_clear(s, range_begin) - 1)
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 4fd042112526..67cc32b1a29a 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -266,6 +266,7 @@ struct kvm_x86_cpu_property {
 #define X86_PROPERTY_MAX_PHY_ADDR		KVM_X86_CPU_PROPERTY(0x80000008, 0, EAX, 0, 7)
 #define X86_PROPERTY_MAX_VIRT_ADDR		KVM_X86_CPU_PROPERTY(0x80000008, 0, EAX, 8, 15)
 #define X86_PROPERTY_PHYS_ADDR_REDUCTION	KVM_X86_CPU_PROPERTY(0x8000001F, 0, EBX, 6, 11)
+#define X86_PROPERTY_SEV_C_BIT KVM_X86_CPU_PROPERTY(0x8000001F, 0, EBX, 0, 5)
 
 #define X86_PROPERTY_MAX_CENTAUR_LEAF		KVM_X86_CPU_PROPERTY(0xC0000000, 0, EAX, 0, 31)
 
@@ -1035,6 +1036,7 @@ do {											\
 } while (0)
 
 void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits);
+void kvm_init_vm_address_properties(struct kvm_vm *vm);
 bool vm_is_unrestricted_guest(struct kvm_vm *vm);
 
 struct ex_regs {
diff --git a/tools/testing/selftests/kvm/include/x86_64/sev.h b/tools/testing/selftests/kvm/include/x86_64/sev.h
new file mode 100644
index 000000000000..e212b032cd77
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/x86_64/sev.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Helpers used for SEV guests
+ *
+ */
+#ifndef SELFTEST_KVM_SEV_H
+#define SELFTEST_KVM_SEV_H
+
+#include <stdint.h>
+#include <stdbool.h>
+
+#include "kvm_util.h"
+
+#define CPUID_MEM_ENC_LEAF 0x8000001f
+#define CPUID_EBX_CBIT_MASK 0x3f
+
+#define SEV_POLICY_NO_DBG	(1UL << 0)
+#define SEV_POLICY_ES		(1UL << 2)
+
+bool is_kvm_sev_supported(void);
+
+void sev_vm_init(struct kvm_vm *vm);
+
+struct kvm_vm *vm_sev_create_with_one_vcpu(uint32_t policy, void *guest_code,
+					   struct kvm_vcpu **cpu);
+
+#endif /* SELFTEST_KVM_SEV_H */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 4a4ee1afd738..b758cc6497c7 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -266,6 +266,7 @@ struct kvm_vm *____vm_create(uint32_t mode)
 	case VM_MODE_PXXV48_4K:
 #ifdef __x86_64__
 		kvm_get_cpu_address_width(&vm->pa_bits, &vm->va_bits);
+		kvm_init_vm_address_properties(vm);
 		/*
 		 * Ignore KVM support for 5-level paging (vm->va_bits == 57),
 		 * it doesn't take effect unless a CR4.LA57 is set, which it
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index c18e2e9d3d75..4a3ce181a19f 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -9,6 +9,7 @@
 #include "test_util.h"
 #include "kvm_util.h"
 #include "processor.h"
+#include "sev.h"
 
 #ifndef NUM_INTERRUPTS
 #define NUM_INTERRUPTS 256
@@ -278,6 +279,9 @@ uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
 {
 	uint64_t *pml4e, *pdpe, *pde;
 
+	TEST_ASSERT(!vm->arch.is_pt_protected,
+		    "Walking page tables of protected guests is impossible");
+
 	TEST_ASSERT(*level >= PG_LEVEL_NONE && *level < PG_LEVEL_NUM,
 		    "Invalid PG_LEVEL_* '%d'", *level);
 
@@ -573,6 +577,9 @@ void kvm_arch_vm_post_create(struct kvm_vm *vm)
 	vm_create_irqchip(vm);
 	sync_global_to_guest(vm, host_cpu_is_intel);
 	sync_global_to_guest(vm, host_cpu_is_amd);
+
+	if (vm->subtype == VM_SUBTYPE_SEV)
+		sev_vm_init(vm);
 }
 
 struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
@@ -1054,6 +1061,15 @@ void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits)
 	}
 }
 
+void kvm_init_vm_address_properties(struct kvm_vm *vm)
+{
+	if (vm->subtype == VM_SUBTYPE_SEV) {
+		vm->protected = true;
+		vm->arch.c_bit = 1ULL << this_cpu_property(X86_PROPERTY_SEV_C_BIT);
+		vm->gpa_tag_mask = vm->arch.c_bit;
+	}
+}
+
 static void set_idt_entry(struct kvm_vm *vm, int vector, unsigned long addr,
 			  int dpl, unsigned short selector)
 {
diff --git a/tools/testing/selftests/kvm/lib/x86_64/sev.c b/tools/testing/selftests/kvm/lib/x86_64/sev.c
new file mode 100644
index 000000000000..f2bac717cac1
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/x86_64/sev.c
@@ -0,0 +1,202 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#define _GNU_SOURCE /* for program_invocation_short_name */
+#include <stdint.h>
+#include <stdbool.h>
+
+#include "kvm_util.h"
+#include "svm_util.h"
+#include "linux/psp-sev.h"
+#include "processor.h"
+#include "sev.h"
+
+#define SEV_FW_REQ_VER_MAJOR 0
+#define SEV_FW_REQ_VER_MINOR 17
+
+enum sev_guest_state {
+	SEV_GSTATE_UNINIT = 0,
+	SEV_GSTATE_LUPDATE,
+	SEV_GSTATE_LSECRET,
+	SEV_GSTATE_RUNNING,
+};
+
+static void sev_ioctl(int cmd, void *data)
+{
+	int sev_fd = open_sev_dev_path_or_exit();
+	struct sev_issue_cmd arg = {
+		.cmd = cmd,
+		.data = (unsigned long)data,
+	};
+
+	kvm_ioctl(sev_fd, SEV_ISSUE_CMD, &arg);
+	close(sev_fd);
+}
+
+static void kvm_sev_ioctl(struct kvm_vm *vm, int cmd, void *data)
+{
+	struct kvm_sev_cmd sev_cmd = {
+		.id = cmd,
+		.sev_fd = vm->arch.sev_fd,
+		.data = (unsigned long)data,
+	};
+
+	vm_ioctl(vm, KVM_MEMORY_ENCRYPT_OP, &sev_cmd);
+}
+
+static void sev_register_encrypted_memory(struct kvm_vm *vm,
+					  struct userspace_mem_region *region)
+{
+	struct kvm_enc_region range = {
+		.addr = region->region.userspace_addr,
+		.size = region->region.memory_size,
+	};
+
+	vm_ioctl(vm, KVM_MEMORY_ENCRYPT_REG_REGION, &range);
+}
+
+static void sev_launch_update_data(struct kvm_vm *vm, vm_paddr_t gpa,
+				   uint64_t size)
+{
+	struct kvm_sev_launch_update_data update_data = {
+		.uaddr = (unsigned long)addr_gpa2hva(vm, gpa),
+		.len = size,
+	};
+
+	kvm_sev_ioctl(vm, KVM_SEV_LAUNCH_UPDATE_DATA, &update_data);
+}
+
+/*
+ * sparsebit_next_clear() can return 0 if [x, 2**64-1] are all set, and the
+ * -1 would then cause an underflow back to 2**64 - 1. This is expected and
+ * correct.
+ *
+ * If the last range in the sparsebit is [x, y] and we try to iterate,
+ * sparsebit_next_set() will return 0, and sparsebit_next_clear() will try
+ * and find the first range, but that's correct because the condition
+ * expression would cause us to quit the loop.
+ */
+static void encrypt_region(struct kvm_vm *vm, struct userspace_mem_region *region)
+{
+	const struct sparsebit *protected_phy_pages = region->protected_phy_pages;
+	const vm_paddr_t gpa_base = region->region.guest_phys_addr;
+	const sparsebit_idx_t lowest_page_in_region = gpa_base >> vm->page_shift;
+	sparsebit_idx_t i, j;
+
+	if (!sparsebit_any_set(protected_phy_pages))
+		return;
+
+	sev_register_encrypted_memory(vm, region);
+
+	sparsebit_for_each_set_range(protected_phy_pages, i, j) {
+		const uint64_t size = (j - i + 1) * vm->page_size;
+		const uint64_t offset = (i - lowest_page_in_region) * vm->page_size;
+
+		sev_launch_update_data(vm, gpa_base + offset, size);
+	}
+}
+
+bool is_kvm_sev_supported(void)
+{
+	struct sev_user_data_status sev_status;
+
+	sev_ioctl(SEV_PLATFORM_STATUS, &sev_status);
+
+	return sev_status.api_major > SEV_FW_REQ_VER_MAJOR ||
+	       (sev_status.api_major == SEV_FW_REQ_VER_MAJOR &&
+		sev_status.api_minor >= SEV_FW_REQ_VER_MINOR);
+}
+
+static void sev_vm_launch(struct kvm_vm *vm, uint32_t policy)
+{
+	struct kvm_sev_launch_start launch_start = {
+		.policy = policy,
+	};
+	struct userspace_mem_region *region;
+	struct kvm_sev_guest_status status;
+	int ctr;
+
+	kvm_sev_ioctl(vm, KVM_SEV_LAUNCH_START, &launch_start);
+	kvm_sev_ioctl(vm, KVM_SEV_GUEST_STATUS, &status);
+
+	TEST_ASSERT(status.policy == policy, "Expected policy %d, got %d",
+		    policy, status.policy);
+	TEST_ASSERT(status.state == SEV_GSTATE_LUPDATE,
+		    "Expected guest state %d, got %d",
+		    SEV_GSTATE_LUPDATE, status.state);
+
+	hash_for_each(vm->regions.slot_hash, ctr, region, slot_node)
+		encrypt_region(vm, region);
+
+	vm->arch.is_pt_protected = true;
+}
+
+static void sev_vm_launch_measure(struct kvm_vm *vm, uint8_t *measurement)
+{
+	struct kvm_sev_launch_measure launch_measure;
+	struct kvm_sev_guest_status guest_status;
+
+	launch_measure.len = 256;
+	launch_measure.uaddr = (__u64)measurement;
+	kvm_sev_ioctl(vm, KVM_SEV_LAUNCH_MEASURE, &launch_measure);
+
+	kvm_sev_ioctl(vm, KVM_SEV_GUEST_STATUS, &guest_status);
+	TEST_ASSERT(guest_status.state == SEV_GSTATE_LSECRET,
+		    "Unexpected guest state: %d", guest_status.state);
+}
+
+static void sev_vm_launch_finish(struct kvm_vm *vm)
+{
+	struct kvm_sev_guest_status status;
+
+	kvm_sev_ioctl(vm, KVM_SEV_GUEST_STATUS, &status);
+	TEST_ASSERT(status.state == SEV_GSTATE_LUPDATE ||
+		    status.state == SEV_GSTATE_LSECRET,
+		    "Unexpected guest state: %d", status.state);
+
+	kvm_sev_ioctl(vm, KVM_SEV_LAUNCH_FINISH, NULL);
+
+	kvm_sev_ioctl(vm, KVM_SEV_GUEST_STATUS, &status);
+	TEST_ASSERT(status.state == SEV_GSTATE_RUNNING,
+		    "Unexpected guest state: %d", status.state);
+}
+
+static void sev_vm_measure(struct kvm_vm *vm)
+{
+	uint8_t measurement[512];
+	int i;
+
+	sev_vm_launch_measure(vm, measurement);
+
+	/* TODO: Validate the measurement is as expected. */
+	pr_debug("guest measurement: ");
+	for (i = 0; i < 32; ++i)
+		pr_debug("%02x", measurement[i]);
+	pr_debug("\n");
+}
+
+void sev_vm_init(struct kvm_vm *vm)
+{
+	vm->arch.sev_fd = open_sev_dev_path_or_exit();
+
+	kvm_sev_ioctl(vm, KVM_SEV_INIT, NULL);
+}
+
+struct kvm_vm *vm_sev_create_with_one_vcpu(uint32_t policy, void *guest_code,
+					   struct kvm_vcpu **cpu)
+{
+	uint32_t mode = VM_MODE_PXXV48_4K | VM_SUBTYPE_SEV << VM_MODE_SUBTYPE_SHIFT;
+	struct kvm_vm *vm;
+	struct kvm_vcpu *cpus[1];
+
+	vm = __vm_create_with_vcpus(mode, 1, 0, guest_code, cpus);
+	*cpu = cpus[0];
+
+	sev_vm_launch(vm, policy);
+
+	sev_vm_measure(vm);
+
+	sev_vm_launch_finish(vm);
+
+	pr_debug("SEV guest created, policy: 0x%x\n", policy);
+
+	return vm;
+}
-- 
2.43.0.472.g3155946c3a-goog


