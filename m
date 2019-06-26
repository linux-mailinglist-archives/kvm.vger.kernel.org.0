Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48EEE570DC
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 20:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbfFZSlS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 14:41:18 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50102 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfFZSlR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 14:41:17 -0400
Received: from p5b06daab.dip0.t-ipconnect.de ([91.6.218.171] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hgCqw-00038t-7w; Wed, 26 Jun 2019 20:41:06 +0200
Date:   Wed, 26 Jun 2019 20:41:04 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
cc:     Peter Zijlstra <peterz@infradead.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KarimAllah <karahmed@amazon.de>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Subject: Re: cputime takes cstate into consideration
In-Reply-To: <20190626183016.GA16439@char.us.oracle.com>
Message-ID: <alpine.DEB.2.21.1906262038040.32342@nanos.tec.linutronix.de>
References: <CANRm+Cyge6viybs63pt7W-cRdntx+wfyOq5EWE2qmEQ71SzMHg@mail.gmail.com> <alpine.DEB.2.21.1906261211410.32342@nanos.tec.linutronix.de> <20190626145413.GE6753@char.us.oracle.com> <20190626161608.GM3419@hirez.programming.kicks-ass.net>
 <20190626183016.GA16439@char.us.oracle.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 26 Jun 2019, Konrad Rzeszutek Wilk wrote:
> On Wed, Jun 26, 2019 at 06:16:08PM +0200, Peter Zijlstra wrote:
> > On Wed, Jun 26, 2019 at 10:54:13AM -0400, Konrad Rzeszutek Wilk wrote:
> > > There were some ideas that Ankur (CC-ed) mentioned to me of using the perf
> > > counters (in the host) to sample the guest and construct a better
> > > accounting idea of what the guest does. That way the dashboard
> > > from the host would not show 100% CPU utilization.
> > 
> > But then you generate extra noise and vmexits on those cpus, just to get
> > this accounting sorted, which sounds like a bad trade.
> 
> Considering that the CPUs aren't doing anything and if you do say the 
> IPIs "only" 100/second - that would be so small but give you a big benefit
> in properly accounting the guests.

The host doesn't know what the guest CPUs are doing. And if you have a full
zero exit setup and the guest is computing stuff or doing that network
offloading thing then they will notice the 100/s vmexits and complain.

> But perhaps there are other ways too to "snoop" if a guest is sitting on
> an MWAIT?

No idea.

Thanks,

	tglx


