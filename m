Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9700F36B987
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 20:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239449AbhDZS7B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 14:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239820AbhDZS7A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 14:59:00 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E599C061574
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 11:58:18 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id h14-20020a17090aea8eb02901553e1cc649so3630247pjz.0
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 11:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uC+i8U1DYABk51F37rCJ7P5O8poPwp+NFIjw6zwOZ2c=;
        b=JuEq54M6xQSipjxCXHUzSdfRcWh9h82ZnxXPcs1RdmvsErPGrx/baNC5nRFhGtngOg
         FvsgO6fKXabxy+m8YcV/rs3+nZSQ20A8nGpz1LbV6yV1kd5Gp5zMBe0gSbG9MGcKGllD
         JfS9Iiq4qge9puIMFqQjPil0/tHPkO2Hmaa3ZiMIUbMtJVBQnVRkmzbgxt+CMQT7wJf4
         pVV+AZJisKhOSQO/c7ww0eW58tSbBefK5ZbwNFV5HhQeRt/TcqKhIxmEgULqk5pu+MR1
         t8mjCt5JTtETEAi+0P7/S6OkdnD68BiSLSqoE5TdK9JSvldCfEoyKakYOspAAL6MFXLc
         XwLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uC+i8U1DYABk51F37rCJ7P5O8poPwp+NFIjw6zwOZ2c=;
        b=ule9RhgFFPixNGGXObrhftP3GoMlTHMD9g5oprqldQ/smr2ZYCunWRrkSjeXR9JC+e
         R4Wyz+e3b1KDSANB3XNklo5neKw0QBYFUqoj1+02vbkiBRvYLV8Y31XpiDh1uLyAsmw8
         Nsvq6Uzq45l5nlwprSpcIRLRuMx9TJ60mF1x9qxgyTBYN26nUyL9jbWW+zQ1eCyqTGaI
         yM9MP00lCb2Vj9fD31Ola/+PKSMOMzXw+gQDhIUo1h9dEjgE3tvxpXaFsI/WEeBKV+bT
         OoqOOxeHpVuKl/kxMyZiegEVGxWyv2dBxEdStUZddVXAHkp8VMhTGKJPOQUnP1sthPcf
         /stg==
X-Gm-Message-State: AOAM531MqCQ7xaUBNzRB7cWzc7PaB2RLKFLuuPfhR026GlRKF/JYyWak
        9H67dyheAxXfwvXxflF2IpAmaTkhF9NnNg==
X-Google-Smtp-Source: ABdhPJzkTREXtqHoctqGihHBPcFzt++MKZsCQrvBXi+RVM7t3GxfmtsMvVVOlyhAizvomEe1Q1jWcg==
X-Received: by 2002:a17:90a:df8d:: with SMTP id p13mr601788pjv.38.1619463497585;
        Mon, 26 Apr 2021 11:58:17 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id b1sm13179440pgf.84.2021.04.26.11.58.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 11:58:16 -0700 (PDT)
Date:   Mon, 26 Apr 2021 11:58:13 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com
Subject: Re: [PATCH 1/3] KVM: selftests: Add exception handling support for
 aarch64
Message-ID: <YIcNRVEF7RXjqHuY@google.com>
References: <20210423040351.1132218-1-ricarkol@google.com>
 <20210423040351.1132218-2-ricarkol@google.com>
 <87sg3hnzrj.wl-maz@kernel.org>
 <20210423110529.vivemdwnznhblhyf@gator>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210423110529.vivemdwnznhblhyf@gator>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 23, 2021 at 01:05:29PM +0200, Andrew Jones wrote:
> On Fri, Apr 23, 2021 at 09:58:24AM +0100, Marc Zyngier wrote:
> > Hi Ricardo,
> > 
> > Thanks for starting this.
> 
> Indeed! Thank you for contributing to AArch64 kvm selftests!
> 
> > > +void vm_handle_exception(struct kvm_vm *vm, int vector, int ec,
> > > +			void (*handler)(struct ex_regs *));
> > > +
> > > +#define SPSR_D          (1 << 9)
> > > +#define SPSR_SS         (1 << 21)
> > > +
> > > +#define write_sysreg(reg, val)						  \
> > > +({									  \
> > > +	asm volatile("msr "__stringify(reg)", %0" : : "r"(val));	  \
> > > +})
> 
> Linux does fancy stuff with the Z constraint to allow xzr. We might as
> well copy that.
> 
> > > diff --git a/tools/testing/selftests/kvm/lib/aarch64/handlers.S b/tools/testing/selftests/kvm/lib/aarch64/handlers.S
> > > new file mode 100644
> > > index 000000000000..c920679b87c0
> > > --- /dev/null
> > > +++ b/tools/testing/selftests/kvm/lib/aarch64/handlers.S
> > > @@ -0,0 +1,104 @@
> > > +/* SPDX-License-Identifier: GPL-2.0 */
> > > +.macro save_registers, el
> > > +	stp	x28, x29, [sp, #-16]!
> > > +	stp	x26, x27, [sp, #-16]!
> > > +	stp	x24, x25, [sp, #-16]!
> > > +	stp	x22, x23, [sp, #-16]!
> > > +	stp	x20, x21, [sp, #-16]!
> > > +	stp	x18, x19, [sp, #-16]!
> > > +	stp	x16, x17, [sp, #-16]!
> > > +	stp	x14, x15, [sp, #-16]!
> > > +	stp	x12, x13, [sp, #-16]!
> > > +	stp	x10, x11, [sp, #-16]!
> > > +	stp	x8, x9, [sp, #-16]!
> > > +	stp	x6, x7, [sp, #-16]!
> > > +	stp	x4, x5, [sp, #-16]!
> > > +	stp	x2, x3, [sp, #-16]!
> > > +	stp	x0, x1, [sp, #-16]!
> > > +
> > > +	.if \el == 0
> > > +	mrs	x1, sp_el0
> > > +	.else
> > > +	mov	x1, sp
> > > +	.endif
> > 
> > It there any point in saving SP_EL1, given that you already have
> > altered it significantly and will not be restoring it? I don't care
> > much, and maybe it is useful as debug information, but a comment would
> > certainly make the intent clearer.
> 
> kvm-unit-tests takes some pains to save the original sp. We may be able to
> take some inspiration from there for this save and restore.
> 
> > > +void kvm_exit_unexpected_vector(int vector, uint64_t ec)
> > > +{
> > > +	ucall(UCALL_UNHANDLED, 2, vector, ec);
> > > +}
> > > +
> > > +#define HANDLERS_IDX(_vector, _ec)	((_vector * ESR_EC_NUM) + _ec)
> > 
> > This is definitely odd. Not all the ECs are valid for all vector entry
> > points. Actually, ECs only make sense for synchronous exceptions, and
> > asynchronous events (IRQ, FIQ, SError) cannot populate ESR_ELx.
> 
> For this, kvm-unit-tests provides a separate API for interrupt handler
> installation, which ensures ec is not used. Also, kvm-unit-tests uses
> a 2-D array [vector][ec] for the synchronous exceptions. I think we
> should be able to use a 2-D array here too, instead of the IDX macro.
> 
> > > +void vm_handle_exception(struct kvm_vm *vm, int vector, int ec,
> > > +			 void (*handler)(struct ex_regs *))
> > 
> > The name seems to be slightly ill defined. To me "handle exception" is
> > the action of handling the exception. Here, you are merely installing
> > an exception handler.
> >
> 
> I agree. Please rename this for all of kvm selftests to something with
> 'install' in the name with the first patch of this series.
> 
> Thanks,
> drew
> 

Thank you Andrew and Marc for the reviews. Will send v2 with all the
feedback.
