Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7370437B10
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 18:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233494AbhJVQpn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 12:45:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:31591 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233277AbhJVQpn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Oct 2021 12:45:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634921004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W/OkavNRtUwEaidR99EZr7U7XrYVv5pnh4kT4nN7WGM=;
        b=N2rdvbfBcYkjsvMn8hfGWE78AHwESAbPnuwT5X5FlTwrmGeViEWMZRnhX6FYEbCudweKNj
        W2Z1valErOA85AS+x54agaz61CgF0eBGXC9Rw5Z7eYUnwOi8GKNbUUuamlERzmwX28Ir/D
        jU0ly5wBtnGdyA5T3clL1t/7NZ9kcwA=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-53-1AY8iAcfP4m7tB8yN0KdKQ-1; Fri, 22 Oct 2021 12:43:23 -0400
X-MC-Unique: 1AY8iAcfP4m7tB8yN0KdKQ-1
Received: by mail-ed1-f71.google.com with SMTP id h19-20020aa7de13000000b003db6ad5245bso4292254edv.9
        for <kvm@vger.kernel.org>; Fri, 22 Oct 2021 09:43:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=W/OkavNRtUwEaidR99EZr7U7XrYVv5pnh4kT4nN7WGM=;
        b=yXpK94D1o1bpBUZinWiMy+vfrGLh1wuli/o4RfWVuod+3Pvsp95BgBS3JqlrHeu3xX
         n3CDjH0m93UCZrzrEnvG55UJ5L/66BIFwDH4h9LsMIA2f6dnjUOyYdWXrpMImQVONcSi
         3eqSgxsIushmfg23qK7IdNj/gQHTlToP0wGCaafmWCcvpapF3X+qYMK7RBe8vsr/TduF
         WQ3O4Otkd+en5AHBmCbQl9yh8g+7FBM/7M8jw6YOBI0LqWWVmKwJ+F/zdPr0ftioIHXS
         4YNg882ZpE70gx6FIBcsf/XeE7nyh2SUXNlnMH/vt0y5CqF8AqEy7N3KzVDUJsZ5VuPW
         raBg==
X-Gm-Message-State: AOAM532Cg+3cPhpOvAxhezDWIh3W9ed40sjb3wXHOEV7PS3mACP2s9D7
        bYz7hTLPrUUWlXu4+5nq8rZ0miShqZ/QrAX8R+NHya8PvWDAgFKOpl7VXUqB1WKeTjrHMWsQMwK
        O0b5yNgHZ3O5Z
X-Received: by 2002:a17:906:2653:: with SMTP id i19mr740625ejc.193.1634921002224;
        Fri, 22 Oct 2021 09:43:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyiXVOl5W/K9kJG7nyZqMWMg/lvUNXM1hdAVlzoMF/Y76tqOHn/fFgp0oEeleNdyYrDQSUZ+w==
X-Received: by 2002:a17:906:2653:: with SMTP id i19mr740598ejc.193.1634921002043;
        Fri, 22 Oct 2021 09:43:22 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id jg13sm2336590ejc.26.2021.10.22.09.43.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 09:43:21 -0700 (PDT)
Message-ID: <b931906f-b38e-1cb5-c797-65ef82c8b262@redhat.com>
Date:   Fri, 22 Oct 2021 18:43:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 0/4] KVM: x86: APICv cleanups
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211022004927.1448382-1-seanjc@google.com>
 <23d9b009-2b48-d93c-3c24-711c4757ca1b@redhat.com>
 <9c159d2f23dc3957a2fda0301b25fca67aa21b30.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <9c159d2f23dc3957a2fda0301b25fca67aa21b30.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/10/21 16:56, Maxim Levitsky wrote:
>      vCPU0                                   vCPU1
>      =====                                   =====
> 
> - disable AVIC
>                                          - #NPT on AVIC MMIO access

vCPU1 is now OUTSIDE_GUEST_CODE

>                                          -*stuck on something prior to the page fault code*
> - enable AVIC
>                                          -*still stuck on something prior to the page fault code*
> - disable AVIC:
>    - raise KVM_REQ_APICV_UPDATE request

kvm_make_all_cpus_request does not wait for vCPU1

>    - zap the SPTE (does nothing, doesn't race
>         with anything either)

vCPU0 writes mmu_notifier_seq here

>                                          - now vCPU1 finally starts running the page fault code.

vCPU1 reads mmu_notifier_seq here

So yeah, I think you're right.

The VM value doesn't have this problem, because it is always stored 
before mmu_notifier_seq is incremented (on the write side) and loaded 
after the mmu_notifier_seq (on the page fault side).  Therefore, if 
vCPU1 sees a stale per-VM apicv_active flag, it is always going to see a 
stale mmu_notifier_seq.

With the per-vCPU flag, instead, the flag is written by 
kvm_vcpu_update_apicv, and that can be long after mmu_notifier_seq is 
incremented.

Paolo

>                                          - vCPU1 AVIC is still enabled
>                                            (because vCPU1 never handled KVM_REQ_APICV_UPDATE),
>                                            so the page fault code will populate the SPTE.
> 
>                                          - handle KVM_REQ_APICV_UPDATE
>                                             - finally disable vCPU1 AVIC
> 
>                                          - VMRUN (vCPU1 AVIC disabled, SPTE populated)

