Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3BE72EA2F2
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 02:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbhAEBmk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jan 2021 20:42:40 -0500
Received: from mga03.intel.com ([134.134.136.65]:49886 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbhAEBmk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jan 2021 20:42:40 -0500
IronPort-SDR: BYYD49Ly8qt4XAtI8VpiGiqbFk+VV1Y2tJ8MNyOUqCwTlCwPafkxITdaIr5tXbHWaQYYHfjLdU
 hiab11EL4MeQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9854"; a="177136723"
X-IronPort-AV: E=Sophos;i="5.78,475,1599548400"; 
   d="scan'208";a="177136723"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2021 17:41:59 -0800
IronPort-SDR: cg/gx9202VTgH7fROrtiORB2QgDHwNlGyq3W6jb5D8KbBGYsMkSrptBnZ8pZVFrPybciWbFgdd
 qIpJJQY+VWxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,475,1599548400"; 
   d="scan'208";a="350166544"
Received: from icx-2s.bj.intel.com ([10.240.192.119])
  by fmsmga008.fm.intel.com with ESMTP; 04 Jan 2021 17:41:55 -0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        tony.luck@intel.com, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, kyung.min.park@intel.com, yang.zhong@intel.com
Subject: [PATCH 0/2] Enumerate and expose AVX_VNNI feature
Date:   Tue,  5 Jan 2021 08:49:07 +0800
Message-Id: <20210105004909.42000-1-yang.zhong@intel.com>
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

