Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0AE72ECD04
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 10:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbhAGJl7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 04:41:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727770AbhAGJlz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 04:41:55 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B44BC0612F5;
        Thu,  7 Jan 2021 01:41:15 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id w124so6765418oia.6;
        Thu, 07 Jan 2021 01:41:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=07CQdayrVUCOmFfJbKyB6H+lGHZIcXlD5ztce6dGZb4=;
        b=F4HfC9tNbEpV+xPrU3x2kF2k4GD71u7PRb84PGwizPAUXO4WP/LosXpb4tF6nVNUmv
         yKpovtwBG61ASwGyaGQi32HEj/6BHaIW7XYdz7ik8NF0G5HOy3LS7kuoDY7dyYKZGiiX
         ZunYdgmeuYPOQ7MzbQp1Fu5f+BhkESxL3wXbc3xyEsT3/I2Oi/4F2KPqHtBdInnt/M8i
         FeX3ctUZVNHPYwISKOkC0Js839LvnzqCYPKQNigsRmuqdDvorYGdzuIEhkEDorPEZ+VU
         OxMSZNNVt91gd6QQ1o1FADNPMU5IsKJ/V6gfuv/0Pg++Q9wdGVu5P7VZo7RwM2gWHUuV
         b/mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=07CQdayrVUCOmFfJbKyB6H+lGHZIcXlD5ztce6dGZb4=;
        b=qV3j0uTCETogh6EPz9+XyMAhP8s/Af+PcRsFInbwY7Sl38n25VtviyHWqiiPmGu9I8
         CaMqLnodjKaDkCIjil60yosDaY4sM7prCP9j6/GSwuBu3+jpdtxQIiUkKgq+Y01lM0Pf
         xsPgB1o3ew4aa9zCmOmPOzHeS+FMQjx0Vk20lvx3nSJv8WnD+VflQJKPrzaVHM2bfarK
         L7NqaljMPmKXF1Vq3HemdMdAehOmJ0LsTovd6S4Ed9VBnjhV8h04CMeW8vPdm2+1yWYe
         QFr7Kl77IM1mvsVFuTwVQDDusW/OzZ+vrlB/Roj2ldDhVOKxyc4aoIfN+PpHdOPPUSGh
         Ng5A==
X-Gm-Message-State: AOAM532YNikP6dcb3tkwsbvvQw+Abey/UEmjWELNra40Fe8tzFAewFbm
        YLiHSFas/eX2hoR8UNi0FuLYP944ZjYKeInXifU=
X-Google-Smtp-Source: ABdhPJzMAQJFJ2VHCewfKniMGCOfKs3FvgcTBOQtn/yDFMAZsYQNBRcbDFgcyVAvpElixHUO6hJbI2yGSFez+ORxZvk=
X-Received: by 2002:aca:6202:: with SMTP id w2mr5667587oib.5.1610012474555;
 Thu, 07 Jan 2021 01:41:14 -0800 (PST)
MIME-Version: 1.0
References: <20210105192844.296277-1-nitesh@redhat.com> <874kjuidgp.fsf@vitty.brq.redhat.com>
 <X/XvWG18aBWocvvf@google.com> <87ble1gkgx.fsf@vitty.brq.redhat.com>
In-Reply-To: <87ble1gkgx.fsf@vitty.brq.redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 7 Jan 2021 17:41:03 +0800
Message-ID: <CANRm+CzXOiWV1dUQiN69TZijifBqiNoJ-b6z58yoGw51Pu1+6g@mail.gmail.com>
Subject: Re: [PATCH] Revert "KVM: x86: Unconditionally enable irqs in guest context"
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        w90p710@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 7 Jan 2021 at 17:35, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Sean Christopherson <seanjc@google.com> writes:
>
> > On Wed, Jan 06, 2021, Vitaly Kuznetsov wrote:
> >>
> >> Looking back, I don't quite understand why we wanted to account ticks
> >> between vmexit and exiting guest context as 'guest' in the first place;
> >> to my understanging 'guest time' is time spent within VMX non-root
> >> operation, the rest is KVM overhead (system).
> >
> > With tick-based accounting, if the tick IRQ is received after PF_VCPU is cleared
> > then that tick will be accounted to the host/system.  The motivation for opening
> > an IRQ window after VM-Exit is to handle the case where the guest is constantly
> > exiting for a different reason _just_ before the tick arrives, e.g. if the guest
> > has its tick configured such that the guest and host ticks get synchronized
> > in a bad way.
> >
> > This is a non-issue when using CONFIG_VIRT_CPU_ACCOUNTING_GEN=y, at least with a
> > stable TSC, as the accounting happens during guest_exit_irqoff() itself.
> > Accounting might be less-than-stellar if TSC is unstable, but I don't think it
> > would be as binary of a failure as tick-based accounting.
> >
>
> Oh, yea, I vaguely remember we had to deal with a very similar problem
> but for userspace/kernel accounting. It was possible to observe e.g. a
> userspace task going 100% kernel while in reality it was just perfectly
> synchronized with the tick and doing a syscall just before it arrives
> (or something like that, I may be misremembering the details).

Yes. :)  commit 2a42eb9594a1 ("sched/cputime: Accumulate vtime on top
of nsec clocksource")

> So depending on the frequency, it is probably possible to e.g observe
> '100% host' with tick based accounting, the guest just has to
> synchronize exiting to KVM in a way that the tick will always arrive
> past guest_exit_irqoff().
>
> It seems to me this is a fundamental problem in case the frequency of
> guest exits can match the frequency of the time accounting tick.
>
> --
> Vitaly
>
