Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 228DDC092A
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 18:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbfI0QG5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 12:06:57 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:36215 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727517AbfI0QG5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 12:06:57 -0400
Received: by mail-io1-f66.google.com with SMTP id b136so17701526iof.3
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 09:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FAo7IKK39pGFlnOlF1WwZBtqdWu3UC6UJgNGToHLQpE=;
        b=IFe4Hi6wI/E4zrwomNStlLA71RM51g8jZFOrCHnSqIM5QWXD9fuaXwyP+6sp4yHU5Q
         wBzY4NMbUUJicmDkcYTwX6vcnw+Xe+N0onWrGD3IWwv0kEYhDYHKjuo5WC70nUoIi49c
         PZL4oA0Z1FLIX4iK8Gv1MWhbeetR87SVDn7LnYmlgbQsNOZb0LAw+S6uZpOqAYVI7hyd
         beMY7esjYUlrEkSw+v7V6wFEpe3orA7EtacI+MadFoYwwTiMob6EhiWRed9xJ8r6XmGo
         Sd8SARte2G3hQedZb/cf4ZGkb8qkM6dGPYsEfb38rtGK8MyfhB+O1cvVLNRTzL5DT14X
         E3+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FAo7IKK39pGFlnOlF1WwZBtqdWu3UC6UJgNGToHLQpE=;
        b=nVNyL5wHI1JmwC0I5VTzzyyAC4bmxAfN+bTzM6efZz2ffiqvsRi6eEYNAj7MVpAUnK
         YrI5BaTan/1ZB1nsVNZKNPrMlBL4t4kWAP/tsNSnxtED6652dYc+kAq4zsMBu6X61fvc
         9aslg8/ZaGX/ZEqWoX+I1AYVkrWTy4NJyh0OUWk/tcVCkOTGmvHnbhxIukFp0frHITkp
         hMvBxALALj9nDlk/hTs/Q6a2rooMiUT0j/OXbDoVl79DcUCA1DXET1a+fAcioadxMCM7
         Ahk1WJAjzcx7InsQ+ucpomVo4Blt5fKfEWGdaQW9a6ONGqv4TmYgDjdPKd6lARymKjz0
         NThA==
X-Gm-Message-State: APjAAAX4FgQXI013rhy7OUSDQx6vrPjnEUDqV0AiMRlpmZcUsABSP1+E
        JhhbQqTBTQD/LKA9qEOBtGOA8ByAsTzbDFpm3vXSjw==
X-Google-Smtp-Source: APXvYqwuF+13S3IkWl12gqCFDtkdPU+nUzSkkhRSfM5FgdNl2gsRIWIr4KbI9a1BHDOFd5l5RdhotSMk2WWxiOiWyzA=
X-Received: by 2002:a02:ba17:: with SMTP id z23mr8876409jan.24.1569600416043;
 Fri, 27 Sep 2019 09:06:56 -0700 (PDT)
MIME-Version: 1.0
References: <8907173e-9f27-6769-09fc-0b82c22d6352@oracle.com>
 <CALMp9eSkognb2hJSuENK+5PSgE8sYzQP=4ioERge6ZaFg1=PEA@mail.gmail.com>
 <cb7c570c-389c-2e96-ba46-555218ba60ed@oracle.com> <CALMp9eQULvr5wKt1Aw3MR+tbeNgvA_4p__6n1YTkWjMHCaEmLw@mail.gmail.com>
 <CALMp9eS1fUVcnVHhty60fUgk3-NuvELMOUFqQmqPLE-Nqy0dFQ@mail.gmail.com>
 <56e7fad0-d577-41db-0b81-363975dc2ca7@redhat.com> <87ftkh6e19.fsf@vitty.brq.redhat.com>
 <6e6f46fe-6e11-c5e3-d80c-327f77b91907@redhat.com> <87d0fl6bv4.fsf@vitty.brq.redhat.com>
 <19db28c0-375a-7bc0-7151-db566ae85de6@redhat.com> <20190927152608.GC25513@linux.intel.com>
 <87a7ap68st.fsf@vitty.brq.redhat.com> <59934fa75540d493dabade5a3e66b7ed159c4aae.camel@intel.com>
In-Reply-To: <59934fa75540d493dabade5a3e66b7ed159c4aae.camel@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 27 Sep 2019 09:06:44 -0700
Message-ID: <CALMp9eQC+mch7BreTer065JpHVNjU6e8UPCKUPy563nr0_T2dg@mail.gmail.com>
Subject: Re: [PATCH] kvm: x86: Add Intel PMU MSRs to msrs_to_save[]
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
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

On Fri, Sep 27, 2019 at 9:05 AM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>
> On Fri, 2019-09-27 at 17:46 +0200, Vitaly Kuznetsov wrote:
> > > > > > > Is this something known already or should I investigate?
> > > > > >
> > > > > > No, I didn't know about it, it works here.
> > > > > >
> > > > >
> > > > > Ok, this is a bit weird :-) '194' is 'MSR_ARCH_PERFMON_EVENTSEL0 +
> > > > > 14'. In intel_pmu_refresh() nr_arch_gp_counters is set to '8', however,
> > > > > rdmsr_safe() for this MSR passes in kvm_init_msr_list() (but it fails
> > > > > for 0x18e..0x193!) so it stay in the list. get_gp_pmc(), however, checks
> > > > > it against nr_arch_gp_counters and returns a failure.
> > > >
> > > > Huh, 194h apparently is a "FLEX_RATIO" MSR.  I agree that PMU MSRs need
> > > > to be checked against CPUID before allowing them.
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
>
> Indeed, "KVM_GET_MSR_INDEX_LIST" returns the guest msrs that KVM supports and
> they are free from different guest configuration since they're initialized when
> kvm module is loaded.
>
> Even though some MSRs are not exposed to guest by clear their related cpuid
> bits, they are still saved/restored by QEMU in the same fashion.
>
> I wonder should we change "KVM_GET_MSR_INDEX_LIST" per VM?

Yes! Quoting Paolo from a few days ago, "If there's a complex or
really weird behavior that userspace would most definitely get wrong,
we should design the API to simplify its job."

> > So it seems that PMU MSRs just can't be there. Revert?
> >
>
