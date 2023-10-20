Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE8C17D10BE
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 15:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377466AbjJTNrV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 09:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377372AbjJTNrU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 09:47:20 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4FDDA3
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 06:47:16 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 41be03b00d2f7-5a9bc2ec556so583233a12.0
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 06:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1697809636; x=1698414436; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ujFKaHWQlVUmMQlPTcdZIic60Ioy7TSqQ3nDhHoDDn0=;
        b=P6hJA9XHLrlREANM92ye5l+V/OvcbTs9+UCzklsxfA+8AWC2JFc3ImCtV4ectOGTkh
         ABMJoNI3/T1b90RNFNBMNHvPEyZ5mcPXcGCP+OjLVezORt1WOZeJhjXp4D7Fdu+BmDt2
         736ngLQ/QdC6O0hRN+h8OzjY2f4Ba+vmCBJjrLMBOoRu49V/QyPAZX33coy7A7VaCjCF
         4zyAGQA91ak6Q6I3bYsdbGrFTZ9NFWiIdUE07XMVb8M0+KTF+785ac3Czh1ic/9ArUtD
         4TjOavBfPz7YIGHs3zm1hwp/hI1OGwboG22n3JL0bkksqaCoTjCfvQvzqKDjyFQli1Sh
         c5JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697809636; x=1698414436;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ujFKaHWQlVUmMQlPTcdZIic60Ioy7TSqQ3nDhHoDDn0=;
        b=Fp+39MLxU31ooZsAsYyaVJXcwMJtFfUxNCjmRrofMm49ELktIVmT0MA6rye67h3Kre
         R7MGkuCJVZ9mVwpzEQPn3UIgK9RlY6pDr235kwhl/3Xvoi90BDNf4z40CrDjfjR2jY3E
         9sked9a48Q3bIq31/ouL9oP4yFMHdaN8mG+T4PIbukwMWNcjskWLAgdwuQFgFnYDJJqZ
         fmtvAYX0DzeczzXXClQIAMttPYbhrKtO1ddjNThdN07k52dUASU1NwlG/dWk8wL0Xkc9
         fQfl6Jtq4a2xceRnw+P+/F/mNy40DXIQCFNFC8MgR4sJDl3fHp9RqOm7Jyqp4+A8DtyQ
         kZgA==
X-Gm-Message-State: AOJu0YxU67FAbQMmzAKw+XMxS6JTcTH9GmdKBVz5UMEhddRUmO+CS9gx
        IkE8wLI3YYbsX8Ogy9TDeJMzjSmOQ1V0Qhdbt40Lcw==
X-Google-Smtp-Source: AGHT+IEe1qO4q6kLy01GbxGxRAix8XMIPBN+082Nf7nryQBHvgSvHroABh+Pz6NLehEhxMDygq9zBHrYtbpZO8gR1/0=
X-Received: by 2002:a05:6a21:66cb:b0:172:f4e:5104 with SMTP id
 ze11-20020a056a2166cb00b001720f4e5104mr1738132pzb.20.1697809636011; Fri, 20
 Oct 2023 06:47:16 -0700 (PDT)
MIME-Version: 1.0
References: <20231020072140.900967-1-apatel@ventanamicro.com>
 <20231020072140.900967-9-apatel@ventanamicro.com> <20231020-f1ec2b7e384a4cfeae39966f@orel>
In-Reply-To: <20231020-f1ec2b7e384a4cfeae39966f@orel>
From:   Anup Patel <apatel@ventanamicro.com>
Date:   Fri, 20 Oct 2023 19:17:03 +0530
Message-ID: <CAK9=C2Vg8O_6OaND_s1MhpBHpm1petoU7DNXOOaSOxXYUY1iAw@mail.gmail.com>
Subject: Re: [PATCH v3 8/9] tty: Add SBI debug console support to HVC SBI driver
To:     Andrew Jones <ajones@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Conor Dooley <conor@kernel.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Atish Patra <atishp@rivosinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 20, 2023 at 4:16=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> On Fri, Oct 20, 2023 at 12:51:39PM +0530, Anup Patel wrote:
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
> >  drivers/tty/hvc/hvc_riscv_sbi.c | 82 ++++++++++++++++++++++++++++++---
> >  2 files changed, 76 insertions(+), 8 deletions(-)
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
> > index 31f53fa77e4a..56da1a4b5aca 100644
> > --- a/drivers/tty/hvc/hvc_riscv_sbi.c
> > +++ b/drivers/tty/hvc/hvc_riscv_sbi.c
> > @@ -39,21 +39,89 @@ static int hvc_sbi_tty_get(uint32_t vtermno, char *=
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
> > +     if (is_vmalloc_addr(buf)) {
> > +             pa =3D page_to_phys(vmalloc_to_page(buf)) + offset_in_pag=
e(buf);
> > +             if (PAGE_SIZE < (offset_in_page(buf) + count))
>
> I thought checkpatch complained about uppercase constants being on the
> left in comparisons.

Nope checkpatch does not complain about this.

>
> > +                     count =3D PAGE_SIZE - offset_in_page(buf);
> > +     } else {
> > +             pa =3D __pa(buf);
> > +     }
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
>
> Shouldn't we return ret.value here in case it's less than count? I see we
> already do that below in get().

Ahh, yes. Good catch, I will update.

>
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
> > +     if (is_vmalloc_addr(buf)) {
> > +             pa =3D page_to_phys(vmalloc_to_page(buf)) + offset_in_pag=
e(buf);
> > +             if (PAGE_SIZE < (offset_in_page(buf) + count))
> > +                     count =3D PAGE_SIZE - offset_in_page(buf);
> > +     } else {
> > +             pa =3D __pa(buf);
> > +     }
> > +
> > +     if (IS_ENABLED(CONFIG_32BIT))
> > +             ret =3D sbi_ecall(SBI_EXT_DBCN, SBI_EXT_DBCN_CONSOLE_READ=
,
> > +                             count, lower_32_bits(pa), upper_32_bits(p=
a),
> > +                             0, 0, 0);
> > +     else
> > +             ret =3D sbi_ecall(SBI_EXT_DBCN, SBI_EXT_DBCN_CONSOLE_READ=
,
> > +                             count, pa, 0, 0, 0, 0);
> > +     if (ret.error)
> > +             return 0;
> > +
> > +     return ret.value;
> > +}
> > +
> > +static const struct hv_ops hvc_sbi_dbcn_ops =3D {
> > +     .put_chars =3D hvc_sbi_dbcn_tty_put,
> > +     .get_chars =3D hvc_sbi_dbcn_tty_get,
> > +};
> > +
> > +static int __init hvc_sbi_init(void)
> > +{
> > +     int err;
> > +
> > +     if ((sbi_spec_version >=3D sbi_mk_version(2, 0)) &&
> > +         (sbi_probe_extension(SBI_EXT_DBCN) > 0)) {
> > +             err =3D PTR_ERR_OR_ZERO(hvc_alloc(0, 0, &hvc_sbi_dbcn_ops=
, 16));
>
> Why an outbuf size of only 16?

The output buffer size of 16 is a very common choice across
HVC drivers. The next best choice is 256.

I guess 256 is better so I will go with that.

>
> > +             if (err)
> > +                     return err;
> > +             hvc_instantiate(0, 0, &hvc_sbi_dbcn_ops);
> > +     } else {
> > +             if (IS_ENABLED(CONFIG_RISCV_SBI_V01)) {
> > +                     err =3D PTR_ERR_OR_ZERO(hvc_alloc(0, 0, &hvc_sbi_=
v01_ops, 16));
> > +                     if (err)
> > +                             return err;
> > +                     hvc_instantiate(0, 0, &hvc_sbi_v01_ops);
> > +             } else {
> > +                     return -ENODEV;
> > +             }
> > +     }
> >
> >       return 0;
> >  }
> > -console_initcall(hvc_sbi_console_init);
> > +device_initcall(hvc_sbi_init);
> > --
> > 2.34.1
> >
>
> Thanks,
> drew

Regards,
Anup
