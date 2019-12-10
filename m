Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2B37117C99
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 01:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbfLJAoh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Dec 2019 19:44:37 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:34871 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727213AbfLJAoh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Dec 2019 19:44:37 -0500
Received: by mail-oi1-f195.google.com with SMTP id k196so8249904oib.2;
        Mon, 09 Dec 2019 16:44:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VUGiVOpo+ESHTZ/q7ZXEUplweHGdxyWpw0bewKvKrKo=;
        b=HJ9uvRByiIhcvlGFLAHIo3zMt4Bje8/0vzIZNo1QGmiVYLM6CmrM02L5Aa5UGwxX/y
         KHhHo/C6Td7K4qbcProiLzKd6BKblDRDsqoaeYh/qIOWRPQGo3OxmXiYU/uzdFCeRaKp
         UeAjDdXnhEPe+FwHRCTsw4148aTuISMtFE1qzMOtpvrxfQeC3eSpAodTKOXa8D/HIn/U
         eFxPghOlpHFFabkmcygBN926ZrR4AE6vUJ9U6mG94WJhziyQ2tVEW6L9w4WzEg8ntK8A
         aypYKtpXvik972wulYD4sleX8awhjUBrG/xoQ+1OHAnP1KaI50QqtuDmCJfLWOX5qriu
         l7hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VUGiVOpo+ESHTZ/q7ZXEUplweHGdxyWpw0bewKvKrKo=;
        b=j3fFaBllJaaknEK1q8f441Ilrr9zmwzpdAWJt1eW3h8SQRSR4HZzlgYDk197wI5jAK
         xnKCIIJnk2v0dBsWtWyEZ1MPua7PmCSsUwG7DuJHb32GxsDu9HW7NdhZ/KXqO7VeubAe
         vMFVX07R74iVaQqDRrHD/sww4cWlHdPwMXFLkdc5Z0K9FId46Ub0N46nZk70I71Rv2Z7
         YcVzbrSwrWgSgrsSFmIJ+6JBlYi9Q9V8hmmc0U3PdB+Qx1v0FifaiABdIAB/9lF8EnCh
         tZ9Euurtd0DUO6D/p36gfuXOathlo40Wa8KK8Jbwp/GIoJAmu3r5d4NLOLR1I6GmFpok
         fD8Q==
X-Gm-Message-State: APjAAAU6zMo5RJxokSnY7xW4kTldem62fNv6AAViKPJ+7EUe77eMsx03
        Mz5Kv8MLArD6iwP5ITJpJt4tApMZiKLlYMhczGo=
X-Google-Smtp-Source: APXvYqz9kY5TLOFKFpF1u4hNcfjzipnq6KIGaqx/5OX1I/CehdbbdgEHMfJc0amvv3RA+MkRDHMbyuTBgTw84WZ+F38=
X-Received: by 2002:aca:758c:: with SMTP id q134mr1786606oic.33.1575938676514;
 Mon, 09 Dec 2019 16:44:36 -0800 (PST)
MIME-Version: 1.0
References: <CANRm+Cyge6viybs63pt7W-cRdntx+wfyOq5EWE2qmEQ71SzMHg@mail.gmail.com>
 <alpine.DEB.2.21.1906261211410.32342@nanos.tec.linutronix.de>
 <20190626145413.GE6753@char.us.oracle.com> <20190626161608.GM3419@hirez.programming.kicks-ass.net>
 <20190626183016.GA16439@char.us.oracle.com> <alpine.DEB.2.21.1906262038040.32342@nanos.tec.linutronix.de>
 <1561575336.25880.7.camel@amazon.de> <20190626192100.GP3419@hirez.programming.kicks-ass.net>
 <1561577254.25880.15.camel@amazon.de>
In-Reply-To: <1561577254.25880.15.camel@amazon.de>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 10 Dec 2019 08:44:25 +0800
Message-ID: <CANRm+Cx2gEf5G3W5yPrgmz0qVkgB+eWM+RCAji=PYvKvAOrHkw@mail.gmail.com>
Subject: Re: cputime takes cstate into consideration
To:     "Raslan, KarimAllah" <karahmed@amazon.de>
Cc:     "peterz@infradead.org" <peterz@infradead.org>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>,
        Frederic Weisbecker <frederic@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 27 Jun 2019 at 03:27, Raslan, KarimAllah <karahmed@amazon.de> wrote:
>
> On Wed, 2019-06-26 at 21:21 +0200, Peter Zijlstra wrote:
> > On Wed, Jun 26, 2019 at 06:55:36PM +0000, Raslan, KarimAllah wrote:
> >
> > >
> > > If the host is completely in no_full_hz mode and the pCPU is dedicated to a
> > > single vCPU/task (and the guest is 100% CPU bound and never exits), you would
> > > still be ticking in the host once every second for housekeeping, right? Would
> > > not updating the mwait-time once a second be enough here?
> >
> > People are trying very hard to get rid of that remnant tick. Lets not
> > add dependencies to it.
> >
> > IMO this is a really stupid issue, 100% time is correct if the guest
> > does idle in pinned vcpu mode.
>
> One use case for proper accounting (obviously for a slightly relaxed definition
> or *proper*) is *external* monitoring of CPU utilization for scaling group
> (i.e. more VMs will be launched when you reach a certain CPU utilization).
> These external monitoring tools needs to account CPU utilization properly.

Except cputime accounting, the other gordian knot is qemu main loop,
libvirt, kthreads etc can't be offload to the other hardware like
smart nic, these stuff will contend with vCPUs even if MWAIT/HLT
instructions are executing in the guest. There is a HLT activity state
in CPU VMCS which indicates the logical processor is inactive because
it executed the HLT instruction, but SDM 24.4.2 mentioned that
execution of the MWAIT instruction may put a logical processor into an
inactive state, however, this VMCS field never reflects this state.

    Wanpeng
