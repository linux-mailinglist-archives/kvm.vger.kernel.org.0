Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 843283F7219
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 11:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237094AbhHYJoc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 05:44:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32737 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234372AbhHYJob (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Aug 2021 05:44:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629884625;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VDB3aoy5vP8AQ/06F9afgv21i9+28hAv1v7LqW0YHDY=;
        b=SQGXVvBiB99lQ2dNono6OgbtvEbwzcJ0wrEMHEV2OsKNTyHrRXuR/YAmI56RUNBWOxLkLt
        4JSPrKb8s1j3+EyUpa3wJHSj7Rkk0KgTkKyLhRPHDJP7P5Jf02I0pvbem+Ss7EU2JHsQbQ
        4FQgct5rTt0q03ISCGFRLA8S2PHuL2g=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-454-VoOv8bSyMna4E9Sv0X9FbQ-1; Wed, 25 Aug 2021 05:43:44 -0400
X-MC-Unique: VoOv8bSyMna4E9Sv0X9FbQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5-20020a1c00050000b02902e67111d9f0so5098740wma.4
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 02:43:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=VDB3aoy5vP8AQ/06F9afgv21i9+28hAv1v7LqW0YHDY=;
        b=MrLx1Cmk49lh9YOZQ8ToAXlQCG4EQtdidyusM8YynjeaCz+VArJKm7fRbXbugKhsv6
         pDS1oyAOjWUiRC+MTruI4VUd9Ll61Du0hP26GomzI/nr8As/jgigOiNDnmYDfnbIkOAx
         xeDaEZ2VhaWRnglDs0b4kNBEsOmo+PknZJr3mePntOe8wPhK4USUBGSwA0Y6YYVCM72e
         vbuw6Cy13hHpLsa3UQOJ83ikS+fEH4sn1IRvIfz4daTKMj1DVdchJz/IrOmXy9NnCNdb
         6VzDuAklY0LtnvGSGtDHRTdJG1HJPTUMvxrVRWhuK+3gfK3ozKnudrt8BfjeCWEgjHIv
         jEBQ==
X-Gm-Message-State: AOAM533N0qcRoih2tNJj3a0zcaJTq8HnTqc3f3VlENeV0yD8DjvOP4QN
        lCMY9mq62zUHNAoKxx6gLzPxLjPjvDiMe3BgfxmIgYAzza0/VOr9ctEEd6KOec0gDxuoyHwzK8n
        wyyNzq6h9tITP
X-Received: by 2002:a7b:c351:: with SMTP id l17mr8464210wmj.120.1629884623224;
        Wed, 25 Aug 2021 02:43:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwTpYUVjyjaViaR9Bny71ISb1iVTVjlxcE78AUpnA73nLcrH/COjHmR9+63GEWBR6NzVBXOKQ==
X-Received: by 2002:a7b:c351:: with SMTP id l17mr8464193wmj.120.1629884622944;
        Wed, 25 Aug 2021 02:43:42 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id g76sm4735096wme.16.2021.08.25.02.43.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 02:43:42 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [PATCH v2 4/4] KVM: x86: Fix stack-out-of-bounds memory access
 from ioapic_write_indirect()
In-Reply-To: <36b6656637d1e6aaa2ab5098f7ebc27644466294.camel@redhat.com>
References: <20210823143028.649818-1-vkuznets@redhat.com>
 <20210823143028.649818-5-vkuznets@redhat.com>
 <20210823185841.ov7ejn2thwebcwqk@habkost.net>
 <87mtp7jowv.fsf@vitty.brq.redhat.com>
 <CAOpTY_ot8teH5x5vVS2HvuMx5LSKLPtyen_ZUM1p7ncci4LFbA@mail.gmail.com>
 <87k0kakip9.fsf@vitty.brq.redhat.com>
 <2df0b6d18115fb7f2701587b7937d8ddae38e36a.camel@redhat.com>
 <87h7fej5ov.fsf@vitty.brq.redhat.com>
 <36b6656637d1e6aaa2ab5098f7ebc27644466294.camel@redhat.com>
Date:   Wed, 25 Aug 2021 11:43:41 +0200
Message-ID: <87bl5lkgfm.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> On Wed, 2021-08-25 at 10:21 +0200, Vitaly Kuznetsov wrote:
>> Maxim Levitsky <mlevitsk@redhat.com> writes:
>> 
>> > On Tue, 2021-08-24 at 16:42 +0200, Vitaly Kuznetsov wrote:
>> ...
>> > Not a classical review but,
>> > I did some digital archaeology with this one, trying to understand what is going on:
>> > 
>> > 
>> > I think that 16 bit vcpu bitmap is due to the fact that IOAPIC spec states that
>> > it can address up to 16 cpus in physical destination mode.
>> >  
>> > In logical destination mode, assuming flat addressing and that logical id = 1 << physical id
>> > which KVM hardcodes, it is also only possible to address 8 CPUs.
>> >  
>> > However(!) in flat cluster mode, the logical apic id is split in two.
>> > We have 16 clusters and each have 4 CPUs, so it is possible to address 64 CPUs,
>> > and unlike the logical ID, the KVM does honour cluster ID, 
>> > thus one can stick say cluster ID 0 to any vCPU.
>> >  
>> >  
>> > Let's look at ioapic_write_indirect.
>> > It does:
>> >  
>> >     -> bitmap_zero(&vcpu_bitmap, 16);
>> >     -> kvm_bitmap_or_dest_vcpus(ioapic->kvm, &irq, &vcpu_bitmap);
>> >     -> kvm_make_scan_ioapic_request_mask(ioapic->kvm, &vcpu_bitmap); // use of the above bitmap
>> >  
>> >  
>> > When we call kvm_bitmap_or_dest_vcpus, we can already overflow the bitmap,
>> > since we pass all 8 bit of the destination even when it is physical.
>> >  
>> >  
>> > Lets examine the kvm_bitmap_or_dest_vcpus:
>> >  
>> >   -> It calls the kvm_apic_map_get_dest_lapic which 
>> >  
>> >        -> for physical destinations, it just sets the bitmap, which can overflow
>> >           if we pass it 8 bit destination (which basically includes reserved bits + 4 bit destination).
>> >  
>> >  
>> >        -> For logical apic ID, it seems to truncate the result to 16 bit, which isn't correct as I explained
>> >           above, but should not overflow the result.
>> >  
>> >   
>> >    -> If call to kvm_apic_map_get_dest_lapic fails, it goes over all vcpus and tries to match the destination
>> >        This can overflow as well.
>> >  
>> >  
>> > I also don't like that ioapic_write_indirect calls the kvm_bitmap_or_dest_vcpus twice,
>> > and second time with 'old_dest_id'
>> >  
>> > I am not 100%  sure why old_dest_id/old_dest_mode are needed as I don't see anything in the
>> > function changing them.
>> > I think only the guest can change them, so maybe the code deals with the guest changing them
>> > while the code is running from a different vcpu?
>> >  
>> > The commit that introduced this code is 7ee30bc132c683d06a6d9e360e39e483e3990708
>> > Nitesh Narayan Lal, maybe you remember something about it?
>> >  
>> 
>> Before posting this patch I've contacted Nitesh privately, he's
>> currently on vacation but will take a look when he gets back.
>> 
>> > Also I worry a lot about other callers of kvm_apic_map_get_dest_lapic
>> >  
>> > It is also called from kvm_irq_delivery_to_apic_fast, and from kvm_intr_is_single_vcpu_fast
>> > and both seem to also use 'unsigned long' for bitmap, and then only use 16 bits of it.
>> >  
>> > I haven't dug into them, but these don't seem to be IOAPIC related and I think
>> > can overwrite the stack as well.
>> 
>> I'm no expert in this code but when writing the patch I somehow
>> convinced myself that a single unsigned long is always enough. I think
>> that for cluster mode 'bitmap' needs 64-bits (and it is *not* a
>> vcpu_bitmap, we need to convert). I may be completely wrong of course
>> but in any case this is a different issue. In ioapic_write_indirect() we
>> have 'vcpu_bitmap' which should certainly be longer than 64 bits.
>
>
> This code which I mentioned in 'other callers' as far as I see is not IOAPIC related.
> For regular local APIC all bets are off, any vCPU and apic ID are possible 
> (xapic I think limits apic id to 255 but x2apic doesn't).
>
> I strongly suspect that this code can overflow as well.

I've probably missed something but I don't see how
kvm_apic_map_get_dest_lapic() can set bits above 64 in 'bitmap'. If it
can, then we have a problem indeed.

-- 
Vitaly

