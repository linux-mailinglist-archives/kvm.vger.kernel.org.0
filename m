Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7D63FD644
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 11:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243449AbhIAJO1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 05:14:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59927 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243285AbhIAJO1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Sep 2021 05:14:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630487610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JFfsdp0moBSobvmRxa50MBuZjWDZuZXxaOD7vKTHwFw=;
        b=PutGUoidLyGC2rP/rjVI+7BOyJyvpSSrQ0AWJ6kPQ5Twh0Yxt3jHavcrsYxpo+lN5gtZf5
        Dfy0s3W0Ig3pzpAjhtY0/C8vJNnmmuRzjZUSSn6dWDLzyoz7XqThq9yvMNDuORqD9T1Ocd
        ivNwulLs9THTjdRvAHz+G6UXjWuP0gI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-383-c54jstO0P8e78aZkKiRY3A-1; Wed, 01 Sep 2021 05:13:29 -0400
X-MC-Unique: c54jstO0P8e78aZkKiRY3A-1
Received: by mail-wm1-f69.google.com with SMTP id s197-20020a1ca9ce000000b002e72ba822dcso2531671wme.6
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 02:13:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JFfsdp0moBSobvmRxa50MBuZjWDZuZXxaOD7vKTHwFw=;
        b=WhIT0BynKguLFiZ83rBTULHRAMDdO0Sx1KZbwZQ9SwEZzSlN22G+NTY1Pud+/xRlvl
         xI4k5uj3Nj5vrLQliSkCW4XaJjPsT9bw6eQtrnlTSRicwjQ+5fNql+DNZBh/eD7TAwJZ
         XDPkJ82dE3zmWUkWP2+cFNFDH0pzf8RJGvxsVtJSXVoum4RaKryZ4/8OC2cTE/G/jxKi
         Up7SwsTLBcoSuLg/HUxVGJQe9peCPaeBhnqOH9G5GmSaizMDjS9qke9nEoDeYwTNdJLi
         WpqjBhSgOiATLfq50PywtpJ7Iw8590UiKVbpcfcvqoRw+hJW0DhWLyEhVrMT4yl7rQe5
         sJQg==
X-Gm-Message-State: AOAM5303nziCm2e4sdOqnAxsZaifiKSBofsRhgwwqSULhO5ANCAW9wPG
        dBYM0+bBHvYf/m15sK+BcpOurMAjdzjAlSEkayMA9ci9NPbjL/tDald+saz5BMumf2dP2jXSI7A
        F8W1RWBzRBiyD
X-Received: by 2002:a7b:cc85:: with SMTP id p5mr8752542wma.42.1630487608012;
        Wed, 01 Sep 2021 02:13:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzN5uhosl/g8BsU95QIeOxgUPXZLSUnfsagYqzdilII9el1VFGZtDLe5ZLLY0YEM5zDbmbtuQ==
X-Received: by 2002:a7b:cc85:: with SMTP id p5mr8752525wma.42.1630487607833;
        Wed, 01 Sep 2021 02:13:27 -0700 (PDT)
Received: from localhost (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id z137sm5388181wmc.14.2021.09.01.02.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 02:13:27 -0700 (PDT)
Date:   Wed, 1 Sep 2021 11:13:26 +0200
From:   Igor Mammedov <imammedo@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH] kvm: x86: Increase MAX_VCPUS to 710
Message-ID: <20210901111326.2efecf6e@redhat.com>
In-Reply-To: <87sfyooh9x.fsf@vitty.brq.redhat.com>
References: <20210831204535.1594297-1-ehabkost@redhat.com>
        <87sfyooh9x.fsf@vitty.brq.redhat.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 01 Sep 2021 10:02:18 +0200
Vitaly Kuznetsov <vkuznets@redhat.com> wrote:

> Eduardo Habkost <ehabkost@redhat.com> writes:
> 
> > Support for 710 VCPUs has been tested by Red Hat since RHEL-8.4.
> > Increase KVM_MAX_VCPUS and KVM_SOFT_MAX_VCPUS to 710.
> >
> > For reference, visible effects of changing KVM_MAX_VCPUS are:
> > - KVM_CAP_MAX_VCPUS and KVM_CAP_NR_VCPUS will now return 710 (of course)
> > - Default value for CPUID[HYPERV_CPUID_IMPLEMENT_LIMITS (00x40000005)].EAX
> >   will now be 710
> > - Bitmap stack variables that will grow:
> >   - At kvm_hv_flush_tlb()  kvm_hv_send_ipi():
> >     - Sparse VCPU bitmap (vp_bitmap) will be 96 bytes long
> >     - vcpu_bitmap will be 92 bytes long
> >   - vcpu_bitmap at bioapic_write_indirect() will be 92 bytes long
> >     once patch "KVM: x86: Fix stack-out-of-bounds memory access
> >     from ioapic_write_indirect()" is applied
> >
> > Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index af6ce8d4c86a..f76fae42bf45 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -37,8 +37,8 @@
> >  
> >  #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
> >  
> > -#define KVM_MAX_VCPUS 288
> > -#define KVM_SOFT_MAX_VCPUS 240
> > +#define KVM_MAX_VCPUS 710  
> 
> Out of pure curiosity, where did 710 came from? Is this some particular
> hardware which was used for testing (weird number btw). Should we maybe
> go to e.g. 1024 for the sake of the beauty of powers of two? :-)
> 
> > +#define KVM_SOFT_MAX_VCPUS 710  
> 
> Do we really need KVM_SOFT_MAX_VCPUS which is equal to KVM_MAX_VCPUS?
> 
> Reading 
> 
> commit 8c3ba334f8588e1d5099f8602cf01897720e0eca
> Author: Sasha Levin <levinsasha928@gmail.com>
> Date:   Mon Jul 18 17:17:15 2011 +0300
> 
>     KVM: x86: Raise the hard VCPU count limit
> 
> the idea behind KVM_SOFT_MAX_VCPUS was to allow developers to test high
> vCPU numbers without claiming such configurations as supported.
> 
> I have two alternative suggestions:
> 1) Drop KVM_SOFT_MAX_VCPUS completely.
> 2) Raise it to a higher number (e.g. 2048)
> 
> >  #define KVM_MAX_VCPU_ID 1023  
> 
> 1023 may not be enough now. I rememeber there was a suggestion to make
> max_vcpus configurable via module parameter and this question was
> raised:
> 
> https://lore.kernel.org/lkml/878s292k75.fsf@vitty.brq.redhat.com/
> 
> TL;DR: to support EPYC-like topologies we need to keep
>  KVM_MAX_VCPU_ID = 4 * KVM_MAX_VCPUS

VCPU_ID (sequential 0-n range) is not APIC ID (sparse distribution),
so topology encoded in the later should be orthogonal to VCPU_ID.

> >  /* memory slots that are not exposed to userspace */
> >  #define KVM_PRIVATE_MEM_SLOTS 3  
> 

