Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7323A53A0FD
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 11:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350502AbiFAJo1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 05:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351356AbiFAJoX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 05:44:23 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CBF85D648;
        Wed,  1 Jun 2022 02:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=7gO+/qCN/8Jde0GHKvaSSw0P67qVOzIwufdwP2CG+4Y=; b=F0y6M5Z/nWUiMTC9auYFpPrynH
        o7xqxil6IK00JwG8Uom0Gekm6YyTkRw9ycY3oLVVdWCaRC1CNvAxzXWVTaStqjegdq+HHjAh1J6pp
        r+A60zcfv8ufsPp89rU1K59NR/+sZTZLZ/R/jbQU3ZR6WkilGjjtpf+d4F2A2WEgtZ78dv3h1XrHb
        4pgEHfozeo4t+CL4k5ylERKljT4mhPFA1c81TptyMwi1S8V+L0OYKYSrH6Oopc+tahfnhguGcVcce
        KT0azo8l8hqFxQLwiay5MO1WTM6z1SN0XQnhBH6bKoEaZzpO+/NM/FUyQ0XPDY8mojwUyCdrLkZjA
        r/zYyRQw==;
Received: from [54.239.6.189] (helo=freeip.amazon.com)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nwKtA-006Abl-M9; Wed, 01 Jun 2022 09:43:40 +0000
Message-ID: <5cd6a6a5c5650fc6a191828e81264c016a4b4a82.camel@infradead.org>
Subject: Re: ...\n
From:   Amit Shah <amit@infradead.org>
To:     Peter Zijlstra <peterz@infradead.org>,
        "Durrant, Paul" <pdurrant@amazon.co.uk>
Cc:     "Allister, Jack" <jalliste@amazon.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "diapop@amazon.co.uk" <diapop@amazon.co.uk>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "metikaya@amazon.co.uk" <metikaya@amazon.co.uk>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "x86@kernel.org" <x86@kernel.org>
Date:   Wed, 01 Jun 2022 11:43:37 +0200
In-Reply-To: <YpcMw2TgNWzrcoRm@worktop.programming.kicks-ass.net>
References: <YpYaYK7a28DFT5Ne@hirez.programming.kicks-ass.net>
         <20220531140236.1435-1-jalliste@amazon.com>
         <YpYpxzt4rmG+LFy9@hirez.programming.kicks-ass.net>
         <059ab3327ac440479ecfdf49fa054347@EX13D32EUC003.ant.amazon.com>
         <YpcMw2TgNWzrcoRm@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-06-01 at 08:52 +0200, Peter Zijlstra wrote:
> On Tue, May 31, 2022 at 02:52:04PM +0000, Durrant, Paul wrote:
> > > 
> > > 
> > > On Tue, May 31, 2022 at 02:02:36PM +0000, Jack Allister wrote:
> > > > The reasoning behind this is that you may want to run a guest at a
> > > > lower CPU frequency for the purposes of trying to match performance
> > > > parity between a host of an older CPU type to a newer faster one.
> > > 
> > > That's quite ludicrus. Also, then it should be the host enforcing the
> > > cpufreq, not the guest.
> > 
> > I'll bite... What's ludicrous about wanting to run a guest at a lower
> > CPU freq to minimize observable change in whatever workload it is
> > running?
> 
> *why* would you want to do that? Everybody wants their stuff done
> faster.

We're running out of older hardware on which VMs have been started, and
these have to be moved to newer hardware.

We want the customer experience to stay as close to the current
situation as possible (i.e. no surprises), as this is just a live-
migration event for these instances.

Live migration events happen today as well, within the same hardware
and hypervisor cluster.  But this hw deprecation thing is going to be
new -- meaning customers and workloads aren't used to having hw
characteristics change as part of LM events.

> If this is some hare-brained money scheme; must not give them if they
> didn't pay up then I really don't care.

Many workloads that are still tied to the older generation instances we
offer are there for a reason.  EC2's newer instance generations have a
better price and performance than the older ones; yet folks use the
older ones.  We don't want to guess as to why that is.  We just want
these workloads to continue running w/o changes or w/o customers having
to even think about these things, while running on supported hardware.

So as infrastructure providers, we're doing everything possible behind-
the-scenes to ensure there's as little disruption to existing workloads
as possible.

> On top of that, you can't hide uarch differences with cpufreq capping.

Yes, this move (old hw -> new hw) isn't supposed to be "hide from the
instances we're doing this".  It's rather "try to match the
capabilities to the older hw as much as possible".

Some software will adapt to these changes; some software won't.  We're
aiming to be ready for both scenarios as far as software allows us.

> Also, it is probably more power efficient to let it run faster and idle
> more, so you're not being environmental either.

Agreed; I can chat about that quite a bit, but that doesn't apply to
this context.

		Amit

