Return-Path: <kvm+bounces-55730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2635B354D9
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 08:56:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A640F244A91
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 06:56:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 691E22F6160;
	Tue, 26 Aug 2025 06:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="TXu8NwlR"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1A8502BE;
	Tue, 26 Aug 2025 06:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756191354; cv=none; b=GsDpASFkNhQOAKXWSpi1LRPBhkc/xT0CSryhE6P7JmJxnmZTCd5AFBqZdMt7V24Tcj+ezavVQ3sm5Go835uCyZsb4KPbXQXFiy+JU6lduqo/LESaTByaK88PCJk9lWAl7tJ1EgIOLLWx38xU/M12e7diJ7auo3cRuDlSdAc10ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756191354; c=relaxed/simple;
	bh=AbFQ84Opa8P2yoCJhAEc+dOQF1w2tEkJ3FXtdJJOOQc=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=RK5xlBJvOTEBwdmhQlDU68V+e/6Q+D4J4adE+4D2rC5CsA+JMuk/6fh0IrL/WRAd8wd6r8m639BfxOu41qL3IOkpb90mujPNTHdpvgSFJLyiuRKGswwWSYpsebI92AXTemOVaeZCX6wzfMahGVnhvS+Butf0XiKhYM8gFeQYfnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=TXu8NwlR; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 57Q6slRZ947466
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 25 Aug 2025 23:54:48 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 57Q6slRZ947466
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025082201; t=1756191292;
	bh=31hcUTjsqXzWZTOGdQDWB0hfth61bxathytRbPMfT9o=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=TXu8NwlRDu8fDbPcGjqill3BNsHgX0GvUITPYr9IBoHH3GCjfMG7577uDy1GKqRSz
	 CS/PEXGldgwejkYOy9WWW9FY4RN3+rytjnTMM2BCv+n6fI/vT6jtINChJ9cYv9FZ1U
	 rTYgdNC2504ShZyWQsoFCIzuAmI7iD+I33HtIroxOjnUymFIKUGH4n22PbuJmS6X2A
	 PVW3daX2eaqMaVJWJ0mLbTJgOU7UQMuL0LZCQ+FOgorfCgtucKKINyDe38/Ji8Ji4D
	 5UJLjnqKnHzX0ueHBkY7xkagO426UpcGYNzrYHxqA8aiHBVasEmblnP4Km78MlXOOM
	 rKLBIPycWoqEA==
Message-ID: <2ed04dff-e778-46c6-bd5f-51295763af06@zytor.com>
Date: Mon, 25 Aug 2025 23:54:46 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Xin Li <xin@zytor.com>
Subject: Re: [PATCH v13 05/21] KVM: x86: Load guest FPU state when access
 XSAVE-managed MSRs
To: Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, john.allen@amd.com,
        mingo@redhat.com, minipli@grsecurity.net, mlevitsk@redhat.com,
        pbonzini@redhat.com, rick.p.edgecombe@intel.com, seanjc@google.com,
        tglx@linutronix.de, weijiang.yang@intel.com, x86@kernel.org
References: <20250821133132.72322-1-chao.gao@intel.com>
 <20250821133132.72322-6-chao.gao@intel.com>
 <b61f8d7c-e8bf-476e-8d56-ce9660a13d02@zytor.com> <aKvP2AHKYeQCPm0x@intel.com>
Content-Language: en-US
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <aKvP2AHKYeQCPm0x@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/24/2025 7:55 PM, Chao Gao wrote:
>> static bool is_xstate_managed_msr(u32 index)
>> {
>>          if (!kvm_caps.supported_xss)
>>                  return false;
>>
>>          switch (index) {
>>          case MSR_IA32_U_CET:
>>          case MSR_IA32_S_CET:
>>          case MSR_IA32_PL1_SSP ... MSR_IA32_PL3_SSP:
>>                  return kvm_caps.supported_xss & XFEATURE_MASK_CET_USER &&
>>                         kvm_caps.supported_xss & XFEATURE_MASK_CET_KERNEL;
>>          default:
>>                  return false;
> This will duplicate checks in other functions. I slightly prefer to keep this
> function super simple and do all capability checks in __kvm_{set,get}_msr()
> or kvm_emulate_msr_{write,read}.
> 
>>          }
>> }
>>
>> And it would be obvious how to add new MSRs related to other XFEATURE bits.
> Just return true for all those MSRs, regardless of host capabilities. If
> kvm_caps doesn't support them, those MSRs are not advertised to userspace
> either (see kvm_probe_msr_to_save()). Loading or putting the guest FPU when
> userspace attempts to read/write those unsupported MSRs shouldn't cause any
> performance issues, as userspace is unlikely to access them in hot paths.

There is no problem as of now, because there are only two CET related bits
set in KVM_SUPPORTED_XSS.  So if !CET, the two bits are cleared thus
kvm_caps.supported_xss is 0, and kvm_load_guest_fpu() is never executed in
__msr_io().

However after any new bit is added to KVM_SUPPORTED_XSS in future, if !CET,
kvm_caps.supported_xss could be non-zero.  There should still be no problem
because we don't expect any access to CET MSRs.

The trouble comes with MSR_IA32_PL0_SSP when FRED and !CET, because it will
be accessed even !CET.  And we need to have to do the following:

static bool is_xstate_managed_msr(u32 index)
{
	switch (index) {
	case MSR_IA32_U_CET:
	case MSR_IA32_PL1_SSP ... MSR_IA32_PL3_SSP:
		return true;
	case MSR_IA32_PL0_SSP:
		return kvm_caps.supported_xss & XFEATURE_MASK_CET_USER &&
		       kvm_caps.supported_xss & XFEATURE_MASK_CET_KERNEL;
	default:
		return false;
	}
}

Then it makes more sense to handle all CET MSRs consistently.

Thanks!
      Xin


