Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4252DB4E2
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 21:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729552AbgLOUKB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 15:10:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727290AbgLOUJs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 15:09:48 -0500
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F50C06179C;
        Tue, 15 Dec 2020 12:09:08 -0800 (PST)
Received: by mail-qt1-x843.google.com with SMTP id c14so15625530qtn.0;
        Tue, 15 Dec 2020 12:09:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yYo6OawOM+iYHfsWvLFs9OA8sMFU25tBpReHtKNVFkc=;
        b=HdUPaWo/44g1/ab/u/lCxL39OMeOuEcfxPk2Mvo8WlLVWcxbuoK6cKSUhBHQE/lEBC
         k+rJseJhnQYPF2ycS9qtRk1DGTk6MXydkyqwaLMjfQfKtTd1VO5TBGCAYk+HMoemr1Rt
         9436dQFFu84trhmMJWkIQAlTDZy10hFvuqAVymR4AZY4KBD/OxQfKaN/z0zk3hzFbo7T
         a97kUKbl1PlLHbq4k1aw2ra8AyCmvUyr/AW7KWdWBiN1C4M9rJgC9eQrtYl/98Ljq1ns
         mNbNNKaXbHvwSnc0En3eH6kEGNSY0RzKxw8emNfM5a4ePz+MbryiGUzAqFaA45ibysbn
         NpWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yYo6OawOM+iYHfsWvLFs9OA8sMFU25tBpReHtKNVFkc=;
        b=XEBbpJVltgL0smq41vogJe6/apKNy4qd9jjGEybSoJLJV/zM6PfHM7VgqUhyj5YDGl
         dm7Lpn22pRKZRraiTYviQQUvFEBg299nTE/o26AA3Fy6lng/Y24GQ+IFbS9Xca0CQXoJ
         lRHc1wbFN558P6rJzUwzqjPsh0tfK6BYnoTaWPwY9iNcIXFE5MeKmvc1yznRHSTY2Z9M
         IhnM0kJg8tDn8KXmBhqLi1Up5ga7FmMvEMnuPSAz919VlmTW7DjKPZKBNHYkIM4Kml0V
         OOMSm7XhDy70Cc2iyxOdKo7vpL6XahJXPWZrhS+6kYp/bdgnGJkTmz4rUE6KAF/kYAsd
         T54A==
X-Gm-Message-State: AOAM533ASNm/IHnXdu1YVup1IkQuUbo+9bJLmne7lR/r1Qbo98n/aYcu
        uhazxifHZZVehQxUsOejLG5NaIPXH2GjyoZE1qb1sxuGzbEIFQ==
X-Google-Smtp-Source: ABdhPJz4sxgTrJCn4eGeTimwc9LQA2HIbXrpEMvbwBiLFHeZXexeUEe8pnh+l1RC/pFzvKtefXlDfOxGcAKr5BevLUg=
X-Received: by 2002:ac8:3a63:: with SMTP id w90mr38565905qte.225.1608062947366;
 Tue, 15 Dec 2020 12:09:07 -0800 (PST)
MIME-Version: 1.0
References: <20201215182805.53913-1-ubizjak@gmail.com> <20201215182805.53913-3-ubizjak@gmail.com>
In-Reply-To: <20201215182805.53913-3-ubizjak@gmail.com>
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Tue, 15 Dec 2020 21:08:58 +0100
Message-ID: <CAFULd4a5R_8K0LJK=LtbumFL4DWLu7i9eGzGvHoUadP67DFppA@mail.gmail.com>
Subject: Re: [PATCH 2/3] locking/atomic/x86: Introduce arch_try_cmpxchg64()
To:     X86 ML <x86@kernel.org>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 15, 2020 at 7:28 PM Uros Bizjak <ubizjak@gmail.com> wrote:
>
> Add arch_try_cmpxchg64(), similar to arch_try_cmpxchg(), that
> operates with 64 bit operands. This function provides the same
> interface for 32 bit and 64 bit targets.
>
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> ---
>  arch/x86/include/asm/cmpxchg_32.h | 62 ++++++++++++++++++++++++++-----
>  arch/x86/include/asm/cmpxchg_64.h |  6 +++
>  2 files changed, 59 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/include/asm/cmpxchg_32.h b/arch/x86/include/asm/cmpxchg_32.h
> index 0a7fe0321613..8dcde400244e 100644
> --- a/arch/x86/include/asm/cmpxchg_32.h
> +++ b/arch/x86/include/asm/cmpxchg_32.h
> @@ -35,15 +35,6 @@ static inline void set_64bit(volatile u64 *ptr, u64 value)
>                      : "memory");
>  }
>
> -#ifdef CONFIG_X86_CMPXCHG64

Oops, I didn't notice that I had left a reversed #ifdef condition in
the patch (to test 32 bit target without X86_CMPXCHG64).

Obviously, CONFIG_X86_CMPXCHG64 has to be defined to use CMPXCHG8B, so
please use #ifdef here.

Uros.

> -#define arch_cmpxchg64(ptr, o, n)                                      \
> -       ((__typeof__(*(ptr)))__cmpxchg64((ptr), (unsigned long long)(o), \
> -                                        (unsigned long long)(n)))
> -#define arch_cmpxchg64_local(ptr, o, n)                                        \
> -       ((__typeof__(*(ptr)))__cmpxchg64_local((ptr), (unsigned long long)(o), \
> -                                              (unsigned long long)(n)))
> -#endif
> -
>  static inline u64 __cmpxchg64(volatile u64 *ptr, u64 old, u64 new)
>  {
>         u64 prev;
> @@ -71,6 +62,39 @@ static inline u64 __cmpxchg64_local(volatile u64 *ptr, u64 old, u64 new)
>  }
>
>  #ifndef CONFIG_X86_CMPXCHG64
> +#define arch_cmpxchg64(ptr, o, n)                                      \
> +       ((__typeof__(*(ptr)))__cmpxchg64((ptr), (unsigned long long)(o), \
> +                                        (unsigned long long)(n)))
> +#define arch_cmpxchg64_local(ptr, o, n)                                        \
> +       ((__typeof__(*(ptr)))__cmpxchg64_local((ptr), (unsigned long long)(o), \
> +
> +#define __raw_try_cmpxchg64(_ptr, _pold, _new, lock)           \
> +({                                                             \
> +       bool success;                                           \
> +       __typeof__(_ptr) _old = (__typeof__(_ptr))(_pold);      \
> +       __typeof__(*(_ptr)) __old = *_old;                      \
> +       __typeof__(*(_ptr)) __new = (_new);                     \
> +       asm volatile(lock "cmpxchg8b %1"                        \
> +                    CC_SET(z)                                  \
> +                    : CC_OUT(z) (success),                     \
> +                      "+m" (*_ptr),                            \
> +                      "+A" (__old)                             \
> +                    : "b" ((unsigned int)__new),               \
> +                      "c" ((unsigned int)(__new>>32))          \
> +                    : "memory");                               \
> +       if (unlikely(!success))                                 \
> +               *_old = __old;                                  \
> +       likely(success);                                        \
> +})
> +
> +#define __try_cmpxchg64(ptr, pold, new)                                \
> +       __raw_try_cmpxchg64((ptr), (pold), (new), LOCK_PREFIX)
> +
> +#define arch_try_cmpxchg64(ptr, pold, new)                     \
> +       __try_cmpxchg64((ptr), (pold), (new))
> +
> +#else
> +
>  /*
>   * Building a kernel capable running on 80386 and 80486. It may be necessary
>   * to simulate the cmpxchg8b on the 80386 and 80486 CPU.
> @@ -108,6 +132,26 @@ static inline u64 __cmpxchg64_local(volatile u64 *ptr, u64 old, u64 new)
>                        : "memory");                             \
>         __ret; })
>
> +#define arch_try_cmpxchg64(ptr, po, n)                         \
> +({                                                             \
> +       bool success;                                           \
> +       __typeof__(ptr) _old = (__typeof__(ptr))(po);           \
> +       __typeof__(*(ptr)) __old = *_old;                       \
> +       __typeof__(*(ptr)) __new = (n);                         \
> +       alternative_io(LOCK_PREFIX_HERE                         \
> +                       "call cmpxchg8b_emu",                   \
> +                       "lock; cmpxchg8b (%%esi)" ,             \
> +                      X86_FEATURE_CX8,                         \
> +                      "+A" (__old),                            \
> +                      "S" ((ptr)),                             \
> +                      "b" ((unsigned int)__new),               \
> +                      "c" ((unsigned int)(__new>>32))          \
> +                      : "memory");                             \
> +       success = (__old == *_old);                             \
> +       if (unlikely(!success))                                 \
> +               *_old = __old;                                  \
> +       likely(success);                                        \
> +})
>  #endif
>
>  #define system_has_cmpxchg_double() boot_cpu_has(X86_FEATURE_CX8)
> diff --git a/arch/x86/include/asm/cmpxchg_64.h b/arch/x86/include/asm/cmpxchg_64.h
> index 072e5459fe2f..250187ac8248 100644
> --- a/arch/x86/include/asm/cmpxchg_64.h
> +++ b/arch/x86/include/asm/cmpxchg_64.h
> @@ -19,6 +19,12 @@ static inline void set_64bit(volatile u64 *ptr, u64 val)
>         arch_cmpxchg_local((ptr), (o), (n));                            \
>  })
>
> +#define arch_try_cmpxchg64(ptr, po, n)                                 \
> +({                                                                     \
> +       BUILD_BUG_ON(sizeof(*(ptr)) != 8);                              \
> +       arch_try_cmpxchg((ptr), (po), (n));                             \
> +})
> +
>  #define system_has_cmpxchg_double() boot_cpu_has(X86_FEATURE_CX16)
>
>  #endif /* _ASM_X86_CMPXCHG_64_H */
> --
> 2.26.2
>
