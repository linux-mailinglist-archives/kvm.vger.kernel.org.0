Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715CD40412F
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 00:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235919AbhIHWwg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 18:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbhIHWwg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 18:52:36 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B895C061575
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 15:51:27 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id n4so2204477plh.9
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 15:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eUB62fjPCFMtNymQZxkMA7y7jsbDXMNViD9zJv4QRm0=;
        b=ADUpDQ/PQsR9HEykYYtYM3CoDCHDKuuuPxwEdT/VIW+O8h6c5bZF8/1+KFLuBnkQPC
         ki3/7kBFViIgBlOTxAj/h+JE92trV7lyf+CmNka/SqNKdGcvrTNL6Dl1KK2NII4Iz8D9
         n9mNMzkdL/ieHHBJ6WzQiCjbEKhJjEk65Qcq1II/HKjD+SqP2pUsCLMZPMkUSsghe9Y2
         giW2AspXGzTyoF2zilFFiE7rC0TcV1rT4PWDyAwGrpvgmvT9r+M1oXcZ1zJuW55tQhov
         +V9YZXHTJEajUxkyRJnBQmWMfLnlasO3JPKBHfyBuZWXXq0MkTaDdN1HG7bXcUosEoNr
         YGPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eUB62fjPCFMtNymQZxkMA7y7jsbDXMNViD9zJv4QRm0=;
        b=sN0vsNIK4OeIJtud1i/oq5KTICDEMoT9ZpnRqnDQ9GeUbxnIWwhgAvmdK8HUbVJ69Z
         46CSEm7xEnz82zCGCk4ia4rRJ7RL5cii4726WYCFEx2AKRM/MTYjbRcnNz1wl0H4z75z
         6B8tnUlOAVMIu/geZTPMWbh/V1RG9xd8mapKF0VyK77Ph1CRXvpNdbBl5CRQMDF+BGyk
         gbqGgVQSBygoLSQcBNt3vvpo1ffckIoo38Yj1pLH/s0RURMuY6DL+Gq8lJCwL+zQKUB5
         Wh+2kQl3kEe4DXswG8/OQbbu5q2a9rApsRdQAdqbKSTyA0llBW/R+wylLzEiqBJFyTRz
         O28A==
X-Gm-Message-State: AOAM532RZlNYI1DjWFZ/eGvtpkNXsli7s/Xtsbr13ETy5wtyG9925COZ
        8RHmez9YttWNDmd7MNshYAjwfQ==
X-Google-Smtp-Source: ABdhPJxmcCqb2XL61nu/JMLD+W87FswO/NVpZ5oznHRsQLON+MYQ8LM093hC+fF93ocDI9HzLmlCFw==
X-Received: by 2002:a17:90a:1982:: with SMTP id 2mr6615541pji.112.1631141486679;
        Wed, 08 Sep 2021 15:51:26 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s9sm206678pfu.129.2021.09.08.15.51.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 15:51:26 -0700 (PDT)
Date:   Wed, 8 Sep 2021 22:51:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Bill Wendling <morbo@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [kvm-unit-tests PATCH v2 2/5] x86: realmode: mark
 exec_in_big_real_mode as noinline
Message-ID: <YTk+amslyQCsM3+M@google.com>
References: <20210825222604.2659360-1-morbo@google.com>
 <20210908204541.3632269-1-morbo@google.com>
 <20210908204541.3632269-3-morbo@google.com>
 <YTkv6HXYEGnDe56h@google.com>
 <CAGG=3QX1L1dsFHhQhiEHPRycm8ot2Abw1j=wR60ezVoKgU0KmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGG=3QX1L1dsFHhQhiEHPRycm8ot2Abw1j=wR60ezVoKgU0KmQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 08, 2021, Bill Wendling wrote:
> On Wed, Sep 8, 2021 at 2:49 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Wed, Sep 08, 2021, Bill Wendling wrote:
> > > exec_in_big_real_mode() uses inline asm that has labels. Clang decides
> >
> > _global_ labels.  Inlining functions with local labels, including asm goto labels,
> > is not problematic, the issue is specific to labels that must be unique for a
> > given compilation unit.
> >
> > > that it can inline this function, which causes the assembler to complain
> > > about duplicate symbols. Mark the function as "noinline" to prevent
> > > this.
> > >
> > > Signed-off-by: Bill Wendling <morbo@google.com>
> > > ---
> > >  x86/realmode.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/x86/realmode.c b/x86/realmode.c
> > > index b4fa603..07a477f 100644
> > > --- a/x86/realmode.c
> > > +++ b/x86/realmode.c
> > > @@ -178,7 +178,7 @@ static inline void init_inregs(struct regs *regs)
> > >               inregs.esp = (unsigned long)&tmp_stack.top;
> > >  }
> > >
> > > -static void exec_in_big_real_mode(struct insn_desc *insn)
> > > +static __attribute__((noinline)) void exec_in_big_real_mode(struct insn_desc *insn)
> >
> > Forgot to use the new define in this patch :-)
> >
> This was intentional. realmode.c doesn't #include any header files,
> and adding '#include "libflat.h" causes a lot of warnings and errors.
> We could do that, but I feel it's beyond the scope of this series of
> patches.

Ah, right, realmode is compiled for real mode and can't use any of the libcflat
stuff.

A better option would be to put the #define in linux/compiler.h and include that
in libcflat.h and directly in realmode.h.  It only requires a small prep patch to
avoid a duplicate barrier() definition.

From 6e6971ef22c335732a9597409a45fee8a3be6fb7 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 8 Sep 2021 15:41:12 -0700
Subject: [PATCH] lib: Drop x86/processor.h's barrier() in favor of compiler.h
 version

Drop x86's duplicate version of barrier() in favor of the generic #define
provided by linux/compiler.h.  Include compiler.h in the all-encompassing
libcflat.h to pick up barrier() and other future goodies, e.g. new
attributes defines.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/libcflat.h      | 1 +
 lib/x86/processor.h | 5 -----
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/lib/libcflat.h b/lib/libcflat.h
index 97db9e3..e619de1 100644
--- a/lib/libcflat.h
+++ b/lib/libcflat.h
@@ -22,6 +22,7 @@

 #ifndef __ASSEMBLY__

+#include <linux/compiler.h>
 #include <stdarg.h>
 #include <stddef.h>
 #include <stdint.h>
diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index f380321..eaf24d4 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -216,11 +216,6 @@ struct descriptor_table_ptr {
     ulong base;
 } __attribute__((packed));

-static inline void barrier(void)
-{
-    asm volatile ("" : : : "memory");
-}
-
 static inline void clac(void)
 {
     asm volatile (".byte 0x0f, 0x01, 0xca" : : : "memory");
--

and then your patch 1 can become:

diff --git a/lib/linux/compiler.h b/lib/linux/compiler.h
index 5d9552a..5937b7b 100644
--- a/lib/linux/compiler.h
+++ b/lib/linux/compiler.h
@@ -46,6 +46,7 @@
 #define barrier()      asm volatile("" : : : "memory")

 #define __always_inline        inline __attribute__((always_inline))
+#define noinline __attribute__((noinline))

