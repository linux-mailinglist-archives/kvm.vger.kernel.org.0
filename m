Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 476493F87C4
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 14:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242415AbhHZMlq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 08:41:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31580 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242352AbhHZMlp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 08:41:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629981657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xE4xBbQLIWV7pSA9/zwb6K3KpXCBnqyT+k+WD/v2u/M=;
        b=THLzOk1quArlFUrMH0IL//0/grjoN1dDd9RZnYOOKSe/gtMt+iHMiUrV/TrE406bGu+vHZ
        9JpuMYC1FIurkW+Te0dEeM70on9a7qkITO/icXv584o3HEBRxsbHUEIYMTmcGQTeweOrjh
        AwN85UPK4+t5cKp35O/qIWs32z8hoV8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-LSZosnm1Pdecl2vZBAxZ_A-1; Thu, 26 Aug 2021 08:40:56 -0400
X-MC-Unique: LSZosnm1Pdecl2vZBAxZ_A-1
Received: by mail-wm1-f71.google.com with SMTP id b207-20020a1c80d8000000b002ea321114f7so146101wmd.7
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 05:40:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=xE4xBbQLIWV7pSA9/zwb6K3KpXCBnqyT+k+WD/v2u/M=;
        b=OWg3jzQljBtGV1ZNWYsztCJ3GIfU4/ktUi6/YpJm/Rx2OiWg5WgTECWWgv7V0htiJl
         SqYxGL3icbj3KJtMnvvPeCknjzyrf0rUheRpOT9Yluu2m/evzmDgmKUoW6HmOpmrcdHO
         FJSD3O79KfPW1RbPoCfUjJXgr/NuQSpxsy37gUbVSWP8Mei0HpjUK65AsnYjNOQBSLP4
         fMw2+RrnNDPinhzc2ALxWpDzT0jW5g3H44mQYO2SCoG9irIpAxZZk2R99wHZdZLAlDXn
         BlJLk2lzPtSRcBn0oiRqj7mDseDG5xs3Z5nI8rtwkAAAuW6eMIHatXK54c/w/dZ7uCB/
         Ha9A==
X-Gm-Message-State: AOAM531pUyG1Hfezrb7gFYMnC/TU1tFMEfM3z7YSOhQdg4EhXamybjeP
        GDkK8USxp5RRr3WOnvSYwbFSaD3LU6EYNJhLnVURM6TcVGohDv63NkL9CBXyJjhfRaionQE47GS
        MU8cNV125krJV
X-Received: by 2002:a1c:a903:: with SMTP id s3mr3397602wme.171.1629981655033;
        Thu, 26 Aug 2021 05:40:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwEW2HXUzAAS4S009Nj/1sGYBhwxy648FtKoZH/vwgRSBIaxgLTKQJt+096ZSqTxZHPsDd9Ag==
X-Received: by 2002:a1c:a903:: with SMTP id s3mr3397588wme.171.1629981654839;
        Thu, 26 Aug 2021 05:40:54 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id m39sm9332579wms.36.2021.08.26.05.40.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 05:40:54 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Eduardo Habkost <ehabkost@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] KVM: x86: Fix stack-out-of-bounds memory access
 from ioapic_write_indirect()
In-Reply-To: <CAOpTY_q=0cuxXAToJrcqCRERY_sUSB1HNVBVNiEpH6Dsy0-+yA@mail.gmail.com>
References: <20210823143028.649818-1-vkuznets@redhat.com>
 <20210823143028.649818-5-vkuznets@redhat.com>
 <20210823185841.ov7ejn2thwebcwqk@habkost.net>
 <87mtp7jowv.fsf@vitty.brq.redhat.com>
 <CAOpTY_ot8teH5x5vVS2HvuMx5LSKLPtyen_ZUM1p7ncci4LFbA@mail.gmail.com>
 <87k0kakip9.fsf@vitty.brq.redhat.com>
 <2df0b6d18115fb7f2701587b7937d8ddae38e36a.camel@redhat.com>
 <87h7fej5ov.fsf@vitty.brq.redhat.com>
 <36b6656637d1e6aaa2ab5098f7ebc27644466294.camel@redhat.com>
 <87bl5lkgfm.fsf@vitty.brq.redhat.com>
 <CAOpTY_q=0cuxXAToJrcqCRERY_sUSB1HNVBVNiEpH6Dsy0-+yA@mail.gmail.com>
Date:   Thu, 26 Aug 2021 14:40:53 +0200
Message-ID: <87tujcidka.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Eduardo Habkost <ehabkost@redhat.com> writes:

> On Wed, Aug 25, 2021 at 5:43 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>>
>> Maxim Levitsky <mlevitsk@redhat.com> writes:
>>
>> > On Wed, 2021-08-25 at 10:21 +0200, Vitaly Kuznetsov wrote:
>> >> Maxim Levitsky <mlevitsk@redhat.com> writes:
>> >>
>> >> > On Tue, 2021-08-24 at 16:42 +0200, Vitaly Kuznetsov wrote:
>> >> ...
>> >> > Not a classical review but,
>> >> > I did some digital archaeology with this one, trying to understand what is going on:
>> >> >
>> >> >
>> >> > I think that 16 bit vcpu bitmap is due to the fact that IOAPIC spec states that
>> >> > it can address up to 16 cpus in physical destination mode.
>> >> >
>> >> > In logical destination mode, assuming flat addressing and that logical id = 1 << physical id
>> >> > which KVM hardcodes, it is also only possible to address 8 CPUs.
>> >> >
>> >> > However(!) in flat cluster mode, the logical apic id is split in two.
>> >> > We have 16 clusters and each have 4 CPUs, so it is possible to address 64 CPUs,
>> >> > and unlike the logical ID, the KVM does honour cluster ID,
>> >> > thus one can stick say cluster ID 0 to any vCPU.
>> >> >
>> >> >
>> >> > Let's look at ioapic_write_indirect.
>> >> > It does:
>> >> >
>> >> >     -> bitmap_zero(&vcpu_bitmap, 16);
>> >> >     -> kvm_bitmap_or_dest_vcpus(ioapic->kvm, &irq, &vcpu_bitmap);
>> >> >     -> kvm_make_scan_ioapic_request_mask(ioapic->kvm, &vcpu_bitmap); // use of the above bitmap
>> >> >
>> >> >
>> >> > When we call kvm_bitmap_or_dest_vcpus, we can already overflow the bitmap,
>> >> > since we pass all 8 bit of the destination even when it is physical.
>> >> >
>> >> >
>> >> > Lets examine the kvm_bitmap_or_dest_vcpus:
>> >> >
>> >> >   -> It calls the kvm_apic_map_get_dest_lapic which
>> >> >
>> >> >        -> for physical destinations, it just sets the bitmap, which can overflow
>> >> >           if we pass it 8 bit destination (which basically includes reserved bits + 4 bit destination).
>> >> >
>> >> >
>> >> >        -> For logical apic ID, it seems to truncate the result to 16 bit, which isn't correct as I explained
>> >> >           above, but should not overflow the result.
>> >> >
>> >> >
>> >> >    -> If call to kvm_apic_map_get_dest_lapic fails, it goes over all vcpus and tries to match the destination
>> >> >        This can overflow as well.
>> >> >
>> >> >
>> >> > I also don't like that ioapic_write_indirect calls the kvm_bitmap_or_dest_vcpus twice,
>> >> > and second time with 'old_dest_id'
>> >> >
>> >> > I am not 100%  sure why old_dest_id/old_dest_mode are needed as I don't see anything in the
>> >> > function changing them.
>> >> > I think only the guest can change them, so maybe the code deals with the guest changing them
>> >> > while the code is running from a different vcpu?
>> >> >
>> >> > The commit that introduced this code is 7ee30bc132c683d06a6d9e360e39e483e3990708
>> >> > Nitesh Narayan Lal, maybe you remember something about it?
>> >> >
>> >>
>> >> Before posting this patch I've contacted Nitesh privately, he's
>> >> currently on vacation but will take a look when he gets back.
>> >>
>> >> > Also I worry a lot about other callers of kvm_apic_map_get_dest_lapic
>> >> >
>> >> > It is also called from kvm_irq_delivery_to_apic_fast, and from kvm_intr_is_single_vcpu_fast
>> >> > and both seem to also use 'unsigned long' for bitmap, and then only use 16 bits of it.
>> >> >
>> >> > I haven't dug into them, but these don't seem to be IOAPIC related and I think
>> >> > can overwrite the stack as well.
>> >>
>> >> I'm no expert in this code but when writing the patch I somehow
>> >> convinced myself that a single unsigned long is always enough. I think
>> >> that for cluster mode 'bitmap' needs 64-bits (and it is *not* a
>> >> vcpu_bitmap, we need to convert). I may be completely wrong of course
>> >> but in any case this is a different issue. In ioapic_write_indirect() we
>> >> have 'vcpu_bitmap' which should certainly be longer than 64 bits.
>> >
>> >
>> > This code which I mentioned in 'other callers' as far as I see is not IOAPIC related.
>> > For regular local APIC all bets are off, any vCPU and apic ID are possible
>> > (xapic I think limits apic id to 255 but x2apic doesn't).
>> >
>> > I strongly suspect that this code can overflow as well.
>>
>> I've probably missed something but I don't see how
>> kvm_apic_map_get_dest_lapic() can set bits above 64 in 'bitmap'. If it
>> can, then we have a problem indeed.
>
> It would be nice if the compiler took care of validating bitmap sizes
> for us. Shouldn't we make the function prototypes explicit about the
> bitmap sizes they expect?
>
> I believe some `typedef DECLARE_BITMAP(...)` or `typedef struct {
> DECLARE_BITMAP(...) } ...` declarations would be very useful here.

The fundamental problem here is that bitmap in Linux has 'unsigned long
*' type, it's supposed to be accompanied with 'int len' parameter but
it's not always the case.

In KVM, we usually use 'vcpu_bitmap' (or 'dest_vcpu_bitmap') and these
are 'KVM_MAX_VCPUS' long. Just 'bitmap' or 'mask' case is a bit more
complicated. E.g. kvm_apic_map_get_logical_dest() uses 'u16 *mask' and
this means that only 16 bits in the destination are supposed to be
set. kvm_apic_map_get_dest_lapic() uses 'unsigned long *bitmap' - go
figure.

We could've probably used a declaration like you suggest to e.g. create
incompatible 'bitmap16','bitmap64',... types and make the compiler do
the checking but I'm slightly hesitant to introduce such helpers to KVM
and not the whole kernel. Alternatively, we could've just encoded the
length in parameters name, e.g. 

@@ -918,7 +918,7 @@ static bool kvm_apic_is_broadcast_dest(struct kvm *kvm, struct kvm_lapic **src,
 static inline bool kvm_apic_map_get_dest_lapic(struct kvm *kvm,
                struct kvm_lapic **src, struct kvm_lapic_irq *irq,
                struct kvm_apic_map *map, struct kvm_lapic ***dst,
-               unsigned long *bitmap)
+               unsigned long *bitmap64)
 {
        int i, lowest;

-- 
Vitaly

