Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBEF3690D4
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 13:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242234AbhDWLGR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 07:06:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29223 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242245AbhDWLGL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Apr 2021 07:06:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619175935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6XHVicoTLSbHdWA8XFB+/kkN/O1wDN0Ij2er34FmuFw=;
        b=cuJdS2HvxhGX18baCGAOBtBUk5+UEt5wNpjaGe0GYGJi8ysPQSVbKJEb0pKMNHM3qEZTNH
        gIWBTBpE1Rg+ayaIJYBaiFsnyRH8MyedOCOR3B7xrQKeiLGYc+4Iisssxm00x/UMDIL0IN
        HDbsMXn+nyW+sk2lslsDRLyxI6x89G0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-jQ8ge6oiN0ia8zMmc5s4AQ-1; Fri, 23 Apr 2021 07:05:33 -0400
X-MC-Unique: jQ8ge6oiN0ia8zMmc5s4AQ-1
Received: by mail-wm1-f70.google.com with SMTP id j187-20020a1c23c40000b0290127873d3384so525028wmj.6
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 04:05:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6XHVicoTLSbHdWA8XFB+/kkN/O1wDN0Ij2er34FmuFw=;
        b=YAA5rsiDtUGeYx1Y+TNQZNoiXRpqCv3N1cLM452tCDqau2aV5e3S20N3e+Q53QihXA
         /IsWJmkqYVmJHOSqS3ATimXoqggEDzEEvbKMshWpzjmgoDG2e/k9KMCcsCGkDuUXL7cP
         VqKvgQcggMmzmtybj85on4ChOHiY7BriDNsxoXw85amf8WPrBBLynJSplTeIsp/Jqnz7
         j5YQ5W7Qsub+3CWeW/49479eRxQ6/u0jHRSSKxgDWW4xAVMbMRlNjLWOWtf3DjU52QAx
         7dXJYeGPrKMWjldZqNaqOotU+ls4CMIvvS3LfBm9ewqVLI2k7l8EN2nouTlpdLJCtomf
         cECw==
X-Gm-Message-State: AOAM533uw3H1Ipp3zEGLQUKmuLbVclez8RpwXq5CZ9+Fg8+8Wszh4+cL
        fYKLv2sglT+fdu4/+6MNwfxPWHZjAH3PIsyEoMWlJi/WwllXGlRnXl1p4skd/3rr8VeCnEkzA85
        FfeGXaywQgj6w
X-Received: by 2002:adf:fbc8:: with SMTP id d8mr4047377wrs.94.1619175932386;
        Fri, 23 Apr 2021 04:05:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyaM5Q2HLo8IcL7t4s/2HBHOYjkBuXbza4hD224Lf6gP3ljhm2fIkz6OihGk76gpoAQzPHP4Q==
X-Received: by 2002:adf:fbc8:: with SMTP id d8mr4047365wrs.94.1619175932257;
        Fri, 23 Apr 2021 04:05:32 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id y11sm8976445wro.37.2021.04.23.04.05.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 04:05:31 -0700 (PDT)
Date:   Fri, 23 Apr 2021 13:05:29 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com
Subject: Re: [PATCH 1/3] KVM: selftests: Add exception handling support for
 aarch64
Message-ID: <20210423110529.vivemdwnznhblhyf@gator>
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

Indeed! Thank you for contributing to AArch64 kvm selftests!

> > +void vm_handle_exception(struct kvm_vm *vm, int vector, int ec,
> > +			void (*handler)(struct ex_regs *));
> > +
> > +#define SPSR_D          (1 << 9)
> > +#define SPSR_SS         (1 << 21)
> > +
> > +#define write_sysreg(reg, val)						  \
> > +({									  \
> > +	asm volatile("msr "__stringify(reg)", %0" : : "r"(val));	  \
> > +})

Linux does fancy stuff with the Z constraint to allow xzr. We might as
well copy that.

> > diff --git a/tools/testing/selftests/kvm/lib/aarch64/handlers.S b/tools/testing/selftests/kvm/lib/aarch64/handlers.S
> > new file mode 100644
> > index 000000000000..c920679b87c0
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/lib/aarch64/handlers.S
> > @@ -0,0 +1,104 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +.macro save_registers, el
> > +	stp	x28, x29, [sp, #-16]!
> > +	stp	x26, x27, [sp, #-16]!
> > +	stp	x24, x25, [sp, #-16]!
> > +	stp	x22, x23, [sp, #-16]!
> > +	stp	x20, x21, [sp, #-16]!
> > +	stp	x18, x19, [sp, #-16]!
> > +	stp	x16, x17, [sp, #-16]!
> > +	stp	x14, x15, [sp, #-16]!
> > +	stp	x12, x13, [sp, #-16]!
> > +	stp	x10, x11, [sp, #-16]!
> > +	stp	x8, x9, [sp, #-16]!
> > +	stp	x6, x7, [sp, #-16]!
> > +	stp	x4, x5, [sp, #-16]!
> > +	stp	x2, x3, [sp, #-16]!
> > +	stp	x0, x1, [sp, #-16]!
> > +
> > +	.if \el == 0
> > +	mrs	x1, sp_el0
> > +	.else
> > +	mov	x1, sp
> > +	.endif
> 
> It there any point in saving SP_EL1, given that you already have
> altered it significantly and will not be restoring it? I don't care
> much, and maybe it is useful as debug information, but a comment would
> certainly make the intent clearer.

kvm-unit-tests takes some pains to save the original sp. We may be able to
take some inspiration from there for this save and restore.

> > +void kvm_exit_unexpected_vector(int vector, uint64_t ec)
> > +{
> > +	ucall(UCALL_UNHANDLED, 2, vector, ec);
> > +}
> > +
> > +#define HANDLERS_IDX(_vector, _ec)	((_vector * ESR_EC_NUM) + _ec)
> 
> This is definitely odd. Not all the ECs are valid for all vector entry
> points. Actually, ECs only make sense for synchronous exceptions, and
> asynchronous events (IRQ, FIQ, SError) cannot populate ESR_ELx.

For this, kvm-unit-tests provides a separate API for interrupt handler
installation, which ensures ec is not used. Also, kvm-unit-tests uses
a 2-D array [vector][ec] for the synchronous exceptions. I think we
should be able to use a 2-D array here too, instead of the IDX macro.

> > +void vm_handle_exception(struct kvm_vm *vm, int vector, int ec,
> > +			 void (*handler)(struct ex_regs *))
> 
> The name seems to be slightly ill defined. To me "handle exception" is
> the action of handling the exception. Here, you are merely installing
> an exception handler.
>

I agree. Please rename this for all of kvm selftests to something with
'install' in the name with the first patch of this series.

Thanks,
drew

