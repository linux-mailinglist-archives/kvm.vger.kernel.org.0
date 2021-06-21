Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77B353AE216
	for <lists+kvm@lfdr.de>; Mon, 21 Jun 2021 06:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbhFUEOz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 00:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbhFUEOs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Jun 2021 00:14:48 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4EA1C061756;
        Sun, 20 Jun 2021 21:03:46 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id w71so2594502pfd.4;
        Sun, 20 Jun 2021 21:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=W9BcsAwtpmpC79LzU3QerIgLLyt1O/3DCtZegRGpFas=;
        b=SH4QCyDkfJ/xzy+yLjO8n3rGGyUav2vEPfoUmuZCkUs4YlpcbDY7gouPGs4NwF0ATH
         TGwBfic2WiDF+6GTq7NQ41nciMq05daYsqWKZ+NI2K0jJC17T6Fb5fbpwROUGzB87rsz
         3JC1ksrj3++eIOmHGI7z6EdHydG4Ye8WXqIZSIffQ5hoyE7/cWE3Zo4XkdslQg7dBhCo
         EZTIW/g4/PU5scTC+4yhbiQsNxt47H7eomhTu1MbDhwRdhz6LznjtwQqb72WCiSTRq7a
         93p/UpUgeylY+E8oxdPRrFIJKvUvdNLUE0wOAh0qDHMfeLcLVplm7P+3f9SZDRBbTFDq
         t+EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W9BcsAwtpmpC79LzU3QerIgLLyt1O/3DCtZegRGpFas=;
        b=UbrMzZPPgpGokEkLFo7rNCKUuY28volcVUmP9rTKB2+ZxACAeppjZsvcjD1vIsUbf3
         5RkJdoUKLqn/qm4VRoUjxSxCqc5313pQyasmBvu4z2w3nz7ECI5P/ViDKUgOh2WsCn0S
         yB5C8BOiv3nLqyhZn4SZIFWTEtyoL5WQ6QuStxW/PrEVxBxL6oVrWr1ki4XFvz2uGYsE
         oUOS9LAKbzHiqidhxWpzG7sdaNKTserBy1VNwJMhrMc1ZENn/ERi7+6AjaOPXPxvg7f5
         XWngb5nfP/8WPKizrTYVZfrF12Y03/8lJwq66kFlCDJ3z1PB4R5JDlNuiYq6be+WY/ZP
         IvfQ==
X-Gm-Message-State: AOAM53297Ftrc7kBg/wkenkTLIGFBqlSonpNM3/dNH5N0FYcinSAqK7F
        Ne+tIgapI9+foov8fx9CNiA=
X-Google-Smtp-Source: ABdhPJzvBS8QJe1nvB8Sk6H6Bj0KzExcP2APyMgc+vVfBoYpHRNXKyG//xGyWtSoJZe4jM32xztACg==
X-Received: by 2002:a62:9242:0:b029:300:6fb1:38b7 with SMTP id o63-20020a6292420000b02903006fb138b7mr14132504pfd.80.1624248226456;
        Sun, 20 Jun 2021 21:03:46 -0700 (PDT)
Received: from Likes-MacBook-Pro.local ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id q12sm15418855pgc.25.2021.06.20.21.03.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Jun 2021 21:03:45 -0700 (PDT)
To:     Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <like.xu@linux.intel.com>
References: <20210514084436.848396-1-like.xu@linux.intel.com>
 <YK6HsR4QXbVuhZf8@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
Subject: Re: [PATCH] KVM: x86/pt: Do not inject TraceToPAPMI when guest PT
 isn't supported
Message-ID: <e82cd903-77ad-790e-22e4-dd8cdf1f4167@gmail.com>
Date:   Mon, 21 Jun 2021 12:03:36 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YK6HsR4QXbVuhZf8@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/5/2021 1:38 am, Sean Christopherson wrote:
> On Fri, May 14, 2021, Like Xu wrote:
>> When a PT perf user is running in system-wide mode on the host,
>> the guest (w/ pt_mode=0) will warn about anonymous NMIs from
>> kvm_handle_intel_pt_intr():
>>
>> [   18.126444] Uhhuh. NMI received for unknown reason 10 on CPU 0.
>> [   18.126447] Do you have a strange power saving mode enabled?
>> [   18.126448] Dazed and confused, but trying to continue
>>
>> In this case, these PMIs should be handled by the host PT handler().
>> When PT is used in guest-only mode, it's harmless to call host handler.
>>
>> Fix: 8479e04e7d("KVM: x86: Inject PMI for KVM guest")
> 
> s/Fix/Fixes
> 
>> Signed-off-by: Like Xu <like.xu@linux.intel.com>
>> ---
>>   arch/x86/events/intel/core.c | 3 +--
>>   arch/x86/kvm/x86.c           | 3 +++
>>   2 files changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
>> index 2521d03de5e0..2f09eb0853de 100644
>> --- a/arch/x86/events/intel/core.c
>> +++ b/arch/x86/events/intel/core.c
>> @@ -2853,8 +2853,7 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
>>   		if (unlikely(perf_guest_cbs && perf_guest_cbs->is_in_guest() &&
>>   			perf_guest_cbs->handle_intel_pt_intr))
>>   			perf_guest_cbs->handle_intel_pt_intr();
>> -		else
>> -			intel_pt_interrupt();
>> +		intel_pt_interrupt();
> 
> Would it make sense to instead do something like:
> 
> 	bool host_pmi = true;
> 
> 	...
> 
> 		if (unlikely(perf_guest_cbs && perf_guest_cbs->is_in_guest() &&
> 			     perf_guest_cbs->handle_intel_pt_intr)
> 			host_pmi = !perf_guest_cbs->handle_intel_pt_intr();

struct perf_guest_info_callbacks {
	...
	void				(*handle_intel_pt_intr)(void);
};


This fix is deferred until the following proposal is finalized.

https://lore.kernel.org/lkml/YKImQ2%2FDilGIkrfe@hirez.programming.kicks-ass.net/

> 
> 		if (likely(host_pmi))
> 			intel_pt_interrupt();
>>   	}
>>   
>>   	/*
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 6529e2023147..6660f3948cea 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -8087,6 +8087,9 @@ static void kvm_handle_intel_pt_intr(void)
>>   {
>>   	struct kvm_vcpu *vcpu = __this_cpu_read(current_vcpu);
>>   
>> +	if (!guest_cpuid_has(vcpu, X86_FEATURE_INTEL_PT))
>> +		return;
>> +
>>   	kvm_make_request(KVM_REQ_PMI, vcpu);
>>   	__set_bit(MSR_CORE_PERF_GLOBAL_OVF_CTRL_TRACE_TOPA_PMI_BIT,
>>   			(unsigned long *)&vcpu->arch.pmu.global_status);
>> -- 
>> 2.31.1
>>
> 
