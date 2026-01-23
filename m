Return-Path: <kvm+bounces-69000-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CAluCBKRc2ntxAAAu9opvQ
	(envelope-from <kvm+bounces-69000-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 16:17:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D2F6E77AE3
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 16:17:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C24D6301CBB9
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 15:04:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 778B837BE84;
	Fri, 23 Jan 2026 15:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YRCWR7MY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1BB2E92D2;
	Fri, 23 Jan 2026 15:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769180442; cv=none; b=L1oAoVZ3qwwm1FPkpSbhQTvjdyMPlYvQfPcyA9pdtbhTrCHdf44xF2LOa+Ajs2EfjJBXV+teqN7MlYZDYmaSD0wbNw7btAQgppvl8q6s4XkBrashAgtjIyKjYjLDA5fYXbbjkNtQ+59iFcyjMrOcpBXI+f4Cc0zzmA1oafFXu74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769180442; c=relaxed/simple;
	bh=ChYtG309Tbh3eYosJ6vQDIt+smUYzcJ5csnA0tNPxIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EP6904o0ohu75/yx6sXjSxxCJ3oF1k+3Zoih8GYYfe+l3PLld1D88WgBcLw6mMdRnQgYHsQQfFvFGkBKauoZ1CPMZuqn6Zcnn3tXAibTw4vBpIsqVC8K9e0O8+9vOsrPk0B5IDQOFZk1fKJWFX1NyOYsBgOfscx1SYy3wV9cV4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YRCWR7MY; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769180441; x=1800716441;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ChYtG309Tbh3eYosJ6vQDIt+smUYzcJ5csnA0tNPxIc=;
  b=YRCWR7MY34HGlgEBJC5yLsq4M5lGWVazqftxxiHXIDhYZLAxdL/XXLQX
   LoQdTHfSWPpnwH3vHEe9C3ywwAhTVA9aoepzdecgFVyyG06jR1k0TBh+P
   R/SCfPdZv7hS9hdliSPMm6Z3/kbPpu4Fmu3E1CrMr0GivER3YDjU1W1mR
   lVOxISUoG6wADGAdx+bWuFjlzmCQI4CGjhsBrz8ZcvLaIMKZka8SX/wAH
   yEzuNindPc6esCbx1Gz0rkm+ULZVMKRQnVcji/TTJf0mOXlaeP1dOx6Pm
   f1+8MNQBYM4aWKoNyqWpZtM+GTEgtgtPa1XbWjyKCYg3zq4Bwx9BAXG8w
   Q==;
X-CSE-ConnectionGUID: tahIEQEbQAmPtejb2urzDQ==
X-CSE-MsgGUID: n7m6E5syQdWQBAxlXYtr2Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11680"; a="70334544"
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="70334544"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 07:00:21 -0800
X-CSE-ConnectionGUID: XEUXxL6dQtOI8+9yqSsKTw==
X-CSE-MsgGUID: kkUWZcVbRom9SqR3Z7YDcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="237697246"
Received: from 984fee019967.jf.intel.com ([10.23.153.244])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 07:00:21 -0800
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
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 25/26] x86/virt/tdx: Avoid updates during update-sensitive operations
Date: Fri, 23 Jan 2026 06:55:33 -0800
Message-ID: <20260123145645.90444-26-chao.gao@intel.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[25];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69000-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,intel.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D2F6E77AE3
X-Rspamd-Action: no action

TDX Module updates may cause TD management operations to fail if they
occur during phases of the TD lifecycle that are sensitive to update
compatibility.

Currently, there are two update-sensitive scenarios:
 - TD build, where TD Measurement Register (TDMR) accumulates over multiple
   TDH.MEM.PAGE.ADD, TDH.MR.EXTEND and TDH.MR.FINALIZE calls.

 - TD migration, where an intermediate crypto state is saved if a state
   migration function (TDH.EXPORT.STATE.* or TDH.IMPORT.STATE.*) is
   interrupted and restored when the function is resumed.

For example, if an update races with TD build operations, the TD
Measurement Register will become incorrect, causing the TD to fail
attestation.

The TDX Module offers two solutions:

1. Avoid updates during update-sensitive times

   The host VMM can instruct TDH.SYS.SHUTDOWN to fail if any of the TDs
   are currently in any update-sensitive cases.

2. Detect incompatibility after updates

   On TDH.SYS.UPDATE, the host VMM can configure the TDX Module to detect
   actual incompatibility cases. The TDX Module will then return a special
   error to signal the incompatibility, allowing the host VMM to restart
   the update-sensitive operations.

Implement option #1 to fail updates if the feature is available. Also,
distinguish this update failure from other failures by returning -EBUSY,
which will be converted to a firmware update error code indicating that the
firmware is busy.

Options like "do nothing" or option #2 are not viable [1] because the
former allows damage to propagate to multiple, potentially unknown
components (adding significant complexity to the whole ecosystem), while
the latter may make existing KVM ioctls unstable.

Based on a reference patch by Vishal [2].

Signed-off-by: Chao Gao <chao.gao@intel.com>
Link: https://lore.kernel.org/linux-coco/aQIbM5m09G0FYTzE@google.com/ # [1]
Link: https://lore.kernel.org/linux-coco/CAGtprH_oR44Vx9Z0cfxvq5-QbyLmy_+Gn3tWm3wzHPmC1nC0eg@mail.gmail.com/ # [2]
---
 arch/x86/include/asm/tdx.h   | 13 +++++++++++--
 arch/x86/kvm/vmx/tdx_errno.h |  2 --
 arch/x86/virt/vmx/tdx/tdx.c  | 23 +++++++++++++++++++----
 3 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 0cd408f902f4..85746de7c528 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -26,15 +26,19 @@
 #define TDX_SEAMCALL_GP			(TDX_SW_ERROR | X86_TRAP_GP)
 #define TDX_SEAMCALL_UD			(TDX_SW_ERROR | X86_TRAP_UD)
 
+#define TDX_SEAMCALL_STATUS_MASK		0xFFFFFFFF00000000ULL
+
 /*
  * TDX module SEAMCALL leaf function error codes
  */
-#define TDX_SUCCESS		0ULL
-#define TDX_RND_NO_ENTROPY	0x8000020300000000ULL
+#define TDX_SUCCESS			0ULL
+#define TDX_RND_NO_ENTROPY		0x8000020300000000ULL
+#define TDX_UPDATE_COMPAT_SENSITIVE	0x8000051200000000ULL
 
 /* Bit definitions of TDX_FEATURES0 metadata field */
 #define TDX_FEATURES0_TD_PRESERVING	BIT(1)
 #define TDX_FEATURES0_NO_RBP_MOD	BIT(18)
+#define TDX_FEATURES0_UPDATE_COMPAT	BIT_ULL(47)
 #ifndef __ASSEMBLER__
 
 #include <uapi/asm/mce.h>
@@ -111,6 +115,11 @@ static inline bool tdx_supports_runtime_update(const struct tdx_sys_info *sysinf
 	return sysinfo->features.tdx_features0 & TDX_FEATURES0_TD_PRESERVING;
 }
 
+static inline bool tdx_supports_update_compatibility(const struct tdx_sys_info *sysinfo)
+{
+	return sysinfo->features.tdx_features0 & TDX_FEATURES0_UPDATE_COMPAT;
+}
+
 int tdx_guest_keyid_alloc(void);
 u32 tdx_get_nr_guest_keyids(void);
 void tdx_guest_keyid_free(unsigned int keyid);
diff --git a/arch/x86/kvm/vmx/tdx_errno.h b/arch/x86/kvm/vmx/tdx_errno.h
index 6ff4672c4181..215c00d76a94 100644
--- a/arch/x86/kvm/vmx/tdx_errno.h
+++ b/arch/x86/kvm/vmx/tdx_errno.h
@@ -4,8 +4,6 @@
 #ifndef __KVM_X86_TDX_ERRNO_H
 #define __KVM_X86_TDX_ERRNO_H
 
-#define TDX_SEAMCALL_STATUS_MASK		0xFFFFFFFF00000000ULL
-
 /*
  * TDX SEAMCALL Status Codes (returned in RAX)
  */
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 5d3f3f3eeb7d..5b562255630b 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1175,10 +1175,13 @@ int tdx_enable(void)
 }
 EXPORT_SYMBOL_FOR_KVM(tdx_enable);
 
+#define TDX_SYS_SHUTDOWN_AVOID_COMPAT_SENSITIVE BIT(16)
+
 int tdx_module_shutdown(void)
 {
 	struct tdx_module_args args = {};
-	int ret, cpu;
+	u64 ret;
+	int cpu;
 
 	/*
 	 * Shut down the TDX Module and prepare handoff data for the next
@@ -1189,9 +1192,21 @@ int tdx_module_shutdown(void)
 	 * hand-off version.
 	 */
 	args.rcx = tdx_sysinfo.handoff.module_hv;
-	ret = seamcall_prerr(TDH_SYS_SHUTDOWN, &args);
-	if (ret)
-		return ret;
+
+	if (tdx_supports_update_compatibility(&tdx_sysinfo))
+		args.rcx |= TDX_SYS_SHUTDOWN_AVOID_COMPAT_SENSITIVE;
+
+	ret = seamcall(TDH_SYS_SHUTDOWN, &args);
+
+	/*
+	 * Return -EBUSY to signal that there is one or more ongoing flows
+	 * which may not be compatible with an updated TDX module, so that
+	 * userspace can retry on this error.
+	 */
+	if ((ret & TDX_SEAMCALL_STATUS_MASK) == TDX_UPDATE_COMPAT_SENSITIVE)
+		return -EBUSY;
+	else if (ret)
+		return -EIO;
 
 	tdx_module_status = TDX_MODULE_UNINITIALIZED;
 	sysinit_done = false;
-- 
2.47.3


