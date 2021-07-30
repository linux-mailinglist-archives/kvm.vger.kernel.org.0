Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF873DB5A8
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 11:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238128AbhG3JJb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 05:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237895AbhG3JJa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 05:09:30 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1903C0613C1
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 02:09:25 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id v16so5059009vss.7
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 02:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C1//LZ4o9bUA4dg1AgHjS+mwziRpkBn+ySaK4ZjppZk=;
        b=v7hqIbZovsisJFkgQACA9jFXmxfez6Xk+l0364CqR0UjELBQwlRHq2IEaDqoYxtfL3
         LMAZ2C3S+SM5SxEB0kpUbHukDcy3VHbrUnh7IddL0awWnEnacbIRt5Yf07BH/dug8l7x
         w4bRtipS5U0WBXkrub2kolienm5dFJIuzXMK8pyvRlkrcJOi69DdpDNhB0UKVEXc7e11
         fJXKDkZCYCL2QEm++mb1mZOjYYAcbAyfBK6bu6uiyUJrMuCCMlC789uF468XzfOV1xyU
         UXnU6kB1JIoE1r6LcsSxgo5u614RM+0Pg6NYcWLKyuxAJbP0HRIZafg2Sh5E9hHcNyrJ
         ivRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C1//LZ4o9bUA4dg1AgHjS+mwziRpkBn+ySaK4ZjppZk=;
        b=enc+U19SFUVIgLH5nQMQ3Nc9acKuwlAR/LbKSZ9bqSq6DjUWoKXLw3RWiUwXCrrQpH
         vIeVnFwe/nRzpARTz7MqvGf85R/Ovx40yu+JIgtnjfxds4UvnBzILQJ5vobDAV+idiIF
         0gxiZF3FvocomqTCmRrNr7lDeR96WArU8DfxuhiHzwEfi38HNiVcYvheU2JbpZayhLH7
         wOb+6s/RfQEIAK5HrKZyrAAodsoGng7e6zmjnah2jXo6rTWpkX2keVOIHuNku82eoy0w
         3jsZ7nRQAZHKb7iKOm14pn21jIetBE34dikJiLZi6S3IjOVuzMeMCfV/QSR92+tXGnEI
         JHQQ==
X-Gm-Message-State: AOAM5316wtFPqb+iag+awG4KZjjwJiWBru2wyJnqxM/cIKFLn5kPEw3e
        YSxCHObL9gxZIPNI472h6zjsL6lvRI4Vh17wmmVgrw==
X-Google-Smtp-Source: ABdhPJyltU9gwBHPo5rmJd2V6wVW/Srwe4VDfgYC5mNRc9eowFaKCrKzuhrzsuSArCYg75ore/6DdyeLezLQ4d4lIyg=
X-Received: by 2002:a67:fe57:: with SMTP id m23mr676372vsr.42.1627636163744;
 Fri, 30 Jul 2021 02:09:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210728073700.120449-1-suleiman@google.com> <YQEQ9zdlBrgpOukj@hirez.programming.kicks-ass.net>
In-Reply-To: <YQEQ9zdlBrgpOukj@hirez.programming.kicks-ass.net>
From:   Suleiman Souhlal <suleiman@google.com>
Date:   Fri, 30 Jul 2021 18:09:12 +0900
Message-ID: <CABCjUKBXCFO4-cXAUdbYEKMz4VyvZ5hD-1yP9H7S7eL8XsqO-g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] KVM: Support Heterogeneous RT VCPU Configurations.
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Suleiman Souhlal <ssouhlal@freebsd.org>,
        Joel Fernandes <joelaf@google.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

On Wed, Jul 28, 2021 at 5:11 PM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Wed, Jul 28, 2021 at 04:36:58PM +0900, Suleiman Souhlal wrote:
> > Hello,
> >
> > This series attempts to solve some issues that arise from
> > having some VCPUs be real-time while others aren't.
> >
> > We are trying to play media inside a VM on a desktop environment
> > (Chromebooks), which requires us to have some tasks in the guest
> > be serviced at real-time priority on the host so that the media
> > can be played smoothly.
> >
> > To achieve this, we give a VCPU real-time priority on the host
> > and use isolcpus= to ensure that only designated tasks are allowed
> > to run on the RT VCPU.
>
> WTH do you need isolcpus for that? What's wrong with cpusets?

I regret mentioning isolcpus here.
The patchset doesn't dictate how the guest is supposed to use RT.
cpusets also work.

> > In order to avoid priority inversions (for example when the RT
> > VCPU preempts a non-RT that's holding a lock that it wants to
> > acquire), we dedicate a host core to the RT vcpu: Only the RT
> > VCPU is allowed to run on that CPU, while all the other non-RT
> > cores run on all the other host CPUs.
> >
> > This approach works on machines that have a large enough number
> > of CPUs where it's possible to dedicate a whole CPU for this,
> > but we also have machines that only have 2 CPUs and doing this
> > on those is too costly.
> >
> > This patch series makes it possible to have a RT VCPU without
> > having to dedicate a whole host core for it.
> > It does this by making it so that non-RT VCPUs can't be
> > preempted if they are in a critical section, which we
> > approximate as having interrupts disabled or non-zero
> > preempt_count. Once the VCPU is found to not be in a critical
> > section anymore, it will give up the CPU.
> > There measures to ensure that preemption isn't delayed too
> > many times.
> >
> > (I realize that the hooks in the scheduler aren't very
> > tasteful, but I couldn't figure out a better way.
> > SVM support will be added when sending the patch for
> > inclusion.)
> >
> > Feedback or alternatives are appreciated.
>
> This is disguisting and completely wrecks the host scheduling. You're
> placing guest over host, that's fundamentally wrong.

I understand the sentiment.

For what it's worth, the patchset doesn't completely rely on a
well-behaved guest: It only delays preemption a bounded number of
times, after which it yields back no matter what.

> NAK!
>
> If you want co-ordinated RT scheduling, look at paravirtualized deadline
> scheduling.

Thanks for the suggestion, I will look into it.

-- Suleiman
