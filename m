Return-Path: <kvm+bounces-31648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DFEEC9C5FFA
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 19:12:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A35DA28469B
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 18:12:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56C7A216E07;
	Tue, 12 Nov 2024 18:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="AP13VNhF"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78BFC216449;
	Tue, 12 Nov 2024 18:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731435058; cv=none; b=YG1P+5znpwLasTaymlIUL21/e2uIS2B+UMnYfEJdg3NxnxPPc/7BLR6BiEQpREj+qNc4XVvmg1dlA1FeUMSMoFk0ZbsFVc4wSfzo993HOkq376jKNKrqNZaN2jCq+OneVEFVKO1Vx8iVQIFIpvlj5y02FvlJqBuLFwQCgQT+sUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731435058; c=relaxed/simple;
	bh=LEQ3H94W9G+4p1zBDNvVrlmIym5MwkCk8vk1Mz9frXw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fP+uuqBUYNvHGBSDFZU5EB5yJHXSjEJOTRreH1V+s04chEHojV1uhMHqTseRmiXI6AXSwHkdB+XmRZ5lMO0iO85BlEXi6JQUdETCNFEFLHNjlQgU7l+JKTXOSQcAkhwsyRbr3E4oMGjGAWCJjJLvIa34PRHGa9HOfdW7ZERHoMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=AP13VNhF; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [172.27.3.244] ([76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 4ACIAE083429129
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 12 Nov 2024 10:10:14 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 4ACIAE083429129
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024101701; t=1731435015;
	bh=6Kx7RtEhxS9ERAWk+qY7jBAYM7lxFcKMRDRKdoGvtOc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AP13VNhFxKlW2B9mIEBBxfwn4PhNlLH+AqHj29XlAWqwf/a37gjL1uL9DkZHwdkqZ
	 lBvEdDhGfXoJgNofNIf7KT2Q1YPqMjto5ISr2VFVvt8+ia3eUY+VE8WS0RHe2Ej0OC
	 P6nV81LRCQ5OJ7CSyxwIJGQM/5fyZXB9WNx3CbBRPjPgoTeb1rLovKWzt7mt1yhzHi
	 Wa2gjYRNbTfL/Sv9nMcpmvm58+FG72Iv1DpkOyWVd5F++r5206Fuausdkkjb8NN0hL
	 rpnNl0Yn/UICTfZFhxK9ybCUVjuHoTCElUlWVbga4QGHPzy66gKSZOBpuI4PCYYZEy
	 LdiZ5prEbc4cQ==
Message-ID: <8c70586e-2513-42d4-b2cd-476caa416c16@zytor.com>
Date: Tue, 12 Nov 2024 10:10:14 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86: kvm: add back X86_LOCAL_APIC dependency
To: Sean Christopherson <seanjc@google.com>, Arnd Bergmann <arnd@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner
 <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, kernel test robot <lkp@intel.com>,
        Michael Roth <michael.roth@amd.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20241112065415.3974321-1-arnd@kernel.org>
 <ZzOY-AlBgouiIbDB@google.com>
Content-Language: en-US
From: "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <ZzOY-AlBgouiIbDB@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/12/24 10:05, Sean Christopherson wrote:
>>
>> Fixes: ea4290d77bda ("KVM: x86: leave kvm.ko out of the build if no vendor module is requested")
>> Reported-by: kernel test robot <lkp@intel.com>
>> Closes: https://lore.kernel.org/oe-kbuild-all/202410060426.e9Xsnkvi-lkp@intel.com/
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> ---
>> Question: is there actually any point in keeping KVM support for 32-bit host
>> processors?
> 
> Nope.  We need _a_ 32-bit KVM build to run as a nested (L1) hypervisor for testing
> purposes, but AFAIK there's zero need to keep 32-bit KVM up-to-date.
> 

What do you mean here? Running an old kernel with the 32-bit KVM in a VM 
for testing the L0 hypervisor?

	-hpa


