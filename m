Return-Path: <kvm+bounces-52688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CAD0B082F5
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 04:28:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B647B1C21FEE
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 02:28:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 072A81E2602;
	Thu, 17 Jul 2025 02:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l7HLr0i5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADF41D554;
	Thu, 17 Jul 2025 02:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752719308; cv=none; b=A3utkc7sEGmZAPtEInepA1x0vRI6R8SfYxuwM075wtAjLn3/3cduZHWMD9J+0wfKdJv7aE6011mDZ4iyITOgpkRc9szuDIUxTQpSVNG1rYdxAJMhX/NIzq6QGbqoMPRseKTEkIPT05SrnIiTo6yVwMiVg++KNUcbbSsZfFjXBek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752719308; c=relaxed/simple;
	bh=QmKLOSFTSlrWXW/WOeYAVPCkH8pqWGIbLlym822KpLY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HiHqEMnD2I5P2K9DM6U3g47GIiDspsEl0a5qn+JvcrqHx3Wt7qE7qcJ9nhGxWiA8bfeZr6zzlfMBZQxVgN3t2RAG2Rz2j4yWLo5V1G1PWxY2upgLxzzNpY4dsRqHXq0zWTFLhVtv3lOM34J4wzSZxrges4quUl20sX8mSfBRLfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l7HLr0i5; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752719307; x=1784255307;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QmKLOSFTSlrWXW/WOeYAVPCkH8pqWGIbLlym822KpLY=;
  b=l7HLr0i5d2wIWPu71NFZkkjceJV99AvUk+SUKRfqvB277XXMdNx8bdAs
   3NiMIS0PFc6la9NqVCoHV3XrS3mlCTWx4Yh5MVjBfPdFVCE0M6UbnbWDk
   Ki0AT0ddOsVyHNo4Xed42Dk6AoZ6cwPyi6YeuoqpynNpS1aau4mv4tD/Y
   5hQNSi9xW0zVAIw6dipa4M5rz3+lRAKzFgBoV2q4Cba6mflgCVbO9OmDs
   f/gHXJRmqWKGNvhkM5vkj8ZlVCJsOKDby0rwhp/R1hO+yTB5MK+BTmrVD
   Js5CIdvumyngTDXk7nWDG3icpnMSz6Vk7MrVLyyViJkIsr4B1mG/As+CK
   g==;
X-CSE-ConnectionGUID: YWdnB0dTTUCael+WjVTOTA==
X-CSE-MsgGUID: T8qfeMWeT/CX5Lk85HzWLg==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="54699012"
X-IronPort-AV: E=Sophos;i="6.16,317,1744095600"; 
   d="scan'208";a="54699012"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2025 19:28:26 -0700
X-CSE-ConnectionGUID: r6cCmxgETseP35BWBWXPAw==
X-CSE-MsgGUID: IRJqHKMtRkScnTW/9Dx10A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,317,1744095600"; 
   d="scan'208";a="194794882"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa001.jf.intel.com with ESMTP; 16 Jul 2025 19:28:24 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xiaoyao.li@intel.com
Subject: [PATCH] KVM: TDX: Don't report base TDVMCALLs
Date: Thu, 17 Jul 2025 10:20:09 +0800
Message-ID: <20250717022010.677645-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove TDVMCALLINFO_GET_QUOTE from user_tdvmcallinfo_1_r11 reported to
userspace to align with the direction of the GHCI spec.

Recently, concern was raised about a gap in the GHCI spec that left
ambiguity in how to expose to the guest that only a subset of GHCI
TDVMCalls were supported. During the back and forth on the spec details[0],
<GetQuote> was moved from an individually enumerable TDVMCall, to one that
is part of the 'base spec', meaning it doesn't have a specific bit in the
<GetTDVMCallInfo> return values. Although the spec[1] is still in draft
form, the GetQoute part has been agreed by the major TDX VMMs.

Unfortunately the commits that were upstreamed still treat <GetQuote> as
individually enumerable. They set bit 0 in the user_tdvmcallinfo_1_r11
which is reported to userspace to tell supported optional TDVMCalls,
intending to say that <GetQuote> is supported.

So stop reporting <GetQute> in user_tdvmcallinfo_1_r11 to align with
the direction of the spec, and allow some future TDVMCall to use that bit.

[0] https://lore.kernel.org/all/aEmuKII8FGU4eQZz@google.com/
[1] https://cdrdv2.intel.com/v1/dl/getContent/858626

Fixes: 28224ef02b56 ("KVM: TDX: Report supported optional TDVMCALLs in TDX capabilities")
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index f31ccdeb905b..ea1261ca805f 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -173,7 +173,6 @@ static void td_init_cpuid_entry2(struct kvm_cpuid_entry2 *entry, unsigned char i
 	tdx_clear_unsupported_cpuid(entry);
 }
 
-#define TDVMCALLINFO_GET_QUOTE				BIT(0)
 #define TDVMCALLINFO_SETUP_EVENT_NOTIFY_INTERRUPT	BIT(1)
 
 static int init_kvm_tdx_caps(const struct tdx_sys_info_td_conf *td_conf,
@@ -192,7 +191,6 @@ static int init_kvm_tdx_caps(const struct tdx_sys_info_td_conf *td_conf,
 	caps->cpuid.nent = td_conf->num_cpuid_config;
 
 	caps->user_tdvmcallinfo_1_r11 =
-		TDVMCALLINFO_GET_QUOTE |
 		TDVMCALLINFO_SETUP_EVENT_NOTIFY_INTERRUPT;
 
 	for (i = 0; i < td_conf->num_cpuid_config; i++)
-- 
2.43.0


