Return-Path: <kvm+bounces-63766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 25847C7234F
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 05:46:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id D77C92B56D
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 04:46:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 054EF3B7A8;
	Thu, 20 Nov 2025 04:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aSoFuAh6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905F62F363C;
	Thu, 20 Nov 2025 04:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763613953; cv=none; b=q3ggcE0yj/HfoQ6kbjRD1QhFRQCKBK+3oZX/BW/16FfT2n8g10QOiMrf1fcVUyWoIBUrbIXdqt2d95ySR1dtcwXXEurekYaSJQJOYROxH4n2O8xI+V/gvSgXY2SlAOopyH3n1TSZ22B1WUn2iB49wNxBjjf+CJzybbfvfqUfPnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763613953; c=relaxed/simple;
	bh=555QTSK7w+3CLaOO6HAWjxV5YyhQ0CQoosMNcAbys4E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AEe0ytJtyXQiuLL9F1jcfXJ9p9xFqoeCzvE8dWkOruYhrXWpJViHmtdocCNLZZ8t44j+R4uzglFHrMQR2oCrfS7h/CK4G7jXTep2U1s4PtGPdSiuY7STlmD4CildveMgt3B/BIecvypOZwT9buaDUAdNy7A6GxYiLJIMAyocCMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aSoFuAh6; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763613951; x=1795149951;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=555QTSK7w+3CLaOO6HAWjxV5YyhQ0CQoosMNcAbys4E=;
  b=aSoFuAh6ch7rwRkbRpCyypUtg+uS9ki7pWHKHQ9cm7TJu3RseuRWf1LV
   FCm2d0HF7cCX2nIbgDWAdAhf/BfWlIHcXJsDPcFnb0dYeEMOb6u6mxpBa
   h2dLGSppJ98LahuKZzKZQoC3aVrT35bNmPIppaKlOX9EHIho4Ul7OAMHZ
   28gQFaxFQrI7CzDlPfOln+xmBUlF7dfhwUbBGAyElCs74YUEnn3xho+Q2
   bpi+Y9x4ND47qYeNQ4Bhhb2hqCF8QFw+4uiaHL4SmSkLhZsBraeRwHf8i
   aQJ59/2HkQWleihPiX4XLXNYmgz73oLehKilrmkavKETgUxm60B9boraz
   A==;
X-CSE-ConnectionGUID: y7AgV4cmRXGlzwtn2IJNNw==
X-CSE-MsgGUID: kBgLNX6nTsukKbRtBpu9YQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="65602256"
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="65602256"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 20:45:51 -0800
X-CSE-ConnectionGUID: 2K9aI5wxS3y0G+ewT4EeQQ==
X-CSE-MsgGUID: J1Xj0L4cRiGewMGuKRLrgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="196380883"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa005.jf.intel.com with ESMTP; 19 Nov 2025 20:45:48 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Chao Gao <chao.gao@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Xudong Hao <xudong.hao@intel.com>
Subject: [PATCH 1/4] KVM: x86: Advertise MOVRS CPUID to userspace
Date: Thu, 20 Nov 2025 13:07:17 +0800
Message-Id: <20251120050720.931449-2-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251120050720.931449-1-zhao1.liu@intel.com>
References: <20251120050720.931449-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Define and pass MOVRS CPUID through to userspace.

MOVRS is a new set of instructions introduced in the Intel platform
Diamond Rapids, to provide load instructions that carry a read-shared
hint.

Functionally, MOVRS family is equivalent to existing load instructions,
but its read-shared hint indicates that the source memory location is
likely to become read-shared by multiple processors, i.e., read in the
future by at least one other processor before it is written (assuming it
is ever written in the future). This hint could optimize the behavior of
the caches, especially shared caches, for this data for future reads by
multiple processors. Additionally, MOVRS family also includes a software
prefetch instruction, PREFETCHRST2, that carries the same read-shared
hint. [*]

MOVRS family is enumerated by CPUID single-bit (0x7.0x1.EAX[bit 31]).
Since it's on a densely-populated CPUID leaf and some other bits on
this leaf have kernel usages, define this new feature in cpufeatures.h,
but hide it in /proc/cpuinfo due to lack of current kernel usage.

Advertise MOVRS bit to userspace directly. It's safe, since there's no
new VMX controls or additional host enabling required for guests to use
this feature.

[*]: Intel Architecture Instruction Set Extensions and Future Features
     (rev.059).

Tested-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Reference link: https://cdrdv2.intel.com/v1/dl/getContent/865891
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kvm/cpuid.c               | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 4091a776e37a..2d57bfe9c4c4 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -325,6 +325,7 @@
 #define X86_FEATURE_AMX_FP16		(12*32+21) /* AMX fp16 Support */
 #define X86_FEATURE_AVX_IFMA            (12*32+23) /* Support for VPMADD52[H,L]UQ */
 #define X86_FEATURE_LAM			(12*32+26) /* "lam" Linear Address Masking */
+#define X86_FEATURE_MOVRS		(12*32+31) /* MOVRS instructions */
 
 /* AMD-defined CPU features, CPUID level 0x80000008 (EBX), word 13 */
 #define X86_FEATURE_CLZERO		(13*32+ 0) /* "clzero" CLZERO instruction */
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 52524e0ca97f..372d82bae272 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1018,6 +1018,7 @@ void kvm_set_cpu_caps(void)
 		F(AMX_FP16),
 		F(AVX_IFMA),
 		F(LAM),
+		F(MOVRS),
 	);
 
 	kvm_cpu_cap_init(CPUID_7_1_ECX,
-- 
2.34.1


