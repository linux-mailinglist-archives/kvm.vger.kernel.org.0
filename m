Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F62718946F
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 04:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgCRD1k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 23:27:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:51491 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726250AbgCRD1k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 23:27:40 -0400
IronPort-SDR: j1bzBZWkTKzwFBQy3dC/qEO+S9pmlaYt7zaNQGp3nSwgTOifOWVUCKyd+BNtxS/GBVz3snA7B7
 JFA90OyCwz0g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2020 20:27:41 -0700
IronPort-SDR: IBUl3rotRx+sX8oYFfTYc6Pg4ZsoSrCZiAk3u71icpdrD859zYVd9jLt9ldVJEYS1UyTIyt/yn
 OSomqr/U0eJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,566,1574150400"; 
   d="scan'208";a="291188370"
Received: from kaiwang3-mobl2.ccr.corp.intel.com (HELO dell-xps.ccr.corp.intel.com) ([10.249.174.200])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Mar 2020 20:27:38 -0700
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Zhong, Yang" <yang.zhong@intel.com>
Subject: [PATCH rebase] KVM: x86: Expose AVX512 VP2INTERSECT in cpuid for TGL
Date:   Wed, 18 Mar 2020 11:27:39 +0800
Message-Id: <20200318032739.3745-1-zhenyuw@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <dcc9899c-f5af-9a4f-3ac2-f37fd8b930f7@redhat.com>
References: <dcc9899c-f5af-9a4f-3ac2-f37fd8b930f7@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tigerlake new AVX512 VP2INTERSECT feature is available.
This trys to expose it for KVM supported cpuid.

Cc: "Zhong, Yang" <yang.zhong@intel.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 08280d8a2ac9..435a7da07d5f 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -338,7 +338,7 @@ void kvm_set_cpu_caps(void)
 	kvm_cpu_cap_mask(CPUID_7_EDX,
 		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
 		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
-		F(MD_CLEAR)
+		F(MD_CLEAR) | F(AVX512_VP2INTERSECT)
 	);
 
 	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
-- 
2.25.1

