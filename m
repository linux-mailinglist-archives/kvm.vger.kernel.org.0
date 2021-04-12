Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF4D35C522
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 13:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240248AbhDLLaM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 07:30:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52611 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240228AbhDLLaM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Apr 2021 07:30:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618226993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nyeLo4FrE5zHreHQz7MasSEetE9tN3Jw9beLpfv7C+Q=;
        b=aSAnDnidOX9HkwAZD7KpooRvdvnwB+XcFX+ocKpv2xR6mTDQ8Q8zH4kM0beZyR7ToX8fSI
        k9ET2y+YaokWpERXU4+vm2m3ed0K7fKdNKUqDDafBX2CSAfZn0S8C3cubJUqvO6l1ntSH1
        FeBLP4MrpQ2py+4d+LZAbmjPabOeKq4=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345-oRMH4OBtNGCY07f_XSvSbA-1; Mon, 12 Apr 2021 07:29:52 -0400
X-MC-Unique: oRMH4OBtNGCY07f_XSvSbA-1
Received: by mail-ej1-f72.google.com with SMTP id d25so3296034ejb.14
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 04:29:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=nyeLo4FrE5zHreHQz7MasSEetE9tN3Jw9beLpfv7C+Q=;
        b=sSsDrlWq151NIH3+jRlfB8oT61hrYOYhcrpdKbdzLI/sXfmS8F+m3bbZc0niWq6Ta5
         wbmG2G15/dHaJaRzZ3HdFaLbpeGZkmE7WamR2jyzPmr9LKZ520gm5Z7zL4oVjkXn3Sa5
         KJWydxw54EcT6K5bdZ3FiT6b1qFUZJEiglQ5h1HFK5U7RweiC3YVsha9m2dQzAE7pAbj
         gsaL5Unmy8u49VCDTdaHBB9hthq8lzg9OFZHrb/25DI7rkpOb04MbRevvOLBnvgocsM8
         TH0Uowd1wIWtPQCXy1yjM0VRutUBHqROO84zQjOiwoPxIJCxhKmLjen9KTaBJ6d5hvpe
         qKQQ==
X-Gm-Message-State: AOAM5324opzziRoD7d6AbP+WI7pnThM9eLefqGMDuaL+oVNsVHi36Bii
        TALAGE1JxI6rKBtTcWJOvkDl09sCOnNIiDf5qWgN7OWVm+4Gwt8KUJpKGJkikXaTCnLW1YjHmxf
        GNjp1pw9jz/Xr
X-Received: by 2002:a05:6402:104c:: with SMTP id e12mr28076532edu.108.1618226991138;
        Mon, 12 Apr 2021 04:29:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyU49Hw6nOmYzmAj9jQhtd21t/eNOeTdT3HGIbQ8noTgP0Y7DfBr7L/L9OO7Hpodode77anZw==
X-Received: by 2002:a05:6402:104c:: with SMTP id e12mr28076506edu.108.1618226990993;
        Mon, 12 Apr 2021 04:29:50 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id e16sm6427109edu.94.2021.04.12.04.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 04:29:50 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Siddharth Chandrasekaran <sidcha@amazon.de>
Cc:     Alexander Graf <graf@amazon.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 4/4] KVM: hyper-v: Advertise support for fast XMM
 hypercalls
In-Reply-To: <20210412081110.GA16796@uc8bbc9586ea454.ant.amazon.com>
References: <20210407211954.32755-1-sidcha@amazon.de>
 <20210407211954.32755-5-sidcha@amazon.de>
 <87blap7zha.fsf@vitty.brq.redhat.com>
 <20210408142053.GA10636@u366d62d47e3651.ant.amazon.com>
 <8735w096pk.fsf@vitty.brq.redhat.com>
 <20210412081110.GA16796@uc8bbc9586ea454.ant.amazon.com>
Date:   Mon, 12 Apr 2021 13:29:49 +0200
Message-ID: <87czuz7nbm.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Siddharth Chandrasekaran <sidcha@amazon.de> writes:

> On Thu, Apr 08, 2021 at 04:44:23PM +0200, Vitaly Kuznetsov wrote:
>> Siddharth Chandrasekaran <sidcha@amazon.de> writes:
>> > On Thu, Apr 08, 2021 at 02:05:53PM +0200, Vitaly Kuznetsov wrote:
>> >> Siddharth Chandrasekaran <sidcha@amazon.de> writes:
>> >> > Now that all extant hypercalls that can use XMM registers (based on
>> >> > spec) for input/outputs are patched to support them, we can start
>> >> > advertising this feature to guests.
>> >> >
>> >> > Cc: Alexander Graf <graf@amazon.com>
>> >> > Cc: Evgeny Iakovlev <eyakovl@amazon.de>
>> >> > Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
>> >> > ---
>> >> >  arch/x86/include/asm/hyperv-tlfs.h | 4 ++--
>> >> >  arch/x86/kvm/hyperv.c              | 1 +
>> >> >  2 files changed, 3 insertions(+), 2 deletions(-)
>> >> >
>> >> > diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
>> >> > index e6cd3fee562b..1f160ef60509 100644
>> >> > --- a/arch/x86/include/asm/hyperv-tlfs.h
>> >> > +++ b/arch/x86/include/asm/hyperv-tlfs.h
>> >> > @@ -49,10 +49,10 @@
>> >> >  /* Support for physical CPU dynamic partitioning events is available*/
>> >> >  #define HV_X64_CPU_DYNAMIC_PARTITIONING_AVAILABLE    BIT(3)
>> >> >  /*
>> >> > - * Support for passing hypercall input parameter block via XMM
>> >> > + * Support for passing hypercall input and output parameter block via XMM
>> >> >   * registers is available
>> >> >   */
>> >> > -#define HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE                BIT(4)
>> >> > +#define HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE                BIT(4) | BIT(15)
>> >>
>> >> TLFS 6.0b states that there are two distinct bits for input and output:
>> >>
>> >> CPUID Leaf 0x40000003.EDX:
>> >> Bit 4: support for passing hypercall input via XMM registers is available.
>> >> Bit 15: support for returning hypercall output via XMM registers is available.
>> >>
>> >> and HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE is not currently used
>> >> anywhere, I'd suggest we just rename
>> >>
>> >> HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE to HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE
>> >> and add HV_X64_HYPERCALL_XMM_OUTPUT_AVAILABLE (bit 15).
>> >
>> > That is how I had it initially; but then noticed that we would never
>> > need to use either of them separately. So it seemed like a reasonable
>> > abstraction to put them together.
>> >
>> 
>> Actually, we may. In theory, KVM userspace may decide to expose just
>> one of these two to the guest as it is not obliged to copy everything
>> from KVM_GET_SUPPORTED_HV_CPUID so we will need separate
>> guest_cpuid_has() checks.
>
> Looks like guest_cpuid_has() check is for x86 CPU features only (if I'm
> not mistaken) and I don't see a suitable alternative that looks into
> vcpu->arch.cpuid_entries[]. So I plan to add a new method
> hv_guest_cpuid_has() in hyperv.c to have this check; does that sound
> right to you?
> If you can give a quick go-ahead, I'll make the changes requested so
> far and send v2 this series.

Sorry my mistake, guest_cpuid_has() was the wrong function to name. In the
meantime I started working on fine-grained access to the existing
Hyper-V enlightenments as well and I think the best approach would be to
cache CPUID 0x40000003 (EAX, EBX, EDX) in kvm_hv_set_cpuid()  to avoid
looping through all guest CPUID entries on every hypercall. Your check
will then look like

 if (hv_vcpu->cpuid_cache.features_edx & HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE)
 ...


 if (hv_vcpu->cpuid_cache.features_edx & HV_X64_HYPERCALL_XMM_OUTPUT_AVAILABLE)
 ...

We can wrap this into a hv_guest_cpuid_has() helper indeed, it'll look like:

 if (hv_guest_cpuid_has(vcpu, HYPERV_CPUID_FEATURES, CPUID_EDX, HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE))
 ...

but I'm not sure it's worth it, maybe raw check is shorter and better.

I plan to send something out in a day or two, I'll Cc: you. Feel free to
do v2 without this, if your series gets merged first I can just add the
'fine-grained access' to mine.

Thanks!

-- 
Vitaly

