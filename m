Return-Path: <kvm+bounces-30444-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 002039BACB1
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 07:42:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ADDE2281DBA
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 06:42:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6F0E18E356;
	Mon,  4 Nov 2024 06:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U9BUI9jA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6C218E37D
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 06:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730702527; cv=none; b=XGT+cV8D3vF88cF6c7RAUi1INmVybJCkdOAxK4F5mVemD0bt0NdTrmAtubon1KZt76kfqjq+lCdSsPspavoT+1O8xLEnGfn/2bAiQpKui2p0JQp02z035d3txMyec518909IgjU+Zdzlxxl1YStOIjK9UA53gUcRfiEMRLoPF4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730702527; c=relaxed/simple;
	bh=HOhkr10ZUZJktGpRpMQEC7/B/7eeHIcKqB5zN8GXdzg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cZEfuKrPWsYSKcvCoyYIl21gUyjQqRpC/mvEz3rFabLT/O4dJ8L+Xfil7pPX4gQjDUxReZNzsuJmi6ajPKHDQT01zuD1ysjTgQRfUe5YZP0M+bbmVyYkWHA5odOaxAvticKWg9jhTFauKyfkL+ltVbfaWdwkgkBjr+N1Irv7jgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U9BUI9jA; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730702526; x=1762238526;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HOhkr10ZUZJktGpRpMQEC7/B/7eeHIcKqB5zN8GXdzg=;
  b=U9BUI9jAoyuhCmoUsnWxGOrqS+LSmgWN+7s+ADbcToGH0OBW8epv/C45
   DSfRQOylJpfFKuyzmD8ZCBlrqsBvKdEseiKiBVnZkiOx44kMxfzV6r5vF
   DnibIUzrTFz5ZmqKnJTjhDR27Efc67bg+4ILyrhYGT1ISJ6+unCyu8zfE
   xMu9A+Mchm/FOXzjFqtgLxoPqsgdbsHeYkSibRIy7HqYYtDXxzXyDYDv2
   rPsLZwzU69GRUxiXsTav4ODNTqKjRb9TlW9z6cnwdoArOP6i1G0Hhfkeh
   v46r5cn4IybWx11NfTua9e6VWFARSMs+vIp/XfCieJcqs2QPd03S73dUF
   A==;
X-CSE-ConnectionGUID: NrlTckViSr6NOpjMzygnTA==
X-CSE-MsgGUID: vg/RVEJ2RSaYgK+0OeCmXQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11245"; a="41776722"
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="41776722"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2024 22:42:06 -0800
X-CSE-ConnectionGUID: fZeyjTaDTleLkx46guoDyw==
X-CSE-MsgGUID: Xg82jgJRQMO1SvIV8D9Pag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="83902929"
Received: from st-server.bj.intel.com ([10.240.193.102])
  by fmviesa010.fm.intel.com with ESMTP; 03 Nov 2024 22:42:03 -0800
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
Subject: [PATCH 4/4] KVM: x86: Advertise AVX-VNNI-INT16 CPUID to userspace
Date: Mon,  4 Nov 2024 14:35:59 +0800
Message-Id: <20241104063559.727228-5-tao1.su@linux.intel.com>
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

AVX-VNNI-INT16 is a new set of instructions in the latest Intel platform
Clearwater Forest, which can multiply and add unsigned and signed words
with and without saturation.

AVX-VNNI-INT16 is enumerated via CPUID.(EAX=7,ECX=1):EDX[bit 10].

Advertise AVX-VNNI-INT16 if it's supported in hardware. There are no new
VMX controls for the feature, i.e. the instructions can't be intercepted
and only use xmm, ymm registers.

Tested-by: Jiaan Lu <jiaan.lu@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
Signed-off-by: Tao Su <tao1.su@linux.intel.com>
---
 arch/x86/kvm/cpuid.c         | 4 ++--
 arch/x86/kvm/reverse_cpuid.h | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 160b060121b2..68cde739a5a3 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -704,8 +704,8 @@ void kvm_set_cpu_caps(void)
 	);
 
 	kvm_cpu_cap_init_kvm_defined(CPUID_7_1_EDX,
-		F(AVX_VNNI_INT8) | F(AVX_NE_CONVERT) | F(PREFETCHITI) |
-		F(AMX_COMPLEX) | F(AVX10)
+		F(AVX_VNNI_INT8) | F(AVX_NE_CONVERT) | F(AMX_COMPLEX) |
+		F(AVX_VNNI_INT16) | F(PREFETCHITI) | F(AVX10)
 	);
 
 	kvm_cpu_cap_init_kvm_defined(CPUID_7_2_EDX,
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index 0d17d6b70639..e46220ece83c 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -46,6 +46,7 @@ enum kvm_only_cpuid_leafs {
 #define X86_FEATURE_AVX_VNNI_INT8       KVM_X86_FEATURE(CPUID_7_1_EDX, 4)
 #define X86_FEATURE_AVX_NE_CONVERT      KVM_X86_FEATURE(CPUID_7_1_EDX, 5)
 #define X86_FEATURE_AMX_COMPLEX         KVM_X86_FEATURE(CPUID_7_1_EDX, 8)
+#define X86_FEATURE_AVX_VNNI_INT16      KVM_X86_FEATURE(CPUID_7_1_EDX, 10)
 #define X86_FEATURE_PREFETCHITI         KVM_X86_FEATURE(CPUID_7_1_EDX, 14)
 #define X86_FEATURE_AVX10               KVM_X86_FEATURE(CPUID_7_1_EDX, 19)
 
-- 
2.34.1


