Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4954441E022
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 19:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352615AbhI3R0V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 13:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352614AbhI3R0T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 13:26:19 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C14C06176F
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 10:24:36 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id b15so28224268lfe.7
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 10:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IOus6RZAODeflkitNKNtNRm/hVuYigDJWYb8TVA+haU=;
        b=D2uC1NpXnCez3Ytp4VABnJkvuhi+0CS1VaFTV4avogW3x4OrLuLLvWQMiRKr1WKS4j
         PTcaPWmLAuGANDqHrTiVVzKCY9yfkwlb8WF6Tf+gfa3rZe5IEYkji7+xmGl3rOEYvXJW
         b5Sk2IDU4tM0PNkXD2K9uOT9iGAlVWXGtu/xvJUhdVEf1oEVw79VV3xiqTZJ6GPco5Hj
         qI41SIPc3djWuAzkAyNJtK2/wFu3txyPfUazgTIrYiidLHB31U5f7cuCCV1DDN0mNPyT
         Ayftn5S5JLoPEABEMCy6hvZqZX0QfyiS0qtlyoTlroaVcP740VEQqqWnj8H9ezw/JFos
         Z8IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IOus6RZAODeflkitNKNtNRm/hVuYigDJWYb8TVA+haU=;
        b=0go42JVFFjUrqpY+lSCiSGWfjFICY8lTNJz8Z0Ii4U6mf4rQhf2/TkmZqQbzvCh4yM
         hu7MJogSwqydHtk32GKKEx+WA3klfUK4jjAI9uqzNzyBXT2hI5B1a3xYFev0IAoPYnLA
         9QTzkpWVYqxg5JlQobiekzxzAqPZ3DDuLeWn3yyEjieRe7MQDo6RjipGwftYVyWgZJiD
         84KDebMJlFbd4687KUGdPgbuSjDCFkRBVHMRDMH32BWHROJPwacXC/pS463SRcyCZxTr
         v3/RbGcD/3qFDVlD2PCphpk4Q2QM5/dObPXPXMH+kEGR5LBanC/fRLj2NANjvbJYjLfC
         HrqA==
X-Gm-Message-State: AOAM5318+/jVDAbLGFu4JO0Wuz4UaTjL6/dBiVNPhCERJD9EspQuXX/p
        NrV5aD/408ASY7kAHIC1w1WsLfqTb7nWe0GYbqGzCA==
X-Google-Smtp-Source: ABdhPJwfSVC7//d6/e+fZoayLkD2H1zJPhp0sz/K7FbaHBHjYfcsEHPJ7CByH+JJAViNtjzQ2spoMMRGnDDx4TU0YSE=
X-Received: by 2002:a2e:95cc:: with SMTP id y12mr7165903ljh.337.1633022674911;
 Thu, 30 Sep 2021 10:24:34 -0700 (PDT)
MIME-Version: 1.0
References: <YSVhV+UIMY12u2PW@google.com> <87mtp5q3gx.wl-maz@kernel.org>
 <CAOQ_QshSaEm_cMYQfRTaXJwnVqeoN29rMLBej-snWd6_0HsgGw@mail.gmail.com>
 <87fsuxq049.wl-maz@kernel.org> <20210825150713.5rpwzm4grfn7akcw@gator.home>
 <CAOQ_QsgWiw9-BuGTUFpHqBw3simUaM4Tweb9y5_oz1UHdr4ELg@mail.gmail.com>
 <877dg8ppnt.wl-maz@kernel.org> <YSfiN3Xq1vUzHeap@google.com>
 <20210827074011.ci2kzo4cnlp3qz7h@gator.home> <CAOQ_Qsg2dKLLanSx6nMbC1Er9DSO3peLVEAJNvU1ZcRVmwaXgQ@mail.gmail.com>
 <87ilyitt6e.wl-maz@kernel.org>
In-Reply-To: <87ilyitt6e.wl-maz@kernel.org>
From:   Oliver Upton <oupton@google.com>
Date:   Thu, 30 Sep 2021 10:24:23 -0700
Message-ID: <CAOQ_QshfXEGL691_MOJn0YbL94fchrngP8vuFReCW-=5UQtNKQ@mail.gmail.com>
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

Hey Marc,

On Thu, Sep 30, 2021 at 12:32 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Oliver,
>
> On Wed, 29 Sep 2021 19:22:05 +0100,
> Oliver Upton <oupton@google.com> wrote:
> >
> > I have some lingering thoughts on this subject since we last spoke and
> > wanted to discuss.
> >
> > I'm having a hard time figuring out how a VMM should handle a new
> > hypercall identity register introduced on a newer kernel. In order to
> > maintain guest ABI, the VMM would need to know about that register and
> > zero it when restoring an older guest.
>
> Just as it would need to be able to discover any new system register
> exposed by default, as it happens at all times. Which is why we have a
> way to discover all the registers, architected or not.
>
> > Perhaps instead we could reserve a range of firmware registers as the
> > 'hypercall identity' registers. Implement all of them as RAZ/WI by
> > default, encouraging userspace to zero these registers away for older
> > VMs but still allowing an old userspace to pick up new KVM features.
> > Doing so would align the hypercall identity registers with the feature
> > ID registers from the architecture.
>
> The range already exists in the form of the "coprocessor" 0x14. I
> don't see the need to expose it as RAZ/WI, however. If userspace
> doesn't know about how this pseudo-register works, it won't be able to
> program it anyway.
>
> I don't buy the parallel with the ID-regs either. They are RAZ/WI by
> default so that they don't UNDEF at runtime. The meaning of a RAZ
> id-register is also well defined (feature not implemented), and the
> CPU cannot write to them. In a way, the ID-regs *are* the enumeration
> mechanism.
>
> Our firmware registers don't follow the same rules. Userspace can
> write to them, and there is no such "not implemented" rule (case in
> point, PSCI). We also have a separate enumeration mechanism
> (GET_ONE_REG), which is (more or less) designed for userspace to find
> what is implemented.
>
> For these reasons, I don't immediately see the point of advertising a
> set of registers ahead of time, before userspace grows an
> understanding of what these registers mean.

Supposing we don't preallocate some hypercall ID registers, how can we
safely migrate a guest from an older kernel to newer kernel? Ideally,
we would preserve the hypercall feature set across the migration which
could work for a while with the first set of registers that get
defined, but whenever a new hypercall firmware register comes along
then the VMM will be clueless to the new ABI.

Fundamentally, I don't think userspace should need a patch to preserve
ABI on a newer kernel. Despite that, it would seem that userspace will
need to learn of any firmware registers that control hypercall
features which come after the initial set that gets proposed. If
KVM_GET_REG_LIST were to disambiguate between ID registers (hypercall,
architectural feature ID registers) from other parts of the vCPU
state, it would be clear to what registers to zero on a newer kernel.
Apologies if it is distracting to mention the feature ID registers
here, but both are on my mind currently and want to make sure there is
some consistency in how features get handled on newer kernels,
architected or not.

--
Thanks,
Oliver
