Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C9C37C7F3
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 18:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237146AbhELQDa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 12:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232791AbhELPxJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 11:53:09 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0D1C06137C
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 08:27:34 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id bo23-20020a17090b0917b029015cb1f2fd59so621014pjb.2
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 08:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1p7s7yHbJjgTEPNp24tZw18ktReYfalK9gHrNJbuQyA=;
        b=rWvZTyo+BT81E3IA1vzV56GxMSZ2zHK+3Y12M1DD9IHnTVBZT9O8jIBaufryo6ikGW
         j2goUsop2XE0C3JHUgurfOfKmpybGuWDV3hgkvI/gkI39nRLQ5EvFQCEfa2Wl4Bz5fHM
         pXGwQ76fFj90ApTpL3jTMKb+e/9DAiG4kwmYHEnDwrwzZvPDGWGGP2DmTygjLUPN2aoe
         jjrqT3iStlGMp2kYu3oFkgR0gxq7r0tijsBsr9W6AirlbqBCNYYlP3cl8CGulW3CoQZH
         eVDdvL6lMXSk8jHKzmP89OxprXv1pZtd+GQNehgrUuLYAEzVtZLGHBMtBI1c+MYrbboe
         VASw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1p7s7yHbJjgTEPNp24tZw18ktReYfalK9gHrNJbuQyA=;
        b=LPq9DH9mV7k+dKSI5W9TiejVUK8zosJnmrZ0lqH8wdaSNTslwBkNmDJWadVVujDCIM
         lTnhLn4EhPNHO9IXTDmkEYI3BMQOVfM6m8rxCnRrTqAHL6xqi/StP2pGHf+NMkjUh+gf
         2e0QBqhYzwItKirmPhZNY1IZ7yFt9LE3pyzOMNjvI4rNXTvi81gaxbsxBZAHdrqRx4TZ
         wc/zkK8mRwtdrNZ8TPrNbkbDDJuFqAGRawe+HYJ58Xd+UoH2INg0W8TbBp+3zA8se65x
         IzPdKNY2IRW/+6PdaewgWemWdavyXL6xD9gqsnM+2fJuzIjcNn2I3tLyqAR1SNSpEyWt
         ePAg==
X-Gm-Message-State: AOAM533GdeLkx2sNAsn0IKYhhi8vYSOM7kI37hpnyBA6s7ehZn8GhvFj
        1I1aort7FmypBBmVBOzr/zANWQ==
X-Google-Smtp-Source: ABdhPJzpzn0JDIkhvQrJ7XJ2OE5lv5VRxXO91bDuAsfDQQFSS7dg+I2D2r/31mHpYTiOeb8deoAWZg==
X-Received: by 2002:a17:90a:f3d3:: with SMTP id ha19mr39726268pjb.166.1620833254037;
        Wed, 12 May 2021 08:27:34 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id v18sm189525pff.90.2021.05.12.08.27.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 08:27:33 -0700 (PDT)
Date:   Wed, 12 May 2021 15:27:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Uros Bizjak <ubizjak@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: SVM/VMX: Use %rax instead of %__ASM_AX within
 CONFIG_X86_64
Message-ID: <YJvz4crhU7Gbn0p0@google.com>
References: <20210512112115.70048-1-ubizjak@gmail.com>
 <074223fd-6f82-9ed6-8664-f324f5027da5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <074223fd-6f82-9ed6-8664-f324f5027da5@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 12, 2021, Paolo Bonzini wrote:
> On 12/05/21 13:21, Uros Bizjak wrote:
> > There is no need to use %__ASM_AX within CONFIG_X86_64. The macro
> > will always expand to %rax.
> > diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> > index 3a6461694fc2..9273709e4800 100644
> > --- a/arch/x86/kvm/vmx/vmenter.S
> > +++ b/arch/x86/kvm/vmx/vmenter.S
> > @@ -142,14 +142,14 @@ SYM_FUNC_START(__vmx_vcpu_run)
> >   	mov VCPU_RSI(%_ASM_AX), %_ASM_SI
> >   	mov VCPU_RDI(%_ASM_AX), %_ASM_DI
> >   #ifdef CONFIG_X86_64
> > -	mov VCPU_R8 (%_ASM_AX),  %r8
> > -	mov VCPU_R9 (%_ASM_AX),  %r9
> > -	mov VCPU_R10(%_ASM_AX), %r10
> > -	mov VCPU_R11(%_ASM_AX), %r11
> > -	mov VCPU_R12(%_ASM_AX), %r12
> > -	mov VCPU_R13(%_ASM_AX), %r13
> > -	mov VCPU_R14(%_ASM_AX), %r14
> > -	mov VCPU_R15(%_ASM_AX), %r15
> > +	mov VCPU_R8 (%rax),  %r8
> > +	mov VCPU_R9 (%rax),  %r9
> > +	mov VCPU_R10(%rax), %r10
> > +	mov VCPU_R11(%rax), %r11
> > +	mov VCPU_R12(%rax), %r12
> > +	mov VCPU_R13(%rax), %r13
> > +	mov VCPU_R14(%rax), %r14
> > +	mov VCPU_R15(%rax), %r15
> >   #endif
> >   	/* Load guest RAX.  This kills the @regs pointer! */
> >   	mov VCPU_RAX(%_ASM_AX), %_ASM_AX
> > @@ -175,14 +175,14 @@ SYM_FUNC_START(__vmx_vcpu_run)
> >   	mov %_ASM_SI, VCPU_RSI(%_ASM_AX)
> >   	mov %_ASM_DI, VCPU_RDI(%_ASM_AX)
> >   #ifdef CONFIG_X86_64
> > -	mov %r8,  VCPU_R8 (%_ASM_AX)
> > -	mov %r9,  VCPU_R9 (%_ASM_AX)
> > -	mov %r10, VCPU_R10(%_ASM_AX)
> > -	mov %r11, VCPU_R11(%_ASM_AX)
> > -	mov %r12, VCPU_R12(%_ASM_AX)
> > -	mov %r13, VCPU_R13(%_ASM_AX)
> > -	mov %r14, VCPU_R14(%_ASM_AX)
> > -	mov %r15, VCPU_R15(%_ASM_AX)
> > +	mov %r8,  VCPU_R8 (%rax)
> > +	mov %r9,  VCPU_R9 (%rax)
> > +	mov %r10, VCPU_R10(%rax)
> > +	mov %r11, VCPU_R11(%rax)
> > +	mov %r12, VCPU_R12(%rax)
> > +	mov %r13, VCPU_R13(%rax)
> > +	mov %r14, VCPU_R14(%rax)
> > +	mov %r15, VCPU_R15(%rax)
> >   #endif
> >   	/* Clear RAX to indicate VM-Exit (as opposed to VM-Fail). */
> > 
> 
> It looks a bit weird either way (either the address is different within the
> #ifdef, or the address is different from the destinatino), so I lean more
> towards avoiding churn.

Even though it's unnecessary, I prefer %_ASM_AX since it provides a consistent
flow across the 64-bit-only boundary.
