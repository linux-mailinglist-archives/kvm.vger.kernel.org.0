Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7951238B2
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 22:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbfLQVcq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 16:32:46 -0500
Received: from mga04.intel.com ([192.55.52.120]:17437 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728059AbfLQVcp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 16:32:45 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 13:32:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,326,1571727600"; 
   d="scan'208";a="227639452"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 17 Dec 2019 13:32:42 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/5] KVM: x86: Add CPUID_7_1_EAX to the reverse CPUID table
Date:   Tue, 17 Dec 2019 13:32:40 -0800
Message-Id: <20191217213242.11712-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217213242.11712-1-sean.j.christopherson@intel.com>
References: <20191217213242.11712-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an entry for CPUID_7_1_EAX in the reserve_cpuid array in preparation
for incorporating the array in bit() build-time assertions, specifically
to avoid an assertion on F(AVX512_BF16) in do_cpuid_7_mask().

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index a631329ebec7..8c77d829e27d 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -53,6 +53,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_7_ECX]         = {         7, 0, CPUID_ECX},
 	[CPUID_8000_0007_EBX] = {0x80000007, 0, CPUID_EBX},
 	[CPUID_7_EDX]         = {         7, 0, CPUID_EDX},
+	[CPUID_7_1_EAX]       = {         7, 1, CPUID_EAX},
 };
 
 static inline u32 bit(int bitno)
-- 
2.24.1

