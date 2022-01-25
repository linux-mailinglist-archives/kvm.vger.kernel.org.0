Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53ED249AC1C
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 07:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239967AbiAYGAk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 01:00:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232079AbiAYF1W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 00:27:22 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA565C0797BF
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 19:47:17 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id k17so2575875ybk.6
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 19:47:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3JStU3NdQOz3moQMwSNGHWkyavUfFkQRe4Ox6rYyRZo=;
        b=s2sH5NPOvw0cLy+zlBKOOBMD1XkTLO8+WwiEIZfbrK7vE+IoRYT6mQ8RE2ZxYT5HD+
         M0IPP0igg1Vu34gs6oEVbbrxBf51x4M9Qxb2yhUc4Jcn3dqtHE/rf2qRE3CSZBwfW5tF
         nv2hstN2C8bpSsG8fHKUOM3VY0a7ODBMpav5zNUpwoKRc/2OnFH5b79YDkOIfEyr/335
         X4eTBTLCr0RRtgTv639Wk63/Fc1iCQDbezm3e3Qe203qZszFhl8WesWQdaQKU5mz9mqM
         KR5TthJp8xPt2rrd+jUgBVVNU1d2E+aHYyz1672JWWgMf1i4YerXJU4XmBupjjBavoOy
         o7pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3JStU3NdQOz3moQMwSNGHWkyavUfFkQRe4Ox6rYyRZo=;
        b=p9veyfn9dGAnr6PsP2PuIvliEW6YtLXG9Dg/k4ZGBsDekTE/YpfvMS6dgu8bUSuOgq
         s2PsjmwdhJI5X+g9JPXiqhA1s7nN6IKSukTWbgNBWOnTis4Dj0i6RbuwGzJlObgfnzvm
         YfK4jHkleVf/vESP+UmeoKi+uyVmSlKBnZNKakQlzUi11iOQoQvehG60RLPa0qbWqezk
         MfdJkcoRfe1gjTT/vvMwI5RgHf31r5pJFhdAuXhwKtTYrdHL5S/w7fEGRMvhIOe+ZwhA
         zp+ijbUAGOu9nD1ce9Szn4DG4OEKbD3R6BnFoQs52rRuZ5a5DKDOzc+HFA32n06Pogk8
         0ZXg==
X-Gm-Message-State: AOAM531uv3D9ZNCndvJkjAHjIrF5vlj1a+rF/aLfhpEO5UJ1GzIMHWNQ
        OjnsHrZW6ftnk1ZKH2YLPekDVSVjHuQS6cTe70DMrw==
X-Google-Smtp-Source: ABdhPJywssp8SsyP3pLaqLGoUHU33BtaZIVWcYSInCrUc6yOhzdrIxiAgEeeO1te/rBPfJsTjsOMnAR2SKxdTVoGodA=
X-Received: by 2002:a25:343:: with SMTP id 64mr28185944ybd.497.1643082436766;
 Mon, 24 Jan 2022 19:47:16 -0800 (PST)
MIME-Version: 1.0
References: <YSVhV+UIMY12u2PW@google.com> <87mtp5q3gx.wl-maz@kernel.org>
 <CAOQ_QshSaEm_cMYQfRTaXJwnVqeoN29rMLBej-snWd6_0HsgGw@mail.gmail.com>
 <87fsuxq049.wl-maz@kernel.org> <20210825150713.5rpwzm4grfn7akcw@gator.home>
 <CAOQ_QsgWiw9-BuGTUFpHqBw3simUaM4Tweb9y5_oz1UHdr4ELg@mail.gmail.com>
 <877dg8ppnt.wl-maz@kernel.org> <YSfiN3Xq1vUzHeap@google.com>
 <20210827074011.ci2kzo4cnlp3qz7h@gator.home> <CAOQ_Qsg2dKLLanSx6nMbC1Er9DSO3peLVEAJNvU1ZcRVmwaXgQ@mail.gmail.com>
 <87ilyitt6e.wl-maz@kernel.org> <CAOQ_QshfXEGL691_MOJn0YbL94fchrngP8vuFReCW-=5UQtNKQ@mail.gmail.com>
 <87lf3drmvp.wl-maz@kernel.org> <CAOQ_QsjVk9n7X9E76ycWBNguydPE0sVvywvKW0jJ_O58A0NJHg@mail.gmail.com>
In-Reply-To: <CAOQ_QsjVk9n7X9E76ycWBNguydPE0sVvywvKW0jJ_O58A0NJHg@mail.gmail.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Mon, 24 Jan 2022 19:47:04 -0800
Message-ID: <CAJHc60wp4uCVQhigNrNxF3pPd_8RPHXQvK+gf7rSxCRfH6KwFg@mail.gmail.com>
Subject: Re: KVM/arm64: Guest ABI changes do not appear rollback-safe
To:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, pshier@google.com,
        ricarkol@google.com, reijiw@google.com, jingzhangos@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, Peter Maydell <peter.maydell@linaro.org>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello all,

Based on the recent discussion on the patch '[RFC PATCH v3 01/11] KVM:
Capture VM start' [1], Reiji, I (and others in the team) were
wondering, since the hypercall feature-map is technically per-VM and
not per-vCPU, would it make more sense to present it as a kvm_device,
rather than vCPU psuedo-registers to the userspace?

If I understand correctly, the original motivation for going with
pseudo-registers was to comply with QEMU, which uses KVM_GET_REG_LIST
and KVM_[GET|SET]_ONE_REG interface, but I'm guessing the VMMs doing
save/restore across migration might write the same values for every
vCPU.

Granted that we would be diverging from the existing implementation
(psci versioning and spectre WA registers), but this can be a cleaner
way forward for extending hypercall support. The kvm_device interface
can be made backward compatible with the way hypercalls are exposed
today, it can have the same registers/features discovery mechanisms
that we discussed above, and majorly the userspace has to configure it
only once per-VM. We can probably make the feature selection immutable
just before any vCPU is created.

Please let me know your thoughts or any disadvantages that I'm overlooking.

Thanks,
Raghavendra

[1]: https://lore.kernel.org/kvmarm/CAJHc60zhRyOad7AqtEFn-Ptro5BGVkfpB2wXWGw5EZMxOHUc=w@mail.gmail.com/



On Fri, Oct 1, 2021 at 8:38 AM Oliver Upton <oupton@google.com> wrote:
>
> On Fri, Oct 1, 2021 at 4:43 AM Marc Zyngier <maz@kernel.org> wrote:
> >
> > On Thu, 30 Sep 2021 18:24:23 +0100,
> > Oliver Upton <oupton@google.com> wrote:
> > >
> > > Hey Marc,
> > >
> > > On Thu, Sep 30, 2021 at 12:32 AM Marc Zyngier <maz@kernel.org> wrote:
> > > >
> > > > Hi Oliver,
> > > >
> > > > On Wed, 29 Sep 2021 19:22:05 +0100,
> > > > Oliver Upton <oupton@google.com> wrote:
> > > > >
> > > > > I have some lingering thoughts on this subject since we last spoke and
> > > > > wanted to discuss.
> > > > >
> > > > > I'm having a hard time figuring out how a VMM should handle a new
> > > > > hypercall identity register introduced on a newer kernel. In order to
> > > > > maintain guest ABI, the VMM would need to know about that register and
> > > > > zero it when restoring an older guest.
> > > >
> > > > Just as it would need to be able to discover any new system register
> > > > exposed by default, as it happens at all times. Which is why we have a
> > > > way to discover all the registers, architected or not.
> > > >
> > > > > Perhaps instead we could reserve a range of firmware registers as the
> > > > > 'hypercall identity' registers. Implement all of them as RAZ/WI by
> > > > > default, encouraging userspace to zero these registers away for older
> > > > > VMs but still allowing an old userspace to pick up new KVM features.
> > > > > Doing so would align the hypercall identity registers with the feature
> > > > > ID registers from the architecture.
> > > >
> > > > The range already exists in the form of the "coprocessor" 0x14. I
> > > > don't see the need to expose it as RAZ/WI, however. If userspace
> > > > doesn't know about how this pseudo-register works, it won't be able to
> > > > program it anyway.
> > > >
> > > > I don't buy the parallel with the ID-regs either. They are RAZ/WI by
> > > > default so that they don't UNDEF at runtime. The meaning of a RAZ
> > > > id-register is also well defined (feature not implemented), and the
> > > > CPU cannot write to them. In a way, the ID-regs *are* the enumeration
> > > > mechanism.
> > > >
> > > > Our firmware registers don't follow the same rules. Userspace can
> > > > write to them, and there is no such "not implemented" rule (case in
> > > > point, PSCI). We also have a separate enumeration mechanism
> > > > (GET_ONE_REG), which is (more or less) designed for userspace to find
> > > > what is implemented.
> > > >
> > > > For these reasons, I don't immediately see the point of advertising a
> > > > set of registers ahead of time, before userspace grows an
> > > > understanding of what these registers mean.
> > >
> > > Supposing we don't preallocate some hypercall ID registers, how can we
> > > safely migrate a guest from an older kernel to newer kernel? Ideally,
> > > we would preserve the hypercall feature set across the migration which
> > > could work for a while with the first set of registers that get
> > > defined, but whenever a new hypercall firmware register comes along
> > > then the VMM will be clueless to the new ABI.
> >
> > My expectations were that whenever userspace writes a set of firmware
> > register, all the defaults are invalidated. For example say that
> > host-A know about a single hypercall register, while host-B knows
> > about two. Upon writing to the first register, the host would clear
> > the set of available services in the second one. If userspace
> > eventually writes there, the value would stick if valid.
> >
> > Also, remember that pseudo-registers don't have to be 64bit. We could
> > define a new class of hypercall-specific registers that would be much
> > wider, and thus have a larger write granularity (KVM supports anything
> > from 8 to 2048 bits). This would make it pretty easy to implement the
> > above.
> >
> > > Fundamentally, I don't think userspace should need a patch to preserve
> > > ABI on a newer kernel. Despite that, it would seem that userspace will
> > > need to learn of any firmware registers that control hypercall
> > > features which come after the initial set that gets proposed. If
> > > KVM_GET_REG_LIST were to disambiguate between ID registers (hypercall,
> > > architectural feature ID registers) from other parts of the vCPU
> > > state, it would be clear to what registers to zero on a newer kernel.
> > > Apologies if it is distracting to mention the feature ID registers
> > > here, but both are on my mind currently and want to make sure there is
> > > some consistency in how features get handled on newer kernels,
> > > architected or not.
> >
> > The problem I see is that we will always need to grow the HC register
> > space one way or another, no matter how many we reserve. Your approach
> > only works if we don't exceed that particular range. Maybe it will
> > never be a problem, but it remains that this is not scalable.
> >
> > If we wanted to be safe, we'd reserve the whole of the possible space
> > as defined by the SMCCC spec. Given that we currently have two HC
> > spaces (the ARM-controlled one, and the KVM-specific one), the
> > function space being 16bits in each case, that's 16kB worth of zeroes
> > that userspace has to save/restore at all times... I'm not overly
> > enthusiastic.
>
> Yeah, that's definitely overkill.
>
> I agree with your position; we can solve the issue altogether by
> enforcing ordering on the hypercall registers. Userspace should read
> all hypercall registers to discover features, then write them. Given
> your suggestion, I don't know if there is much need for the guesswork
> to conclude on an appropriate register size for the hypercall bitmaps.
> 64 bits seems fine to me..
>
> --
> Thanks,
> Oliver
