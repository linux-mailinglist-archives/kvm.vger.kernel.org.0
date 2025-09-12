Return-Path: <kvm+bounces-57364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DCA57B542C7
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 08:23:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 989585A135F
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 06:23:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81DF1280A52;
	Fri, 12 Sep 2025 06:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jbhtOeQS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27C9274FDF;
	Fri, 12 Sep 2025 06:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757658228; cv=none; b=KhL+Am9FIUuw3PBs3LlqLBNmRvlkh1VTz14pErmMUeYZQLZHzN8m+Rnsxtm09vpznPMkDfLjQ2m8bkhrqc2Etivi1GwTL0q0oukJrfTb/9FGAAeL+rWWfTU7DW56fH7mdKWikwUzoc8LlD/KWFsritXiM/pp3gZpGLM0Rlu6o+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757658228; c=relaxed/simple;
	bh=vtTuYLCY6xMMGWqqui1Brk0WaPBa2lSanAkLpSPBLM8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mfprz0LfIUjWTn+Ls56iPs8n67mFSzQjjwMOy3gsYu8nTSd4XLXZfydNrmS1k1j8ecRykcEcRg8grkqSzDZCJMNaoDkow8K6eKp6PiJ/RPolBQcPG/yszOMw3sDk1EJbu0Rpob/YxjsIjaho10HeRlTY0lOuoMtIQnlyNmHqEkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jbhtOeQS; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757658227; x=1789194227;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vtTuYLCY6xMMGWqqui1Brk0WaPBa2lSanAkLpSPBLM8=;
  b=jbhtOeQSLAbzjkNvIGgOwpHlzxul0LbYmthN43VHeM83bqcwqmGZCwim
   7M7+BRVmZ2vOhm9T4sdS1TqBAfmQMwfcZtr7HHS8pnHsRTnD+ELphQVu7
   o+itowv4tmLZUOgMDMhX/nmQYMEHkkJmbtcGP/ALnkGr6IhRGzXoarS9y
   TqMyc8NQq83c4F8pBM9NlUVi/xTA8qK6oXYHvd1qBOV3vOtYIR5EwF6Xw
   PcQpyrIybVxUaIuC2Zv15b4K/MBw916V3JhIFGa0Zig6fWqOqAWo/ZtwJ
   HCaNf3LbW6V7KXMfTa3SIy4+JQCOj/K6/rEreh+swkcFT1x/7+wtshx2C
   Q==;
X-CSE-ConnectionGUID: ib37DYjYTn6DiydTeVJmrw==
X-CSE-MsgGUID: XZHOzaCZQya2woea+pNm+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11550"; a="59229560"
X-IronPort-AV: E=Sophos;i="6.18,259,1751266800"; 
   d="scan'208";a="59229560"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2025 23:23:46 -0700
X-CSE-ConnectionGUID: vlsFmkCJTRGluq4euorSlA==
X-CSE-MsgGUID: 31U0xWdhShyI+lApXzd3Sw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,259,1751266800"; 
   d="scan'208";a="174278154"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2025 23:23:41 -0700
Message-ID: <ac7eb055-a3a2-479c-8d21-4ebc262be93b@intel.com>
Date: Fri, 12 Sep 2025 14:23:38 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 15/22] KVM: x86: Don't emulate instructions guarded by
 CET
To: Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, acme@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 john.allen@amd.com, mingo@kernel.org, mingo@redhat.com,
 minipli@grsecurity.net, mlevitsk@redhat.com, namhyung@kernel.org,
 pbonzini@redhat.com, prsampat@amd.com, rick.p.edgecombe@intel.com,
 seanjc@google.com, shuah@kernel.org, tglx@linutronix.de,
 weijiang.yang@intel.com, x86@kernel.org, xin@zytor.com
References: <20250909093953.202028-1-chao.gao@intel.com>
 <20250909093953.202028-16-chao.gao@intel.com>
 <8121026d-aede-4f78-a081-b81186b96e9b@intel.com> <aMKniY+GguBPe8tK@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aMKniY+GguBPe8tK@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/11/2025 6:42 PM, Chao Gao wrote:
>>> @@ -4941,6 +4947,24 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
>>>    	if (ctxt->d == 0)
>>>    		return EMULATION_FAILED;
>>> +	if (ctxt->ops->get_cr(ctxt, 4) & X86_CR4_CET) {
>>> +		u64 u_cet, s_cet;
>>> +		bool stop_em;
>>> +
>>> +		if (ctxt->ops->get_msr(ctxt, MSR_IA32_U_CET, &u_cet) ||
>>> +		    ctxt->ops->get_msr(ctxt, MSR_IA32_S_CET, &s_cet))
>>> +			return EMULATION_FAILED;
>>> +
>>> +		stop_em = ((u_cet & CET_SHSTK_EN) || (s_cet & CET_SHSTK_EN)) &&
>>> +			  (opcode.flags & ShadowStack);
>>> +
>>> +		stop_em |= ((u_cet & CET_ENDBR_EN) || (s_cet & CET_ENDBR_EN)) &&
>>> +			   (opcode.flags & IndirBrnTrk);
>>
>> Why don't check CPL here? Just for simplicity?
> 
> I think so. This is a corner case and we don't want to make it very precise
> (and thus complex). The reason is that no one had a strong opinion on whether
> to do the CPL check or not. I asked the same question before [*], but I don't
> have a strong opinion on this either.

I'm OK with it.

But I think we should at least mention it in the change log. So people 
will know that CPL check is skipped intentionally and maintainers are OK 
with it so the patch was merged, when they dig the history.

> [*]: https://lore.kernel.org/kvm/ZaSQn7RCRTaBK1bc@chao-email/


