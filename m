Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A1134358E
	for <lists+kvm@lfdr.de>; Sun, 21 Mar 2021 23:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbhCUWyy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Mar 2021 18:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbhCUWyd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Mar 2021 18:54:33 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FEEEC061574;
        Sun, 21 Mar 2021 15:54:32 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id h13so17128149eds.5;
        Sun, 21 Mar 2021 15:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Z9xr4Xi94dVtC2WveM03iOasplX5pn6cocHVxQtURPw=;
        b=Wj044R0ik1Ev6nWZVjfnuFjisPcuGeYUoV73SdRZzv7Q70RmfZQV59vJkLuwi31+h7
         /RE9Vyl/tKZM7iT0Bz91iqVuIcO8EeAWQOLTFPskd5ie0hmDHmTdC3zGRNbW5qDZAkoQ
         af8NrkF6AJdS/rbiQt2ime8LzN9LBaA4aWOkvQ1cokAQB0fZ7765lITqWCiUsx2nzg3q
         EegeL4t3vKPLWgtuqTWcGU3P53BGvtvHaNwxAPoLMtAQXn4d60uDVOvdrgRtmcceXX3l
         cJx/4RIjk/p4ilKvEmxWfjxdMWn//Kk5Bt/XbQI17kZ+KH320mFIHse++qmVErGqZbMs
         5AKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Z9xr4Xi94dVtC2WveM03iOasplX5pn6cocHVxQtURPw=;
        b=LManxKjMu/Tyipmixs/Tv+QuSDHz1RowM6i7QngA//RTpwAJF1KLUp6qGNQ+JjU0Qz
         p9Iz/1WmcS6BbZj8BhfMpDrCiMd8ty6mFMeRVDwLRZ92q3Zb3+9JERZzkbytMxtKcv+X
         ybLLioV7+/5PYZ46uxHlcfxJrx5fjXxp3h9SwakGty1d3gq/xQiuSeWLnMY+BocBj//Y
         QfNByB3rMzEmJPtBeaZXS+6eSSdpGeF9Tl7ZGY+HatpOXocPz688T8dmDV/7YxlO7WT8
         pNNv+kQ/7yW7Gkt6XBDQ2hKOEwxiUbrLbyhehLlzXSD4qfWMfGNK5/beISzSjfk2wLnY
         jUcg==
X-Gm-Message-State: AOAM532pqhP4iSaC/pXf1ltE0JwjL74sTra0OonSH+r3vRBNsw/pawvY
        HdyHK4VbFjrww9V7Bx5St3o=
X-Google-Smtp-Source: ABdhPJzl24D9UVY26MI5xmR81wQBrgXkw6Vq0VAa/xb9HuP+7Ib4rduRhdP9QZq/xlQ+AO9ZnpPXvA==
X-Received: by 2002:aa7:df84:: with SMTP id b4mr22388520edy.240.1616367271346;
        Sun, 21 Mar 2021 15:54:31 -0700 (PDT)
Received: from gmail.com (54033286.catv.pool.telekom.hu. [84.3.50.134])
        by smtp.gmail.com with ESMTPSA id e4sm8084346ejz.4.2021.03.21.15.54.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 15:54:30 -0700 (PDT)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date:   Sun, 21 Mar 2021 23:54:28 +0100
From:   Ingo Molnar <mingo@kernel.org>
To:     Randy Dunlap <rdunlap@bombadil.infradead.org>
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, pbonzini@redhat.com,
        seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: A typo fix
Message-ID: <20210321225428.GA1885130@gmail.com>
References: <20210320190425.18743-1-unixbhaskar@gmail.com>
 <f9d4429-d594-8898-935a-e222bb8c247@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9d4429-d594-8898-935a-e222bb8c247@bombadil.infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


* Randy Dunlap <rdunlap@bombadil.infradead.org> wrote:

> 
> 
> On Sun, 21 Mar 2021, Bhaskar Chowdhury wrote:
> 
> > 
> > s/resued/resumed/
> > 
> > Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> 
> Acked-by: Randy Dunlap <rdunlap@infradead.org>
> 
> 
> > ---
> > arch/x86/include/asm/kvm_host.h | 2 +-
> > 1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 9bc091ecaaeb..eae82551acb1 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1470,7 +1470,7 @@ extern u64 kvm_mce_cap_supported;
> > /*
> >  * EMULTYPE_NO_DECODE - Set when re-emulating an instruction (after completing
> >  *			userspace I/O) to indicate that the emulation context
> > - *			should be resued as is, i.e. skip initialization of
> > + *			should be resumed as is, i.e. skip initialization of
> >  *			emulation context, instruction fetch and decode.

This is the *wrong* fix, the correct word in this context is 'reused', 
not 'resumed' ...

See how I fixed most arch/x86/ typo fixes in tip:x86/cleanups:

  d9f6e12fb0b7: ("x86: Fix various typos in comments")
  163b099146b8: ("x86: Fix various typos in comments, take #2")

These single file typo fixes are a bad idea for another reason as 
well, as they create a lot of unnecessary churn.

Thanks,

	Ingo
