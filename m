Return-Path: <kvm+bounces-1544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25A847E94DA
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 03:32:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 74B5BB20A33
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 02:32:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65E37F9FB;
	Mon, 13 Nov 2023 02:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="Wqdj2+CU"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 425D88C11
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 02:31:55 +0000 (UTC)
X-Greylist: delayed 426 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 12 Nov 2023 18:31:51 PST
Received: from smtp-1909.mail.infomaniak.ch (smtp-1909.mail.infomaniak.ch [185.125.25.9])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A2310C
	for <kvm@vger.kernel.org>; Sun, 12 Nov 2023 18:31:51 -0800 (PST)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
	by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4STCtW49lkzMq2Gn;
	Mon, 13 Nov 2023 02:24:35 +0000 (UTC)
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4STCtV157dz3W;
	Mon, 13 Nov 2023 03:24:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1699842275;
	bh=o9nqKbiugyVsavDfBV6aqCgZeoXT/7P+XJT3zGIQ/Fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wqdj2+CUV44d4HuZMwuSPZXcGHSanzUo3Ulx4D8YehMH9U5vcbFl7jLW7UcFqNia4
	 y2LVudO16hFYsUqLi3Nu+P7n0Bmi1mQVJg9RF5u2Z1azQ1wphiWgO5ISohde0JzGD5
	 Oin1vdzYOHYknvXN+6DvT1FtaqYxe8GF44LgGvKQ=
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Kees Cook <keescook@chromium.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Alexander Graf <graf@amazon.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	Forrest Yuan Yu <yuanyu@google.com>,
	James Gowans <jgowans@amazon.com>,
	James Morris <jamorris@linux.microsoft.com>,
	John Andersen <john.s.andersen@intel.com>,
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
	Marian Rotariu <marian.c.rotariu@gmail.com>,
	=?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
	=?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
	Thara Gopinath <tgopinath@microsoft.com>,
	Trilok Soni <quic_tsoni@quicinc.com>,
	Wei Liu <wei.liu@kernel.org>,
	Will Deacon <will@kernel.org>,
	Yu Zhang <yu.c.zhang@linux.intel.com>,
	Zahra Tarkhani <ztarkhani@microsoft.com>,
	=?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
	dev@lists.cloudhypervisor.org,
	kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	qemu-devel@nongnu.org,
	virtualization@lists.linux-foundation.org,
	x86@kernel.org,
	xen-devel@lists.xenproject.org
Subject: [RFC PATCH v2 11/19] KVM: x86: Add new hypercall to set EPT permissions
Date: Sun, 12 Nov 2023 21:23:18 -0500
Message-ID: <20231113022326.24388-12-mic@digikod.net>
In-Reply-To: <20231113022326.24388-1-mic@digikod.net>
References: <20231113022326.24388-1-mic@digikod.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha

From: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>

Add a new KVM_HC_PROTECT_MEMORY hypercall that enables a guest to set
EPT permissions for guest pages.

Until now, all of the guest pages (except Page Tracked pages) are given
RWX permissions in the EPT. In Heki, we want to restrict the permissions
to what is strictly needed. For instance, a text page only needs R_X. A
read-only data page only needs R__. A normal data page only needs RW_.

The guest will pass a page list to the hypercall. The page list is a
list of one or more physical pages each of which contains a array of
guest ranges and attributes. Currently, the attributes only contain
permissions. In the future, other attributes may be added.  The
hypervisor will apply the specified permissions in the EPT.

When a guest try to access its memory in a way which is not allowed, KVM
creates a synthetic kernel page fault. This fault should be handled by
the guest, which is not currently the case, making it try again and
again.  This will be part of a follow-up patch series.

When enabled, KASAN reveals a bug in the memory attributes patches. We
didn't find the source of this issue yet.

Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Co-developed-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---

Changes since v1:

The original hypercall contained support for statically defined sections
(text, rodata, etc). It has been redesigned like this:

- The previous version accepted an array of physically contiguous
  ranges. This is appropriate for statically defined sections which are
  loaded in contiguous memory.  But, for other cases like module
  loading, the pages would be discontiguous. The current version of the
  hypercall accepts a page list to fix this.

- The previous version passed permission combinations. E.g.,
  HEKI_MEM_ATTR_EXEC would imply R_X. The current version passes
  permissions as memory attributes and each of the permissions must be
  separately specified. E.g., for text, (MEM_ATTR_READ | MEM_ATTR_EXEC)
  must be passed.

- The previous version locked down the permissions for guest pages so
  that once the permissions are set, they cannot be changed. In this
  version, permissions can be changed dynamically, except when the
  MEM_ATTR_IMMUTABLE is set.  So, the hypercall has been renamed from
  KVM_HC_LOCK_MEM_PAGE_RANGES to KVM_HC_PROTECT_MEMORY. The dynamic
  setting of permissions is needed by the following features (probably
  not a complete list):
  - Kprobes and Optprobes
  - Static call optimization
  - Jump Label optimization
  - Ftrace and Livepatch
  - Module loading and unloading
  - eBPF JIT
  - Kexec
  - Kgdb

Examples:
- A text page can be made writable very briefly to install a probe or a
  trace.
- eBPF JIT can populate a writable page with code and make it
  read-execute.
- Module load can load read-only data into a writable page and make the
  page read-only.
- When pages are unmapped, their permissions in the EPT must revert to
  read-write.
---
 Documentation/virt/kvm/x86/hypercalls.rst |  14 +++
 arch/x86/kvm/mmu/mmu.c                    |  77 +++++++++++++
 arch/x86/kvm/mmu/paging_tmpl.h            |   3 +
 arch/x86/kvm/mmu/spte.c                   |  15 ++-
 arch/x86/kvm/x86.c                        | 130 ++++++++++++++++++++++
 include/linux/heki.h                      |  29 +++++
 include/uapi/linux/kvm_para.h             |   1 +
 7 files changed, 267 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/x86/hypercalls.rst b/Documentation/virt/kvm/x86/hypercalls.rst
index 3178576f4c47..28865d111773 100644
--- a/Documentation/virt/kvm/x86/hypercalls.rst
+++ b/Documentation/virt/kvm/x86/hypercalls.rst
@@ -207,3 +207,17 @@ The hypercall lets a guest request control register flags to be pinned for
 itself.
 
 Returns 0 on success or a KVM error code otherwise.
+
+10. KVM_HC_PROTECT_MEMORY
+-------------------------
+
+:Architecture: x86
+:Status: active
+:Purpose: Request permissions to be set in EPT
+
+- a0: physical address of a struct heki_page_list
+
+The hypercall lets a guest request memory permissions to be set for a list
+of physical pages.
+
+Returns 0 on success or a KVM error code otherwise.
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2024ff21d036..2d09bcc35462 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -47,9 +47,11 @@
 #include <linux/sched/signal.h>
 #include <linux/uaccess.h>
 #include <linux/hash.h>
+#include <linux/heki.h>
 #include <linux/kern_levels.h>
 #include <linux/kstrtox.h>
 #include <linux/kthread.h>
+#include <linux/kvm_mem_attr.h>
 
 #include <asm/page.h>
 #include <asm/memtype.h>
@@ -4446,6 +4448,75 @@ static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
 	       mmu_invalidate_retry_gfn(vcpu->kvm, fault->mmu_seq, fault->gfn);
 }
 
+static bool mem_attr_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+{
+	unsigned long perm;
+	bool noexec, nowrite;
+
+	if (unlikely(fault->rsvd))
+		return false;
+
+	if (!fault->present)
+		return false;
+
+	perm = kvm_permissions_get(vcpu->kvm, fault->gfn);
+	noexec = !(perm & MEM_ATTR_EXEC);
+	nowrite = !(perm & MEM_ATTR_WRITE);
+
+	if (fault->exec && noexec) {
+		struct x86_exception exception = {
+			.vector = PF_VECTOR,
+			.error_code_valid = true,
+			.error_code = fault->error_code,
+			.nested_page_fault = false,
+			/*
+			 * TODO: This kind of kernel page fault needs to be
+			 * handled by the guest, which is not currently the
+			 * case, making it try again and again.
+			 *
+			 * You may want to test with cr2_or_gva to see the page
+			 * fault caught by the guest kernel (thinking it is a
+			 * user space fault).
+			 */
+			.address = static_call(kvm_x86_fault_gva)(vcpu),
+			.async_page_fault = false,
+		};
+
+		pr_warn_ratelimited(
+			"heki: Creating fetch #PF at 0x%016llx GFN=%llx\n",
+			exception.address, fault->gfn);
+		kvm_inject_page_fault(vcpu, &exception);
+		return true;
+	}
+
+	if (fault->write && nowrite) {
+		struct x86_exception exception = {
+			.vector = PF_VECTOR,
+			.error_code_valid = true,
+			.error_code = fault->error_code,
+			.nested_page_fault = false,
+			/*
+			 * TODO: This kind of kernel page fault needs to be
+			 * handled by the guest, which is not currently the
+			 * case, making it try again and again.
+			 *
+			 * You may want to test with cr2_or_gva to see the page
+			 * fault caught by the guest kernel (thinking it is a
+			 * user space fault).
+			 */
+			.address = static_call(kvm_x86_fault_gva)(vcpu),
+			.async_page_fault = false,
+		};
+
+		pr_warn_ratelimited(
+			"heki: Creating write #PF at 0x%016llx GFN=%llx\n",
+			exception.address, fault->gfn);
+		kvm_inject_page_fault(vcpu, &exception);
+		return true;
+	}
+	return false;
+}
+
 static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	int r;
@@ -4457,6 +4528,9 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (page_fault_handle_page_track(vcpu, fault))
 		return RET_PF_EMULATE;
 
+	if (mem_attr_fault(vcpu, fault))
+		return RET_PF_RETRY;
+
 	r = fast_page_fault(vcpu, fault);
 	if (r != RET_PF_INVALID)
 		return r;
@@ -4537,6 +4611,9 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
 	if (page_fault_handle_page_track(vcpu, fault))
 		return RET_PF_EMULATE;
 
+	if (mem_attr_fault(vcpu, fault))
+		return RET_PF_RETRY;
+
 	r = fast_page_fault(vcpu, fault);
 	if (r != RET_PF_INVALID)
 		return r;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 08f0c8d28245..49e8295d62dd 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -820,6 +820,9 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 		return RET_PF_EMULATE;
 	}
 
+	if (mem_attr_fault(vcpu, fault))
+		return RET_PF_RETRY;
+
 	r = mmu_topup_memory_caches(vcpu, true);
 	if (r)
 		return r;
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 386cc1e8aab9..d72dc149424c 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -10,6 +10,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kvm_host.h>
+#include <linux/kvm_mem_attr.h>
 #include "mmu.h"
 #include "mmu_internal.h"
 #include "x86.h"
@@ -143,6 +144,11 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	int level = sp->role.level;
 	u64 spte = SPTE_MMU_PRESENT_MASK;
 	bool wrprot = false;
+	unsigned long perm;
+
+	perm = kvm_permissions_get(vcpu->kvm, gfn);
+	if (!(perm & MEM_ATTR_WRITE))
+		pte_access &= ~ACC_WRITE_MASK;
 
 	WARN_ON_ONCE(!pte_access && !shadow_present_mask);
 
@@ -178,10 +184,15 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		pte_access &= ~ACC_EXEC_MASK;
 	}
 
-	if (pte_access & ACC_EXEC_MASK)
+	if (pte_access & ACC_EXEC_MASK) {
 		spte |= shadow_x_mask;
-	else
+#ifdef CONFIG_HEKI
+		if (enable_mbec && !(perm & MEM_ATTR_EXEC))
+			spte &= ~VMX_EPT_EXECUTABLE_MASK;
+#endif
+	} else {
 		spte |= shadow_nx_mask;
+	}
 
 	if (pte_access & ACC_USER_MASK)
 		spte |= shadow_user_mask;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 43c28a6953bf..44f94b75ff16 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -62,6 +62,8 @@
 #include <linux/entry-kvm.h>
 #include <linux/suspend.h>
 #include <linux/smp.h>
+#include <linux/heki.h>
+#include <linux/kvm_mem_attr.h>
 
 #include <trace/events/ipi.h>
 #include <trace/events/kvm.h>
@@ -9983,6 +9985,131 @@ static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
 	return;
 }
 
+#ifdef CONFIG_HEKI
+
+static int heki_protect_memory(struct kvm *const kvm, gpa_t list_pa)
+{
+	struct heki_page_list *list, *head;
+	struct heki_pages *pages;
+	size_t size;
+	int i, npages, err = 0;
+
+	/* Read in the page list. */
+	head = NULL;
+	npages = 0;
+	while (list_pa) {
+		list = kmalloc(PAGE_SIZE, GFP_KERNEL);
+		if (!list) {
+			/* For want of a better error number. */
+			err = -KVM_E2BIG;
+			goto free;
+		}
+
+		err = kvm_read_guest(kvm, list_pa, list, sizeof(*list));
+		if (err) {
+			pr_warn("heki: Can't read list %llx\n", list_pa);
+			err = -KVM_EFAULT;
+			goto free;
+		}
+		list_pa += sizeof(*list);
+
+		size = list->npages * sizeof(*pages);
+		pages = list->pages;
+		err = kvm_read_guest(kvm, list_pa, pages, size);
+		if (err) {
+			pr_warn("heki: Can't read pages %llx\n", list_pa);
+			err = -KVM_EFAULT;
+			goto free;
+		}
+
+		list->next = head;
+		head = list;
+		npages += list->npages;
+		list_pa = list->next_pa;
+	}
+
+	/* For kvm_permissions_set() -> kvm_vm_set_mem_attributes() */
+	mutex_lock(&kvm->slots_arch_lock);
+
+	/*
+	 * Walk the page list, apply the permissions for each guest page and
+	 * zap the EPT entry of each page. The pages will be faulted in on
+	 * demand and the correct permissions will be applied at the correct
+	 * level for the pages.
+	 */
+	for (list = head; list; list = list->next) {
+		pages = list->pages;
+
+		for (i = 0; i < list->npages; i++) {
+			gfn_t gfn_start, gfn_end;
+			unsigned long permissions;
+
+			if (!PAGE_ALIGNED(pages[i].pa)) {
+				pr_warn("heki: GPA not aligned: %llx\n",
+					pages[i].pa);
+				err = -KVM_EINVAL;
+				goto unlock;
+			}
+			if (!PAGE_ALIGNED(pages[i].epa)) {
+				pr_warn("heki: GPA not aligned: %llx\n",
+					pages[i].epa);
+				err = -KVM_EINVAL;
+				goto unlock;
+			}
+
+			gfn_start = gpa_to_gfn(pages[i].pa);
+			gfn_end = gpa_to_gfn(pages[i].epa);
+			permissions = pages[i].permissions;
+
+			if (!permissions || (permissions & ~MEM_ATTR_PROT)) {
+				err = -KVM_EINVAL;
+				goto unlock;
+			}
+
+			if (!(permissions & MEM_ATTR_EXEC) && !enable_mbec) {
+				/*
+				 * Guests can check for MBEC support to avoid
+				 * this error message. We will continue
+				 * applying restrictions partially.
+				 */
+				pr_warn("heki: Clearing kernel exec "
+					"depends on MBEC, which is disabled.");
+				permissions |= MEM_ATTR_EXEC;
+			}
+
+			pr_warn("heki: Request to protect GFNs %llx-%llx"
+				" with %s permissions=%s%s%s\n",
+				gfn_start, gfn_end,
+				(permissions & MEM_ATTR_IMMUTABLE) ?
+					"immutable" :
+					"mutable",
+				(permissions & MEM_ATTR_READ) ? "r" : "_",
+				(permissions & MEM_ATTR_WRITE) ? "w" : "_",
+				(permissions & MEM_ATTR_EXEC) ? "x" : "_");
+
+			err = kvm_permissions_set(kvm, gfn_start, gfn_end,
+						  permissions);
+			if (err) {
+				pr_warn("heki: Failed to set permissions\n");
+				goto unlock;
+			}
+		}
+	}
+
+unlock:
+	mutex_unlock(&kvm->slots_arch_lock);
+
+free:
+	while (head) {
+		list = head;
+		head = head->next;
+		kfree(list);
+	}
+	return err;
+}
+
+#endif /* CONFIG_HEKI */
+
 static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
 {
 	u64 ret = vcpu->run->hypercall.ret;
@@ -10097,6 +10224,9 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 				return ret;
 		}
 		break;
+	case KVM_HC_PROTECT_MEMORY:
+		ret = heki_protect_memory(vcpu->kvm, a0);
+		break;
 #endif /* CONFIG_HEKI */
 	default:
 		ret = -KVM_ENOSYS;
diff --git a/include/linux/heki.h b/include/linux/heki.h
index 96ccb17657e5..89cc9273a968 100644
--- a/include/linux/heki.h
+++ b/include/linux/heki.h
@@ -8,6 +8,7 @@
 #ifndef __HEKI_H__
 #define __HEKI_H__
 
+#include <linux/kvm_types.h>
 #include <linux/types.h>
 #include <linux/bug.h>
 #include <linux/cache.h>
@@ -17,6 +18,32 @@
 
 #ifdef CONFIG_HEKI
 
+/*
+ * This structure contains a guest physical range and its permissions (RWX).
+ */
+struct heki_pages {
+	gpa_t pa;
+	gpa_t epa;
+	unsigned long permissions;
+};
+
+/*
+ * Guest ranges are passed to the VMM or hypervisor so they can be authenticated
+ * and their permissions can be set in the host page table. When an array of
+ * these is passed to the Hypervisor or VMM, the array must be in physically
+ * contiguous memory.
+ *
+ * This struct occupies one page. In each page, an array of guest ranges can
+ * be passed. A guest request to the VMM/Hypervisor may contain a list of
+ * these structs (linked by "next_pa").
+ */
+struct heki_page_list {
+	struct heki_page_list *next;
+	gpa_t next_pa;
+	unsigned long npages;
+	struct heki_pages pages[];
+};
+
 /*
  * A hypervisor that supports Heki will instantiate this structure to
  * provide hypervisor specific functions for Heki.
@@ -36,6 +63,8 @@ struct heki {
 extern struct heki heki;
 extern bool heki_enabled;
 
+extern bool __read_mostly enable_mbec;
+
 void heki_early_init(void);
 void heki_late_init(void);
 
diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
index 2ed418704603..938c9006e354 100644
--- a/include/uapi/linux/kvm_para.h
+++ b/include/uapi/linux/kvm_para.h
@@ -31,6 +31,7 @@
 #define KVM_HC_SCHED_YIELD		11
 #define KVM_HC_MAP_GPA_RANGE		12
 #define KVM_HC_LOCK_CR_UPDATE		13
+#define KVM_HC_PROTECT_MEMORY		14
 
 /*
  * hypercalls use architecture specific
-- 
2.42.1


