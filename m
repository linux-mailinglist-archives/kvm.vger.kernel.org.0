Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8479714BC26
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 15:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbgA1OvV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 09:51:21 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:58536 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbgA1N6p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jan 2020 08:58:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=qSQNK5Ivf59NAVe6e3CbDIPuMhg/3mhXwdp9SJF3SBc=; b=UAp4z2OGa2j0tTakFsoHY0IkYV
        mdzavhq23GBpGSJ3VX2I8KnPm1PMNWcYJPnU45iPJU/NOZtBrqeq1ktD6tb6cWQmRMyV0fkEmabMr
        3NDJKvtWR6/H1LbRI05kAQWd3DCRedR0m8ukRRK+XupgnbdXNmhz/fprYx075ArJLc6SB42n0OcsZ
        Da0ne+DDfsiZe1oYCI4PM48+ya6JAYx+USyQeixxJQEvvcws4j4dQ6zVM5izobdh/+MWLfx5PcoT+
        z6vX+ykzCQ6pmPHV6gvIyQQUVwojlvn/DfZ5iwY1iOwPa+4ikFYrhtZT7XYk4ffIHGFFLDWFcg0QD
        iuViXTpw==;
Received: from [177.41.103.99] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwRO8-0006I7-CR; Tue, 28 Jan 2020 13:58:45 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iwRNq-001BKZ-RL; Tue, 28 Jan 2020 14:58:26 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 21/27] docs: kvm: Convert locking.txt to ReST format
Date:   Tue, 28 Jan 2020 14:58:17 +0100
Message-Id: <31d840edcc924b6b4d6f3f6b3f130623c2a4d91c.1580219586.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1580219586.git.mchehab+huawei@kernel.org>
References: <cover.1580219586.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

- Use document title and chapter markups;
- Add markups for literal blocks;
- use :field: for field descriptions;
- Add blank lines and adjust indentation.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/virt/kvm/index.rst              |   1 +
 .../virt/kvm/{locking.txt => locking.rst}     | 109 ++++++++++--------
 2 files changed, 61 insertions(+), 49 deletions(-)
 rename Documentation/virt/kvm/{locking.txt => locking.rst} (79%)

diff --git a/Documentation/virt/kvm/index.rst b/Documentation/virt/kvm/index.rst
index ac83bc588f7e..9be8f53b729d 100644
--- a/Documentation/virt/kvm/index.rst
+++ b/Documentation/virt/kvm/index.rst
@@ -12,6 +12,7 @@ KVM
    cpuid
    halt-polling
    hypercalls
+   locking
    msr
    vcpu-requests
 
diff --git a/Documentation/virt/kvm/locking.txt b/Documentation/virt/kvm/locking.rst
similarity index 79%
rename from Documentation/virt/kvm/locking.txt
rename to Documentation/virt/kvm/locking.rst
index 635cd6eaf714..065706a9155e 100644
--- a/Documentation/virt/kvm/locking.txt
+++ b/Documentation/virt/kvm/locking.rst
@@ -1,3 +1,4 @@
+=================
 KVM Lock Overview
 =================
 
@@ -18,7 +19,7 @@ On x86, vcpu->mutex is taken outside kvm->arch.hyperv.hv_lock.
 Everything else is a leaf: no other lock is taken inside the critical
 sections.
 
-2: Exception
+2. Exception
 ------------
 
 Fast page fault:
@@ -28,15 +29,16 @@ the mmu-lock on x86. Currently, the page fault can be fast in one of the
 following two cases:
 
 1. Access Tracking: The SPTE is not present, but it is marked for access
-tracking i.e. the SPTE_SPECIAL_MASK is set. That means we need to
-restore the saved R/X bits. This is described in more detail later below.
+   tracking i.e. the SPTE_SPECIAL_MASK is set. That means we need to
+   restore the saved R/X bits. This is described in more detail later below.
 
 2. Write-Protection: The SPTE is present and the fault is
-caused by write-protect. That means we just need to change the W bit of the 
-spte.
+   caused by write-protect. That means we just need to change the W bit of
+   the spte.
 
 What we use to avoid all the race is the SPTE_HOST_WRITEABLE bit and
 SPTE_MMU_WRITEABLE bit on the spte:
+
 - SPTE_HOST_WRITEABLE means the gfn is writable on host.
 - SPTE_MMU_WRITEABLE means the gfn is writable on mmu. The bit is set when
   the gfn is writable on guest mmu and it is not write-protected by shadow
@@ -48,19 +50,23 @@ restore the saved R/X bits if VMX_EPT_TRACK_ACCESS mask is set, or both. This
 is safe because whenever changing these bits can be detected by cmpxchg.
 
 But we need carefully check these cases:
-1): The mapping from gfn to pfn
+
+1) The mapping from gfn to pfn
+
 The mapping from gfn to pfn may be changed since we can only ensure the pfn
 is not changed during cmpxchg. This is a ABA problem, for example, below case
 will happen:
 
-At the beginning:
-gpte = gfn1
-gfn1 is mapped to pfn1 on host
-spte is the shadow page table entry corresponding with gpte and
-spte = pfn1
+At the beginning::
 
-   VCPU 0                           VCPU0
-on fast page fault path:
+	gpte = gfn1
+	gfn1 is mapped to pfn1 on host
+	spte is the shadow page table entry corresponding with gpte and
+	spte = pfn1
+
+	   VCPU 0                           VCPU0
+
+on fast page fault path::
 
    old_spte = *spte;
                                  pfn1 is swapped out:
@@ -81,6 +87,7 @@ We dirty-log for gfn1, that means gfn2 is lost in dirty-bitmap.
 For direct sp, we can easily avoid it since the spte of direct sp is fixed
 to gfn. For indirect sp, before we do cmpxchg, we call gfn_to_pfn_atomic()
 to pin gfn to pfn, because after gfn_to_pfn_atomic():
+
 - We have held the refcount of pfn that means the pfn can not be freed and
   be reused for another gfn.
 - The pfn is writable that means it can not be shared between different gfns
@@ -91,7 +98,8 @@ Then, we can ensure the dirty bitmaps is correctly set for a gfn.
 Currently, to simplify the whole things, we disable fast page fault for
 indirect shadow page.
 
-2): Dirty bit tracking
+2) Dirty bit tracking
+
 In the origin code, the spte can be fast updated (non-atomically) if the
 spte is read-only and the Accessed bit has already been set since the
 Accessed bit and Dirty bit can not be lost.
@@ -99,12 +107,14 @@ Accessed bit and Dirty bit can not be lost.
 But it is not true after fast page fault since the spte can be marked
 writable between reading spte and updating spte. Like below case:
 
-At the beginning:
-spte.W = 0
-spte.Accessed = 1
+At the beginning::
 
-   VCPU 0                                       VCPU0
-In mmu_spte_clear_track_bits():
+	spte.W = 0
+	spte.Accessed = 1
+
+	   VCPU 0                                       VCPU0
+
+In mmu_spte_clear_track_bits()::
 
    old_spte = *spte;
 
@@ -134,7 +144,8 @@ In order to avoid this kind of issue, we always treat the spte as "volatile"
 if it can be updated out of mmu-lock, see spte_has_volatile_bits(), it means,
 the spte is always atomically updated in this case.
 
-3): flush tlbs due to spte updated
+3) flush tlbs due to spte updated
+
 If the spte is updated from writable to readonly, we should flush all TLBs,
 otherwise rmap_write_protect will find a read-only spte, even though the
 writable spte might be cached on a CPU's TLB.
@@ -166,47 +177,47 @@ which time it will be set using the Dirty tracking mechanism described above.
 3. Reference
 ------------
 
-Name:		kvm_lock
-Type:		mutex
-Arch:		any
-Protects:	- vm_list
+:Name:		kvm_lock
+:Type:		mutex
+:Arch:		any
+:Protects:	- vm_list
 
-Name:		kvm_count_lock
-Type:		raw_spinlock_t
-Arch:		any
-Protects:	- hardware virtualization enable/disable
-Comment:	'raw' because hardware enabling/disabling must be atomic /wrt
+:Name:		kvm_count_lock
+:Type:		raw_spinlock_t
+:Arch:		any
+:Protects:	- hardware virtualization enable/disable
+:Comment:	'raw' because hardware enabling/disabling must be atomic /wrt
 		migration.
 
-Name:		kvm_arch::tsc_write_lock
-Type:		raw_spinlock
-Arch:		x86
-Protects:	- kvm_arch::{last_tsc_write,last_tsc_nsec,last_tsc_offset}
+:Name:		kvm_arch::tsc_write_lock
+:Type:		raw_spinlock
+:Arch:		x86
+:Protects:	- kvm_arch::{last_tsc_write,last_tsc_nsec,last_tsc_offset}
 		- tsc offset in vmcb
-Comment:	'raw' because updating the tsc offsets must not be preempted.
+:Comment:	'raw' because updating the tsc offsets must not be preempted.
 
-Name:		kvm->mmu_lock
-Type:		spinlock_t
-Arch:		any
-Protects:	-shadow page/shadow tlb entry
-Comment:	it is a spinlock since it is used in mmu notifier.
+:Name:		kvm->mmu_lock
+:Type:		spinlock_t
+:Arch:		any
+:Protects:	-shadow page/shadow tlb entry
+:Comment:	it is a spinlock since it is used in mmu notifier.
 
-Name:		kvm->srcu
-Type:		srcu lock
-Arch:		any
-Protects:	- kvm->memslots
+:Name:		kvm->srcu
+:Type:		srcu lock
+:Arch:		any
+:Protects:	- kvm->memslots
 		- kvm->buses
-Comment:	The srcu read lock must be held while accessing memslots (e.g.
+:Comment:	The srcu read lock must be held while accessing memslots (e.g.
 		when using gfn_to_* functions) and while accessing in-kernel
 		MMIO/PIO address->device structure mapping (kvm->buses).
 		The srcu index can be stored in kvm_vcpu->srcu_idx per vcpu
 		if it is needed by multiple functions.
 
-Name:		blocked_vcpu_on_cpu_lock
-Type:		spinlock_t
-Arch:		x86
-Protects:	blocked_vcpu_on_cpu
-Comment:	This is a per-CPU lock and it is used for VT-d posted-interrupts.
+:Name:		blocked_vcpu_on_cpu_lock
+:Type:		spinlock_t
+:Arch:		x86
+:Protects:	blocked_vcpu_on_cpu
+:Comment:	This is a per-CPU lock and it is used for VT-d posted-interrupts.
 		When VT-d posted-interrupts is supported and the VM has assigned
 		devices, we put the blocked vCPU on the list blocked_vcpu_on_cpu
 		protected by blocked_vcpu_on_cpu_lock, when VT-d hardware issues
-- 
2.24.1

