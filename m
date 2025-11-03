Return-Path: <kvm+bounces-61924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B3BB9C2E761
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 00:45:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 350591895507
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 23:45:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC631312802;
	Mon,  3 Nov 2025 23:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xo4iRbnf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA383090E4;
	Mon,  3 Nov 2025 23:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762213482; cv=none; b=kR8cJPPoiGVeZES0o8CLxfVNDShUA38jLu0JOYVHmLGeIOJ3oUTprFpODjlfqMTy/ucTFgz3Ac2mwTzOZD6RWCEldi5ZtMmRtY2SA5sCwyWw4g5se5hOgEuc9sdfXBvP8rDfN5yOFsjRmKKj6EckQHtjdrjgqVaDNPFgMo/R/Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762213482; c=relaxed/simple;
	bh=plT6RDGZ55kW9Y/hyCWee00KU8pk6DzkUuw9fe7+RZk=;
	h=Subject:To:Cc:From:Date:References:In-Reply-To:Message-Id; b=QRAqP0P3L1BLnBYrrPvzzT8IX65o7Dxh9RbyCpCQeIooy2VmurH0/r67X9MKejX+cF8a8uCBQ5/zVgYSXxEMDeYd8PhdxagoQOUhwM1Z+pklVeqb82UcRYQtWtWnD8jiWPhYygpQnltK20n6KytW3SKVb+4v78+CsAfPyBurKBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Xo4iRbnf; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762213480; x=1793749480;
  h=subject:to:cc:from:date:references:in-reply-to:
   message-id;
  bh=plT6RDGZ55kW9Y/hyCWee00KU8pk6DzkUuw9fe7+RZk=;
  b=Xo4iRbnftUeoE6ORGymoNrh6qJrO1U4rrQwNsJ1dhI8MB4h9l3VGizsX
   W0xu6N28GaWEUWM1Dx2fKKsRe02I4jd28JZDHY2ZfQbrC1JtCP1s9l5x6
   onYBNzbm1gkyw+uHL6RONUT/Fm7KU09CwL7SqcrwBIw+aLUd1okkFXUwp
   UsASBcWIh+Ozirs2NequvfzNTuuIIddbNQ0dFWa2HVRTpA4AXZztigAjY
   5OroEU4cZnlh8nO9oFp3QG40W8kW1MiD6Htl9u9cmI8MuI8AxukG5JbRu
   3/HtbTEn4wXLyV9g1T+xkDf9jXIpYzDyFUi9d0YfOF1aNpurZ30dIZkSw
   w==;
X-CSE-ConnectionGUID: zJ8Rb6ReROW0Xjz+AqO98g==
X-CSE-MsgGUID: 0nZXw3QXQKaO7y7lTv41qA==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="64396852"
X-IronPort-AV: E=Sophos;i="6.19,277,1754982000"; 
   d="scan'208";a="64396852"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 15:44:40 -0800
X-CSE-ConnectionGUID: s9zKKyDHTzqkxTSoMGGfKg==
X-CSE-MsgGUID: VSEh5AI/QHCY/TJA6M+qDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,277,1754982000"; 
   d="scan'208";a="186948466"
Received: from davehans-spike.ostc.intel.com (HELO localhost.localdomain) ([10.165.164.11])
  by orviesa007.jf.intel.com with ESMTP; 03 Nov 2025 15:44:39 -0800
Subject: [v2][PATCH 2/2] x86/virt/tdx: Fix sparse warnings from using 0 for NULL
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>, kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
From: Dave Hansen <dave.hansen@linux.intel.com>
Date: Mon, 03 Nov 2025 15:44:39 -0800
References: <20251103234435.0850400B@davehans-spike.ostc.intel.com>
In-Reply-To: <20251103234435.0850400B@davehans-spike.ostc.intel.com>
Message-Id: <20251103234439.DC8227E4@davehans-spike.ostc.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>


From: Dave Hansen <dave.hansen@linux.intel.com>

Stop using 0 for NULL.

sparse moans:

	... arch/x86/kvm/vmx/tdx.c:859:38: warning: Using plain integer as NULL pointer

for several TDX pointer initializations. While I love a good ptr=0
now and then, it's good to have quiet sparse builds.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Fixes: a50f673f25e0 ("KVM: TDX: Do TDX specific vcpu initialization")
Fixes: 8d032b683c29 ("KVM: TDX: create/destroy VM structure")
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Kirill A. Shutemov" <kas@kernel.org>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---

 b/arch/x86/kvm/vmx/tdx.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/x86/kvm/vmx/tdx.c~tdx-sparse-fix-1 arch/x86/kvm/vmx/tdx.c
--- a/arch/x86/kvm/vmx/tdx.c~tdx-sparse-fix-1	2025-11-03 15:11:28.177643833 -0800
+++ b/arch/x86/kvm/vmx/tdx.c	2025-11-03 15:11:28.185644508 -0800
@@ -856,7 +856,7 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu
 	}
 	if (tdx->vp.tdvpr_page) {
 		tdx_reclaim_control_page(tdx->vp.tdvpr_page);
-		tdx->vp.tdvpr_page = 0;
+		tdx->vp.tdvpr_page = NULL;
 		tdx->vp.tdvpr_pa = 0;
 	}
 
@@ -2642,7 +2642,7 @@ free_tdcs:
 free_tdr:
 	if (tdr_page)
 		__free_page(tdr_page);
-	kvm_tdx->td.tdr_page = 0;
+	kvm_tdx->td.tdr_page = NULL;
 
 free_hkid:
 	tdx_hkid_free(kvm_tdx);
@@ -3016,7 +3016,7 @@ free_tdcx:
 free_tdvpr:
 	if (tdx->vp.tdvpr_page)
 		__free_page(tdx->vp.tdvpr_page);
-	tdx->vp.tdvpr_page = 0;
+	tdx->vp.tdvpr_page = NULL;
 	tdx->vp.tdvpr_pa = 0;
 
 	return ret;
_

