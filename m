Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DADD2647D03
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 05:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiLIEqS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 23:46:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiLIEqP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 23:46:15 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50D67D052
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 20:46:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670561171; x=1702097171;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cfcGuqjmJd9mFhP+Pvw2L6NRRFKtmKzaIwxt5GjI4O0=;
  b=SPnNYF7QW6rlBN1KxlBYcRGN3VeynaSijDOpcNA5jFt1GhJx8qrfGE8V
   rLOsaC+j7w7sAOS7c2FzUu2TiFD8AndK/g38U01OqB3aQBny4mG3dh2yv
   2VfGeGWuedE7SxxAqa9t2Ruk68pgF7VLLKvypXyPPBk4iEbzfnN+CJ0n/
   yomKOD61mebwGDSgCL2loXJogG+LJk7Bgt2zdtbjUzfRcLmPxAXVeg936
   LaM2lRcvfNA/IVaLpjwr+S/5h9dpItu60DQNxzg+kqEf1ynLj/nG/+8bT
   FbHVVWPCYTQk7rQQwjHLixPNz2ddrpub2OiMg6hn0vmi0CPGqno9WIuBG
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="318530842"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="318530842"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 20:46:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="892524442"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="892524442"
Received: from sqa-gate.sh.intel.com (HELO robert-clx2.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 08 Dec 2022 20:46:10 -0800
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org
Cc:     Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v3 4/9] KVM: x86: MMU: Commets update
Date:   Fri,  9 Dec 2022 12:45:52 +0800
Message-Id: <20221209044557.1496580-5-robert.hu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221209044557.1496580-1-robert.hu@linux.intel.com>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_mmu_ensure_valid_pgd() is stale. Update the comments according to
latest code.

No function changes.

P.S. Sean firstly noticed this in
https://lore.kernel.org/kvm/Yg%2FguAXFLJBmDflh@google.com/.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d433c8923b18..450500086932 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4452,8 +4452,12 @@ void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	union kvm_mmu_page_role new_role = mmu->root_role;
 
+	/*
+	 * If no root is found in cache, current active root.hpa will be (set)
+	 * INVALID_PAGE, a new root will be set up during vcpu_enter_guest()
+	 * --> kvm_mmu_reload().
+	 */
 	if (!fast_pgd_switch(vcpu->kvm, mmu, new_pgd, new_role)) {
-		/* kvm_mmu_ensure_valid_pgd will set up a new root.  */
 		return;
 	}
 
-- 
2.31.1

