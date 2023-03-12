Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C39416B644A
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbjCLJyD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbjCLJyC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:54:02 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA74938E89
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:53:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614836; x=1710150836;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2B4qtDpi2jNJ87Wd1oN5FcO1wIzRWYFg54VEZ4qNneI=;
  b=LJVnPHq0P6uadkxT45RL8F/l2aPBCLNNisF9hdynzB1aRJ6AoPBx1dZs
   WBg86RcFnhiq+v+C2KhbBGYRx5Sg3w0C7ngAkUYvjxO1i1MYr6stWUg2i
   zRC5fW6b/zLyTGBM4apeOjvnOzoaaGShSmAigwWJ+voUNL4Hgw2N1EE2b
   C3GY3zC7l6yh/gLOsewLGl/7qMQKtlvslovujfOqZGCwZhO8qLMg9QE4T
   K492YCMwAvcc+9YrolJbLV30d2TGDvS5vAQnLsOc/6a5cR1GYyxVxnPFh
   CLffN3bFeamaokbTdJJhmru11u8OaPFC26+3G3VeWb5jwarcRWEY/5TO3
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316622820"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316622820"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:53:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="852408899"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="852408899"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:53:54 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-1 1/5] pkvm: arm64: Move nvhe/spinlock.h to include/asm dir
Date:   Mon, 13 Mar 2023 02:00:44 +0800
Message-Id: <20230312180048.1778187-2-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180048.1778187-1-jason.cj.chen@intel.com>
References: <20230312180048.1778187-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move nvhe/spinlock.h to include/asm dir, and rename to pkvm_spinlock.h.
This help to expose spinlock for pKVM, which is needed by the following
patch of moving pKVM page allocator to general dir.

Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 .../include/nvhe/spinlock.h => include/asm/pkvm_spinlock.h} | 6 +++---
 arch/arm64/kvm/hyp/include/nvhe/gfp.h                       | 2 +-
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h               | 2 +-
 arch/arm64/kvm/hyp/include/nvhe/mm.h                        | 2 +-
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h                      | 2 +-
 arch/arm64/kvm/hyp/nvhe/mm.c                                | 2 +-
 6 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/spinlock.h b/arch/arm64/include/asm/pkvm_spinlock.h
similarity index 95%
rename from arch/arm64/kvm/hyp/include/nvhe/spinlock.h
rename to arch/arm64/include/asm/pkvm_spinlock.h
index 7c7ea8c55405..456417b40645 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/spinlock.h
+++ b/arch/arm64/include/asm/pkvm_spinlock.h
@@ -10,8 +10,8 @@
  * Copyright (C) 2012 ARM Ltd.
  */
 
-#ifndef __ARM64_KVM_NVHE_SPINLOCK_H__
-#define __ARM64_KVM_NVHE_SPINLOCK_H__
+#ifndef __ARM64_ASM_PKVM_SPINLOCK_H__
+#define __ARM64_ASM_PKVM_SPINLOCK_H__
 
 #include <asm/alternative.h>
 #include <asm/lse.h>
@@ -122,4 +122,4 @@ static inline void hyp_assert_lock_held(hyp_spinlock_t *lock)
 static inline void hyp_assert_lock_held(hyp_spinlock_t *lock) { }
 #endif
 
-#endif /* __ARM64_KVM_NVHE_SPINLOCK_H__ */
+#endif /* __ARM64_ASM_PKVM_SPINLOCK_H__ */
diff --git a/arch/arm64/kvm/hyp/include/nvhe/gfp.h b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
index 0a048dc06a7d..58e9f15b6a64 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/gfp.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
@@ -5,7 +5,7 @@
 #include <linux/list.h>
 
 #include <nvhe/memory.h>
-#include <nvhe/spinlock.h>
+#include <asm/pkvm_spinlock.h>
 
 #define HYP_NO_ORDER	USHRT_MAX
 
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index b7bdbe63deed..12b5db7a1ffe 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -12,7 +12,7 @@
 #include <asm/kvm_pgtable.h>
 #include <asm/virt.h>
 #include <nvhe/pkvm.h>
-#include <nvhe/spinlock.h>
+#include <asm/pkvm_spinlock.h>
 
 /*
  * SW bits 0-1 are reserved to track the memory ownership state of each page:
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
index d5ec972b5c1e..1d50bb1da315 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -8,7 +8,7 @@
 #include <linux/types.h>
 
 #include <nvhe/memory.h>
-#include <nvhe/spinlock.h>
+#include <asm/pkvm_spinlock.h>
 
 extern struct kvm_pgtable pkvm_pgtable;
 extern hyp_spinlock_t pkvm_pgd_lock;
diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index 82b3d62538a6..992d3492297b 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -10,7 +10,7 @@
 #include <asm/kvm_pkvm.h>
 
 #include <nvhe/gfp.h>
-#include <nvhe/spinlock.h>
+#include <asm/pkvm_spinlock.h>
 
 /*
  * Holds the relevant data for maintaining the vcpu state completely at hyp.
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index 318298eb3d6b..9f740e441bce 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -16,7 +16,7 @@
 #include <nvhe/memory.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
-#include <nvhe/spinlock.h>
+#include <asm/pkvm_spinlock.h>
 
 struct kvm_pgtable pkvm_pgtable;
 hyp_spinlock_t pkvm_pgd_lock;
-- 
2.25.1

