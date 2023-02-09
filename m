Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8099C68FD36
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 03:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbjBIClV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 21:41:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbjBIClL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 21:41:11 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8428D21281
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 18:41:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675910470; x=1707446470;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QYcKa3NwIHOrY0nQ+UVoBSf9ZlO4HWnzfaKMa3h3s8U=;
  b=QyMZ8XzyIRGTLrvnFu8iotKDJ2kmxUe0ydctugvzdeav0YEQ4b2UXDPE
   w68YWTdnbLTS65pNZppYZkZVhvzEIhAsKquGZwPKNlboOFiBmncA5nEoQ
   1zzFj9SpvWuj2231pYNZycH1z5Fd8S3f41/4x/Vs/2Ip842Joogxc1yJZ
   TeirZci4MB3m1ZtODrtEv11Bk63saINOooi1ImZv0r/knKGtCi/UMFzMz
   7BaWMHWp8Rda0WcNRYy9Rrlssg/7JyLGKXb77kLEIDyEBGYqfyOK6f1zC
   tNsJvHnJRxfyws1sJxX5iqYm7XochE9wfhLIbMfWwhOabgTzazPdrtfPE
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="394586616"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="394586616"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 18:41:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="645094384"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="645094384"
Received: from sqa-gate.sh.intel.com (HELO robert-clx2.tsp.org) ([10.239.48.212])
  by orsmga006.jf.intel.com with ESMTP; 08 Feb 2023 18:41:01 -0800
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, yu.c.zhang@linux.intel.com,
        yuan.yao@linux.intel.com, jingqi.liu@intel.com,
        weijiang.yang@intel.com, chao.gao@intel.com,
        isaku.yamahata@intel.com
Cc:     kirill.shutemov@linux.intel.com, kvm@vger.kernel.org,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v4 3/9] KVM: x86: MMU: Commets update
Date:   Thu,  9 Feb 2023 10:40:16 +0800
Message-Id: <20230209024022.3371768-4-robert.hu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230209024022.3371768-1-robert.hu@linux.intel.com>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index 1d61dfe37c77..9a780445a88e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4497,8 +4497,12 @@ void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
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

