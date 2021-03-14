Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50FE633A5E0
	for <lists+kvm@lfdr.de>; Sun, 14 Mar 2021 17:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234091AbhCNQAo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Mar 2021 12:00:44 -0400
Received: from mga14.intel.com ([192.55.52.115]:7144 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234000AbhCNQA1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 14 Mar 2021 12:00:27 -0400
IronPort-SDR: OVHdDJDy761aUVz4NoFLlpG4uDoeeGp9PvrRzDTHod5skRaHsnNeXddh0kPmJOdDIsYKaj7+Qx
 Pm1ZH49cI29Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9923"; a="188360683"
X-IronPort-AV: E=Sophos;i="5.81,248,1610438400"; 
   d="scan'208";a="188360683"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2021 09:00:27 -0700
IronPort-SDR: rHulesa4GWG3LXQatPywhm6YX639LoH5hnEwNnxYhjw9VPvP0WQD8jeo5aHCTUGCguu+tK3lBt
 wKDcqn22juWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,248,1610438400"; 
   d="scan'208";a="439530609"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Mar 2021 09:00:24 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, wei.w.wang@intel.com, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH v4 01/11] perf/x86/intel: Fix the comment about guest LBR support on KVM
Date:   Sun, 14 Mar 2021 23:52:14 +0800
Message-Id: <20210314155225.206661-2-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210314155225.206661-1-like.xu@linux.intel.com>
References: <20210314155225.206661-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Starting from v5.12, KVM reports guest LBR and extra_regs support
when the host has relevant support. Just delete this part of the
comment and fix a typo.

Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/events/intel/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index d4569bfa83e3..7bb96ac87615 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -5565,8 +5565,7 @@ __init int intel_pmu_init(void)
 
 	/*
 	 * Access LBR MSR may cause #GP under certain circumstances.
-	 * E.g. KVM doesn't support LBR MSR
-	 * Check all LBT MSR here.
+	 * Check all LBR MSR here.
 	 * Disable LBR access if any LBR MSRs can not be accessed.
 	 */
 	if (x86_pmu.lbr_nr && !check_msr(x86_pmu.lbr_tos, 0x3UL))
-- 
2.29.2

