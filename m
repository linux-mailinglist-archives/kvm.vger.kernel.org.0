Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA5D663034
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 20:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235146AbjAITWd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 14:22:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234934AbjAITWb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 14:22:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 221436C2BE;
        Mon,  9 Jan 2023 11:22:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D44C61115;
        Mon,  9 Jan 2023 19:22:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC67C433EF;
        Mon,  9 Jan 2023 19:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673292148;
        bh=htbtetKp6LvDEmtxfygdNB2SYbLgZM+2mVnnjewbqS4=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=Au6Y+DeU+7zTdmR/w13Bb2913aWfnKsrBWT0WL1Y3humfk2O8vXhFYp79RSotXbeO
         UyA5cheMgKBO9b7e8zwAffWSNfK4JxvxGqoR76OjH9KY66SzDyhFppU39clTt4MaiC
         qdRyxEhFg6DtGiHRp3jWinivHMTG8QYQe2NnenFmxXniV81gj2w3TxzfrP2eL4J+bl
         p3/55maqNVSYx+05YCUYY0qUAwPMGCF6z7XJ2CVIZz9fhAnO1Je5mjinxq9OTCNEX6
         Jf8n4BNeHBZXif/YbFp+0DEKuVrGf++Gw8sfTHQw8y3fqwZT7iq1kEzZrHqnQ6V+VY
         tGsnWVp5c+L2Q==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 78CF65C05C8; Mon,  9 Jan 2023 11:22:28 -0800 (PST)
Date:   Mon, 9 Jan 2023 11:22:28 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     rcu@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@meta.com, rostedt@goodmis.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH rcu 01/27] arch/x86: Remove "select SRCU"
Message-ID: <20230109192228.GV4028633@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20230105003759.GA1769545@paulmck-ThinkPad-P17-Gen-1>
 <20230105003813.1770367-1-paulmck@kernel.org>
 <Y7xSO2dW1sy21RVz@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7xSO2dW1sy21RVz@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 09, 2023 at 05:43:23PM +0000, Sean Christopherson wrote:
> On Wed, Jan 04, 2023, Paul E. McKenney wrote:
> > Now that the SRCU Kconfig option is unconditionally selected, there is
> > no longer any point in selecting it.  Therefore, remove the "select SRCU"
> > Kconfig statements.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: Borislav Petkov <bp@alien8.de>
> > Cc: Dave Hansen <dave.hansen@linux.intel.com>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: Sean Christopherson <seanjc@google.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: <x86@kernel.org>
> > Cc: <kvm@vger.kernel.org>
> > ---
> 
> ...
> 
> > diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> > index fbeaa9ddef598..9306d99585188 100644
> > --- a/arch/x86/kvm/Kconfig
> > +++ b/arch/x86/kvm/Kconfig
> > @@ -46,7 +46,6 @@ config KVM
> >  	select KVM_XFER_TO_GUEST_WORK
> >  	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
> >  	select KVM_VFIO
> > -	select SRCU
> 
> Would it be too much trouble to bundle all of the KVM changes into a single patch?
> The SRCU requirement is a generic KVM requirement that's handled in the arch Kconfigs
> purely because of KVM's somewhat roundabout Kconfig setup.

No problem, and will do on my next rebase.  I might end up with a long
list of Cc's, but so it goes.  I will of course send the result as a
reply to this message.

							Thanx, Paul

> >  	select INTERVAL_TREE
> >  	select HAVE_KVM_PM_NOTIFIER if PM
> >  	help
> > -- 
> > 2.31.1.189.g2e36527f23
> > 
