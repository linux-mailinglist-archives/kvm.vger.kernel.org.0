Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2DC36EE8E
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 19:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240951AbhD2RFA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 13:05:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26241 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240946AbhD2RE7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Apr 2021 13:04:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619715852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nefj2fq2T6KO70bmZ+d62df+XmNxQOpkvhxo2gt/gH4=;
        b=I8h2hmZz4BDNymFFdNhoRNcFBoDqYFEd4Rhq+pUsi2Z17YY7B0aD5/cYGgRFmI2ycS0Pw7
        H8IoXm477JCZJRgm+x9BnHnkMqhBmDEqIme8ojyHwvuEPia0J2BsBttmy+4sMt74haTNO7
        CWmpXau+wTVcpoRlBtM2nvmZTEKRsFk=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-dE3mnFDVOjaW9IQ9AAhQ0A-1; Thu, 29 Apr 2021 13:04:10 -0400
X-MC-Unique: dE3mnFDVOjaW9IQ9AAhQ0A-1
Received: by mail-ed1-f70.google.com with SMTP id u30-20020a50a41e0000b0290385504d6e4eso7258170edb.7
        for <kvm@vger.kernel.org>; Thu, 29 Apr 2021 10:04:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nefj2fq2T6KO70bmZ+d62df+XmNxQOpkvhxo2gt/gH4=;
        b=hXSbBP65eQ0fljt9HpaER4u89TYMBckU76hjBuA+xfEAOTirBF8ZjL92mbgJxQtEjb
         y1YumNtfoo8VyovM7SA3LHKZtuhTX6+wIpWAd94DHouVWQQO3qIa7AmD69L8Kwy5iFbg
         xxtaKDCrCOdUvpP6turaP0g+bi/W8F49zx8aibaOkXzDz3YhhrQymWU/vsBrSxiEvrel
         hxC4/OG+Q8LuCpown2xbRP+2kgKCvNcWkSgL4rwlxisxrpIC+mwUx1vm6ds/NTRQv+wS
         NmhmHySPuIbBp6NP9y6kT2z3vb1KeOt9YaEDzOAXgJtLKbes+5Ors55lKhxugEcfpjcp
         13RA==
X-Gm-Message-State: AOAM532LTW/RCk46nKuWIkpq/DngR6QwurhuSL4IDNjCaH5auZgfXfy5
        nQi5k04t7W4VQxbkpQh0rnyh9gcugJUOFwYrtEYcb/kviasJYU0ezvT3tyX5hEr1YUoDaFb+UTS
        N+AouNCWYRRZV
X-Received: by 2002:a05:6402:120c:: with SMTP id c12mr722493edw.98.1619715849088;
        Thu, 29 Apr 2021 10:04:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzznAp/etf/nR8xXfGtW3DEqoIhDAO7pAHMrM84CMg2r3AUBIaPwEYJyUCaCE49inPzWm7S4Q==
X-Received: by 2002:a05:6402:120c:: with SMTP id c12mr722462edw.98.1619715848858;
        Thu, 29 Apr 2021 10:04:08 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id dk13sm1062275edb.34.2021.04.29.10.04.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Apr 2021 10:04:08 -0700 (PDT)
To:     Sean Christopherson <seanjc@google.com>,
        "Shahin, Md Shahadat Hossain" <shahinmd@amazon.de>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Szczepanek, Bartosz" <bsz@amazon.de>,
        "bgardon@google.com" <bgardon@google.com>
References: <1619700409955.15104@amazon.de> <YIrjiXja3/5e6frs@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Subject: [RFC PATCH] kvm/x86: Fix 'lpages' kvm stat for TDM MMU
Message-ID: <3bdf46db-bd64-0ca7-039a-9c123f5a40f9@redhat.com>
Date:   Thu, 29 Apr 2021 19:04:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YIrjiXja3/5e6frs@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/04/21 18:49, Sean Christopherson wrote:
> On Thu, Apr 29, 2021, Shahin, Md Shahadat Hossain wrote:
>> Large pages not being created properly may result in increased memory
>> access time. The 'lpages' kvm stat used to keep track of the current
>> number of large pages in the system, but with TDP MMU enabled the stat
>> is not showing the correct number.
>>
>> This patch extends the lpages counter to cover the TDP case.
>>
>> Signed-off-by: Md Shahadat Hossain Shahin <shahinmd@amazon.de>
>> Cc: Bartosz Szczepanek <bsz@amazon.de>
>> ---
>>   arch/x86/kvm/mmu/tdp_mmu.c | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
>> index 34207b874886..1e2a3cb33568 100644
>> --- a/arch/x86/kvm/mmu/tdp_mmu.c
>> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
>> @@ -425,6 +425,12 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>>   
>>   	if (old_spte == new_spte)
>>   		return;
>> +	
>> +	if (is_large_pte(old_spte))
>> +		--kvm->stat.lpages;
>> +	
>> +	if (is_large_pte(new_spte))
>> +		++kvm->stat.lpages;
> 
> Hrm, kvm->stat.lpages could get corrupted when __handle_changed_spte() is called
> under read lock, e.g. if multiple vCPUs are faulting in memory.

Ouch, indeed!

One way to fix it without needing an atomic operation is to make it a 
per-vcpu stat.  It would be a bit weird for the binary stats because we 
would have to hide this one from the vCPU statistics file descriptor 
(and only aggregate it in the VM statistics).

Alternatively, you can do the atomic_add only if is_large_pte(old_spte) 
!= is_large_pte(new_spte), casting &kvm->stat.lpages to an atomic64_t*.

Paolo

