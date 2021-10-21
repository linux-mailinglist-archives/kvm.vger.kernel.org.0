Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6600436DF5
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 01:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbhJUXKe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 19:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbhJUXKc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 19:10:32 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8B9C061764
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 16:08:14 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id w14so7058711edv.11
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 16:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q+sDs+17oINsK1vX1YrlwIEC/gKNBj+bVVm47Hsn7NU=;
        b=jnsfyIX30pNxzvocDzD1opG/s0T5dpDbeAyO1WUoXHP6ZJ+CWIqfqInYAa6rk0++9u
         rFb98GuG+FTV67sdl6/eqKVzHBnehuYhrxs4HEhVfkseILOX1ET1uq+0EDfdkKmDSlE/
         aY72usY5y08lwTBoWsp2P/qbKodt/hNo159nMInuO4g9kf6IDoZ/9eDobdnbF7K5wO6K
         RjEplyIxPB1IcPlUTB5yikWUkTdYnm+ZOiwb9wgWcApRAFTqskEcFmOl9QKVxd9zmmMi
         0oowYXERSCH2G1HgHTXJ6H6n2ZOplJbatxN5P4BrekYAm+lnRGLQZNtIv3DEwZjC/IvT
         mR6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q+sDs+17oINsK1vX1YrlwIEC/gKNBj+bVVm47Hsn7NU=;
        b=PGcdfZ9hUWm36ZZnr4wBMNhvVgDyxF2qKd8EtaGgV2QP0GPSKksAidLIlPpaQSRDRM
         r4JYChgqavsVsKWXzN3AyY81R7AZbyVsYQfRoMN6O3MPu/jFzBiBHMGU0/V6xCVFqsRV
         jTIaGUrVXRVpHiuMCrk/D+RgmPA4J6BsJ/loTgw0bvg24PbCKd+2jaXTRkPRw+zaiRHy
         dOKoU8KK95CytWDK1/H16iRLvsufl+tkSOs/7eTlcampT//v1q7XQwqp9Q6Kh9c8i4yo
         moxHVcZQiADvYQH7UeJGqvpFQqKSj9W7WngYg/r3tBenzqtWLI7aZvgwXxJiJzM894BD
         A6Aw==
X-Gm-Message-State: AOAM5336bGCdoZG9o4nFE0FVh545A8ordJUINTZGzOSpAhLsy21xKBWr
        YYcKErzeIxT5q7LvfCw/3i7xpSfnpe0CTWi7H52SbQ==
X-Google-Smtp-Source: ABdhPJxg52yl7R6k03l1Z+ooWi1wOOP8zq4jojiesTJBmKaH/1ULhJY0inX8iXGRhBhH8om+CBafBwF9Z1yVwvQR3yw=
X-Received: by 2002:a17:906:5950:: with SMTP id g16mr10943296ejr.149.1634857693017;
 Thu, 21 Oct 2021 16:08:13 -0700 (PDT)
MIME-Version: 1.0
References: <20211021114910.1347278-1-pbonzini@redhat.com> <20211021114910.1347278-8-pbonzini@redhat.com>
In-Reply-To: <20211021114910.1347278-8-pbonzini@redhat.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Thu, 21 Oct 2021 23:08:01 +0000
Message-ID: <CAAAPnDHGEJP8Ss2M3KxVHT=MnHrbb-3=RAdpQVXzKyx9KWpRvw@mail.gmail.com>
Subject: Re: [PATCH kvm-unit-tests 7/9] x86: get rid of ring0stacktop
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, jmattson@google.com, zxwang42@gmail.com,
        marcorr@google.com, seanjc@google.com, jroedel@suse.de,
        varad.gautam@suse.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> --- a/lib/x86/usermode.c
> +++ b/lib/x86/usermode.c
> @@ -47,8 +47,8 @@ uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
>         }
>
>         asm volatile (
> -                       /* Backing Up Stack in rdi */
> -                       "mov %%rsp, %%rdi\n\t"
> +                       /* Prepare kernel SP for exception handlers */
> +                       "mov %%rsp, %[rsp0]\n\t"
>                         /* Load user_ds to DS and ES */
>                         "mov %[user_ds], %%ax\n\t"
>                         "mov %%ax, %%ds\n\t"
> @@ -92,9 +92,10 @@ uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
>                         "int %[kernel_entry_vector]\n\t"
>                         /* Kernel Mode */
>                         "ret_to_kernel:\n\t"
> -                       "mov %%rdi, %%rsp\n\t"
> +                       "mov %[rsp0], %%rsp\n\t"
>                         :
> -                       "+a"(rax)
> +                       "+a"(rax),
> +                       [rsp0]"=m"(tss.rsp0),
>                         :

The compiler didn't like the comma:
-                       [rsp0]"=m"(tss.rsp0),
+                       [rsp0]"=m"(tss.rsp0)

>                         [arg1]"m"(arg1),
>                         [arg2]"m"(arg2),

> --- a/x86/umip.c
> +++ b/x86/umip.c
> @@ -124,7 +124,7 @@ static noinline int do_ring3(void (*fn)(const char *), const char *arg)
>                   "mov %%dx, %%es\n\t"
>                   "mov %%dx, %%fs\n\t"
>                   "mov %%dx, %%gs\n\t"
> -                 "mov %%" R "sp, %%" R "cx\n\t"
> +                 "mov %%" R "sp, %[sp0]\n\t" /* kernel sp for exception handlers */
>                   "push" W " %%" R "dx \n\t"
>                   "lea %[user_stack_top], %%" R "dx \n\t"
>                   "push" W " %%" R "dx \n\t"
> @@ -133,8 +133,6 @@ static noinline int do_ring3(void (*fn)(const char *), const char *arg)
>                   "push" W " $1f \n\t"
>                   "iret" W "\n"
>                   "1: \n\t"
> -                 "push %%" R "cx\n\t"   /* save kernel SP */
> -
>  #ifndef __x86_64__
>                   "push %[arg]\n\t"
>  #endif
> @@ -142,13 +140,15 @@ static noinline int do_ring3(void (*fn)(const char *), const char *arg)
>  #ifndef __x86_64__
>                   "pop %%ecx\n\t"
>  #endif
> -
> -                 "pop %%" R "cx\n\t"
>                   "mov $1f, %%" R "dx\n\t"
>                   "int %[kernel_entry_vector]\n\t"
>                   ".section .text.entry \n\t"
>                   "kernel_entry: \n\t"
> -                 "mov %%" R "cx, %%" R "sp \n\t"
> +#ifdef __x86_64__
> +                 "mov %[sp0], %%" R "sp\n\t"
> +#else
> +                 "add $(5 * " S "), %%esp\n\t"
> +#endif
>                   "mov %[kernel_ds], %%cx\n\t"
>                   "mov %%cx, %%ds\n\t"
>                   "mov %%cx, %%es\n\t"
> @@ -157,7 +157,12 @@ static noinline int do_ring3(void (*fn)(const char *), const char *arg)
>                   "jmp *%%" R "dx \n\t"
>                   ".section .text\n\t"
>                   "1:\n\t"
> -                 : [ret] "=&a" (ret)
> +                 : [ret] "=&a" (ret),
> +#ifdef __x86_64__
> +                   [sp0] "=m" (tss.rsp0),
> +#else
> +                   [sp0] "=m" (tss.esp0),
> +#endif
>                   : [user_ds] "i" (USER_DS),

Same here:
-                   [sp0] "=m" (tss.rsp0),
-                   [sp0] "=m" (tss.esp0),
+                   [sp0] "=m" (tss.rsp0)
+                   [sp0] "=m" (tss.esp0)

>                     [user_cs] "i" (USER_CS),
>                     [user_stack_top]"m"(user_stack[sizeof(user_stack) -
> --
> 2.27.0
>
>
