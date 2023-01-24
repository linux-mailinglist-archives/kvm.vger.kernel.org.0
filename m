Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFCA67A4D3
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 22:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234976AbjAXVS6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 16:18:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234913AbjAXVSy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 16:18:54 -0500
Received: from out-198.mta0.migadu.com (out-198.mta0.migadu.com [IPv6:2001:41d0:1004:224b::c6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B26521F7
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 13:18:17 -0800 (PST)
Date:   Tue, 24 Jan 2023 21:18:10 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1674595095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CnSq4mBbw8yIBMhIRKayETuEHeib8k7L9ZTqOeYi3PI=;
        b=MgrUEDLCALpdGP50oLgldB4thgGtzyIH2dBkSuxkTLVU9dFZOdt4boNR1m6wbC7ZVk08LO
        huugRiBeVoC41yib++Q7KKxT/txti822KALNGV+56GxuLP5E37h9HOEsfpzxoQicWYkoUY
        Qz0ak+yrCJ0K2x15ayvuCIBYWMIgJpE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Will Deacon <will@kernel.org>
Cc:     maz@kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
        catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] MAINTAINERS: Add Oliver Upton as co-maintainer of
 KVM/arm64
Message-ID: <Y9BLEj+/doAKmXzP@google.com>
References: <20230123210256.2728218-1-oliver.upton@linux.dev>
 <20230124093728.GA26080@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230124093728.GA26080@willie-the-truck>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 24, 2023 at 09:37:29AM +0000, Will Deacon wrote:
> On Mon, Jan 23, 2023 at 09:02:56PM +0000, Oliver Upton wrote:
> > Going forward I intend to help Marc with maintaining KVM/arm64. We've
> > spoken about this quite a bit and he has been a tremendous help in
> > ramping up to the task (thank you!). We haven't worked out the exact
> > details of how the process will work, but the goal is to even out the
> > maintenance responsibilities to give us both ample time for development.
> > 
> > To that end, updating the maintainers entry to reflect the change.
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  MAINTAINERS | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 42fc47c6edfd..7323efcc1270 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -11355,9 +11355,9 @@ F:	virt/kvm/*
> >  
> >  KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)
> >  M:	Marc Zyngier <maz@kernel.org>
> > +M:	Oliver Upton <oliver.upton@linux.dev>
> 
> Ya know, alphabetical order tends to put Mr Z at the bottom of the list,
> but I can understand why you don't necessarily want to be first in the
> pack just yet!

I think you may've spotted my intentions here :-) Short of any
objections, I'll shamelessly leave Marc in the direct line of fire until
someone alphabetizes it.

> In any case, this is really great to see:
> 
> Acked-by: Will Deacon <will@kernel.org>

Thanks!

-- 
Thanks,
Oliver
