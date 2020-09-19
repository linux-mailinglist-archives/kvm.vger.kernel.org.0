Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91580270EDF
	for <lists+kvm@lfdr.de>; Sat, 19 Sep 2020 17:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgISPTI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Sep 2020 11:19:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60351 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726434AbgISPTF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 19 Sep 2020 11:19:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600528744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UbPVb1SNMbV2AieY6+SVa7sK76f4nIZ2S6J0MZz1m7s=;
        b=bLpIiqH4lglFdX/wfk0EHa8cRMq7U3L3ud1HCwTJnhGe323rEL+R81WEZEh3CNqrojM28u
        oIRNtuzMUEzHSza+aiZhnvson5Hs2YESusRhfbrPEJQ7PXStBEwxFBXBO4gJhzBzTZpoju
        6uHH8bMtOnngHtwx9MI1A08zCo1jhRQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-PC7CNl23NCmfffB0tedk1A-1; Sat, 19 Sep 2020 11:19:02 -0400
X-MC-Unique: PC7CNl23NCmfffB0tedk1A-1
Received: by mail-wr1-f70.google.com with SMTP id b7so3554192wrn.6
        for <kvm@vger.kernel.org>; Sat, 19 Sep 2020 08:19:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UbPVb1SNMbV2AieY6+SVa7sK76f4nIZ2S6J0MZz1m7s=;
        b=nGqxUR9jRk2+Aj/n1TAo+tJqtaLMeJLlE2Ip+E3I49hoBoJ4ey2AjivwPdNQY3TgGh
         BrtpbLPVQznW9krX9h2iB+WvZJNoids5chK/EZ60WFyVQvG3wmmY+QlusQr5jwAR0Ogg
         H6mAwQZblPHc7gD6Ix/LkgmbuH0tAiENiGlMmHyelyIBTXewTAenqrbF1PUePF8+e9PN
         oopWdYn9UC8X6ALVuzYmVuI7zGo0MAk7hmXJy6SBYBqp6Fd7LG8mQSF1mzJWlO9s+wjo
         4e2qyjsm7XOb/C8vKReUJz1qpQDRKEk3C0whtdB7slA8DTZOndUAd5qggUcH+dp7ypjq
         JGwg==
X-Gm-Message-State: AOAM5313ks4Al60Iw6Moj6JqPZ+ZtZiJteMoiddvYkm4vpYnnA/iQepi
        sWakBEdIfZ7+LWePq0rrB1nQngPkT7UTtD4v9HLtdAwTsqFv+jBmT3sc360Z1cUMZ8410bAS5RT
        Y7E0Y83svlaZ4
X-Received: by 2002:a05:6000:100c:: with SMTP id a12mr46271726wrx.115.1600528740891;
        Sat, 19 Sep 2020 08:19:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzSDC+LPueFhpaaTGv2ug0qRqfzgHwqddZt/Gb4Xtw5UXDFve1xKaVT3W11Pk7R2NFm1DhDew==
X-Received: by 2002:a05:6000:100c:: with SMTP id a12mr46271696wrx.115.1600528740649;
        Sat, 19 Sep 2020 08:19:00 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b20a:b600:521c:512d? ([2001:b07:6468:f312:b20a:b600:521c:512d])
        by smtp.gmail.com with ESMTPSA id c16sm12719465wrx.31.2020.09.19.08.18.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Sep 2020 08:18:59 -0700 (PDT)
Subject: Re: [PATCH 3/3 v4] KVM: SVM: Don't flush cache if hardware enforces
 cache coherency across encryption domains
To:     Borislav Petkov <bp@alien8.de>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, jmattson@google.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com
References: <20200917212038.5090-1-krish.sadhukhan@oracle.com>
 <20200917212038.5090-4-krish.sadhukhan@oracle.com>
 <20200918075651.GC6585@zn.tnic>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b711fc52-0adf-1afd-61c8-ce142bff9ddb@redhat.com>
Date:   Sat, 19 Sep 2020 17:18:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200918075651.GC6585@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/09/20 09:56, Borislav Petkov wrote:
> On Thu, Sep 17, 2020 at 09:20:38PM +0000, Krish Sadhukhan wrote:
>> In some hardware implementations, coherency between the encrypted and
>> unencrypted mappings of the same physical page in a VM is enforced. In such a
>> system, it is not required for software to flush the VM's page from all CPU
>> caches in the system prior to changing the value of the C-bit for the page.
>>
>> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>> ---
>>  arch/x86/kvm/svm/sev.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 7bf7bf734979..3c9a45efdd4d 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -384,7 +384,8 @@ static void sev_clflush_pages(struct page *pages[], unsigned long npages)
>>  	uint8_t *page_virtual;
>>  	unsigned long i;
>>  
>> -	if (npages == 0 || pages == NULL)
>> +	if (this_cpu_has(X86_FEATURE_SME_COHERENT) || npages == 0 ||
>> +	    pages == NULL)
>>  		return;
>>  
>>  	for (i = 0; i < npages; i++) {
>> -- 
> 
> Took the first two, Paolo lemme know if I should route this one through
> tip too.
> 
> Thx.
> 

Yeah, it's innocuous enough as far as conflicts are concerned.

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

