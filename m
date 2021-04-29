Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC7E836F144
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 22:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233477AbhD2Ute (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 16:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbhD2Ute (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Apr 2021 16:49:34 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F2B3C06138B
        for <kvm@vger.kernel.org>; Thu, 29 Apr 2021 13:48:47 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id j6so7589741pfh.5
        for <kvm@vger.kernel.org>; Thu, 29 Apr 2021 13:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vfHYRnlb0vVZXq2Q43nIevJ7E7GHoNnTAH4NF+Y+ato=;
        b=bX9FlXZlTMXKWDjEW6C0Fo7hElOWeG/bNgdT2zGzTrxSmlR/fT0SIWaNA8fO3F6FzT
         PiTywxQs7BJz2sypT9T/UgHUZUXd+NZ2y/x5nklOe7OC/Qk/1HmRyZWeb5X+JPnGfgQY
         4C4My8Jy2Q0pIjifBEK0TgbnQMrZNplVVNyjngx1HTTxG3l91DZRum1giu20xqM6uU7R
         vDOR6XRg1hAevH0sjKxU6vCWwXNMVmFgwOZ8BCNHag7qao99j+qWTx6YzlTai6EG/KDj
         IKiu3zrUsLQkq96XZXp8xI4129oeZSDkU+mvwd7mmY5WW5wEBRH74xX4rPxjk06WykSk
         zg1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vfHYRnlb0vVZXq2Q43nIevJ7E7GHoNnTAH4NF+Y+ato=;
        b=dJGjYw+YebpOJu4ZdrUrl73y8YaCAlSl0jCLGU8ryAFAfucqmV9Ae2kpJr6pjLdSeN
         1MaLIqhYU3K8mHlYo0XpPgZjyCXf8tT842sW29wajzgAzISptYZF6yBMuxTFgEI3B8gP
         IcddnwQPadkr34j7IUvba8XKed4DaEjDZahcJ5XoFR9HEl8CsxDEv+OLbcNpQIvkEhfH
         cvNExad5yz19lJ6i9Ueo0SCg7+XJFwz3LwEAVP6pGnJFwPM8WpqVCJo3XWORv/StjpI1
         +vPVKEa+i8maLTo9e8hO42xhN0S2XSEvWziBvNl9zM/IvMTlnv67SvSwkFR1knpeU+Ka
         35TA==
X-Gm-Message-State: AOAM530eA0dqp1hKb/BbK5A8Te3W4UFdVQHNz1WN5ZDSB8sUOvuLrf36
        AJvpjfHcGEkNnvFqdNN0rc9qEw==
X-Google-Smtp-Source: ABdhPJzuQA1inRk4ReHCvh+AGTrZE0BErUvVuR+abPHgf+1IpAurGZHHxvanQ1tmL/Y8HSon3LHLiw==
X-Received: by 2002:a63:df09:: with SMTP id u9mr1459024pgg.112.1619729326829;
        Thu, 29 Apr 2021 13:48:46 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id p12sm8544742pjo.4.2021.04.29.13.48.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 13:48:46 -0700 (PDT)
Date:   Thu, 29 Apr 2021 13:48:42 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, drjones@redhat.com, alexandru.elisei@arm.com,
        eric.auger@redhat.com
Subject: Re: [PATCH 1/3] KVM: selftests: Add exception handling support for
 aarch64
Message-ID: <YIsbqhQ/OOzluxtq@google.com>
References: <20210423040351.1132218-1-ricarkol@google.com>
 <20210423040351.1132218-2-ricarkol@google.com>
 <87sg3hnzrj.wl-maz@kernel.org>
 <YIryP84dAc0XHJk2@google.com>
 <87fsz8vp4d.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fsz8vp4d.wl-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 29, 2021 at 08:59:14PM +0100, Marc Zyngier wrote:
> AOn Thu, 29 Apr 2021 18:51:59 +0100,
> Ricardo Koller <ricarkol@google.com> wrote:
> > 
> > On Fri, Apr 23, 2021 at 09:58:24AM +0100, Marc Zyngier wrote:
> > > Hi Ricardo,
> > > 
> > > Thanks for starting this.
> > > 
> > > On Fri, 23 Apr 2021 05:03:49 +0100,
> > > Ricardo Koller <ricarkol@google.com> wrote:
> > > > +.pushsection ".entry.text", "ax"
> > > > +.balign 0x800
> > > > +.global vectors
> > > > +vectors:
> > > > +.popsection
> > > > +
> > > > +/*
> > > > + * Build an exception handler for vector and append a jump to it into
> > > > + * vectors (while making sure that it's 0x80 aligned).
> > > > + */
> > > > +.macro HANDLER, el, label, vector
> > > > +handler\()\vector:
> > > > +	save_registers \el
> > > > +	mov	x0, sp
> > > > +	mov	x1, \vector
> > > > +	bl	route_exception
> > > > +	restore_registers \el
> > > > +
> > > > +.pushsection ".entry.text", "ax"
> > > > +.balign 0x80
> > > > +	b	handler\()\vector
> > > > +.popsection
> > > > +.endm
> > > 
> > > That's an interesting construct, wildly different from what we are
> > > using elsewhere in the kernel, but hey, I like change ;-). It'd be
> > > good to add a comment to spell out that anything that emits into
> > > .entry.text between the declaration of 'vectors' and the end of this
> > > file will break everything.
> > > 
> > > > +
> > > > +.global ex_handler_code
> > > > +ex_handler_code:
> > > > +	HANDLER	1, sync, 0			// Synchronous EL1t
> > > > +	HANDLER	1, irq, 1			// IRQ EL1t
> > > > +	HANDLER	1, fiq, 2			// FIQ EL1t
> > > > +	HANDLER	1, error, 3			// Error EL1t
> > > 
> > > Can any of these actually happen? As far as I can see, the whole
> > > selftest environment seems to be designed around EL1h.
> > >
> > 
> > They can happen. KVM defaults to use EL1h:
> 
> That's not a KVM decision. That's an architectural requirement. Reset
> is an exception, exception use the handler mode.
> 

That makes sense, thanks for the clarification.

> > 
> > 	#define VCPU_RESET_PSTATE_EL1   (PSR_MODE_EL1h | PSR_A_BIT | PSR_I_BIT | \
> > 
> > but then a guest can set the SPSel to 0:
> > 
> > 	asm volatile("msr spsel, #0");
> > 
> > and this happens:
> > 
> > 	  Unexpected exception guest (vector:0x0, ec:0x25)
> > 
> > I think it should still be a valid situation: some test might want to
> > try it.
> 
> Sure, but that's not what this test (in patch #2) is doing, is it?
> If, as I believe, this is an unexpected situation, why not handle it
> separately? I'm not advocating one way or another, but it'd be good to
> understand the actual scope of the exception handling in this
> infrastructure.
> 
> If you plan to allow tests to run in the EL1t environment, where do
> you decide to switch back to EL1t after taking the exception in EL1h?
> Are the tests supposed to implement both stack layouts?
> 
> Overall, I'm worried that nobody is going to use this layout *unless*
> it becomes mandated.
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.

Got it, I see your point. Yes, I'm definitely not planning to use it.
Will just treat those vectors as "invalid".

Thanks again,
Ricardo
