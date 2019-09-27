Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06310C08FA
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 17:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbfI0PzP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 11:55:15 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:44287 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727682AbfI0PzP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 11:55:15 -0400
Received: by mail-io1-f68.google.com with SMTP id j4so17492595iog.11
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 08:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=463o+OwG055spCgG/RocapNdjYyOdD1A+urFmmcnZrE=;
        b=CKRRhUDmb+krvCj535+zV7SMOk/sgVu1aoawHiQlWwVQbW5NPyEuSchIpqRRGFDD2L
         n79PVX4JQUzXQgadjVvBghKr7HogP18SRALGQbv/o9ZNi8QCIkjUtGPZGOqHHwGyB6Q1
         frwgJ/PxTBFwKsFasvsSQBjFSLklLmCq+wUNK7YKBAuhI0qJOd4Sdk37U8qJTcH38PJu
         OlRuTxPYc8LSZhBFSLE01F8voJPeyq6dPiZFw13SDT9C+9MzbTkbHp0RGmW1MRUibdU/
         KxqnpQGhbYfvDdChiKWhDcmljtcAxcC/NJadRuxKsovL+/5fYvJerrFauXM1cg+DtErM
         BY9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=463o+OwG055spCgG/RocapNdjYyOdD1A+urFmmcnZrE=;
        b=BsClmDHKZI90KPsjsMaBkSjK7BsjIKomscUsgAHmZOoqmYTiJ0/eOzgKSYHJnMMutk
         GCTFWOSFCn5VBxFoukjfeTEA7+sZpOJf+esJM+7UMTuDSxH5DSWt86nuobEtHCywz3m3
         711FT7BTEWuP7C+kud+MdXYVfBlASiOkOvxNqYU+bKbaj0Bu60RFkI8faBVs8xGDTrLF
         KL+sI9iBihuPFJW7whAIbitde1ObtxoZ1coFFYeQ29OHQXNSYEz9QRObGPRw2uDLt/LL
         Nhgotg06ovMT2ry0ilTD5E7UJ57qvAn1pTHHfefD4AaizScdEQCKSFdSSV6OlxAdehQS
         qr8Q==
X-Gm-Message-State: APjAAAVfddcbv/YEYRXH2YrBX8jQt+kcIyAnIcRO0Qr6cmNFlJQ0PG6t
        U9sqRCK+kzORbnfv8E37TITPIDNBy/qUASMt9siQ8Q==
X-Google-Smtp-Source: APXvYqyVwlYljqTuhtXzwRI7Yb3rlCHUh/G5GJMTGuJWwG3wAwpXgtDROWo23caqbZbFvNIkp3gNWO7XscA8uc8nc6Y=
X-Received: by 2002:a92:4a0d:: with SMTP id m13mr5393074ilf.119.1569599714259;
 Fri, 27 Sep 2019 08:55:14 -0700 (PDT)
MIME-Version: 1.0
References: <8907173e-9f27-6769-09fc-0b82c22d6352@oracle.com>
 <CALMp9eSkognb2hJSuENK+5PSgE8sYzQP=4ioERge6ZaFg1=PEA@mail.gmail.com>
 <cb7c570c-389c-2e96-ba46-555218ba60ed@oracle.com> <CALMp9eQULvr5wKt1Aw3MR+tbeNgvA_4p__6n1YTkWjMHCaEmLw@mail.gmail.com>
 <CALMp9eS1fUVcnVHhty60fUgk3-NuvELMOUFqQmqPLE-Nqy0dFQ@mail.gmail.com>
 <56e7fad0-d577-41db-0b81-363975dc2ca7@redhat.com> <87ftkh6e19.fsf@vitty.brq.redhat.com>
 <6e6f46fe-6e11-c5e3-d80c-327f77b91907@redhat.com> <87d0fl6bv4.fsf@vitty.brq.redhat.com>
 <19db28c0-375a-7bc0-7151-db566ae85de6@redhat.com> <20190927152608.GC25513@linux.intel.com>
 <87a7ap68st.fsf@vitty.brq.redhat.com>
In-Reply-To: <87a7ap68st.fsf@vitty.brq.redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 27 Sep 2019 08:55:02 -0700
Message-ID: <CALMp9eTqWamhCb6cu7AvnVi0u0Y2c5HsG3iaktNANa-JfBODLw@mail.gmail.com>
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

On Fri, Sep 27, 2019 at 8:47 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
>
> > On Fri, Sep 27, 2019 at 05:19:25PM +0200, Paolo Bonzini wrote:
> >> On 27/09/19 16:40, Vitaly Kuznetsov wrote:
> >> > Paolo Bonzini <pbonzini@redhat.com> writes:
> >> >
> >> >> On 27/09/19 15:53, Vitaly Kuznetsov wrote:
> >> >>> Paolo Bonzini <pbonzini@redhat.com> writes:
> >> >>>
> >> >>>> Queued, thanks.
> >> >>>
> >> >>> I'm sorry for late feedback but this commit seems to be causing
> >> >>> selftests failures for me, e.g.:
> >> >>>
> >> >>> # ./x86_64/state_test
> >> >>> Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
> >> >>> Guest physical address width detected: 46
> >> >>> ==== Test Assertion Failure ====
> >> >>>   lib/x86_64/processor.c:1089: r == nmsrs
> >> >>>   pid=14431 tid=14431 - Argument list too long
> >> >>>      1   0x000000000040a55f: vcpu_save_state at processor.c:1088 (discriminator 3)
> >> >>>      2   0x00000000004010e3: main at state_test.c:171 (discriminator 4)
> >> >>>      3   0x00007f881eb453d4: ?? ??:0
> >> >>>      4   0x0000000000401287: _start at ??:?
> >> >>>   Unexpected result from KVM_GET_MSRS, r: 36 (failed at 194)
> >
> > That "failed at %x" print line should really be updated to make it clear
> > that it's printing hex...
> >
>
> Yea, I also wasn't sure and had to look in the code. Will send a patch
> if no one beats me to it.
>
> >> >>> Is this something known already or should I investigate?
> >> >>
> >> >> No, I didn't know about it, it works here.
> >> >>
> >> >
> >> > Ok, this is a bit weird :-) '194' is 'MSR_ARCH_PERFMON_EVENTSEL0 +
> >> > 14'. In intel_pmu_refresh() nr_arch_gp_counters is set to '8', however,
> >> > rdmsr_safe() for this MSR passes in kvm_init_msr_list() (but it fails
> >> > for 0x18e..0x193!) so it stay in the list. get_gp_pmc(), however, checks
> >> > it against nr_arch_gp_counters and returns a failure.
> >>
> >> Huh, 194h apparently is a "FLEX_RATIO" MSR.  I agree that PMU MSRs need
> >> to be checked against CPUID before allowing them.
> >
> > My vote would be to programmatically generate the MSRs using CPUID and the
> > base MSR, as opposed to dumping them into the list and cross-referencing
> > them against CPUID.  E.g. there should also be some form of check that the
> > architectural PMUs are even supported.
>
> Yes. The problem appears to be that msrs_to_save[] and emulated_msrs[]
> are global and for the MSRs in question we check
> kvm_find_cpuid_entry(vcpu, 0xa, ) to find out how many of them are
> available so this can be different for different VMs (and even vCPUs :-)
> However,
>
> "KVM_GET_MSR_INDEX_LIST returns the guest msrs that are supported.  The list
> varies by kvm version and host processor, but does not change otherwise."
>
> So it seems that PMU MSRs just can't be there. Revert?

The API design is unfortunate, but I would argue that any MSR that a
guest *might* support has to be in this list for live migration to
work with the vPMU enabled. I don't know about qemu, but Google's
userspace will only save/restore MSRs that are in this list
