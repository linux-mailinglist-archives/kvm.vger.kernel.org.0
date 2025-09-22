Return-Path: <kvm+bounces-58353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1DD0B8F073
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 07:40:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B07B171487
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 05:40:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5849722F757;
	Mon, 22 Sep 2025 05:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NXxjQtMb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3672F219A7D;
	Mon, 22 Sep 2025 05:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758519598; cv=none; b=QWFPz0//oX8Q+yhwPeWp5YYDcabVWuyxlmVn34RCOyCrKjS6uKDip6YWBHx08ONSk9czLpRPD2TjXg9uUp8xm5WEPKF+vIM6tW29fBzlNSiKQrGUY6KM2BlIN1lwyKEL1kZFI5WwKlc+ck9DW2SOEjSGsNb1P22QaL/RgBz3p6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758519598; c=relaxed/simple;
	bh=5/EqBGwMHlNOJO51uhP5Brjjwg/gaNWLL/kN6rgYfZY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EGJC4Do1Wt8NiPrXefOzENUOjCT8efrbrg4RYO9xpj0Jomuj5/LybxC8YXEzvzWtl8WvUqPRiFuMF2TOM2ZF3p1tJ2hIX4Cfaz1vzqOw7CAbWx+nCamsoVua4bA91LWaC1RCiySdDxuT+gK8ekAJwryhSMuq8t6vJDWDaSJWxWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NXxjQtMb; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758519596; x=1790055596;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5/EqBGwMHlNOJO51uhP5Brjjwg/gaNWLL/kN6rgYfZY=;
  b=NXxjQtMbg11kXDOrUVXpsc0DuY6yxkU82HP7gzTSkgY9q3u8ExJ8oTEh
   X3uPQ6gUkI1Bre3GHkjDv8cvyX7cU7Gk/zQxpvQKa3d63LkWhwYEvvaIv
   lNjVq4MFjy9mFFvWt0sf3S7dWlYKnHH+Tc/pF2Qa5VgiTI+3hx9zNdyBF
   vK0ubhlLYk/1o4OMzolSBjUnvxDqzAWXv1Xz0+9fYQssMFLdDDojH0mC1
   ydjGXhwWfDXTn6IwIL8SlSf7bahuoxrH8Uy9rR1pTCkDRLgdyUCLK0/Tz
   DQUDhkhChn2b3D9xDEfKSzQV2XuhSPpQ+hXEnLPEkchaCsiG8Cr9y+ZkG
   Q==;
X-CSE-ConnectionGUID: bdTMoHsxROSlzO2Cnnxz5Q==
X-CSE-MsgGUID: hCRKolS+TAK91dPVD36omg==
X-IronPort-AV: E=McAfee;i="6800,10657,11560"; a="72139846"
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="72139846"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2025 22:39:55 -0700
X-CSE-ConnectionGUID: B/l+egQ7St+rvr6q3xj/Zw==
X-CSE-MsgGUID: BItWCuH9QgOo/QKD1QTIOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="176295261"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2025 22:39:52 -0700
Message-ID: <fd8ebddd-adfc-4eef-bf30-20139574d0dd@linux.intel.com>
Date: Mon, 22 Sep 2025 13:39:50 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 18/51] KVM: x86: Don't emulate instructions affected
 by CET features
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-19-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250919223258.1604852-19-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/20/2025 6:32 AM, Sean Christopherson wrote:
> Don't emulate branch instructions, e.g. CALL/RET/JMP etc., that are
> affected by Shadow Stacks and/or Indirect Branch Tracking when said
> features are enabled in the guest, as fully emulating CET would require
> significant complexity for no practical benefit (KVM shouldn't need to
> emulate branch instructions on modern hosts).  Simply doing nothing isn't
> an option as that would allow a malicious entity to subvert CET
> protections via the emulator.
>
> To detect instructions that are subject to IBT or affect IBT state, use
> the existing IsBranch flag along with the source operand type to detect
> indirect branches, and the existing NearBranch flag to detect far branches
> (which can affect IBT state even if the branch itself is direct).
>
> For Shadow Stacks, explicitly track instructions that directly affect the
> current SSP, as KVM's emulator doesn't have existing flags that can be
> used to precisely detect such instructions.  Alternatively, the em_xxx()
> helpers could directly check for ShadowStack interactions, but using a
> dedicated flag is arguably easier to audit, and allows for handling both
> IBT and SHSTK in one fell swoop.
>
> Note!  On far transfers, do NOT consult the current privilege level and
> instead treat SHSTK/IBT as being enabled if they're enabled for User *or*
> Supervisor mode.  On inter-privilege level far transfers, SHSTK and IBT
> can be in play for the target privilege level, i.e. checking the current
> privilege could get a false negative, and KVM doesn't know the target
> privilege level until emulation gets under way.
>
> Note #2, FAR JMP from 64-bit mode to compatibility mode interacts with
> the current SSP, but only to ensure SSP[63:32] == 0.  Don't tag FAR JMP
> as SHSTK, which would be rather confusing and would result in FAR JMP
> being rejected unnecessarily the vast majority of the time (ignoring that
> it's unlikely to ever be emulated).  A future commit will add the #GP(0)
> check for the specific FAR JMP scenario.
>
> Note #3, task switches also modify SSP and so need to be rejected.  That
> too will be addressed in a future commit.
>
> Suggested-by: Chao Gao <chao.gao@intel.com>
> Originally-by: Yang Weijiang <weijiang.yang@intel.com>
> Cc: Mathias Krause <minipli@grsecurity.net>
> Cc: John Allen <john.allen@amd.com>
> Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

Two nits below.

> ---
>   arch/x86/kvm/emulate.c | 114 ++++++++++++++++++++++++++++++++++++-----
>   1 file changed, 100 insertions(+), 14 deletions(-)
>
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 23929151a5b8..dc0249929cbf 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -178,6 +178,7 @@
>   #define IncSP       ((u64)1 << 54)  /* SP is incremented before ModRM calc */
>   #define TwoMemOp    ((u64)1 << 55)  /* Instruction has two memory operand */
>   #define IsBranch    ((u64)1 << 56)  /* Instruction is considered a branch. */
> +#define ShadowStack ((u64)1 << 57)  /* Instruction affects Shadow Stacks. */
>   
>   #define DstXacc     (DstAccLo | SrcAccHi | SrcWrite)
>   
> @@ -660,6 +661,57 @@ static inline bool emul_is_noncanonical_address(u64 la,
>   	return !ctxt->ops->is_canonical_addr(ctxt, la, flags);
>   }
>   
> +static bool is_shstk_instruction(u64 flags)
> +{
> +	return flags & ShadowStack;
> +}
> +
> +static bool is_ibt_instruction(u64 flags)
> +{
> +	if (!(flags & IsBranch))
> +		return false;
> +
> +	/*
> +	 * Far transfers can affect IBT state even if the branch itself is
> +	 * direct, e.g. when changing privilege levels and loading a conforming
> +	 * code segment.  For simplicity, treat all far branches as affecting
> +	 * IBT.  False positives are acceptable (emulating far branches on an
> +	 * IBT-capable CPU won't happen in practice), while false negatives
> +	 * could impact guest security.
> +	 *
> +	 * Note, this also handles SYCALL and SYSENTER.

SYCALL -> SYSCALL

> +	 */
> +	if (!(flags & NearBranch))
> +		return true;
> +
> +	switch (flags & (OpMask << SrcShift)) {
> +	case SrcReg:
> +	case SrcMem:
> +	case SrcMem16:
> +	case SrcMem32:
> +		return true;
> +	case SrcMemFAddr:
> +	case SrcImmFAddr:
> +		/* Far branches should be handled above. */
> +		WARN_ON_ONCE(1);
> +		return true;
> +	case SrcNone:
> +	case SrcImm:
> +	case SrcImmByte:
> +	/*
> +	 * Note, ImmU16 is used only for the stack adjustment operand on ENTER
> +	 * and RET instructions.  ENTER isn't a branch and RET FAR is handled
> +	 * by the NearBranch check above.  RET itself isn't an indirect branch.
> +	 */
> +	case SrcImmU16:
> +		return false;
> +	default:
> +		WARN_ONCE(1, "Unexpected Src operand '%llx' on branch",
> +			  (flags & (OpMask << SrcShift)));
> +		return false;

Is it safer to reject the emulation if it has unexpected src operand?

> +	}
> +}
> +
>
[...]

