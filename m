Return-Path: <kvm+bounces-33271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4288B9E88EE
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 02:11:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB4E31886DB1
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 01:08:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E56611E86E;
	Mon,  9 Dec 2024 01:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fBrzWu2q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90049171E76;
	Mon,  9 Dec 2024 01:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733706379; cv=none; b=Zh/lKBZ+LGQVKnDNIRNFjCtioMvK5d6Kb2LUr1BeqPrK87pTuqhqJtsO8hTNZDSH+NCYrkek8rOIwDjnL5nKlgnKSwu8/Ah1XofsSxeGowioAQ8IAllsdDDawuLF8lvw5KsV0h+YEWfCdWG16Z1WPsotxrANZRqZrI+mPxkTMWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733706379; c=relaxed/simple;
	bh=AYHBZbrjquH1tFqarRInkGRZET4ShNmSkNhvZUOTuio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bv2R83OOkJ4fxb1Y3vyuNkwP7lgRE6R/xbEZd27xxbLpw3yh2oQXXvOjW3CXVGTi4Hl+qGxvnQ1JElHB72X85Ev1Tiu/OkAgdD5zCupYnzIxlqpaEI5kSTcraeUsnmFKIl9tiMb/xd/5UugfFDtbb1HbrauQvpaLW4oiVg3/IhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fBrzWu2q; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733706378; x=1765242378;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AYHBZbrjquH1tFqarRInkGRZET4ShNmSkNhvZUOTuio=;
  b=fBrzWu2qKucFLRE2NhBibpNZuSI2azpilVfnKojlKgg0Iko/gfMGyVUN
   v08JC9yHv4pQgG9qzmVaIjqGEDieValcNNkW7cjv4tR5sco4bQW+swfWO
   n0ZhSvITxKM0T1hC1+JzHuvWVULtJRkbgcbSRMIHmDyMND3yrRR8g8FvT
   QvQ3xTIL4hmOVINsLScScS5dMBo5lau01hY4CnlLrLb/R1jr4ey0wyPsP
   gC0bLqOIMF0sQ62Ta3L8oVPGufwTSfsSpjh8EvrdSn9V2PHDdu/36a4pn
   6kUpIa3P9YDSg5DOFlRNiH+FvMiM3604I8hM2BkPKhMKGl1cClB4kpHSz
   g==;
X-CSE-ConnectionGUID: WmWnq7dmS86cvYVlo8r7tg==
X-CSE-MsgGUID: iAnRB2pqRyKR3Q3agx6+zw==
X-IronPort-AV: E=McAfee;i="6700,10204,11280"; a="36833726"
X-IronPort-AV: E=Sophos;i="6.12,218,1728975600"; 
   d="scan'208";a="36833726"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2024 17:06:17 -0800
X-CSE-ConnectionGUID: Z0SnVEeZSUSJEKhx7EtrRw==
X-CSE-MsgGUID: 08Jd9yCAQLOb29e0CzDqwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,218,1728975600"; 
   d="scan'208";a="95402520"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2024 17:06:14 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH 12/16] KVM: TDX: Inhibit APICv for TDX guest
Date: Mon,  9 Dec 2024 09:07:26 +0800
Message-ID: <20241209010734.3543481-13-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Inhibit APICv for TDX guest in KVM since TDX doesn't support APICv accesses
from host VMM.

Follow how SEV inhibits APICv.  I.e, define a new inhibit reason for TDX, set
it on TD initialization, and add the flag to kvm_x86_ops.required_apicv_inhibits.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX interrupts breakout:
- Removed WARN_ON_ONCE(kvm_apicv_activated(vcpu->kvm)) in
  tdx_td_vcpu_init(). (Rick)
- Change APICV -> APICv in changelog for consistency.
- Split the changelog to 2 paragraphs.
---
 arch/x86/include/asm/kvm_host.h | 12 +++++++++++-
 arch/x86/kvm/vmx/main.c         |  3 ++-
 arch/x86/kvm/vmx/tdx.c          |  3 +++
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 32c7d58a5d68..df535f08e004 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1281,6 +1281,15 @@ enum kvm_apicv_inhibit {
 	 */
 	APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED,
 
+	/*********************************************************/
+	/* INHIBITs that are relevant only to the Intel's APICv. */
+	/*********************************************************/
+
+	/*
+	 * APICv is disabled because TDX doesn't support it.
+	 */
+	APICV_INHIBIT_REASON_TDX,
+
 	NR_APICV_INHIBIT_REASONS,
 };
 
@@ -1299,7 +1308,8 @@ enum kvm_apicv_inhibit {
 	__APICV_INHIBIT_REASON(IRQWIN),			\
 	__APICV_INHIBIT_REASON(PIT_REINJ),		\
 	__APICV_INHIBIT_REASON(SEV),			\
-	__APICV_INHIBIT_REASON(LOGICAL_ID_ALIASED)
+	__APICV_INHIBIT_REASON(LOGICAL_ID_ALIASED),	\
+	__APICV_INHIBIT_REASON(TDX)
 
 struct kvm_arch {
 	unsigned long n_used_mmu_pages;
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 7f933f821188..13a0ab0a520c 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -445,7 +445,8 @@ static int vt_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 	 BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |			\
 	 BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |	\
 	 BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |		\
-	 BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED))
+	 BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED) |		\
+	 BIT(APICV_INHIBIT_REASON_TDX))
 
 struct kvm_x86_ops vt_x86_ops __initdata = {
 	.name = KBUILD_MODNAME,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b0f525069ebd..b51d2416acfb 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2143,6 +2143,8 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 		goto teardown;
 	}
 
+	kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_TDX);
+
 	return 0;
 
 	/*
@@ -2528,6 +2530,7 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 		return -EIO;
 	}
 
+	vcpu->arch.apic->apicv_active = false;
 	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 
 	return 0;
-- 
2.46.0


