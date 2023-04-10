Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 856886DC6EC
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 14:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjDJMug (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 08:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjDJMu1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 08:50:27 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D227D84;
        Mon, 10 Apr 2023 05:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681131025; x=1712667025;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g+1+1pWWmsug5/Dns9GEoG9llMqB6VBF1AwE2jD44ss=;
  b=irS6TBhcIYUFJ2f/gS77b1PP7tfwu8GbiYgPszHm1ObxxlZyotweUocV
   8MpInpGZcSQauSl2w6SfBu+biVo83hayVNcy0v77qrfdzYjAtk6jWoPil
   gSRx42mybz2uVaLlu/G5D2VgSMDhvFGvqMocqb/RCi7ex4BdQQS3pHSJV
   Ou/sovGmffEYBqrVNrOzKvrmgP6S+B1WtMPJb5o/SVc+fpm6Suasn7qDb
   tjKIvT0XRpzA0NPo69CK8MyAD8Vob1SSa30+Ujr3MwbeUbvz5RNEufg4J
   coKg2dZkRBA548pil6Lk2IUDTTaq4JN4sv0+Ym56XYEjKJguYb5GW+tzg
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10675"; a="371183499"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="371183499"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 05:50:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10675"; a="638455270"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="638455270"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by orsmga003.jf.intel.com with ESMTP; 10 Apr 2023 05:50:23 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        xiaoyao.li@intel.com
Subject: [PATCH 2/2] KVM: VMX: Move the comment of CR4.MCE handling right above the code
Date:   Mon, 10 Apr 2023 08:50:17 -0400
Message-Id: <20230410125017.1305238-3-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230410125017.1305238-1-xiaoyao.li@intel.com>
References: <20230410125017.1305238-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

... to improve the code readability.

No functional change indented.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index befa2486836b..c9421eb25666 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3433,13 +3433,13 @@ void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	unsigned long old_cr4 = kvm_read_cr4(vcpu);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	unsigned long hw_cr4;
+
 	/*
 	 * Pass through host's Machine Check Enable value to hw_cr4, which
 	 * is in force while we are in guest mode.  Do not let guests control
 	 * this bit, even if host CR4.MCE == 0.
 	 */
-	unsigned long hw_cr4;
-
 	hw_cr4 = (cr4_read_shadow() & X86_CR4_MCE) | (cr4 & ~X86_CR4_MCE);
 	if (is_unrestricted_guest(vcpu))
 		hw_cr4 |= KVM_VM_CR4_ALWAYS_ON_UNRESTRICTED_GUEST;
-- 
2.34.1

