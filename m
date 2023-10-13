Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5697C88ED
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 17:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232270AbjJMPmE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 11:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232465AbjJMPmC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 11:42:02 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8614B7
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 08:41:58 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id 46e09a7af769-6c0b8f42409so1422710a34.0
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 08:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1697211718; x=1697816518; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=58F4pC3mBDu8F+pvcYNIm1FByUJEAPva6M9hCs3f/vs=;
        b=n+BqQMAKWJX45AnFEWePhAqGlkLkXrnY0T7msk+XhAMKqkVcC1Zncxg9ON0N79vJQi
         uuCIL7VVp44DdNoBOoFFoZM4dH1AjhOWHn8i/jNP+HbNGexnAJVYNcdGfhSCXIuv5zZk
         xG8BSJqWHcc1NGCb5y/9PfstHSukkld0lzVWudGZ38hwnUAnKvHVf51rJg81bjSrDAD8
         QsXt0gsfgcjBv0JOp28jbp7zOeqUKPu3YOQivYr/XxG0Heg5lRqySMHPxQdx97uWW8h8
         ukDBuHjTaiDAytEaWbqZZgRowb8J1y5SXTGPlox+JisQsKaGTs7BGacRiVDBz1FZiNq9
         bMjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697211718; x=1697816518;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=58F4pC3mBDu8F+pvcYNIm1FByUJEAPva6M9hCs3f/vs=;
        b=d7IAOrx/uJdNPEUbxSez7ugqyyMrU/80LAl+AieAqVzDRWFvkLfhRvbY6lCbhoPpoc
         vBUQtbfMnc1BNre9Mb9lYe0JVnvSAawXVhnvLLvz2+5X9v8KrBSadvVRO1TbnJNWQ9vH
         A20MeHjwmIP37ecBIDMe6ZxaG0kCUzhD4GO7C0QQ7wSjUeXEUihspIbtnL0NIDa02Jl3
         +5cjm6vhQElX37eRRZdUgiNaFtaCQoH543wXHCN2Qo+sa8ACf1aAwizktuIgGkSqMpOU
         3xIwz0U+kSMSJKB8sr7n39rBiN4Wa/tBh/w1jGhsI2p6zpL1OmGLf42TsUyIG9LgvWd3
         1Z3g==
X-Gm-Message-State: AOJu0Yxch0v1pzZbFqryaHTmQXu3RIbmQnNFwC1BRCqGY65UffpIizZA
        u8P3RFfCj43nSLE+C9Hy24Yu6tIfNZppUnvDh9EvDg==
X-Google-Smtp-Source: AGHT+IEzcIYsSKMe5bsbRMbzf4xh1PED9ixUfbd1o7ixVah0VHZj9arKWffuv9/jPa1nkBsBkAGklSaRf41sshg9uSY=
X-Received: by 2002:a05:6870:6587:b0:1e9:b7a7:8efe with SMTP id
 fp7-20020a056870658700b001e9b7a78efemr5211668oab.2.1697211718067; Fri, 13 Oct
 2023 08:41:58 -0700 (PDT)
MIME-Version: 1.0
References: <20231012051509.738750-1-apatel@ventanamicro.com>
 <20231012051509.738750-8-apatel@ventanamicro.com> <87fs2ghxyz.fsf@all.your.base.are.belong.to.us>
In-Reply-To: <87fs2ghxyz.fsf@all.your.base.are.belong.to.us>
From:   Anup Patel <apatel@ventanamicro.com>
Date:   Fri, 13 Oct 2023 21:11:46 +0530
Message-ID: <CAK9=C2XFTULtQ6YoNHDb7WJwm8p3wkG_pJA8h+XYGEOzt18Ctg@mail.gmail.com>
Subject: Re: [PATCH v2 7/8] tty: Add SBI debug console support to HVC SBI driver
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Conor Dooley <conor@kernel.org>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Atish Patra <atishp@rivosinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 12, 2023 at 5:08=E2=80=AFPM Bj=C3=B6rn T=C3=B6pel <bjorn@kernel=
.org> wrote:
>
> Anup Patel <apatel@ventanamicro.com> writes:
>
> > From: Atish Patra <atishp@rivosinc.com>
> >
> > RISC-V SBI specification supports advanced debug console
> > support via SBI DBCN extension.
> >
> > Extend the HVC SBI driver to support it.
> >
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > ---
> >  drivers/tty/hvc/Kconfig         |  2 +-
> >  drivers/tty/hvc/hvc_riscv_sbi.c | 76 ++++++++++++++++++++++++++++++---
> >  2 files changed, 70 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/tty/hvc/Kconfig b/drivers/tty/hvc/Kconfig
> > index 4f9264d005c0..6e05c5c7bca1 100644
> > --- a/drivers/tty/hvc/Kconfig
> > +++ b/drivers/tty/hvc/Kconfig
> > @@ -108,7 +108,7 @@ config HVC_DCC_SERIALIZE_SMP
> >
> >  config HVC_RISCV_SBI
> >       bool "RISC-V SBI console support"
> > -     depends on RISCV_SBI_V01
> > +     depends on RISCV_SBI
> >       select HVC_DRIVER
> >       help
> >         This enables support for console output via RISC-V SBI calls, w=
hich
> > diff --git a/drivers/tty/hvc/hvc_riscv_sbi.c b/drivers/tty/hvc/hvc_risc=
v_sbi.c
> > index 31f53fa77e4a..da318d7f55c5 100644
> > --- a/drivers/tty/hvc/hvc_riscv_sbi.c
> > +++ b/drivers/tty/hvc/hvc_riscv_sbi.c
> > @@ -39,21 +39,83 @@ static int hvc_sbi_tty_get(uint32_t vtermno, char *=
buf, int count)
> >       return i;
> >  }
> >
> > -static const struct hv_ops hvc_sbi_ops =3D {
> > +static const struct hv_ops hvc_sbi_v01_ops =3D {
> >       .get_chars =3D hvc_sbi_tty_get,
> >       .put_chars =3D hvc_sbi_tty_put,
> >  };
> >
> > -static int __init hvc_sbi_init(void)
> > +static int hvc_sbi_dbcn_tty_put(uint32_t vtermno, const char *buf, int=
 count)
> >  {
> > -     return PTR_ERR_OR_ZERO(hvc_alloc(0, 0, &hvc_sbi_ops, 16));
> > +     phys_addr_t pa;
> > +     struct sbiret ret;
> > +
> > +     if (is_vmalloc_addr(buf))
> > +             pa =3D page_to_phys(vmalloc_to_page(buf)) + offset_in_pag=
e(buf);
>
> What is assumed from buf here? If buf is crossing a page, you need to
> adjust the count, no?

I never saw a page crossing buffer but I will certainly address this
in the next revision.

>
> > +     else
> > +             pa =3D __pa(buf);
> > +
> > +     if (IS_ENABLED(CONFIG_32BIT))
> > +             ret =3D sbi_ecall(SBI_EXT_DBCN, SBI_EXT_DBCN_CONSOLE_WRIT=
E,
> > +                             count, lower_32_bits(pa), upper_32_bits(p=
a),
> > +                             0, 0, 0);
> > +     else
> > +             ret =3D sbi_ecall(SBI_EXT_DBCN, SBI_EXT_DBCN_CONSOLE_WRIT=
E,
> > +                             count, pa, 0, 0, 0, 0);
> > +     if (ret.error)
> > +             return 0;
> > +
> > +     return count;
> >  }
> > -device_initcall(hvc_sbi_init);
> >
> > -static int __init hvc_sbi_console_init(void)
> > +static int hvc_sbi_dbcn_tty_get(uint32_t vtermno, char *buf, int count=
)
> >  {
> > -     hvc_instantiate(0, 0, &hvc_sbi_ops);
> > +     phys_addr_t pa;
> > +     struct sbiret ret;
> > +
> > +     if (is_vmalloc_addr(buf))
> > +             pa =3D page_to_phys(vmalloc_to_page(buf)) + offset_in_pag=
e(buf);
>
> And definitely adjust count here, if we're crossing a page!

Sure, I will update here as well.

Thanks,
Anup
