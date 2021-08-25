Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6730D3F711A
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 10:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239326AbhHYI1l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 04:27:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24353 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231971AbhHYI1j (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Aug 2021 04:27:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629880013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hw2zPmIxOckhD41uqS/X7JqPhnbQ+Fo/eKabxGOh6b8=;
        b=dJo62gZhqniAv0nJEodfTb257a+kx9Hbvn8gHLSOq/uB2HzoJNkhPZfSdQ4+t9dNO1ERyA
        H0CkKjycfBMdS8sP8WrLsNITZ401uioJnwfHHEn5AaF0HxOffi5DFjVSYNnzfP6b6VhsCo
        twWFU1idfzT+HRz3fa/h+nka2ajWXnA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-gpGCLyLEOzyemqtmq4F3Uw-1; Wed, 25 Aug 2021 04:26:46 -0400
X-MC-Unique: gpGCLyLEOzyemqtmq4F3Uw-1
Received: by mail-wr1-f71.google.com with SMTP id n10-20020a5d660a0000b02901551ef5616eso6399772wru.20
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 01:26:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=hw2zPmIxOckhD41uqS/X7JqPhnbQ+Fo/eKabxGOh6b8=;
        b=nGji/Vf0SjZOEm9wtlhZmVe7beCQ/wzDeYQCA8UJYHrwecwVxSeNi2wXfnTDwcyZVg
         KtBxJjU6mnvS8gEBYhaMu12vJWPfGytECBVOUG1NCQzvx1C2c35EKN53kQ4B9+O4HVyY
         fHeN1FOevyjZUftoK4YvHfo00CToZD4tGuywokfdpy3qqK9pnIRKc+yrWJ2Uuf9V7LEG
         Fz1V3bHmzUq+BNPpDq6pJkSAn8R0tIirduzkwA3DIohjVxuMYIQ/wdbzj7r+OQa5xKAN
         I3f5WT+2ysKrueCBCF0Vy1b5QyhqHFB7+1AtVw6/O5kCiHpmDDorBX8NYoNRivafjuPn
         C5kA==
X-Gm-Message-State: AOAM532wURKOHhd2ysbh+CJ4OAVwa+I4neKkqtT6OhKnAmRMnlwUzwWL
        5kPi64A2Z+sJXyv3TXvw3lYSwVRsjPzZdu4idK6p6hJxV8geHwCPqrXbuf1cHyzjtZaPOKD8RGU
        R3DzKMLOwIETY
X-Received: by 2002:adf:c506:: with SMTP id q6mr789736wrf.78.1629880005743;
        Wed, 25 Aug 2021 01:26:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw6A5hiH3U/43h6cOiMSnLit5EgFI1b0pDXuQx1QTuJr31niaj9920rv40BxROGgkMGDI5wDQ==
X-Received: by 2002:adf:c506:: with SMTP id q6mr789715wrf.78.1629880005568;
        Wed, 25 Aug 2021 01:26:45 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id f23sm4484806wmc.3.2021.08.25.01.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 01:26:45 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] KVM: x86: Fix stack-out-of-bounds memory access
 from ioapic_write_indirect()
In-Reply-To: <YSUvESHcms6B3+DA@google.com>
References: <20210823143028.649818-1-vkuznets@redhat.com>
 <20210823143028.649818-5-vkuznets@redhat.com>
 <20210823185841.ov7ejn2thwebcwqk@habkost.net>
 <87mtp7jowv.fsf@vitty.brq.redhat.com>
 <CAOpTY_ot8teH5x5vVS2HvuMx5LSKLPtyen_ZUM1p7ncci4LFbA@mail.gmail.com>
 <87k0kakip9.fsf@vitty.brq.redhat.com>
 <2df0b6d18115fb7f2701587b7937d8ddae38e36a.camel@redhat.com>
 <YSUvESHcms6B3+DA@google.com>
Date:   Wed, 25 Aug 2021 10:26:44 +0200
Message-ID: <87eeaij5ff.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Aug 24, 2021, Maxim Levitsky wrote:
>> On Tue, 2021-08-24 at 16:42 +0200, Vitaly Kuznetsov wrote:
>> > Eduardo Habkost <ehabkost@redhat.com> writes:
>> > 
>> > > On Tue, Aug 24, 2021 at 3:13 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>> > > > Eduardo Habkost <ehabkost@redhat.com> writes:
>> > > > 
>> > > > > On Mon, Aug 23, 2021 at 04:30:28PM +0200, Vitaly Kuznetsov wrote:
>> > > > > > diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
>> > > > > > index ff005fe738a4..92cd4b02e9ba 100644
>> > > > > > --- a/arch/x86/kvm/ioapic.c
>> > > > > > +++ b/arch/x86/kvm/ioapic.c
>> > > > > > @@ -319,7 +319,7 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
>> > > > > >      unsigned index;
>> > > > > >      bool mask_before, mask_after;
>> > > > > >      union kvm_ioapic_redirect_entry *e;
>> > > > > > -    unsigned long vcpu_bitmap;
>> > > > > > +    unsigned long vcpu_bitmap[BITS_TO_LONGS(KVM_MAX_VCPUS)];
>
> The preferred pattern is:
>
> 	DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);
>

Yes, thanks!

>> > > > > 
>> > > > > Is there a way to avoid this KVM_MAX_VCPUS-sized variable on the
>> > > > > stack?  This might hit us back when we increase KVM_MAX_VCPUS to
>> > > > > a few thousand VCPUs (I was planning to submit a patch for that
>> > > > > soon).
>> > > > 
>> > > > What's the short- or mid-term target?
>> > > 
>> > > Short term target is 2048 (which was already tested). Mid-term target
>> > > (not tested yet) is 4096, maybe 8192.
>> > > 
>> > > > Note, we're allocating KVM_MAX_VCPUS bits (not bytes!) here, this means
>> > > > that for e.g. 2048 vCPUs we need 256 bytes of the stack only. In case
>> > > > the target much higher than that, we will need to either switch to
>> > > > dynamic allocation or e.g. use pre-allocated per-CPU variables and make
>> > > > this a preempt-disabled region. I, however, would like to understand if
>> > > > the problem with allocating this from stack is real or not first.
>> > > 
>> > > Is 256 bytes too much here, or would that be OK?
>> > > 
>> > 
>> > AFAIR, on x86_64 stack size (both reqular and irq) is 16k, eating 256
>
> Don't forget i386!  :-)
>

I'm not forgetting, I'm deliberately ignoring its existence :-)

Whoever tries to raise KVM_MAX_VCPUS from '288' may limit the change to
x86_64, I seriosly doubt 32bit users want to run guests with thouthands
of CPUs.

>> > bytes of it is probably OK. I'd start worrying when we go to 1024 (8k
>> > vCPUs) and above (but this is subjective of course).
>
> 256 is fine, 1024 would indeed be problematic, e.g. CONFIG_FRAME_WARN defaults to
> 1024 on 32-bit kernels.  That's not a hard limit per se, but ideally KVM will stay
> warn-free on all flavors of x86.

Thanks for the CONFIG_FRAME_WARN pointer, I said '1024' out of top of my
head but it seems the number wasn't random after all)

>
>> On the topic of enlarging these bitmaps to cover all vCPUs.
>> 
>> I also share the worry of having the whole bitmap on kernel stack for very
>> large number of vcpus.
>> Maybe we need to abstract and use a bitmap for a sane number of vcpus, 
>> and use otherwise a 'kmalloc'ed buffer?
>
> That's a future problem.  More specifically, it's the problem of whoever wants to
> push KVM_MAX_VCPUS > ~2048.  There are a lot of ways to solve the problem, e.g.
> this I/O APIC code runs under a spinlock so a dedicated bitmap in struct kvm_ioapic
> could be used to avoid a large stack allocation.

+1

>
>> Also in theory large bitmaps might affect performance a bit.
>
> Maybe.  The only possible degredation for small VMs, i.e. VMs that don't need the
> full bitmap, is if the compiler puts other variables below the bitmap and causes
> sub-optimal cache line usage.  But I suspect/hope the compiler is smart enough to
> use GPRs and/or organize the local variables on the stack so that doesn't happen.
>

-- 
Vitaly

