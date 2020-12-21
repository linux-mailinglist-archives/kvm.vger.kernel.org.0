Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75CBF2E02CD
	for <lists+kvm@lfdr.de>; Tue, 22 Dec 2020 00:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbgLUXF7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Dec 2020 18:05:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgLUXF6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Dec 2020 18:05:58 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E649C0613D6
        for <kvm@vger.kernel.org>; Mon, 21 Dec 2020 15:05:16 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id w1so457712pjc.0
        for <kvm@vger.kernel.org>; Mon, 21 Dec 2020 15:05:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=LeoeYnCQ4DjHLLXlMxxQJshzAfmMhw5UEdcS2SRtSy4=;
        b=Ftr369q9NwaPNhLcUHiuHQkp7Le7NZyiC2K8bG8lqMkcSxIRbREQK8cxCw70jEIuk8
         fpp3rw8vRTQdVoVnGfKISRtuIiESfmbNppyrNt8ynyBTm/fFNSZWNe9NKKFHw73j2EOi
         MciYSOFxYWYGeua+iAl+sW7GAK8JrXbknG6J5fSWd/+uKj4puUY2R/kqJLt5B7gat645
         mFkkWbw+S99Am+DWBg9bzDUErbsm1cfqhI3LHqFmbGfFfpBgiYecSmBxz9y9acucMYSW
         kC9nVAF30TWUs4Z64IX6kLG10PsWpyV8VfQsp48dJmOXPKl2O54EjArdzjDyf6ZTztJJ
         Nl9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=LeoeYnCQ4DjHLLXlMxxQJshzAfmMhw5UEdcS2SRtSy4=;
        b=YTjcKMNtKTbAl21Ds2IXeAWGXzSoqFfottneCfM2C50oZHg+cRHtNWOCAm1tLBih/V
         FzO5Qy4K2cgq+V84YjiglceHkQRYbtb3Pyl+4phbBvzTHYjnuq9yWN1j7NrobhRHLNl/
         dt8UOmklxrWGnV80Ml6EqZaBqTJwoeF8nz6bkikB0+H/mNVUAlDBEXkowKEvH1YmNsbY
         gMDEu/+cnR7xTubTc6bec69Bx723ZsANI32GcPq0gax9w0frmpjcxcz7q27QvbiKFJe4
         gcJAGCLFcxH0mKeSqZE8FfO2izJX/JLEQKLzN3sx9Y1c7ldKbBHl6fDY6pdRqW6xfuP7
         nOQQ==
X-Gm-Message-State: AOAM5324yihCNIE9j174NtrkD93GNm5vItL013r12KC8/kDQbxjVZndj
        0zHrFk8u/akRfuMfFmf1NGcq+Q==
X-Google-Smtp-Source: ABdhPJymkZ99e3soMAm7qGBFf5xuPRNrUkIcWAxP77eBmgNUrWJtwOrB/MUJpfwVsDfW1PLtlQ4oKw==
X-Received: by 2002:a17:902:9b91:b029:db:f003:c5eb with SMTP id y17-20020a1709029b91b02900dbf003c5ebmr18176770plp.1.1608591915873;
        Mon, 21 Dec 2020 15:05:15 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id w27sm14034183pfq.104.2020.12.21.15.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 15:05:15 -0800 (PST)
Date:   Mon, 21 Dec 2020 15:05:08 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     Uros Bizjak <ubizjak@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3] KVM/x86: Move definition of __ex to x86.h
Message-ID: <X+EqJB/k1kxSWE7m@google.com>
References: <20201221194800.46962-1-ubizjak@gmail.com>
 <a773afca-7f28-2392-74ad-0895da3f75ca@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a773afca-7f28-2392-74ad-0895da3f75ca@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 21, 2020, Krish Sadhukhan wrote:
> 
> On 12/21/20 11:48 AM, Uros Bizjak wrote:
> > diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> > index c5ee0f5ce0f1..5b16d2b5c3bc 100644
> > --- a/arch/x86/kvm/x86.h
> > +++ b/arch/x86/kvm/x86.h
> > @@ -8,6 +8,30 @@
> >   #include "kvm_cache_regs.h"
> >   #include "kvm_emulate.h"
> > +asmlinkage void kvm_spurious_fault(void);
> > +
> > +/*
> > + * Handle a fault on a hardware virtualization (VMX or SVM) instruction.
> > + *
> > + * Hardware virtualization extension instructions may fault if a reboot turns
> > + * off virtualization while processes are running.  Usually after catching the
> > + * fault we just panic; during reboot instead the instruction is ignored.
> > + */
> > +#define __ex(insn)							\
> 
> 
> While the previous name was too elaborate, this new name is very cryptic. 
> Unless we are saving for space,it's better to give a somewhat descriptive
> name.

We are saving for space in a way.  Not so much to actually save lines of code,
but to avoid stealing the focus from the code that matters.  __ex() is cryptic
for the completely unfamiliar, but I'm worried that anything more verbose will
harm the readability of the code where it is used, which is usually what's more
important in the long run.  

__ex() does have some meaning, as it's connected to the various ex_handler_*()
helpers.  ex_handle() is the best semi-verbose alternative that I can think of,
but even that is too long for my liking when reading the inline asm flows.  And
it's not like ex_handle() tells the whole story; the reader still has to go to
the definition to understand what it does, or worse, will make incorrect
assumptions about how exceptions are handled.

E.g. with the short version, my eyes gravitate toward vmxoff/vmsave without
getting stuck on the verbose wrapper.

	asm volatile (__ex("vmxoff"));

	asm volatile(__ex("vmsave") : : "a" (__sme_page_pa(sd->save_area)) : "memory");

vs.

	asm volatile (ex_handle("vmxoff"));

	asm volatile(ex_handle("vmsave") : : "a" (__sme_page_pa(sd->save_area)) : "memory");
