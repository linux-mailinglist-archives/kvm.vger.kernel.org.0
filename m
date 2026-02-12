Return-Path: <kvm+bounces-70986-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MB38EFvnjWlE8gAAu9opvQ
	(envelope-from <kvm+bounces-70986-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:44:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E66412E6AF
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:44:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 22080304FE0F
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 14:38:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6740D366553;
	Thu, 12 Feb 2026 14:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oBpzrgiU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3098A35DCF4;
	Thu, 12 Feb 2026 14:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770906995; cv=none; b=Zspvd39LDYvk02DVPtAuCpHUWWXBeaHKeWZNXErW9GK0BDMf/21ZLCUXX8Oqfyss9x3lHsjnQR8roXm5e/rrfqgxASXqrwkBqQBw1DsQBppNP47fmUr5mnygdendEEV3tIAAFTWRpKjJFU8JDl8T+2XLpFrOSAPzgIjcnNBh/38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770906995; c=relaxed/simple;
	bh=U741iM/p2Txpdybf3Xz1G0vtdfwN3sCq59uW6LiqzVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lP1stvPJh9fskFgOWEavFgdOFSuRBmRHdxn9JQE9shifWe9GvvEmkxibKRDmjMzsq02iWae5yk7nsaE20olCHv9HyCKvihlmJuHrJwVC3rV/DPYbqBRgbB9J/R/d+KYUJGwsScXNCl009SEvZI6BiPK5OchDp80FyTKexHVCnjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oBpzrgiU; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770906994; x=1802442994;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U741iM/p2Txpdybf3Xz1G0vtdfwN3sCq59uW6LiqzVg=;
  b=oBpzrgiU7KLLA+uhpNHrym/glZ31QMmiUlUiVvUfZff8dy4cnf7Qj9zJ
   Scluxxa5zHRACGT/NPnCsJHOd823ptwjdy+Y0sK5OqB6CPBJ52Wap/8v4
   9/Ese0bSuwgrEEinsJ0PejsGYBr9d3wOu+uwKftirW7iQVMjVBkZZis+K
   Njnl1wsuysEXbModbfFmQ9Ya2gb5Zfm4NyhALa2IcKA6YKgpfol5jlzpP
   m9/8NMXKNljeFwbD8TbrfCzbJyk+MO4BYPY4cmhL8NwT3lm7NYemaLdZV
   PRfZ7hsYLbrZiMOUP2Nl5VWB2J5xa5lFQnUq4dzI6VSLjCHU76PWgZV67
   g==;
X-CSE-ConnectionGUID: NPFnF6DbSc+ohpXk/T/YuQ==
X-CSE-MsgGUID: RdI2o+URRrWWIVwPXPCD9g==
X-IronPort-AV: E=McAfee;i="6800,10657,11699"; a="89662938"
X-IronPort-AV: E=Sophos;i="6.21,286,1763452800"; 
   d="scan'208";a="89662938"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 06:36:33 -0800
X-CSE-ConnectionGUID: A/29T/a1SU+x16f7OzQgrw==
X-CSE-MsgGUID: n4isDzdzS2SzNckGiMyvFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,286,1763452800"; 
   d="scan'208";a="211428318"
Received: from 984fee019967.jf.intel.com ([10.23.153.244])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 06:36:32 -0800
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
Subject: [PATCH v4 24/24] [NOT-FOR-REVIEW] x86/virt/seamldr: Save and restore current VMCS
Date: Thu, 12 Feb 2026 06:35:27 -0800
Message-ID: <20260212143606.534586-25-chao.gao@intel.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
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
	TAGGED_FROM(0.00)[bounces-70986-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: 9E66412E6AF
X-Rspamd-Action: no action

P-SEAMLDR calls clobber the current VMCS as documented in Intel® Trust
Domain CPU Architectural Extensions (May 2021 edition) Chapter 2.3 [1]:

  SEAMRET from the P-SEAMLDR clears the current VMCS structure pointed
  to by the current-VMCS pointer. A VMM that invokes the P-SEAMLDR using
  SEAMCALL must reload the current-VMCS, if required, using the VMPTRLD
  instruction.

Save and restore the current VMCS using VMPTRST and VMPTRLD instructions
to avoid breaking KVM.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
This patch is needed for testing until microcode is updated to preserve
the current VMCS across P-SEAMLDR calls. Otherwise, if some normal VMs
are running before TDX Module updates, vmread/vmwrite errors may occur
immediately after updates.
---
 arch/x86/include/asm/special_insns.h | 22 ++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/seamldr.c      | 16 +++++++++++++++-
 2 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index 46aa2c9c1bda..a3e9a139b669 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -303,6 +303,28 @@ static __always_inline void tile_release(void)
 	asm volatile(".byte 0xc4, 0xe2, 0x78, 0x49, 0xc0");
 }
 
+static inline int vmptrst(u64 *vmcs_pa)
+{
+	asm goto("1: vmptrst %0\n\t"
+		 _ASM_EXTABLE(1b, %l[error])
+		 : "=m" (*vmcs_pa) : : "cc" : error);
+
+	return 0;
+error:
+	return -EIO;
+}
+
+static inline int vmptrld(u64 vmcs_pa)
+{
+	asm goto("1: vmptrld %0\n\t"
+		 "jna %l[error]\n\t"
+		 _ASM_EXTABLE(1b, %l[error])
+		 : : "m" (vmcs_pa) : "cc" : error);
+	return 0;
+error:
+	return -EIO;
+}
+
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_X86_SPECIAL_INSNS_H */
diff --git a/arch/x86/virt/vmx/tdx/seamldr.c b/arch/x86/virt/vmx/tdx/seamldr.c
index 3f37cc6c68ff..02695307b8a0 100644
--- a/arch/x86/virt/vmx/tdx/seamldr.c
+++ b/arch/x86/virt/vmx/tdx/seamldr.c
@@ -16,6 +16,7 @@
 #include <linux/stop_machine.h>
 
 #include <asm/seamldr.h>
+#include <asm/special_insns.h>
 
 #include "seamcall_internal.h"
 #include "tdx.h"
@@ -59,12 +60,25 @@ static DEFINE_RAW_SPINLOCK(seamldr_lock);
 
 static int seamldr_call(u64 fn, struct tdx_module_args *args)
 {
+	u64 current_vmcs = -1ULL;
+	int ret;
+
 	/*
 	 * Serialize P-SEAMLDR calls and disable interrupts as the calls
 	 * can be made from IRQ context.
 	 */
 	guard(raw_spinlock_irqsave)(&seamldr_lock);
-	return seamcall_prerr(fn, args);
+
+	/*
+	 * P-SEAMLDR calls clobber the current VMCS. Save and restore it.
+	 * -1 indicates invalid VMCS and no restoration is needed.
+	 */
+	WARN_ON_ONCE(vmptrst(&current_vmcs));
+	ret = seamcall_prerr(fn, args);
+	if (current_vmcs != -1ULL)
+		WARN_ON_ONCE(vmptrld(current_vmcs));
+
+	return ret;
 }
 
 int seamldr_get_info(struct seamldr_info *seamldr_info)
-- 
2.47.3


