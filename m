Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0BA052A721
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 17:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350594AbiEQPl6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 11:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350460AbiEQPle (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 11:41:34 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AEC940E7C;
        Tue, 17 May 2022 08:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652802094; x=1684338094;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GOB8cTBeHai+pCWfEMfwO/R4JwVJByoNcZuExMPWTjs=;
  b=nMvG6fIbXkWlSDIVi6dcdpebwOfk3EW+RRaGxTeHW0qMi0Y7KeA6LTkV
   iAjZ+IdtSGSX6RmetiWQX4QkGDl9J+AIvgfAIjEQataGqNRAqnY53MlTl
   q0XnBNF35yJih81UL8V0C2mAGZVET4XAnSygnUKTS40QJ0y0656ptS1oh
   0NDkM1IrvRFu14qsUPLN4YJE/ZI3tPFgNLROYWyQEue4oXUngG9gT84Wi
   oZCBray/cslhqpgZYoJ5cKiFOPd2yc9TEcV0rPa6NoXriM7pUVF18oK0/
   pvJkl8mXmofu10xHIl9NB0tMeoDIj6dsZBF3xb1eZnnl7Dgbt0rOtFkTH
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10350"; a="357632092"
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="357632092"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 08:41:32 -0700
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="626533547"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 08:41:32 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, vkuznets@redhat.com,
        kan.liang@linux.intel.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Like Xu <like.xu@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v12 01/16] perf/x86/intel: Fix the comment about guest LBR support on KVM
Date:   Tue, 17 May 2022 11:40:45 -0400
Message-Id: <20220517154100.29983-2-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220517154100.29983-1-weijiang.yang@intel.com>
References: <20220517154100.29983-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

Starting from v5.12, KVM reports guest LBR and extra_regs support
when the host has relevant support. Just delete this part of the
comment and fix a typo incidentally.

Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/events/intel/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index f136be17c1e2..1c70ab856bf4 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -6494,8 +6494,7 @@ __init int intel_pmu_init(void)
 					  x86_pmu.intel_ctrl);
 	/*
 	 * Access LBR MSR may cause #GP under certain circumstances.
-	 * E.g. KVM doesn't support LBR MSR
-	 * Check all LBT MSR here.
+	 * Check all LBR MSR here.
 	 * Disable LBR access if any LBR MSRs can not be accessed.
 	 */
 	if (x86_pmu.lbr_tos && !check_msr(x86_pmu.lbr_tos, 0x3UL))
-- 
2.27.0

