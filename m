Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67F7C3B216D
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 21:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhFWTzj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 15:55:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21306 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229523AbhFWTzj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 15:55:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624478001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cUTB7rHthe76pbGmYM084Sjx8ayVBRHQw9Xw36oAOPE=;
        b=cQp3VojwtRAzfaljTXPA1Hbo3UfY1Hr00TdP/sdnLxblOXdHPC/OhoGPGBdSgDt8qYsmSG
        r1JOPUzJ/FVtIQCtxJDSpeIOwqx3x8HsNsCCOcJ6SRavUfcH1hxP/7ZDFIh96xmdJ2/n4O
        FGIoGgUf1lhQ+9EBa6NZXnApehV4NrE=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-yqJbLiq7OLS7GNp029V3xQ-1; Wed, 23 Jun 2021 15:53:17 -0400
X-MC-Unique: yqJbLiq7OLS7GNp029V3xQ-1
Received: by mail-ed1-f70.google.com with SMTP id x10-20020aa7cd8a0000b0290394bdda92a8so1942200edv.8
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 12:53:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cUTB7rHthe76pbGmYM084Sjx8ayVBRHQw9Xw36oAOPE=;
        b=FVc2EnI22/4/HM3fanPI1UXMn3+sSGHEUkJJ+O7/DZSU5Trzdfvf66CW1ZHAuHz6A6
         ZBXjt6a5zuJpneE/I4MQNr02mt43gHDIaP2oLpCse5R4aWKg1Cs9+mOHBW6ryUh2jq5y
         VqYoBmHH+BffQ7iqpDWLjLg5EgOojNGzByJfUmcKKKo3JjzqaJG+msJthOqR9qsJRyfB
         fBMRIjZp1AAtz2F2HF9SNjD0FY2xHmxUAwfFA32cxzIrByHFFt8v6YXpvbB5CTgrHz+r
         N+3srd7fk/blh3rScdSqfQvRIt5BTJc7r2Pq8mcK1sS0FqvAr/6H78Qs9KKPe8Uo19Ak
         ZBkQ==
X-Gm-Message-State: AOAM53034xY8cshbyCooGmf5tnzxoy+jPUFBK0qU7m1LS/3wqVOYVRdf
        VTa4ZCMiw3avtuOT3CWhDL6yYWN7C7fNHtJ2S7wAc2w/Efr2qwoux+4W+GaNOMYfqguUJtGdX1V
        iIovbPcSGyN89
X-Received: by 2002:a50:9345:: with SMTP id n5mr1945643eda.289.1624477996233;
        Wed, 23 Jun 2021 12:53:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx84bbbDxSbyKIa+Y8qhpY6dQ36JqHh+T/qbouegnSKBx6sL5tYBEvLNWn+o6T39EXZa6onVA==
X-Received: by 2002:a50:9345:: with SMTP id n5mr1945623eda.289.1624477996039;
        Wed, 23 Jun 2021 12:53:16 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id jx17sm282801ejc.60.2021.06.23.12.53.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 12:53:15 -0700 (PDT)
Subject: Re: [PATCH 07/54] KVM: x86: Alert userspace that KVM_SET_CPUID{,2}
 after KVM_RUN is broken
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20210622175739.3610207-1-seanjc@google.com>
 <20210622175739.3610207-8-seanjc@google.com>
 <f031b6bc-c98d-8e46-34ac-79e540674a55@redhat.com>
 <CALMp9eSpEJrr6mNoLcGgV8Pa2abQUkPA1uwNBMJZWexBArB3gg@mail.gmail.com>
 <6f25273e-ad80-4d99-91df-1dd0c847af39@redhat.com>
 <CALMp9eTzJb0gnRzK_2MQyeO2kmrKJwyYYHE5eYEai+_LPg8HrQ@mail.gmail.com>
 <af716f56-9d68-2514-7b85-f9bbb1a82acf@redhat.com>
 <CALMp9eQG-QLm1xRXw2CxLEsRukH0q6HoaQKPraDo-TyCSv6EKg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <00691c37-5c29-e898-2657-8d7ef6b5dfad@redhat.com>
Date:   Wed, 23 Jun 2021 21:53:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CALMp9eQG-QLm1xRXw2CxLEsRukH0q6HoaQKPraDo-TyCSv6EKg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/21 21:02, Jim Mattson wrote:
>>
>> BTW, there is actually a theoretical usecase for KVM_SET_CPUID2 after
>> KVM_RUN, which is to test OSes against microcode updates that hide,
>> totally random example, the RTM bit.  But it's still not worth keeping
>> it given 1) the bugs and complications in KVM, 2) if you really wanted
>> that kind of testing so hard, the fact that you can just create a new
>> vcpu file descriptor from scratch, possibly in cooperation with
>> userspace MSR filtering 3) AFAIK no one has done that anyway in 15 years.
>
> Though such a usecase may exist, I don't think it actually works
> today. For example, kvm_vcpu_after_set_cpuid() potentially changes the
> value of the guest IA32_PERF_GLOBAL_CTRL MSR.

Yep, and that's why I'm okay with actively deprecating KVM_SET_CPUID2 
and not just "discouraging" it.

Paolo

