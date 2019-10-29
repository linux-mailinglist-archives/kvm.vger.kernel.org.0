Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A37CE8C11
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2019 16:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390094AbfJ2Pou (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Oct 2019 11:44:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41644 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389319AbfJ2Pou (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Oct 2019 11:44:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=bLHQ9ES4uovIMte4KF6pdSi3ymLKQ1bfJF3BoDC+60k=; b=fTsOHwCQIjRAPhsfX254qq39K
        jmouMXV3yl64qNXPS4xoGatOntk7xk1mGlfaHoKtgMkkSgonqH3SdbbAKvFQjVq7blK1ElK8fHdnz
        on9YVhgZlr25/7ykRYjMly0W6VrxYv9PqnssxjObuB2p78hkkErd38umaCbUUq3vHAnKwXiSKyt1s
        wq4aU5IiD3T8aXqWt1oRiU3kYkfJAzJir3TXLQ6jl1znYLvmQtu727DdGcYA1xM9iNXILS6NIcO7u
        IFeJGggENsVIqOdUT4FXjDC+0lTLlSCJ05r/X6X4NwbpEMfbSENvKFbJLPCjIGpI67U6qGWsWeJ7+
        nYp2MO3ew==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iPTfV-0006VB-Kf; Tue, 29 Oct 2019 15:44:25 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 9B14E30025A;
        Tue, 29 Oct 2019 16:43:22 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 64D2F2B438360; Tue, 29 Oct 2019 16:44:23 +0100 (CET)
Date:   Tue, 29 Oct 2019 16:44:23 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     SAURAV GIREPUNJE <saurav.girepunje@gmail.com>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        saurav.girepunje@hotmail.com
Subject: Re: [PATCH] arch: x86: kvm: mmu.c: use true/false for bool type
Message-ID: <20191029154423.GN4131@hirez.programming.kicks-ass.net>
References: <20191029094104.GA11220@saurav>
 <20191029101300.GK4114@hirez.programming.kicks-ass.net>
 <20191029134246.GA4943@saurav>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191029134246.GA4943@saurav>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 29, 2019 at 07:12:46PM +0530, SAURAV GIREPUNJE wrote:
> On Tue, Oct 29, 2019 at 11:13:00AM +0100, Peter Zijlstra wrote:
> > On Tue, Oct 29, 2019 at 03:11:04PM +0530, Saurav Girepunje wrote:
> > > Use true/false for bool type "dbg" in mmu.c
> > > 
> > > Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>
> > > ---
> > >  arch/x86/kvm/mmu.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> > > index 24c23c66b226..c0b1df69ce0f 100644
> > > --- a/arch/x86/kvm/mmu.c
> > > +++ b/arch/x86/kvm/mmu.c
> > > @@ -68,7 +68,7 @@ enum {
> > >  #undef MMU_DEBUG
> > >  
> > >  #ifdef MMU_DEBUG
> > > -static bool dbg = 0;
> > > +static bool dbg = true;
> > 
> > You're actually changing the value from false to true. Please, if you
> > don't know C, don't touch things.
> Hi,
> 
> Thanks for your review.
> I accept that I have given wrong value "true" to debug variable. It's my bad my typo mistake.  
> I will make sure that I will not touch your exclusive C code where we can assign 0/1 to a bool variable,
> As you have given me a free advice, I also request you to please don't review such small patches from newbie to discourage them.

I will most certainly review whatever I want, and clearly it is needed.
