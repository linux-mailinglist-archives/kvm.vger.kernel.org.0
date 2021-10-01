Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5406D41F15E
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 17:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355077AbhJAPkp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 11:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355081AbhJAPkh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Oct 2021 11:40:37 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22B5C06177C
        for <kvm@vger.kernel.org>; Fri,  1 Oct 2021 08:38:48 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id x27so40422665lfu.5
        for <kvm@vger.kernel.org>; Fri, 01 Oct 2021 08:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=caDxly+TDg5GzXq8rhIFgWm2KHSBFQbAt3cPO0aQ+jQ=;
        b=RXCgo3jcLnJ39FiTHCfHTdVYahi5odm2B84SoHXN17WiY57B5UdEFaKyH/D+Ajgj0O
         M/Lr1fZOMW/KOvaMaPn7TbpvoAIOD2/XcrJY1z9Q91fd/baKA4vlr76/UPGS9gKy6jtO
         QxmcKWjkliAUmxiz41cbqPhzSize17LKGbH8hpf2wirkGVf1kAim/5hlHYXxrFZ3ewWl
         E22rCstiDejoueilAf2/0B0W7u5s/NpLS1+cnc0fRDcZezV8N7LBh4FDnz8XDBS2vNFR
         MC6X0qtpiVf+duHH5DqsIuYOeUqyMmlq6JbOe+lB5h/ZLHbiFqvl5awppSPdaLBUt7h4
         0XIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=caDxly+TDg5GzXq8rhIFgWm2KHSBFQbAt3cPO0aQ+jQ=;
        b=gKCGcDxh9FNNXmoVck6w/ssPmaG7wpGvL9qt/kZgbYkafDrtxgceU9U//06z6b/Qqi
         gsRmnfKapcy4rD0wh0bqL/l7z5SV/YY2QXBRhI81cd+cB1hi6Rlc5IKbHOfYsu7h6nBV
         kFG/fJegcVPT2VGWorosSZYyXOaJxjE57wVomrzfEKgePgKBnAir+bLjqiXR/Rm4jxyE
         4HP5Ig5tIjwFR66iRLh5WuXHpeuIuXdKKmVIG7gwbCqYmvYtDdRS3qikxayHqBB8qpI6
         RSat8wq7/tNUzVH0DOmMP09iDdAWp4meXFX/1bpRVq8g64kb/Gk5UoTXP+qH2I4k3Dhz
         B39A==
X-Gm-Message-State: AOAM531LlWNUKyjF9D9+UcqJ8+CAWOWxTtAj4VeFr0J2WqdYXRTXyKMd
        u7//kfA7hh9evtGJguFOIgwR2GV1JYJMJaQQ2deeYUMV/25RBw==
X-Google-Smtp-Source: ABdhPJw8nB4dkJ+kFhDR8bcfgS2uOXJXL4vm8BM/whq82kReOofwAMMvIocOR1ZzBz2SuaPtCZ/tuNIZZraVQHQA6Ek=
X-Received: by 2002:ac2:4217:: with SMTP id y23mr5976320lfh.361.1633102726741;
 Fri, 01 Oct 2021 08:38:46 -0700 (PDT)
MIME-Version: 1.0
References: <YSVhV+UIMY12u2PW@google.com> <87mtp5q3gx.wl-maz@kernel.org>
 <CAOQ_QshSaEm_cMYQfRTaXJwnVqeoN29rMLBej-snWd6_0HsgGw@mail.gmail.com>
 <87fsuxq049.wl-maz@kernel.org> <20210825150713.5rpwzm4grfn7akcw@gator.home>
 <CAOQ_QsgWiw9-BuGTUFpHqBw3simUaM4Tweb9y5_oz1UHdr4ELg@mail.gmail.com>
 <877dg8ppnt.wl-maz@kernel.org> <YSfiN3Xq1vUzHeap@google.com>
 <20210827074011.ci2kzo4cnlp3qz7h@gator.home> <CAOQ_Qsg2dKLLanSx6nMbC1Er9DSO3peLVEAJNvU1ZcRVmwaXgQ@mail.gmail.com>
 <87ilyitt6e.wl-maz@kernel.org> <CAOQ_QshfXEGL691_MOJn0YbL94fchrngP8vuFReCW-=5UQtNKQ@mail.gmail.com>
 <87lf3drmvp.wl-maz@kernel.org>
In-Reply-To: <87lf3drmvp.wl-maz@kernel.org>
From:   Oliver Upton <oupton@google.com>
Date:   Fri, 1 Oct 2021 08:38:35 -0700
Message-ID: <CAOQ_QsjVk9n7X9E76ycWBNguydPE0sVvywvKW0jJ_O58A0NJHg@mail.gmail.com>
Subject: Re: KVM/arm64: Guest ABI changes do not appear rollback-safe
To:     Marc Zyngier <maz@kernel.org>
Cc:     Andrew Jones <drjones@redhat.com>, kvmarm@lists.cs.columbia.edu,
        pshier@google.com, ricarkol@google.com, rananta@google.com,
        reijiw@google.com, jingzhangos@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
        Alexandru.Elisei@arm.com, suzuki.poulose@arm.com,
        Peter Maydell <peter.maydell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 1, 2021 at 4:43 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 30 Sep 2021 18:24:23 +0100,
> Oliver Upton <oupton@google.com> wrote:
> >
> > Hey Marc,
> >
> > On Thu, Sep 30, 2021 at 12:32 AM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > Hi Oliver,
> > >
> > > On Wed, 29 Sep 2021 19:22:05 +0100,
> > > Oliver Upton <oupton@google.com> wrote:
> > > >
> > > > I have some lingering thoughts on this subject since we last spoke and
> > > > wanted to discuss.
> > > >
> > > > I'm having a hard time figuring out how a VMM should handle a new
> > > > hypercall identity register introduced on a newer kernel. In order to
> > > > maintain guest ABI, the VMM would need to know about that register and
> > > > zero it when restoring an older guest.
> > >
> > > Just as it would need to be able to discover any new system register
> > > exposed by default, as it happens at all times. Which is why we have a
> > > way to discover all the registers, architected or not.
> > >
> > > > Perhaps instead we could reserve a range of firmware registers as the
> > > > 'hypercall identity' registers. Implement all of them as RAZ/WI by
> > > > default, encouraging userspace to zero these registers away for older
> > > > VMs but still allowing an old userspace to pick up new KVM features.
> > > > Doing so would align the hypercall identity registers with the feature
> > > > ID registers from the architecture.
> > >
> > > The range already exists in the form of the "coprocessor" 0x14. I
> > > don't see the need to expose it as RAZ/WI, however. If userspace
> > > doesn't know about how this pseudo-register works, it won't be able to
> > > program it anyway.
> > >
> > > I don't buy the parallel with the ID-regs either. They are RAZ/WI by
> > > default so that they don't UNDEF at runtime. The meaning of a RAZ
> > > id-register is also well defined (feature not implemented), and the
> > > CPU cannot write to them. In a way, the ID-regs *are* the enumeration
> > > mechanism.
> > >
> > > Our firmware registers don't follow the same rules. Userspace can
> > > write to them, and there is no such "not implemented" rule (case in
> > > point, PSCI). We also have a separate enumeration mechanism
> > > (GET_ONE_REG), which is (more or less) designed for userspace to find
> > > what is implemented.
> > >
> > > For these reasons, I don't immediately see the point of advertising a
> > > set of registers ahead of time, before userspace grows an
> > > understanding of what these registers mean.
> >
> > Supposing we don't preallocate some hypercall ID registers, how can we
> > safely migrate a guest from an older kernel to newer kernel? Ideally,
> > we would preserve the hypercall feature set across the migration which
> > could work for a while with the first set of registers that get
> > defined, but whenever a new hypercall firmware register comes along
> > then the VMM will be clueless to the new ABI.
>
> My expectations were that whenever userspace writes a set of firmware
> register, all the defaults are invalidated. For example say that
> host-A know about a single hypercall register, while host-B knows
> about two. Upon writing to the first register, the host would clear
> the set of available services in the second one. If userspace
> eventually writes there, the value would stick if valid.
>
> Also, remember that pseudo-registers don't have to be 64bit. We could
> define a new class of hypercall-specific registers that would be much
> wider, and thus have a larger write granularity (KVM supports anything
> from 8 to 2048 bits). This would make it pretty easy to implement the
> above.
>
> > Fundamentally, I don't think userspace should need a patch to preserve
> > ABI on a newer kernel. Despite that, it would seem that userspace will
> > need to learn of any firmware registers that control hypercall
> > features which come after the initial set that gets proposed. If
> > KVM_GET_REG_LIST were to disambiguate between ID registers (hypercall,
> > architectural feature ID registers) from other parts of the vCPU
> > state, it would be clear to what registers to zero on a newer kernel.
> > Apologies if it is distracting to mention the feature ID registers
> > here, but both are on my mind currently and want to make sure there is
> > some consistency in how features get handled on newer kernels,
> > architected or not.
>
> The problem I see is that we will always need to grow the HC register
> space one way or another, no matter how many we reserve. Your approach
> only works if we don't exceed that particular range. Maybe it will
> never be a problem, but it remains that this is not scalable.
>
> If we wanted to be safe, we'd reserve the whole of the possible space
> as defined by the SMCCC spec. Given that we currently have two HC
> spaces (the ARM-controlled one, and the KVM-specific one), the
> function space being 16bits in each case, that's 16kB worth of zeroes
> that userspace has to save/restore at all times... I'm not overly
> enthusiastic.

Yeah, that's definitely overkill.

I agree with your position; we can solve the issue altogether by
enforcing ordering on the hypercall registers. Userspace should read
all hypercall registers to discover features, then write them. Given
your suggestion, I don't know if there is much need for the guesswork
to conclude on an appropriate register size for the hypercall bitmaps.
64 bits seems fine to me..

--
Thanks,
Oliver
