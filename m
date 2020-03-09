Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E462A17EB6D
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 22:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbgCIVoo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 17:44:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30939 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727144AbgCIVol (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 17:44:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583790279;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VFqtYf9mq+u3FzlLfuxydB/fRuMWFK1AHk/2aTLyELw=;
        b=BjSzoKgqn4T53ybLyWyjJr6s3UvNosGh33tiKId+amAu7wMJtPmQH9uBn5oxhlM1Tbpicm
        KdKZmRSGxUwMdV0GiRHVUfVmzAHm2jRPJcFx7RC4hhV7lYXnUT8/r8VEkXhVRN3T6AhMLE
        27bnMiaLT9dguHQ7KH2fPIqK8BGupAI=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-eiwgoz_EOpS15nTExbF4mw-1; Mon, 09 Mar 2020 17:44:38 -0400
X-MC-Unique: eiwgoz_EOpS15nTExbF4mw-1
Received: by mail-qt1-f198.google.com with SMTP id c13so7739595qtq.23
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2020 14:44:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VFqtYf9mq+u3FzlLfuxydB/fRuMWFK1AHk/2aTLyELw=;
        b=kMYaI1bZvXwfsP+v4aXk7aU7TnK8ldCsO7euG9LE23DIKgRhHfcjbYGHkwqqg+Ivdg
         RSu5dbBVHRMF4qzVgK2aDggIwZDnXCSSLPId6mOQRRXG8U2EOENAhYcBUGY7Oy+ob2Zd
         PvkP37CP1uXzEgZZtXK+RB88wBQMRQML4Th4e2NriPym2NN8Oe3drqMnL08SxITGmpCR
         WJAhvn3Mwezs+vK+h0FqcZZu+NE0ZiisisEQC8i/1rpwK1U8j75JF9gwl85SBEqBKRyS
         eDIGfHFzevbuyWbWsojn8mhxJJAheWdNVRWu8D8GwCsNQHhl5SJ/P9h/2oBw99yA0QhN
         RpDA==
X-Gm-Message-State: ANhLgQ0RsToubyxVzrlxgb5YhQL5wpxgMeQOfOuT/0uLukW5b03nzKam
        M41cLiToIOZ+pzdMNlk2+3As4sZW3T6esmSCYxFP72MSfzY2U+APcFoEXB4sqW5OmF6yWfxrs6U
        nNfwsyaAQrzzK
X-Received: by 2002:ac8:4d09:: with SMTP id w9mr9644596qtv.279.1583790277352;
        Mon, 09 Mar 2020 14:44:37 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuh+ceAfgiHWgR0R3jJZE+MetgCxWERrO8JTxu9fCc1VqqScb7CdfsJhP8QDyaVEg0OjKZhxA==
X-Received: by 2002:ac8:4d09:: with SMTP id w9mr9644576qtv.279.1583790276848;
        Mon, 09 Mar 2020 14:44:36 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id l3sm15323397qkl.100.2020.03.09.14.44.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 14:44:36 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Yan Zhao <yan.y.zhao@intel.com>, Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        peterx@redhat.com, Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v6 03/14] KVM: X86: Don't track dirty for KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]
Date:   Mon,  9 Mar 2020 17:44:13 -0400
Message-Id: <20200309214424.330363-4-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200309214424.330363-1-peterx@redhat.com>
References: <20200309214424.330363-1-peterx@redhat.com>
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
index 98959e8cd448..ae7641b6a473 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1651,7 +1651,8 @@ void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu);
 
 int kvm_is_in_guest(void);
 
-int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size);
+void __user *__x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
+				     u32 size);
 bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu);
 bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 24c0b2ba8fb9..9b325599faf2 100644
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
index 40b1e6138cd5..fc638a164e03 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3467,34 +3467,26 @@ static bool guest_state_valid(struct kvm_vcpu *vcpu)
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
 
@@ -3503,6 +3495,7 @@ static int init_rmode_identity_map(struct kvm *kvm)
 	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
 	int i, r = 0;
 	kvm_pfn_t identity_map_pfn;
+	void __user *uaddr;
 	u32 tmp;
 
 	/* Protect kvm_vmx->ept_identity_pagetable_done. */
@@ -3515,22 +3508,24 @@ static int init_rmode_identity_map(struct kvm *kvm)
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
 
@@ -3557,19 +3552,22 @@ static void seg_setup(int seg)
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
 
@@ -3581,7 +3579,7 @@ static int alloc_apic_access_page(struct kvm *kvm)
 	kvm->arch.apic_access_page_done = true;
 out:
 	mutex_unlock(&kvm->slots_lock);
-	return r;
+	return ret;
 }
 
 int allocate_vpid(void)
@@ -4503,7 +4501,7 @@ static int vmx_interrupt_allowed(struct kvm_vcpu *vcpu)
 
 static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr)
 {
-	int ret;
+	void __user *ret;
 
 	if (enable_unrestricted_guest)
 		return 0;
@@ -4513,10 +4511,12 @@ static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr)
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
index 5de200663f51..fe485d4ba6c7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9756,7 +9756,33 @@ void kvm_arch_sync_events(struct kvm *kvm)
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
@@ -9765,12 +9791,12 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
 
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
@@ -9779,10 +9805,10 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
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
@@ -9798,13 +9824,13 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
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

