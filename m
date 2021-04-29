Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFC436EF2D
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 19:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241071AbhD2Rwv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 13:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241003AbhD2Rwu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Apr 2021 13:52:50 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0552BC06138B
        for <kvm@vger.kernel.org>; Thu, 29 Apr 2021 10:52:04 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id h14-20020a17090aea8eb02901553e1cc649so278184pjz.0
        for <kvm@vger.kernel.org>; Thu, 29 Apr 2021 10:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Iqvx6xUJ3HpBD776B4jOHX3DLMKME1UEEEadpoQT2gQ=;
        b=jGzEnHyVLypFuPSu8rwkpX2gw75JhanOw6rujoZojvWajm23gVjBoBRyEMs0GNr7Tf
         EcOQCFEQRHs5l1om6BhrQUyLwY6d/qnjVcbqFQzCVec6NMixGQPl8Q+im8HFnw5KqADL
         JpWeBCVxB5lAcDQqFhjm349oNMLodbTI3QJ4mQZUVyJR/oCpKPzdrJZOalg8HVJ5q2dO
         Q7sUVbWw8XJXF+BygD9tCvtlWqOFa+c8QhNMwhXQq1VYCsdktnz9IZwujP0y2UHT9gqv
         /SlKRcfLpR5Z1xWPo4ys9565wgBOfp16ixNMnx517kk3b1R6bU8QT7cdkCCJv9OfyEOv
         puHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Iqvx6xUJ3HpBD776B4jOHX3DLMKME1UEEEadpoQT2gQ=;
        b=WwUbmsXeyupPj5NHN1gGQpCvH5kDApgHtbFy/p5gK7y2sQDiyYki+7qFSgJXqPcRKT
         oTMK6GsFx6CxETf8crB9kmEf3Ubn2MWtUm3zp74Tw0vdXSpeBY5XiE7Sa8/rlyIvtx1H
         yTJOVHcNjsEllwBNPWu/JYIyWg4cm6dYfEiQ9HnWV7+d0+qdlEuapw8knJziUXdkHdi8
         UwVbEVzc+irR4PnIZySDdD1CtILcAiORASkDPkHh1wbDliWE7GIn5oM1dHCciIUmVfSk
         xUDnv0G9+PoL+PAeY1pR5aRxxMmtIL4vUS4D73ufRbyhGOqyxEXEKLdKheos0XKxyoA8
         qayA==
X-Gm-Message-State: AOAM53141UjmBjKLeQ3u69crEyeLx/ogBaw053dqaPA3fjjVYrsSEd3U
        1ARAS7tEf56ekvYmamIG9mNVdb0pLaYdvxI7
X-Google-Smtp-Source: ABdhPJzso9M0RRFDzJYpF5zFVqb7Ha24skEaZX2/YLwsOZbDSGiaKX23vzenBQY+6pH5STksUnpOgw==
X-Received: by 2002:a17:90a:602:: with SMTP id j2mr1024998pjj.211.1619718723372;
        Thu, 29 Apr 2021 10:52:03 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id x13sm526220pgf.13.2021.04.29.10.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 10:52:02 -0700 (PDT)
Date:   Thu, 29 Apr 2021 10:51:59 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, drjones@redhat.com, alexandru.elisei@arm.com,
        eric.auger@redhat.com
Subject: Re: [PATCH 1/3] KVM: selftests: Add exception handling support for
 aarch64
Message-ID: <YIryP84dAc0XHJk2@google.com>
References: <20210423040351.1132218-1-ricarkol@google.com>
 <20210423040351.1132218-2-ricarkol@google.com>
 <87sg3hnzrj.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sg3hnzrj.wl-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 23, 2021 at 09:58:24AM +0100, Marc Zyngier wrote:
> Hi Ricardo,
> 
> Thanks for starting this.
> 
> On Fri, 23 Apr 2021 05:03:49 +0100,
> Ricardo Koller <ricarkol@google.com> wrote:
> > +.pushsection ".entry.text", "ax"
> > +.balign 0x800
> > +.global vectors
> > +vectors:
> > +.popsection
> > +
> > +/*
> > + * Build an exception handler for vector and append a jump to it into
> > + * vectors (while making sure that it's 0x80 aligned).
> > + */
> > +.macro HANDLER, el, label, vector
> > +handler\()\vector:
> > +	save_registers \el
> > +	mov	x0, sp
> > +	mov	x1, \vector
> > +	bl	route_exception
> > +	restore_registers \el
> > +
> > +.pushsection ".entry.text", "ax"
> > +.balign 0x80
> > +	b	handler\()\vector
> > +.popsection
> > +.endm
> 
> That's an interesting construct, wildly different from what we are
> using elsewhere in the kernel, but hey, I like change ;-). It'd be
> good to add a comment to spell out that anything that emits into
> .entry.text between the declaration of 'vectors' and the end of this
> file will break everything.
> 
> > +
> > +.global ex_handler_code
> > +ex_handler_code:
> > +	HANDLER	1, sync, 0			// Synchronous EL1t
> > +	HANDLER	1, irq, 1			// IRQ EL1t
> > +	HANDLER	1, fiq, 2			// FIQ EL1t
> > +	HANDLER	1, error, 3			// Error EL1t
> 
> Can any of these actually happen? As far as I can see, the whole
> selftest environment seems to be designed around EL1h.
>

They can happen. KVM defaults to use EL1h:

	#define VCPU_RESET_PSTATE_EL1   (PSR_MODE_EL1h | PSR_A_BIT | PSR_I_BIT | \

but then a guest can set the SPSel to 0:

	asm volatile("msr spsel, #0");

and this happens:

	  Unexpected exception guest (vector:0x0, ec:0x25)

I think it should still be a valid situation: some test might want to
try it.

Thanks,
Ricardo
