Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57EC81524E0
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 03:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbgBECv1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 21:51:27 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:59897 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727945AbgBECvW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Feb 2020 21:51:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580871080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JlOS6C8tGQvFVsl+o6di+4ALD4s7OpNlxzWInCgkgGU=;
        b=OOyUR0jIXrMyQoVU+8glp3/DDIZVfiVwuaLUPE/Bk+x1PoT7GP5hYwh3bfcfNTP0bv7sN4
        bEa6Kukkep+JkRFWz5KEj2Ww+/iU5IMaGV/ywj49tHM9QF65n4cxOH24+GTZQYKdr8pqxx
        H/LQFz4lAXLQdZc6o78uIlykj7GADcs=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-qtakMHO_PdO-uElLJOnzUQ-1; Tue, 04 Feb 2020 21:51:17 -0500
X-MC-Unique: qtakMHO_PdO-uElLJOnzUQ-1
Received: by mail-qv1-f70.google.com with SMTP id d7so611082qvq.12
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2020 18:51:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JlOS6C8tGQvFVsl+o6di+4ALD4s7OpNlxzWInCgkgGU=;
        b=DhIj3UJTTtViXovcnQ+WP6oelsNodbKw+HA/Rch06VyNlRpe/LXUjBPmQGfkNrmhXF
         qBdT0uSHZNXminWu3JuD7fpywyEEfXbEd3rsFJdC1MO2n++9tt09SSOMKx40/fhKBZAe
         rA7oDU1Vo8op5sYmPTg1EqJTO2p4cspvVp/hHMC5KWyQnDe+tmmJkUmDRw7OrQQ/ufjs
         YxdCE4XBEsSmPP/Vdoe15OqrINNPILZNyswyXI508yt5i/cZcbL11bIEOgVfboMBfPit
         YesDdNnvrVfGk9rPqoCt36ZvGCDf+s2BOb5eUcnJCMdkDnrYYLKl8VWjjlV4idmcdWFR
         TNuw==
X-Gm-Message-State: APjAAAWolR5d2JCjppglWr4QZQekvR0xSh736gt1mDSdvndharjXhzcF
        E3WIvJIF2nXAsJCuuA555cao+MdYYP4ejOEjLMfwTj4VW5a7/Av4/bhROaTEIDOeIDwnYV1dMXq
        1OjcN7JtX4Cj/
X-Received: by 2002:a05:620a:20d0:: with SMTP id f16mr3507890qka.349.1580871075576;
        Tue, 04 Feb 2020 18:51:15 -0800 (PST)
X-Google-Smtp-Source: APXvYqzlOB1Xe5sXg3yy7jrT914bM9INW2BmPt7HvmMxS/JhDswHqDwxZKkxpLE34tzsUvxNTX8Usw==
X-Received: by 2002:a05:620a:20d0:: with SMTP id f16mr3507866qka.349.1580871075077;
        Tue, 04 Feb 2020 18:51:15 -0800 (PST)
Received: from xz-x1.redhat.com ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id b141sm12380923qkg.33.2020.02.04.18.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 18:51:14 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>, peterx@redhat.com,
        Kevin Tian <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH v4 03/14] KVM: X86: Don't track dirty for KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]
Date:   Tue,  4 Feb 2020 21:50:54 -0500
Message-Id: <20200205025105.367213-4-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200205025105.367213-1-peterx@redhat.com>
References: <20200205025105.367213-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Originally, we have three code paths that can dirty a page without
vcpu context for X86:

  - init_rmode_identity_map
  - init_rmode_tss
  - kvmgt_rw_gpa

init_rmode_identity_map and init_rmode_tss will be setup on
destination VM no matter what (and the guest cannot even see them), so
it does not make sense to track them at all.

To do this, allow __x86_set_memory_region() to return the userspace
address that just allocated to the caller.  Then in both of the
functions we directly write to the userspace address instead of
calling kvm_write_*() APIs.

Another trivial change is that we don't need to explicitly clear the
identity page table root in init_rmode_identity_map() because no
matter what we'll write to the whole page with 4M huge page entries.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +-
 arch/x86/kvm/svm.c              |  9 ++--
 arch/x86/kvm/vmx/vmx.c          | 78 ++++++++++++++++-----------------
 arch/x86/kvm/x86.c              | 40 ++++++++++++++---
 4 files changed, 80 insertions(+), 50 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 77d206a93658..8fc46bbce57a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1640,7 +1640,8 @@ void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu);
 
 int kvm_is_in_guest(void);
 
-int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size);
+void __user *__x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
+				     u32 size);
 bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu);
 bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index bf0556588ad0..160468e0898e 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1736,7 +1736,8 @@ static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
  */
 static int avic_update_access_page(struct kvm *kvm, bool activate)
 {
-	int ret = 0;
+	void __user *ret;
+	int r = 0;
 
 	mutex_lock(&kvm->slots_lock);
 	/*
@@ -1752,13 +1753,15 @@ static int avic_update_access_page(struct kvm *kvm, bool activate)
 				      APIC_ACCESS_PAGE_PRIVATE_MEMSLOT,
 				      APIC_DEFAULT_PHYS_BASE,
 				      activate ? PAGE_SIZE : 0);
-	if (ret)
+	if (IS_ERR(ret)) {
+		r = PTR_ERR(ret);
 		goto out;
+	}
 
 	kvm->arch.apic_access_page_done = activate;
 out:
 	mutex_unlock(&kvm->slots_lock);
-	return ret;
+	return r;
 }
 
 static int avic_init_backing_page(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1419c53aed16..a01f3bcef27a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3447,34 +3447,26 @@ static bool guest_state_valid(struct kvm_vcpu *vcpu)
 	return true;
 }
 
-static int init_rmode_tss(struct kvm *kvm)
+static int init_rmode_tss(struct kvm *kvm, void __user *ua)
 {
-	gfn_t fn;
+	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
 	u16 data = 0;
 	int idx, r;
 
-	idx = srcu_read_lock(&kvm->srcu);
-	fn = to_kvm_vmx(kvm)->tss_addr >> PAGE_SHIFT;
-	r = kvm_clear_guest_page(kvm, fn, 0, PAGE_SIZE);
-	if (r < 0)
-		goto out;
+	for (idx = 0; idx < 3; idx++) {
+		r = __copy_to_user(ua + PAGE_SIZE * idx, zero_page, PAGE_SIZE);
+		if (r)
+			return -EFAULT;
+	}
+
 	data = TSS_BASE_SIZE + TSS_REDIRECTION_SIZE;
-	r = kvm_write_guest_page(kvm, fn++, &data,
-			TSS_IOPB_BASE_OFFSET, sizeof(u16));
-	if (r < 0)
-		goto out;
-	r = kvm_clear_guest_page(kvm, fn++, 0, PAGE_SIZE);
-	if (r < 0)
-		goto out;
-	r = kvm_clear_guest_page(kvm, fn, 0, PAGE_SIZE);
-	if (r < 0)
-		goto out;
+	r = __copy_to_user(ua + TSS_IOPB_BASE_OFFSET, &data, sizeof(u16));
+	if (r)
+		return -EFAULT;
+
 	data = ~0;
-	r = kvm_write_guest_page(kvm, fn, &data,
-				 RMODE_TSS_SIZE - 2 * PAGE_SIZE - 1,
-				 sizeof(u8));
-out:
-	srcu_read_unlock(&kvm->srcu, idx);
+	r = __copy_to_user(ua + RMODE_TSS_SIZE - 1, &data, sizeof(u8));
+
 	return r;
 }
 
@@ -3483,6 +3475,7 @@ static int init_rmode_identity_map(struct kvm *kvm)
 	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
 	int i, r = 0;
 	kvm_pfn_t identity_map_pfn;
+	void __user *uaddr;
 	u32 tmp;
 
 	/* Protect kvm_vmx->ept_identity_pagetable_done. */
@@ -3495,22 +3488,24 @@ static int init_rmode_identity_map(struct kvm *kvm)
 		kvm_vmx->ept_identity_map_addr = VMX_EPT_IDENTITY_PAGETABLE_ADDR;
 	identity_map_pfn = kvm_vmx->ept_identity_map_addr >> PAGE_SHIFT;
 
-	r = __x86_set_memory_region(kvm, IDENTITY_PAGETABLE_PRIVATE_MEMSLOT,
-				    kvm_vmx->ept_identity_map_addr, PAGE_SIZE);
-	if (r < 0)
+	uaddr = __x86_set_memory_region(kvm,
+					IDENTITY_PAGETABLE_PRIVATE_MEMSLOT,
+					kvm_vmx->ept_identity_map_addr,
+					PAGE_SIZE);
+	if (IS_ERR(uaddr)) {
+		r = PTR_ERR(uaddr);
 		goto out;
+	}
 
-	r = kvm_clear_guest_page(kvm, identity_map_pfn, 0, PAGE_SIZE);
-	if (r < 0)
-		goto out;
 	/* Set up identity-mapping pagetable for EPT in real mode */
 	for (i = 0; i < PT32_ENT_PER_PAGE; i++) {
 		tmp = (i << 22) + (_PAGE_PRESENT | _PAGE_RW | _PAGE_USER |
 			_PAGE_ACCESSED | _PAGE_DIRTY | _PAGE_PSE);
-		r = kvm_write_guest_page(kvm, identity_map_pfn,
-				&tmp, i * sizeof(tmp), sizeof(tmp));
-		if (r < 0)
+		r = __copy_to_user(uaddr + i * sizeof(tmp), &tmp, sizeof(tmp));
+		if (r) {
+			r = -EFAULT;
 			goto out;
+		}
 	}
 	kvm_vmx->ept_identity_pagetable_done = true;
 
@@ -3537,19 +3532,22 @@ static void seg_setup(int seg)
 static int alloc_apic_access_page(struct kvm *kvm)
 {
 	struct page *page;
-	int r = 0;
+	void __user *r;
+	int ret = 0;
 
 	mutex_lock(&kvm->slots_lock);
 	if (kvm->arch.apic_access_page_done)
 		goto out;
 	r = __x86_set_memory_region(kvm, APIC_ACCESS_PAGE_PRIVATE_MEMSLOT,
 				    APIC_DEFAULT_PHYS_BASE, PAGE_SIZE);
-	if (r)
+	if (IS_ERR(r)) {
+		ret = PTR_ERR(r);
 		goto out;
+	}
 
 	page = gfn_to_page(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
 	if (is_error_page(page)) {
-		r = -EFAULT;
+		ret = -EFAULT;
 		goto out;
 	}
 
@@ -3561,7 +3559,7 @@ static int alloc_apic_access_page(struct kvm *kvm)
 	kvm->arch.apic_access_page_done = true;
 out:
 	mutex_unlock(&kvm->slots_lock);
-	return r;
+	return ret;
 }
 
 int allocate_vpid(void)
@@ -4479,7 +4477,7 @@ static int vmx_interrupt_allowed(struct kvm_vcpu *vcpu)
 
 static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr)
 {
-	int ret;
+	void __user *ret;
 
 	if (enable_unrestricted_guest)
 		return 0;
@@ -4489,10 +4487,12 @@ static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr)
 				      PAGE_SIZE * 3);
 	mutex_unlock(&kvm->slots_lock);
 
-	if (ret)
-		return ret;
+	if (IS_ERR(ret))
+		return PTR_ERR(ret);
+
 	to_kvm_vmx(kvm)->tss_addr = addr;
-	return init_rmode_tss(kvm);
+
+	return init_rmode_tss(kvm, ret);
 }
 
 static int vmx_set_identity_map_addr(struct kvm *kvm, u64 ident_addr)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7e3f1d937224..030435f1a033 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9732,7 +9732,33 @@ void kvm_arch_sync_events(struct kvm *kvm)
 	kvm_free_pit(kvm);
 }
 
-int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
+/**
+ * __x86_set_memory_region: Setup KVM internal memory slot
+ *
+ * @kvm: the kvm pointer to the VM.
+ * @id: the slot ID to setup.
+ * @gpa: the GPA to install the slot (unused when @size == 0).
+ * @size: the size of the slot. Set to zero to uninstall a slot.
+ *
+ * This function helps to setup a KVM internal memory slot.  Specify
+ * @size > 0 to install a new slot, while @size == 0 to uninstall a
+ * slot.  The return code can be one of the following:
+ *
+ *   - An error number if error happened, or,
+ *   - For installation: the HVA of the newly mapped memory slot, or,
+ *   - For uninstallation: zero if we successfully uninstall a slot.
+ *
+ * The caller should always use IS_ERR() to check the return value
+ * before use.  NOTE: KVM internal memory slots are guaranteed and
+ * won't change until the VM is destroyed. This is also true to the
+ * returned HVA when installing a new memory slot.  The HVA can be
+ * invalidated by either an errornous userspace program or a VM under
+ * destruction, however as long as we use __copy_{to|from}_user()
+ * properly upon the HVAs and handle the failure paths always then
+ * we're safe.
+ */
+void __user * __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
+				      u32 size)
 {
 	int i, r;
 	unsigned long hva;
@@ -9741,12 +9767,12 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
 
 	/* Called with kvm->slots_lock held.  */
 	if (WARN_ON(id >= KVM_MEM_SLOTS_NUM))
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
 	slot = id_to_memslot(slots, id);
 	if (size) {
 		if (slot->npages)
-			return -EEXIST;
+			return ERR_PTR(-EEXIST);
 
 		/*
 		 * MAP_SHARED to prevent internal slot pages from being moved
@@ -9755,10 +9781,10 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
 		hva = vm_mmap(NULL, 0, size, PROT_READ | PROT_WRITE,
 			      MAP_SHARED | MAP_ANONYMOUS, 0);
 		if (IS_ERR((void *)hva))
-			return PTR_ERR((void *)hva);
+			return (void __user *)hva;
 	} else {
 		if (!slot->npages)
-			return 0;
+			return ERR_PTR(0);
 
 		hva = 0;
 	}
@@ -9774,13 +9800,13 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
 		m.memory_size = size;
 		r = __kvm_set_memory_region(kvm, &m);
 		if (r < 0)
-			return r;
+			return ERR_PTR(r);
 	}
 
 	if (!size)
 		vm_munmap(old.userspace_addr, old.npages * PAGE_SIZE);
 
-	return 0;
+	return (void __user *)hva;
 }
 EXPORT_SYMBOL_GPL(__x86_set_memory_region);
 
-- 
2.24.1

