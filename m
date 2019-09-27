Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34AAFC0BE9
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 21:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728260AbfI0TD2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 15:03:28 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:43472 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728206AbfI0TD1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 15:03:27 -0400
Received: by mail-io1-f66.google.com with SMTP id v2so18965462iob.10
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 12:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LJk7s95XlGGC/hwjWnhFwwLDGDb9hglrm+MzR0TLRxM=;
        b=AwIjURbWVIvZiyWp0yjCTgSgrMe5vaa7MzucPuAsTwbKr8hurn1Wf1xxxulHwRIuPA
         2qz2aGpUksz9KlNbUlm3zrJZELXAHkmbq3WVci4Pb0u8kWXPIsu+eGNNQov0XXRHHSPn
         JqvE6moVnSf3sJ144JRoP3A5ZD+XsID3WfUapBuG5vnyP7FJKr+KJBmeAJAU2Oyw4hSn
         XCNvFE+l+QYXdI0jJMkaa1maDW2jxNuiH4ARXkjwipikFPetxRjlbVbrjbSCnSFnnccu
         ZGg8LnHQlgyH8E3UuVkj101N8bd/mslLx4/c66WSWUb7sdnZi/EFrc79KiIaDy82Q82g
         AmKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LJk7s95XlGGC/hwjWnhFwwLDGDb9hglrm+MzR0TLRxM=;
        b=aY7Wio/3FTjLsWoLxF5z+B3VxTGaJW6RerFUYmKaPpQl8NjcDmLx/bIUQVrV5fpgTN
         aS2KefLkYZ5g1ksKkB9o/UdG3XJgLaonWA+DsnR/ZDAOpPW21SGwsQjsJVZNvipUVjW6
         SF44xVJA1vsrR8Tlq7UeI0J+S0B60kEgMAdPYESeoeNIK6+Q+fLfCmnnTKgr1M7w4ATw
         DHFppIQukhmFPiHptzGYu1Dm044tQ/B1XZvH3K6SmcpKwxwKmBoZVZ2R9rLsyKdMV//L
         b34l+FnYFqHs014Al9vXubQWGCxZ3zI7DV4HmKzVBAm46Jbsic56ZwXzoXLX1/g1x9cV
         ahGA==
X-Gm-Message-State: APjAAAWTkPnyNVIk2n3VrjLsdfKzUiUqCV7/hx9fO1rwDLHwUSJfo6V3
        oecz7RdYkc2oHmxxDsuEZtvMkG982Ev0mLbLjzoa/w==
X-Google-Smtp-Source: APXvYqzKf7pGAa6NVzYB1C4uwYBkLENOVeuNoe3flyy4GP/+vwDgFsWyoa6RfAyoGih7m4jpjauEZZHbWPUBEycghAA=
X-Received: by 2002:a92:5a10:: with SMTP id o16mr6725362ilb.296.1569611006032;
 Fri, 27 Sep 2019 12:03:26 -0700 (PDT)
MIME-Version: 1.0
References: <87d0fl6bv4.fsf@vitty.brq.redhat.com> <19db28c0-375a-7bc0-7151-db566ae85de6@redhat.com>
 <20190927152608.GC25513@linux.intel.com> <87a7ap68st.fsf@vitty.brq.redhat.com>
 <59934fa75540d493dabade5a3e66b7ed159c4aae.camel@intel.com>
 <e4a17cfb-8172-9ad8-7010-ee860c4898bf@redhat.com> <CALMp9eQcHbm6nLAQ_o8dS4B+2k6B0eHxuGvv6Ls_-HL9PC4mhQ@mail.gmail.com>
 <11f63bd6-50cc-a6ce-7a36-a6e1a4d8c5e9@redhat.com> <20190927171405.GD25513@linux.intel.com>
 <CALMp9eRpW++f1R7inMhu33s7GmerbD21+rGwyRmKphEEvdTDLQ@mail.gmail.com> <20190927173526.GH25513@linux.intel.com>
In-Reply-To: <20190927173526.GH25513@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 27 Sep 2019 12:03:13 -0700
Message-ID: <CALMp9eTXKYohFk4iJXizQa8OvAo1JKej0UEHRsiBJq4SOKmZpQ@mail.gmail.com>
Subject: Re: [PATCH] kvm: x86: Add Intel PMU MSRs to msrs_to_save[]
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Eric Hankland <ehankland@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 27, 2019 at 10:35 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Fri, Sep 27, 2019 at 10:30:38AM -0700, Jim Mattson wrote:
> > On Fri, Sep 27, 2019 at 10:14 AM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > >
> > > On Fri, Sep 27, 2019 at 06:32:27PM +0200, Paolo Bonzini wrote:
> > > > On 27/09/19 18:10, Jim Mattson wrote:
> > > > > On Fri, Sep 27, 2019 at 9:06 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > > > >>
> > > > >> On 27/09/19 17:58, Xiaoyao Li wrote:
> > > > >>> Indeed, "KVM_GET_MSR_INDEX_LIST" returns the guest msrs that KVM supports and
> > > > >>> they are free from different guest configuration since they're initialized when
> > > > >>> kvm module is loaded.
> > > > >>>
> > > > >>> Even though some MSRs are not exposed to guest by clear their related cpuid
> > > > >>> bits, they are still saved/restored by QEMU in the same fashion.
> > > > >>>
> > > > >>> I wonder should we change "KVM_GET_MSR_INDEX_LIST" per VM?
> > > > >>
> > > > >> We can add a per-VM version too, yes.
> > > >
> > > > There is one problem with that: KVM_SET_CPUID2 is a vCPU ioctl, not a VM
> > > > ioctl.
> > > >
> > > > > Should the system-wide version continue to list *some* supported MSRs
> > > > > and *some* unsupported MSRs, with no rhyme or reason? Or should we
> > > > > codify what that list contains?
> > > >
> > > > The optimal thing would be for it to list only MSRs that are
> > > > unconditionally supported by all VMs and are part of the runtime state.
> > > >  MSRs that are not part of the runtime state, such as the VMX
> > > > capabilities, should be returned by KVM_GET_MSR_FEATURE_INDEX_LIST.
> > > >
> > > > This also means that my own commit 95c5c7c77c06 ("KVM: nVMX: list VMX
> > > > MSRs in KVM_GET_MSR_INDEX_LIST", 2019-07-02) was incorrect.
> > > > Unfortunately, that commit was done because userspace (QEMU) has a
> > > > genuine need to detect whether KVM is new enough to support the
> > > > IA32_VMX_VMFUNC MSR.
> > > >
> > > > Perhaps we can make all MSRs supported unconditionally if
> > > > host_initiated.  For unsupported performance counters it's easy to make
> > > > them return 0, and allow setting them to 0, if host_initiated
> > >
> > > I don't think we need to go that far.  Allowing any ol' MSR access seems
> > > like it would cause more problems than it would solve, e.g. userspace
> > > could completely botch something and never know.
> > >
> > > For the perf MSRs, could we enumerate all arch perf MSRs that are supported
> > > by hardware?  That would also be the list of MSRs that host_initiated MSR
> > > accesses can touch regardless of guest support.
> > >
> > > Something like:
> > >
> > >         case MSR_ARCH_PERFMON_PERFCTR0 ... MSR_ARCH_PERFMON_PERFCTR0+INTEL_PMC_MAX_GENERIC:
> > >         case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL0+INTEL_PMC_MAX_GENERIC:
> > >                 if (kvm_pmu_is_valid_msr(vcpu, msr))
> > >                         return kvm_pmu_set_msr(vcpu, msr_info);
> > >                 else if (msr <= num_hw_counters)
> > >                         break;
> > >                 return 1;
> >
> > That doesn't quite work, since you need a vcpu, and
> > KVM_GET_MSR_INDEX_LIST is a system-wide ioctl, not a VCPU ioctl.
>
> That'd be for the {kvm,vmx}_set_msr() flow.  The KVM_GET_MSR_INDEX_LIST
> flow would report all MSRs from 0..num_hw_counters, where num_hw_counters
> is pulled from CPUID.

The try-catch methodology used for all of the other msrs_to_save[]
*should* have worked here, if (a) the static PMU MSR list stopped at
the correct maximum PMC index (which is clearly less than
INTEL_PMC_MAX_GENERIC), and (b) Intel had reserved all of the
currently unused PMU MSRs so that accesses to them actually raised
#GP. Alas, neither is the case. Revert the change.

I propose moving these MSRs to the inaptly named emulated_msrs[],
reducing the static list to the theoretical maximum of 18, and adding
code to vmx_has_emulated_msr to filter based on host CPUID leaf 0AH.
