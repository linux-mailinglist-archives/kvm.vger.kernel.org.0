Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1CB32D219F
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 04:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbgLHD4P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 22:56:15 -0500
Received: from mga14.intel.com ([192.55.52.115]:59706 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726556AbgLHD4P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 22:56:15 -0500
IronPort-SDR: S78jpoF0QNdalHYH0mrKvDC521k/uhLx+oCgLXdAYuJ6pImjLdmXvVV060jTM5JRR1RWo2Wlws
 nbUny04lgLeg==
X-IronPort-AV: E=McAfee;i="6000,8403,9828"; a="173060178"
X-IronPort-AV: E=Sophos;i="5.78,401,1599548400"; 
   d="scan'208";a="173060178"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2020 19:55:34 -0800
IronPort-SDR: 5VaoYfYOjT0IMeSQT265ZQRj5OkGBhDd2r6N47s5OhVUEHIPti3esmiz3cT4ndAAmFnFIN8xC+
 KIFlg74j+JXA==
X-IronPort-AV: E=Sophos;i="5.78,401,1599548400"; 
   d="scan'208";a="363469714"
Received: from km-skylake-client-platform.sc.intel.com ([10.3.52.146])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2020 19:55:34 -0800
From:   Kyung Min Park <kyung.min.park@intel.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com, kyung.min.park@intel.com,
        cathy.zhang@intel.com
Subject: [PATCH 0/2] Enumerate and expose AVX512_FP16 feature 
Date:   Mon,  7 Dec 2020 19:34:39 -0800
Message-Id: <20201208033441.28207-1-kyung.min.park@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce AVX512_FP16 feature and expose it to KVM CPUID for processors
that support it. KVM reports this information and guests can make use
of it.

Detailed information on the instruction and CPUID feature flag can be found
in the latest "extensions" manual [1].

Reference:
[1]. https://software.intel.com/content/www/us/en/develop/download/intel-architecture-instruction-set-extensions-programming-reference.html

Cathy Zhang (1):
  x86: Expose AVX512_FP16 for supported CPUID

Kyung Min Park (1):
  Enumerate AVX512 FP16 CPUID feature flag

 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kernel/cpu/cpuid-deps.c   | 1 +
 arch/x86/kvm/cpuid.c               | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

-- 
2.17.1

