Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB2760073C
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 09:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbiJQHFl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 03:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbiJQHF3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 03:05:29 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1F92ED74
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 00:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665990328; x=1697526328;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tu83SZoF/RacnhkbCYiD4Vw9+wYNgusGRn+uARJfeBo=;
  b=Dok1g1gLl6II+FRLKTB7uFc9rpkRBiSk6DiH01tK2HaX5KSNjfd6in3c
   vBZmNLLW2yRY73uqdubHVjOMBYPGfys+k5UQvNf0G/MJIgwCO0jOl3laz
   8rO78OcO8NEm97f2bw+LatZD6U9JdepGBygmYvk6dmwdy+2SgngBgcz/G
   3k+0u8e8hV+yfQxLgjjcqfbtwL1DXsQ9mpl8p39OlWsXMYOz3E46I2ztu
   wZflZeskvhZFMWcdbOYXzYgzPJNtfmkPxLS8mMgZIAxFE3N9ypEVUI6X2
   6HZg6gLSD1M0Rce/pwc85TixLLOvJmmtCjQNbJFz1YNXqEIqcfL6OmF8P
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10502"; a="306805992"
X-IronPort-AV: E=Sophos;i="5.95,190,1661842800"; 
   d="scan'208";a="306805992"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2022 00:05:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10502"; a="579271376"
X-IronPort-AV: E=Sophos;i="5.95,190,1661842800"; 
   d="scan'208";a="579271376"
Received: from sqa-gate.sh.intel.com (HELO robert-clx2.tsp.org) ([10.239.48.212])
  by orsmga003.jf.intel.com with ESMTP; 17 Oct 2022 00:05:19 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH 4/9] [Trivial] KVM: x86: MMU: Commets update
Date:   Mon, 17 Oct 2022 15:04:45 +0800
Message-Id: <20221017070450.23031-5-robert.hu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221017070450.23031-1-robert.hu@linux.intel.com>
References: <20221017070450.23031-1-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 385a1a9b1ac4..315456f30964 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4437,8 +4437,12 @@ void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
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

