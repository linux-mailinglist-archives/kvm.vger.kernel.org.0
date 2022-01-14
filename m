Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5A7E48E78B
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 10:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233789AbiANJbz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 04:31:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23369 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230104AbiANJbz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 04:31:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642152714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4HBgz8OwU/mU5OrM0Gwxwm6qrWMg9a0UmRfWZIj1Z94=;
        b=QyBYN2rdmsF8AKokTmKgdpnuxaXioB5OvSzj+e9d5I6CTPeIAIH1f/Kk9yi9Fpv7t83wV0
        uKOtzyCu3t3m6C1nknA5NxunpfDgAgaZeVa35AMIQPQX5eyQYMuNQqKrtkkclMx0GtA7Eh
        V1/6yQ3KEw+wCo64ZUmnmiHj87rhiAE=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-582-mUVgo3FaNC2-rwUoP1-zaA-1; Fri, 14 Jan 2022 04:31:53 -0500
X-MC-Unique: mUVgo3FaNC2-rwUoP1-zaA-1
Received: by mail-ed1-f70.google.com with SMTP id m8-20020a056402510800b003f9d22c4d48so7845426edd.21
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 01:31:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=4HBgz8OwU/mU5OrM0Gwxwm6qrWMg9a0UmRfWZIj1Z94=;
        b=b3xozfyulAjGQYMEz29Vz8Sjogzt2heqUa0ppWQ6/UGzVNXxDhHkaK0E7eEe7arCLU
         GqEzwR8LGsVDzyOETXqMvqLUfeCW+B+Cu6csHeqG2Z09TEYD/E6EXkRV7rd5vmu2tPlk
         5Z6hzPRmR3NrTeSmA4hL8BcI0GIboWlfIS4ccCg44hngDcFwV2xo+u0i7nqga3TAIkoy
         BN+tnP9PYAGfNgvgSHdQ5D7sDKCtcYGaV0vvBw+X284NCAYqH5aMGTYfT7ni4wWMhdxK
         Igj64WD0pHC9YnaTxHTBeTJFvX4VDticjbuzs5BN/DmWMV98QyvVQURZ2q95Lh1ZlCDp
         PGOQ==
X-Gm-Message-State: AOAM532T9w3Eu5g9zX5vZCLPymFyF7B/zLI369j5n1ZMYnXbgq1KrFAv
        +BtFK08QDYZ17MzFU9w7d/w75DB5L1yU+du2qnh5l2tL5XGbmcBXcIf6Flep2hPKZ557NZH7XdT
        aeHf2rSHtRgr1
X-Received: by 2002:a17:906:12c7:: with SMTP id l7mr6547780ejb.648.1642152711980;
        Fri, 14 Jan 2022 01:31:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyB+u9F0i5ZOwZvvAmolu1OmUAo0EEgaS2J8+AhnOUmWoFgW41SQ+6okJCPoKrUBsp8FewU7w==
X-Received: by 2002:a17:906:12c7:: with SMTP id l7mr6547769ejb.648.1642152711768;
        Fri, 14 Jan 2022 01:31:51 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id hq29sm1720490ejc.141.2022.01.14.01.31.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 01:31:51 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Igor Mammedov <imammedo@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 2/2] KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN
In-Reply-To: <20220114095535.0f498707@redhat.com>
References: <20211122175818.608220-1-vkuznets@redhat.com>
 <20211122175818.608220-3-vkuznets@redhat.com>
 <16368a89-99ea-e52c-47b6-bd006933ec1f@redhat.com>
 <20211227183253.45a03ca2@redhat.com>
 <61325b2b-dc93-5db2-2d0a-dd0900d947f2@redhat.com>
 <87mtkdqm7m.fsf@redhat.com> <20220103104057.4dcf7948@redhat.com>
 <YeCowpPBEHC6GJ59@google.com> <20220114095535.0f498707@redhat.com>
Date:   Fri, 14 Jan 2022 10:31:50 +0100
Message-ID: <87ilummznd.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Igor Mammedov <imammedo@redhat.com> writes:

> On Thu, 13 Jan 2022 22:33:38 +0000
> Sean Christopherson <seanjc@google.com> wrote:
>
>> On Mon, Jan 03, 2022, Igor Mammedov wrote:
>> > On Mon, 03 Jan 2022 09:04:29 +0100
>> > Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>> >   
>> > > Paolo Bonzini <pbonzini@redhat.com> writes:
>> > >   
>> > > > On 12/27/21 18:32, Igor Mammedov wrote:    
>> > > >>> Tweaked and queued nevertheless, thanks.    
>> > > >> it seems this patch breaks VCPU hotplug, in scenario:
>> > > >> 
>> > > >>    1. hotunplug existing VCPU (QEMU stores VCPU file descriptor in parked cpus list)
>> > > >>    2. hotplug it again (unsuspecting QEMU reuses stored file descriptor when recreating VCPU)
>> > > >> 
>> > > >> RHBZ:https://bugzilla.redhat.com/show_bug.cgi?id=2028337#c11
>> > > >>     
>> > > >
>> > > > The fix here would be (in QEMU) to not call KVM_SET_CPUID2 again. 
>> > > > However, we need to work around it in KVM, and allow KVM_SET_CPUID2 if 
>> > > > the data passed to the ioctl is the same that was set before.    
>> > > 
>> > > Are we sure the data is going to be *exactly* the same? In particular,
>> > > when using vCPU fds from the parked list, do we keep the same
>> > > APIC/x2APIC id when hotplugging? Or can we actually hotplug with a
>> > > different id?  
>> > 
>> > If I recall it right, it can be a different ID easily.  
>> 
>> No, it cannot.  KVM doesn't provide a way for userspace to change the APIC ID of
>> a vCPU after the vCPU is created.  x2APIC flat out disallows changing the APIC ID,
>> and unless there's magic I'm missing, apic_mmio_write() => kvm_lapic_reg_write()
>> is not reachable from userspace.
>> 
>> The only way for userspace to set the APIC ID is to change vcpu->vcpu_id, and that
>> can only be done at KVM_VCPU_CREATE.
>> 
>> So, reusing a parked vCPU for hotplug must reuse the same APIC ID.  QEMU handles
>> this by stashing the vcpu_id, a.k.a. APIC ID, when parking a vCPU, and reuses a
>> parked vCPU if and only if it has the same APIC ID.  And because QEMU derives the
>> APIC ID from topology, that means all the topology CPUID leafs must remain the
>> same, otherwise the guest is hosed because it will send IPIs to the wrong vCPUs.
>
> Indeed, I was wrong.
> I just checked all cpu unplug history in qemu. It was introduced in qemu-2.7
> and from the very beginning it did stash vcpu_id,
> so there is no old QEMU that would re-plug VCPU with different apic_id.
> Though tells us nothing about what other userspace implementations might do.
>

The genie is out of the bottle already, 5.16 is released with the change
(which was promissed for some time, KVM was complaining with
pr_warn_ratelimited()). I'd be brave and say that if QEMU doesn't need
it then nobody else does (out of curiosity, are there KVM VMMs besides
QEMU which support CPU hotplug out there?).

> However, a problem of failing KVM_SET_CPUID2 during VCPU re-plug
> is still there and re-plug will fail if KVM rejects repeated KVM_SET_CPUID2
> even if ioctl called with exactly the same CPUID leafs as the 1st call.
>

Assuming APIC id change doesn not need to be supported, I can send v2
here with an empty allowlist.

-- 
Vitaly

