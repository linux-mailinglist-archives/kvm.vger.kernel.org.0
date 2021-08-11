Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7075F3E8B76
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 10:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236270AbhHKIJP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 04:09:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59019 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235974AbhHKIH4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Aug 2021 04:07:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628669210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l5r6D8jUkNx5Z0m6hgkp7yIVpIvqOnZTyj26nR1HJ7k=;
        b=XYD67XgTfh44nmL3kg0gYBbkOEJywvbZtreCmPwe/EGaWwTdySZpxLpfd8zoO13LJVmoF5
        Npd/doO+3iCz9sIn++ypB43huXHQ2WHPDoCoT9SqQQs8Tqgp4uBGFkMIsqdgwnYCHGJyvj
        nuE3c7A47+M7ga4/QohAyaMLO7yTtD4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-c-tNJYbJMtGuVzI4eMDNEQ-1; Wed, 11 Aug 2021 04:06:47 -0400
X-MC-Unique: c-tNJYbJMtGuVzI4eMDNEQ-1
Received: by mail-wr1-f71.google.com with SMTP id f6-20020adfe9060000b0290153abe88c2dso427148wrm.20
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 01:06:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l5r6D8jUkNx5Z0m6hgkp7yIVpIvqOnZTyj26nR1HJ7k=;
        b=TMhqD3n5FuANNHM0fhtGkGIS0DhDUh4wCvJZpQVqFVs7c9gkKPshIPGwpTEatXGUYB
         uX/nTFZTTtKrGIjeBgqCeAfBSeVQjAPdUs+K6V9iBc94Rhpnady2m7dw0HXjb4EmaFHD
         zvhsLK+fKAu6fS8tJ//tvOSgxed6QxIB37AOdOMtojAYf9NqVd4YiAVyFm2GOVuCI7gx
         2vYVMXyxIl6Yu1wR69rTTkixWERfvCZy1T+Gqt5YbYzNKdVUzr3dWTWI1QdaX+N/pxOZ
         rw8vvPxggTZM6qWkOWQhHkcAZ9FsjnbwU4IvrhfS7451e83Cot38BLdgMuL2YbJ8HwVa
         G+pg==
X-Gm-Message-State: AOAM533soqCe/q6Psrj7X3fFgITywhdQBsQQP02QlaicWU28Hm1LdBw7
        HyiCoyavWw3BIs3LTJGWwHNNixjGkJO9RwQ1ogvWgzUBYtkgCLQ76HT+YzwuFizp+jZAY7ab3Er
        qpehR/lz/nSx5
X-Received: by 2002:a5d:68cb:: with SMTP id p11mr35726052wrw.364.1628669206049;
        Wed, 11 Aug 2021 01:06:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyxOTmqN+Uo0zudKogchLE49arHby/+3aOpLRhbOaodhXmC9tsnZNZ8BkMLNkhO4f20zgVqig==
X-Received: by 2002:a5d:68cb:: with SMTP id p11mr35726033wrw.364.1628669205866;
        Wed, 11 Aug 2021 01:06:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id r23sm8947379wrr.14.2021.08.11.01.06.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 01:06:45 -0700 (PDT)
Subject: Re: [PATCH v4 00/16] My AVIC patch queue
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
References: <20210810205251.424103-1-mlevitsk@redhat.com>
 <42cb19be1f6598e878b5b122e2152bdec27f62db.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <af1014c0-a690-7e10-4bb7-a751af9c5bbc@redhat.com>
Date:   Wed, 11 Aug 2021 10:06:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <42cb19be1f6598e878b5b122e2152bdec27f62db.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/08/21 23:21, Maxim Levitsky wrote:
> On Tue, 2021-08-10 at 23:52 +0300, Maxim Levitsky wrote:
>> Hi!
>>
>> This is a series of bugfixes to the AVIC dynamic inhibition, which was
>> made while trying to fix bugs as much as possible in this area and trying
>> to make the AVIC+SYNIC conditional enablement work.
>>
>> * Patches 1,3-8 are code from Sean Christopherson which
> 
> I mean patches 1,4-8. I forgot about patch 3 which I also added,
> which just added a comment about parameters of the kvm_flush_remote_tlbs_with_address.
> 
> Best regards,
> 	Maxim Levitsky
> 
>>    implement an alternative approach of inhibiting AVIC without
>>    disabling its memslot.
>>
>>    V4: addressed review feedback.
>>
>> * Patch 2 is new and it fixes a bug in kvm_flush_remote_tlbs_with_address
>>
>> * Patches 9-10 in this series fix a race condition which can cause
>>    a lost write from a guest to APIC when the APIC write races
>>    the AVIC un-inhibition, and add a warning to catch this problem
>>    if it re-emerges again.
>>
>>    V4: applied review feedback from Paolo
>>
>> * Patch 11 is the patch from Vitaly about allowing AVIC with SYNC
>>    as long as the guest doesn’t use the AutoEOI feature. I only slightly
>>    changed it to expose the AutoEOI cpuid bit regardless of AVIC enablement.
>>
>>    V4: fixed a race that Paolo pointed out.
>>
>> * Patch 12 is a refactoring that is now possible in SVM AVIC inhibition code,
>>    because the RCU lock is not dropped anymore.
>>
>> * Patch 13-15 fixes another issue I found in AVIC inhibit code:
>>
>>    Currently avic_vcpu_load/avic_vcpu_put are called on userspace entry/exit
>>    from KVM (aka kvm_vcpu_get/kvm_vcpu_put), and these functions update the
>>    "is running" bit in the AVIC physical ID remap table and update the
>>    target vCPU in iommu code.
>>
>>    However both of these functions don't do anything when AVIC is inhibited
>>    thus the "is running" bit will be kept enabled during the exit to userspace.
>>    This shouldn't be a big issue as the caller
>>    doesn't use the AVIC when inhibited but still inconsistent and can trigger
>>    a warning about this in avic_vcpu_load.
>>
>>    To be on the safe side I think it makes sense to call
>>    avic_vcpu_put/avic_vcpu_load when inhibiting/uninhibiting the AVIC.
>>    This will ensure that the work these functions do is matched.
>>
>>    V4: I splitted a single patch to 3 patches to make it easier
>>        to review, and applied Paolo's review feedback.
>>
>> * Patch 16 removes the pointless APIC base
>>    relocation from AVIC to make it consistent with the rest of KVM.
>>
>>    (both AVIC and APICv only support default base, while regular KVM,
>>    sort of support any APIC base as long as it is not RAM.
>>    If guest attempts to relocate APIC base to non RAM area,
>>    while APICv/AVIC are active, the new base will be non accelerated,
>>    while the default base will continue to be AVIC/APICv backed).
>>
>>    On top of that if guest uses different APIC bases on different vCPUs,
>>    KVM doesn't honour the fact that the MMIO range should only be active
>>    on that vCPU.

No problem, b4 diff is my friend. :)  Queued, thanks.

Paolo

