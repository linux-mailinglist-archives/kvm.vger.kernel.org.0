Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9423405BE2
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 19:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240530AbhIIRUz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 13:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235813AbhIIRUy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 13:20:54 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD76FC061574
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 10:19:44 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id t19so5068567ejr.8
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 10:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HP6zYcpN9FTCWRSqbs+P2HEdnIvKmMR7Slns5ajotdk=;
        b=O7ZKQV9R/GtyXSocKl+UyRIcG2TtwdAeFQiTGMjV5gOtkwQNzrmMZGOQYXUfvwrlF6
         u/KKzGgGaYSYCcOL5vg1NFmVLymU6tSvUqO235qJQIUxZZp0TOOJOn8xTLrZsbiRzOLa
         SDESGrE4cn99EvFxLhwc9SWqZI9R8IjgJ69i9MuN3q5lFd0dG58kPpdIhqH5OSG3YnP9
         nX64SkVyT9kLpRf3FJ9GxxQrrTBsnn6rZCVXXEtGqRKS7QZbjuQciN154j2gIhjtU2pU
         2DUYQ+UF4JLkq7psolkIJKCb8M7tg7WhRK30c3MmsWeplHjD+VL7ieVivpMuirCL5tx2
         Zy6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HP6zYcpN9FTCWRSqbs+P2HEdnIvKmMR7Slns5ajotdk=;
        b=NyK2+1qQ6BpgT4D+1sjPTds3xZa/RKofDAI9L3VOQD8O4ZaTzBM3bLa0a5/1F3FmJk
         IiiP6A9eSikGhwR3S1utQhduRefYEj/BjHKMvub44fevmk1QHiwkxL2ry2FGEU/0/X4Y
         Qm6NO12AANfYotYEHKKF/UqNo7w2UB7dA8mMPGmS6I7Esah/eAnE6BbHJ5uKKHtC7HFE
         n9DywTKrwJOP7leS2A0Px7ct5DGpqs6Waxi1OioMREVUFcKumDhVrOFDFn5+Lz1RZJFo
         TKOnNs0kf/8WkpeP4z5o8sqjREQluQjzANA0BS8JfqcharEkQnu/YIjIR6DrpDYsDlr4
         sQAg==
X-Gm-Message-State: AOAM531tV0ndlj3DTeDd3ruKPLU2SPr/Mjf5QbnXm1um26tByAcOnYtM
        546PjZYbKRH6J08tIMYCQLf0zL+TDmglNF3LkTawnAJWOQ==
X-Google-Smtp-Source: ABdhPJyCMijf54lukseMqOggIsTy5V2XL7j5b0M3LhpyCRS0zSbLiLtv2yXEZcx6N/EJqcigWSmoQ3aIzEsQKQONGMo=
X-Received: by 2002:a17:906:2c10:: with SMTP id e16mr4508234ejh.182.1631207982958;
 Thu, 09 Sep 2021 10:19:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210825222604.2659360-1-morbo@google.com> <20210908204541.3632269-1-morbo@google.com>
 <20210908204541.3632269-3-morbo@google.com> <YTkv6HXYEGnDe56h@google.com>
 <CAGG=3QX1L1dsFHhQhiEHPRycm8ot2Abw1j=wR60ezVoKgU0KmQ@mail.gmail.com> <YTk+amslyQCsM3+M@google.com>
In-Reply-To: <YTk+amslyQCsM3+M@google.com>
From:   Bill Wendling <morbo@google.com>
Date:   Thu, 9 Sep 2021 10:19:31 -0700
Message-ID: <CAGG=3QWBiyxC_K96yXZPxCBHoB3gffvzkzwvaTHgTLJHKqJ4Tw@mail.gmail.com>
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

On Wed, Sep 8, 2021 at 3:51 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Sep 08, 2021, Bill Wendling wrote:
> > On Wed, Sep 8, 2021 at 2:49 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Wed, Sep 08, 2021, Bill Wendling wrote:
> > > > exec_in_big_real_mode() uses inline asm that has labels. Clang decides
> > >
> > > _global_ labels.  Inlining functions with local labels, including asm goto labels,
> > > is not problematic, the issue is specific to labels that must be unique for a
> > > given compilation unit.
> > >
> > > > that it can inline this function, which causes the assembler to complain
> > > > about duplicate symbols. Mark the function as "noinline" to prevent
> > > > this.
> > > >
> > > > Signed-off-by: Bill Wendling <morbo@google.com>
> > > > ---
> > > >  x86/realmode.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/x86/realmode.c b/x86/realmode.c
> > > > index b4fa603..07a477f 100644
> > > > --- a/x86/realmode.c
> > > > +++ b/x86/realmode.c
> > > > @@ -178,7 +178,7 @@ static inline void init_inregs(struct regs *regs)
> > > >               inregs.esp = (unsigned long)&tmp_stack.top;
> > > >  }
> > > >
> > > > -static void exec_in_big_real_mode(struct insn_desc *insn)
> > > > +static __attribute__((noinline)) void exec_in_big_real_mode(struct insn_desc *insn)
> > >
> > > Forgot to use the new define in this patch :-)
> > >
> > This was intentional. realmode.c doesn't #include any header files,
> > and adding '#include "libflat.h" causes a lot of warnings and errors.
> > We could do that, but I feel it's beyond the scope of this series of
> > patches.
>
> Ah, right, realmode is compiled for real mode and can't use any of the libcflat
> stuff.
>
> A better option would be to put the #define in linux/compiler.h and include that
> in libcflat.h and directly in realmode.h.  It only requires a small prep patch to
> avoid a duplicate barrier() definition.
>
Sounds good to me. Please go ahead and submit this for inclusion and I
can revamp my stuff.

-bw

> From 6e6971ef22c335732a9597409a45fee8a3be6fb7 Mon Sep 17 00:00:00 2001
> From: Sean Christopherson <seanjc@google.com>
> Date: Wed, 8 Sep 2021 15:41:12 -0700
> Subject: [PATCH] lib: Drop x86/processor.h's barrier() in favor of compiler.h
>  version
>
> Drop x86's duplicate version of barrier() in favor of the generic #define
> provided by linux/compiler.h.  Include compiler.h in the all-encompassing
> libcflat.h to pick up barrier() and other future goodies, e.g. new
> attributes defines.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  lib/libcflat.h      | 1 +
>  lib/x86/processor.h | 5 -----
>  2 files changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/lib/libcflat.h b/lib/libcflat.h
> index 97db9e3..e619de1 100644
> --- a/lib/libcflat.h
> +++ b/lib/libcflat.h
> @@ -22,6 +22,7 @@
>
>  #ifndef __ASSEMBLY__
>
> +#include <linux/compiler.h>
>  #include <stdarg.h>
>  #include <stddef.h>
>  #include <stdint.h>
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index f380321..eaf24d4 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -216,11 +216,6 @@ struct descriptor_table_ptr {
>      ulong base;
>  } __attribute__((packed));
>
> -static inline void barrier(void)
> -{
> -    asm volatile ("" : : : "memory");
> -}
> -
>  static inline void clac(void)
>  {
>      asm volatile (".byte 0x0f, 0x01, 0xca" : : : "memory");
> --
>
> and then your patch 1 can become:
>
> diff --git a/lib/linux/compiler.h b/lib/linux/compiler.h
> index 5d9552a..5937b7b 100644
> --- a/lib/linux/compiler.h
> +++ b/lib/linux/compiler.h
> @@ -46,6 +46,7 @@
>  #define barrier()      asm volatile("" : : : "memory")
>
>  #define __always_inline        inline __attribute__((always_inline))
> +#define noinline __attribute__((noinline))
>
