Return-Path: <kvm+bounces-36530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 710DEA1B722
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:41:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 095F83AE054
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:41:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B249C14F9F3;
	Fri, 24 Jan 2025 13:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PI8VlI/z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2D113A257
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725988; cv=none; b=cYp7ilRAy7+njjb6MkMCSHyApA/CgMM7FieXA/YA6lPngonwVpvdLAqUIugXW1Ay1P7wmvb7Ya1Sk6atyOocx+K9MhulFmfGxUlESfxP5zMMysp+5bRcMm0rS5OI3vU829lUfh14UZglkH+f7uyRhWGfqadOGY041/FaXDD0mtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725988; c=relaxed/simple;
	bh=R7oHs5ceEXGmP8urc22iTrcnB1GDDwG0Hw6Vg6gX3CI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cHRJ6Vl/CQuu7L+ztJwCtuceB0VboiFm4Qej6YALpKfuR7axwlYPYzKq6F0sMozEzQblU+xVOcGfB7IY7iHB+ZoezZB+Hh/0vtj78uzRF2EjuS4Ls7fhlXFm/9FqT30x127Lvo6VFcn8Af9rULQKjCu/whLlkRmeTXDyXw6EkPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PI8VlI/z; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725988; x=1769261988;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R7oHs5ceEXGmP8urc22iTrcnB1GDDwG0Hw6Vg6gX3CI=;
  b=PI8VlI/zQm2fe9V3DXJ9GvsZXav5QjiUIrdJluiGtnto/APuSeltKJ71
   aTjBZEqiJcZC9h8JDSMmabAAhRgw9P1HLCLg+LqGtO21KoP805qv5Nx0c
   GTYC75k8eu1y4GbOVgmDMUxlljJAwO26gniQvAUKNB8GdAzzZqEbLGkkj
   pVjyAH8d0fvWUoaUvo+ED/NdDZT+Vkkte4U8ydt6NibeT2WVbQrTjo3wT
   kYvOCZpuqaRaTk8jhsMgTs6UGcjRwuLgdqtyvugoqzXORPgWltv4fuAek
   k2RnsXbSaDv4TH69DU1fmur9cBANvbdnSnkPe+aOCluQWg+dZjMQ4wmdt
   A==;
X-CSE-ConnectionGUID: bl8tQJ19T5u/v9Lh6VQgfw==
X-CSE-MsgGUID: M26fY560RSaVJ3/S7jk2Ow==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246588"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246588"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:39:48 -0800
X-CSE-ConnectionGUID: s00mDXelRF6zUi7uycCu8A==
X-CSE-MsgGUID: C0Ay4mYCR+eHJGN2vje7rQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804462"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:39:44 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Igor Mammedov <imammedo@redhat.com>
Cc: Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	xiaoyao.li@intel.com,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: [PATCH v7 44/52] i386/cpu: Move CPUID_XSTATE_XSS_MASK to header file and introduce CPUID_XSTATE_MASK
Date: Fri, 24 Jan 2025 08:20:40 -0500
Message-Id: <20250124132048.3229049-45-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250124132048.3229049-1-xiaoyao.li@intel.com>
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

They will be used by TDX.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/cpu.c | 3 ---
 target/i386/cpu.h | 5 +++++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 4088bf63c48f..f1330627adbb 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1829,9 +1829,6 @@ static const X86RegisterInfo32 x86_reg_info_32[CPU_NB_REGS32] = {
 };
 #undef REGISTER
 
-/* CPUID feature bits available in XSS */
-#define CPUID_XSTATE_XSS_MASK    (XSTATE_ARCH_LBR_MASK)
-
 ExtSaveArea x86_ext_save_areas[XSAVE_STATE_AREA_COUNT] = {
     [XSTATE_FP_BIT] = {
         /* x87 FP state component is always enabled if XSAVE is supported */
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 4890424c3a9e..a4c0531262ce 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -623,6 +623,11 @@ typedef enum X86Seg {
                                  XSTATE_Hi16_ZMM_MASK | XSTATE_PKRU_MASK | \
                                  XSTATE_XTILE_CFG_MASK | XSTATE_XTILE_DATA_MASK)
 
+/* CPUID feature bits available in XSS */
+#define CPUID_XSTATE_XSS_MASK    (XSTATE_ARCH_LBR_MASK)
+
+#define CPUID_XSTATE_MASK       (CPUID_XSTATE_XCR0_MASK | CPUID_XSTATE_XSS_MASK)
+
 /* CPUID feature words */
 typedef enum FeatureWord {
     FEAT_1_EDX,         /* CPUID[1].EDX */
-- 
2.34.1


