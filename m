Return-Path: <kvm+bounces-44095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8884DA9A547
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 10:08:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1BD165A574C
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 08:08:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75F9420C46A;
	Thu, 24 Apr 2025 08:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="LUn/Q21e"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F8F1F5841;
	Thu, 24 Apr 2025 08:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745482072; cv=none; b=E2PasgAo+2FzWdSPyglw9p9fZPBCO97IiU8u+UzkE0gZJmP34THUmqUHjb4WymTq+vKy2bvTbtkzhBRf1IOVUrBsnHpXO4Y94PYkIykf4nK/6vVPEIf/81RrFc/ASg0UCbIvd+UHJKt2r+MTPCatLCXWuIzTyaWHyRAmDcmQoyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745482072; c=relaxed/simple;
	bh=OFVNa/M8demFl5U9urQ5Rsbf4hx01XDASJ/v4Lvme2c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HkHilalbz1yygdhkx02+/uPo/EQ+jmWadLycWj0om+rOrZ++mzRqT06AJaRlgOBO5NMdyJxARUm+sP8vKVjRDOpY9OTFC0hpZXu35xgQTA+YIbxN6IOaCyNhxz3oabfqJqb6l1y6JXUieyi6mCNziToRMDBpGe0erhVkxgLoyb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=LUn/Q21e; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53O86uOw731084
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Thu, 24 Apr 2025 01:06:57 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53O86uOw731084
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745482020;
	bh=KmEo1ZYQQDPe/eBHeAwtyK6uD2OsimPSMpYKwP9PF0M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LUn/Q21ek7qt428VJCVaK7r0J65rS474/tbeyN6jnxDuA4e+VPH4XEfI/OsSLUYBB
	 BvpRAzADaXbAdlHcAxsKfc87VmEQu4veJ4shAXxl6d+KfdMZGS/rDLljsWBue+tMlb
	 jvEyu1Yv4F+eoj5cW4qEigccihTAn74hoJfZFM3aAPaGNzM7K5G9tj8QnwXy8c/25/
	 yT845Q0l6v0MeAUuXA9Fh8iSxmX1i65xs7b1QnacLeCOR9am33RZQnJmKye1tVbACZ
	 56XAfIsHBaouAtfIE0fwp1tmTpu1+KQweyH6OVB1NQwNJmnyPtnyxqbNHrqwDH/2lO
	 6Ooz8AMRP9cKQ==
Message-ID: <bb8f6b85-4e7d-440a-a8c3-0e0da45864b8@zytor.com>
Date: Thu, 24 Apr 2025 01:06:56 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 21/34] x86/msr: Utilize the alternatives mechanism
 to write MSR
To: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux.dev, linux-pm@vger.kernel.org,
        linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org,
        netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        acme@kernel.org, andrew.cooper3@citrix.com, peterz@infradead.org,
        namhyung@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
        wei.liu@kernel.org, ajay.kaher@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
        luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
        haiyangz@microsoft.com, decui@microsoft.com
References: <20250422082216.1954310-1-xin@zytor.com>
 <20250422082216.1954310-22-xin@zytor.com>
 <b2624e84-6fab-44a3-affc-ce0847cd3da4@suse.com>
 <f7198308-e8f8-4cc5-b884-24bc5f408a2a@zytor.com>
 <37c88ea3-dd24-4607-9ee1-0f19025aaef3@suse.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <37c88ea3-dd24-4607-9ee1-0f19025aaef3@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/23/2025 9:05 AM, Jürgen Groß wrote:
>> It's not a major change, but when it is patched to use the immediate 
>> form MSR write instruction, it's straightforwardly streamlined.
> 
> It should be rather easy to switch the current wrmsr/rdmsr paravirt 
> patching
> locations to use the rdmsr/wrmsr instructions instead of doing a call to
> native_*msr().
> 
> The case of the new immediate form could be handled the same way.

Actually, that is how we get this patch with the existing alternatives
infrastructure.  And we took a step further to also remove the pv_ops
MSR APIs...

It looks to me that you want to add a new facility to the alternatives
infrastructure first?


>>> Only the "paravirt" term has been eliminated.
>>
>> Yes.
>>
>> But a PV guest doesn't operate at the highest privilege level, which
>> means MSR instructions typically result in a #GP fault.  I actually 
>> think the pv_ops MSR APIs are unnecessary because of this inherent
>> limitation.
>>
>> Looking at the Xen MSR code, except PMU and just a few MSRs, it falls
>> back to executes native MSR instructions.  As MSR instructions trigger
>> #GP, Xen takes control and handles them in 2 ways:
>>
>>    1) emulate (or ignore) a MSR operation and skip the guest instruction.
>>
>>    2) inject the #GP back to guest OS and let its #GP handler handle it.
>>       But Linux MSR exception handler just ignores the MSR instruction
>>       (MCE MSR exception will panic).
>>
>> So why not let Xen handle all the details which it already tries to do?
> 
> Some MSRs are not handled that way, but via a kernel internal emulation.
> And those are handled that way mostly due to performance reasons. And some
> need special treatment.
> 
>> (Linux w/ such a change may not be able to run on old Xen hypervisors.)
> 
> Yes, and this is something to avoid.
> 
> And remember that Linux isn't the only PV-mode guest existing.
> 
>> BTW, if performance is a concern, writes to MSR_KERNEL_GS_BASE and
>> MSR_GS_BASE anyway are hpyercalls into Xen.
> 
> Yes, and some other MSR writes are just NOPs with Xen-PV.
> 

I will do some cleanup and refactor first.

BTW, at least we can merge the safe() APIs into the non-safe() ones.

Thanks!
     Xin

