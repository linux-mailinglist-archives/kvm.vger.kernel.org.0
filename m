Return-Path: <kvm+bounces-53847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C5062B1858A
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 18:12:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 60B751AA4E2C
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 16:13:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E8E028C85A;
	Fri,  1 Aug 2025 16:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="u/tLA5HC"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBDB2853E2;
	Fri,  1 Aug 2025 16:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754064754; cv=none; b=dhAGEYwmCkkRYnH+RMvOdRtQ8orLO/6s5Xdbmy9ESYVBE1ZUiU0VW4g+OGpWXbei6BqH5tSqz5yy/0ScCOJ3cT6XQUdb1FV9b7SSQCIDq7Ps2YSfIXS0WqjqPHpMT8BcoP9k9/N4DgkAqkqHxsm8TcpbHg+35cbBgIyY1715Cck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754064754; c=relaxed/simple;
	bh=FiPHx8I1Aai4fM+df6uy44aCioERZf+FndVBYOg2CfE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AvOmN4oMRDYPqC1qvJ4KnLoqFIaiS5i0KcKD+3hhMfFLzht1S04wSne6P+YwSAK66kXZjchTB4rYuRZmy0a5+xD+I4loCM1i8RxZ3HgP2mGWpb2/HEKhwsD/rBjxCrDy0tydtzvk714IktkgQ5CcRAvV9yJxIfwLpKUjOOr7X9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=u/tLA5HC; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 571GBXXN2934251
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Fri, 1 Aug 2025 09:11:33 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 571GBXXN2934251
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1754064695;
	bh=s7Hz6nFVcamPJJ7JZf+hdomwuA8kf/1WLVS3ix1E9TA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=u/tLA5HCY9Zbsy0yp4pZTGSsaKouYaZM5qAu0ws5DCDTFyI1zEqyZm/jRXip6PbBW
	 71gb+Jg514MjrdsqI9gvJCXqvCrr+yo4VqeX40X3kSE329g7M9b/3+2RZrmO/84skw
	 BPU2i2kQHf4m648Q47ZnBB8AtIqXRw40+Ck7+XH8/lmagHSCdIAjbttkY3GkHQPnQo
	 DUmrfAYsTsavDtzd7nS119gwNCQCsCw/EXz9J3V4iRRMhpornS8HAA5YbjPCEo/lTY
	 ai7LSs+PjeiIciDz8B4OZO7VSLaXYGdNZ+rSr6LotQm+eIO4T1ghj18IHOMFFFFosJ
	 wiVYH6/ESpJbQ==
Message-ID: <4133bdb5-be2c-4594-aba2-511cecb5a343@zytor.com>
Date: Fri, 1 Aug 2025 09:11:33 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 4/4] KVM: x86: Advertise support for the immediate form
 of MSR instructions
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        chao.gao@intel.com
References: <20250730174605.1614792-1-xin@zytor.com>
 <20250730174605.1614792-5-xin@zytor.com> <aIzRhGVgZXPXNwA1@google.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <aIzRhGVgZXPXNwA1@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/1/2025 7:39 AM, Sean Christopherson wrote:
> On Wed, Jul 30, 2025, Xin Li (Intel) wrote:
>> Advertise support for the immediate form of MSR instructions to userspace
>> if the instructions are supported by the underlying CPU.
> 
> SVM needs to explicitly clear the capability so that KVM doesn't over-advertise
> support if AMD ever implements X86_FEATURE_MSR_IMM.
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index ca550c4fa174..7e7821ee8ee1 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5311,8 +5311,12 @@ static __init void svm_set_cpu_caps(void)
>          /* CPUID 0x8000001F (SME/SEV features) */
>          sev_set_cpu_caps();
>   
> -       /* Don't advertise Bus Lock Detect to guest if SVM support is absent */
> +       /*
> +        * Clear capabilities that are automatically configured by common code,
> +        * but that require explicit SVM support (that isn't yet implemented).
> +        */
>          kvm_cpu_cap_clear(X86_FEATURE_BUS_LOCK_DETECT);
> +       kvm_cpu_cap_clear(X86_FEATURE_MSR_IMM);
>   }
>   
>   static __init int svm_hardware_setup(void)
> 

Nice catch!

Yes, a feature needing explicit enabling effort can't be blindly
advertised until the support on all sub-arch is ready.  I.e., I need to
disable it on non-Intel CPUs because it's only done for Intel.

