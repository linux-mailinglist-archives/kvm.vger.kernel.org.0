Return-Path: <kvm+bounces-52465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E2987B0563D
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 11:23:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC88C4E604B
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 09:22:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 320642D6603;
	Tue, 15 Jul 2025 09:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FUMuw6e0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED0E2D5A08;
	Tue, 15 Jul 2025 09:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752571307; cv=none; b=XLB9N2oPZ42KJ2UEfu9dt5fbvUrTOViSYQH4W1QvY9SAfGfx3xpgqXkGTWIE7F0U5gmrQSVHmrmP9c6SSb6XhsqGSzFM5DUKB9UEjlxXADaa3/hzGuWPdxwUfs+7uIDhwyitliNbGOfkmrbeOuPSH+5BMn5p9fBcYzrdxN/s0bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752571307; c=relaxed/simple;
	bh=AJZCa/zxixHSRjGU574C3rCz/DtBj23gZzVQ/NXvAG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1ZhBB0lZbCHUlyXySqROcPq6vOeGLXPZSUWO+OkZMN6EpSbmn8cLgs592S70aDYoMFqLoEUz1YubkpBh9LV2N1S5680bjSyq5eL2mxwiXlSvENpwo+sGJPm7oSv9cbHG563MVrfw9m5AHXRo9QPUuPcNXl++TsPWhGEfqAnLFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FUMuw6e0; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752571306; x=1784107306;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AJZCa/zxixHSRjGU574C3rCz/DtBj23gZzVQ/NXvAG0=;
  b=FUMuw6e04Fg+8Of2nFdFOSYuRQOCIIvZOIjs+lja7QZYVCt/SgTHvrU5
   XnAfrPB+Zd+CS/ETnYQQK4yLNLRhHlgbhtwicyY9Gcm3yBB/6Yt9015m/
   wwrC2S2CK434XbEiLpDzeBUaLlfzoJyAJrFfaAf/jX0wON6WVI6FdBGDG
   LzOO4VNBSt1Fysp4gWAZpNTRkuhqgDZxfk1hZC7UwJN/XRhwLNPvvm+R9
   IwO81/Yn9RuOnwFOVGO8fjjMbDlUX5bs2wN6MeUarJPToWU2sJoZMIO0M
   rottzKkAjErNgCxm5OAS9teVLoZn3stdzocm/ua9cuqhpLPIRASMEpdiK
   Q==;
X-CSE-ConnectionGUID: ZA5kOMQ1QEegenl2jL61UQ==
X-CSE-MsgGUID: BYzTS07aThOHkxg0zQA/5A==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54003398"
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="54003398"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 02:21:45 -0700
X-CSE-ConnectionGUID: 9psXVbHbSkKipD84/pTxvw==
X-CSE-MsgGUID: T9bCbQFLRCatMEt6RJ4j/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="188183753"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa001.fm.intel.com with ESMTP; 15 Jul 2025 02:21:41 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: "Kirill A. Shutemov" <kas@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-coco@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Kai Huang <kai.huang@intel.com>,
	binbin.wu@linux.intel.com,
	yan.y.zhao@intel.com,
	reinette.chatre@intel.com,
	adrian.hunter@intel.com,
	tony.lindgren@intel.com,
	xiaoyao.li@intel.com
Subject: [PATCH v3 4/4] KVM: TDX: Rename KVM_SUPPORTED_TD_ATTRS to KVM_SUPPORTED_TDX_TD_ATTRS
Date: Tue, 15 Jul 2025 17:13:12 +0800
Message-ID: <20250715091312.563773-5-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250715091312.563773-1-xiaoyao.li@intel.com>
References: <20250715091312.563773-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rename KVM_SUPPORTED_TD_ATTRS to KVM_SUPPORTED_TDX_TD_ATTRS to include
"TDX" in the name, making it clear that it pertains to TDX.

Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index c539c2e6109f..9473610d32e6 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -62,7 +62,7 @@ void tdh_vp_wr_failed(struct vcpu_tdx *tdx, char *uclass, char *op, u32 field,
 	pr_err("TDH_VP_WR[%s.0x%x]%s0x%llx failed: 0x%llx\n", uclass, field, op, val, err);
 }
 
-#define KVM_SUPPORTED_TD_ATTRS (TDX_TD_ATTR_SEPT_VE_DISABLE)
+#define KVM_SUPPORTED_TDX_TD_ATTRS (TDX_TD_ATTR_SEPT_VE_DISABLE)
 
 static __always_inline struct kvm_tdx *to_kvm_tdx(struct kvm *kvm)
 {
@@ -76,7 +76,7 @@ static __always_inline struct vcpu_tdx *to_tdx(struct kvm_vcpu *vcpu)
 
 static u64 tdx_get_supported_attrs(const struct tdx_sys_info_td_conf *td_conf)
 {
-	u64 val = KVM_SUPPORTED_TD_ATTRS;
+	u64 val = KVM_SUPPORTED_TDX_TD_ATTRS;
 
 	if ((val & td_conf->attributes_fixed1) != td_conf->attributes_fixed1)
 		return 0;
-- 
2.43.0


