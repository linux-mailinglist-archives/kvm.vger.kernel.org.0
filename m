Return-Path: <kvm+bounces-47548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D0578AC204C
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 11:57:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 695761781D6
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 09:57:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE90224166A;
	Fri, 23 May 2025 09:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Oplk5MMM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557C823C8DB;
	Fri, 23 May 2025 09:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747994036; cv=none; b=b+G+AJ/Qd+qa91pV9eJHUsg7Cm6A8jsnJmcbkJkOpJyw6Wa2sM4PPNhhwFxfDcv9SBZhGCjZ2CNMtYyLM2JCyWV4HmS2lLXPa4oDe7XcazUMJEbJvfhuzkNAfarRltKgzzi+xtFD0xcvPNZWl7qDx41PxUuVj8hbzkBUG97rERY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747994036; c=relaxed/simple;
	bh=nviGRwH+/KUO7vULr9q0AjxG0x6jr8VzzBx1v24lAQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OkuyL+FnWFPz4jQVveU6u45KLy1z7NzvgEwypsBIzzb5fa4b8H62gM2ZTpF0RiUrnYXTrghZCdOzqBQRchP1KfMGF8xSTkJLLhyhQZp/DTPeg8nmEXf7W1l4fWyNa0tTVDP2756ZY09Ks4TDYuQNGcJayBA5YFWf3JoovxGSiMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Oplk5MMM; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747994034; x=1779530034;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nviGRwH+/KUO7vULr9q0AjxG0x6jr8VzzBx1v24lAQg=;
  b=Oplk5MMMJcFNSC1G2lvzYAeM/Est0vbFycFp84JhbbuYTrGAin6fU7e4
   nHaThirrbt4G6CaZ5rCJbvRtxyWuw0NbTdBQfe/cLlv8Kac0lsu1Vu9Or
   hOWs1H/150clC5XUzi4n4uVdzC44MyrP3WpciIBSE+HtsgpnNqxUj0l11
   FYb2DmQoll/kImE7sT+dtjmrjLB1lbYlmPZA5968CM9Y9ADDgQSzTZQEb
   E/C51qLG6UXhMfcDiC7UNfWPojMHUSnkPR5Ya9CWZGl8zPBGQQlx8RvKL
   kYT/6VU8A+KsbjYCwcHtWFX/Fi5XiGe2b4RabtwPNg/eYXZ5uO8BGvuvE
   w==;
X-CSE-ConnectionGUID: kN/XWtKDROWua0OEX/+WpA==
X-CSE-MsgGUID: AJHB0EE1QKOltr8k7PWFFg==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="75444207"
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="75444207"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:53:54 -0700
X-CSE-ConnectionGUID: lcqwToa7S8+fQ2cBRbMlWg==
X-CSE-MsgGUID: UrMtVa8yS/OqOHu8OsbCDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="164315078"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:53:53 -0700
From: Chao Gao <chao.gao@intel.com>
To: linux-coco@lists.linux.dev,
	x86@kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	eddie.dong@intel.com,
	kirill.shutemov@intel.com,
	dave.hansen@intel.com,
	dan.j.williams@intel.com,
	kai.huang@intel.com,
	isaku.yamahata@intel.com,
	elena.reshetova@intel.com,
	rick.p.edgecombe@intel.com,
	Chao Gao <chao.gao@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 13/20] x86/virt/tdx: Reset software states after TDX module shutdown
Date: Fri, 23 May 2025 02:52:36 -0700
Message-ID: <20250523095322.88774-14-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250523095322.88774-1-chao.gao@intel.com>
References: <20250523095322.88774-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reset all software states used to track and guard TDX global and per-CPU
initialization (i.e. TDH.SYS.INIT and TDH.SYS.LP.INIT). the kernel needs to
do them again after TD-Preserving updates.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index fa6b3f1eb197..4cdeec0a4128 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -56,6 +56,9 @@ static struct tdmr_info_list tdx_tdmr_list;
 static enum tdx_module_status_t tdx_module_status;
 static DEFINE_MUTEX(tdx_module_lock);
 
+static bool sysinit_done;
+static int sysinit_ret;
+
 /* All TDX-usable memory regions.  Protected by mem_hotplug_lock. */
 static LIST_HEAD(tdx_memlist);
 
@@ -130,8 +133,6 @@ static int try_init_module_global(void)
 {
 	struct tdx_module_args args = {};
 	static DEFINE_RAW_SPINLOCK(sysinit_lock);
-	static bool sysinit_done;
-	static int sysinit_ret;
 
 	lockdep_assert_irqs_disabled();
 
@@ -1346,9 +1347,22 @@ int tdx_enable(void)
 }
 EXPORT_SYMBOL_GPL(tdx_enable);
 
+static void tdx_module_reset_state(void)
+{
+	int cpu;
+
+	tdx_module_status = TDX_MODULE_UNINITIALIZED;
+	sysinit_done = false;
+	sysinit_ret = 0;
+
+	for_each_online_cpu(cpu)
+		per_cpu(tdx_lp_initialized, cpu) = false;
+}
+
 int tdx_module_shutdown(void)
 {
 	struct tdx_module_args args = {};
+	int ret;
 
 	/*
 	 * Shut down TDX module and prepare handoff data for the next TDX module.
@@ -1356,7 +1370,11 @@ int tdx_module_shutdown(void)
 	 * fail.
 	 */
 	args.rcx = tdx_sysinfo.handoff.module_hv;
-	return seamcall_prerr(TDH_SYS_SHUTDOWN, &args);
+	ret = seamcall_prerr(TDH_SYS_SHUTDOWN, &args);
+	if (!ret)
+		tdx_module_reset_state();
+
+	return ret;
 }
 
 static bool is_pamt_page(unsigned long phys)
-- 
2.47.1


