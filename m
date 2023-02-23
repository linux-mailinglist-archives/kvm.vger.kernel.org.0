Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13BE46A025E
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 06:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbjBWF34 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 00:29:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBWF3z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 00:29:55 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24B3CA05;
        Wed, 22 Feb 2023 21:29:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677130193; x=1708666193;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=K8IMeI4Bvp4oHzpdzTBMsmizPfZAgqXCDZxNy/3Bn1k=;
  b=dPSW90Hrbt3dBW2+kwmBglQiU77wCdG0gd40pddHm1bMUctH+rDZjLoS
   SqxntP+k0CmQJMVXRhqNKSqF7m5NgNhWeFulEgEkSgPe1zOhnPmLAkond
   wN840y+AfRFac0ts+W8RtvrLjR5uxP1PtdhnSuSfM3ZcU+w+RjeYuuJpv
   jwdsk+i60fQ0M6MebuFvPnd+RhEA7F1D84HTVfJTWr1y6jlkiDCptz0tt
   7uC2Kvpuyq/dwNqKce6eVXxik/bmrsCz38uh9oJybwdvchy6K1k6DQ48q
   /jF6QGqQXG9PSmM8CyETlcStlCehLHw+8JjfEA/L6UX68zAn31O47ys/d
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10629"; a="331789151"
X-IronPort-AV: E=Sophos;i="5.97,320,1669104000"; 
   d="scan'208";a="331789151"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2023 21:29:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10629"; a="672342758"
X-IronPort-AV: E=Sophos;i="5.97,320,1669104000"; 
   d="scan'208";a="672342758"
Received: from ubuntu.bj.intel.com ([10.238.155.108])
  by orsmga002.jf.intel.com with ESMTP; 22 Feb 2023 21:29:50 -0800
From:   Jun Miao <jun.miao@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com
Cc:     kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, jun.miao@intel.com
Subject: [PATCH v2] KVM: Fix comments that refer to the non-existent install_new_memslots()
Date:   Thu, 23 Feb 2023 13:28:51 +0800
Message-Id: <20230223052851.1054799-1-jun.miao@intel.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The function of install_new_memslots() was replaced by kvm_swap_active_memslots().
In order to avoid confusion, fix the comments that refer the non-existent name of
install_new_memslots which always be ignored.

Fixes: a54d806688fe ("KVM: Keep memslots in tree-based structures instead of array-based ones")
Signed-off-by: Jun Miao <jun.miao@intel.com>
---
 Documentation/virt/kvm/locking.rst |  2 +-
 include/linux/kvm_host.h           |  4 ++--
 virt/kvm/kvm_main.c                | 10 +++++-----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index 14c4e9fa501d..6e03ad853c27 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -21,7 +21,7 @@ The acquisition orders for mutexes are as follows:
 - kvm->mn_active_invalidate_count ensures that pairs of
   invalidate_range_start() and invalidate_range_end() callbacks
   use the same memslots array.  kvm->slots_lock and kvm->slots_arch_lock
-  are taken on the waiting side in install_new_memslots, so MMU notifiers
+  are taken on the waiting side in kvm_swap_active_memslots(), so MMU notifiers
   must not take either kvm->slots_lock or kvm->slots_arch_lock.
 
 For SRCU:
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8ada23756b0e..98605bd25060 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -58,7 +58,7 @@
 
 /*
  * Bit 63 of the memslot generation number is an "update in-progress flag",
- * e.g. is temporarily set for the duration of install_new_memslots().
+ * e.g. is temporarily set for the duration of kvm_swap_active_memslots().
  * This flag effectively creates a unique generation number that is used to
  * mark cached memslot data, e.g. MMIO accesses, as potentially being stale,
  * i.e. may (or may not) have come from the previous memslots generation.
@@ -713,7 +713,7 @@ struct kvm {
 	 * use by the VM. To be used under the slots_lock (above) or in a
 	 * kvm->srcu critical section where acquiring the slots_lock would
 	 * lead to deadlock with the synchronize_srcu in
-	 * install_new_memslots.
+	 * kvm_swap_active_memslots().
 	 */
 	struct mutex slots_arch_lock;
 	struct mm_struct *mm; /* userspace tied to this vm */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d255964ec331..9f9077a898dc 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1298,7 +1298,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	 * At this point, pending calls to invalidate_range_start()
 	 * have completed but no more MMU notifiers will run, so
 	 * mn_active_invalidate_count may remain unbalanced.
-	 * No threads can be waiting in install_new_memslots as the
+	 * No threads can be waiting in kvm_swap_active_memslots() as the
 	 * last reference on KVM has been dropped, but freeing
 	 * memslots would deadlock without this manual intervention.
 	 */
@@ -1742,13 +1742,13 @@ static void kvm_invalidate_memslot(struct kvm *kvm,
 	kvm_arch_flush_shadow_memslot(kvm, old);
 	kvm_arch_guest_memory_reclaimed(kvm);
 
-	/* Was released by kvm_swap_active_memslots, reacquire. */
+	/* Was released by kvm_swap_active_memslots(), reacquire. */
 	mutex_lock(&kvm->slots_arch_lock);
 
 	/*
 	 * Copy the arch-specific field of the newly-installed slot back to the
 	 * old slot as the arch data could have changed between releasing
-	 * slots_arch_lock in install_new_memslots() and re-acquiring the lock
+	 * slots_arch_lock in kvm_swap_active_memslots() and re-acquiring the lock
 	 * above.  Writers are required to retrieve memslots *after* acquiring
 	 * slots_arch_lock, thus the active slot's data is guaranteed to be fresh.
 	 */
@@ -1810,11 +1810,11 @@ static int kvm_set_memslot(struct kvm *kvm,
 	int r;
 
 	/*
-	 * Released in kvm_swap_active_memslots.
+	 * Released in kvm_swap_active_memslots().
 	 *
 	 * Must be held from before the current memslots are copied until
 	 * after the new memslots are installed with rcu_assign_pointer,
-	 * then released before the synchronize srcu in kvm_swap_active_memslots.
+	 * then released before the synchronize srcu in kvm_swap_active_memslots().
 	 *
 	 * When modifying memslots outside of the slots_lock, must be held
 	 * before reading the pointer to the current memslots until after all
-- 
2.32.0

