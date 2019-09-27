Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17240C090C
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 17:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbfI0P7t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 11:59:49 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:46232 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727207AbfI0P7t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 11:59:49 -0400
Received: by mail-io1-f68.google.com with SMTP id c6so17476256ioo.13
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 08:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DOQOLOk8mR55+5SfJr42ERkbpqQeibayuDXzPPceExo=;
        b=NlyQyztPkbpJFZxyHjZ3HS/uUhlSAZIYrhZ5n1YGG5lNm5pC5NvNKd/B03iJs3QrLU
         TnvY4/m9yMO5ka8fav53LWS1RRh3ClCUWsHykXraHpCpTjyptjo7+O4HgARhgtOzpFQH
         SGDSK9tH4DO8JToOHk/p+2YC4w+R0mEETSHxRz1Ls/aYcF8c8+yxsAVBnYnYT1yNtIS+
         XEicu4aYzrr+WUS2uTWy2Q4ty8LQscOuNceLcEQnLAaMPH3P25y5MpGTy8o0Nl+OG9nt
         +ab8az1ygFfjQhrJBpd9FN7lmlqJ8BUtQbYmLVbtcDsQPgwDhbM9aQLQ4GaGXDbtTJMB
         4RKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DOQOLOk8mR55+5SfJr42ERkbpqQeibayuDXzPPceExo=;
        b=Mr1HcD8ZSgQtZwrbq1aIZoCQSQ/lpUgbrHB8qHolrdu6i/SZr6cveTFnAyuI0tPQeV
         vFto4FU8HpGtN7IQtQBVuZOqqq1JdtND6ztdwxoBcfAm2ovfz2MNBxWJWvWXNKp3OmGE
         qy9AoWNt98HhRfdygiz0adzP2b5vJ3pIn4dhfLi13SNLW1UO2nhAKZ42zTIQhpZka7el
         /2nmtbwq/iEnFjskpu+M6phqaeI80/r+St0gn7aDGsFF109fvnGqVztXWAefGhFn8Yoo
         KkEU1GZm4GtNkPc0EhAA9vz16GgA55k7Zy7I8RRPiPAyH2R9kTJwsMUtYh82RvzLNzx/
         k25A==
X-Gm-Message-State: APjAAAWSmydl58bni8GfNrK8+sbN5+HbPA8E1eZbEmpUOK2soDLKfGT4
        5/mn06E3HV6mUWLAXl84iQD96GhTsW+QHquwRpSRhw==
X-Google-Smtp-Source: APXvYqzv2NzEsCDoftvTCMIVBzK4M0n2Wlol+ppN9umg/vDpLVdxq8ZWxq1uIMi0Rv1+sRZyYfwmIkERN5xYZTnrkss=
X-Received: by 2002:a5e:8a43:: with SMTP id o3mr5705811iom.296.1569599986628;
 Fri, 27 Sep 2019 08:59:46 -0700 (PDT)
MIME-Version: 1.0
References: <8907173e-9f27-6769-09fc-0b82c22d6352@oracle.com>
 <CALMp9eSkognb2hJSuENK+5PSgE8sYzQP=4ioERge6ZaFg1=PEA@mail.gmail.com>
 <cb7c570c-389c-2e96-ba46-555218ba60ed@oracle.com> <CALMp9eQULvr5wKt1Aw3MR+tbeNgvA_4p__6n1YTkWjMHCaEmLw@mail.gmail.com>
 <CALMp9eS1fUVcnVHhty60fUgk3-NuvELMOUFqQmqPLE-Nqy0dFQ@mail.gmail.com>
 <56e7fad0-d577-41db-0b81-363975dc2ca7@redhat.com> <87ftkh6e19.fsf@vitty.brq.redhat.com>
 <6e6f46fe-6e11-c5e3-d80c-327f77b91907@redhat.com> <87d0fl6bv4.fsf@vitty.brq.redhat.com>
 <19db28c0-375a-7bc0-7151-db566ae85de6@redhat.com> <20190927152608.GC25513@linux.intel.com>
 <87a7ap68st.fsf@vitty.brq.redhat.com> <CALMp9eTqWamhCb6cu7AvnVi0u0Y2c5HsG3iaktNANa-JfBODLw@mail.gmail.com>
In-Reply-To: <CALMp9eTqWamhCb6cu7AvnVi0u0Y2c5HsG3iaktNANa-JfBODLw@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 27 Sep 2019 08:59:35 -0700
Message-ID: <CALMp9eS-18sAEKnJdYNCFEBco89Js4x8CM=MREnzG0E6qoAKDQ@mail.gmail.com>
Subject: Re: [PATCH] kvm: x86: Add Intel PMU MSRs to msrs_to_save[]
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Eric Hankland <ehankland@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 27, 2019 at 8:55 AM Jim Mattson <jmattson@google.com> wrote:
>
> On Fri, Sep 27, 2019 at 8:47 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> >
> > Sean Christopherson <sean.j.christopherson@intel.com> writes:
> >
> > > On Fri, Sep 27, 2019 at 05:19:25PM +0200, Paolo Bonzini wrote:
> > >> On 27/09/19 16:40, Vitaly Kuznetsov wrote:
> > >> > Paolo Bonzini <pbonzini@redhat.com> writes:
> > >> >
> > >> >> On 27/09/19 15:53, Vitaly Kuznetsov wrote:
> > >> >>> Paolo Bonzini <pbonzini@redhat.com> writes:
> > >> >>>
> > >> >>>> Queued, thanks.
> > >> >>>
> > >> >>> I'm sorry for late feedback but this commit seems to be causing
> > >> >>> selftests failures for me, e.g.:
> > >> >>>
> > >> >>> # ./x86_64/state_test
> > >> >>> Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
> > >> >>> Guest physical address width detected: 46
> > >> >>> ==== Test Assertion Failure ====
> > >> >>>   lib/x86_64/processor.c:1089: r == nmsrs
> > >> >>>   pid=14431 tid=14431 - Argument list too long
> > >> >>>      1   0x000000000040a55f: vcpu_save_state at processor.c:1088 (discriminator 3)
> > >> >>>      2   0x00000000004010e3: main at state_test.c:171 (discriminator 4)
> > >> >>>      3   0x00007f881eb453d4: ?? ??:0
> > >> >>>      4   0x0000000000401287: _start at ??:?
> > >> >>>   Unexpected result from KVM_GET_MSRS, r: 36 (failed at 194)
> > >
> > > That "failed at %x" print line should really be updated to make it clear
> > > that it's printing hex...
> > >
> >
> > Yea, I also wasn't sure and had to look in the code. Will send a patch
> > if no one beats me to it.
> >
> > >> >>> Is this something known already or should I investigate?
> > >> >>
> > >> >> No, I didn't know about it, it works here.
> > >> >>
> > >> >
> > >> > Ok, this is a bit weird :-) '194' is 'MSR_ARCH_PERFMON_EVENTSEL0 +
> > >> > 14'. In intel_pmu_refresh() nr_arch_gp_counters is set to '8', however,
> > >> > rdmsr_safe() for this MSR passes in kvm_init_msr_list() (but it fails
> > >> > for 0x18e..0x193!) so it stay in the list. get_gp_pmc(), however, checks
> > >> > it against nr_arch_gp_counters and returns a failure.
> > >>
> > >> Huh, 194h apparently is a "FLEX_RATIO" MSR.  I agree that PMU MSRs need
> > >> to be checked against CPUID before allowing them.
> > >
> > > My vote would be to programmatically generate the MSRs using CPUID and the
> > > base MSR, as opposed to dumping them into the list and cross-referencing
> > > them against CPUID.  E.g. there should also be some form of check that the
> > > architectural PMUs are even supported.
> >
> > Yes. The problem appears to be that msrs_to_save[] and emulated_msrs[]
> > are global and for the MSRs in question we check
> > kvm_find_cpuid_entry(vcpu, 0xa, ) to find out how many of them are
> > available so this can be different for different VMs (and even vCPUs :-)
> > However,
> >
> > "KVM_GET_MSR_INDEX_LIST returns the guest msrs that are supported.  The list
> > varies by kvm version and host processor, but does not change otherwise."
> >
> > So it seems that PMU MSRs just can't be there. Revert?
>
> The API design is unfortunate, but I would argue that any MSR that a
> guest *might* support has to be in this list for live migration to
> work with the vPMU enabled. I don't know about qemu, but Google's
> userspace will only save/restore MSRs that are in this list

Having said that, please revert the offending commit, and I'll take
another shot at it (unless someone else wants to do it).
