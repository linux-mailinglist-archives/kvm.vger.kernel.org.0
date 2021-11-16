Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97B9C4532BD
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 14:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236660AbhKPNUj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 08:20:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236562AbhKPNUf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 08:20:35 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF49AC061570
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 05:17:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=L8xb7MV4nPlwY1u8sks+AMPOnZjQtxR5C2Gj8DyL/rY=; b=cwWd1kT4oLGdGtW8lTr7TQF+pZ
        JWeBImFVr+X6Hp2PeJ/8512/yaw0AdPMn4ojwa1sIF6n1IcaVoepsLBlUrNqC+oYaqoD74FJsoBgQ
        zRQhy6Mmi81qkI+xWnfnZdU1uPHUSX4jBeopI8DpA5IysEWEqFrMS/cY4sv1Ly1fBkCsDxnuFYemh
        2dPJ7uZXPFNapOv71vr+mjJj7ncaMVG4LDD+LQ2Cg0+Qn+NloJoz12vPxMo4fnyg1CDHdGdHwxeTb
        9NBQdY1VKEx+zgQgcyYYu3HFxb/bg5OfAvs7z5Cesc5X5fMCWnvzr8IKYmWy247R671JxaQqJFKh2
        G/34mN1g==;
Received: from 54-240-197-233.amazon.com ([54.240.197.233] helo=freeip.amazon.com)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mmyL2-001n48-SN; Tue, 16 Nov 2021 13:17:29 +0000
Message-ID: <94bb55e117287e07ba74de2034800da5ba4398d2.camel@infradead.org>
Subject: Re: [RFC PATCH 0/11] Rework gfn_to_pfn_cache
From:   David Woodhouse <dwmw2@infradead.org>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>, karahmed@amazon.com
Date:   Tue, 16 Nov 2021 13:17:25 +0000
In-Reply-To: <57d599584ace8ab410b9b14569f434028e2cf642.camel@infradead.org>
References: <2b400dbb16818da49fb599b9182788ff9896dcda.camel@infradead.org>
         <32b00203-e093-8ffc-a75b-27557b5ee6b1@redhat.com>
         <28435688bab2dc1e272acc02ce92ba9a7589074f.camel@infradead.org>
         <4c37db19-14ed-46b8-eabe-0381ba879e5c@redhat.com>
         <537fdcc6af80ba6285ae0cdecdb615face25426f.camel@infradead.org>
         <7e4b895b-8f36-69cb-10a9-0b4139b9eb79@redhat.com>
                 <95fae9cf56b1a7f0a5f2b9a1934e29e924908ff2.camel@infradead.org>
         <3a2a9a8c-db98-b770-78e2-79f5880ce4ed@redhat.com>
         <2c7eee5179d67694917a5a0d10db1bce24af61bf.camel@infradead.org>
         <537a1d4e-9168-cd4a-cd2f-cddfd8733b05@redhat.com>
         <YZLmapmzs7sLpu/L@google.com>
         <57d599584ace8ab410b9b14569f434028e2cf642.camel@infradead.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-of9QcsCb6N49wEtDhQIU"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-of9QcsCb6N49wEtDhQIU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2021-11-15 at 23:22 +0000, David Woodhouse wrote:
> On Mon, 2021-11-15 at 22:59 +0000, Sean Christopherson wrote:
> > On Mon, Nov 15, 2021, Paolo Bonzini wrote:
> > > On 11/15/21 20:11, David Woodhouse wrote:
> > > > > Changing mn_memslots_update_rcuwait to a waitq (and renaming it t=
o
> > > > > mn_invalidate_waitq) is of course also a possibility.
> > > > I suspect that's the answer.
> > > >=20
> > > > I think the actual*invalidation*  of the cache still lives in the
> > > > invalidate_range() callback where I have it at the moment.
> >=20
> > Oooh!  [finally had a lightbulb moment about ->invalidate_range() after=
 years of
> > befuddlement].
> >=20
> > Two things:
> >=20
> >   1. Using _only_ ->invalidate_range() is not correct.  ->invalidate_ra=
nge() is
> >      required if and only if the old PFN needs to be _unmapped_.  Speci=
fically,
> >      if the protections are being downgraded without changing the PFN, =
it doesn't
> >      need to be called.  E.g. from hugetlb_change_protection():
>=20
> OK, that's kind of important to realise. Thanks.
>=20
> So, I had just split the atomic and guest-mode invalidations apart:
> https://git.infradead.org/users/dwmw2/linux.git/commitdiff/6cf5fe318fd
> but will go back to doing it all in invalidate_range_start from a
> single list.
>=20
> And just deal with the fact that the atomic users now have to
> loop/retry/wait for there *not* to be an MMU notification in progress.
>=20
> >      I believe we could use ->invalidate_range() to handle the unmap ca=
se if KVM's
> >      ->invalidate_range_start() hook is enhanced to handle the RW=3D>R =
case.  The
> >      "struct mmu_notifier_range" provides the event type, IIUC we could=
 have the
> >      _start() variant handle MMU_NOTIFY_PROTECTION_{VMA,PAGE} (and mayb=
e
> >      MMU_NOTIFY_SOFT_DIRTY?), and let the more precise unmap-only varia=
nt handle
> >      everything else.
>=20
> Not sure that helps us much. It was the termination condition on the
> "when should we keep retrying, and when should we give up?" that was
> painful, and a mixed mode doesn't that problem it go away.
>=20
> I'll go back and have another look in the morning, with something much
> closer to what I showed in
> https://lore.kernel.org/kvm/040d61dad066eb2517c108232efb975bc1cda780.came=
l@infradead.org/
>=20


Looks a bit like this, and it seems to be working for the Xen event
channel self-test. I'll port it into our actual Xen hosting environment
and give it some more serious testing.

I'm not sure I'm ready to sign up to immediately fix everything that's
hosed in nesting and kill off all users of the unsafe kvm_vcpu_map(),
but I'll at least convert one vCPU user to demonstrate that the new
gfn_to_pfn_cache is working sanely for that use case.



From: David Woodhouse <dwmw@amazon.co.uk>
Subject: [PATCH 08/10] KVM: Reinstate gfn_to_pfn_cache with invalidation su=
pport

This can be used in two modes. There is an atomic mode where the cached
mapping is accessed while holding the rwlock, and a mode where the
physical address is used by a vCPU in guest mode.

For the latter case, an invalidation will wake the vCPU with the new
KVM_REQ_GPC_INVALIDATE, and the architecture will need to refresh any
caches it still needs to access before entering guest mode again.

Only one vCPU can be targeted by the wake requests; it's simple enough
to make it wake all vCPUs or even a mask but I don't see a use case for
that additional complexity right now.

Invalidation happens from the invalidate_range_start MMU notifier, which
needs to be able to sleep in order to wake the vCPU and wait for it.

This means that revalidation potentially needs to "wait" for the MMU
operation to complete and the invalidate_range_end notifier to be
invoked. Like the vCPU when it takes a page fault in that period, we
just spin =E2=80=94 fixing that in a future patch by implementing an actual
*wait* may be another part of shaving this particularly hirsute yak.

As noted in the comments in the function itself, the only case where
the invalidate_range_start notifier is expected to be called *without*
being able to sleep is when the OOM reaper is killing the process. In
that case, we expect the vCPU threads already to have exited, and thus
there will be nothing to wake, and no reason to wait. So we clear the
KVM_REQUEST_WAIT bit and send the request anyway, then complain loudly
if there actually *was* anything to wake up.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/Kconfig              |   1 +
 include/linux/kvm_host.h          |  14 ++
 include/linux/kvm_types.h         |  17 ++
 virt/kvm/Kconfig                  |   3 +
 virt/kvm/Makefile.kvm             |   1 +
 virt/kvm/dirty_ring.c             |   2 +-
 virt/kvm/kvm_main.c               |  13 +-
 virt/kvm/{mmu_lock.h =3D> kvm_mm.h} |  23 ++-
 virt/kvm/pfncache.c               | 275 ++++++++++++++++++++++++++++++
 9 files changed, 342 insertions(+), 7 deletions(-)
 rename virt/kvm/{mmu_lock.h =3D> kvm_mm.h} (55%)
 create mode 100644 virt/kvm/pfncache.c

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index d7fa0a42ac25..af351107d47f 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -26,6 +26,7 @@ config KVM
 	select PREEMPT_NOTIFIERS
 	select MMU_NOTIFIER
 	select HAVE_KVM_IRQCHIP
+	select HAVE_KVM_PFNCACHE
 	select HAVE_KVM_IRQFD
 	select HAVE_KVM_DIRTY_RING
 	select IRQ_BYPASS_MANAGER
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c310648cc8f1..52e17e4b7694 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -151,6 +151,7 @@ static inline bool is_error_page(struct page *page)
 #define KVM_REQ_UNBLOCK           2
 #define KVM_REQ_UNHALT            3
 #define KVM_REQ_VM_DEAD           (4 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_W=
AKEUP)
+#define KVM_REQ_GPC_INVALIDATE    (5 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_W=
AKEUP)
 #define KVM_REQUEST_ARCH_BASE     8
=20
 #define KVM_ARCH_REQ_FLAGS(nr, flags) ({ \
@@ -559,6 +560,10 @@ struct kvm {
 	unsigned long mn_active_invalidate_count;
 	struct rcuwait mn_memslots_update_rcuwait;
=20
+	/* For management / invalidation of gfn_to_pfn_caches */
+	spinlock_t gpc_lock;
+	struct list_head gpc_list;
+
 	/*
 	 * created_vcpus is protected by kvm->lock, and is incremented
 	 * at the beginning of KVM_CREATE_VCPU.  online_vcpus is only
@@ -966,6 +971,15 @@ int kvm_vcpu_write_guest(struct kvm_vcpu *vcpu, gpa_t =
gpa, const void *data,
 			 unsigned long len);
 void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn);
=20
+int kvm_gfn_to_pfn_cache_init(struct kvm *kvm, struct gfn_to_pfn_cache *gp=
c,
+			      struct kvm_vcpu *vcpu, bool kernel_map,
+			      gpa_t gpa, unsigned long len, bool write);
+int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache =
*gpc,
+				 gpa_t gpa, unsigned long len, bool write);
+bool kvm_gfn_to_pfn_cache_check(struct kvm *kvm, struct gfn_to_pfn_cache *=
gpc,
+				gpa_t gpa, unsigned long len);
+void kvm_gfn_to_pfn_cache_destroy(struct kvm *kvm, struct gfn_to_pfn_cache=
 *gpc);
+
 void kvm_sigset_activate(struct kvm_vcpu *vcpu);
 void kvm_sigset_deactivate(struct kvm_vcpu *vcpu);
=20
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 234eab059839..e454d2c003d6 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -19,6 +19,7 @@ struct kvm_memslots;
 enum kvm_mr_change;
=20
 #include <linux/types.h>
+#include <linux/spinlock_types.h>
=20
 #include <asm/kvm_types.h>
=20
@@ -53,6 +54,22 @@ struct gfn_to_hva_cache {
 	struct kvm_memory_slot *memslot;
 };
=20
+struct gfn_to_pfn_cache {
+	u64 generation;
+	gpa_t gpa;
+	unsigned long uhva;
+	struct kvm_memory_slot *memslot;
+	struct kvm_vcpu *vcpu;
+	struct list_head list;
+	rwlock_t lock;
+	void *khva;
+	kvm_pfn_t pfn;
+	bool active;
+	bool valid;
+	bool dirty;
+	bool kernel_map;
+};
+
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
 /*
  * Memory caches are used to preallocate memory ahead of various MMU flows=
,
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 97cf5413ac25..f4834c20e4a6 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -4,6 +4,9 @@
 config HAVE_KVM
        bool
=20
+config HAVE_KVM_PFNCACHE
+       bool
+
 config HAVE_KVM_IRQCHIP
        bool
=20
diff --git a/virt/kvm/Makefile.kvm b/virt/kvm/Makefile.kvm
index ee9c310f3601..ca499a216d0f 100644
--- a/virt/kvm/Makefile.kvm
+++ b/virt/kvm/Makefile.kvm
@@ -11,3 +11,4 @@ kvm-$(CONFIG_KVM_MMIO) +=3D $(KVM)/coalesced_mmio.o
 kvm-$(CONFIG_KVM_ASYNC_PF) +=3D $(KVM)/async_pf.o
 kvm-$(CONFIG_HAVE_KVM_IRQCHIP) +=3D $(KVM)/irqchip.o
 kvm-$(CONFIG_HAVE_KVM_DIRTY_RING) +=3D $(KVM)/dirty_ring.o
+kvm-$(CONFIG_HAVE_KVM_PFNCACHE) +=3D $(KVM)/pfncache.o
diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index 88f4683198ea..2b4474387895 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -9,7 +9,7 @@
 #include <linux/vmalloc.h>
 #include <linux/kvm_dirty_ring.h>
 #include <trace/events/kvm.h>
-#include "mmu_lock.h"
+#include "kvm_mm.h"
=20
 int __weak kvm_cpu_dirty_log_size(void)
 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 356d636e037d..85506e4bd145 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -59,7 +59,7 @@
=20
 #include "coalesced_mmio.h"
 #include "async_pf.h"
-#include "mmu_lock.h"
+#include "kvm_mm.h"
 #include "vfio.h"
=20
 #define CREATE_TRACE_POINTS
@@ -684,6 +684,9 @@ static int kvm_mmu_notifier_invalidate_range_start(stru=
ct mmu_notifier *mn,
 	kvm->mn_active_invalidate_count++;
 	spin_unlock(&kvm->mn_invalidate_lock);
=20
+	gfn_to_pfn_cache_invalidate_start(kvm, range->start, range->end,
+					  hva_range.may_block);
+
 	__kvm_handle_hva_range(kvm, &hva_range);
=20
 	return 0;
@@ -1051,6 +1054,9 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	spin_lock_init(&kvm->mn_invalidate_lock);
 	rcuwait_init(&kvm->mn_memslots_update_rcuwait);
=20
+	INIT_LIST_HEAD(&kvm->gpc_list);
+	spin_lock_init(&kvm->gpc_lock);
+
 	INIT_LIST_HEAD(&kvm->devices);
=20
 	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
@@ -2390,8 +2396,8 @@ static int hva_to_pfn_remapped(struct vm_area_struct =
*vma,
  * 2): @write_fault =3D false && @writable, @writable will tell the caller
  *     whether the mapping is writable.
  */
-static kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
-			bool write_fault, bool *writable)
+kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
+		     bool write_fault, bool *writable)
 {
 	struct vm_area_struct *vma;
 	kvm_pfn_t pfn =3D 0;
diff --git a/virt/kvm/mmu_lock.h b/virt/kvm/kvm_mm.h
similarity index 55%
rename from virt/kvm/mmu_lock.h
rename to virt/kvm/kvm_mm.h
index 9e1308f9734c..b976e4b07e88 100644
--- a/virt/kvm/mmu_lock.h
+++ b/virt/kvm/kvm_mm.h
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
=20
-#ifndef KVM_MMU_LOCK_H
-#define KVM_MMU_LOCK_H 1
+#ifndef __KVM_MM_H__
+#define __KVM_MM_H__ 1
=20
 /*
  * Architectures can choose whether to use an rwlock or spinlock
@@ -20,4 +20,21 @@
 #define KVM_MMU_UNLOCK(kvm)    spin_unlock(&(kvm)->mmu_lock)
 #endif /* KVM_HAVE_MMU_RWLOCK */
=20
-#endif
+kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
+		     bool write_fault, bool *writable);
+
+#ifdef CONFIG_HAVE_KVM_PFNCACHE
+void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,
+				       unsigned long start,
+				       unsigned long end,
+				       bool may_block);
+#else
+static inline void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,
+						     unsigned long start,
+						     unsigned long end,
+						     bool may_block)
+{
+}
+#endif /* HAVE_KVM_PFNCACHE */
+
+#endif /* __KVM_MM_H__ */
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
new file mode 100644
index 000000000000..f2efc52039a8
--- /dev/null
+++ b/virt/kvm/pfncache.c
@@ -0,0 +1,275 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Kernel-based Virtual Machine driver for Linux
+ *
+ * This module enables kernel and guest-mode vCPU access to guest physical
+ * memory with suitable invalidation mechanisms.
+ *
+ * Copyright =C2=A9 2021 Amazon.com, Inc. or its affiliates.
+ *
+ * Authors:
+ *   David Woodhouse <dwmw2@infradead.org>
+ */
+
+#include <linux/kvm_host.h>
+#include <linux/kvm.h>
+#include <linux/highmem.h>
+#include <linux/module.h>
+#include <linux/errno.h>
+
+#include "kvm_mm.h"
+
+/*
+ * MMU notifier 'invalidate_range_start' hook.
+ */
+void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, unsigned long star=
t,
+				       unsigned long end, bool may_block)
+{
+	DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);
+	struct gfn_to_pfn_cache *gpc;
+	bool wake_vcpus =3D false;
+
+	spin_lock(&kvm->gpc_lock);
+	list_for_each_entry(gpc, &kvm->gpc_list, list) {
+		write_lock_irq(&gpc->lock);
+
+		/* Only a single page so no need to care about length */
+		if (gpc->valid && !is_error_noslot_pfn(gpc->pfn) &&
+		    gpc->uhva >=3D start && gpc->uhva < end) {
+			gpc->valid =3D false;
+
+			if (gpc->dirty) {
+				int idx =3D srcu_read_lock(&kvm->srcu);
+				mark_page_dirty(kvm, gpa_to_gfn(gpc->gpa));
+				srcu_read_unlock(&kvm->srcu, idx);
+
+				kvm_set_pfn_dirty(gpc->pfn);
+				gpc->dirty =3D false;
+			}
+
+			/*
+			 * If a guest vCPU could be using the physical address,
+			 * it needs to be woken.
+			 */
+			if (gpc->vcpu) {
+				if (!wake_vcpus) {
+					wake_vcpus =3D true;
+					bitmap_zero(vcpu_bitmap, KVM_MAX_VCPUS);
+				}
+				__set_bit(gpc->vcpu->vcpu_idx, vcpu_bitmap);
+			}
+		}
+		write_unlock_irq(&gpc->lock);
+	}
+	spin_unlock(&kvm->gpc_lock);
+
+	if (wake_vcpus) {
+		unsigned int req =3D KVM_REQ_GPC_INVALIDATE;
+		bool called;
+
+		/*
+		 * If the OOM reaper is active, then all vCPUs should have
+		 * been stopped already, so perform the request without
+		 * KVM_REQUEST_WAIT and be sad if any needed to be woken.
+		 */
+		if (!may_block)
+			req &=3D ~KVM_REQUEST_WAIT;
+
+		called =3D kvm_make_vcpus_request_mask(kvm, req, vcpu_bitmap);
+
+		WARN_ON_ONCE(called && !may_block);
+	}
+}
+
+bool kvm_gfn_to_pfn_cache_check(struct kvm *kvm, struct gfn_to_pfn_cache *=
gpc,
+				gpa_t gpa, unsigned long len)
+{
+	struct kvm_memslots *slots =3D kvm_memslots(kvm);
+
+	if ((gpa & ~PAGE_MASK) + len > PAGE_SIZE)
+		return false;
+
+	if (gpc->gpa !=3D gpa || gpc->generation !=3D slots->generation ||
+	    kvm_is_error_hva(gpc->uhva))
+		return false;
+
+	if (!gpc->valid)
+		return false;
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(kvm_gfn_to_pfn_cache_check);
+
+int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache =
*gpc,
+				 gpa_t gpa, unsigned long len, bool write)
+{
+	struct kvm_memslots *slots =3D kvm_memslots(kvm);
+	unsigned long page_offset =3D gpa & ~PAGE_MASK;
+	kvm_pfn_t old_pfn, new_pfn;
+	unsigned long old_uhva;
+	gpa_t old_gpa;
+	void *old_khva;
+	bool old_valid, old_dirty;
+	int ret =3D 0;
+
+	/*
+	 * If must fit within a single page. The 'len' argument is
+	 * only to enforce that.
+	 */
+	if (page_offset + len > PAGE_SIZE)
+		return -EINVAL;
+
+	write_lock_irq(&gpc->lock);
+
+	old_gpa =3D gpc->gpa;
+	old_pfn =3D gpc->pfn;
+	old_khva =3D gpc->khva;
+	old_uhva =3D gpc->uhva;
+	old_valid =3D gpc->valid;
+	old_dirty =3D gpc->dirty;
+
+	/* If the userspace HVA is invalid, refresh that first */
+	if (gpc->gpa !=3D gpa || gpc->generation !=3D slots->generation ||
+	    kvm_is_error_hva(gpc->uhva)) {
+		gfn_t gfn =3D gpa_to_gfn(gpa);
+
+		gpc->dirty =3D false;
+		gpc->gpa =3D gpa;
+		gpc->generation =3D slots->generation;
+		gpc->memslot =3D __gfn_to_memslot(slots, gfn);
+		gpc->uhva =3D gfn_to_hva_memslot(gpc->memslot, gfn);
+
+		if (kvm_is_error_hva(gpc->uhva)) {
+			ret =3D -EFAULT;
+			goto out;
+		}
+
+		gpc->uhva +=3D page_offset;
+	}
+
+	/*
+	 * If the userspace HVA changed or the PFN was already invalid,
+	 * drop the lock and do the HVA to PFN lookup again.
+	 */
+	if (!old_valid || old_uhva !=3D gpc->uhva) {
+		unsigned long uhva =3D gpc->uhva;
+		void *new_khva =3D NULL;
+		unsigned long mmu_seq;
+		int retry;
+
+		/* Placeholders for "hva is valid but not yet mapped" */
+		gpc->pfn =3D KVM_PFN_ERR_FAULT;
+		gpc->khva =3D NULL;
+		gpc->valid =3D true;
+
+		write_unlock_irq(&gpc->lock);
+
+	retry_map:
+		mmu_seq =3D kvm->mmu_notifier_seq;
+		smp_rmb();
+
+		new_pfn =3D hva_to_pfn(uhva, false, NULL, true, NULL);
+		if (is_error_noslot_pfn(new_pfn)) {
+			ret =3D -EFAULT;
+			goto map_done;
+		}
+
+		read_lock(&kvm->mmu_lock);
+		retry =3D mmu_notifier_retry_hva(kvm, mmu_seq, uhva);
+		read_unlock(&kvm->mmu_lock);
+		if (retry) {
+			cond_resched();
+			goto retry_map;
+		}
+
+		if (gpc->kernel_map) {
+			if (new_pfn =3D=3D old_pfn) {
+				new_khva =3D (void *)((unsigned long)old_khva - page_offset);
+				old_pfn =3D KVM_PFN_ERR_FAULT;
+				old_khva =3D NULL;
+			} else if (pfn_valid(new_pfn)) {
+				new_khva =3D kmap(pfn_to_page(new_pfn));
+#ifdef CONFIG_HAS_IOMEM
+			} else {
+				new_khva =3D memremap(pfn_to_hpa(new_pfn), PAGE_SIZE, MEMREMAP_WB);
+#endif
+			}
+			if (!new_khva)
+				ret =3D -EFAULT;
+		}
+
+	map_done:
+		write_lock_irq(&gpc->lock);
+		if (ret) {
+			gpc->valid =3D false;
+			gpc->pfn =3D KVM_PFN_ERR_FAULT;
+			gpc->khva =3D NULL;
+		} else {
+			/* At this point, gpc->valid may already have been cleared */
+			gpc->pfn =3D new_pfn;
+			gpc->khva =3D new_khva + page_offset;
+		}
+	}
+
+ out:
+	if (ret)
+		gpc->dirty =3D false;
+	else
+		gpc->dirty =3D write;
+
+	write_unlock_irq(&gpc->lock);
+
+	/* Unmap the old page if it was mapped before */
+	if (!is_error_noslot_pfn(old_pfn)) {
+		if (pfn_valid(old_pfn)) {
+			kunmap(pfn_to_page(old_pfn));
+#ifdef CONFIG_HAS_IOMEM
+		} else {
+			memunmap(old_khva);
+#endif
+		}
+		kvm_release_pfn(old_pfn, old_dirty);
+		if (old_dirty)
+			mark_page_dirty(kvm, old_gpa);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kvm_gfn_to_pfn_cache_refresh);
+
+int kvm_gfn_to_pfn_cache_init(struct kvm *kvm, struct gfn_to_pfn_cache *gp=
c,
+			      struct kvm_vcpu *vcpu, bool kernel_map,
+			      gpa_t gpa, unsigned long len, bool write)
+{
+	if (!gpc->active) {
+		rwlock_init(&gpc->lock);
+
+		gpc->khva =3D NULL;
+		gpc->pfn =3D KVM_PFN_ERR_FAULT;
+		gpc->uhva =3D KVM_HVA_ERR_BAD;
+		gpc->vcpu =3D vcpu;
+		gpc->kernel_map =3D kernel_map;
+		gpc->valid =3D false;
+		gpc->active =3D true;
+
+		spin_lock(&kvm->gpc_lock);
+		list_add(&gpc->list, &kvm->gpc_list);
+		spin_unlock(&kvm->gpc_lock);
+	}
+	return kvm_gfn_to_pfn_cache_refresh(kvm, gpc, gpa, len, write);
+}
+EXPORT_SYMBOL_GPL(kvm_gfn_to_pfn_cache_init);
+
+void kvm_gfn_to_pfn_cache_destroy(struct kvm *kvm, struct gfn_to_pfn_cache=
 *gpc)
+{
+	if (gpc->active) {
+		spin_lock(&kvm->gpc_lock);
+		list_del(&gpc->list);
+		spin_unlock(&kvm->gpc_lock);
+
+		/* In failing, it will tear down any existing mapping */
+		(void)kvm_gfn_to_pfn_cache_refresh(kvm, gpc, GPA_INVALID, 0, false);
+		gpc->active =3D false;
+	}
+}
+EXPORT_SYMBOL_GPL(kvm_gfn_to_pfn_cache_destroy);
--=20
2.31.1


--=-of9QcsCb6N49wEtDhQIU
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCECow
ggUcMIIEBKADAgECAhEA4rtJSHkq7AnpxKUY8ZlYZjANBgkqhkiG9w0BAQsFADCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0EwHhcNMTkwMTAyMDAwMDAwWhcNMjIwMTAxMjM1
OTU5WjAkMSIwIAYJKoZIhvcNAQkBFhNkd213MkBpbmZyYWRlYWQub3JnMIIBIjANBgkqhkiG9w0B
AQEFAAOCAQ8AMIIBCgKCAQEAsv3wObLTCbUA7GJqKj9vHGf+Fa+tpkO+ZRVve9EpNsMsfXhvFpb8
RgL8vD+L133wK6csYoDU7zKiAo92FMUWaY1Hy6HqvVr9oevfTV3xhB5rQO1RHJoAfkvhy+wpjo7Q
cXuzkOpibq2YurVStHAiGqAOMGMXhcVGqPuGhcVcVzVUjsvEzAV9Po9K2rpZ52FE4rDkpDK1pBK+
uOAyOkgIg/cD8Kugav5tyapydeWMZRJQH1vMQ6OVT24CyAn2yXm2NgTQMS1mpzStP2ioPtTnszIQ
Ih7ASVzhV6csHb8Yrkx8mgllOyrt9Y2kWRRJFm/FPRNEurOeNV6lnYAXOymVJwIDAQABo4IB0zCC
Ac8wHwYDVR0jBBgwFoAUgq9sjPjF/pZhfOgfPStxSF7Ei8AwHQYDVR0OBBYEFLfuNf820LvaT4AK
xrGK3EKx1DE7MA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMB0GA1UdJQQWMBQGCCsGAQUF
BwMEBggrBgEFBQcDAjBGBgNVHSAEPzA9MDsGDCsGAQQBsjEBAgEDBTArMCkGCCsGAQUFBwIBFh1o
dHRwczovL3NlY3VyZS5jb21vZG8ubmV0L0NQUzBaBgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3Js
LmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVtYWls
Q0EuY3JsMIGLBggrBgEFBQcBAQR/MH0wVQYIKwYBBQUHMAKGSWh0dHA6Ly9jcnQuY29tb2RvY2Eu
Y29tL0NPTU9ET1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5jcnQwJAYI
KwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNvbTAeBgNVHREEFzAVgRNkd213MkBpbmZy
YWRlYWQub3JnMA0GCSqGSIb3DQEBCwUAA4IBAQALbSykFusvvVkSIWttcEeifOGGKs7Wx2f5f45b
nv2ghcxK5URjUvCnJhg+soxOMoQLG6+nbhzzb2rLTdRVGbvjZH0fOOzq0LShq0EXsqnJbbuwJhK+
PnBtqX5O23PMHutP1l88AtVN+Rb72oSvnD+dK6708JqqUx2MAFLMevrhJRXLjKb2Mm+/8XBpEw+B
7DisN4TMlLB/d55WnT9UPNHmQ+3KFL7QrTO8hYExkU849g58Dn3Nw3oCbMUgny81ocrLlB2Z5fFG
Qu1AdNiBA+kg/UxzyJZpFbKfCITd5yX49bOriL692aMVDyqUvh8fP+T99PqorH4cIJP6OxSTdxKM
MIIFHDCCBASgAwIBAgIRAOK7SUh5KuwJ6cSlGPGZWGYwDQYJKoZIhvcNAQELBQAwgZcxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRo
ZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMB4XDTE5MDEwMjAwMDAwMFoXDTIyMDEwMTIz
NTk1OVowJDEiMCAGCSqGSIb3DQEJARYTZHdtdzJAaW5mcmFkZWFkLm9yZzCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBALL98Dmy0wm1AOxiaio/bxxn/hWvraZDvmUVb3vRKTbDLH14bxaW
/EYC/Lw/i9d98CunLGKA1O8yogKPdhTFFmmNR8uh6r1a/aHr301d8YQea0DtURyaAH5L4cvsKY6O
0HF7s5DqYm6tmLq1UrRwIhqgDjBjF4XFRqj7hoXFXFc1VI7LxMwFfT6PStq6WedhROKw5KQytaQS
vrjgMjpICIP3A/CroGr+bcmqcnXljGUSUB9bzEOjlU9uAsgJ9sl5tjYE0DEtZqc0rT9oqD7U57My
ECIewElc4VenLB2/GK5MfJoJZTsq7fWNpFkUSRZvxT0TRLqznjVepZ2AFzsplScCAwEAAaOCAdMw
ggHPMB8GA1UdIwQYMBaAFIKvbIz4xf6WYXzoHz0rcUhexIvAMB0GA1UdDgQWBBS37jX/NtC72k+A
CsaxitxCsdQxOzAOBgNVHQ8BAf8EBAMCBaAwDAYDVR0TAQH/BAIwADAdBgNVHSUEFjAUBggrBgEF
BQcDBAYIKwYBBQUHAwIwRgYDVR0gBD8wPTA7BgwrBgEEAbIxAQIBAwUwKzApBggrBgEFBQcCARYd
aHR0cHM6Ly9zZWN1cmUuY29tb2RvLm5ldC9DUFMwWgYDVR0fBFMwUTBPoE2gS4ZJaHR0cDovL2Ny
bC5jb21vZG9jYS5jb20vQ09NT0RPUlNBQ2xpZW50QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFp
bENBLmNybDCBiwYIKwYBBQUHAQEEfzB9MFUGCCsGAQUFBzAChklodHRwOi8vY3J0LmNvbW9kb2Nh
LmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVtYWlsQ0EuY3J0MCQG
CCsGAQUFBzABhhhodHRwOi8vb2NzcC5jb21vZG9jYS5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5m
cmFkZWFkLm9yZzANBgkqhkiG9w0BAQsFAAOCAQEAC20spBbrL71ZEiFrbXBHonzhhirO1sdn+X+O
W579oIXMSuVEY1LwpyYYPrKMTjKECxuvp24c829qy03UVRm742R9Hzjs6tC0oatBF7KpyW27sCYS
vj5wbal+TttzzB7rT9ZfPALVTfkW+9qEr5w/nSuu9PCaqlMdjABSzHr64SUVy4ym9jJvv/FwaRMP
gew4rDeEzJSwf3eeVp0/VDzR5kPtyhS+0K0zvIWBMZFPOPYOfA59zcN6AmzFIJ8vNaHKy5QdmeXx
RkLtQHTYgQPpIP1Mc8iWaRWynwiE3ecl+PWzq4i+vdmjFQ8qlL4fHz/k/fT6qKx+HCCT+jsUk3cS
jDCCBeYwggPOoAMCAQICEGqb4Tg7/ytrnwHV2binUlYwDQYJKoZIhvcNAQEMBQAwgYUxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMSswKQYDVQQDEyJDT01PRE8gUlNBIENlcnRpZmljYXRp
b24gQXV0aG9yaXR5MB4XDTEzMDExMDAwMDAwMFoXDTI4MDEwOTIzNTk1OVowgZcxCzAJBgNVBAYT
AkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNV
BAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRoZW50
aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEAvrOeV6wodnVAFsc4A5jTxhh2IVDzJXkLTLWg0X06WD6cpzEup/Y0dtmEatrQPTRI5Or1u6zf
+bGBSyD9aH95dDSmeny1nxdlYCeXIoymMv6pQHJGNcIDpFDIMypVpVSRsivlJTRENf+RKwrB6vcf
WlP8dSsE3Rfywq09N0ZfxcBa39V0wsGtkGWC+eQKiz4pBZYKjrc5NOpG9qrxpZxyb4o4yNNwTqza
aPpGRqXB7IMjtf7tTmU2jqPMLxFNe1VXj9XB1rHvbRikw8lBoNoSWY66nJN/VCJv5ym6Q0mdCbDK
CMPybTjoNCQuelc0IAaO4nLUXk0BOSxSxt8kCvsUtQIDAQABo4IBPDCCATgwHwYDVR0jBBgwFoAU
u69+Aj36pvE8hI6t7jiY7NkyMtQwHQYDVR0OBBYEFIKvbIz4xf6WYXzoHz0rcUhexIvAMA4GA1Ud
DwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMBEGA1UdIAQKMAgwBgYEVR0gADBMBgNVHR8E
RTBDMEGgP6A9hjtodHRwOi8vY3JsLmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDZXJ0aWZpY2F0aW9u
QXV0aG9yaXR5LmNybDBxBggrBgEFBQcBAQRlMGMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9jcnQuY29t
b2RvY2EuY29tL0NPTU9ET1JTQUFkZFRydXN0Q0EuY3J0MCQGCCsGAQUFBzABhhhodHRwOi8vb2Nz
cC5jb21vZG9jYS5jb20wDQYJKoZIhvcNAQEMBQADggIBAHhcsoEoNE887l9Wzp+XVuyPomsX9vP2
SQgG1NgvNc3fQP7TcePo7EIMERoh42awGGsma65u/ITse2hKZHzT0CBxhuhb6txM1n/y78e/4ZOs
0j8CGpfb+SJA3GaBQ+394k+z3ZByWPQedXLL1OdK8aRINTsjk/H5Ns77zwbjOKkDamxlpZ4TKSDM
KVmU/PUWNMKSTvtlenlxBhh7ETrN543j/Q6qqgCWgWuMAXijnRglp9fyadqGOncjZjaaSOGTTFB+
E2pvOUtY+hPebuPtTbq7vODqzCM6ryEhNhzf+enm0zlpXK7q332nXttNtjv7VFNYG+I31gnMrwfH
M5tdhYF/8v5UY5g2xANPECTQdu9vWPoqNSGDt87b3gXb1AiGGaI06vzgkejL580ul+9hz9D0S0U4
jkhJiA7EuTecP/CFtR72uYRBcunwwH3fciPjviDDAI9SnC/2aPY8ydehzuZutLbZdRJ5PDEJM/1t
yZR2niOYihZ+FCbtf3D9mB12D4ln9icgc7CwaxpNSCPt8i/GqK2HsOgkL3VYnwtx7cJUmpvVdZ4o
gnzgXtgtdk3ShrtOS1iAN2ZBXFiRmjVzmehoMof06r1xub+85hFQzVxZx5/bRaTKTlL8YXLI8nAb
R9HWdFqzcOoB/hxfEyIQpx9/s81rgzdEZOofSlZHynoSMYIDyjCCA8YCAQEwga0wgZcxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRo
ZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEA4rtJSHkq7AnpxKUY8ZlYZjANBglghkgB
ZQMEAgEFAKCCAe0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjEx
MTE2MTMxNzI1WjAvBgkqhkiG9w0BCQQxIgQglXaw6SYsdKswFhO2ufCxcd4A2MvusKgDmLuownMw
aKgwgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBAIuHBohlt28Mup32zzHTPxPuVAOcnRiPMIfjtfTrdfSMJdawNVKgQ4ud2d90J9b2
jzNAGd2xXvKSDUVholTJ/WyOTP7Wv28c+OxaLofwGnvIxPj7AjBKru3FmYsWV7Jizd8GB7bY2zFx
yBUxKhLdpwSZDBzKk5RwrS7/MMgYIhULTVcDgnf9X2VlAc86f8V1ya0vpN7XEAa6ngNp+HEJJ5ee
Q3Z+4QK/Pqgy+soRoNi8Jz7zlP8u7blLOCvCBVTCytL5g9HqTP0bIYH8keZ0p4GQQTIvQBoP9Sag
EkU4I/0TyrzqVOJm7ZmArcOA5hqnEUcAB11fjbt0fmlUyv7yiYIAAAAAAAA=


--=-of9QcsCb6N49wEtDhQIU--

