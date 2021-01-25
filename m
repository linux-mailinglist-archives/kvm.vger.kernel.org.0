Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4603E303411
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 06:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729487AbhAZFNd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 00:13:33 -0500
Received: from mga14.intel.com ([192.55.52.115]:22891 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726404AbhAYJVt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 04:21:49 -0500
IronPort-SDR: XG+eqluQ8F43AjNtNvXDj3Stw4QMf4ejjvh1PmbQA/hThYeL5COk5yGkKHrhlW3jW8mvNb9soP
 vibmfwMAwXLg==
X-IronPort-AV: E=McAfee;i="6000,8403,9874"; a="178915827"
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="178915827"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 01:07:25 -0800
IronPort-SDR: 8IAAKiQ1IlzmMdVyBA/wUeStiLzhFO5EVeMyWOk7aEcjh2bFIeSWMnVhVvbi1DBjHOJpb5j4FF
 UFSxHLb5zBvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="402223960"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga004.fm.intel.com with ESMTP; 25 Jan 2021 01:07:23 -0800
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Cc:     chang.seok.bae@intel.com, kvm@vger.kernel.org, robert.hu@intel.com,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [RFC PATCH 11/12] kvm/vmx/nested: Support CR4.KL in nested
Date:   Mon, 25 Jan 2021 17:06:19 +0800
Message-Id: <1611565580-47718-12-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611565580-47718-1-git-send-email-robert.hu@linux.intel.com>
References: <1611565580-47718-1-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add CR4.KL in nested.msr.cr4_fixed1 when guest CPUID supports KeyLocker. So
that it can pass check when preparing vmcs02.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cf8ab95..f66887d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7374,6 +7374,7 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
 	cr4_fixed1_update(X86_CR4_PKE,        ecx, feature_bit(PKU));
 	cr4_fixed1_update(X86_CR4_UMIP,       ecx, feature_bit(UMIP));
 	cr4_fixed1_update(X86_CR4_LA57,       ecx, feature_bit(LA57));
+	cr4_fixed1_update(X86_CR4_KEYLOCKER,       ecx, feature_bit(KEYLOCKER));
 
 #undef cr4_fixed1_update
 }
-- 
1.8.3.1

