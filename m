Return-Path: <kvm+bounces-25817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DCC796AF07
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 05:17:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE6B41F2575A
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 03:17:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12E5F126C0A;
	Wed,  4 Sep 2024 03:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TlFkq+FH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EAC68121B;
	Wed,  4 Sep 2024 03:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725419679; cv=none; b=gdWYwy81WW2KnARvNM5NyjffPqhrGsrCMdOH9rdfciGOvEYImtCkEDQTmbzo/mblDvcBa4ih2dNxjn8xgLEFv12jVejZCEasxxTmAJfg6ZAuU/s3iYDPOX/VbHA+GGdLLjjzxky0U8p3XEP3zvwiWlFBwwjdxLCmRkddYAvy5vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725419679; c=relaxed/simple;
	bh=xW7XPRQeiRKx4GXYs8rvZQUSXXmZ+f+w5kAxqysOs6Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YOwppWv0Z/H4WnrG9Upf7SjiHwqDILZ6MSkD6dUPjdyoxG/Gtn4gOdjwIHsbf4Py3ZfJjj1N3eiRRWxAa7AmvJGMESjg6geV8sr/SiGTdLWYkKXuxrsawYwRmoQSre+i5qpJEcZvu2yJCVEjc3lfwI2aPxgHPyQXmqApFLGX540=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TlFkq+FH; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725419677; x=1756955677;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xW7XPRQeiRKx4GXYs8rvZQUSXXmZ+f+w5kAxqysOs6Q=;
  b=TlFkq+FHf7vXNykzvKNxNZA4JE3wsQvMbknwnlYAZ2mX5COYc5g52ovS
   +ZsMC7tw4hGeYL257RNy3Lr0rmQsIY2ztmvRsS7ySmDkr0SIp6kd2vpIC
   blqLhW30txzSMBC8r+EuCkC0A8BJj2IM6ZtypvUQUKqI8dNaM/4ghEMen
   y3xHyccegAYvkh0f/EiPNkrwh6TaG2G4f5Wbn24I1tDhLd4nHQE8E3yPO
   Llj9ppvANPUpVNEcPZRm6wiC/RH6fOKXX2ejYnj+Suu+NuWtc0Rmd1Y8B
   Fe4c4BfqwWSO4QFllb3X5o6q36+KOiwM7NHCqfg3RaCPnZjjxaml+ij2h
   g==;
X-CSE-ConnectionGUID: qBWwsdF7ROSIZYkvVo8DJA==
X-CSE-MsgGUID: XC4ipXY7Sf+t7LQ10ig2OQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="23564673"
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="23564673"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:08:08 -0700
X-CSE-ConnectionGUID: OjmE+G0MTdSlc73sQO8Pxg==
X-CSE-MsgGUID: AfRUoVkYSUWoU4oyAwjKxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="65106279"
Received: from dgramcko-desk.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.221.153])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:08:05 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	dmatlack@google.com,
	isaku.yamahata@gmail.com,
	yan.y.zhao@intel.com,
	nik.borisov@suse.com,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org,
	Yuan Yao <yuan.yao@intel.com>
Subject: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with operand SEPT
Date: Tue,  3 Sep 2024 20:07:39 -0700
Message-Id: <20240904030751.117579-10-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yuan Yao <yuan.yao@intel.com>

TDX module internally uses locks to protect internal resources.  It tries
to acquire the locks.  If it fails to obtain the lock, it returns
TDX_OPERAND_BUSY error without spin because its execution time limitation.

TDX SEAMCALL API reference describes what resources are used.  It's known
which TDX SEAMCALL can cause contention with which resources.  VMM can
avoid contention inside the TDX module by avoiding contentious TDX SEAMCALL
with, for example, spinlock.  Because OS knows better its process
scheduling and its scalability, a lock at OS/VMM layer would work better
than simply retrying TDX SEAMCALLs.

TDH.MEM.* API except for TDH.MEM.TRACK operates on a secure EPT tree and
the TDX module internally tries to acquire the lock of the secure EPT tree.
They return TDX_OPERAND_BUSY | TDX_OPERAND_ID_SEPT in case of failure to
get the lock.  TDX KVM allows sept callbacks to return error so that TDP
MMU layer can retry.

Retry TDX TDH.MEM.* API on the error because the error is a rare event
caused by zero-step attack mitigation.

Signed-off-by: Yuan Yao <yuan.yao@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU part 2 v1:
 - Updates from seamcall overhaul (Kai)

v19:
 - fix typo TDG.VP.ENTER => TDH.VP.ENTER,
   TDX_OPRRAN_BUSY => TDX_OPERAND_BUSY
 - drop the description on TDH.VP.ENTER as this patch doesn't touch
   TDH.VP.ENTER
---
 arch/x86/kvm/vmx/tdx_ops.h | 48 ++++++++++++++++++++++++++++++++------
 1 file changed, 41 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
index 0363d8544f42..8ca3e252a6ed 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -31,6 +31,40 @@
 #define pr_tdx_error_3(__fn, __err, __rcx, __rdx, __r8)	\
 	pr_tdx_error_N(__fn, __err, "rcx 0x%llx, rdx 0x%llx, r8 0x%llx\n", __rcx, __rdx, __r8)
 
+/*
+ * TDX module acquires its internal lock for resources.  It doesn't spin to get
+ * locks because of its restrictions of allowed execution time.  Instead, it
+ * returns TDX_OPERAND_BUSY with an operand id.
+ *
+ * Multiple VCPUs can operate on SEPT.  Also with zero-step attack mitigation,
+ * TDH.VP.ENTER may rarely acquire SEPT lock and release it when zero-step
+ * attack is suspected.  It results in TDX_OPERAND_BUSY | TDX_OPERAND_ID_SEPT
+ * with TDH.MEM.* operation.  Note: TDH.MEM.TRACK is an exception.
+ *
+ * Because TDP MMU uses read lock for scalability, spin lock around SEAMCALL
+ * spoils TDP MMU effort.  Retry several times with the assumption that SEPT
+ * lock contention is rare.  But don't loop forever to avoid lockup.  Let TDP
+ * MMU retry.
+ */
+#define TDX_ERROR_SEPT_BUSY    (TDX_OPERAND_BUSY | TDX_OPERAND_ID_SEPT)
+
+static inline u64 tdx_seamcall_sept(u64 op, struct tdx_module_args *in)
+{
+#define SEAMCALL_RETRY_MAX     16
+	struct tdx_module_args args_in;
+	int retry = SEAMCALL_RETRY_MAX;
+	u64 ret;
+
+	do {
+		args_in = *in;
+		ret = seamcall_ret(op, in);
+	} while (ret == TDX_ERROR_SEPT_BUSY && retry-- > 0);
+
+	*in = args_in;
+
+	return ret;
+}
+
 static inline u64 tdh_mng_addcx(struct kvm_tdx *kvm_tdx, hpa_t addr)
 {
 	struct tdx_module_args in = {
@@ -55,7 +89,7 @@ static inline u64 tdh_mem_page_add(struct kvm_tdx *kvm_tdx, gpa_t gpa,
 	u64 ret;
 
 	clflush_cache_range(__va(hpa), PAGE_SIZE);
-	ret = seamcall_ret(TDH_MEM_PAGE_ADD, &in);
+	ret = tdx_seamcall_sept(TDH_MEM_PAGE_ADD, &in);
 
 	*rcx = in.rcx;
 	*rdx = in.rdx;
@@ -76,7 +110,7 @@ static inline u64 tdh_mem_sept_add(struct kvm_tdx *kvm_tdx, gpa_t gpa,
 
 	clflush_cache_range(__va(page), PAGE_SIZE);
 
-	ret = seamcall_ret(TDH_MEM_SEPT_ADD, &in);
+	ret = tdx_seamcall_sept(TDH_MEM_SEPT_ADD, &in);
 
 	*rcx = in.rcx;
 	*rdx = in.rdx;
@@ -93,7 +127,7 @@ static inline u64 tdh_mem_sept_remove(struct kvm_tdx *kvm_tdx, gpa_t gpa,
 	};
 	u64 ret;
 
-	ret = seamcall_ret(TDH_MEM_SEPT_REMOVE, &in);
+	ret = tdx_seamcall_sept(TDH_MEM_SEPT_REMOVE, &in);
 
 	*rcx = in.rcx;
 	*rdx = in.rdx;
@@ -123,7 +157,7 @@ static inline u64 tdh_mem_page_aug(struct kvm_tdx *kvm_tdx, gpa_t gpa, hpa_t hpa
 	u64 ret;
 
 	clflush_cache_range(__va(hpa), PAGE_SIZE);
-	ret = seamcall_ret(TDH_MEM_PAGE_AUG, &in);
+	ret = tdx_seamcall_sept(TDH_MEM_PAGE_AUG, &in);
 
 	*rcx = in.rcx;
 	*rdx = in.rdx;
@@ -140,7 +174,7 @@ static inline u64 tdh_mem_range_block(struct kvm_tdx *kvm_tdx, gpa_t gpa,
 	};
 	u64 ret;
 
-	ret = seamcall_ret(TDH_MEM_RANGE_BLOCK, &in);
+	ret = tdx_seamcall_sept(TDH_MEM_RANGE_BLOCK, &in);
 
 	*rcx = in.rcx;
 	*rdx = in.rdx;
@@ -335,7 +369,7 @@ static inline u64 tdh_mem_page_remove(struct kvm_tdx *kvm_tdx, gpa_t gpa,
 	};
 	u64 ret;
 
-	ret = seamcall_ret(TDH_MEM_PAGE_REMOVE, &in);
+	ret = tdx_seamcall_sept(TDH_MEM_PAGE_REMOVE, &in);
 
 	*rcx = in.rcx;
 	*rdx = in.rdx;
@@ -361,7 +395,7 @@ static inline u64 tdh_mem_range_unblock(struct kvm_tdx *kvm_tdx, gpa_t gpa,
 	};
 	u64 ret;
 
-	ret = seamcall_ret(TDH_MEM_RANGE_UNBLOCK, &in);
+	ret = tdx_seamcall_sept(TDH_MEM_RANGE_UNBLOCK, &in);
 
 	*rcx = in.rcx;
 	*rdx = in.rdx;
-- 
2.34.1


