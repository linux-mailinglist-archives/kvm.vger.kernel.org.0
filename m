Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5601B2D21A2
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 04:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgLHD4p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 22:56:45 -0500
Received: from mga14.intel.com ([192.55.52.115]:59706 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726556AbgLHD4p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 22:56:45 -0500
IronPort-SDR: Pevb0BF4lHRIr9bC7/RguIX0ejY0RSmGRQCwxdqvVSsW7OZisJprRxjd1se5fDvqw039bB4FT7
 ILJtYha9SufQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9828"; a="173060182"
X-IronPort-AV: E=Sophos;i="5.78,401,1599548400"; 
   d="scan'208";a="173060182"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2020 19:55:35 -0800
IronPort-SDR: 99uynEt5jHqcAbRU/AZLAFnaNABKgcDEZBW0H4iDxedrURkee1Et3Uw7BtVHxhnWl/Vauv3WXX
 5e/hpWBUrG9A==
X-IronPort-AV: E=Sophos;i="5.78,401,1599548400"; 
   d="scan'208";a="363469731"
Received: from km-skylake-client-platform.sc.intel.com ([10.3.52.146])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2020 19:55:35 -0800
From:   Kyung Min Park <kyung.min.park@intel.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com, kyung.min.park@intel.com,
        cathy.zhang@intel.com
Subject: [PATCH 2/2] x86: Expose AVX512_FP16 for supported CPUID
Date:   Mon,  7 Dec 2020 19:34:41 -0800
Message-Id: <20201208033441.28207-3-kyung.min.park@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201208033441.28207-1-kyung.min.park@intel.com>
References: <20201208033441.28207-1-kyung.min.park@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Cathy Zhang <cathy.zhang@intel.com>

AVX512_FP16 is supported by Intel processors, like Sapphire Rapids.
It could gain better performance for it's faster compared to FP32
while meets the precision or magnitude requirement. It's availability
is indicated by CPUID.(EAX=7,ECX=0):EDX[bit 23].

Expose it in KVM supported CPUID, then guest could make use of it.

Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
Signed-off-by: Kyung Min Park <kyung.min.park@intel.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index e83bfe2daf82..d7707cfc9401 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -416,7 +416,7 @@ void kvm_set_cpu_caps(void)
 		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
 		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
 		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
-		F(SERIALIZE) | F(TSXLDTRK)
+		F(SERIALIZE) | F(TSXLDTRK) | F(AVX512_FP16)
 	);
 
 	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
-- 
2.17.1

