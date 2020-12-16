Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E810B2DB978
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 03:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725780AbgLPC4G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 21:56:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:29831 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725710AbgLPC4F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 21:56:05 -0500
IronPort-SDR: +Pz0CGGXVOIVx1aJ+co9iQGTc0iey7hGlXq2A2U9N7gXCSQpe32Zf/mfm/QJ47XaTBsrzeiaDb
 Sl9pos3io84w==
X-IronPort-AV: E=McAfee;i="6000,8403,9836"; a="175135304"
X-IronPort-AV: E=Sophos;i="5.78,423,1599548400"; 
   d="scan'208";a="175135304"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2020 18:55:48 -0800
IronPort-SDR: 1rQpOIgf5gRmVEWY1QU262a/Z7RX/jkCuKvmRyqgdHHfSfggL83ZnOrb02TqxeI2zqOPhz2eB+
 UDt9jbasmV7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,423,1599548400"; 
   d="scan'208";a="451538766"
Received: from icx-2s.bj.intel.com ([10.240.192.119])
  by fmsmga001.fm.intel.com with ESMTP; 15 Dec 2020 18:55:45 -0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        tony.luck@intel.com, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, kyung.min.park@intel.com, yang.zhong@intel.com
Subject: [PATCH 0/2] Enumerate and expose AVX_VNNI feature
Date:   Wed, 16 Dec 2020 10:01:27 +0800
Message-Id: <20201216020129.19875-1-yang.zhong@intel.com>
X-Mailer: git-send-email 2.29.2.334.gfaefdd61ec
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A processor supports AVX_VNNI instructions if CPUID.(EAX=7,ECX=1):EAX[bit 4]
is present.

This series includes kernel and kvm patches, kernel patch define this
new cpu feature bit and kvm expose this bit to guest. When this bit is
enabled on cpu or vcpu, the cpu feature flag is shown as "avx_vnni" in
/proc/cpuinfo of host and guest.

Detailed information on the instruction and CPUID feature flag can be
found in the latest "extensions" manual [1].

Reference:
[1]. https://software.intel.com/content/www/us/en/develop/download/intel-architecture-instruction-set-extensions-programming-reference.html


Kyung Min Park (1):
  Enumerate AVX Vector Neural Network instructions

Yang Zhong (1):
  KVM: Expose AVX_VNNI instruction to guset

 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kvm/cpuid.c               | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

-- 
2.29.2.334.gfaefdd61ec

