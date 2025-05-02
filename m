Return-Path: <kvm+bounces-45247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 588C6AA7908
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 20:02:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BCB469A4CFE
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 18:01:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58723268FD5;
	Fri,  2 May 2025 18:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="CAJaBviD"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACEBC3D6F;
	Fri,  2 May 2025 18:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746208900; cv=none; b=rxXK3y80Z3AkHi0zxuqwdHDXRualK+wIRwsxhxnIozWAH4UC1/PmqR5Cu7Q3bBZCKT6wnxpFkcKZ9BArJgWEIONxgxubLtfxKL2vuRnUxO82yJ3m2cvntzQnrPUcpEeXqCmktsekS7VqFkG7yS84bfCPoAKWf1WPxi+1ps/amIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746208900; c=relaxed/simple;
	bh=bVi2uLJgadMIDrlKX2yiVqiyC/JIX88QVjfioOah/5Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MrDZzRByDXHe+5Hab8W6sy5p6auTh3UjhbDnWW8hXImmm04MUBHCaD4ra6cRgOKrtPyp2d64FUPwUziOs2H2YlZIacOHEavqzve56Z6Ukplw68wpmc1PItLOkQGe0mbtxOufmaULTF5hKYP8TRyC49jWXt85qF5zE0JjgO+UgQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=CAJaBviD; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 542I0lLB2105252
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Fri, 2 May 2025 11:00:48 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 542I0lLB2105252
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1746208851;
	bh=hT0wLy4M/v5r4X1GaFGl658jjbwFpHKBOET/YkmHGHo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CAJaBviDhg9dcDsmvqA7VZfyDyiseEFTi17BVGAsmrhSXWlwiI3sYKkn5aE2mwhbP
	 bgZAZCKk7pLOdVIAGKVBRNa+jDTPSLoC/S4MqW+rGSD/V4WtV8+NS0S15CsAopcW/D
	 17kzdds9fMZzZC5qWrbmIdApNBkD8vV6qwWs5V7taNjREQAvzbGbXtMwRqqeGWDmv1
	 xWQCz/zWDImzXOdooMewYA4YdpZtEtQmtoEmaUnapfwXICzNPcQLl4pKTBi4Mr75n/
	 VvCXK2e99oq/VMAeMrTNHzml4+e9V0yqLoSG6KEbpqN8YhN5gnNNj/Afn1DJ5XrLTD
	 OXrUGFJVQ0RAQ==
Message-ID: <4b896294-66a3-4f4b-84f2-ec67dbaa9a6e@zytor.com>
Date: Fri, 2 May 2025 11:00:47 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/15] x86/msr: Move rdtsc{,_ordered}() to <asm/tsc.h>
To: Ingo Molnar <mingo@kernel.org>
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
        pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
        luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
        haiyangz@microsoft.com, decui@microsoft.com,
        dapeng1.mi@linux.intel.com, ilpo.jarvinen@linux.intel.com
References: <20250427092027.1598740-1-xin@zytor.com>
 <20250427092027.1598740-3-xin@zytor.com> <aBSHyo-pu7K_CfpI@gmail.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <aBSHyo-pu7K_CfpI@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/2/2025 1:52 AM, Ingo Molnar wrote:
> 
> * Xin Li (Intel) <xin@zytor.com> wrote:
> 
>> For some reason, there are some TSC-related functions in the MSR
>> header even though there is a tsc.h header.
>>
>> Relocate rdtsc{,_ordered}() from <asm/msr.h> to <asm/tsc.h>, and
>> subsequently remove the inclusion of <asm/msr.h> in <asm/tsc.h>.
>>
>> Signed-off-by: Xin Li (Intel) <xin@zytor.com>
>> Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
>> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> 
>> --- a/arch/x86/include/asm/tsc.h
>> +++ b/arch/x86/include/asm/tsc.h
>> @@ -7,7 +7,81 @@
>>   
>>   #include <asm/cpufeature.h>
>>   #include <asm/processor.h>
>> -#include <asm/msr.h>
> 
> Note that in the tip:x86/msr commit I've applied today I've
> intentionally delayed the removal of this header dependency, to reduce
> the probability of breaking -next today or in the near future.
> 
> We can remove that now superfluous header dependency in a future patch.
> 

This is truly a brilliant decision!

Especially regarding the issues Ilpo identified.

Thanks!
     Xin

