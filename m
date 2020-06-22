Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B301C2034FE
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 12:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgFVKnn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 06:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgFVKnn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 06:43:43 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9663EC061794
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 03:43:41 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id y20so15221331wmi.2
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 03:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=41akXYz0zWUNhlfBjzUWwsJTByPRnzWKiqrdZU1i7G4=;
        b=MIAYt/eEyjzjrMOC9tR0Rnjpy7E0R2DfPDd1YOevwED1wfhVpIvxZ8+xdaPMEzy312
         0tboK0HYL6xZtrqlj5k4dLNaEVV4TGi03EQ6q1oQoKIA7nHHG56OXkjKWemGkLHGeXTN
         0V5NrB/LKvE1oYoNQiIcl4r7cS8wK3E62GQXqGpgKj84VOfwGlcSZXvczqE8TZCIOxYc
         NsxHTCKIwNvQCOxJG/hGYNTJOGLQILiBr59fktX+0IFo0zaXlq+bzEBfU16Lqs9R38vM
         rzn7z6v7QgBthMpLVDcn1vXwfPLx6Hf9x+kCALK4KjxZ49wlhkvobTDvkXApPfzXetOg
         j/Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=41akXYz0zWUNhlfBjzUWwsJTByPRnzWKiqrdZU1i7G4=;
        b=Qd91m8ejDknSMAXRLZXpdjbgjz0+PgSTiqpNxjyd8i90fDvSSwbWdl3uAiv3DdP/li
         ryIOBsL13a2/YdjCFHn4hA8PpF7foxgkZTR7c95GqZbR+DMc9QyOJNxqojUv1ynSLCz9
         ZG0Hu/IC8yOAXVPpUtRR9SUMcKP8dX9G+mAI13e36O8VAh3O6y9WWoob/lvCPMIwAfWK
         1cncs+wukEdZ+5LxkFB8+Rl8IyNUv50BIY8NO4o2AxVd3ZVp1ctVo1bbQvimrqzoYVlE
         0AigiRLEwnnnLuVQCvejo1HjOXIbFvrq2Csrvkv1ItkuS9gL4cELYjfYkI07Zr2CHc0k
         MMOg==
X-Gm-Message-State: AOAM532YOzcRXVBt5nrSnh5zsyc0p0w+DaZj1E740mJScBmPIegvqaTf
        EBNWPl2P3065irg/mcOmVvTqhQ==
X-Google-Smtp-Source: ABdhPJwAZ7DVXsoNP8LJ1W76bsiRbgL84gXPr8NS+WTEdcfmi6/xbh/HvI6TdqdIux1Q492mPuTN9Q==
X-Received: by 2002:a1c:3dc3:: with SMTP id k186mr15237237wma.66.1592822620197;
        Mon, 22 Jun 2020 03:43:40 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:355c:447d:ad3d:ac5c])
        by smtp.gmail.com with ESMTPSA id j6sm15851487wmb.3.2020.06.22.03.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 03:43:39 -0700 (PDT)
Date:   Mon, 22 Jun 2020 11:43:35 +0100
From:   Andrew Scull <ascull@google.com>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Dave Martin <Dave.Martin@arm.com>, kernel-team@android.com
Subject: Re: [PATCH v2 5/5] KVM: arm64: Simplify PtrAuth alternative patching
Message-ID: <20200622104335.GB178085@google.com>
References: <20200622080643.171651-1-maz@kernel.org>
 <20200622080643.171651-6-maz@kernel.org>
 <20200622091508.GB88608@C02TD0UTHF1T.local>
 <20200622103932.GA178085@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200622103932.GA178085@google.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 22, 2020 at 11:39:32AM +0100, Andrew Scull wrote:
> On Mon, Jun 22, 2020 at 10:15:08AM +0100, Mark Rutland wrote:
> > On Mon, Jun 22, 2020 at 09:06:43AM +0100, Marc Zyngier wrote:
> 
> 
> > > --- a/arch/arm64/include/asm/kvm_ptrauth.h
> > > +++ b/arch/arm64/include/asm/kvm_ptrauth.h
> > > @@ -61,44 +61,36 @@
> > >  
> > >  /*
> > >   * Both ptrauth_switch_to_guest and ptrauth_switch_to_host macros will
> > > - * check for the presence of one of the cpufeature flag
> > > - * ARM64_HAS_ADDRESS_AUTH_ARCH or ARM64_HAS_ADDRESS_AUTH_IMP_DEF and
> > > + * check for the presence ARM64_HAS_ADDRESS_AUTH, which is defined as
> > > + * (ARM64_HAS_ADDRESS_AUTH_ARCH || ARM64_HAS_ADDRESS_AUTH_IMP_DEF) and
> > >   * then proceed ahead with the save/restore of Pointer Authentication
> > > - * key registers.
> > > + * key registers if enabled for the guest.
> > >   */
> > >  .macro ptrauth_switch_to_guest g_ctxt, reg1, reg2, reg3
> > > -alternative_if ARM64_HAS_ADDRESS_AUTH_ARCH
> > > +alternative_if_not ARM64_HAS_ADDRESS_AUTH
> > >  	b	1000f
> > >  alternative_else_nop_endif
> > > -alternative_if_not ARM64_HAS_ADDRESS_AUTH_IMP_DEF
> > > -	b	1001f
> > > -alternative_else_nop_endif
> > > -1000:
> > >  	mrs	\reg1, hcr_el2
> > >  	and	\reg1, \reg1, #(HCR_API | HCR_APK)
> > > -	cbz	\reg1, 1001f
> > > +	cbz	\reg1, 1000f
> > >  	add	\reg1, \g_ctxt, #CPU_APIAKEYLO_EL1
> > >  	ptrauth_restore_state	\reg1, \reg2, \reg3
> > > -1001:
> > > +1000:
> > >  .endm
> > 
> > Since these are in macros, we could use \@ to generate a macro-specific
> > lavel rather than a magic number, which would be less likely to conflict
> > with the surrounding environment and would be more descriptive. We do
> > that in a few places already, and here it could look something like:
> > 
> > | alternative_if_not ARM64_HAS_ADDRESS_AUTH
> > | 	b	.L__skip_pauth_switch\@
> > | alternative_else_nop_endif
> > | 	
> > | 	...
> > | 
> > | .L__skip_pauth_switch\@:
> > 
> > Per the gas documentation
> > 
> > | \@
> > |
> > |    as maintains a counter of how many macros it has executed in this
> > |    pseudo-variable; you can copy that number to your output with ‘\@’,
> > |    but only within a macro definition.
> 
> Is this relibale for this sort of application? The description just
> sounds like a counter of macros rather than specifically a unique label
> generator. It may work most of the time but also seems that it has the
> potential to be more fragile given that it would change based on the
> rest of the code in the file to potentially conflict with something it
> didn't previously conflict with. 

Ah, you invoke a macro in order for the label to be generated so it will
increment and the label is namespaced by the prefix. I see.
