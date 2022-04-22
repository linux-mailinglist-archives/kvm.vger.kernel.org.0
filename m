Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 621FA50B235
	for <lists+kvm@lfdr.de>; Fri, 22 Apr 2022 09:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445242AbiDVH6c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 03:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445164AbiDVH60 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 03:58:26 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CBAE35A92;
        Fri, 22 Apr 2022 00:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650614133; x=1682150133;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Uf5NlAoLuOXlBIrdKFym8wQ+mxT/dKFsa/Ux1rlIwNE=;
  b=FSzI6yV70eOfQtLUxURbJAl3J2AhjwGguKxbXglhXi2l5oHicCBPyAJ6
   PiZMFB4kH63yaPqgu8LFnnwlGKI6Ccuouxmy/PjGO+45CI2vcSDw0IokF
   LznC8Yc7Zs/Dj124JjQNCg7GokEZ/RHcRiLYqGhPWJC5bfKiNnxUaz4vM
   yM66rQywZJdUQKp4lON8ywceVsvGodjYk6v9raIz2Sdp8r5TnB77Up6v7
   uF9jxnzZKTLhGM9foOQfLjRSwEjFbWW1+qxicPubq5f24i3c2y3CyHdIp
   N6dnuuhFIJhd6qB4IlhuDjNZJFtsTvcRawt10rhfPT5eUA8Xs2GC2FiNA
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="264384827"
X-IronPort-AV: E=Sophos;i="5.90,281,1643702400"; 
   d="scan'208";a="264384827"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 00:55:30 -0700
X-IronPort-AV: E=Sophos;i="5.90,281,1643702400"; 
   d="scan'208";a="577741321"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 00:55:30 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, vkuznets@redhat.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Like Xu <like.xu@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v10 03/16] perf/x86/intel: Fix the comment about guest LBR support on KVM
Date:   Fri, 22 Apr 2022 03:54:56 -0400
Message-Id: <20220422075509.353942-4-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220422075509.353942-1-weijiang.yang@intel.com>
References: <20220422075509.353942-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index fc7f458eb3de..b4a0ae3eea27 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -6396,8 +6396,7 @@ __init int intel_pmu_init(void)
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

