Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B2148DA4A
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 16:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235894AbiAMPAE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 10:00:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:46781 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233578AbiAMPAD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jan 2022 10:00:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642086003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uIIx80vBS7Zrvo667xofSjznZoS9LVJI6OKZAt68fcw=;
        b=fM+FwbDC2OrbZgqmseTIZQ+B9vsyDW9ZUN8+M/sJDDMYLSYhEji2g+/bGwVN6S7+Yz2uWI
        MDjnHgDHB9BisTMc+MZ+LqTDEb3Fv4QNWNMpmzQGL7bPjlpCoMQr3bPHbUPH5Xje3ISL5u
        xcqi1SJMmPnKzDDDLUvO/L1c/w5Wmr4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-583-wvXXhWJoPHuPeWAL5B5BqQ-1; Thu, 13 Jan 2022 10:00:01 -0500
X-MC-Unique: wvXXhWJoPHuPeWAL5B5BqQ-1
Received: by mail-ed1-f70.google.com with SMTP id h1-20020aa7cdc1000000b0040042dd2fe4so4313297edw.17
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 07:00:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=uIIx80vBS7Zrvo667xofSjznZoS9LVJI6OKZAt68fcw=;
        b=INwFktkEJsHlNKDJZ81BrYh5BkqkNW5xRRt4fAHbL405i85WFja665iREzM6BbEK/2
         BaIde7tegXA7IGQFs28F+OqVTitIjfXscMlB2ITe9F0nbeN3uKKfiRL1DAcmmUuwDC+b
         Sb4/f9+qd4FgJ4huwEjLNm+XpX7my3TelW6p8cXZbE9t5odLCy63IUMPdp7R6LWlUr4/
         u2PpJhLy3pHNY2fS2Lg3PaRp9RMQ8vx7ztiZXytw9/fxFwBcuXQ3RE4UMiUHF0/paWNy
         Si/fiwFp6E1qk4FyRkYm7PrxwnjUIYE3j18ZTHLrYB1nzlIqOWTAtDVuptBxwZGqvi7u
         aqWQ==
X-Gm-Message-State: AOAM533LUsTzAMmcxzmegG7gwJSo/S7pRGyBZE9a3DPuVQfMGkzpG3zr
        pl2l4uKJtI5You5BVimSXJaosNLTbG61dyBHZ5VltI2OnNvV7/Yz5c0xy9oH80efkFB5DlRZ2t/
        DXfsU5pSZXAVV
X-Received: by 2002:a05:6402:4249:: with SMTP id g9mr4392440edb.321.1642086000804;
        Thu, 13 Jan 2022 07:00:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxx64NsOfS2v3idCJzNPz1xn1LfHJj/+xa/1vXM9VAQhkkNI9DCyH/sJasr/o1BNR90k40fNA==
X-Received: by 2002:a05:6402:4249:: with SMTP id g9mr4392424edb.321.1642086000609;
        Thu, 13 Jan 2022 07:00:00 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id h11sm1296842edb.59.2022.01.13.06.59.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 07:00:00 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN
In-Reply-To: <6ae7e64c53727f9f00537d787e9612c292c4e244.camel@redhat.com>
References: <20211122175818.608220-1-vkuznets@redhat.com>
 <20211122175818.608220-3-vkuznets@redhat.com>
 <16368a89-99ea-e52c-47b6-bd006933ec1f@redhat.com>
 <20211227183253.45a03ca2@redhat.com>
 <61325b2b-dc93-5db2-2d0a-dd0900d947f2@redhat.com>
 <87mtkdqm7m.fsf@redhat.com> <20220103104057.4dcf7948@redhat.com>
 <875yr1q8oa.fsf@redhat.com>
 <ceb63787-b057-13db-4624-b430c51625f1@redhat.com>
 <87o84qpk7d.fsf@redhat.com> <877dbbq5om.fsf@redhat.com>
 <5505d731-cf87-9662-33f3-08844d92877c@redhat.com>
 <20220111090022.1125ffb5@redhat.com> <87fsptnjic.fsf@redhat.com>
 <50136685-706e-fc6a-0a77-97e584e74f93@redhat.com>
 <87bl0gnfy5.fsf@redhat.com>
 <7e7c7e22f8b1b1695d26d9e19a767b87c679df93.camel@redhat.com>
 <87zgnzn1nr.fsf@redhat.com>
 <6ae7e64c53727f9f00537d787e9612c292c4e244.camel@redhat.com>
Date:   Thu, 13 Jan 2022 15:59:59 +0100
Message-ID: <87wnj3n0k0.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> On Thu, 2022-01-13 at 15:36 +0100, Vitaly Kuznetsov wrote:
>> Maxim Levitsky <mlevitsk@redhat.com> writes:
>> 
>> > On Thu, 2022-01-13 at 10:27 +0100, Vitaly Kuznetsov wrote:
>> > > Paolo Bonzini <pbonzini@redhat.com> writes:
>> > > 
>> > > > On 1/12/22 14:58, Vitaly Kuznetsov wrote:
>> > > > > -	best = kvm_find_cpuid_entry(vcpu, 0xD, 1);
>> > > > > +	best = cpuid_entry2_find(entries, nent, 0xD, 1);
>> > > > >   	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
>> > > > >   		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
>> > > > >   		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
>> > > > >   
>> > > > > -	best = kvm_find_kvm_cpuid_features(vcpu);
>> > > > > +	best = __kvm_find_kvm_cpuid_features(vcpu, vcpu->arch.cpuid_entries,
>> > > > > +					     vcpu->arch.cpuid_nent);
>> > > > >   	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
>> > > > 
>> > > > I think this should be __kvm_find_kvm_cpuid_features(vcpu, entries, nent).
>> > > > 
>> > > 
>> > > Of course.
>> > > 
>> > > > > +		case 0x1:
>> > > > > +			/* Only initial LAPIC id is allowed to change */
>> > > > > +			if (e->eax ^ best->eax || ((e->ebx ^ best->ebx) >> 24) ||
>> > > > > +			    e->ecx ^ best->ecx || e->edx ^ best->edx)
>> > > > > +				return -EINVAL;
>> > > > > +			break;
>> > > > 
>> > > > This XOR is a bit weird.  In addition the EBX test is checking the wrong 
>> > > > bits (it checks whether 31:24 change and ignores changes to 23:0).
>> > > 
>> > > Indeed, however, I've tested CPU hotplug with QEMU trying different
>> > > CPUs in random order and surprisingly othing blew up, feels like QEMU
>> > > was smart enough to re-use the right fd)
>> > > 
>> > > > You can write just "(e->ebx & ~0xff000000u) != (best->ebx ~0xff000000u)".
>> > > > 
>> > > > > +		default:
>> > > > > +			if (e->eax ^ best->eax || e->ebx ^ best->ebx ||
>> > > > > +			    e->ecx ^ best->ecx || e->edx ^ best->edx)
>> > > > > +				return -EINVAL;
>> > > > 
>> > > > This one even more so.
>> > > 
>> > > Thanks for the early review, I'm going to prepare a selftest and send
>> > > this out.
>> > > 
>> > I also looked at this recently (due to other reasons) and I found out that
>> > qemu picks a parked vcpu by its vcpu_id which is its initial apic id,
>> > thus apic id related features should not change.
>> > 
>> > Take a look at 'kvm_get_vcpu' in qemu source.
>> > Maybe old qemu versions didn't do this?
>> 
>> I took Igor's word on this, I didn't check QEMU code :-)
>> 
>> In the v1 I've just sent [L,x2]APIC ids are allowed to change. This
>> shouldn't screw the MMU (which was the main motivation for forbidding
>> KVM_SET_CPUID{,2} after KVM_RUN in the first place) but maybe we don't
>> really need to be so permissive.
>> 
>
> For my nested AVIC work I would really want the APIC ID of a VCPU to be read-only
> and be equal to vcpu_id.
>

Doesn't APIC ID have topology encoded in it?

> That simplifies lot of things, and in practice it is hightly likely that no guests
> change their APIC id, and likely that qemu doesn't as well.

-- 
Vitaly

