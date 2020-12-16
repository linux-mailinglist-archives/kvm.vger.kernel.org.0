Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504182DC176
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 14:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbgLPNnl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 08:43:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbgLPNnk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Dec 2020 08:43:40 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E30C061794;
        Wed, 16 Dec 2020 05:43:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+4vd395O47PjmfEXnoEeM5KbxqcEezbK6dCpcez8b8Y=; b=kvqVcM0zuM16sdJUCBTqJSGO6R
        Y+aqPtDVkY7tqxQTdHL4dbepBoBgbaXVjFDWtZJtyhCYTjxoLpkVvvdP4l06WR7gVCdMFNrehWK4u
        YSz5iLyTTHZRpUkyXHGUPFwy+6KRySnwgofJeOF7Q++fRcd57ZtMH2dyPRRH0i/NawqHER3tlm2sa
        dCI+AfwDY4TwSeEIOukNQr0yFixQEHIloKJ5BYY7Nq9TXt8bE3QFDWIBbypkh8B5RrlomLgDa2ZqZ
        brCUCjhWTIjebHxhK2bjmxxd+vSy/PGP51MyhvhrY7j/S4pNbBxz1Oz6s2tDcgqMCzqxab/ZGCrXc
        2yacQkLA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kpX4t-0003ew-B9; Wed, 16 Dec 2020 13:42:51 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 21993304D58;
        Wed, 16 Dec 2020 14:42:50 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 064CE202C01EB; Wed, 16 Dec 2020 14:42:49 +0100 (CET)
Date:   Wed, 16 Dec 2020 14:42:49 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     Ingo Molnar <mingo@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        jeyu@kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        ardb@kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Jason Baron <jbaron@akamai.com>
Subject: Re: [RFC][PATCH] jump_label/static_call: Add MAINTAINERS
Message-ID: <20201216134249.GU3092@hirez.programming.kicks-ass.net>
References: <MW4PR21MB1857CC85A6844C89183C93E9BFC59@MW4PR21MB1857.namprd21.prod.outlook.com>
 <20201216092649.GM3040@hirez.programming.kicks-ass.net>
 <20201216105926.GS3092@hirez.programming.kicks-ass.net>
 <20201216133014.GT3092@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201216133014.GT3092@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 16, 2020 at 02:30:14PM +0100, Peter Zijlstra wrote:
> 
> FWIW, I recently noticed we're not being Cc'ed on patches for this
> stuff, so how about we do something like the below?
> 
> Anybody holler if they don't agree with the letter assigned, or if they
> feel they've been left out entirely and want in on the 'fun' :-)
> 
> ---
> Subject: jump_label/static_call: Add MAINTAINERS
> From: Peter Zijlstra <peterz@infradead.org>
> 
> These files don't appear to have a MAINTAINERS entry and as such
> patches miss being seen by people who know this code.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  MAINTAINERS |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16766,6 +16766,18 @@ M:	Ion Badulescu <ionut@badula.org>
>  S:	Odd Fixes
>  F:	drivers/net/ethernet/adaptec/starfire*
>  
> +STATIC BRANCH/CALL
> +M:	Peter Zijlstra <peterz@infradead.org>
> +M:	Josh Poimboeuf <jpoimboe@redhat.com>
> +M:	Jason Baron <jbaron@akamai.com>
> +R:	Steven Rostedt <rostedt@goodmis.org>
> +R:	Ard Biesheuvel <ardb@kernel.org>
> +S:	Supported

F:	arch/*/include/asm/jump_label*.h
F:	arch/*/include/asm/static_call*.h
F:	arch/*/kernel/jump_label.c
F:	arch/*/kernel/static_call.c

These too?

> +F:	include/linux/jump_label*.h
> +F:	include/linux/static_call*.h
> +F:	kernel/jump_label.c
> +F:	kernel/static_call.c
> +
>  STEC S1220 SKD DRIVER
>  M:	Damien Le Moal <Damien.LeMoal@wdc.com>
>  L:	linux-block@vger.kernel.org
