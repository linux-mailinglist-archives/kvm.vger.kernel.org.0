Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 134003710BF
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 06:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbhECEZs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 00:25:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:48931 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhECEZs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 May 2021 00:25:48 -0400
IronPort-SDR: xiururXPWFozdSoxHiLg3zKgqbKxxtKIpRbbB+vMvsa4vR5iB4vhOiKE8gyZqsEJBm8mxsQVTI
 V5vsmvWOf+vw==
X-IronPort-AV: E=McAfee;i="6200,9189,9972"; a="194518684"
X-IronPort-AV: E=Sophos;i="5.82,268,1613462400"; 
   d="scan'208";a="194518684"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2021 21:24:55 -0700
IronPort-SDR: KIJH8VpNWhrENTHmKsHK58xrxeY39KQE4QYn/+G/CtU/nR5k0ycc01QLEkgwsnFg76rBzDYw5X
 JOi0thy+gKwQ==
X-IronPort-AV: E=Sophos;i="5.82,268,1613462400"; 
   d="scan'208";a="432522639"
Received: from jsarvent-desk.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.135.231])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2021 21:24:53 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, bgardon@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, Kai Huang <kai.huang@intel.com>
Subject: [PATCH] KVM: x86/mmu: Fix kdoc of __handle_changed_spte
Date:   Mon,  3 May 2021 16:24:46 +1200
Message-Id: <20210503042446.154695-1-kai.huang@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The function name of kdoc of __handle_changed_spte() should be itself,
rather than handle_changed_spte().  Fix the typo.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 83cbdbe5de5a..ff0ae030004d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -388,7 +388,7 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
 }
 
 /**
- * handle_changed_spte - handle bookkeeping associated with an SPTE change
+ * __handle_changed_spte - handle bookkeeping associated with an SPTE change
  * @kvm: kvm instance
  * @as_id: the address space of the paging structure the SPTE was a part of
  * @gfn: the base GFN that was mapped by the SPTE
-- 
2.31.1

