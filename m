Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9CE377DCD
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 10:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbhEJIR0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 04:17:26 -0400
Received: from mga12.intel.com ([192.55.52.136]:42716 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230247AbhEJIRW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 04:17:22 -0400
IronPort-SDR: 9qwGzIWPLXjRmc6axNEsIp0//+m0HPNeoPQxLmfuebVtC+0TXg4UWNj1zeDQJZ3GivbhzO4D/O
 WFCuou+l5+ig==
X-IronPort-AV: E=McAfee;i="6200,9189,9979"; a="178727692"
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="178727692"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2021 01:16:18 -0700
IronPort-SDR: A8O24rmZPMITHaXTHS0g7m9BXC0WTkqwm3V1YI0XUwBk5fle9Ddoeydih1v/U3dUn6YYtesOb5
 kfnPuvfGxihQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="408250826"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga002.jf.intel.com with ESMTP; 10 May 2021 01:16:15 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RESEND PATCH v4 01/10] perf/x86/intel: Fix the comment about guest LBR support on KVM
Date:   Mon, 10 May 2021 16:15:25 +0800
Message-Id: <20210510081535.94184-2-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510081535.94184-1-like.xu@linux.intel.com>
References: <20210510081535.94184-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Starting from v5.12, KVM reports guest LBR and extra_regs support
when the host has relevant support. Just delete this part of the
comment and fix a typo incidentally.

Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
---
I personally recommend this patch to hit the mainline through the KVM tree.

 arch/x86/events/intel/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 2521d03de5e0..612b4bcf0634 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -6249,8 +6249,7 @@ __init int intel_pmu_init(void)
 					  x86_pmu.intel_ctrl);
 	/*
 	 * Access LBR MSR may cause #GP under certain circumstances.
-	 * E.g. KVM doesn't support LBR MSR
-	 * Check all LBT MSR here.
+	 * Check all LBR MSR here.
 	 * Disable LBR access if any LBR MSRs can not be accessed.
 	 */
 	if (x86_pmu.lbr_nr && !check_msr(x86_pmu.lbr_tos, 0x3UL))
-- 
2.31.1

