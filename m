Return-Path: <kvm+bounces-30441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 031C89BACAE
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 07:42:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A410E1F222E1
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 06:42:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8772918DF8F;
	Mon,  4 Nov 2024 06:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YPaOwWbx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5367618D64D
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 06:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730702518; cv=none; b=XXgM98Lm9iPgofqyBGL3noXUhDIk7IzKFULq9FHigTLX1ZStnaujdaxtnmv4ywNscVXjoRc89vCz5m8jI2/QyABwcFU4vBvb8T12odULSUXWttXaS1RnQvtw8++YYoffFkL3j+/90DOfcXfaLELh+nG00rls6aOKLsSwLN/rLwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730702518; c=relaxed/simple;
	bh=Gk/pDh5H1hn8kUf1miRAm6KpEDmFIe71Wx1tlq+NTtw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rR54PBwfxliK4shOchrppRM2tK7AMK2WOXI3xxjpCFZKu24V9ciY0qzpY95Kkt3I4gb7ZnSWHAT7Ymk6yqiYgrBXRHHl278/j5GB160d/YFulthh7c11VBoIVK8Z8PwcF42JvSEPYBvN09zXVLycl1zA3+pTZGeKL2vGKIjY/8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YPaOwWbx; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730702518; x=1762238518;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Gk/pDh5H1hn8kUf1miRAm6KpEDmFIe71Wx1tlq+NTtw=;
  b=YPaOwWbxCUt+RkQghmXT26a8OxcaIAjv25JCoKi5vhurn4jCyQA4tGTx
   n6qTlRlOIryXMdeS+PHTZj+SNRyqtYcBS+VQ0uShLegKw4js6f1h6Aivi
   dUxMXnF3vBfztpuksfH3lqBLGcugXOnY43NXGR0UDOqQTwkcE7FUq/CI+
   m6SdGgILqrhdxpgFmJ1Bkz94yiV8j1lK/1ulGWFQ6nOeIifEpMvDxDMkS
   gRe4N5O8ws70O2ORzmGP9TKgIB1sktFb7ruCHuecYXYNBnmIUAcZa5+cV
   4N6hKCyG9AwcLkjF+88+K0ay31XG7holIKguFkc+9zwbQkUV7yRYxgqVW
   A==;
X-CSE-ConnectionGUID: b+dHdAm1QvykoAhhY+ugRQ==
X-CSE-MsgGUID: hf6bgEE6QhGTLFAzNNFL1A==
X-IronPort-AV: E=McAfee;i="6700,10204,11245"; a="41776703"
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="41776703"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2024 22:41:58 -0800
X-CSE-ConnectionGUID: Gqn+6iRgSimo9hgHqTNwwQ==
X-CSE-MsgGUID: vBa3VDV7SiibdDMABX3R+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="83902894"
Received: from st-server.bj.intel.com ([10.240.193.102])
  by fmviesa010.fm.intel.com with ESMTP; 03 Nov 2024 22:41:54 -0800
From: Tao Su <tao1.su@linux.intel.com>
To: kvm@vger.kernel.org,
	x86@kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	chao.gao@intel.com,
	xiaoyao.li@intel.com,
	jiaan.lu@intel.com,
	xuelian.guo@intel.com,
	tao1.su@linux.intel.com
Subject: [PATCH 1/4] x86: KVM: Advertise SHA512 CPUID to userspace
Date: Mon,  4 Nov 2024 14:35:56 +0800
Message-Id: <20241104063559.727228-2-tao1.su@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241104063559.727228-1-tao1.su@linux.intel.com>
References: <20241104063559.727228-1-tao1.su@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SHA512 is a new set of instructions in the latest Intel platform
Clearwater Forest, which contains VSHA512MSG1, VSHA512MSG2, VSHA512RNDS2.

SHA512 is enumerated via CPUID.(EAX=7,ECX=1):EAX[bit 0].

SHA512 is on an expected-dense CPUID leaf and some other bits on this leaf
have kernel usages. Considering SHA512 itself has not truly kernel usages,
hide this one in /proc/cpuinfo.

These instructions only operate in xmm, ymm registers and have no new VMX
controls, so there is no additional host enabling required for guests to
use these instructions, i.e. advertising SHA512 CPUID to userspace is
safe.

Tested-by: Jiaan Lu <jiaan.lu@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
Signed-off-by: Tao Su <tao1.su@linux.intel.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kvm/cpuid.c               | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 913fd3a7bac6..896794528b81 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -317,6 +317,7 @@
 #define X86_FEATURE_ZEN1		(11*32+31) /* CPU based on Zen1 microarchitecture */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
+#define X86_FEATURE_SHA512		(12*32+ 0) /* SHA512 instructions */
 #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* "avx_vnni" AVX VNNI instructions */
 #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* "avx512_bf16" AVX512 BFLOAT16 instructions */
 #define X86_FEATURE_CMPCCXADD           (12*32+ 7) /* CMPccXADD instructions */
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 41786b834b16..5c7772567a4e 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -698,7 +698,7 @@ void kvm_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
 
 	kvm_cpu_cap_mask(CPUID_7_1_EAX,
-		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) |
+		F(SHA512) | F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) |
 		F(FZRM) | F(FSRS) | F(FSRC) |
 		F(AMX_FP16) | F(AVX_IFMA) | F(LAM)
 	);
-- 
2.34.1


