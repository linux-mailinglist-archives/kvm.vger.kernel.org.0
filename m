Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A626C1546BA
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 15:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgBFOvT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 09:51:19 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:55392 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727527AbgBFOug (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 09:50:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=qTpK99sN7WRqIfWf+ZjYD4CgBdyOTvR2MsNxs1Vzre8=; b=SiLIfsQECfdhy3NHjPkIWI/fa2
        QemtgGMo27Lpw3GUYAKeZfBsXv3dfYZnUqr2QS4qOydsZ6LnC4jE2LymDvI0Ixy6Q9gvE3rFTNg9E
        9jzhG7iiEDt8B1o8eg+rEc62ylhRoGSunTwt5WogAjXRG2Kxm5hRi78TWHvoha1RR5fhfbIXEL6h1
        cldDeXtCS/d15Dgg6SgmLVU0fLlj3muUx1cpe418cSTneutynX6iUSsP+soLWj1F4pP5s+5jyBpla
        Kpcr+mR5/JcZwcCvzTZM8/Z1FV4UkJTPJOMTxi1bcYd7sv8fktJFrFZGEnXnNMG5qS4oVMihaMfrM
        zUiMACJw==;
Received: from [179.95.15.160] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iziUE-0004Ia-RY; Thu, 06 Feb 2020 14:50:35 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iziU7-002nLn-0e; Thu, 06 Feb 2020 15:50:27 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v2 22/27] docs: kvm: Convert mmu.txt to ReST format
Date:   Thu,  6 Feb 2020 15:50:19 +0100
Message-Id: <6d1a51c7f1ab22a8722c14b05caa3c80cac9fbf0.1581000481.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1581000481.git.mchehab+huawei@kernel.org>
References: <cover.1581000481.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

- Use document title and chapter markups;
- Add markups for tables;
- Add markups for literal blocks;
- Add blank lines and adjust indentation.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/virt/kvm/index.rst            |  1 +
 Documentation/virt/kvm/{mmu.txt => mmu.rst} | 62 ++++++++++++++++-----
 2 files changed, 49 insertions(+), 14 deletions(-)
 rename Documentation/virt/kvm/{mmu.txt => mmu.rst} (94%)

diff --git a/Documentation/virt/kvm/index.rst b/Documentation/virt/kvm/index.rst
index 9be8f53b729d..95e2487d38f4 100644
--- a/Documentation/virt/kvm/index.rst
+++ b/Documentation/virt/kvm/index.rst
@@ -13,6 +13,7 @@ KVM
    halt-polling
    hypercalls
    locking
+   mmu
    msr
    vcpu-requests
 
diff --git a/Documentation/virt/kvm/mmu.txt b/Documentation/virt/kvm/mmu.rst
similarity index 94%
rename from Documentation/virt/kvm/mmu.txt
rename to Documentation/virt/kvm/mmu.rst
index dadb29e8738f..60981887d20b 100644
--- a/Documentation/virt/kvm/mmu.txt
+++ b/Documentation/virt/kvm/mmu.rst
@@ -1,3 +1,6 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+======================
 The x86 kvm shadow mmu
 ======================
 
@@ -7,27 +10,37 @@ physical addresses to host physical addresses.
 
 The mmu code attempts to satisfy the following requirements:
 
-- correctness: the guest should not be able to determine that it is running
+- correctness:
+	       the guest should not be able to determine that it is running
                on an emulated mmu except for timing (we attempt to comply
                with the specification, not emulate the characteristics of
                a particular implementation such as tlb size)
-- security:    the guest must not be able to touch host memory not assigned
+- security:
+	       the guest must not be able to touch host memory not assigned
                to it
-- performance: minimize the performance penalty imposed by the mmu
-- scaling:     need to scale to large memory and large vcpu guests
-- hardware:    support the full range of x86 virtualization hardware
-- integration: Linux memory management code must be in control of guest memory
+- performance:
+               minimize the performance penalty imposed by the mmu
+- scaling:
+               need to scale to large memory and large vcpu guests
+- hardware:
+               support the full range of x86 virtualization hardware
+- integration:
+               Linux memory management code must be in control of guest memory
                so that swapping, page migration, page merging, transparent
                hugepages, and similar features work without change
-- dirty tracking: report writes to guest memory to enable live migration
+- dirty tracking:
+               report writes to guest memory to enable live migration
                and framebuffer-based displays
-- footprint:   keep the amount of pinned kernel memory low (most memory
+- footprint:
+               keep the amount of pinned kernel memory low (most memory
                should be shrinkable)
-- reliability:  avoid multipage or GFP_ATOMIC allocations
+- reliability:
+               avoid multipage or GFP_ATOMIC allocations
 
 Acronyms
 ========
 
+====  ====================================================================
 pfn   host page frame number
 hpa   host physical address
 hva   host virtual address
@@ -41,6 +54,7 @@ pte   page table entry (used also to refer generically to paging structure
 gpte  guest pte (referring to gfns)
 spte  shadow pte (referring to pfns)
 tdp   two dimensional paging (vendor neutral term for NPT and EPT)
+====  ====================================================================
 
 Virtual and real hardware supported
 ===================================
@@ -90,11 +104,13 @@ Events
 The mmu is driven by events, some from the guest, some from the host.
 
 Guest generated events:
+
 - writes to control registers (especially cr3)
 - invlpg/invlpga instruction execution
 - access to missing or protected translations
 
 Host generated events:
+
 - changes in the gpa->hpa translation (either through gpa->hva changes or
   through hva->hpa changes)
 - memory pressure (the shrinker)
@@ -117,16 +133,19 @@ Leaf ptes point at guest pages.
 The following table shows translations encoded by leaf ptes, with higher-level
 translations in parentheses:
 
- Non-nested guests:
+ Non-nested guests::
+
   nonpaging:     gpa->hpa
   paging:        gva->gpa->hpa
   paging, tdp:   (gva->)gpa->hpa
- Nested guests:
+
+ Nested guests::
+
   non-tdp:       ngva->gpa->hpa  (*)
   tdp:           (ngva->)ngpa->gpa->hpa
 
-(*) the guest hypervisor will encode the ngva->gpa translation into its page
-    tables if npt is not present
+  (*) the guest hypervisor will encode the ngva->gpa translation into its page
+      tables if npt is not present
 
 Shadow pages contain the following information:
   role.level:
@@ -291,28 +310,41 @@ Handling a page fault is performed as follows:
 
  - if the RSV bit of the error code is set, the page fault is caused by guest
    accessing MMIO and cached MMIO information is available.
+
    - walk shadow page table
    - check for valid generation number in the spte (see "Fast invalidation of
      MMIO sptes" below)
    - cache the information to vcpu->arch.mmio_gva, vcpu->arch.mmio_access and
      vcpu->arch.mmio_gfn, and call the emulator
+
  - If both P bit and R/W bit of error code are set, this could possibly
    be handled as a "fast page fault" (fixed without taking the MMU lock).  See
    the description in Documentation/virt/kvm/locking.txt.
+
  - if needed, walk the guest page tables to determine the guest translation
    (gva->gpa or ngpa->gpa)
+
    - if permissions are insufficient, reflect the fault back to the guest
+
  - determine the host page
+
    - if this is an mmio request, there is no host page; cache the info to
      vcpu->arch.mmio_gva, vcpu->arch.mmio_access and vcpu->arch.mmio_gfn
+
  - walk the shadow page table to find the spte for the translation,
    instantiating missing intermediate page tables as necessary
+
    - If this is an mmio request, cache the mmio info to the spte and set some
      reserved bit on the spte (see callers of kvm_mmu_set_mmio_spte_mask)
+
  - try to unsynchronize the page
+
    - if successful, we can let the guest continue and modify the gpte
+
  - emulate the instruction
+
    - if failed, unshadow the page and let the guest continue
+
  - update any translations that were modified by the instruction
 
 invlpg handling:
@@ -324,10 +356,12 @@ invlpg handling:
 Guest control register updates:
 
 - mov to cr3
+
   - look up new shadow roots
   - synchronize newly reachable shadow pages
 
 - mov to cr0/cr4/efer
+
   - set up mmu context for new paging mode
   - look up new shadow roots
   - synchronize newly reachable shadow pages
@@ -358,6 +392,7 @@ on fault type:
 (user write faults generate a #PF)
 
 In the first case there are two additional complications:
+
 - if CR4.SMEP is enabled: since we've turned the page into a kernel page,
   the kernel may now execute it.  We handle this by also setting spte.nx.
   If we get a user fetch or read fault, we'll change spte.u=1 and
@@ -446,4 +481,3 @@ Further reading
 
 - NPT presentation from KVM Forum 2008
   http://www.linux-kvm.org/images/c/c8/KvmForum2008%24kdf2008_21.pdf
-
-- 
2.24.1

