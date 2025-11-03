Return-Path: <kvm+bounces-61923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 304ABC2E758
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 00:44:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A40ED18929B4
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 23:45:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C05F530C602;
	Mon,  3 Nov 2025 23:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RBo3uqyV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3332FF161;
	Mon,  3 Nov 2025 23:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762213479; cv=none; b=orN+NngmDVwG9+bbEeXSY1VWnWiXn8oi4e1ih3sqEUpfd2dc9CuiifBfqeGbLbUFOLQxo77P1f3ufvNuUgPisplQ9yTAMiDapbd3K8uKY278BB0vhz7onqH6ecGlIVVZjuZaonkrgQzbyOU/nqtg5+iNBvwgvBWxq9xF0WAytuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762213479; c=relaxed/simple;
	bh=1CX/p1kddQMlKdnXAU8Vqn2zt154h9mj7ISIqvBDh48=;
	h=Subject:To:Cc:From:Date:References:In-Reply-To:Message-Id; b=m6rx9DYGRGEqaFSwSG6ngOV9HBeb0SJ8q0QPxHLcHGSyjwZzQ5dAo4utYJl8h6Ru8OyhTWUrAl4uBcV2bCj+mooWuDkKLoAT5IoEsftMFwuT3wMY/YQyKPNzh5CHXLLuTIz8tSocauXSFjgNMZm00/Z/qZKm5T0Rbf3MteP/eRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RBo3uqyV; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762213478; x=1793749478;
  h=subject:to:cc:from:date:references:in-reply-to:
   message-id;
  bh=1CX/p1kddQMlKdnXAU8Vqn2zt154h9mj7ISIqvBDh48=;
  b=RBo3uqyVl/5gemRG+XkGyp9IJVlkB3M1rkWvr7018SK2nURiSE+HgF1R
   6IpNrqNbs6j6FZg/Bgy8kH1AnhsemnCpIFWc7lDEcIWgPrtMowGQLzkli
   ZFxeBdhN5zWWsi6n12YTdYlT+MT8c8TmANE6YYGrd467JzqrpfbHa7aE1
   WzzRdUk6K2lk+MU9zqYYDjmBhwK2fdEm9maTAgJ325FLFnAA+nj6GxZlX
   buvPj6jFI+nBtpsASchLYnej1wiGYyjgWTZwIFVVzttdjsOqZq+NTFQ/n
   FwvLzuxR1G8MrODgegQkZMU435h4syeZXMWySkrSX7gwnM4tIV8wCd8y8
   w==;
X-CSE-ConnectionGUID: A5W6SPXNQ/in6qfyVLXUPg==
X-CSE-MsgGUID: eeyUlv/lRGyhOJa8zuY/iA==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="64217936"
X-IronPort-AV: E=Sophos;i="6.19,277,1754982000"; 
   d="scan'208";a="64217936"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 15:44:37 -0800
X-CSE-ConnectionGUID: My+YqEBUS+CU6fznRMDJQA==
X-CSE-MsgGUID: U6phfDb7TdGjyq+Y+Q5C9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,277,1754982000"; 
   d="scan'208";a="187150888"
Received: from davehans-spike.ostc.intel.com (HELO localhost.localdomain) ([10.165.164.11])
  by orviesa008.jf.intel.com with ESMTP; 03 Nov 2025 15:44:37 -0800
Subject: [v2][PATCH 1/2] x86/virt/tdx: Remove __user annotation from kernel pointer
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>, kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
From: Dave Hansen <dave.hansen@linux.intel.com>
Date: Mon, 03 Nov 2025 15:44:37 -0800
References: <20251103234435.0850400B@davehans-spike.ostc.intel.com>
In-Reply-To: <20251103234435.0850400B@davehans-spike.ostc.intel.com>
Message-Id: <20251103234437.A0532420@davehans-spike.ostc.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>


From: Dave Hansen <dave.hansen@linux.intel.com>

Separate __user pointer variable declaration from kernel one.

There are two 'kvm_cpuid2' pointers involved here. There's an "input"
side: 'td_cpuid' which is a normal kernel pointer and an 'output'
side. The output here is userspace and there is an attempt at properly
annotating the variable with __user:

	struct kvm_cpuid2 __user *output, *td_cpuid;

But, alas, this is wrong. The __user in the definition applies to both
'output' and 'td_cpuid'. Sparse notices the address space mismatch and
will complain about it.

Fix it up by completely separating the two definitions so that it is
obviously correct without even having to know what the C syntax rules
even are.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Fixes: 488808e682e7 ("KVM: x86: Introduce KVM_TDX_GET_CPUID")
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

 b/arch/x86/kvm/vmx/tdx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/x86/kvm/vmx/tdx.c~tdx-sparse-fix-3 arch/x86/kvm/vmx/tdx.c
--- a/arch/x86/kvm/vmx/tdx.c~tdx-sparse-fix-3	2025-11-03 15:11:26.773525519 -0800
+++ b/arch/x86/kvm/vmx/tdx.c	2025-11-03 15:11:26.782526277 -0800
@@ -3054,7 +3054,8 @@ static int tdx_vcpu_get_cpuid_leaf(struc
 
 static int tdx_vcpu_get_cpuid(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
 {
-	struct kvm_cpuid2 __user *output, *td_cpuid;
+	struct kvm_cpuid2 __user *output;
+	struct kvm_cpuid2 *td_cpuid;
 	int r = 0, i = 0, leaf;
 	u32 level;
 
_

