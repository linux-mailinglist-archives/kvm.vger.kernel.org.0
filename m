Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7AAA673D2C
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 16:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbjASPK4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 10:10:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbjASPKu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 10:10:50 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6073769239;
        Thu, 19 Jan 2023 07:10:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674141048; x=1705677048;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3cOB46VGq8/Iw3wpbdSkSQ/qmcK81MvT/60er3OPmA4=;
  b=A7h9en3hIkou7I7AC4PBYknqxMqJLNwFZjKxbBKt34dYKkrJ5M9wsP81
   4T3k8HlmDApi2eHbzvS3DGxVDWHmI8Gj/F4XsXfl8dltaxMqgDLSIQoY2
   88n494m6OlCZKEGSbZIx26vdhBtc5D0iNcWAsHEG221O/Tkpz/RKvFY0+
   p6v+YLj5KgEd/oeewzFcFDwk/AfbltON0rYUSNMsFZ6kLR0NYcjkvEp4l
   wzU9TrOI7wpoYdkKqxe3+juw81GieMXPdDNANCFfNjIznTI1xQ8ddcZZL
   s8lwYIRb6NCE+2RU8u3J6fd/8I48Dc8yWDmF3Y/yIFL0k6VzMwcT/k9NL
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="325350478"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="325350478"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 07:10:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="610093351"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="610093351"
Received: from skxmcp01.bj.intel.com ([10.240.193.86])
  by orsmga003.jf.intel.com with ESMTP; 19 Jan 2023 07:10:46 -0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] KVM: nVMX: Remove outdated comments in nested_vmx_setup_ctls_msrs()
Date:   Thu, 19 Jan 2023 22:19:45 +0800
Message-Id: <20230119141946.585610-1-yu.c.zhang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
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
Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
---
 arch/x86/kvm/vmx/nested.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d93c715cda6a..81dfbffae575 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6863,11 +6863,6 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
 	msrs->procbased_ctls_low &=
 		~(CPU_BASED_CR3_LOAD_EXITING | CPU_BASED_CR3_STORE_EXITING);
 
-	/*
-	 * secondary cpu-based controls.  Do not include those that
-	 * depend on CPUID bits, they are added later by
-	 * vmx_vcpu_after_set_cpuid.
-	 */
 	msrs->secondary_ctls_low = 0;
 
 	msrs->secondary_ctls_high = vmcs_conf->cpu_based_2nd_exec_ctrl;
-- 
2.25.1

