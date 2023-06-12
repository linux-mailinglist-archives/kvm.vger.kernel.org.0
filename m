Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC97872B5B3
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 05:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234118AbjFLDIZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Jun 2023 23:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233318AbjFLDIR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 11 Jun 2023 23:08:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 710E3E62;
        Sun, 11 Jun 2023 20:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=V5veyfA2KKdGawPZUrWbJWEmsvc+vf30GCw8DAtjIos=; b=TIJfE/QEphsK3LIjhTNK9jlRrX
        6NYuvunBk9ad9NfKeNCIe6/RAC6TibowZIQY48PJD5w/2wBTDwN4lwlOJvBktSMhd/66Hk9opcrQw
        z59i0BVg4wz10n5LG8CgzJoMpCoSJZ46xHtOXQG08brjfmJ9YcY6avmP2RuQewetROFQsf8kzuu36
        ouySaslQkrvCrEhhPAwch4C2N96DIp0Rnzgce2zIgmz5EOVtCuSJtzYNz+0t7AtW05wc93y/wYTll
        foJ+dUGzsmMBM95sJ+YBh0niUUJUNun/XYLt2b04ls3Qalu2r8jSXONQYlMVxDuIL6Tx3fGLbm/Q6
        L78Qwgqw==;
Received: from [2601:1c2:980:9ec0::2764] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1q8Xuf-002P78-34;
        Mon, 12 Jun 2023 03:08:14 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 2/4] Documentation: KVM: make corrections to locking.rst
Date:   Sun, 11 Jun 2023 20:08:08 -0700
Message-ID: <20230612030810.23376-3-rdunlap@infradead.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612030810.23376-1-rdunlap@infradead.org>
References: <20230612030810.23376-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Correct grammar and punctuation.
Use "read-only" for consistency.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
---
Q: What is spte.HOST_WRITEABLE supposed to be? It is not used anywhere
  else in the kernel source tree.

 Documentation/virt/kvm/locking.rst |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -- a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -67,7 +67,7 @@ following two cases:
 2. Write-Protection: The SPTE is present and the fault is caused by
    write-protect. That means we just need to change the W bit of the spte.
 
-What we use to avoid all the race is the Host-writable bit and MMU-writable bit
+What we use to avoid all the races is the Host-writable bit and MMU-writable bit
 on the spte:
 
 - Host-writable means the gfn is writable in the host kernel page tables and in
@@ -130,7 +130,7 @@ to gfn.  For indirect sp, we disabled fa
 A solution for indirect sp could be to pin the gfn, for example via
 kvm_vcpu_gfn_to_pfn_atomic, before the cmpxchg.  After the pinning:
 
-- We have held the refcount of pfn that means the pfn can not be freed and
+- We have held the refcount of pfn; that means the pfn can not be freed and
   be reused for another gfn.
 - The pfn is writable and therefore it cannot be shared between different gfns
   by KSM.
@@ -186,22 +186,22 @@ writable between reading spte and updati
 The Dirty bit is lost in this case.
 
 In order to avoid this kind of issue, we always treat the spte as "volatile"
-if it can be updated out of mmu-lock, see spte_has_volatile_bits(), it means,
+if it can be updated out of mmu-lock [see spte_has_volatile_bits()]; it means
 the spte is always atomically updated in this case.
 
 3) flush tlbs due to spte updated
 
-If the spte is updated from writable to readonly, we should flush all TLBs,
+If the spte is updated from writable to read-only, we should flush all TLBs,
 otherwise rmap_write_protect will find a read-only spte, even though the
 writable spte might be cached on a CPU's TLB.
 
 As mentioned before, the spte can be updated to writable out of mmu-lock on
-fast page fault path, in order to easily audit the path, we see if TLBs need
-be flushed caused by this reason in mmu_spte_update() since this is a common
+fast page fault path. In order to easily audit the path, we see if TLBs needing
+to be flushed caused this reason in mmu_spte_update() since this is a common
 function to update spte (present -> present).
 
 Since the spte is "volatile" if it can be updated out of mmu-lock, we always
-atomically update the spte, the race caused by fast page fault can be avoided,
+atomically update the spte and the race caused by fast page fault can be avoided.
 See the comments in spte_has_volatile_bits() and mmu_spte_update().
 
 Lockless Access Tracking:
@@ -283,9 +283,9 @@ time it will be set using the Dirty trac
 :Arch:		x86
 :Protects:	wakeup_vcpus_on_cpu
 :Comment:	This is a per-CPU lock and it is used for VT-d posted-interrupts.
-		When VT-d posted-interrupts is supported and the VM has assigned
+		When VT-d posted-interrupts are supported and the VM has assigned
 		devices, we put the blocked vCPU on the list blocked_vcpu_on_cpu
-		protected by blocked_vcpu_on_cpu_lock, when VT-d hardware issues
+		protected by blocked_vcpu_on_cpu_lock. When VT-d hardware issues
 		wakeup notification event since external interrupts from the
 		assigned devices happens, we will find the vCPU on the list to
 		wakeup.
