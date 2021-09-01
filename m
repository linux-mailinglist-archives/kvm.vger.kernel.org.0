Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 701353FD76D
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 12:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232819AbhIAKO5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 06:14:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52822 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232258AbhIAKO4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Sep 2021 06:14:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630491239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6Xhqwxajqw0bB7EMsnxFVtWq78wNvOTmsrxkbIXy3c4=;
        b=b6kitShZD8zhjaBSHeATZzxKhJcb+nHe3juAK64n2VFHVWqc4zo2/V6cogcCYSb/W46XIm
        zSjhjQH9BAdPTZ/38d9zrZf4S8TphPC7m/PIICZCiLMCV+c/BO8L5p4gDTzXM5bKk9tQYw
        XhhQHy7pqANr9+QT/OlLJOtXYCq1RMw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-Q9sb9MG1N0KLrufjW-g8hQ-1; Wed, 01 Sep 2021 06:13:58 -0400
X-MC-Unique: Q9sb9MG1N0KLrufjW-g8hQ-1
Received: by mail-wr1-f72.google.com with SMTP id h14-20020a056000000e00b001575b00eb08so611835wrx.13
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 03:13:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=6Xhqwxajqw0bB7EMsnxFVtWq78wNvOTmsrxkbIXy3c4=;
        b=eUkGmD7VkinPcAECtAGZ80NoOSMypZkRN5OIjPMpDlMqm4Aq7EG8Gl3AbNvRCwggC7
         vxBu8AyBdG1pRrrwFCCvoSutodNb0PK15IrNYrVMqbStwEvpAZFm3MCwXwnL9fsijkRH
         G5sPDGZ1eg+Sjxi4bMTBBSkGLsj77uExCYm3qie3+mycSVBUTb7zDmJlfu3CshVFyJd5
         E8TO/XIE3TbN3aR/kW+0EawHjTqekVjDRRKgSDjVR3ToAAUttw97qioUjFzQW3sV5qWz
         3BWrhBer/RoZgLAKBLyY2GTAfOOud908jwbHy4GZNEVHsH4ZMM566hCmz0B1p7kly+iL
         Q97Q==
X-Gm-Message-State: AOAM5309h/GR26ASnTaZmB4QHAlKYYItu/eqh0Hnzf6m23Lsm8T8io7X
        87XEfLh6fVMKmSyE1cFTR4eDlZKEOUy1caT5V6DiAN/Y5UPKZLjACW0i3rXJxt7qX1wWGspG1Hs
        90WYDlU+xpMFO
X-Received: by 2002:a05:600c:230c:: with SMTP id 12mr8905967wmo.41.1630491237322;
        Wed, 01 Sep 2021 03:13:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwq5cIMX75slmoFWnEm9AA+yLh1uSyJ7JThTl4wi3kQ9KjhcBMBzMwNRwVvaOcfMq6C15ZGqA==
X-Received: by 2002:a05:600c:230c:: with SMTP id 12mr8905950wmo.41.1630491237110;
        Wed, 01 Sep 2021 03:13:57 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id o23sm9347859wro.76.2021.09.01.03.13.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 03:13:56 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Igor Mammedov <imammedo@redhat.com>
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH] kvm: x86: Increase MAX_VCPUS to 710
In-Reply-To: <20210901111326.2efecf6e@redhat.com>
References: <20210831204535.1594297-1-ehabkost@redhat.com>
 <87sfyooh9x.fsf@vitty.brq.redhat.com> <20210901111326.2efecf6e@redhat.com>
Date:   Wed, 01 Sep 2021 12:13:55 +0200
Message-ID: <87ilzkob6k.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Igor Mammedov <imammedo@redhat.com> writes:

> On Wed, 01 Sep 2021 10:02:18 +0200
> Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
>> Eduardo Habkost <ehabkost@redhat.com> writes:
>> 
>> > Support for 710 VCPUs has been tested by Red Hat since RHEL-8.4.
>> > Increase KVM_MAX_VCPUS and KVM_SOFT_MAX_VCPUS to 710.
>> >
>> > For reference, visible effects of changing KVM_MAX_VCPUS are:
>> > - KVM_CAP_MAX_VCPUS and KVM_CAP_NR_VCPUS will now return 710 (of course)
>> > - Default value for CPUID[HYPERV_CPUID_IMPLEMENT_LIMITS (00x40000005)].EAX
>> >   will now be 710
>> > - Bitmap stack variables that will grow:
>> >   - At kvm_hv_flush_tlb()  kvm_hv_send_ipi():
>> >     - Sparse VCPU bitmap (vp_bitmap) will be 96 bytes long
>> >     - vcpu_bitmap will be 92 bytes long
>> >   - vcpu_bitmap at bioapic_write_indirect() will be 92 bytes long
>> >     once patch "KVM: x86: Fix stack-out-of-bounds memory access
>> >     from ioapic_write_indirect()" is applied
>> >
>> > Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
>> > ---
>> >  arch/x86/include/asm/kvm_host.h | 4 ++--
>> >  1 file changed, 2 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> > index af6ce8d4c86a..f76fae42bf45 100644
>> > --- a/arch/x86/include/asm/kvm_host.h
>> > +++ b/arch/x86/include/asm/kvm_host.h
>> > @@ -37,8 +37,8 @@
>> >  
>> >  #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
>> >  
>> > -#define KVM_MAX_VCPUS 288
>> > -#define KVM_SOFT_MAX_VCPUS 240
>> > +#define KVM_MAX_VCPUS 710  
>> 
>> Out of pure curiosity, where did 710 came from? Is this some particular
>> hardware which was used for testing (weird number btw). Should we maybe
>> go to e.g. 1024 for the sake of the beauty of powers of two? :-)
>> 
>> > +#define KVM_SOFT_MAX_VCPUS 710  
>> 
>> Do we really need KVM_SOFT_MAX_VCPUS which is equal to KVM_MAX_VCPUS?
>> 
>> Reading 
>> 
>> commit 8c3ba334f8588e1d5099f8602cf01897720e0eca
>> Author: Sasha Levin <levinsasha928@gmail.com>
>> Date:   Mon Jul 18 17:17:15 2011 +0300
>> 
>>     KVM: x86: Raise the hard VCPU count limit
>> 
>> the idea behind KVM_SOFT_MAX_VCPUS was to allow developers to test high
>> vCPU numbers without claiming such configurations as supported.
>> 
>> I have two alternative suggestions:
>> 1) Drop KVM_SOFT_MAX_VCPUS completely.
>> 2) Raise it to a higher number (e.g. 2048)
>> 
>> >  #define KVM_MAX_VCPU_ID 1023  
>> 
>> 1023 may not be enough now. I rememeber there was a suggestion to make
>> max_vcpus configurable via module parameter and this question was
>> raised:
>> 
>> https://lore.kernel.org/lkml/878s292k75.fsf@vitty.brq.redhat.com/
>> 
>> TL;DR: to support EPYC-like topologies we need to keep
>>  KVM_MAX_VCPU_ID = 4 * KVM_MAX_VCPUS
>
> VCPU_ID (sequential 0-n range) is not APIC ID (sparse distribution),
> so topology encoded in the later should be orthogonal to VCPU_ID.

Why do we even have KVM_MAX_VCPU_ID which is != KVM[_SOFT]_MAX_VCPUS
then?

KVM_MAX_VCPU_ID is only checked in kvm_vm_ioctl_create_vcpu() which
passes 'id' down to kvm_vcpu_init() which, in its turn, sets
'vcpu->vcpu_id'. This is, for example, returned by kvm_x2apic_id():

static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
{
        return apic->vcpu->vcpu_id;
}

So I'm pretty certain this is actually APIC id and it has topology in
it.

-- 
Vitaly

