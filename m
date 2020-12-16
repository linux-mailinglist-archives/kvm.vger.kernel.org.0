Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 977722DC219
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 15:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbgLPOYX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 09:24:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:55200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725550AbgLPOYX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Dec 2020 09:24:23 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EDE4233CE;
        Wed, 16 Dec 2020 14:23:41 +0000 (UTC)
Date:   Wed, 16 Dec 2020 09:23:39 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Dexuan Cui <decui@microsoft.com>, Ingo Molnar <mingo@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        jeyu@kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        ardb@kernel.org, Jason Baron <jbaron@akamai.com>
Subject: Re: [RFC][PATCH] jump_label/static_call: Add MAINTAINERS
Message-ID: <20201216092339.74835205@gandalf.local.home>
In-Reply-To: <20201216134249.GU3092@hirez.programming.kicks-ass.net>
References: <MW4PR21MB1857CC85A6844C89183C93E9BFC59@MW4PR21MB1857.namprd21.prod.outlook.com>
        <20201216092649.GM3040@hirez.programming.kicks-ass.net>
        <20201216105926.GS3092@hirez.programming.kicks-ass.net>
        <20201216133014.GT3092@hirez.programming.kicks-ass.net>
        <20201216134249.GU3092@hirez.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 16 Dec 2020 14:42:49 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Dec 16, 2020 at 02:30:14PM +0100, Peter Zijlstra wrote:
> > 
> > FWIW, I recently noticed we're not being Cc'ed on patches for this
> > stuff, so how about we do something like the below?
> > 
> > Anybody holler if they don't agree with the letter assigned, or if they
> > feel they've been left out entirely and want in on the 'fun' :-)
> > 
> > ---
> > Subject: jump_label/static_call: Add MAINTAINERS
> > From: Peter Zijlstra <peterz@infradead.org>
> > 
> > These files don't appear to have a MAINTAINERS entry and as such
> > patches miss being seen by people who know this code.
> > 
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > ---
> >  MAINTAINERS |   12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> > 
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -16766,6 +16766,18 @@ M:	Ion Badulescu <ionut@badula.org>
> >  S:	Odd Fixes
> >  F:	drivers/net/ethernet/adaptec/starfire*
> >  
> > +STATIC BRANCH/CALL
> > +M:	Peter Zijlstra <peterz@infradead.org>
> > +M:	Josh Poimboeuf <jpoimboe@redhat.com>
> > +M:	Jason Baron <jbaron@akamai.com>
> > +R:	Steven Rostedt <rostedt@goodmis.org>
> > +R:	Ard Biesheuvel <ardb@kernel.org>
> > +S:	Supported  
> 
> F:	arch/*/include/asm/jump_label*.h
> F:	arch/*/include/asm/static_call*.h
> F:	arch/*/kernel/jump_label.c
> F:	arch/*/kernel/static_call.c
> 
> These too?

Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve

> 
> > +F:	include/linux/jump_label*.h
> > +F:	include/linux/static_call*.h
> > +F:	kernel/jump_label.c
> > +F:	kernel/static_call.c
> > +
> >  STEC S1220 SKD DRIVER
> >  M:	Damien Le Moal <Damien.LeMoal@wdc.com>
> >  L:	linux-block@vger.kernel.org  

