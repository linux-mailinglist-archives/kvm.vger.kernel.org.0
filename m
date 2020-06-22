Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02AF42034F3
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 12:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgFVKjk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 06:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727066AbgFVKjk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 06:39:40 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B803BC061794
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 03:39:39 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id f18so2658063wml.3
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 03:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Lb/frQrugPlke769VI0ZGjO7llYS1ocNVbXaMbRE4lg=;
        b=BYWy1U3LTb7z1OQDvwZvSosKr1sv3gduL754zzevWWN7Ns1D38AkKsd8PAjr7ruqJP
         6N36GAb4b+1ZsqTjT9BGrE7KWe6iP5ifH6s3842R+A+9WxhZ5pnuVruniORrL3BAEAvk
         mj6HXKQ45TrrgkqBKLaFqO9x73kt+C/ulCuNRcQn12CJEOApO9pxx5gXJTgGdy5WmY3k
         a8Gs3FP1mmk0BhmfR8zcCbQlZYkEfdhv+D7gyjFiwPjkiCCnfwW7vEH89P5um6fgfwXT
         9IXfqrX+ZNUkFtXTxkzsHQX7s85JjnoMpwb2Wm1HTIu6XaDeTOsltX4wJIEfDxHr/NIk
         +7YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Lb/frQrugPlke769VI0ZGjO7llYS1ocNVbXaMbRE4lg=;
        b=aNwMvwJcr7fsPjmYggP6fgtCHjMNdR7s1q49O05VAiRCno8nwOipwoZPxgIld6LdXL
         Bp1zZcvf/1i7w3xSaob7K0Je+lE3BxsMuPM/FB9wWzUMK/qci7PgBro6BVwULrQG+e2b
         2R0dZBsYJlu5TXR8PSySQYsk5IflynZGJZWeNow1L0fp9iyCgGJtdiERTM057KwhFzVM
         8BP4lB69+dFIzQEs33ys6OD353rST+skiqovkHxI4bJW7k8ysMJFUfqM3i0xRrnv3LkW
         jTMfKEJY7nNBOiCUP8guSsTZRYUolfp/GvNznKmVjpQwvmhJn03DnrL/4AxnKowiASlu
         zNuQ==
X-Gm-Message-State: AOAM533my1N6oNmrdj1WOKR6a3m9eOsprIe+oHk91vKzQS9M8MHEE3kJ
        fI+49MitTJi6+WTOyU9gPrvcag==
X-Google-Smtp-Source: ABdhPJw4ly1lF7pDB7TqBfR669amiQoWOkVZzba+2H5Qih6YqqlqJd9J1Sg6mf6Q9ECAf2qRBMfBMw==
X-Received: by 2002:a1c:6408:: with SMTP id y8mr9774703wmb.122.1592822378088;
        Mon, 22 Jun 2020 03:39:38 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:355c:447d:ad3d:ac5c])
        by smtp.gmail.com with ESMTPSA id 65sm12666681wre.6.2020.06.22.03.39.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 03:39:37 -0700 (PDT)
Date:   Mon, 22 Jun 2020 11:39:32 +0100
From:   Andrew Scull <ascull@google.com>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Dave Martin <Dave.Martin@arm.com>, kernel-team@android.com
Subject: Re: [PATCH v2 5/5] KVM: arm64: Simplify PtrAuth alternative patching
Message-ID: <20200622103932.GA178085@google.com>
References: <20200622080643.171651-1-maz@kernel.org>
 <20200622080643.171651-6-maz@kernel.org>
 <20200622091508.GB88608@C02TD0UTHF1T.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200622091508.GB88608@C02TD0UTHF1T.local>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 22, 2020 at 10:15:08AM +0100, Mark Rutland wrote:
> On Mon, Jun 22, 2020 at 09:06:43AM +0100, Marc Zyngier wrote:


> > --- a/arch/arm64/include/asm/kvm_ptrauth.h
> > +++ b/arch/arm64/include/asm/kvm_ptrauth.h
> > @@ -61,44 +61,36 @@
> >  
> >  /*
> >   * Both ptrauth_switch_to_guest and ptrauth_switch_to_host macros will
> > - * check for the presence of one of the cpufeature flag
> > - * ARM64_HAS_ADDRESS_AUTH_ARCH or ARM64_HAS_ADDRESS_AUTH_IMP_DEF and
> > + * check for the presence ARM64_HAS_ADDRESS_AUTH, which is defined as
> > + * (ARM64_HAS_ADDRESS_AUTH_ARCH || ARM64_HAS_ADDRESS_AUTH_IMP_DEF) and
> >   * then proceed ahead with the save/restore of Pointer Authentication
> > - * key registers.
> > + * key registers if enabled for the guest.
> >   */
> >  .macro ptrauth_switch_to_guest g_ctxt, reg1, reg2, reg3
> > -alternative_if ARM64_HAS_ADDRESS_AUTH_ARCH
> > +alternative_if_not ARM64_HAS_ADDRESS_AUTH
> >  	b	1000f
> >  alternative_else_nop_endif
> > -alternative_if_not ARM64_HAS_ADDRESS_AUTH_IMP_DEF
> > -	b	1001f
> > -alternative_else_nop_endif
> > -1000:
> >  	mrs	\reg1, hcr_el2
> >  	and	\reg1, \reg1, #(HCR_API | HCR_APK)
> > -	cbz	\reg1, 1001f
> > +	cbz	\reg1, 1000f
> >  	add	\reg1, \g_ctxt, #CPU_APIAKEYLO_EL1
> >  	ptrauth_restore_state	\reg1, \reg2, \reg3
> > -1001:
> > +1000:
> >  .endm
> 
> Since these are in macros, we could use \@ to generate a macro-specific
> lavel rather than a magic number, which would be less likely to conflict
> with the surrounding environment and would be more descriptive. We do
> that in a few places already, and here it could look something like:
> 
> | alternative_if_not ARM64_HAS_ADDRESS_AUTH
> | 	b	.L__skip_pauth_switch\@
> | alternative_else_nop_endif
> | 	
> | 	...
> | 
> | .L__skip_pauth_switch\@:
> 
> Per the gas documentation
> 
> | \@
> |
> |    as maintains a counter of how many macros it has executed in this
> |    pseudo-variable; you can copy that number to your output with ‘\@’,
> |    but only within a macro definition.

Is this relibale for this sort of application? The description just
sounds like a counter of macros rather than specifically a unique label
generator. It may work most of the time but also seems that it has the
potential to be more fragile given that it would change based on the
rest of the code in the file to potentially conflict with something it
didn't previously conflict with. 
