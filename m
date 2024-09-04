Return-Path: <kvm+bounces-25810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EFC4296AEF8
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 05:15:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2DEFC1C22918
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 03:15:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D143F7174F;
	Wed,  4 Sep 2024 03:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YhKMPf4Q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C3D47F4A;
	Wed,  4 Sep 2024 03:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725419674; cv=none; b=YavSEHgJC2cd9BE6qqnAXnEfASboO0yiaHw4Atx9t5c3x1YICxl2JIQIv+R7W5FcbKzHDd2HTgnQOEpe+5XKZFw8pC62sLKlfQm5x9NZzFRSMY/1Rwwlq0IoYz1IhPaQII8ZO0EMIzTKQXkYiiEpMZe9CZm9iirit3tpoAttY4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725419674; c=relaxed/simple;
	bh=ERxpuu2tmgTUyl4OT2x8+HukYN0tTSxMFn6qwuOdsfs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=D5o1pGtyLZQwUzJoLkLe2cGfVvYl9cNTP833PxNofucNJDCxZ/5NR9Reecww28M8LOlk4hNR/1CDqRkBc5knU5fWBMCpXcVjjB/fAqkOJZDXnE3zLu7lwprhId4M8sBLKXk33qPFL8oVLrFX2kDUvqRiv9nsMmyYg2RFAHOlrUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YhKMPf4Q; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725419672; x=1756955672;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ERxpuu2tmgTUyl4OT2x8+HukYN0tTSxMFn6qwuOdsfs=;
  b=YhKMPf4QKorMaRAdagWYJ2ypMIHqVTDemo48KGCQIXlLNelv/Ioh1sfj
   xaCxeNtzxulKgVcdHDQN5k58cN+I5WGPJghni2xZfaMoldKXxXrM+2bTh
   SNddX5dZisLANq228D3J57nWgIZLul/9lTfd9H3ADHZB+CaEfR4PmHtJ9
   3ybkFsORyPtZYE1NW4H5L37TjAOGX3F/dNK5mmxSclDh6/XyeeMYIP7QN
   RddKhrccap/krGAu8PYyZv5mQ5VsHEZ1xQmxnH0hg5utbcMysAI45ng46
   GKc2OnwldiE0VcXfv5IoTFfou4HCh1Ih5RrJmgJdtwsiRalCmGId+j41/
   w==;
X-CSE-ConnectionGUID: StpK510jR5SHMyAdpCajGw==
X-CSE-MsgGUID: CtwKzyvmTim4YiH+6H+yyg==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="23564644"
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="23564644"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:08:01 -0700
X-CSE-ConnectionGUID: g1k1juoLRduHQHVTuqEfIQ==
X-CSE-MsgGUID: t9WSXgTgQ9mLifELb9dgBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="65106246"
Received: from dgramcko-desk.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.221.153])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:08:00 -0700
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
	linux-kernel@vger.kernel.org
Subject: [PATCH 05/21] KVM: VMX: Teach EPT violation helper about private mem
Date: Tue,  3 Sep 2024 20:07:35 -0700
Message-Id: <20240904030751.117579-6-rick.p.edgecombe@intel.com>
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

Teach EPT violation helper to check shared mask of a GPA to find out
whether the GPA is for private memory.

When EPT violation is triggered after TD accessing a private GPA, KVM will
exit to user space if the corresponding GFN's attribute is not private.
User space will then update GFN's attribute during its memory conversion
process. After that, TD will re-access the private GPA and trigger EPT
violation again. Only with GFN's attribute matches to private, KVM will
fault in private page, map it in mirrored TDP root, and propagate changes
to private EPT to resolve the EPT violation.

Relying on GFN's attribute tracking xarray to determine if a GFN is
private, as for KVM_X86_SW_PROTECTED_VM, may lead to endless EPT
violations.

Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU part 2 v1:
 - Split from "KVM: TDX: handle ept violation/misconfig exit"
---
 arch/x86/kvm/vmx/common.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
index 78ae39b6cdcd..10aa12d45097 100644
--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -6,6 +6,12 @@
 
 #include "mmu.h"
 
+static inline bool kvm_is_private_gpa(struct kvm *kvm, gpa_t gpa)
+{
+	/* For TDX the direct mask is the shared mask. */
+	return !kvm_is_addr_direct(kvm, gpa);
+}
+
 static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
 					     unsigned long exit_qualification)
 {
@@ -28,6 +34,13 @@ static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
 		error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) ?
 			      PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
 
+	/*
+	 * Don't rely on GFN's attribute tracking xarray to prevent EPT violation
+	 * loops.
+	 */
+	if (kvm_is_private_gpa(vcpu->kvm, gpa))
+		error_code |= PFERR_PRIVATE_ACCESS;
+
 	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
 }
 
-- 
2.34.1


