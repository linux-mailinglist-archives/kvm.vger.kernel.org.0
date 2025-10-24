Return-Path: <kvm+bounces-60971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C253C04830
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 08:35:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B0DD3BA4D9
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 06:35:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AF072749E6;
	Fri, 24 Oct 2025 06:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="By965o7D"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CD425F7A5
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 06:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761287718; cv=none; b=Y9gYII3p6/Q7BZ00GUkB/WqA48Re7x1zisYeiGIY0MpaLcbcDzaXTmw77g7wnNMb0m7nxhzN/ZfTKpvjUKmlt8yKJLb/sV2sh+l6LvJr5MzUXFoz8MWQ0keUYBeRWJj//fk/LhBKwOZmDE+cxazW9woxVPD9UXUGR3G6amil/SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761287718; c=relaxed/simple;
	bh=q1llAB51wlYD8DExeRchjbchwIbqPcgnJ8aGmhooIHs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aqiNIB0+xW/mlv8uAFGGk9vpPA0ZvpBIsPdpOzeUnIm4G4sDRC8S7KSvA/IoLt3dIBbQ3p3t43wqThk1KhiH6XmkocupT0vHCftZ9ssbBcmyWkJ1nexId4zwie8mNY3EdrkbksSiG22zJkcr3MMmuwlCP25frcYJARgLvdUUoi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=By965o7D; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761287717; x=1792823717;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q1llAB51wlYD8DExeRchjbchwIbqPcgnJ8aGmhooIHs=;
  b=By965o7DuvBgMG7lNCDnN96JwA8X67cTSlUpv4cY7C/8UD1ga60SZ9fp
   NmAMUnZF5BYnQWt7PPPvwEl9Srlm9YV3OZCSFg1NRTvmwpEhnXC3GBNt5
   7QMQc889PC2u/ZEBBuFwkixk3BY+5eIHajLUheQbQWGUme6St0abk0OMi
   dqMTTv/l+q+3BnQwRn9AGHqnuPP6c6PkVZZGRSmP1nPrAVjA84GrXC99S
   0P5ekR2dBcKQEk3rTuuWG0bZxTIFzhlBt2TEpBigAUn2AJpm6WICXeKIZ
   N0aLE1QgGIe/dbgm78ce9EC+Mdgevap9DOVL2KSmHFnBwQz30S1pU/ANx
   Q==;
X-CSE-ConnectionGUID: C7KhEXQYTEy472lX9OI3DA==
X-CSE-MsgGUID: BkC3i5VvTYW3nrJrShjVug==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="86095587"
X-IronPort-AV: E=Sophos;i="6.19,251,1754982000"; 
   d="scan'208";a="86095587"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 23:35:17 -0700
X-CSE-ConnectionGUID: zdda8MoeRuaoDINh3c/nxA==
X-CSE-MsgGUID: mKBG2dchQsOb/9ZT/rM9Xg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,251,1754982000"; 
   d="scan'208";a="184276073"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa006.fm.intel.com with ESMTP; 23 Oct 2025 23:35:14 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Chao Gao <chao.gao@intel.com>,
	John Allen <john.allen@amd.com>,
	Babu Moger <babu.moger@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v3 10/20] i386/cpu: Add missing migratable xsave features
Date: Fri, 24 Oct 2025 14:56:22 +0800
Message-Id: <20251024065632.1448606-11-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251024065632.1448606-1-zhao1.liu@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Xtile-cfg & xtile-data are both user xstates. Their xstates are cached
in X86CPUState, and there's a related vmsd "vmstate_amx_xtile", so that
it's safe to mark them as migratable.

Arch lbr xstate is a supervisor xstate, and it is save & load by saving
& loading related arch lbr MSRs, which are cached in X86CPUState, and
there's a related vmsd "vmstate_arch_lbr". So it's also safe to mark it
as migratable (even though KVM hasn't supported it - its migration
support is completed in QEMU).

PT is still unmigratable since KVM disabled it and there's no vmsd and
no other emulation/simulation support.

Tested-by: Farrah Chen <farrah.chen@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 1917376dbea9..b01729ad36d2 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1522,7 +1522,8 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
         .migratable_flags = XSTATE_FP_MASK | XSTATE_SSE_MASK |
             XSTATE_YMM_MASK | XSTATE_BNDREGS_MASK | XSTATE_BNDCSR_MASK |
             XSTATE_OPMASK_MASK | XSTATE_ZMM_Hi256_MASK | XSTATE_Hi16_ZMM_MASK |
-            XSTATE_PKRU_MASK,
+            XSTATE_PKRU_MASK | XSTATE_ARCH_LBR_MASK | XSTATE_XTILE_CFG_MASK |
+            XSTATE_XTILE_DATA_MASK,
     },
     [FEAT_XSAVE_XCR0_HI] = {
         .type = CPUID_FEATURE_WORD,
-- 
2.34.1


