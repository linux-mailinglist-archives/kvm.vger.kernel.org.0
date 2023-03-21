Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E70216C3C64
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 22:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbjCUVCl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 17:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbjCUVCk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 17:02:40 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65216574DD;
        Tue, 21 Mar 2023 14:02:39 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id p203so18812614ybb.13;
        Tue, 21 Mar 2023 14:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679432558;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7KdYKeJhs6BlAbgaUy8umwaslI0fUCE3dBqVeYeDGa4=;
        b=bjYjHDJStZi1r9+Dbh03/V+dKle/fh0I2f8dANFi6Z7Ffw6/6lEuAmi+EtVvshC8YO
         0VZIzOm4z4XG1JwEsNe9uLN9RUWclnIsuy2EFe81Wywbjt/W9FQpXpJYu0+Wp9fb42Nc
         G2m4V3Uuz5U223CYTzEkAuOWJeNEQ32rOv9DJAfonOuVpm7xfw3iI4tITYZyLgNglwaY
         6buutuajtIpLZPQXUWIo4A6lEMIst8TWmsfkES/IzmzS2195lHLcnRaNV1Ng4Nvo3W89
         uJKdgYowqcj+I7rmdzbWzxAN2mEYOFNbARgG5Mn1wGMKv1kr24hG62cpdHRXpE3h5+LU
         AEIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679432558;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7KdYKeJhs6BlAbgaUy8umwaslI0fUCE3dBqVeYeDGa4=;
        b=Q8pnUb5p8QNob8kUSDJ94Rqe1+DMdX+o2btf+DJzo1fN29iEBDvwgKGWVXzonlxkU/
         0s8A6Mz8DW7TogwnBj7/a/MrW1bCSMjsxirC1B1RBExfxRASq+9z2AUVD+fLGcXYfOjO
         Udr51ScQnlIdIcRYoXkHKJZcInwVg28DfE4a++TUe7paGp7HZkgnM+w0zryeYq2OdXF3
         J6T61RTpnGs5TKPtn0IHKtB+W2xGiF23+IFBiZYrPGmshstqSC+EgWmBzLuqOxdfs6ag
         oo7DqDY8g+T5hFxaZaSAdulzWr0HXKkEKkDTo3642CfaJSnbC2L0iaTNWZ2/N2SRWOve
         TnJg==
X-Gm-Message-State: AAQBX9dMj4p16qP2KGV6EViE1BJrWVT8p15q6RhZcgVG0HSCr95xAr+J
        pFQfmP+4m3TLKsV/1vTOD6rZW94R2EJgWohlMwYoyn25tw==
X-Google-Smtp-Source: AKy350btW9WCm9AQmE3K1LLLcrTqOju2+M8P5TE4wmOswUXQ6vy6ttqgKH5L2NNJ1AHtqCpunxcZuuTWV1YXvemYS70=
X-Received: by 2002:a05:6902:1208:b0:b6f:dcd:6cd2 with SMTP id
 s8-20020a056902120800b00b6f0dcd6cd2mr2154016ybu.10.1679432558494; Tue, 21 Mar
 2023 14:02:38 -0700 (PDT)
MIME-Version: 1.0
References: <20230316222109.1940300-1-usama.arif@bytedance.com>
 <20230316222109.1940300-10-usama.arif@bytedance.com> <CAMzpN2jMyLP9h5o_wwdThHipAns2_dx3Nf8JYhj5pEqaeWXqYg@mail.gmail.com>
 <30efad7b8a5922cdaa48ab89a2dbaf425daf49a8.camel@infradead.org>
In-Reply-To: <30efad7b8a5922cdaa48ab89a2dbaf425daf49a8.camel@infradead.org>
From:   Brian Gerst <brgerst@gmail.com>
Date:   Tue, 21 Mar 2023 17:02:27 -0400
Message-ID: <CAMzpN2ijBZV0d+FjXpi8iP9rQ2gFgQ-9TtkZMB4xDizox1yW3g@mail.gmail.com>
Subject: Re: [PATCH v15 09/12] x86/smpboot: Support parallel startup of
 secondary CPUs
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Usama Arif <usama.arif@bytedance.com>, tglx@linutronix.de,
        kim.phillips@amd.com, piotrgorski@cachyos.org,
        oleksandr@natalenko.name, arjan@linux.intel.com, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        x86@kernel.org, pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        gpiccoli@igalia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 21, 2023 at 3:12=E2=80=AFPM David Woodhouse <dwmw2@infradead.or=
g> wrote:
>
> On Tue, 2023-03-21 at 14:28 -0400, Brian Gerst wrote:
> >
> > > @@ -264,6 +318,14 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, =
SYM_L_GLOBAL)
> > >          lgdt    (%rsp)
> > >          addq    $16, %rsp
> > >
> > > +       /* Drop the realmode protection. For the boot CPU the pointer=
 is NULL! */
> > > +       movq    trampoline_lock(%rip), %rax
> > > +       testq   %rax, %rax
> > > +       jz      .Lsetup_data_segments
> > > +       lock
> > > +       btrl    $0, (%rax)
> > > +
> > > +.Lsetup_data_segments:
> > >          /* set up data segments */
> > >          xorl %eax,%eax
> > >          movl %eax,%ds
> >
> > This can still go earlier, right after "movq TASK_threadsp(%rax),
> > %rsp".  The GDT descriptor is placed on the idle thread stack, so it's
> > safe to drop the lock before it.
>
>
> --- a/arch/x86/kernel/head_64.S
> +++ b/arch/x86/kernel/head_64.S
> @@ -335,6 +335,17 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_=
L_GLOBAL)
>         movq    pcpu_hot + X86_current_task(%rdx), %rax
>         movq    TASK_threadsp(%rax), %rsp
>
> +       /*
> +        * Now that this CPU is running on its own stack, drop the realmo=
de
> +        * protection. For the boot CPU the pointer is NULL!
> +        */
> +       movq    trampoline_lock(%rip), %rax
> +       testq   %rax, %rax
> +       jz      .Lsetup_gdt
> +       lock
> +       btrl    $0, (%rax)
> +
> +.Lsetup_gdt:
>         /*
>          * We must switch to a new descriptor in kernel space for the GDT
>          * because soon the kernel won't have access anymore to the users=
pace
> @@ -377,14 +388,6 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_=
L_GLOBAL)
>         shrq    $32, %rdx
>         wrmsr
>
> -       /* Drop the realmode protection. For the boot CPU the pointer is =
NULL! */
> -       movq    trampoline_lock(%rip), %rax
> -       testq   %rax, %rax
> -       jz      .Lsetup_idt
> -       lock
> -       btrl    $0, (%rax)
> -
> -.Lsetup_idt:
>         /* Setup and Load IDT */
>         pushq   %rsi
>         call    early_setup_idt
>

Looks good, thanks.
