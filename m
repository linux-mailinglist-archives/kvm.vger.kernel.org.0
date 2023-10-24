Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 661EC7D48F8
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 09:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233137AbjJXHvB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 03:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233760AbjJXHu6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 03:50:58 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA350118;
        Tue, 24 Oct 2023 00:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698133855; x=1729669855;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=y4GdVfvr4r3TS2jPrXzPuftPnG1qKJX1nHclPM7uF4Y=;
  b=C+a8I5hz/snaRZa6cNTUVVPd8RqNlA21RTBnyZ4r5JoxGk6D9FQ+H1pC
   9QBV1KzH99JJlG4Gvv3JDr4dluluyBiBrX3+P6aP1zEIQBFKEYRj1bDiW
   78HQMluccYeEuXdDtvObNp4oFyMIr2VGnUAUtbubNRs1KWgoMiBebB3VO
   p3JPhSCg7WgTTygVF8ibt+4DUNLIvqCDJxS9v+MGLF+7FhTOnTUPHGGNz
   Sp6pea13iKpaDMWQ+xjt34PQWot6sMh2CWmiWD3mLZoVpqArCDgjyS7KJ
   QE+PDxHUpetyeEcYOpBv53mZlv+16OErFU6eX8gvLcqpZlLxpa1Gqu1wI
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="367235184"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="367235184"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 00:50:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="1089766233"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="1089766233"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by fmsmga005.fm.intel.com with ESMTP; 24 Oct 2023 00:50:52 -0700
From:   Dapeng Mi <dapeng1.mi@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Dapeng Mi <dapeng1.mi@intel.com>,
        Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests Patch 1/5] x86: pmu: Remove duplicate code in pmu_init()
Date:   Tue, 24 Oct 2023 15:57:44 +0800
Message-Id: <20231024075748.1675382-2-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231024075748.1675382-1-dapeng1.mi@linux.intel.com>
References: <20231024075748.1675382-1-dapeng1.mi@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Xiong Zhang <xiong.y.zhang@intel.com>

There are totally same code in pmu_init() helper, remove the duplicate
code.

Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 lib/x86/pmu.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
index 0f2afd650bc9..d06e94553024 100644
--- a/lib/x86/pmu.c
+++ b/lib/x86/pmu.c
@@ -16,11 +16,6 @@ void pmu_init(void)
 			pmu.fixed_counter_width = (cpuid_10.d >> 5) & 0xff;
 		}
 
-		if (pmu.version > 1) {
-			pmu.nr_fixed_counters = cpuid_10.d & 0x1f;
-			pmu.fixed_counter_width = (cpuid_10.d >> 5) & 0xff;
-		}
-
 		pmu.nr_gp_counters = (cpuid_10.a >> 8) & 0xff;
 		pmu.gp_counter_width = (cpuid_10.a >> 16) & 0xff;
 		pmu.gp_counter_mask_length = (cpuid_10.a >> 24) & 0xff;
-- 
2.34.1

