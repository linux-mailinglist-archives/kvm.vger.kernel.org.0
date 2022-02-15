Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D85C24B8591
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 11:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232978AbiBPK1R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 05:27:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232845AbiBPK1F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 05:27:05 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 951F7206995;
        Wed, 16 Feb 2022 02:26:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645007213; x=1676543213;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XYYRmnMXn0p1yU77umZ0EA7rGS8W/A5csOU+/9Nx74U=;
  b=cDe0duQnlUN6WyGXQB7N943Zqm8hR/4TT9bkaJ1L5C6WI6oQ3seICyUF
   Z7yqpV6GC3tZtVBpiVfJyF6TDJHV7I4iHkUM1OnI5ZwRrWNJfzhS8OVA8
   fy0vJyc4BBmhrlJcVr2D8rKsx3DA0ncxhntx/W1yz1QAWJtMXIQk5AgZ3
   XFDrerSgoOM3dThRiPG/8b6a23zgMC9fs93zMuPm1BT1N9cEZCliy0wyp
   Tgrc2AJAKnqi000VkxbOu/wHGl1AEBL0VIPuAciPYDdrSIRJlJjKzRwNC
   V+0KFKyImESof4zlPzxV9jYUNzWAJJefsNgIqssqLZT7bDYz5SFRu6VED
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="231201161"
X-IronPort-AV: E=Sophos;i="5.88,373,1635231600"; 
   d="scan'208";a="231201161"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 02:26:51 -0800
X-IronPort-AV: E=Sophos;i="5.88,373,1635231600"; 
   d="scan'208";a="498708580"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 02:26:50 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, vkuznets@redhat.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Like Xu <like.xu@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v9 04/17] perf/x86/intel: Fix the comment about guest LBR support on KVM
Date:   Tue, 15 Feb 2022 16:25:31 -0500
Message-Id: <20220215212544.51666-5-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220215212544.51666-1-weijiang.yang@intel.com>
References: <20220215212544.51666-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
index a3c7ca876aeb..f216431135bd 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -6353,8 +6353,7 @@ __init int intel_pmu_init(void)
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

