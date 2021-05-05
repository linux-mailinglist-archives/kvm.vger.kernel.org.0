Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 441AA3748D6
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 21:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbhEETrg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 15:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232642AbhEETrf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 15:47:35 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 885D9C061574
        for <kvm@vger.kernel.org>; Wed,  5 May 2021 12:46:38 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id w3so4699445ejc.4
        for <kvm@vger.kernel.org>; Wed, 05 May 2021 12:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9YKks1MIWR6n/3YFjtLH/pKCp7CerCnDCGt2HK7yw0w=;
        b=kAeglYP6Ii6YuQfFNZgv3tvriwCuyxwYflp1i9Sc4vSOeqKyafSPlR/5+ze5NVA4vP
         Zo/1F0tKsdqOuYoajAWkR28t+WeSNN/4qmnm1/nZM/jCjr6sP8ah6FCjw9jX+V6dcfIK
         bc6bKY5VRk4Sa+ucKs2vUFLNZHPFMqjBO6KqncOWByNL71wBKOaaOLCzLFlwf5rvxnKa
         Npl6JwbYu0aWBaAQ63mYXl5WcgHUWqxif3egbESFWdwwO2xUJA7mA3Ldr4HoeXW6F3ps
         xXnPLEDADU2QTVLbgAyCAanDQslXPC9Zo+kH7t/4fVHr136dsIvc02t/kCTSq+WzXx97
         itNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9YKks1MIWR6n/3YFjtLH/pKCp7CerCnDCGt2HK7yw0w=;
        b=NvwE5fTwnrK+kAxPoTjf/n83mnJghwV9udYOvIoMAsWHtKImDj4/8eMw8nqNcW6MFn
         eLZDF2IsqRAUvQ+NqafwkovmWOUFSArF/h4N/CB605phFA3O7NgaITlZ3gyu5ujriEUm
         GYpVQ+jspCPi7IJ+16xVdP5/SMusHBnWGuiIbwrmQWwoHW4dXCkEfn71SITsIh2r3hmT
         UH9gYlWg4GQ2hpC745OUddAyn3ir0n4M0m/izcne+DMGRLch9Adqc3p7TnZXkjrz13jp
         pvS/FfsFEMeT+/T6dLACXVBk8yqmgBzWTx0AdK0x8pXI69GpeKrn9oKo5XEkd55KC1pY
         cD6w==
X-Gm-Message-State: AOAM532x5W2r0c0nyE3YERwPeSiI0MuFozJOJ1XsGYSSDik2+Fu586QH
        exLCP0olaBiV8sS30Jdi4vsmrQ0mImu2+En/nAcx
X-Google-Smtp-Source: ABdhPJw7nY50mjeODI10q+kOLlgygBWSsrS7HTcMd9YAV31Yq8kVm15ispKizTi3kwHqBgyTAdR3l2hDYjvcrg6n6Ow=
X-Received: by 2002:a17:906:1fd1:: with SMTP id e17mr396765ejt.419.1620243996946;
 Wed, 05 May 2021 12:46:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210505131412.654238-1-pbonzini@redhat.com> <941e5f21-7d0b-2e67-21d1-3c425a43f489@redhat.com>
In-Reply-To: <941e5f21-7d0b-2e67-21d1-3c425a43f489@redhat.com>
From:   Bill Wendling <morbo@google.com>
Date:   Wed, 5 May 2021 12:46:25 -0700
Message-ID: <CAGG=3QX82NZqPcQEaf1zXOwqw60MTBNjD6WHVPMCLUfjKuDmdw@mail.gmail.com>
Subject: Re: [PATCH kvm-unit-tests] libcflat: provide long division routines
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 5, 2021 at 6:16 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 05/05/21 15:14, Paolo Bonzini wrote:
> > The -nostdlib flag disables the driver from adding libclang_rt.*.a
> > during linking. Adding a specific library to the command line such as
> > libgcc then causes the linker to report unresolved symbols, because the
> > libraries that resolve those symbols aren't automatically added.
> >
> > libgcc however is only needed for long division (64-bit by 64-bit).
> > Instead of linking the whole of it, implement the routines that are
> > needed.
> >
> > Reported-by: Bill Wendling <morbo@google.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>
Thanks, Paolo!

-bw

> Oops, I didn't actually remove libgcc!
>
> diff --git a/Makefile b/Makefile
> index 24b7917..ddebcae 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -25,8 +25,6 @@ cc-option = $(shell if $(CC) -Werror $(1) -S -o /dev/null -xc /dev/null \
>   #make sure env CFLAGS variable is not used
>   CFLAGS =
>
> -libgcc := $(shell $(CC) --print-libgcc-file-name)
> -
>   libcflat := lib/libcflat.a
>   cflatobjs := \
>         lib/argv.o \
> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index 55478ec..38385e0 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -58,9 +58,7 @@ OBJDIRS += lib/arm
>   libeabi = lib/arm/libeabi.a
>   eabiobjs = lib/arm/eabi_compat.o
>
> -libgcc := $(shell $(CC) $(machine) --print-libgcc-file-name)
> -
> -FLATLIBS = $(libcflat) $(LIBFDT_archive) $(libgcc) $(libeabi)
> +FLATLIBS = $(libcflat) $(LIBFDT_archive) $(libeabi)
>   %.elf: LDFLAGS = -nostdlib $(arch_LDFLAGS)
>   %.elf: %.o $(FLATLIBS) $(SRCDIR)/arm/flat.lds $(cstart.o)
>         $(CC) $(CFLAGS) -c -o $(@:.elf=.aux.o) $(SRCDIR)/lib/auxinfo.c \
> diff --git a/x86/Makefile.common b/x86/Makefile.common
> index 55f7f28..52bb7aa 100644
> --- a/x86/Makefile.common
> +++ b/x86/Makefile.common
> @@ -37,12 +37,10 @@ COMMON_CFLAGS += -O1
>   # stack.o relies on frame pointers.
>   KEEP_FRAME_POINTER := y
>
> -libgcc := $(shell $(CC) -m$(bits) --print-libgcc-file-name)
> -
>   # We want to keep intermediate file: %.elf and %.o
>   .PRECIOUS: %.elf %.o
>
> -FLATLIBS = lib/libcflat.a $(libgcc)
> +FLATLIBS = lib/libcflat.a
>   %.elf: %.o $(FLATLIBS) $(SRCDIR)/x86/flat.lds $(cstart.o)
>         $(CC) $(CFLAGS) -nostdlib -o $@ -Wl,-T,$(SRCDIR)/x86/flat.lds \
>                 $(filter %.o, $^) $(FLATLIBS)
>
>
> > ---
> >   arm/Makefile.arm  |   1 +
> >   lib/ldiv32.c      | 105 ++++++++++++++++++++++++++++++++++++++++++++++
> >   x86/Makefile.i386 |   2 +-
> >   3 files changed, 107 insertions(+), 1 deletion(-)
> >   create mode 100644 lib/ldiv32.c
> >
> > diff --git a/arm/Makefile.arm b/arm/Makefile.arm
> > index d379a28..687a8ed 100644
> > --- a/arm/Makefile.arm
> > +++ b/arm/Makefile.arm
> > @@ -23,6 +23,7 @@ cstart.o = $(TEST_DIR)/cstart.o
> >   cflatobjs += lib/arm/spinlock.o
> >   cflatobjs += lib/arm/processor.o
> >   cflatobjs += lib/arm/stack.o
> > +cflatobjs += lib/ldiv32.o
> >
> >   # arm specific tests
> >   tests =
> > diff --git a/lib/ldiv32.c b/lib/ldiv32.c
> > new file mode 100644
> > index 0000000..e9d434f
> > --- /dev/null
> > +++ b/lib/ldiv32.c
> > @@ -0,0 +1,105 @@
> > +#include <inttypes.h>
> > +
> > +extern uint64_t __udivmoddi4(uint64_t num, uint64_t den, uint64_t *p_rem);
> > +extern int64_t __moddi3(int64_t num, int64_t den);
> > +extern int64_t __divdi3(int64_t num, int64_t den);
> > +extern uint64_t __udivdi3(uint64_t num, uint64_t den);
> > +extern uint64_t __umoddi3(uint64_t num, uint64_t den);
> > +
> > +uint64_t __udivmoddi4(uint64_t num, uint64_t den, uint64_t *p_rem)
> > +{
> > +     uint64_t quot = 0;
> > +
> > +     /* Trigger a division by zero at run time (trick taken from iPXE).  */
> > +     if (den == 0)
> > +             return 1/((unsigned)den);
> > +
> > +     if (num >= den) {
> > +             /* Align den to num to avoid wasting time on leftmost zero bits.  */
> > +             int n = __builtin_clzll(den) - __builtin_clzll(num);
> > +             den <<= n;
> > +
> > +             do {
> > +                     quot <<= 1;
> > +                     if (num >= den) {
> > +                             num -= den;
> > +                             quot |= 1;
> > +                     }
> > +                     den >>= 1;
> > +             } while (n--);
> > +     }
> > +
> > +     if (p_rem)
> > +             *p_rem = num;
> > +
> > +     return quot;
> > +}
> > +
> > +int64_t __moddi3(int64_t num, int64_t den)
> > +{
> > +     uint64_t mask = num < 0 ? -1 : 0;
> > +
> > +     /* Compute absolute values and do an unsigned division.  */
> > +     num = (num + mask) ^ mask;
> > +     if (den < 0)
> > +             den = -den;
> > +
> > +     /* Copy sign of num into result.  */
> > +     return (__umoddi3(num, den) + mask) ^ mask;
> > +}
> > +
> > +int64_t __divdi3(int64_t num, int64_t den)
> > +{
> > +     uint64_t mask = (num ^ den) < 0 ? -1 : 0;
> > +
> > +     /* Compute absolute values and do an unsigned division.  */
> > +     if (num < 0)
> > +             num = -num;
> > +     if (den < 0)
> > +             den = -den;
> > +
> > +     /* Copy sign of num^den into result.  */
> > +     return (__udivdi3(num, den) + mask) ^ mask;
> > +}
> > +
> > +uint64_t __udivdi3(uint64_t num, uint64_t den)
> > +{
> > +     uint64_t rem;
> > +     return __udivmoddi4(num, den, &rem);
> > +}
> > +
> > +uint64_t __umoddi3(uint64_t num, uint64_t den)
> > +{
> > +     uint64_t rem;
> > +     __udivmoddi4(num, den, &rem);
> > +     return rem;
> > +}
> > +
> > +#ifdef TEST
> > +#include <assert.h>
> > +#define UTEST(a, b, q, r) assert(__udivdi3(a, b) == q && __umoddi3(a, b) == r)
> > +#define STEST(a, b, q, r) assert(__divdi3(a, b) == q && __moddi3(a, b) == r)
> > +int main()
> > +{
> > +     UTEST(1, 1, 1, 0);
> > +     UTEST(2, 2, 1, 0);
> > +     UTEST(5, 3, 1, 2);
> > +     UTEST(10, 3, 3, 1);
> > +     UTEST(120, 3, 40, 0);
> > +     UTEST(120, 1, 120, 0);
> > +     UTEST(0x7FFFFFFFFFFFFFFFULL, 17, 0x787878787878787, 8);
> > +     UTEST(0x7FFFFFFFFFFFFFFFULL, 0x787878787878787, 17, 8);
> > +     UTEST(0x8000000000000001ULL, 17, 0x787878787878787, 10);
> > +     UTEST(0x8000000000000001ULL, 0x787878787878787, 17, 10);
> > +     UTEST(0, 5, 0, 0);
> > +
> > +     STEST(0x7FFFFFFFFFFFFFFFULL, 17, 0x787878787878787, 8);
> > +     STEST(0x7FFFFFFFFFFFFFFFULL, -17, -0x787878787878787, 8);
> > +     STEST(-0x7FFFFFFFFFFFFFFFULL, 17, -0x787878787878787, -8);
> > +     STEST(-0x7FFFFFFFFFFFFFFFULL, -17, 0x787878787878787, -8);
> > +     STEST(33, 5, 6, 3);
> > +     STEST(33, -5, -6, 3);
> > +     STEST(-33, 5, -6, -3);
> > +     STEST(-33, -5, 6, -3);
> > +}
> > +#endif
> > diff --git a/x86/Makefile.i386 b/x86/Makefile.i386
> > index c04e5aa..960e274 100644
> > --- a/x86/Makefile.i386
> > +++ b/x86/Makefile.i386
> > @@ -3,7 +3,7 @@ bits = 32
> >   ldarch = elf32-i386
> >   COMMON_CFLAGS += -mno-sse -mno-sse2
> >
> > -cflatobjs += lib/x86/setjmp32.o
> > +cflatobjs += lib/x86/setjmp32.o lib/ldiv32.o
> >
> >   tests = $(TEST_DIR)/taskswitch.flat $(TEST_DIR)/taskswitch2.flat \
> >       $(TEST_DIR)/cmpxchg8b.flat $(TEST_DIR)/la57.flat
> >
>
