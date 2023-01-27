Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C534267E597
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 13:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234274AbjA0MkN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 07:40:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234432AbjA0Mjv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 07:39:51 -0500
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6435B24CBA
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 04:38:34 -0800 (PST)
Received: by mail-vs1-xe2f.google.com with SMTP id k6so5179043vsk.1
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 04:38:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=76/Qo0p/UxKI75yKdBSKj64ShK7ggokQHoWD6X+9VHg=;
        b=Hszngf222LTCIZHcJU1fcQ3FtMpp0R2eOQm3OvoYjsDNqUd9DWcmWOy+/4fg78+HsO
         8XFpqun0Ueoj6fmd17AWt7K/6W2VW1sD/tmGPEQcv4nIf9Gt3HuB0Vnhk/IwXI1pSYGJ
         BPZXC2Km1XXz633t+U9T88H2NhD1Xhj19dWgOmKi0Ec6TgvVDAHSMWw0oEdfg5mMiwUp
         QFM3/gIYS3j1sl3Pz9WOlt/pZg66CUZmDctaZTQiyqh4feNu+YQconFv4gttY67JPn67
         yOiZvxB6QYbnHv4Q60G40Qo4FX7HK0lwkbFRczhuBipr3M3bs+35aM8GDrCkk65hkX7y
         amzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=76/Qo0p/UxKI75yKdBSKj64ShK7ggokQHoWD6X+9VHg=;
        b=umYL7izpVNn8chobbZbz+/17xWyncwKYiC2pcnAXa239JlcjVjT9zReDnTVoaVDrYq
         8WmhOPFTSGSxQaGFK4qwnf0cZAshVvf9ETaXyxLLMjGmqhImmFBvB6ab6HWC+Io0jEwC
         oL6mv4cGnwu7CvojM+2WUF8iPvMyS9K9T4g98D79UTE0gwraMDVFiX0hNxkSHOW7QkuP
         omGwUfvwnzgxU4TMUNG/CvhcL2qx5rAYQoum5uk+5Sge+qeqMPiX9zkUTkxviXnNjv1S
         Qk/o2fHFAwItvLh4FrwjjjnkXqlHS110qC5tAF8sSEOemPhIvw6jfpuHuRJMDeiIPg3B
         evHw==
X-Gm-Message-State: AFqh2krOyOXHRfEjOVmvCDI0sX5ZshZ6My23S/MyieK5BPa2qgJP8JD3
        f7rDe4EQ3lToNXGrZY8diZ1MantjBUD1CbkbN6aG3w==
X-Google-Smtp-Source: AMrXdXvc0q+iLQCnU6T6GYjXCaxLciz1aBj2XVRZ5Wl7IH4DhMufJ5y3L690UwNsvqdwM9Ay5ls2J7TzC6BW9BtSReM=
X-Received: by 2002:a05:6102:3134:b0:3d3:d816:c798 with SMTP id
 f20-20020a056102313400b003d3d816c798mr4972887vsh.59.1674823110815; Fri, 27
 Jan 2023 04:38:30 -0800 (PST)
MIME-Version: 1.0
References: <20230112140304.1830648-1-apatel@ventanamicro.com>
 <20230112140304.1830648-3-apatel@ventanamicro.com> <20230126160234.pkx4socjv3fcxpmn@orel>
In-Reply-To: <20230126160234.pkx4socjv3fcxpmn@orel>
From:   Anup Patel <apatel@ventanamicro.com>
Date:   Fri, 27 Jan 2023 18:08:19 +0530
Message-ID: <CAK9=C2X3=GZ1KDhHOAY2Mk+=uYAqSMVSYEQkWizm2=VgF_ynXw@mail.gmail.com>
Subject: Re: [PATCH 2/7] RISC-V: Detect AIA CSRs from ISA string
To:     Andrew Jones <ajones@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 26, 2023 at 9:32 PM Andrew Jones <ajones@ventanamicro.com> wrote:
>
> On Thu, Jan 12, 2023 at 07:32:59PM +0530, Anup Patel wrote:
> > We have two extension names for AIA ISA support: Smaia (M-mode AIA CSRs)
> > and Ssaia (S-mode AIA CSRs).
> >
> > We extend the ISA string parsing to detect Smaia and Ssaia extensions.
> >
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > ---
> >  arch/riscv/include/asm/hwcap.h | 8 ++++++++
> >  arch/riscv/kernel/cpu.c        | 2 ++
> >  arch/riscv/kernel/cpufeature.c | 2 ++
> >  3 files changed, 12 insertions(+)
> >
> > diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
> > index 86328e3acb02..c649e85ed7bb 100644
> > --- a/arch/riscv/include/asm/hwcap.h
> > +++ b/arch/riscv/include/asm/hwcap.h
> > @@ -59,10 +59,18 @@ enum riscv_isa_ext_id {
> >       RISCV_ISA_EXT_ZIHINTPAUSE,
> >       RISCV_ISA_EXT_SSTC,
> >       RISCV_ISA_EXT_SVINVAL,
> > +     RISCV_ISA_EXT_SSAIA,
> > +     RISCV_ISA_EXT_SMAIA,
>
> These will change a couple different ways due other other patches in
> flight, but let's put the pair in alphabetical order now so they get
> moved together that way.

Okay, I will update.

>
> >       RISCV_ISA_EXT_ID_MAX
> >  };
> >  static_assert(RISCV_ISA_EXT_ID_MAX <= RISCV_ISA_EXT_MAX);
> >
> > +#ifdef CONFIG_RISCV_M_MODE
> > +#define RISCV_ISA_EXT_SxAIA          RISCV_ISA_EXT_SMAIA
> > +#else
> > +#define RISCV_ISA_EXT_SxAIA          RISCV_ISA_EXT_SSAIA
> > +#endif
>
> This isn't used in this patch, so should probably be introduced in a later
> patch when it is.

Okay, I will move this to the patch where it is used.

>
> > +
> >  /*
> >   * This enum represents the logical ID for each RISC-V ISA extension static
> >   * keys. We can use static key to optimize code path if some ISA extensions
> > diff --git a/arch/riscv/kernel/cpu.c b/arch/riscv/kernel/cpu.c
> > index 1b9a5a66e55a..a215ec929160 100644
> > --- a/arch/riscv/kernel/cpu.c
> > +++ b/arch/riscv/kernel/cpu.c
> > @@ -162,6 +162,8 @@ arch_initcall(riscv_cpuinfo_init);
> >   *    extensions by an underscore.
> >   */
> >  static struct riscv_isa_ext_data isa_ext_arr[] = {
> > +     __RISCV_ISA_EXT_DATA(smaia, RISCV_ISA_EXT_SMAIA),
> > +     __RISCV_ISA_EXT_DATA(ssaia, RISCV_ISA_EXT_SSAIA),
> >       __RISCV_ISA_EXT_DATA(sscofpmf, RISCV_ISA_EXT_SSCOFPMF),
> >       __RISCV_ISA_EXT_DATA(sstc, RISCV_ISA_EXT_SSTC),
> >       __RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
> > diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
> > index 93e45560af30..3c5b51f519d5 100644
> > --- a/arch/riscv/kernel/cpufeature.c
> > +++ b/arch/riscv/kernel/cpufeature.c
> > @@ -228,6 +228,8 @@ void __init riscv_fill_hwcap(void)
> >                               SET_ISA_EXT_MAP("zihintpause", RISCV_ISA_EXT_ZIHINTPAUSE);
> >                               SET_ISA_EXT_MAP("sstc", RISCV_ISA_EXT_SSTC);
> >                               SET_ISA_EXT_MAP("svinval", RISCV_ISA_EXT_SVINVAL);
> > +                             SET_ISA_EXT_MAP("smaia", RISCV_ISA_EXT_SMAIA);
> > +                             SET_ISA_EXT_MAP("ssaia", RISCV_ISA_EXT_SSAIA);
> >                       }
> >  #undef SET_ISA_EXT_MAP
> >               }
> > --
> > 2.34.1
> >
>
> Otherwise,
>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
>

Thanks,
Anup
