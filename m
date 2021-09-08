Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BABA4040DB
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 00:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235902AbhIHWIt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 18:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235838AbhIHWIs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 18:08:48 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEAD5C061575
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 15:07:39 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id mf2so7148856ejb.9
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 15:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cDG/P2eUoSTSpe2KQH+KOgYAPhYf5wGgbjjv6J2pkOo=;
        b=Ie89JsZhZSvF//k1lJLHphylHfAd1p0Xgc1MO8VwlH7F4C6jQhekvhrD5EvyEspqfk
         J1P6GwyJ6w3E+losy3FVZkZjr37H2IVmHfuUfeHp3AVmu6PxEjUMaJ2aUF6LvrY5tVTk
         0KP28vyuY8VZkIqatNQb0Ry+T4AOOw5rFnuwygPj9M9UvetA+GkBmhlaYdSZYlK2e0NN
         2v/w5Oxkc7RDUE8r9SEFogej5vS6YYvNVGx/SRX0QhPH0IvTjYv6AvznHjCJWjiLJsvU
         Hhz1OHJ4MKKhD2mWywYV8Mz4ZBLFoAf2nu6/2i/BE1nY/vfxu0QHAPs+rnQQV/Y6FPPF
         fMhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cDG/P2eUoSTSpe2KQH+KOgYAPhYf5wGgbjjv6J2pkOo=;
        b=IkDzNGOUXUz/K+H9gvf96K+X31LTsj+Oy/7vHC03QvLvoEteZM3zlAjNS21zZxbm4+
         YaZBkuKL3DMWuC8a/nzRyMo0dc/SDJsES6kfGHUgL+ha414kbWXuQpGg8kQKbZknbjhe
         8NU0jHzIFoXU72KQHbJZ99GFMNrHEWAg9IUQWhgJHa629tozNWEejz7wHaCQB2pi23CI
         fzV/RXmWhJgXPtCCUJE3XKJ2EDMxwymelNt4P61oyvNJbsXh/U/L5PZhqAhrvVxuLExZ
         NSSQ2zWUYQ+PfgyaRdVKuZOu8I+BGP3DrbgDwcaa15mcBp1EHtvM7pgImKToa7HZWzxm
         tTqA==
X-Gm-Message-State: AOAM533ENe0I67XHFQRtCozjQwAU0gGtHCEew1fiTOugEb19NFg2N3eB
        RG/iCj3RCOwmD9YfU/M415gmc/WItjbAoi4oxD98wX+1Xg==
X-Google-Smtp-Source: ABdhPJyx7ilcwdO8vAJ/SUcaoghvgKCf4KEiRqUbQ2Ig0novhk2hXjtdFQ6kUZenZy6Yi+JgT/6KbXD6/50WyZ2pKz8=
X-Received: by 2002:a17:906:180a:: with SMTP id v10mr354852eje.112.1631138857950;
 Wed, 08 Sep 2021 15:07:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210825222604.2659360-1-morbo@google.com> <20210908204541.3632269-1-morbo@google.com>
 <20210908204541.3632269-3-morbo@google.com> <YTkv6HXYEGnDe56h@google.com>
In-Reply-To: <YTkv6HXYEGnDe56h@google.com>
From:   Bill Wendling <morbo@google.com>
Date:   Wed, 8 Sep 2021 15:07:27 -0700
Message-ID: <CAGG=3QX1L1dsFHhQhiEHPRycm8ot2Abw1j=wR60ezVoKgU0KmQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 2/5] x86: realmode: mark
 exec_in_big_real_mode as noinline
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 8, 2021 at 2:49 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Sep 08, 2021, Bill Wendling wrote:
> > exec_in_big_real_mode() uses inline asm that has labels. Clang decides
>
> _global_ labels.  Inlining functions with local labels, including asm goto labels,
> is not problematic, the issue is specific to labels that must be unique for a
> given compilation unit.
>
> > that it can inline this function, which causes the assembler to complain
> > about duplicate symbols. Mark the function as "noinline" to prevent
> > this.
> >
> > Signed-off-by: Bill Wendling <morbo@google.com>
> > ---
> >  x86/realmode.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/x86/realmode.c b/x86/realmode.c
> > index b4fa603..07a477f 100644
> > --- a/x86/realmode.c
> > +++ b/x86/realmode.c
> > @@ -178,7 +178,7 @@ static inline void init_inregs(struct regs *regs)
> >               inregs.esp = (unsigned long)&tmp_stack.top;
> >  }
> >
> > -static void exec_in_big_real_mode(struct insn_desc *insn)
> > +static __attribute__((noinline)) void exec_in_big_real_mode(struct insn_desc *insn)
>
> Forgot to use the new define in this patch :-)
>
This was intentional. realmode.c doesn't #include any header files,
and adding '#include "libflat.h" causes a lot of warnings and errors.
We could do that, but I feel it's beyond the scope of this series of
patches.

-bw
