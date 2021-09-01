Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 658FA3FDDE9
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 16:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245442AbhIAOnK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 10:43:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47949 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234001AbhIAOnK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Sep 2021 10:43:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630507333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ThmvD/LmG/BnOQp3jbI5LkIuE5Ttt/4cAWAFp8apIZo=;
        b=dP5J8FCjoCKyP2TGMX+7PlWOn+WcPj2up3DupRJ/j6KXNZ84vvhAEqxKRY+Z3UM6GRFw8F
        /COHROb6OX14SepzEtoACanGwQylY9L0jeyWfoev69UEhEpDoMiewe8OfcyYGIoXjeSRQ+
        pExA9Aqx8xX/SJt5GkUQwTomAAR2ZbA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-464-5fL2DkBfNZquXorYD0w9XQ-1; Wed, 01 Sep 2021 10:42:11 -0400
X-MC-Unique: 5fL2DkBfNZquXorYD0w9XQ-1
Received: by mail-wr1-f70.google.com with SMTP id d10-20020adffbca000000b00157bc86d94eso847769wrs.20
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 07:42:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ThmvD/LmG/BnOQp3jbI5LkIuE5Ttt/4cAWAFp8apIZo=;
        b=GY6G53xqp9ipkZI/iZ+lJXpUJzTyi4O7lMmrec1eTrQEjHmTaWDKbaQ655jIx9WPgB
         hUxXlqDaJHiN5OYT+CD6yk/bw7po1+dGy8xJ0c80nrStJzLZ6na6+MnG6au3XYaBFuCD
         ZNv/9seJiI1G8L+OGHkRqGD48jPg76okhsP8VURsXkQKDccrveG4jjQVujy6lfcP/i2G
         ILshldgdllH2NVMimP4VlG73mBAnZogMkU3cZr6w5tlWqnk8o88vmsNwjzpzNbFNleS0
         T0Rn0xpF8Pw7ALFdn0YkcW7cltnMfn+aa/fm9wOkSAcV237PqUdX+UJmI1WavaNVmi6Z
         vWrA==
X-Gm-Message-State: AOAM5333LK7zl/Zx053BqMt4HBsDimIWfwSdsq7PH7xgzPDUOvFFlIL5
        c0zbQYlwg6sF981KCK4W8Vy1WRdaDZ158S+sti7N+eATaJPMI5A5BlkJVXkzw74n/zhXQNI4CrN
        JerRKIYSqz3aO
X-Received: by 2002:a1c:a9ce:: with SMTP id s197mr9874150wme.173.1630507330614;
        Wed, 01 Sep 2021 07:42:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwfS2oJ4EaWvcivrt2cFdBj8a1w4oCETq/xC8BT6kKwIPZYwGswnviUIv/R3XDGz0tfdclXTA==
X-Received: by 2002:a1c:a9ce:: with SMTP id s197mr9874124wme.173.1630507330383;
        Wed, 01 Sep 2021 07:42:10 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id q195sm5644030wme.37.2021.09.01.07.42.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 07:42:09 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Igor Mammedov <imammedo@redhat.com>
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH] kvm: x86: Increase MAX_VCPUS to 710
In-Reply-To: <20210901153615.296486b5@redhat.com>
References: <20210831204535.1594297-1-ehabkost@redhat.com>
 <87sfyooh9x.fsf@vitty.brq.redhat.com> <20210901111326.2efecf6e@redhat.com>
 <87ilzkob6k.fsf@vitty.brq.redhat.com> <20210901153615.296486b5@redhat.com>
Date:   Wed, 01 Sep 2021 16:42:08 +0200
Message-ID: <875yvknyrj.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Igor Mammedov <imammedo@redhat.com> writes:

> On Wed, 01 Sep 2021 12:13:55 +0200
> Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
>> Igor Mammedov <imammedo@redhat.com> writes:
>> 
>> > On Wed, 01 Sep 2021 10:02:18 +0200
>> > Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>> >  
>> >> Eduardo Habkost <ehabkost@redhat.com> writes:
>> >>   
>> >> > Support for 710 VCPUs has been tested by Red Hat since RHEL-8.4.
>> >> > Increase KVM_MAX_VCPUS and KVM_SOFT_MAX_VCPUS to 710.
>> >> >
>> >> > For reference, visible effects of changing KVM_MAX_VCPUS are:
>> >> > - KVM_CAP_MAX_VCPUS and KVM_CAP_NR_VCPUS will now return 710 (of course)
>> >> > - Default value for CPUID[HYPERV_CPUID_IMPLEMENT_LIMITS (00x40000005)].EAX
>> >> >   will now be 710
>> >> > - Bitmap stack variables that will grow:
>> >> >   - At kvm_hv_flush_tlb()  kvm_hv_send_ipi():
>> >> >     - Sparse VCPU bitmap (vp_bitmap) will be 96 bytes long
>> >> >     - vcpu_bitmap will be 92 bytes long
>> >> >   - vcpu_bitmap at bioapic_write_indirect() will be 92 bytes long
>> >> >     once patch "KVM: x86: Fix stack-out-of-bounds memory access
>> >> >     from ioapic_write_indirect()" is applied
>> >> >
>> >> > Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
>> >> > ---
>> >> >  arch/x86/include/asm/kvm_host.h | 4 ++--
>> >> >  1 file changed, 2 insertions(+), 2 deletions(-)
>> >> >
>> >> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> >> > index af6ce8d4c86a..f76fae42bf45 100644
>> >> > --- a/arch/x86/include/asm/kvm_host.h
>> >> > +++ b/arch/x86/include/asm/kvm_host.h
>> >> > @@ -37,8 +37,8 @@
>> >> >  
>> >> >  #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
>> >> >  
>> >> > -#define KVM_MAX_VCPUS 288
>> >> > -#define KVM_SOFT_MAX_VCPUS 240
>> >> > +#define KVM_MAX_VCPUS 710    
>> >> 
>> >> Out of pure curiosity, where did 710 came from? Is this some particular
>> >> hardware which was used for testing (weird number btw). Should we maybe
>> >> go to e.g. 1024 for the sake of the beauty of powers of two? :-)
>> >>   
>> >> > +#define KVM_SOFT_MAX_VCPUS 710    
>> >> 
>> >> Do we really need KVM_SOFT_MAX_VCPUS which is equal to KVM_MAX_VCPUS?
>> >> 
>> >> Reading 
>> >> 
>> >> commit 8c3ba334f8588e1d5099f8602cf01897720e0eca
>> >> Author: Sasha Levin <levinsasha928@gmail.com>
>> >> Date:   Mon Jul 18 17:17:15 2011 +0300
>> >> 
>> >>     KVM: x86: Raise the hard VCPU count limit
>> >> 
>> >> the idea behind KVM_SOFT_MAX_VCPUS was to allow developers to test high
>> >> vCPU numbers without claiming such configurations as supported.
>> >> 
>> >> I have two alternative suggestions:
>> >> 1) Drop KVM_SOFT_MAX_VCPUS completely.
>> >> 2) Raise it to a higher number (e.g. 2048)
>> >>   
>> >> >  #define KVM_MAX_VCPU_ID 1023    
>> >> 
>> >> 1023 may not be enough now. I rememeber there was a suggestion to make
>> >> max_vcpus configurable via module parameter and this question was
>> >> raised:
>> >> 
>> >> https://lore.kernel.org/lkml/878s292k75.fsf@vitty.brq.redhat.com/
>> >> 
>> >> TL;DR: to support EPYC-like topologies we need to keep
>> >>  KVM_MAX_VCPU_ID = 4 * KVM_MAX_VCPUS  
>> >
>> > VCPU_ID (sequential 0-n range) is not APIC ID (sparse distribution),
>> > so topology encoded in the later should be orthogonal to VCPU_ID.  
>> 
>> Why do we even have KVM_MAX_VCPU_ID which is != KVM[_SOFT]_MAX_VCPUS
>> then?
> I'd say for compat reasons (8c3ba334f85 KVM: x86: Raise the hard VCPU count limit)
>
> qemu warns users that they are out of recommended (tested) limit when
> it sees requested maxcpus over soft limit.
> See soft_vcpus_limit in qemu.
>

That's the reason why we have KVM_SOFT_MAX_VCPUS in addition to
KVM_MAX_VCPUS, not why we have KVM_MAX_VCPU_ID :-)

>
>> KVM_MAX_VCPU_ID is only checked in kvm_vm_ioctl_create_vcpu() which
>> passes 'id' down to kvm_vcpu_init() which, in its turn, sets
>> 'vcpu->vcpu_id'. This is, for example, returned by kvm_x2apic_id():
>> 
>> static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
>> {
>>         return apic->vcpu->vcpu_id;
>> }
>> 
>> So I'm pretty certain this is actually APIC id and it has topology in
>> it.
> Yep, I mixed it up with cpu_index on QEMU side,
> for x86 it fetches actual apic id and feeds that to kvm when creating vCPU.
>
> It looks like KVM_MAX_VCPU_ID (KVM_SOFT_MAX_VCPUS) is essentially
> MAX_[SOFT_]APIC_ID which in some places is treated as max number of vCPUs,
> so actual max count of vCPUs could be less than that (in case of sparse APIC
> IDs /non power of 2 thread|core|whatever count/).

Yes. To avoid the confusion, I'd suggest we re-define KVM_MAX_VCPU_ID as
something like:

#define KVM_MAX_VCPU_ID_TO_MAX_VCPUS_RATIO 4
#define KVM_MAX_VCPU_ID (KVM_MAX_VCPUS * KVM_MAX_VCPU_ID_TO_MAX_VCPUS_RATIO)

and add a comment about sparse APIC IDs/topology.

-- 
Vitaly

