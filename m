Return-Path: <kvm+bounces-39999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C964A4D766
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 10:07:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF052171FA0
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 09:06:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 327C4203712;
	Tue,  4 Mar 2025 09:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PysToXcS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75981FCCF7
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 09:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741078857; cv=none; b=Dl6vu9GMSn4fn33wB3HaIXBpt2DaKct+vWASuoV+8WNWx+5/mSj05BiaKPWKgRtmXoHHZsF0abvVxZIRIJkg4u6lh9lE0nyU6PV2Y295Xyez6AFQfwEjDsf9oBlgZ5tAti5euTTvjHfDC7I2xNE2jBsY9QQPbR3lTKrEs4rV9v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741078857; c=relaxed/simple;
	bh=vWrPEir3bzFlK5oiXQXK/zk+1pANQ7B4tAkQ8xb5AQE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YAMrMD+F/iLi7sfu9vJgl3OIXEB67/O0BkxP7OJIbvgRYmyb69wIUZIeS/G+YKLo+VA7D4+//rD5lIJU0VnHmNf2zlvswDSY5pBGy7EJ+HVv0f0fr3LgC/d7iIpm2qQKwT922xZcLEbJivcfEtOt6uaOro3a5zZotiS1KX8G970=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PysToXcS; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741078856; x=1772614856;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vWrPEir3bzFlK5oiXQXK/zk+1pANQ7B4tAkQ8xb5AQE=;
  b=PysToXcSdDpqp34sNJAjNb0JqS4jd0o90wZFGaM7gf/0tNAJ6ybHKXwU
   3uL1nzvvYeZnJhDW+qIwFbLJ+O36l+sCEIgXQgHmLVQlJjRHGIKLreRdq
   Mlpp9yDnhOCnyamte2T/ICxAPDcviwdZ6avTSCZ0+rZeXkigYuYbaUDxl
   xNb9iYulmxMovgZXXHgKggtkpbG6kl0FswIb7RX2fQ81AKLFR7fGsDeMP
   BjCDXvV8H2/KtC43tpK9RvrhAES/fkftfPN3p2fRh/xSIafg8k0IDhECv
   YaKLf5oBT4fWKC5eZysTYiKjgSZMBNH7kWWpSL0MDAwrPC/NnGRb2sqbf
   Q==;
X-CSE-ConnectionGUID: 1BgAK7GdQTmxGaXQ+8mayg==
X-CSE-MsgGUID: OiQgshzbQ5Km/VJjciUogQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="52631339"
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="52631339"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 01:00:55 -0800
X-CSE-ConnectionGUID: 7k+UiGlETw+SV8RoxTiVAg==
X-CSE-MsgGUID: w67zPHe+QvuZAtrHUU8HQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="118999231"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Mar 2025 01:00:54 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH 2/2] KVM: x86: Explicitly set eax and ebx to 0 when X86_FEATURE_PERFMON_V2 cannot be exposed to guest
Date: Tue,  4 Mar 2025 03:23:14 -0500
Message-Id: <20250304082314.472202-3-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250304082314.472202-1-xiaoyao.li@intel.com>
References: <20250304082314.472202-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It wrongly exposes the host ebx value of leaf 0x80000022 to userspace
when it's supposed to return 0.

Fixes: 94cdeebd8211 ("KVM: x86/cpuid: Add AMD CPUID ExtPerfMonAndDbg leaf 0x80000022")
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index f9a9175e3fe8..5e4d4934c0d3 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1767,7 +1767,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 
 		entry->ecx = entry->edx = 0;
 		if (!enable_pmu || !kvm_cpu_cap_has(X86_FEATURE_PERFMON_V2)) {
-			entry->eax = entry->ebx;
+			entry->eax = entry->ebx = 0;
 			break;
 		}
 
-- 
2.34.1


