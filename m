Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D72C348D4DE
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 10:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbiAMJPh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 04:15:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:19796 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232662AbiAMJNZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 04:13:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642065205; x=1673601205;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CkwE9r4swjvAVRf2un3ZUZyY1myOpPsqaQPExNGcgoY=;
  b=Q/sq39oBnvH2DTkTBj2tnrxh7ZypoliyfYI4Md9vEyNWRBAO2Zd42F5r
   0fNb8Z7qXbP2dKtCstRmNKklev0Pd3+ozdfy8XBq6jgUBdcHa8pQqR+Ft
   fFUc5LgW3DBv1aLv3zKCXspZT0BOU0RDieEwwlUf5MeQA8T5SGYzW4xAx
   JhuhYINJr79nFD8nbUaXopht9H5UmCxAA03Ekivlk+9qgjurDKtLO0YcL
   Vni4fHBVlJD3YH4YnT9adaRLnerbCUx2uHlV5t42xfKTtJ4uT7D/gbjRF
   /wEX/j14XJzna9hY4X9w29/cXW/uNoaDYe4exDYiOXaaG6e3ZZo2XTycz
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10225"; a="243762775"
X-IronPort-AV: E=Sophos;i="5.88,284,1635231600"; 
   d="scan'208";a="243762775"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 01:13:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,284,1635231600"; 
   d="scan'208";a="529587633"
Received: from icx.bj.intel.com ([10.240.192.117])
  by orsmga008.jf.intel.com with ESMTP; 13 Jan 2022 01:13:18 -0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     x86@kernel.org, kvm@vger.kernel.org, tglx@linutronix.de,
        pbonzini@redhat.com
Cc:     kevin.tian@intel.com, jing2.liu@linux.intel.com,
        yang.zhong@intel.com
Subject: [PATCH] x86/fpu: Fix inline prefix warnings
Date:   Thu, 13 Jan 2022 13:08:25 -0500
Message-Id: <20220113180825.322333-1-yang.zhong@intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix sparse warnings in xstate and remove inline prefix.

Fixes: 980fe2fddcff ("x86/fpu: Extend fpu_xstate_prctl() with guest permissions")
Signed-off-by: Yang Zhong <yang.zhong@intel.com>
Reported-by: kernel test robot <lkp@intel.com>
---
 arch/x86/include/asm/fpu/api.h | 2 +-
 arch/x86/kernel/fpu/xstate.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
index a467eb80f9ed..c83b3020350a 100644
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -132,7 +132,7 @@ static inline void fpstate_free(struct fpu *fpu) { }
 /* fpstate-related functions which are exported to KVM */
 extern void fpstate_clear_xstate_component(struct fpstate *fps, unsigned int xfeature);
 
-extern inline u64 xstate_get_guest_group_perm(void);
+extern u64 xstate_get_guest_group_perm(void);
 
 /* KVM specific functions */
 extern bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu);
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 10fe072f1c92..02b3ddaf4f75 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1744,7 +1744,7 @@ static inline int xstate_request_perm(unsigned long idx, bool guest)
 }
 #endif  /* !CONFIG_X86_64 */
 
-inline u64 xstate_get_guest_group_perm(void)
+u64 xstate_get_guest_group_perm(void)
 {
 	return xstate_get_group_perm(true);
 }
