Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11EEEC0A5A
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 19:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbfI0Raw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 13:30:52 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53422 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbfI0Raw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 13:30:52 -0400
Received: by mail-wm1-f67.google.com with SMTP id i16so6860404wmd.3
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 10:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n3qEo1jhMKOryexqyMggKz3D98N871HaV2LiKUqu48Y=;
        b=YzdLBUJ6j1Y+hEOn8PoqYboXjLl02VAL+UTctZWBbjK40g1X9D8eCVdxJEpUl6aQ9l
         cG04tR/eKXCh6k/CjGJqoypf3QWuRo7nm7i8P3ByYY3lnySOujsi7Uv159oJ+NvCJQX3
         OZvJDPkZiiUp+oSCYbgn03p2N39ToP62RXEvtqiTwM5DQMhUPrmhlhhhxN0oz8zSBFTb
         66H/KooGTecQhoSWbJEMyaVW1Owa7eeq5AKWzfILbR+QNVIl+ZA4RvWu8lpRBG36dQcZ
         HJpUIvgtkgqHM+F+0+tePTyteO4XHJkcPN46t09mbeluvAI8DP5HYuUidK7nz0eZv1YE
         y+hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n3qEo1jhMKOryexqyMggKz3D98N871HaV2LiKUqu48Y=;
        b=n4X8JkMlvvM1ClMghqNEaKI3ey+ZmBNaPT3Hhlsp9iBhEUgeSgdWApXWTku2B30Rh9
         8lNfQNnrE+QHRUzijbEWEJo0dKeAi7S3a1G2KIhlHP819D6pkkz6bAlGNN05n61Sl86o
         eVEaTD8zPk8O8892sqzbxRu8BhT+Xw4DLlu+U4GnVGI45sF8pp+KRvUMQmW2kZcsX5/O
         uFHkeBUkPW8go9DdcJYkGUuU/7OEoS8Y8TrqvDPxR0tLKUQYBZkCADJJZUeA2ioNJiG3
         C6jVewVjwBX0BvfmHiMAkX1xo2FJeh+df3bWD0MGYUrQNdP8Xy8opEgFosZkDhiwrvVt
         hXxA==
X-Gm-Message-State: APjAAAWWSzeT2fN+SEGAwsIr031r4wVqkkKXn4gN3W2dmZ+pASWlOaS7
        D0fU+Vpd1bBsalklhm73HUWqLwOVzGP6+f9cai4duCs+Qh9k2g==
X-Google-Smtp-Source: APXvYqzpzt+/242GNGDwlcmKMlflYwwCtUkJjqRAGgtRmsuP5X6oxVL1+PWu2LIjV8vJsUWIE4OqVXhDq66plSPml4Y=
X-Received: by 2002:a05:600c:241:: with SMTP id 1mr8013122wmj.32.1569605450119;
 Fri, 27 Sep 2019 10:30:50 -0700 (PDT)
MIME-Version: 1.0
References: <87ftkh6e19.fsf@vitty.brq.redhat.com> <6e6f46fe-6e11-c5e3-d80c-327f77b91907@redhat.com>
 <87d0fl6bv4.fsf@vitty.brq.redhat.com> <19db28c0-375a-7bc0-7151-db566ae85de6@redhat.com>
 <20190927152608.GC25513@linux.intel.com> <87a7ap68st.fsf@vitty.brq.redhat.com>
 <59934fa75540d493dabade5a3e66b7ed159c4aae.camel@intel.com>
 <e4a17cfb-8172-9ad8-7010-ee860c4898bf@redhat.com> <CALMp9eQcHbm6nLAQ_o8dS4B+2k6B0eHxuGvv6Ls_-HL9PC4mhQ@mail.gmail.com>
 <11f63bd6-50cc-a6ce-7a36-a6e1a4d8c5e9@redhat.com> <20190927171405.GD25513@linux.intel.com>
In-Reply-To: <20190927171405.GD25513@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 27 Sep 2019 10:30:38 -0700
Message-ID: <CALMp9eRpW++f1R7inMhu33s7GmerbD21+rGwyRmKphEEvdTDLQ@mail.gmail.com>
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

On Fri, Sep 27, 2019 at 10:14 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Fri, Sep 27, 2019 at 06:32:27PM +0200, Paolo Bonzini wrote:
> > On 27/09/19 18:10, Jim Mattson wrote:
> > > On Fri, Sep 27, 2019 at 9:06 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > >>
> > >> On 27/09/19 17:58, Xiaoyao Li wrote:
> > >>> Indeed, "KVM_GET_MSR_INDEX_LIST" returns the guest msrs that KVM supports and
> > >>> they are free from different guest configuration since they're initialized when
> > >>> kvm module is loaded.
> > >>>
> > >>> Even though some MSRs are not exposed to guest by clear their related cpuid
> > >>> bits, they are still saved/restored by QEMU in the same fashion.
> > >>>
> > >>> I wonder should we change "KVM_GET_MSR_INDEX_LIST" per VM?
> > >>
> > >> We can add a per-VM version too, yes.
> >
> > There is one problem with that: KVM_SET_CPUID2 is a vCPU ioctl, not a VM
> > ioctl.
> >
> > > Should the system-wide version continue to list *some* supported MSRs
> > > and *some* unsupported MSRs, with no rhyme or reason? Or should we
> > > codify what that list contains?
> >
> > The optimal thing would be for it to list only MSRs that are
> > unconditionally supported by all VMs and are part of the runtime state.
> >  MSRs that are not part of the runtime state, such as the VMX
> > capabilities, should be returned by KVM_GET_MSR_FEATURE_INDEX_LIST.
> >
> > This also means that my own commit 95c5c7c77c06 ("KVM: nVMX: list VMX
> > MSRs in KVM_GET_MSR_INDEX_LIST", 2019-07-02) was incorrect.
> > Unfortunately, that commit was done because userspace (QEMU) has a
> > genuine need to detect whether KVM is new enough to support the
> > IA32_VMX_VMFUNC MSR.
> >
> > Perhaps we can make all MSRs supported unconditionally if
> > host_initiated.  For unsupported performance counters it's easy to make
> > them return 0, and allow setting them to 0, if host_initiated
>
> I don't think we need to go that far.  Allowing any ol' MSR access seems
> like it would cause more problems than it would solve, e.g. userspace
> could completely botch something and never know.
>
> For the perf MSRs, could we enumerate all arch perf MSRs that are supported
> by hardware?  That would also be the list of MSRs that host_initiated MSR
> accesses can touch regardless of guest support.
>
> Something like:
>
>         case MSR_ARCH_PERFMON_PERFCTR0 ... MSR_ARCH_PERFMON_PERFCTR0+INTEL_PMC_MAX_GENERIC:
>         case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL0+INTEL_PMC_MAX_GENERIC:
>                 if (kvm_pmu_is_valid_msr(vcpu, msr))
>                         return kvm_pmu_set_msr(vcpu, msr_info);
>                 else if (msr <= num_hw_counters)
>                         break;
>                 return 1;

That doesn't quite work, since you need a vcpu, and
KVM_GET_MSR_INDEX_LIST is a system-wide ioctl, not a VCPU ioctl.

> > (BTW, how did you pick 32?  is there any risk of conflicts with other MSRs?).
>
> Presumably because INTEL_PMC_MAX_GENERIC is 32.
>
> > I'm not sure of the best set of values to allow for VMX caps, especially
> > with the default0/default1 stuff going on for execution controls.  But
> > perhaps that would be the simplest thing to do.
> >
> > One possibility would be to make a KVM_GET_MSR_INDEX_LIST variant that
> > is a system ioctl and takes a CPUID vector.  I'm worried that it would
> > be tedious to get right and hardish to keep correct---so I'm not sure
> > it's a good idea.
> >
> > Paolo
