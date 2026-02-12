Return-Path: <kvm+bounces-70974-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IP7cDp3mjWms8QAAu9opvQ
	(envelope-from <kvm+bounces-70974-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:41:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C2A8512E5AB
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:41:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 58CDE310689A
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 14:37:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCC4C361666;
	Thu, 12 Feb 2026 14:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JDhdWFpP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E536735FF79;
	Thu, 12 Feb 2026 14:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770906985; cv=none; b=rSHL6z+izF9aAtP1gMhhyIcrcHj01advS1pIS7/ecF+YMKNazl/TQAmb4tMtl4eyyYh3m8V9GQ02SG2yT+qfGSnHZ8B2ME6ojKP5DWficJUW0I9WamgySpSlHI2zISALigRb4LvTgatc1nTombI8QWbPFROKBYqUgXWsDKQmpF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770906985; c=relaxed/simple;
	bh=jdrRXNF7aPnIm+3Q3Sa3xsjiQxhL3L60es0JuoyeMLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mDP26T3elhqhxV4Qj5RHGEWYWZJcLOibmbfSsIHh0+0A0+PGKhLhFwKFRtOdS9p5Ml8SMklPJBb3vevux7Q/hR4sINCHxxKwZoBliF7SY/y22A0E8OPdiDZ9O93JBwtATfjGzxbN71ASux/tV6D8ojVhjrEM/uRJO++J5wOTzpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JDhdWFpP; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770906984; x=1802442984;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jdrRXNF7aPnIm+3Q3Sa3xsjiQxhL3L60es0JuoyeMLs=;
  b=JDhdWFpPraJvvhzwh4/6UvWZdCHd2tSwGvHm3vvb2WvjJS4YkUXUBG6J
   RtvuBBb7hFRLsY3UKurbeIAnp8MLa0HkcQzLX9Yi8ZOrDpfdbdCXeJtpp
   FZjxNi2DYxldQSoExFZ3SBssv+EtOwVfPnjHsGqI+IHdBjbqNY7QmpHYv
   NwRFGgXOdLBnYn492MRPqO66v+d7GhAfmfcEVlMq2Ck5iHturJ3o9n3x8
   LGluEw/SKdGwUxw2XLbm09tmQniPDcwOU479qNVZyNpkC4tcwcgS0B49i
   YVBa8b/yjhUDIh5ILBTDLu59HNgrygJAxIA08MJNjGwoW44/wrfIUsvII
   A==;
X-CSE-ConnectionGUID: QdEX8vTUR+qHYWWo0ayXhg==
X-CSE-MsgGUID: xQhIRCvFTYOIic6Vyk3R+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11699"; a="89662843"
X-IronPort-AV: E=Sophos;i="6.21,286,1763452800"; 
   d="scan'208";a="89662843"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 06:36:23 -0800
X-CSE-ConnectionGUID: 0oKAbTlcSWSOb/U54VCYRg==
X-CSE-MsgGUID: KrtZ/AP7S4yYX5CYYslwvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,286,1763452800"; 
   d="scan'208";a="211428267"
Received: from 984fee019967.jf.intel.com ([10.23.153.244])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 06:36:23 -0800
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
	binbin.wu@linux.intel.com,
	tony.lindgren@linux.intel.com,
	Chao Gao <chao.gao@intel.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v4 13/24] x86/virt/seamldr: Shut down the current TDX module
Date: Thu, 12 Feb 2026 06:35:16 -0800
Message-ID: <20260212143606.534586-14-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260212143606.534586-1-chao.gao@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[26];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70974-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: C2A8512E5AB
X-Rspamd-Action: no action

The first step of TDX Module updates is shutting down the current TDX
Module. This step also packs state information that needs to be
preserved across updates as handoff data, which will be consumed by the
updated module. The handoff data is stored internally in the SEAM range
and is hidden from the kernel.

To ensure a successful update, the new module must be able to consume
the handoff data generated by the old module. Since handoff data layout
may change between modules, the handoff data is versioned. Each module
has a native handoff version and provides backward support for several
older versions.

The complete handoff versioning protocol is complex as it supports both
module upgrades and downgrades. See details in Intel® Trust Domain
Extensions (Intel® TDX) Module Base Architecture Specification, Revision
348549-007, Chapter 4.5.3 "Handoff Versioning".

Ideally, the kernel needs to retrieve the handoff versions supported by
the current module and the new module and select a version supported by
both. But, since the Linux kernel only supports module upgrades, simply
request the current module to generate handoff data using its highest
supported version, expecting that the new module will likely support it.

Note that only one CPU needs to call the TDX Module's shutdown API.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>
---
v4:
 - skip the whole handoff metadata if runtime updates are not supported
   [Yilun]
v3:
 - remove autogeneration stuff in the changelog
v2:
 - add a comment about how handoff version is chosen.
 - remove the first !ret in get_tdx_sys_info_handoff() as we edited the
   auto-generated code anyway
 - remove !! when determining whether a CPU is the primary one
 - remove unnecessary if-break nesting in TDP_SHUTDOWN
---
 arch/x86/include/asm/tdx_global_metadata.h  |  5 +++++
 arch/x86/virt/vmx/tdx/seamldr.c             | 10 ++++++++++
 arch/x86/virt/vmx/tdx/tdx.c                 | 15 +++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h                 |  3 +++
 arch/x86/virt/vmx/tdx/tdx_global_metadata.c | 15 +++++++++++++++
 5 files changed, 48 insertions(+)

diff --git a/arch/x86/include/asm/tdx_global_metadata.h b/arch/x86/include/asm/tdx_global_metadata.h
index 40689c8dc67e..8a9ebd895e70 100644
--- a/arch/x86/include/asm/tdx_global_metadata.h
+++ b/arch/x86/include/asm/tdx_global_metadata.h
@@ -40,12 +40,17 @@ struct tdx_sys_info_td_conf {
 	u64 cpuid_config_values[128][2];
 };
 
+struct tdx_sys_info_handoff {
+	u16 module_hv;
+};
+
 struct tdx_sys_info {
 	struct tdx_sys_info_version version;
 	struct tdx_sys_info_features features;
 	struct tdx_sys_info_tdmr tdmr;
 	struct tdx_sys_info_td_ctrl td_ctrl;
 	struct tdx_sys_info_td_conf td_conf;
+	struct tdx_sys_info_handoff handoff;
 };
 
 #endif
diff --git a/arch/x86/virt/vmx/tdx/seamldr.c b/arch/x86/virt/vmx/tdx/seamldr.c
index 70bc577e5957..c59cdd5b1fe4 100644
--- a/arch/x86/virt/vmx/tdx/seamldr.c
+++ b/arch/x86/virt/vmx/tdx/seamldr.c
@@ -18,6 +18,7 @@
 #include <asm/seamldr.h>
 
 #include "seamcall_internal.h"
+#include "tdx.h"
 
 /* P-SEAMLDR SEAMCALL leaf function */
 #define P_SEAMLDR_INFO			0x8000000000000000
@@ -196,6 +197,7 @@ static struct seamldr_params *init_seamldr_params(const u8 *data, u32 size)
  */
 enum tdp_state {
 	TDP_START,
+	TDP_SHUTDOWN,
 	TDP_DONE,
 };
 
@@ -228,8 +230,12 @@ static void ack_state(void)
 static int do_seamldr_install_module(void *params)
 {
 	enum tdp_state newstate, curstate = TDP_START;
+	int cpu = smp_processor_id();
+	bool primary;
 	int ret = 0;
 
+	primary = cpumask_first(cpu_online_mask) == cpu;
+
 	do {
 		/* Chill out and re-read tdp_data */
 		cpu_relax();
@@ -238,6 +244,10 @@ static int do_seamldr_install_module(void *params)
 		if (newstate != curstate) {
 			curstate = newstate;
 			switch (curstate) {
+			case TDP_SHUTDOWN:
+				if (primary)
+					ret = tdx_module_shutdown();
+				break;
 			default:
 				break;
 			}
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index b65b2a609e81..f911c8c63800 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1176,6 +1176,21 @@ int tdx_enable(void)
 }
 EXPORT_SYMBOL_FOR_KVM(tdx_enable);
 
+int tdx_module_shutdown(void)
+{
+	struct tdx_module_args args = {};
+
+	/*
+	 * Shut down the TDX Module and prepare handoff data for the next
+	 * TDX Module. This SEAMCALL requires a handoff version. Use the
+	 * module's handoff version, as it is the highest version the
+	 * module can produce and is more likely to be supported by new
+	 * modules as new modules likely have higher handoff version.
+	 */
+	args.rcx = tdx_sysinfo.handoff.module_hv;
+	return seamcall_prerr(TDH_SYS_SHUTDOWN, &args);
+}
+
 static bool is_pamt_page(unsigned long phys)
 {
 	struct tdmr_info_list *tdmr_list = &tdx_tdmr_list;
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 82bb82be8567..1c4da9540ae0 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -46,6 +46,7 @@
 #define TDH_PHYMEM_PAGE_WBINVD		41
 #define TDH_VP_WR			43
 #define TDH_SYS_CONFIG			45
+#define TDH_SYS_SHUTDOWN		52
 
 /*
  * SEAMCALL leaf:
@@ -118,4 +119,6 @@ struct tdmr_info_list {
 	int max_tdmrs;	/* How many 'tdmr_info's are allocated */
 };
 
+int tdx_module_shutdown(void);
+
 #endif
diff --git a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
index 4c9917a9c2c3..6aee10c36489 100644
--- a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
+++ b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
@@ -100,6 +100,20 @@ static int get_tdx_sys_info_td_conf(struct tdx_sys_info_td_conf *sysinfo_td_conf
 	return ret;
 }
 
+static int get_tdx_sys_info_handoff(struct tdx_sys_info_handoff *sysinfo_handoff)
+{
+	int ret = 0;
+	u64 val;
+
+	if (!tdx_supports_runtime_update(&tdx_sysinfo))
+		return 0;
+
+	if (!ret && !(ret = read_sys_metadata_field(0x8900000100000000, &val)))
+		sysinfo_handoff->module_hv = val;
+
+	return ret;
+}
+
 static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
 {
 	int ret = 0;
@@ -115,6 +129,7 @@ static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
 	ret = ret ?: get_tdx_sys_info_tdmr(&sysinfo->tdmr);
 	ret = ret ?: get_tdx_sys_info_td_ctrl(&sysinfo->td_ctrl);
 	ret = ret ?: get_tdx_sys_info_td_conf(&sysinfo->td_conf);
+	ret = ret ?: get_tdx_sys_info_handoff(&sysinfo->handoff);
 
 	return ret;
 }
-- 
2.47.3


