Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE20E36CDC0
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 23:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237055AbhD0VQb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 17:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236965AbhD0VQa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 17:16:30 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF8FC061574
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 14:15:46 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id i3so45964162edt.1
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 14:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KjKAsb4G8TL0ol4SRQit/BMD/Sr8mtKntpyCFUbKr94=;
        b=HMZ+pxK0o6EdaBnD+V+E9N/Mawmh+v/mbYODS7DVQcPiNqU4SkxU35nImij+ex55F8
         QcOsMUrumgUV581ugOiAptctCihm0S7ATq5R/Vila2Ytv5piXIcnp5m4Za+dwRXCrg/N
         KJ9J7Zwqg+dUDikbK5dXV9iVSJME5OJJJIgtR35Kz6Uw+n+ZPjdAIZYdRBTR+E3joPjN
         L9ejgMaoAEknf6+r51EZve93cKAb2SK38ox7KiAlpXg/ETJIBAqKw1Ym28BqCMRILngn
         +6AVzzG5Q9fQIGQBW/4cv/NbT2ZhYGAw/i87BSuXogYQAWV5Pya56rbgA/y8/piiuupq
         Q5/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KjKAsb4G8TL0ol4SRQit/BMD/Sr8mtKntpyCFUbKr94=;
        b=hWP8sMOzVgaqhXCU/HnYvJR2PiPtwC3FvLFdGsFvvrklgsOEoLRW8AFzdhWCZqGe4u
         LaIrNcZb/584kK45vEI0bdyh1L+28gl63Rb0YIqqSezT8yYsw+B/RpgfYJzSBlUV/dma
         4jzCsiWfu3kAQH0h6uhXe6ScvDuKEed2lE6dljlah3XkdldDRAsfepuVpe6kWxWgeQuv
         GNXXRPvseOA93JMTf5hnUohp3RmYGGzkIkFh/94XOvmsl7NaKsc8u/mU7OgTPbn3vg7a
         YIPi9sQXUbjBxX1kuFEKR8BpEqmfnm7N0XQLkJESZGgQ7+lwC4k5VBhwTsOU3kP8DDki
         HGiw==
X-Gm-Message-State: AOAM533oDByGAiF2mq0xcOFDh2VImNYR5jThso3yvY899qLchmWvY/7N
        gIUhMGV9UDbCoIlSEwJKS6VYOLHbwPsIsVm5Gc4b5I8IKbC1
X-Google-Smtp-Source: ABdhPJwwQsrz//4XD2vnKLu5roFhRqir4u8BZB4HhDQJTUYzabBHV0Zmq7bHGPnYJhGST19HKLCcNOSrfBCVjHueL4E=
X-Received: by 2002:aa7:c7da:: with SMTP id o26mr6804672eds.244.1619558145094;
 Tue, 27 Apr 2021 14:15:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210309045250.3333311-1-morbo@google.com>
In-Reply-To: <20210309045250.3333311-1-morbo@google.com>
From:   Bill Wendling <morbo@google.com>
Date:   Tue, 27 Apr 2021 14:15:34 -0700
Message-ID: <CAGG=3QWRS6q3g=AqbgPWDh4uuK3fS_Vw2MK9OXo618P+Y6n-WA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] Makefile: do not use "libgcc" for clang
To:     kvm list <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping.

On Mon, Mar 8, 2021 at 8:53 PM Bill Wendling <morbo@google.com> wrote:
>
> The -nostdlib flag disables the driver from adding libclang_rt.*.a
> during linking. Adding a specific library to the command line then
> causes the linker to report unresolved symbols, because the libraries
> that resolve those symbols aren't automatically added. Turns out clang
> doesn't need to specify that library.
>
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>  Makefile            | 6 ++++++
>  arm/Makefile.common | 2 ++
>  x86/Makefile.common | 2 ++
>  3 files changed, 10 insertions(+)
>
> diff --git a/Makefile b/Makefile
> index e0828fe..61a1276 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -22,10 +22,16 @@ DESTDIR := $(PREFIX)/share/kvm-unit-tests/
>  cc-option = $(shell if $(CC) -Werror $(1) -S -o /dev/null -xc /dev/null \
>                > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)
>
> +# cc-name
> +# Expands to either gcc or clang
> +cc-name = $(shell $(CC) -v 2>&1 | grep -q "clang version" && echo clang || echo gcc)
> +
>  #make sure env CFLAGS variable is not used
>  CFLAGS =
>
> +ifneq ($(cc-name),clang)
>  libgcc := $(shell $(CC) --print-libgcc-file-name)
> +endif
>
>  libcflat := lib/libcflat.a
>  cflatobjs := \
> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index a123e85..94922aa 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -58,7 +58,9 @@ OBJDIRS += lib/arm
>  libeabi = lib/arm/libeabi.a
>  eabiobjs = lib/arm/eabi_compat.o
>
> +ifneq ($(cc-name),clang)
>  libgcc := $(shell $(CC) $(machine) --print-libgcc-file-name)
> +endif
>
>  FLATLIBS = $(libcflat) $(LIBFDT_archive) $(libgcc) $(libeabi)
>  %.elf: LDFLAGS = -nostdlib $(arch_LDFLAGS)
> diff --git a/x86/Makefile.common b/x86/Makefile.common
> index 55f7f28..a96b236 100644
> --- a/x86/Makefile.common
> +++ b/x86/Makefile.common
> @@ -37,7 +37,9 @@ COMMON_CFLAGS += -O1
>  # stack.o relies on frame pointers.
>  KEEP_FRAME_POINTER := y
>
> +ifneq ($(cc-name),clang)
>  libgcc := $(shell $(CC) -m$(bits) --print-libgcc-file-name)
> +endif
>
>  # We want to keep intermediate file: %.elf and %.o
>  .PRECIOUS: %.elf %.o
> --
> 2.30.1.766.gb4fecdf3b7-goog
>
