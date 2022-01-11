Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5473948B624
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 19:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350220AbiAKSw5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 13:52:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350167AbiAKSw5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 13:52:57 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD04C061748
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 10:52:56 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id 127so33793001ybb.4
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 10:52:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=17MefAb7Wq51LBItM83lwZITi4By/+6kifCdUczNHes=;
        b=qe/vTFEQwfqq+6k74r7b8ljqbjo6ywjiHIZvlXWsbp5cgSwDmZeXP7KquwvmXWtxan
         WIiTsy2bpJ3Edfi0fwgbn5KlEpxI2ct3pCgIQKEnBSsz9YU9mHCiLnH+HrlrvTEJAXQn
         WVPTmLVQeydNcrhrRk3YLrFt9UfEKFk0/QkK/5QWu4sHXrkFZBC/aTcv04KZJzB5HBzx
         OhyWzwxYcxgwBacEU0iNLa8PTrZ1sXHyo/H944RQ2AhQlHyUEVjKaDLxyotS/00b3/3A
         fBQkmgyjGXxOEqWLhMJ/5pZN9YoOzuYeXLnoN+OS+gfAM+/oQhmnjHPWIna3AQU/mNw1
         8hfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=17MefAb7Wq51LBItM83lwZITi4By/+6kifCdUczNHes=;
        b=yoyQu4/l0Xe+GUwDUSFjgTWoGB9V+2IwulbMh9u8wmFdyJgxP6r467kt5t36NdtGvE
         iQ7FilLHTgH/7l5IBShnbc+s5WM3yUwa1nUiNWE1eAwYXNgNwhbRX7qESu1vSluz6IgU
         4CwmHN8bmiN/7X87u2V1wL8ZpRW2RAyloymli6HCkr99OPXeGYjP0OC10RlATzlWrsHy
         i91JI/FUlZ6XfPFdo1/9/8dTr3VGTHTHKsFKsvGonYIU1X1FRA0ncnizrz78BJLdGcjF
         9oqWBS10AZbu06C6kJXOhNsQP6g55T/MPP9wHjCGmHrWMI8cu1WSi14e6bAJB3r2a5pu
         bA3A==
X-Gm-Message-State: AOAM532qTpXvizSgbCKCkQ87p9WNlwPnaLYsPKz8UpaAqJhDUtN9kqe+
        yGj2SEJV4XwSYh4pyeOMnSwVwEjf/K2mgZcJkF8c2A==
X-Google-Smtp-Source: ABdhPJyn0Wq/OnTFO+pZZsGiPNj88pyrxrt8LxfP010ZWFUMpcdrTES6feVX3nFLo0tTGlZ2e9VdGfMDeGrY622KE1E=
X-Received: by 2002:a25:c841:: with SMTP id y62mr8486367ybf.196.1641927175898;
 Tue, 11 Jan 2022 10:52:55 -0800 (PST)
MIME-Version: 1.0
References: <20220104194918.373612-1-rananta@google.com> <20220104194918.373612-2-rananta@google.com>
 <CAAeT=Fxyct=WLUvfbpROKwB9huyt+QdJnKTaj8c5NKk+UY51WQ@mail.gmail.com>
 <CAJHc60za+E-zEO5v2QeKuifoXznPnt5n--g1dAN5jgsuq+SxrA@mail.gmail.com>
 <CALMp9eQDzqoJMck=_agEZNU9FJY9LB=iW-8hkrRc20NtqN=gDA@mail.gmail.com>
 <CAJHc60xZ9emY9Rs9ZbV+AH-Mjmkyg4JZU7V16TF48C-HJn+n4A@mail.gmail.com> <CALMp9eTPJZDtMiHZ5XRiYw2NR9EBKSfcP5CYddzyd2cgWsJ9hw@mail.gmail.com>
In-Reply-To: <CALMp9eTPJZDtMiHZ5XRiYw2NR9EBKSfcP5CYddzyd2cgWsJ9hw@mail.gmail.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Tue, 11 Jan 2022 10:52:45 -0800
Message-ID: <CAJHc60xD2U36pM4+Dq3yZw6Cokk-16X83JHMPXj4aFnxOJ3BUQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 01/11] KVM: Capture VM start
To:     Jim Mattson <jmattson@google.com>
Cc:     Reiji Watanabe <reijiw@google.com>, Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 10, 2022 at 3:57 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Mon, Jan 10, 2022 at 3:07 PM Raghavendra Rao Ananta
> <rananta@google.com> wrote:
> >
> > On Fri, Jan 7, 2022 at 4:05 PM Jim Mattson <jmattson@google.com> wrote:
> > >
> > > On Fri, Jan 7, 2022 at 3:43 PM Raghavendra Rao Ananta
> > > <rananta@google.com> wrote:
> > > >
> > > > Hi Reiji,
> > > >
> > > > On Thu, Jan 6, 2022 at 10:07 PM Reiji Watanabe <reijiw@google.com> wrote:
> > > > >
> > > > > Hi Raghu,
> > > > >
> > > > > On Tue, Jan 4, 2022 at 11:49 AM Raghavendra Rao Ananta
> > > > > <rananta@google.com> wrote:
> > > > > >
> > > > > > Capture the start of the KVM VM, which is basically the
> > > > > > start of any vCPU run. This state of the VM is helpful
> > > > > > in the upcoming patches to prevent user-space from
> > > > > > configuring certain VM features after the VM has started
> > > > > > running.
> > >
> > > What about live migration, where the VM has already technically been
> > > started before the first call to KVM_RUN?
> >
> > My understanding is that a new 'struct kvm' is created on the target
> > machine and this flag should be reset, which would allow the VMM to
> > restore the firmware registers. However, we would be running KVM_RUN
> > for the first time on the target machine, thus setting the flag.
> > So, you are right; It's more of a resume operation from the guest's
> > point of view. I guess the name of the variable is what's confusing
> > here.
>
> I was actually thinking that live migration gives userspace an easy
> way to circumvent your restriction. You said, "This state of the VM is
> helpful in the upcoming patches to prevent user-space from configuring
> certain VM features after the VM has started running." However, if you
> don't ensure that these VM features are configured the same way on the
> target machine as they were on the source machine, you have not
> actually accomplished your stated goal.
>
Isn't that up to the VMM to save/restore and validate the registers
across migrations?
Perhaps I have to re-word my intentions for the patch- userspace
should be able to configure the registers before issuing the first
KVM_RUN.

Thanks,
Raghavendra

> > Thanks,
> > Raghavendra
