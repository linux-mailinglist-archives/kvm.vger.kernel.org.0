Return-Path: <kvm+bounces-55586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F384B333B1
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 03:54:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C19C3442066
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 01:54:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9516A22C32D;
	Mon, 25 Aug 2025 01:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="aORlH73L"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1D31F4CA4;
	Mon, 25 Aug 2025 01:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756086843; cv=none; b=lnZ+aQDvoywpikfSksLOl0R63czF25pIVyL0jwJsNnYmH5zECtgUx+Jx3AWURtvm/9U8Qv5wsjRjzqjMUwSXVmSxiEtY55reRcXOgmSCetVERqYoxRUv2tLbLjIA5WeENOnAj3XhVg6E5tGVXdB3KBPHRPMpQgT15OeVrT3Fdhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756086843; c=relaxed/simple;
	bh=q2NRu60D+e5X8votf4lAC2BBZ7dibcQeSlMHAF4cpO4=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=U2+B3lU2BrhAHRJYIFJLWGJKnceGyUJasux+nmIeW6L2y7F9XdOQsXaRyjhMq9axlC3zQys/e5V10UgP9Z/yS1hynjRS4Tqahe8x3Gg7irmvMzkhjpgbTf82vRVuTprjwM8UkFOosIV0GLQra8mP+irqVUhjxRfWNLvt/j1eKCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=aORlH73L; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 57P1quU6226866
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Sun, 24 Aug 2025 18:52:56 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 57P1quU6226866
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025082201; t=1756086777;
	bh=T1iGU+6e3kBh5j7YDqBPqdOByA2wTCG62lZCRAK2x9g=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=aORlH73LdDZ7yZLR48yIz9lmJxl3Fwh9YnXtniRfcAg5PqtTAazxWbQEoAyzzK5kG
	 UMaIfjICq63GRLXcUSTqYbwjeBequWS1hXJEBn3M+Q1yZBNBwu/J+eN8oCmO0jfuW7
	 sponO/JREfkSoQaiFTcItyUuSiKuczIUjURE7isrPClJf7wfvt1iEajX6wb6Yz/c6n
	 QsDohieDNG89DmOjBHstU9nh+PGHVlDpu3TQFUgt9hEEYOo3meFVptlYgLpdyG+M2i
	 QzCWxqKJj1gjynatrrZqxFS0DDmDw6Ec3H8Bz3tZAIN5pW5heDIMRPakt055+M5ICG
	 0A05RoiXuPWZA==
Message-ID: <b61f8d7c-e8bf-476e-8d56-ce9660a13d02@zytor.com>
Date: Sun, 24 Aug 2025 18:52:55 -0700
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
To: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        john.allen@amd.com, mingo@redhat.com, minipli@grsecurity.net,
        mlevitsk@redhat.com, pbonzini@redhat.com, rick.p.edgecombe@intel.com,
        seanjc@google.com, tglx@linutronix.de, weijiang.yang@intel.com,
        x86@kernel.org
References: <20250821133132.72322-1-chao.gao@intel.com>
 <20250821133132.72322-6-chao.gao@intel.com>
Content-Language: en-US
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <20250821133132.72322-6-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 6b01c6e9330e..799ac76679c9 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4566,6 +4569,21 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   }
>   EXPORT_SYMBOL_GPL(kvm_get_msr_common);
>   
> +/*
> + *  Returns true if the MSR in question is managed via XSTATE, i.e. is context
> + *  switched with the rest of guest FPU state.
> + */
> +static bool is_xstate_managed_msr(u32 index)
> +{
> +	switch (index) {
> +	case MSR_IA32_U_CET:


Why MSR_IA32_S_CET is not included here?


> +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}


Is it better to do?

static bool is_xstate_managed_msr(u32 index)
{
          if (!kvm_caps.supported_xss)
                  return false;

          switch (index) {
          case MSR_IA32_U_CET:
          case MSR_IA32_S_CET:
          case MSR_IA32_PL1_SSP ... MSR_IA32_PL3_SSP:
                  return kvm_caps.supported_xss & XFEATURE_MASK_CET_USER &&
                         kvm_caps.supported_xss & XFEATURE_MASK_CET_KERNEL;
          default:
                  return false;
          }
}

And it would be obvious how to add new MSRs related to other XFEATURE bits.

Thanks!
     Xin

