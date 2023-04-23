Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 349156EBE71
	for <lists+kvm@lfdr.de>; Sun, 23 Apr 2023 12:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjDWKLY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Apr 2023 06:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbjDWKLW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Apr 2023 06:11:22 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D96C819A6
        for <kvm@vger.kernel.org>; Sun, 23 Apr 2023 03:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682244681; x=1713780681;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Kb5MSFctci33XXK+rGGrVMQNXuMftwF2+MW8h4EFB5s=;
  b=OFZ+obXiGLx3AkYaEPsIxkP1Kfj2KWkheaDPfbejeiv1Igx7Tpgthe/S
   YV3P4y+xNBdgmQcI9u8P2jVEFuYfVL8IPe45B55eRsxRPL82MxgDGiCMM
   tGgS9CTcI8GRhyfYzUmCkdQjeN569074MTPMsjK9Q25vYMuJjV78s4oGB
   m2cw2CGfZro7vHbY+OkaWkwVOw2xgD/iKUjMMmZhtTB5sYGJtLmacmWfQ
   Cqw0BPi/MCaGPebkDZRCdSW0G1ZoYW2vWT1Js3ut+Ub+WreAna0VUDaub
   ZSA/rJ3Q+/W1nGEHRDDbExWEt+0BjkCw58OACSLqbVVldh3kYnpGb9ToK
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10688"; a="348173936"
X-IronPort-AV: E=Sophos;i="5.99,220,1677571200"; 
   d="scan'208";a="348173936"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2023 03:11:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10688"; a="938974058"
X-IronPort-AV: E=Sophos;i="5.99,220,1677571200"; 
   d="scan'208";a="938974058"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.254.214.112])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2023 03:11:20 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, binbin.wu@linux.intel.com
Subject: [PATCH 2/2] KVM: x86: Fix some comments
Date:   Sun, 23 Apr 2023 18:11:12 +0800
Message-Id: <20230423101112.13803-3-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230423101112.13803-1-binbin.wu@linux.intel.com>
References: <20230423101112.13803-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

msrs_to_save_all is out-dated after commit 2374b7310b66
(KVM: x86/pmu: Use separate array for defining "PMU MSRs to save").
Update the comments to msrs_to_save_base.

Fix a typo in x86 mmu.rst.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
 Documentation/virt/kvm/x86/mmu.rst | 2 +-
 arch/x86/kvm/x86.c                 | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/x86/mmu.rst b/Documentation/virt/kvm/x86/mmu.rst
index 8364afa228ec..26f62034b6f3 100644
--- a/Documentation/virt/kvm/x86/mmu.rst
+++ b/Documentation/virt/kvm/x86/mmu.rst
@@ -205,7 +205,7 @@ Shadow pages contain the following information:
   role.passthrough:
     The page is not backed by a guest page table, but its first entry
     points to one.  This is set if NPT uses 5-level page tables (host
-    CR4.LA57=1) and is shadowing L1's 4-level NPT (L1 CR4.LA57=1).
+    CR4.LA57=1) and is shadowing L1's 4-level NPT (L1 CR4.LA57=0).
   gfn:
     Either the guest page table containing the translations shadowed by this
     page, or the base page frame for linear translations.  See role.direct.
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1b74da8682a0..d02150a1c909 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1430,7 +1430,7 @@ EXPORT_SYMBOL_GPL(kvm_emulate_rdpmc);
  *
  * The three MSR lists(msrs_to_save, emulated_msrs, msr_based_features)
  * extract the supported MSRs from the related const lists.
- * msrs_to_save is selected from the msrs_to_save_all to reflect the
+ * msrs_to_save is selected from the msrs_to_save_base to reflect the
  * capabilities of the host cpu. This capabilities test skips MSRs that are
  * kvm-specific. Those are put in emulated_msrs_all; filtering of emulated_msrs
  * may depend on host virtualization features rather than host cpu features.
@@ -1533,7 +1533,7 @@ static const u32 emulated_msrs_all[] = {
 	 * by arch/x86/kvm/vmx/nested.c based on CPUID or other MSRs.
 	 * We always support the "true" VMX control MSRs, even if the host
 	 * processor does not, so I am putting these registers here rather
-	 * than in msrs_to_save_all.
+	 * than in msrs_to_save_base.
 	 */
 	MSR_IA32_VMX_BASIC,
 	MSR_IA32_VMX_TRUE_PINBASED_CTLS,
-- 
2.25.1

