Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B86E3FDD54
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 15:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244250AbhIANhS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 09:37:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34056 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244220AbhIANhR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Sep 2021 09:37:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630503380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9GJaak9/fukjOpM3yRsW6fGYLPWlO2ujAk6t2MGMTZ0=;
        b=hRpc52h/JwhGFSQbIJv8UZHOXhaSHKrZLQd+8iJPeZJCKD5yhONOiYbO1GZ/hgk+61oONi
        4n6UF46VrqEhZ6cZcmBIK+Fx9voA8V1wutdHW5LIrbCEJRvuP4TYcuJrkHqQVPxxLVxmxd
        Ip7Y4dBqzimhzar8jUHwzue2dksi2dQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-hT-nol8_PPu5LI3qlRmxZw-1; Wed, 01 Sep 2021 09:36:19 -0400
X-MC-Unique: hT-nol8_PPu5LI3qlRmxZw-1
Received: by mail-wm1-f70.google.com with SMTP id a201-20020a1c7fd2000000b002e748bf0544so2847831wmd.2
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 06:36:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9GJaak9/fukjOpM3yRsW6fGYLPWlO2ujAk6t2MGMTZ0=;
        b=I9ksJiMRqeROSeopoSlMavnLaPcIscbTCrL8qalMars2VOOc5xW+HgUde5D1WCnx2o
         lXutD47S6w0BX/hFqJYgdTYXKIG+zhcZ31BTQXVPRK3eifWKOqC9lnaHBGT38vuDMdPM
         oDtaJlrE3CYCppm9F8i+q9Qv9WqD7fr7HA8XmGIszqzc5dCooV4nnCyy0ozehTQwmaWG
         PjbzzgW8yS0z8Y3tUNLXcGXhSDw54D5lXH553Igfamb5NvsYMoSHppJQyoaM7EL3q0AP
         gbNZvoukKCE/n7t64G0wqSpAKitcZmBH2ca//2RFrMtqYUkPNjUlUsotiDlsC4J7nX/0
         4Xsg==
X-Gm-Message-State: AOAM531bdXywIIb6ck3fjP0IyiAJXfWXztfdb3U1ffHxwG3p2NzWsAyU
        iaT3GP+DoGo3EhSiYsuQM35JwEMtVNbEWuFAEU1AzZV3DQ9teAOjv11wdx/Hmv8VkmaF42x5pCX
        Hv7Z421BmjHg/
X-Received: by 2002:a1c:7e4e:: with SMTP id z75mr9920133wmc.152.1630503377756;
        Wed, 01 Sep 2021 06:36:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy2PrBs83QLdQi2i0EsAHORE+4iG6+VIDnZzcPrknaDnG/lVnaLhQmJdaJ69STVkPWx7ZwjRA==
X-Received: by 2002:a1c:7e4e:: with SMTP id z75mr9920096wmc.152.1630503377420;
        Wed, 01 Sep 2021 06:36:17 -0700 (PDT)
Received: from localhost (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id s1sm15576413wrs.53.2021.09.01.06.36.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 06:36:16 -0700 (PDT)
Date:   Wed, 1 Sep 2021 15:36:15 +0200
From:   Igor Mammedov <imammedo@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH] kvm: x86: Increase MAX_VCPUS to 710
Message-ID: <20210901153615.296486b5@redhat.com>
In-Reply-To: <87ilzkob6k.fsf@vitty.brq.redhat.com>
References: <20210831204535.1594297-1-ehabkost@redhat.com>
        <87sfyooh9x.fsf@vitty.brq.redhat.com>
        <20210901111326.2efecf6e@redhat.com>
        <87ilzkob6k.fsf@vitty.brq.redhat.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 01 Sep 2021 12:13:55 +0200
Vitaly Kuznetsov <vkuznets@redhat.com> wrote:

> Igor Mammedov <imammedo@redhat.com> writes:
> 
> > On Wed, 01 Sep 2021 10:02:18 +0200
> > Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> >  
> >> Eduardo Habkost <ehabkost@redhat.com> writes:
> >>   
> >> > Support for 710 VCPUs has been tested by Red Hat since RHEL-8.4.
> >> > Increase KVM_MAX_VCPUS and KVM_SOFT_MAX_VCPUS to 710.
> >> >
> >> > For reference, visible effects of changing KVM_MAX_VCPUS are:
> >> > - KVM_CAP_MAX_VCPUS and KVM_CAP_NR_VCPUS will now return 710 (of course)
> >> > - Default value for CPUID[HYPERV_CPUID_IMPLEMENT_LIMITS (00x40000005)].EAX
> >> >   will now be 710
> >> > - Bitmap stack variables that will grow:
> >> >   - At kvm_hv_flush_tlb()  kvm_hv_send_ipi():
> >> >     - Sparse VCPU bitmap (vp_bitmap) will be 96 bytes long
> >> >     - vcpu_bitmap will be 92 bytes long
> >> >   - vcpu_bitmap at bioapic_write_indirect() will be 92 bytes long
> >> >     once patch "KVM: x86: Fix stack-out-of-bounds memory access
> >> >     from ioapic_write_indirect()" is applied
> >> >
> >> > Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
> >> > ---
> >> >  arch/x86/include/asm/kvm_host.h | 4 ++--
> >> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >> >
> >> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> >> > index af6ce8d4c86a..f76fae42bf45 100644
> >> > --- a/arch/x86/include/asm/kvm_host.h
> >> > +++ b/arch/x86/include/asm/kvm_host.h
> >> > @@ -37,8 +37,8 @@
> >> >  
> >> >  #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
> >> >  
> >> > -#define KVM_MAX_VCPUS 288
> >> > -#define KVM_SOFT_MAX_VCPUS 240
> >> > +#define KVM_MAX_VCPUS 710    
> >> 
> >> Out of pure curiosity, where did 710 came from? Is this some particular
> >> hardware which was used for testing (weird number btw). Should we maybe
> >> go to e.g. 1024 for the sake of the beauty of powers of two? :-)
> >>   
> >> > +#define KVM_SOFT_MAX_VCPUS 710    
> >> 
> >> Do we really need KVM_SOFT_MAX_VCPUS which is equal to KVM_MAX_VCPUS?
> >> 
> >> Reading 
> >> 
> >> commit 8c3ba334f8588e1d5099f8602cf01897720e0eca
> >> Author: Sasha Levin <levinsasha928@gmail.com>
> >> Date:   Mon Jul 18 17:17:15 2011 +0300
> >> 
> >>     KVM: x86: Raise the hard VCPU count limit
> >> 
> >> the idea behind KVM_SOFT_MAX_VCPUS was to allow developers to test high
> >> vCPU numbers without claiming such configurations as supported.
> >> 
> >> I have two alternative suggestions:
> >> 1) Drop KVM_SOFT_MAX_VCPUS completely.
> >> 2) Raise it to a higher number (e.g. 2048)
> >>   
> >> >  #define KVM_MAX_VCPU_ID 1023    
> >> 
> >> 1023 may not be enough now. I rememeber there was a suggestion to make
> >> max_vcpus configurable via module parameter and this question was
> >> raised:
> >> 
> >> https://lore.kernel.org/lkml/878s292k75.fsf@vitty.brq.redhat.com/
> >> 
> >> TL;DR: to support EPYC-like topologies we need to keep
> >>  KVM_MAX_VCPU_ID = 4 * KVM_MAX_VCPUS  
> >
> > VCPU_ID (sequential 0-n range) is not APIC ID (sparse distribution),
> > so topology encoded in the later should be orthogonal to VCPU_ID.  
> 
> Why do we even have KVM_MAX_VCPU_ID which is != KVM[_SOFT]_MAX_VCPUS
> then?
I'd say for compat reasons (8c3ba334f85 KVM: x86: Raise the hard VCPU count limit)

qemu warns users that they are out of recommended (tested) limit when
it sees requested maxcpus over soft limit.
See soft_vcpus_limit in qemu.


> KVM_MAX_VCPU_ID is only checked in kvm_vm_ioctl_create_vcpu() which
> passes 'id' down to kvm_vcpu_init() which, in its turn, sets
> 'vcpu->vcpu_id'. This is, for example, returned by kvm_x2apic_id():
> 
> static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
> {
>         return apic->vcpu->vcpu_id;
> }
> 
> So I'm pretty certain this is actually APIC id and it has topology in
> it.
Yep, I mixed it up with cpu_index on QEMU side,
for x86 it fetches actual apic id and feeds that to kvm when creating vCPU.

It looks like KVM_MAX_VCPU_ID (KVM_SOFT_MAX_VCPUS) is essentially
MAX_[SOFT_]APIC_ID which in some places is treated as max number of vCPUs,
so actual max count of vCPUs could be less than that (in case of sparse APIC
IDs /non power of 2 thread|core|whatever count/).




