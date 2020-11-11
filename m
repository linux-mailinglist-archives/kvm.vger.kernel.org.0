Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B21B32AF849
	for <lists+kvm@lfdr.de>; Wed, 11 Nov 2020 19:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726570AbgKKSiC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Nov 2020 13:38:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbgKKSiB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Nov 2020 13:38:01 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE654C0613D1
        for <kvm@vger.kernel.org>; Wed, 11 Nov 2020 10:38:01 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id t13so2897387ilp.2
        for <kvm@vger.kernel.org>; Wed, 11 Nov 2020 10:38:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=itPRVLen1rowP5zk81nvH9kq7jIr58useVqCdLSQLXk=;
        b=KgjBqqhPJeuufYEs1HO3OuJg47rvVReykHPTC8gAaSYEKGbN/TiiSi1r4YBVDq2GAD
         +tmsXbpRKvpSNp2Iyxp824P7lagWUcVHVhMpHri3JQN1FZSLDBWgxJMTuDLl8GNtXjJb
         aoL6SqwFcFkaQopoUQzcTsJPWXfNwSA+/UfB1Qw2sBjLo/hoAmt0zhaHNMAWTVZ+oDSn
         ZeIknAjYcb0Kvqb2t7oxwbTrhBAacHU5cCoI4oHALq0TQnFpNZBBl3nTsLM/Rso+wyVQ
         R1/dZ751N7cLC9G02GlMWmbe40ZJUZ1kriou1dr6pPHXyPpJEMGtGFO9cXTibAxKR7nD
         jTyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=itPRVLen1rowP5zk81nvH9kq7jIr58useVqCdLSQLXk=;
        b=XfK4DW4zWjGLyzRj+I4LjHGuqb1OO1dDbHipd221Dmxmyzw0d3DoKqA0YkaxIR6cAp
         KYhFSPBSVnnjm/SkHXUMzjGzmkD6GZns0o5O1Btiw3Ob+UbQt3bJr6nzQ9IX2N+KWose
         w1NmThH3YKO1GFyNURe/x/rRYdi51Nfn8Ffa2yNdU8vAFwyjEwe2zwJ87/WiwD6AXpyS
         XSrumYg1oxvq+IpLMHx82xlUNWI8TmQaQ2v77EK3WAwTJgK5z6aCP57jLuVjEB9f6wH8
         /asVzMRobrRJtUylQ7NwVCwt/VjTM904UhvOFY0aQUiJ0ltWcKTWiitrMmI2SHT4j/DY
         FDKg==
X-Gm-Message-State: AOAM532AQyM7xFdE2RGkzbKnNU3JvMd6GtTEoLSpEjUitEuDdD+ZVvum
        NLgzwOCzA9vVxFXadVmsFSFSR/GpZ2o53wATxZkeH0hvR0nTUg==
X-Google-Smtp-Source: ABdhPJzn6MDHCz3X7qJ+dfFh27Cb89Vr1zhjylWI01o6pZa7vKKlyra6WnfIJAP3a6uLqvWFPvr5igpZEbHz1bZWMpk=
X-Received: by 2002:a05:6e02:bcb:: with SMTP id c11mr18956284ilu.285.1605119880758;
 Wed, 11 Nov 2020 10:38:00 -0800 (PST)
MIME-Version: 1.0
References: <20201110162344.152663d5.zkaspar82@gmail.com> <CANgfPd-gaDhmwPm5CC=cAFn8mBczbUjs7u3KucAGdKmU81Vbeg@mail.gmail.com>
 <20201111120939.54929a50.zkaspar82@gmail.com>
In-Reply-To: <20201111120939.54929a50.zkaspar82@gmail.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 11 Nov 2020 10:37:49 -0800
Message-ID: <CANgfPd_qouM3h-3i=kqZvmpz53_qcj5G8eUbn0L75ZKmtZVtvQ@mail.gmail.com>
Subject: Re: Unable to start VM with 5.10-rc3
To:     Zdenek Kaspar <zkaspar82@gmail.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zdenek,

I'm working on reproducing the issue. I don't have access to a CPU
without EPT, but I tried turning off EPT on a Skylake and I think I
reproduced the issue, but wasn't able to confirm in the logs.

If you were operating without EPT I assume the guest was in non-paging
mode to get into direct_page_fault in the first place. I would still
have expected the root HPA to be valid unless...

Ah, if you're operating with PAE, then the root hpa will be valid but
not have a shadow page associated with it, as it is set to
__pa(vcpu->arch.mmu->pae_root) in mmu_alloc_direct_roots.
In that case, I can see why we get a NULL pointer dereference in
is_tdp_mmu_root.

I will send out a patch that should fix this if the issue is as
described above. I don't have hardware to test this on, but if you
don't mind applying the patch and checking it, that would be awesome.

Ben

On Wed, Nov 11, 2020 at 3:09 AM Zdenek Kaspar <zkaspar82@gmail.com> wrote:
>
> Hi, I'm sure my bisect has nothing to do with KVM,
> because it was quick shot between -rc1 and previous release.
>
> This old CPU doesn't have EPT (see attached file)
>
> ./run_tests.sh
> FAIL apic-split (timeout; duration=90s)
> FAIL ioapic-split (timeout; duration=90s)
> FAIL apic (timeout; duration=30)
> ... ^C
> few RIP is_tdp_mmu_root observed in dmesg
>
> Z.
>
> On Tue, 10 Nov 2020 17:13:21 -0800
> Ben Gardon <bgardon@google.com> wrote:
>
> > Hi Zdenek,
> >
> > That crash is most likely the result of a missing check for an invalid
> > root HPA or NULL shadow page in is_tdp_mmu_root, which could have
> > prevented the NULL pointer dereference.
> > However, I'm not sure how a vCPU got to that point in the page fault
> > handler with a bad EPT root page.
> >
> > I see VMX in your list of flags, is your machine 64 bit with EPT or
> > some other configuration?
> >
> > I'm surprised you are finding your machine unable to boot for
> > bisecting. Do you know if it's crashing in the same spot or somewhere
> > else? I wouldn't expect the KVM page fault handler to run as part of
> > boot.
> >
> > I will send out a patch first thing tomorrow morning (PST) to WARN
> > instead of crashing with a NULL pointer dereference. Are you able to
> > reproduce the issue with any KVM selftest?
> >
> > Ben
> >
> >
> > On Tue, Nov 10, 2020 at 7:24 AM Zdenek Kaspar <zkaspar82@gmail.com>
> > wrote:
> > >
> > > Hi,
> > >
> > > attached file is result from today's linux-master (with fixes
> > > for 5.10-rc4) when I try to start VM on older machine:
> > >
> > > model name      : Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz
> > > flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr
> > > pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ht tm pbe
> > > syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl
> > > cpuid aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16
> > > xtpr pdcm lahf_lm pti tpr_shadow dtherm vmx flags       :
> > > tsc_offset vtpr
> > >
> > > I did quick check with 5.9 (distro kernel) and it works,
> > > but VM performance seems extremely impacted. 5.8 works fine.
> > >
> > > Back to 5.10 issue: it's problematic since 5.10-rc1 and I have no
> > > luck with bisecting (machine doesn't boot).
> > >
> > > TIA, Z.
>
