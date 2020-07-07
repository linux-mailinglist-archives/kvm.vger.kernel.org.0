Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDCE2163E5
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 04:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbgGGCWA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 22:22:00 -0400
Received: from mga06.intel.com ([134.134.136.31]:19834 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727102AbgGGCV7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 22:21:59 -0400
IronPort-SDR: 2eEKm4TVWvNgP5GAPwt8Bg+UZHD/+Tdq/bHOoPOUpar99o182OH1oAA630D8WEcD5uV/cjR/hJ
 SopAWnksGBZA==
X-IronPort-AV: E=McAfee;i="6000,8403,9674"; a="209050433"
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="209050433"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 19:21:59 -0700
IronPort-SDR: 4ERrEDINsxnxPLeqOLojP+YMLwK87zHEhl0GpaJTYdIABBbGTyrROU8ewer/kLcaG6jWQEA9Nl
 5Y8H8Gde7ncw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="357633753"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.238.156.127])
  by orsmga001.jf.intel.com with ESMTP; 06 Jul 2020 19:21:54 -0700
From:   Cathy Zhang <cathy.zhang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, ricardo.neri-calderon@linux.intel.com,
        kyung.min.park@intel.com, jpoimboe@redhat.com,
        gregkh@linuxfoundation.org, ak@linux.intel.com,
        dave.hansen@intel.com, tony.luck@intel.com,
        ravi.v.shankar@intel.com, Cathy Zhang <cathy.zhang@intel.com>
Subject: [PATCH v2 3/4] x86: Expose SERIALIZE for supported cpuid
Date:   Tue,  7 Jul 2020 10:16:22 +0800
Message-Id: <1594088183-7187-4-git-send-email-cathy.zhang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1594088183-7187-1-git-send-email-cathy.zhang@intel.com>
References: <1594088183-7187-1-git-send-email-cathy.zhang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SERIALIZE instruction is supported by intel processors,
like Sapphire Rapids. Expose it in KVM supported cpuid.

Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
---
 arch/x86/kvm/cpuid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 8a294f9..e603aeb 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -341,7 +341,8 @@ void kvm_set_cpu_caps(void)
 	kvm_cpu_cap_mask(CPUID_7_EDX,
 		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
 		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
-		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM)
+		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
+		F(SERIALIZE)
 	);
 
 	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
-- 
1.8.3.1

