Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4289764D9D3
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 11:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbiLOK4R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 05:56:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbiLOK4D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 05:56:03 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4DE2CE30;
        Thu, 15 Dec 2022 02:55:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671101759; x=1702637759;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ewl61zMt+xWW5epCxoSU4VxrJv8NtqxzsHSTsrgEojM=;
  b=Fc+1KKWOsfXPARZwYjGtaBOdAlr6JI+aM0vd3Os/jYSIyJpCEMVd3RuF
   XgOMhFcFNUqpr7PGaxMaj1YqvUjGlPuqRZWrYTisS6R+HzV2Tz7ch19ML
   yI51Dgemqb20HGURjAFhGFZrnOxdqFn6wjqJvg66nQE30Boyxp0KM3P1E
   I6tQbSKpr4WcxCwe7snlTFTwVgeydB4xDPMqnE8D+A2JTmO9m/06cY3ks
   iMNfiU9k0M6StttNUkSjvK5YxIdknFbmVUqI0X7vAX2UVsqp0k5mZro74
   CqZWK2hKZnHZP9v+EDI+xDBnGTA3VN8KC3jYkLdqe1e0X+f+kdNx4e/iG
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="316285437"
X-IronPort-AV: E=Sophos;i="5.96,247,1665471600"; 
   d="scan'208";a="316285437"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 02:55:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="738054024"
X-IronPort-AV: E=Sophos;i="5.96,247,1665471600"; 
   d="scan'208";a="738054024"
Received: from skxmcp01.bj.intel.com ([10.240.193.86])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Dec 2022 02:55:57 -0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: nVMX: Remove outdated comments in nested_vmx_setup_ctls_msrs().
Date:   Thu, 15 Dec 2022 18:05:58 +0800
Message-Id: <20221215100558.1202615-1-yu.c.zhang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

nested_vmx_setup_ctls_msrs() initializes the vmcs_conf.nested,
which stores the global VMX MSR configurations when nested is
supported, regardless of any particular CPUID settings for one
VM.

Commit 6defc591846d ("KVM: nVMX: include conditional controls
in /dev/kvm KVM_GET_MSRS") added the some feature flags for
secondary proc-based controls, so that those features can be
available in KVM_GET_MSRS. Yet this commit did not remove the
obsolete comments in nested_vmx_setup_ctls_msrs().

Just fix the comments, and no functional change intended.

Fixes: 6defc591846d ("KVM: nVMX: include conditional controls in /dev/kvm KVM_GET_MSRS")
Reported-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
---
 arch/x86/kvm/vmx/nested.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b6f4411b613e..76cca5d5aa6b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6854,11 +6854,7 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
 	msrs->procbased_ctls_low &=
 		~(CPU_BASED_CR3_LOAD_EXITING | CPU_BASED_CR3_STORE_EXITING);
 
-	/*
-	 * secondary cpu-based controls.  Do not include those that
-	 * depend on CPUID bits, they are added later by
-	 * vmx_vcpu_after_set_cpuid.
-	 */
+	/* secondary cpu-based controls */
 	msrs->secondary_ctls_low = 0;
 
 	msrs->secondary_ctls_high = vmcs_conf->cpu_based_2nd_exec_ctrl;
-- 
2.17.1

