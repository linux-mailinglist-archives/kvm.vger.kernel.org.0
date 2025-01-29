Return-Path: <kvm+bounces-36827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 808F0A21A93
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 11:00:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C95F018883B5
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 10:00:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C63C01B0434;
	Wed, 29 Jan 2025 09:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gGckBbF+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110AE1AE005;
	Wed, 29 Jan 2025 09:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738144788; cv=none; b=OnOzz9kP/eR7Qt7jfaBEOqjFcUPdCSSUKE9bTH6qqBeAxJSIIAIFmR3ga0Is/G33hiHHYlNgJRMoMHpZdV4FTkS74DWFSYULnVPiKuerKPjY8w7MGZ9bGv4mFJezxp9hY3R3Zq/o4i5Fcm/tBKOf4k8YzAOm5RThrkAsS1osNl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738144788; c=relaxed/simple;
	bh=/4Lo8XF6cbPBU2Y7UwHVxWV7Y8Vf0vf6oq/Z59rDoIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b2Cwm2a09qgpRx4teGzhJxhJ9qLZB/a6jYZV30EBGegnTgJ+RSVrbbm1GhUIvLGZ9JaEh6Ky6vc8/LQ2kf/pb2fbHM/EEd+MJrNI7QbmuxdiG2LrazJfLtN3yL5Xz+bLWHoYf4f1MVVhhyBnVdAzIO5FpbfegyjWyARpilcj76E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gGckBbF+; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738144786; x=1769680786;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/4Lo8XF6cbPBU2Y7UwHVxWV7Y8Vf0vf6oq/Z59rDoIE=;
  b=gGckBbF+dCVTz9E7YwiYJBDPlpoNxomdv3sa+jFvDsu3pEN/IAfKbuFI
   MqZsw6hJ1qidmY8ngFks7P/9R36SL5kJYf7IPaqGkxUS39u96qZgn8dPw
   tcU/tXTpti5eo6j5QBgp7geuWkm+d3mKQCOa2R/U7NCPTpjoV6kTNrRFJ
   dKxQMhnBNSlqObqxLYpQvkOYoSqHnhcSyYBoSFcpe8wcYgLLQPSq5VmVu
   sJZdOHO6srlTttDDV1gJjPSNxhR7vmE33HjfOzlFJ0el5hhKoIJLDj0+f
   Gz4+FjqZtOH3+ASVkLKXoByfL1n8zPMAuwC4TnE4Gq5bwQA83N1v665hi
   Q==;
X-CSE-ConnectionGUID: gxcfjVTFTTmrTklF1BEN5A==
X-CSE-MsgGUID: f7xV9Qy9Sn2camGr+Xdp5g==
X-IronPort-AV: E=McAfee;i="6700,10204,11329"; a="50035966"
X-IronPort-AV: E=Sophos;i="6.13,243,1732608000"; 
   d="scan'208";a="50035966"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2025 01:59:24 -0800
X-CSE-ConnectionGUID: ofh4u1lCQe2kTW83QZPjwA==
X-CSE-MsgGUID: JOTYmd5hScyyij0ku6Qdtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="132262644"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.ger.corp.intel.com) ([10.246.0.178])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2025 01:59:19 -0800
From: Adrian Hunter <adrian.hunter@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	nik.borisov@suse.com,
	linux-kernel@vger.kernel.org,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	weijiang.yang@intel.com,
	dave.hansen@linux.intel.com,
	x86@kernel.org
Subject: [PATCH V2 01/12] x86/virt/tdx: Make tdh_vp_enter() noinstr
Date: Wed, 29 Jan 2025 11:58:50 +0200
Message-ID: <20250129095902.16391-2-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250129095902.16391-1-adrian.hunter@intel.com>
References: <20250129095902.16391-1-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

Make tdh_vp_enter() noinstr because KVM requires VM entry to be noinstr
for 2 reasons:
 1. The use of context tracking via guest_state_enter_irqoff() and
    guest_state_exit_irqoff()
 2. The need to avoid IRET between VM-exit and NMI handling in order to
    avoid prematurely releasing NMI inhibit.

Consequently make __seamcall_saved_ret() noinstr also. Currently
tdh_vp_enter() is the only caller of __seamcall_saved_ret().

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
TD vcpu enter/exit v2:
 - New patch
---
 arch/x86/virt/vmx/tdx/seamcall.S | 3 +++
 arch/x86/virt/vmx/tdx/tdx.c      | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/seamcall.S b/arch/x86/virt/vmx/tdx/seamcall.S
index 5b1f2286aea9..6854c52c374b 100644
--- a/arch/x86/virt/vmx/tdx/seamcall.S
+++ b/arch/x86/virt/vmx/tdx/seamcall.S
@@ -41,6 +41,9 @@ SYM_FUNC_START(__seamcall_ret)
 	TDX_MODULE_CALL host=1 ret=1
 SYM_FUNC_END(__seamcall_ret)
 
+/* KVM requires non-instrumentable __seamcall_saved_ret() for TDH.VP.ENTER */
+.section .noinstr.text, "ax"
+
 /*
  * __seamcall_saved_ret() - Host-side interface functions to SEAM software
  * (the P-SEAMLDR or the TDX module), with saving output registers to the
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 4a010e65276d..1515c467dd86 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1511,7 +1511,7 @@ static void tdx_clflush_page(struct page *page)
 	clflush_cache_range(page_to_virt(page), PAGE_SIZE);
 }
 
-u64 tdh_vp_enter(struct tdx_vp *td, struct tdx_module_args *args)
+noinstr u64 tdh_vp_enter(struct tdx_vp *td, struct tdx_module_args *args)
 {
 	args->rcx = tdx_tdvpr_pa(td);
 
-- 
2.43.0


