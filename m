Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 812F53D8BF9
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 12:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235785AbhG1KiP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 06:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232113AbhG1KiJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 06:38:09 -0400
Received: from mail-ua1-x934.google.com (mail-ua1-x934.google.com [IPv6:2607:f8b0:4864:20::934])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7693FC061760
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 03:38:07 -0700 (PDT)
Received: by mail-ua1-x934.google.com with SMTP id n15so933416uaj.1
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 03:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ppF9hsuApA1gAdtp04EoScTyC9qpS+x6as3y4xQpHnc=;
        b=vFfg09wRfvg1ngcWXs+miTYupLNW1VwZMJvYDgLL7QbAI0OfUBuyy5+DLuRcmFapfq
         1J6VCh2JwpP+b7DJiQawtdZXxGOF8Uqqtgd6+jPlDs80GK3V0ByC87/go3MjplD4KiAr
         +OX1JFBLpDDYKPeE0z03CX8Dy13smOFiINSkbo0i6f1rFqdab7MOzw/uFyEl6EAqPYKc
         gIh1LSblkZ3X8ooX9iPL8XrOKDqCR3ABZDgH6rcOeuH/QqaL4Wh5EQk9svqVDEVlVTFW
         HNWdB5Qt1STo03x+O1VSAWoChDZ+QfyCUaztu0/Ktu9PSV4ApD/SQ+KXmSN7z8lNcLlv
         qCgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ppF9hsuApA1gAdtp04EoScTyC9qpS+x6as3y4xQpHnc=;
        b=Xsh/wf5mBQ7A9eqLtaFmS7x6QOYVkmrUxmtjtVgE64Vp8pdvgaI4GkWSzJ/3qwd0Oh
         ub6ZwlzBKgif2gdOo4wBAP6+uy73cRh41oHBwTX3o22iDFsPB/eafHZQ+vjMIXGiRJu8
         u8D/HJyp6oTzIgiu8KECeTp/6zxP5IqA7ewKcrFmzVTgsE1Q2XB3U54YCfWIDbswdP2q
         4h9XMmT0e5/fhkjXqVdSosq1jNNT/5WSjgUtmB/zh80l5uL0+vUsO6o45LWiAIn11aEf
         jcNEylPxDeYEbkUmnfQ9dC6TyfVf06SPJSJUFq/9PUUZH6uYS8WSFUkgdqAKb/X5YRvv
         +M/A==
X-Gm-Message-State: AOAM5331q1lOR0K9mof01hcKjEeCExK39dDNz35V9VoN5122XD4TKIPA
        bHrRn8Ay+Uk/UMDhqESYGUwCJNnwCVVEzf7r1fozKg==
X-Google-Smtp-Source: ABdhPJzxcI8UBH87MdK5EwRFxa2AeKU4k/QodZislgrtkcbfcyk7nkqYkeT7cnej+TISOCeVJnCPuzaWWtkohho790k=
X-Received: by 2002:ab0:76d0:: with SMTP id w16mr22128615uaq.15.1627468686420;
 Wed, 28 Jul 2021 03:38:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210728073700.120449-1-suleiman@google.com> <YQEQ9zdlBrgpOukj@hirez.programming.kicks-ass.net>
 <20210728103253.GB7633@fuller.cnet>
In-Reply-To: <20210728103253.GB7633@fuller.cnet>
From:   Suleiman Souhlal <suleiman@google.com>
Date:   Wed, 28 Jul 2021 19:37:55 +0900
Message-ID: <CABCjUKDscba-HjgHuodkWmBYKM+jmv1EkDrxXAZteP3kf1Qv-Q@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] KVM: Support Heterogeneous RT VCPU Configurations.
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
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
        kvm@vger.kernel.org, Nitesh Narayan Lal <nitesh@redhat.com>,
        Nicolas Saenz Julienne <nsaenzju@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 28, 2021 at 7:34 PM Marcelo Tosatti <mtosatti@redhat.com> wrote:
>
> On Wed, Jul 28, 2021 at 10:10:31AM +0200, Peter Zijlstra wrote:
> > On Wed, Jul 28, 2021 at 04:36:58PM +0900, Suleiman Souhlal wrote:
> > > Hello,
> > >
> > > This series attempts to solve some issues that arise from
> > > having some VCPUs be real-time while others aren't.
> > >
> > > We are trying to play media inside a VM on a desktop environment
> > > (Chromebooks), which requires us to have some tasks in the guest
> > > be serviced at real-time priority on the host so that the media
> > > can be played smoothly.
> > >
> > > To achieve this, we give a VCPU real-time priority on the host
> > > and use isolcpus= to ensure that only designated tasks are allowed
> > > to run on the RT VCPU.
> >
> > WTH do you need isolcpus for that? What's wrong with cpusets?
> >
> > > In order to avoid priority inversions (for example when the RT
> > > VCPU preempts a non-RT that's holding a lock that it wants to
> > > acquire), we dedicate a host core to the RT vcpu: Only the RT
> > > VCPU is allowed to run on that CPU, while all the other non-RT
> > > cores run on all the other host CPUs.
> > >
> > > This approach works on machines that have a large enough number
> > > of CPUs where it's possible to dedicate a whole CPU for this,
> > > but we also have machines that only have 2 CPUs and doing this
> > > on those is too costly.
> > >
> > > This patch series makes it possible to have a RT VCPU without
> > > having to dedicate a whole host core for it.
> > > It does this by making it so that non-RT VCPUs can't be
> > > preempted if they are in a critical section, which we
> > > approximate as having interrupts disabled or non-zero
> > > preempt_count. Once the VCPU is found to not be in a critical
> > > section anymore, it will give up the CPU.
> > > There measures to ensure that preemption isn't delayed too
> > > many times.
> > >
> > > (I realize that the hooks in the scheduler aren't very
> > > tasteful, but I couldn't figure out a better way.
> > > SVM support will be added when sending the patch for
> > > inclusion.)
> > >
> > > Feedback or alternatives are appreciated.
> >
> > This is disguisting and completely wrecks the host scheduling. You're
> > placing guest over host, that's fundamentally wrong.
> >
> > NAK!
> >
> > If you want co-ordinated RT scheduling, look at paravirtualized deadline
> > scheduling.
>
> Peter, not sure what exactly are you thinking of? (to solve this
> particular problem with pv deadline scheduling).
>
> Shouldnt it be possible to, through paravirt locks, boost the priority
> of the non-RT vCPU (when locking fails in the -RT vCPU) ?

Unfortunately paravirt locks doesn't work in this configuration
because sched_yield() doesn't work across scheduling classes (non-RT
vs RT). :-(

-- Suleiman
