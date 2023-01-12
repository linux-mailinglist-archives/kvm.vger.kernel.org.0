Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 893A1668723
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 23:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237088AbjALWnE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 17:43:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235985AbjALWnC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 17:43:02 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C53545E0BE
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 14:42:57 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id z4-20020a17090a170400b00226d331390cso22549727pjd.5
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 14:42:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tqKOG577l6PVAmU6CxoNSS4VgMWPVhEdV8Oq9ulxoEc=;
        b=HYSGl0TbUOxwm6hVYqP5AykntqHk9XFGrjaY/5bluQ9KTGdAgUQQe3JPdHMNNIeHSd
         EjHruLM8OO810UmCF2PwM1CDkkrJ3OJPaWevM3tMmeE+oXc/EaIKsCE0ilPIijCs7fvy
         +3PTiLB15jKaKxNDuH69AfE+ytwXJ9oaPIwYU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tqKOG577l6PVAmU6CxoNSS4VgMWPVhEdV8Oq9ulxoEc=;
        b=wh7tWJeDR8E7VjyGtHQpxXyd16iZPiiV+VMTCxHjMiCPBSP36L4TzL3i6bs2uzl9mT
         rx0IB7GRSVwd4/3l5Kb951blirDvibacog9MWxa+n2AtHvHgki+iStl8GlXzFQ9gdy9H
         O+Dmi2hqs1ULO3A3XBhJmyPJOiD14/o0RIiJfhjVYU7qzQ0ajt6FahT/GsuEAb4MHYSI
         i6qBgtbMY1lksKn5U6sCePiV/7t3zQFQiTX6Hpe0eaN4ac0f3tqOXwU+kH6jlAaXlz0g
         gHL1pcnZp0R/M7FY1xh4vRGm+UQq4tou7V8nm7SU75spsSup3hA7J05Di4rqFbmVc1Zs
         eNBQ==
X-Gm-Message-State: AFqh2kqEQPahh8XIrmDkfy3bEfoK4R/OM+K68JcLVc+wB8Fxlm5MD5NQ
        R46sLs/yV6/qMslH1PbH3RxE3Q==
X-Google-Smtp-Source: AMrXdXuNOTJBNQ534uvVdr3PVS0ZkHrpACjbEUR5hhNSLBxq71QNNxk33HXjoOTY6fT6rWjV/bcNzw==
X-Received: by 2002:a17:902:da8f:b0:194:5519:5766 with SMTP id j15-20020a170902da8f00b0019455195766mr5990391plx.40.1673563377229;
        Thu, 12 Jan 2023 14:42:57 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id j6-20020a170902690600b00192aecb231asm12703764plk.121.2023.01.12.14.42.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 14:42:56 -0800 (PST)
Date:   Thu, 12 Jan 2023 14:42:56 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Replace 0-length arrays with flexible arrays
Message-ID: <202301121441.1E38EE308@keescook>
References: <20230105190548.never.323-kees@kernel.org>
 <Y7xPSEMOWqz+3kgD@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7xPSEMOWqz+3kgD@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 09, 2023 at 05:30:48PM +0000, Sean Christopherson wrote:
> On Thu, Jan 05, 2023, Kees Cook wrote:
> > Zero-length arrays are deprecated[1]. Replace struct kvm_nested_state's
> > "data" union 0-length arrays with flexible arrays. (How are the
> > sizes of these arrays verified?)
> 
> It's not really interpreted as an array, it's a mandatory single-entry "array".
> 
> 	if (copy_from_user(vmcs12, user_vmx_nested_state->vmcs12, sizeof(*vmcs12)))
> 		return -EFAULT;

If it's mandatory, why is it [0] instead of just a single struct? i.e.
why is it not:

	union {
		struct kvm_vmx_nested_state_data vmx;
		struct kvm_svm_nested_state_data svm;
	};

> 
> > Detected with GCC 13, using -fstrict-flex-arrays=3:
> > 
> > arch/x86/kvm/svm/nested.c: In function 'svm_get_nested_state':
> > arch/x86/kvm/svm/nested.c:1536:17: error: array subscript 0 is outside array bounds of 'struct kvm_svm_nested_state_data[0]' [-Werror=array-bounds=]
> >  1536 |                 &user_kvm_nested_state->data.svm[0];
> >       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > In file included from include/uapi/linux/kvm.h:15,
> >                  from include/linux/kvm_host.h:40,
> >                  from arch/x86/kvm/svm/nested.c:18:
> > arch/x86/include/uapi/asm/kvm.h:511:50: note: while referencing 'svm'
> >   511 |                 struct kvm_svm_nested_state_data svm[0];
> >       |                                                  ^~~
> > 
> > [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays
> > 
> > Cc: Sean Christopherson <seanjc@google.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: Borislav Petkov <bp@alien8.de>
> > Cc: Dave Hansen <dave.hansen@linux.intel.com>
> > Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> > Cc: x86@kernel.org
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: kvm@vger.kernel.org
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> 
> Nit on the comment aside,
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> 
> >  arch/x86/include/uapi/asm/kvm.h | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> > index e48deab8901d..8ec3dfd641b0 100644
> > --- a/arch/x86/include/uapi/asm/kvm.h
> > +++ b/arch/x86/include/uapi/asm/kvm.h
> > @@ -502,13 +502,13 @@ struct kvm_nested_state {
> >  	} hdr;
> >  
> >  	/*
> > -	 * Define data region as 0 bytes to preserve backwards-compatability
> > +	 * Define union of flexible arrays to preserve backwards-compatability
> 
> I think I'd actually prefer the "as 0 bytes" comment.  The important part is that
> the size of "data" be zero, how that happens is immaterial.

Okay, I'll drop this part.

> 
> >  	 * to old definition of kvm_nested_state in order to avoid changing
> >  	 * KVM_{GET,PUT}_NESTED_STATE ioctl values.
> >  	 */
> >  	union {
> > -		struct kvm_vmx_nested_state_data vmx[0];
> > -		struct kvm_svm_nested_state_data svm[0];
> > +		__DECLARE_FLEX_ARRAY(struct kvm_vmx_nested_state_data, vmx);
> > +		__DECLARE_FLEX_ARRAY(struct kvm_svm_nested_state_data, svm);
> >  	} data;
> >  };
> >  
> > -- 
> > 2.34.1
> > 

-- 
Kees Cook
