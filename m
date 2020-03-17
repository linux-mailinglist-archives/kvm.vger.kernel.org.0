Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5B591879F1
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 07:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbgCQGzG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 02:55:06 -0400
Received: from mga14.intel.com ([192.55.52.115]:25817 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726207AbgCQGzF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 02:55:05 -0400
IronPort-SDR: 9URtp7CndDTfHErMEtxwd6mIexQMGiaZub9bvI7xpo62rRn3SrBAeLdJgXZaJvkNmOSFlIMzlV
 r8RsRuZ7xuyg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 23:55:05 -0700
IronPort-SDR: Ks2lyFR4oQi+/qPyHNM8E+gog2qCtpLm5wZsCX9HHOT8ta1lsCwXUxodY71dHg89zhK5itHWIN
 FBE4ui/9eucg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,563,1574150400"; 
   d="scan'208";a="233412448"
Received: from debian-skl.sh.intel.com ([10.239.160.44])
  by orsmga007.jf.intel.com with ESMTP; 16 Mar 2020 23:55:03 -0700
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Zhong, Yang" <yang.zhong@intel.com>
Subject: [PATCH] KVM: x86: Expose AVX512 VP2INTERSECT in cpuid for TGL
Date:   Tue, 17 Mar 2020 14:55:53 +0800
Message-Id: <20200317065553.64790-1-zhenyuw@linux.intel.com>
X-Mailer: git-send-email 2.25.0.rc2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tigerlake new AVX512 VP2INTERSECT feature is available.
This would expose it for KVM supported cpuid.

Cc: "Zhong, Yang" <yang.zhong@intel.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b1c469446b07..b4e25ff6ab0a 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -374,7 +374,7 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
 	const u32 kvm_cpuid_7_0_edx_x86_features =
 		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
 		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
-		F(MD_CLEAR);
+		F(MD_CLEAR) | F(AVX512_VP2INTERSECT);
 
 	/* cpuid 7.1.eax */
 	const u32 kvm_cpuid_7_1_eax_x86_features =
-- 
2.25.0.rc2

