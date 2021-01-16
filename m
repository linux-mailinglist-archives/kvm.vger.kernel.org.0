Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 126D92F8DC9
	for <lists+kvm@lfdr.de>; Sat, 16 Jan 2021 18:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbhAPRJm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 Jan 2021 12:09:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727944AbhAPRJe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 Jan 2021 12:09:34 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F6EC0617AB
        for <kvm@vger.kernel.org>; Sat, 16 Jan 2021 06:17:05 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id k4so7970601ybp.6
        for <kvm@vger.kernel.org>; Sat, 16 Jan 2021 06:17:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AhGK/6XQsnDXFD6m51WpGMESDPE8+NDGrsD4blt+WV4=;
        b=FZn6u53vlElyMCljU2RqtTC0wqPJ0rL6XTJSshrojIR62xkNhz47HvANPnH2fP70iH
         wz6uoiCou3crMOBI6SNOhsl2Z50AAW5kNM5gmPi3czthENwKrRbiNa65YKzDN29NY6Yf
         HTWwYIRJkJjkq3/uFs/t5vHaPT1tvhdiE79MCCwVcG+3J6UVdBpNs3tUT7VmqxFkBmTq
         gDWNN9O4h3cSC+yF9eCbkdVmcEaJSZgvW45e19iA4Snpz7iJDDZwm8jh+LElnBUI13tq
         vwT4TrhoMIMhuAmlS12m3+bJj+lQBH2xttWqdmD4IWddoOEFli+JFm6uKqQs5+15OMad
         oYUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AhGK/6XQsnDXFD6m51WpGMESDPE8+NDGrsD4blt+WV4=;
        b=X1SpbKxffnWD52qtjWSqAMTFf5JS6x0qT0ToCoZ106Elq5KYHuMMZOdnkx/H5oaL48
         QB2eTIzewrTjGBZOg9da8zExtGuBudo6AyaIuoypDaKVlEnvcALhcYG61jrV6PhrV8qB
         eMnu0pkXy34yk+3hMQD7AgHblekANd9Y99Qf8NERqUTz6t8lEvvb9rtv18OJjd08ewCQ
         n0D/oR7u+h0GwzJE2+PjDYPZVFj7wtGa2QOnXdIx2uglyIh01nc0goEOT22FeRUfX3kn
         GCosMz+Qh66zRizVEoQs4vCW1Rlvq5hfk9mnxrJeB8fFNUrJClG5w49DIlmqVxRuo4hM
         o6GQ==
X-Gm-Message-State: AOAM5307ds1IhhVpT7eEI74rYaZ2EKnN7c+3SmPM3oR39aoEmpmdVdBE
        R9nN3IZ5zrLaC8dTbGx9ZNQPnAx9QfUHvXy8kX+ouKzUxM4=
X-Google-Smtp-Source: ABdhPJwUTfgLPskdO2ytBdIyorFheZbKeXJkZikB8msfdK3+x4ZMMf7jE6UOjEwAdHKOFLbgRiJrK0qBlMxdDQZ0tZ8=
X-Received: by 2002:a25:3bc5:: with SMTP id i188mr24905481yba.332.1610806624728;
 Sat, 16 Jan 2021 06:17:04 -0800 (PST)
MIME-Version: 1.0
References: <1606206780-80123-1-git-send-email-bmeng.cn@gmail.com> <be7005bb-94f8-4a3f-8e51-de1e21499683@redhat.com>
In-Reply-To: <be7005bb-94f8-4a3f-8e51-de1e21499683@redhat.com>
From:   Bin Meng <bmeng.cn@gmail.com>
Date:   Sat, 16 Jan 2021 22:16:51 +0800
Message-ID: <CAEUhbmUVBCNh8DiPusqSm20vRsvMRBDj2Rqu+QOyg3shTSPAug@mail.gmail.com>
Subject: Re: [kvm-unit-tests][RFC PATCH] x86: Add a new test case for ret/iret
 with a nullified segment
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Bin Meng <bin.meng@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On Tue, Nov 24, 2020 at 5:12 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 24/11/20 09:33, Bin Meng wrote:
> > From: Bin Meng <bin.meng@windriver.com>
> >
> > This makes up the test case for the following QEMU patch:
> > http://patchwork.ozlabs.org/project/qemu-devel/patch/1605261378-77971-1-git-send-email-bmeng.cn@gmail.com/
> >
> > Note the test case only fails on an unpatched QEMU with "accel=tcg".
> >
> > Signed-off-by: Bin Meng <bin.meng@windriver.com>
> > ---
> > Sending this as RFC since I am new to kvm-unit-tests
> >
> >   x86/emulator.c | 38 ++++++++++++++++++++++++++++++++++++++
> >   1 file changed, 38 insertions(+)
> >
> > diff --git a/x86/emulator.c b/x86/emulator.c
> > index e46d97e..6100b6d 100644
> > --- a/x86/emulator.c
> > +++ b/x86/emulator.c
> > @@ -6,10 +6,14 @@
> >   #include "processor.h"
> >   #include "vmalloc.h"
> >   #include "alloc_page.h"
> > +#include "usermode.h"
> >
> >   #define memset __builtin_memset
> >   #define TESTDEV_IO_PORT 0xe0
> >
> > +#define MAGIC_NUM 0xdeadbeefdeadbeefUL
> > +#define GS_BASE 0x400000
> > +
> >   static int exceptions;
> >
> >   /* Forced emulation prefix, used to invoke the emulator unconditionally.  */
> > @@ -925,6 +929,39 @@ static void test_sreg(volatile uint16_t *mem)
> >       write_ss(ss);
> >   }
> >
> > +static uint64_t usr_gs_mov(void)
> > +{
> > +    static uint64_t dummy = MAGIC_NUM;
> > +    uint64_t dummy_ptr = (uint64_t)&dummy;
> > +    uint64_t ret;
> > +
> > +    dummy_ptr -= GS_BASE;
> > +    asm volatile("mov %%gs:(%%rcx), %%rax" : "=a"(ret): "c"(dummy_ptr) :);
> > +
> > +    return ret;
> > +}
> > +
> > +static void test_iret(void)
> > +{
> > +    uint64_t val;
> > +    bool raised_vector;
> > +
> > +    /* Update GS base to 4MiB */
> > +    wrmsr(MSR_GS_BASE, GS_BASE);
> > +
> > +    /*
> > +     * Per the SDM, jumping to user mode via `iret`, which is returning to
> > +     * outer privilege level, for segment registers (ES, FS, GS, and DS)
> > +     * if the check fails, the segment selector becomes null.
> > +     *
> > +     * In our test case, GS becomes null.
> > +     */
> > +    val = run_in_user((usermode_func)usr_gs_mov, GP_VECTOR,
> > +                      0, 0, 0, 0, &raised_vector);
> > +
> > +    report(val == MAGIC_NUM, "Test ret/iret with a nullified segment");
> > +}
> > +
> >   /* Broken emulation causes triple fault, which skips the other tests. */
> >   #if 0
> >   static void test_lldt(volatile uint16_t *mem)
> > @@ -1074,6 +1111,7 @@ int main(void)
> >       test_shld_shrd(mem);
> >       //test_lgdt_lidt(mem);
> >       test_sreg(mem);
> > +     test_iret();
> >       //test_lldt(mem);
> >       test_ltr(mem);
> >       test_cmov(mem);
> >
>
> Thanks, the patch is good.

Is this patch applied?

Regards,
Bin
