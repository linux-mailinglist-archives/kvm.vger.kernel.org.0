Return-Path: <kvm+bounces-43911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E1A8A98577
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 11:29:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8003617A028
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 09:29:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B18425CC53;
	Wed, 23 Apr 2025 09:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="UmIumy9c"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD392701B5;
	Wed, 23 Apr 2025 09:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745400528; cv=none; b=pORcwe7OPLEKwzN0vQimRV/3TAax5zfJC+ISP2m6LhbiW35rlaQ3PRBFlUX9wU5IHR5p9khUKWjyj7tgZh9Bp7i0FmGiwsteZJ77R08U6PQfzEQH9qw0oK43e079VSfUmBi2ZuzEZxGLXUm6FPVdHxMjQxEmOeuXi1G8AdQvjD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745400528; c=relaxed/simple;
	bh=+EYVuYrtu0aOqe3lbGO7b9PG5zqWh+Kau/58q5Ikx7w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SiqJAvCjPomS4sFbbZsaZrXnie+44uUS1W9DkZ8drnHCb3FDPGo7J+hd443HMoXUHPKJVrkH/DAxRQyf0/Ke/WIbRIXKIeUS4clA6JXMrzUTfs8mYfzqNsZ2UOFpaf1SSkbhgYBvGDiYKtX0vb5GkPpFu52sFWHbRS4a4fPxQvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=UmIumy9c; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53N9RlMD3219913
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Wed, 23 Apr 2025 02:27:48 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53N9RlMD3219913
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745400470;
	bh=ljTCYrwFB4jWmVUKcnZoEtS1ENJ4as2xI12Y2XbkMGU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UmIumy9ccUWtp5ZpbFY6Ho9GgYRlVSRySL3D0+L6jUnzCuWo+VAXnfIYm+WcNWHcr
	 3vdBJ+wwDthlqUfiIoaN3DvHPiYn4gb/+Mbw6citZ1Nn3xuBxFNqKSFdRNvSlmfDHg
	 sgDUE/YJgzJJyaLCEhkxOt4S6E7bN3HrTuYY85xE4DOyVvo6Ap2JfPnfbPyl+GWU88
	 BCLMSAjhGktSUoCdwdyy/ZS83Z3KwNGZuWXVpY05BNcjcn6RiyoIM0nH70HIaJUZTW
	 sxPrQvxiLK2+ljs3l/mZq4cz6GbUS+eJfVvDu2BEsKu2EVOjGnH6pzErQiG0qnjLGr
	 yA9/DCpyDaO8g==
Message-ID: <7527f09c-7163-4276-b9a4-edac6c8217ae@zytor.com>
Date: Wed, 23 Apr 2025 02:27:46 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 10/34] x86/msr: Convert __rdmsr() uses to
 native_rdmsrq() uses
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux.dev, linux-pm@vger.kernel.org,
        linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org,
        netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        acme@kernel.org, jgross@suse.com, andrew.cooper3@citrix.com,
        peterz@infradead.org, namhyung@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
        wei.liu@kernel.org, ajay.kaher@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, luto@kernel.org,
        boris.ostrovsky@oracle.com, kys@microsoft.com, haiyangz@microsoft.com,
        decui@microsoft.com
References: <20250422082216.1954310-1-xin@zytor.com>
 <20250422082216.1954310-11-xin@zytor.com> <aAexLqjhKncFyw2V@google.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <aAexLqjhKncFyw2V@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/22/2025 8:09 AM, Sean Christopherson wrote:
> On Tue, Apr 22, 2025, Xin Li (Intel) wrote:
>> __rdmsr() is the lowest level primitive MSR read API, and its direct
>> use is NOT preferred.
> 
> Doesn't mean it's wrong.

I wouldn't go so far as to claim that it's wrong :-)

>> Use its wrapper function native_rdmsrq() instead.

The current code exhibits a somewhat haphazard use of MSR APIs, so I
wanted to clarify which API to employ in specific situations with
verbose function naming.

Here is an example that Boris had to fix the use of MSR APIs:

https://web.git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f980f9c31a923e9040dee0bc679a5f5b09e61f40

> 
> ...
> 
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 1547bfacd40f..e73c1d5ba6c4 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -380,7 +380,7 @@ static __always_inline void vmx_disable_fb_clear(struct vcpu_vmx *vmx)
>>   	if (!vmx->disable_fb_clear)
>>   		return;
>>   
>> -	msr = __rdmsr(MSR_IA32_MCU_OPT_CTRL);
>> +	msr = native_rdmsrq(MSR_IA32_MCU_OPT_CTRL);
>>   	msr |= FB_CLEAR_DIS;
>>   	native_wrmsrq(MSR_IA32_MCU_OPT_CTRL, msr);
>>   	/* Cache the MSR value to avoid reading it later */
>> @@ -7307,7 +7307,7 @@ void noinstr vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx,
>>   		return;
>>   
>>   	if (flags & VMX_RUN_SAVE_SPEC_CTRL)
>> -		vmx->spec_ctrl = __rdmsr(MSR_IA32_SPEC_CTRL);
>> +		vmx->spec_ctrl = native_rdmsrq(MSR_IA32_SPEC_CTRL);
> 
> And what guarantees that native_rdmsrq() won't have tracing?  Ugh, a later patch
> renames native_rdmsrq() => native_rdmsrq_no_trace().
> 
> I really don't like this.  It makes simple and obvious code:
> 
> 	vmx->spec_ctrl = __rdmsr(MSR_IA32_SPEC_CTRL);
> 
> so much harder to read:
> 
> 	vmx->spec_ctrl = native_rdmsrq_no_trace(MSR_IA32_SPEC_CTRL);
> 
> and does so in a way that is difficult to review, e.g. I have to peek ahead to
> understand that this is even ok.
> 
> I strongly prefer that we find a way to not require such verbose APIs, especially
> if KVM ends up using native variants throughout.  Xen PV is supposed to be the
> odd one out, yet native code is what suffers.  Blech.

Will try to figure out how to name the APIs.

One reason I chose verbose names is that short names are in use and
renaming needs to touch a lot of files (and not fun at all).

Thanks!
     Xin


