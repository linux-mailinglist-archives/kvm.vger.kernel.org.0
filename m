Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1A9469C6F0
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 09:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbjBTIqD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 03:46:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbjBTIqC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 03:46:02 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69936C164;
        Mon, 20 Feb 2023 00:46:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676882761; x=1708418761;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wRQGYaheBX/3R65qusfDmCgRZiKlnsyVOKTVMzWu8mU=;
  b=i5luY265oCVq/31UUV6ZV4MyWDJehytFgTyoKRfJ5hUNIXTiORDT2M8W
   hntlinFB8WPopZhwpxIUCXjVOjG3i5iqFk7Tz2ApGnDCH4HPLA3A0Bol9
   3wn3QtTdOomrulRzD4sEGo0Jg59WD1TSczIYYV3KWJvg0NFoSV4LYpL7i
   jfnSNVmNk+2DRo+iGy5wbAeihhz7CwozvLVXepFoAo++9rKimV5G1eeeI
   +Kyie2qA3dUpw4Ubm0NxfP7a9a7lOffsfQI3s//Hm/yZUAXxbtWNtOwQT
   0A8AdEFgty1cBvls6t0ID0U+yAHKRUXv5MRprESHj8om6p0XQ4C78rpSn
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10626"; a="330068036"
X-IronPort-AV: E=Sophos;i="5.97,312,1669104000"; 
   d="scan'208";a="330068036"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2023 00:46:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10626"; a="664567879"
X-IronPort-AV: E=Sophos;i="5.97,312,1669104000"; 
   d="scan'208";a="664567879"
Received: from ubuntu.bj.intel.com ([10.238.155.108])
  by orsmga007.jf.intel.com with ESMTP; 20 Feb 2023 00:45:58 -0800
From:   Jun Miao <jun.miao@intel.com>
To:     pbonzini@redhat.com, corbet@lwn.net
Cc:     seanjc@google.com, maciej.szmigiero@oracle.com,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, jun.miao@intel.com
Subject: [PATCH] KVM: Align the function name of kvm_swap_active_memslots()
Date:   Mon, 20 Feb 2023 16:45:00 +0800
Message-Id: <20230220084500.938739-1-jun.miao@intel.com>
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

The function of install_new_memslots() is replaced by kvm_swap_active_memslots().
In order to avoid confusion, align the name in the comments which always be ignored.

Fixes: a54d806688fe "KVM: Keep memslots in tree-based structures instead of array-based ones")
Signed-off-by: Jun Miao <jun.miao@intel.com>
---
 Documentation/virt/kvm/locking.rst | 2 +-
 include/linux/kvm_host.h           | 4 ++--
 virt/kvm/kvm_main.c                | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index 14c4e9fa501d..ac0e549a3ae7 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -21,7 +21,7 @@ The acquisition orders for mutexes are as follows:
 - kvm->mn_active_invalidate_count ensures that pairs of
   invalidate_range_start() and invalidate_range_end() callbacks
   use the same memslots array.  kvm->slots_lock and kvm->slots_arch_lock
-  are taken on the waiting side in install_new_memslots, so MMU notifiers
+  are taken on the waiting side in kvm_swap_active_memslots, so MMU notifiers
   must not take either kvm->slots_lock or kvm->slots_arch_lock.
 
 For SRCU:
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8ada23756b0e..7f8242dd2745 100644
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
+	 * kvm_swap_active_memslots.
 	 */
 	struct mutex slots_arch_lock;
 	struct mm_struct *mm; /* userspace tied to this vm */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d255964ec331..7a4ff9fc5978 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1298,7 +1298,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	 * At this point, pending calls to invalidate_range_start()
 	 * have completed but no more MMU notifiers will run, so
 	 * mn_active_invalidate_count may remain unbalanced.
-	 * No threads can be waiting in install_new_memslots as the
+	 * No threads can be waiting in kvm_swap_active_memslots as the
 	 * last reference on KVM has been dropped, but freeing
 	 * memslots would deadlock without this manual intervention.
 	 */
@@ -1748,7 +1748,7 @@ static void kvm_invalidate_memslot(struct kvm *kvm,
 	/*
 	 * Copy the arch-specific field of the newly-installed slot back to the
 	 * old slot as the arch data could have changed between releasing
-	 * slots_arch_lock in install_new_memslots() and re-acquiring the lock
+	 * slots_arch_lock in kvm_swap_active_memslots() and re-acquiring the lock
 	 * above.  Writers are required to retrieve memslots *after* acquiring
 	 * slots_arch_lock, thus the active slot's data is guaranteed to be fresh.
 	 */
-- 
2.32.0

