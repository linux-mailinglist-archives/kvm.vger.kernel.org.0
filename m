Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAD33B1F3E
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 19:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbhFWROE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 13:14:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20817 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229660AbhFWROC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 13:14:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624468304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TggIJ4Xh1AX7l8pzYC0ZKngxne49cnRfXWPo8Jy9AUM=;
        b=NexrqgrJBZXxTYen6BaDx10el59HCiK1npDJaSM6tJIitqY9mCFDgaQsQ/CDU302roP2FX
        W2ZD21uQYv2YkEQidNYsTuZl6b0rBev2f5dmLryR6wAHkHe3xdG+tYv0PlI8VU9o1k6r7T
        NlLK2zNK9eF6GX1+ZqBTJSJq0/qutu0=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-FgH2i8ySOZWK0bG4cW3usQ-1; Wed, 23 Jun 2021 13:11:43 -0400
X-MC-Unique: FgH2i8ySOZWK0bG4cW3usQ-1
Received: by mail-ej1-f69.google.com with SMTP id lu1-20020a170906fac1b02904aa7372ec41so1087891ejb.23
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 10:11:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TggIJ4Xh1AX7l8pzYC0ZKngxne49cnRfXWPo8Jy9AUM=;
        b=cKOv+n+bMlGhGVDCVYyRTokuy1J85GM1M3MEFoWLd8yTGGZ0bW8e+s1xPIkVs4Gcsk
         e3QTC8TmC62aXDM+o8X+BG6+jHhNobDthWb9PvJ2iy7BA1WDyCpIvKiwaKFJB/f90jAT
         mPLNEE37bN06kAZfePO947OmgfN+zmz4f038kqKs7pmmRGDWandU0x2DAdYbOGTtasNm
         tA1QbkaeU0vSAlPgOv0cTA+LUy+PGvN3nT0HRD0JXzH2Fx1At45fWOXXuKeLjGvpUsjL
         /LIp5KXew7nDkyxvK9mubjinxjg4OvbnQwXIhuHfkLJyLYF5/aYvQdYWBcq0AiVgLQWe
         lCNw==
X-Gm-Message-State: AOAM533yrVFIqNFNlGeYDpqdFQowMO5JKuyuLAvnRRxFy/Yi8jUmBt8V
        ZBLqLU7a1UDnpfocKiI316t7BB+La++/im++BMU5qqhFAkULBLqIiCLxAoHs/hD3Mf1XGNgaMWE
        FxVMsGcxEl8dI
X-Received: by 2002:a17:906:85b:: with SMTP id f27mr1149359ejd.50.1624468302140;
        Wed, 23 Jun 2021 10:11:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwIHxcJy11EjlnPuoHXJwR/9o9MR/7Oct3mzw1mbbTwMG/GmET4XacDhIybIZBTBW0wFu0U7A==
X-Received: by 2002:a17:906:85b:: with SMTP id f27mr1149331ejd.50.1624468301923;
        Wed, 23 Jun 2021 10:11:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id lu21sm158417ejb.31.2021.06.23.10.11.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 10:11:41 -0700 (PDT)
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
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6f25273e-ad80-4d99-91df-1dd0c847af39@redhat.com>
Date:   Wed, 23 Jun 2021 19:11:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CALMp9eSpEJrr6mNoLcGgV8Pa2abQUkPA1uwNBMJZWexBArB3gg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/21 19:00, Jim Mattson wrote:
> On Wed, Jun 23, 2021 at 7:16 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 22/06/21 19:56, Sean Christopherson wrote:
>>> +     /*
>>> +      * KVM does not correctly handle changing guest CPUID after KVM_RUN, as
>>> +      * MAXPHYADDR, GBPAGES support, AMD reserved bit behavior, etc.. aren't
>>> +      * tracked in kvm_mmu_page_role.  As a result, KVM may miss guest page
>>> +      * faults due to reusing SPs/SPTEs.  Alert userspace, but otherwise
>>> +      * sweep the problem under the rug.
>>> +      *
>>> +      * KVM's horrific CPUID ABI makes the problem all but impossible to
>>> +      * solve, as correctly handling multiple vCPU models (with respect to
>>> +      * paging and physical address properties) in a single VM would require
>>> +      * tracking all relevant CPUID information in kvm_mmu_page_role.  That
>>> +      * is very undesirable as it would double the memory requirements for
>>> +      * gfn_track (see struct kvm_mmu_page_role comments), and in practice
>>> +      * no sane VMM mucks with the core vCPU model on the fly.
>>> +      */
>>> +     if (vcpu->arch.last_vmentry_cpu != -1)
>>> +             pr_warn_ratelimited("KVM: KVM_SET_CPUID{,2} after KVM_RUN may cause guest instability\n");
>>
>> Let's make this even stronger and promise to break it in 5.16.
>>
>> Paolo
> 
> Doesn't this fall squarely into kvm's philosophy of "we should let
> userspace shoot itself in the foot wherever possible"? I thought we
> only stepped in when host stability was an issue.
> 
> I'm actually delighted if this is a sign that we're rethinking that
> philosophy. I'd just like to hear someone say it.

Nah, that's not the philosophy.  The philosophy is that covering all 
possible ways for userspace to shoot itself in the foot is impossible.

However, here we're talking about 2 lines of code (thanks also to your 
patches that add last_vmentry_cpu for completely unrelated reasons) to 
remove a whole set of bullet/foot encounters.

Paolo

