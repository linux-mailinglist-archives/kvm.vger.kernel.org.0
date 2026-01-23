Return-Path: <kvm+bounces-68994-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EHwvHI+Oc2l0xAAAu9opvQ
	(envelope-from <kvm+bounces-68994-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 16:06:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FC2877778
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 16:06:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 84A1B3044CA0
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 15:03:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B25133BBBF;
	Fri, 23 Jan 2026 15:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LklEmNJ0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2E9361DD2;
	Fri, 23 Jan 2026 15:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769180437; cv=none; b=VeM3rb2aH3Cainp9LafWUXzfBPkYYC0TN7Ri2NWrs/x0RBG56c/IdhB1RdhMzjf+Di+0GcEglvXdJfdcEnp/RbxieH28Z3evo31VknNZ35I6BxCh8qtfgmLua2OC4m+EdtSxXsp7wTkAt62R7sozgYB7HCYBpeUJyoeVxVzJs/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769180437; c=relaxed/simple;
	bh=KJpmqqhLnjAbDclaNk+4xpsm/pXva8svEd54xfOtQPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F3Uet478oNCdPgo9em/bbWmDxd/DllCL+1ieoTRXS+1De8DYkLv6QHepYKf8tqwrtMJWOK+vg92MikI2JAmmPr+9EvAkcW47AU/K0FD1tfF19K+OY4WswbCeK9HHKp3OqDuEY151V9QAIt+CutC/O19zAgUKjN3GGAG++zNx+uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LklEmNJ0; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769180436; x=1800716436;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KJpmqqhLnjAbDclaNk+4xpsm/pXva8svEd54xfOtQPw=;
  b=LklEmNJ04Ao50Xx+70LP7yxBQ47V4Q9eK1pq+ur4cgLTSdueESo6JnIi
   rwZpnr4tN9efjtFAjsU25kPcqXxB2H7FStOC5hrXs+Uqd+0ydEWcrjvKU
   5vNnoLGBs4vbjJYpRK58gP0J94N8Inc7xnycl4/B99PXTOVNB0drpUsWA
   PXjhl7hNCdh1gUVIjSec1zNlm30PNSySJSJroSE4Oi1hxlTh55jYH25IP
   e6EL8EfmhqUJUXTzrnm4AptD/JMP5fpa+YxQy0w6rmqlGgVYSWEHmpnxu
   ssljkTsTXldroN/hRjRfMmagCabTdpSMujnIOHZ7zshZ9DuDXvT+DBtcn
   A==;
X-CSE-ConnectionGUID: 4tCBbG7mQTakslkrNewrtQ==
X-CSE-MsgGUID: tIEh1d6tRpKJoZRvj2D2JQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11680"; a="70334487"
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="70334487"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 07:00:18 -0800
X-CSE-ConnectionGUID: VtwK72JFTvOS9MSnXDwF1w==
X-CSE-MsgGUID: OiWuBPkKR72fDYfjxuD+Ow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="237697186"
Received: from 984fee019967.jf.intel.com ([10.23.153.244])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 07:00:18 -0800
From: Chao Gao <chao.gao@intel.com>
To: linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org
Cc: reinette.chatre@intel.com,
	ira.weiny@intel.com,
	kai.huang@intel.com,
	dan.j.williams@intel.com,
	yilun.xu@linux.intel.com,
	sagis@google.com,
	vannapurve@google.com,
	paulmck@kernel.org,
	nik.borisov@suse.com,
	zhenzhong.duan@intel.com,
	seanjc@google.com,
	rick.p.edgecombe@intel.com,
	kas@kernel.org,
	dave.hansen@linux.intel.com,
	vishal.l.verma@intel.com,
	Chao Gao <chao.gao@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v3 19/26] x86/virt/seamldr: Install a new TDX Module
Date: Fri, 23 Jan 2026 06:55:27 -0800
Message-ID: <20260123145645.90444-20-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260123145645.90444-1-chao.gao@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[25];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68994-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,intel.com:mid]
X-Rspamd-Queue-Id: 0FC2877778
X-Rspamd-Action: no action

After shutting down the running TDX module, the next step is to install the
new TDX Module supplied by userspace.

P-SEAMLDR provides the SEAMLDR.INSTALL SEAMCALL for that. The SEAMCALL
accepts the seamldr_params struct and should be called serially on all
CPUs.

Invoke the SEAMLDR.INSTALL SEAMCALL serially on all CPUs and add a new
spinlock to enforce serialization.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
---
 arch/x86/virt/vmx/tdx/seamldr.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/seamldr.c b/arch/x86/virt/vmx/tdx/seamldr.c
index b497fa72ebb6..13c34e6378e0 100644
--- a/arch/x86/virt/vmx/tdx/seamldr.c
+++ b/arch/x86/virt/vmx/tdx/seamldr.c
@@ -13,6 +13,7 @@
 #include <linux/mm.h>
 #include <linux/nmi.h>
 #include <linux/slab.h>
+#include <linux/spinlock.h>
 #include <linux/stop_machine.h>
 #include <linux/types.h>
 
@@ -23,6 +24,7 @@
 
 /* P-SEAMLDR SEAMCALL leaf function */
 #define P_SEAMLDR_INFO			0x8000000000000000
+#define P_SEAMLDR_INSTALL		0x8000000000000001
 
 /* P-SEAMLDR can accept up to 496 4KB pages for TDX module binary */
 #define SEAMLDR_MAX_NR_MODULE_4KB_PAGES	496
@@ -45,6 +47,7 @@ struct seamldr_params {
 } __packed;
 
 static struct seamldr_info seamldr_info __aligned(256);
+static DEFINE_RAW_SPINLOCK(seamldr_lock);
 
 static inline int seamldr_call(u64 fn, struct tdx_module_args *args)
 {
@@ -235,6 +238,7 @@ static struct seamldr_params *init_seamldr_params(const u8 *data, u32 size)
 enum tdp_state {
 	TDP_START,
 	TDP_SHUTDOWN,
+	TDP_CPU_INSTALL,
 	TDP_DONE,
 };
 
@@ -272,9 +276,10 @@ static void print_update_failure_message(void)
  * See multi_cpu_stop() from where this multi-cpu state-machine was
  * adopted, and the rationale for touch_nmi_watchdog()
  */
-static int do_seamldr_install_module(void *params)
+static int do_seamldr_install_module(void *seamldr_params)
 {
 	enum tdp_state newstate, curstate = TDP_START;
+	struct tdx_module_args args = {};
 	int cpu = smp_processor_id();
 	bool primary;
 	int ret = 0;
@@ -293,6 +298,11 @@ static int do_seamldr_install_module(void *params)
 				if (primary)
 					ret = tdx_module_shutdown();
 				break;
+			case TDP_CPU_INSTALL:
+				args.rcx = __pa(seamldr_params);
+				scoped_guard(raw_spinlock, &seamldr_lock)
+					ret = seamldr_call(P_SEAMLDR_INSTALL, &args);
+				break;
 			default:
 				break;
 			}
-- 
2.47.3


