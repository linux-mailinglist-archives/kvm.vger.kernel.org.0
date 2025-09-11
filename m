Return-Path: <kvm+bounces-57291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2121AB52CF3
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 11:19:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B02C21C2062E
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 09:19:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35AA22E8DE1;
	Thu, 11 Sep 2025 09:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VR3CFPlR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB2D214A8B;
	Thu, 11 Sep 2025 09:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757582337; cv=none; b=DSTb+j/T8yYrn/609XAqbyx2vlisyV2egDwcqB/DobmFw5nCgUJTDN1HKKxLIy6CK/uwzri2LhDy5k8T0QLJa5T4219en0JWhM6CEifMDEfi3XLPgIbSzziGMo2ENK9XPF4TDAhRRAy+E4LnoxPVJ10pT/D6f405SOBjcYX5mlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757582337; c=relaxed/simple;
	bh=6IJ6y6d+p19D/hsvQumBPOT9ry6MWZVMYgvu/00cO3s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZLyQHefYKGJJnbLY+zBjNlRLUKQ/H87o9H2PWK1m+Bm2zZMJ39SrggRPV2m9/pA2IQbVDH81DTO/Om+JhhKzJ2uN1mUI6HKLMx7ST6igDk3WAVoTkxc2yBCJWcfokHVuCW3HAm3xBX+L8MXrrWvFq4mTzk0RT/STmRsFW8KGoiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VR3CFPlR; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757582336; x=1789118336;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6IJ6y6d+p19D/hsvQumBPOT9ry6MWZVMYgvu/00cO3s=;
  b=VR3CFPlRFRboi8SSOvJG7eQydRrWovJBBJs0YTXWI6RY5NFsENBT4mhd
   LoRJOex9J72oB4TyfivhPyro+eQTDSSlCCAZCeiEhAfRXWkgpKGAGeOuX
   dwWVJUKxbUPIbcIvj9f184vz6685HFnPFwlcL0ajjaFSKVyd1Kf86Jt5R
   dg9zghgg8a3AN7cRI9BNl4Mn+iDHoOPztzmTxt+B0trbG3hyUxkV74xdT
   MldlipinlvqCpC5hlLwhHhDlyRutxmtW8YO10JG80Fv1SGpT82wHw/wYJ
   CjbDi619Jqgk+SEEuq35wMVpXdKa3YFiqHRB1o77RPhDgHRcysD/znrsQ
   g==;
X-CSE-ConnectionGUID: RJijFVtoSxanEKkc4D9V1A==
X-CSE-MsgGUID: HpiQLCTqRYa6wov/lFV3hw==
X-IronPort-AV: E=McAfee;i="6800,10657,11549"; a="47480608"
X-IronPort-AV: E=Sophos;i="6.18,256,1751266800"; 
   d="scan'208";a="47480608"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2025 02:18:55 -0700
X-CSE-ConnectionGUID: VJLiGQIxRS67ep4bpbco0A==
X-CSE-MsgGUID: 7Ip+pSX1RC+vnwnEomkejA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,256,1751266800"; 
   d="scan'208";a="173209976"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2025 02:18:50 -0700
Message-ID: <8121026d-aede-4f78-a081-b81186b96e9b@intel.com>
Date: Thu, 11 Sep 2025 17:18:47 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 15/22] KVM: x86: Don't emulate instructions guarded by
 CET
To: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: acme@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, john.allen@amd.com, mingo@kernel.org, mingo@redhat.com,
 minipli@grsecurity.net, mlevitsk@redhat.com, namhyung@kernel.org,
 pbonzini@redhat.com, prsampat@amd.com, rick.p.edgecombe@intel.com,
 seanjc@google.com, shuah@kernel.org, tglx@linutronix.de,
 weijiang.yang@intel.com, x86@kernel.org, xin@zytor.com
References: <20250909093953.202028-1-chao.gao@intel.com>
 <20250909093953.202028-16-chao.gao@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250909093953.202028-16-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/9/2025 5:39 PM, Chao Gao wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
> 
> Don't emulate the branch instructions, e.g., CALL/RET/JMP etc., when CET
> is active in guest, return KVM_INTERNAL_ERROR_EMULATION to userspace to
> handle it.
> 
> KVM doesn't emulate CPU behaviors to check CET protected stuffs while
> emulating guest instructions, instead it stops emulation on detecting
> the instructions in process are CET protected. By doing so, it can avoid
> generating bogus #CP in guest and preventing CET protected execution flow
> subversion from guest side.
> 
> Suggested-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> ---
>   arch/x86/kvm/emulate.c | 46 ++++++++++++++++++++++++++++++++----------
>   1 file changed, 35 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 542d3664afa3..97a4d1e69583 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -178,6 +178,8 @@
>   #define IncSP       ((u64)1 << 54)  /* SP is incremented before ModRM calc */
>   #define TwoMemOp    ((u64)1 << 55)  /* Instruction has two memory operand */
>   #define IsBranch    ((u64)1 << 56)  /* Instruction is considered a branch. */
> +#define ShadowStack ((u64)1 << 57)  /* Instruction protected by Shadow Stack. */
> +#define IndirBrnTrk ((u64)1 << 58)  /* Instruction protected by IBT. */
>   
>   #define DstXacc     (DstAccLo | SrcAccHi | SrcWrite)
>   
> @@ -4068,9 +4070,11 @@ static const struct opcode group4[] = {
>   static const struct opcode group5[] = {
>   	F(DstMem | SrcNone | Lock,		em_inc),
>   	F(DstMem | SrcNone | Lock,		em_dec),
> -	I(SrcMem | NearBranch | IsBranch,       em_call_near_abs),
> -	I(SrcMemFAddr | ImplicitOps | IsBranch, em_call_far),
> -	I(SrcMem | NearBranch | IsBranch,       em_jmp_abs),
> +	I(SrcMem | NearBranch | IsBranch | ShadowStack | IndirBrnTrk,
> +	em_call_near_abs),
> +	I(SrcMemFAddr | ImplicitOps | IsBranch | ShadowStack | IndirBrnTrk,
> +	em_call_far),
> +	I(SrcMem | NearBranch | IsBranch | IndirBrnTrk, em_jmp_abs),
>   	I(SrcMemFAddr | ImplicitOps | IsBranch, em_jmp_far),
>   	I(SrcMem | Stack | TwoMemOp,		em_push), D(Undefined),
>   };
> @@ -4332,11 +4336,11 @@ static const struct opcode opcode_table[256] = {
>   	/* 0xC8 - 0xCF */
>   	I(Stack | SrcImmU16 | Src2ImmByte | IsBranch, em_enter),
>   	I(Stack | IsBranch, em_leave),
> -	I(ImplicitOps | SrcImmU16 | IsBranch, em_ret_far_imm),
> -	I(ImplicitOps | IsBranch, em_ret_far),
> -	D(ImplicitOps | IsBranch), DI(SrcImmByte | IsBranch, intn),
> +	I(ImplicitOps | SrcImmU16 | IsBranch | ShadowStack, em_ret_far_imm),
> +	I(ImplicitOps | IsBranch | ShadowStack, em_ret_far),
> +	D(ImplicitOps | IsBranch), DI(SrcImmByte | IsBranch | ShadowStack, intn),
>   	D(ImplicitOps | No64 | IsBranch),
> -	II(ImplicitOps | IsBranch, em_iret, iret),
> +	II(ImplicitOps | IsBranch | ShadowStack, em_iret, iret),
>   	/* 0xD0 - 0xD7 */
>   	G(Src2One | ByteOp, group2), G(Src2One, group2),
>   	G(Src2CL | ByteOp, group2), G(Src2CL, group2),
> @@ -4352,7 +4356,7 @@ static const struct opcode opcode_table[256] = {
>   	I2bvIP(SrcImmUByte | DstAcc, em_in,  in,  check_perm_in),
>   	I2bvIP(SrcAcc | DstImmUByte, em_out, out, check_perm_out),
>   	/* 0xE8 - 0xEF */
> -	I(SrcImm | NearBranch | IsBranch, em_call),
> +	I(SrcImm | NearBranch | IsBranch | ShadowStack, em_call),
>   	D(SrcImm | ImplicitOps | NearBranch | IsBranch),
>   	I(SrcImmFAddr | No64 | IsBranch, em_jmp_far),
>   	D(SrcImmByte | ImplicitOps | NearBranch | IsBranch),
> @@ -4371,7 +4375,8 @@ static const struct opcode opcode_table[256] = {
>   static const struct opcode twobyte_table[256] = {
>   	/* 0x00 - 0x0F */
>   	G(0, group6), GD(0, &group7), N, N,
> -	N, I(ImplicitOps | EmulateOnUD | IsBranch, em_syscall),
> +	N, I(ImplicitOps | EmulateOnUD | IsBranch | ShadowStack | IndirBrnTrk,
> +	em_syscall),
>   	II(ImplicitOps | Priv, em_clts, clts), N,
>   	DI(ImplicitOps | Priv, invd), DI(ImplicitOps | Priv, wbinvd), N, N,
>   	N, D(ImplicitOps | ModRM | SrcMem | NoAccess), N, N,
> @@ -4402,8 +4407,9 @@ static const struct opcode twobyte_table[256] = {
>   	IIP(ImplicitOps, em_rdtsc, rdtsc, check_rdtsc),
>   	II(ImplicitOps | Priv, em_rdmsr, rdmsr),
>   	IIP(ImplicitOps, em_rdpmc, rdpmc, check_rdpmc),
> -	I(ImplicitOps | EmulateOnUD | IsBranch, em_sysenter),
> -	I(ImplicitOps | Priv | EmulateOnUD | IsBranch, em_sysexit),
> +	I(ImplicitOps | EmulateOnUD | IsBranch | ShadowStack | IndirBrnTrk,
> +	em_sysenter),
> +	I(ImplicitOps | Priv | EmulateOnUD | IsBranch | ShadowStack, em_sysexit),
>   	N, N,
>   	N, N, N, N, N, N, N, N,
>   	/* 0x40 - 0x4F */
> @@ -4941,6 +4947,24 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
>   	if (ctxt->d == 0)
>   		return EMULATION_FAILED;
>   
> +	if (ctxt->ops->get_cr(ctxt, 4) & X86_CR4_CET) {
> +		u64 u_cet, s_cet;
> +		bool stop_em;
> +
> +		if (ctxt->ops->get_msr(ctxt, MSR_IA32_U_CET, &u_cet) ||
> +		    ctxt->ops->get_msr(ctxt, MSR_IA32_S_CET, &s_cet))
> +			return EMULATION_FAILED;
> +
> +		stop_em = ((u_cet & CET_SHSTK_EN) || (s_cet & CET_SHSTK_EN)) &&
> +			  (opcode.flags & ShadowStack);
> +
> +		stop_em |= ((u_cet & CET_ENDBR_EN) || (s_cet & CET_ENDBR_EN)) &&
> +			   (opcode.flags & IndirBrnTrk);

Why don't check CPL here? Just for simplicity?

> +		if (stop_em)
> +			return EMULATION_FAILED;
> +	}
> +
>   	ctxt->execute = opcode.u.execute;
>   
>   	if (unlikely(emulation_type & EMULTYPE_TRAP_UD) &&


