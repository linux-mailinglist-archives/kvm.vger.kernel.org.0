Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB83131220E
	for <lists+kvm@lfdr.de>; Sun,  7 Feb 2021 07:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbhBGG4d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Feb 2021 01:56:33 -0500
Received: from mga07.intel.com ([134.134.136.100]:48431 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229611AbhBGG4d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Feb 2021 01:56:33 -0500
IronPort-SDR: 3GTvJJnbRjzp4nUoXOTww258BFH+aZoQgA97PqCiZajHDHzReqZsijm9zl/ObGlEV1NouFVKCj
 ql7diPm3UH5g==
X-IronPort-AV: E=McAfee;i="6000,8403,9887"; a="245660843"
X-IronPort-AV: E=Sophos;i="5.81,159,1610438400"; 
   d="scan'208";a="245660843"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2021 22:54:45 -0800
IronPort-SDR: bZjtW2cyg+iTRXU9kcYbw194kx7IhBTOrbnlSPqgzGgDPId9vZLjXGEEmx4zyOK1aMt90Mn+TD
 qYpI1/P4LIOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,159,1610438400"; 
   d="scan'208";a="410376574"
Received: from vmmteam.bj.intel.com ([10.240.193.86])
  by fmsmga004.fm.intel.com with ESMTP; 06 Feb 2021 22:54:43 -0800
From:   Jing Liu <jing2.liu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jing2.liu@intel.com
Subject: [PATCH RFC 1/7] kvm: x86: Expose XFD CPUID to guest
Date:   Sun,  7 Feb 2021 10:42:50 -0500
Message-Id: <20210207154256.52850-2-jing2.liu@linux.intel.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20210207154256.52850-1-jing2.liu@linux.intel.com>
References: <20210207154256.52850-1-jing2.liu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel's Extended Feature Disable (XFD) feature is an extension
to the XSAVE feature that allows an operating system to enable
a feature while preventing specific user threads from using
the feature. A processor that supports XFD enumerates
CPUID.(EAX=0DH,ECX=1):EAX[4] as 1.

Signed-off-by: Jing Liu <jing2.liu@linux.intel.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 83637a2ff605..04a73c395c71 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -437,7 +437,7 @@ void kvm_set_cpu_caps(void)
 	);
 
 	kvm_cpu_cap_mask(CPUID_D_1_EAX,
-		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | F(XSAVES)
+		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | F(XSAVES) | F(XFD)
 	);
 
 	kvm_cpu_cap_mask(CPUID_8000_0001_ECX,
-- 
2.18.4

