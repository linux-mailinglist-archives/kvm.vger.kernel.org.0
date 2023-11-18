Return-Path: <kvm+bounces-1988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AA927EFFB7
	for <lists+kvm@lfdr.de>; Sat, 18 Nov 2023 14:00:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 08F22B20A4C
	for <lists+kvm@lfdr.de>; Sat, 18 Nov 2023 13:00:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69AF513AEB;
	Sat, 18 Nov 2023 12:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="GiSV6CsL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE67F9
	for <kvm@vger.kernel.org>; Sat, 18 Nov 2023 04:59:55 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id 98e67ed59e1d1-27ff7fe7fbcso2423543a91.1
        for <kvm@vger.kernel.org>; Sat, 18 Nov 2023 04:59:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1700312395; x=1700917195; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tWeYeGhv4+oULCCym1oagJtI9ntJIQQlmv612A1M6xA=;
        b=GiSV6CsL0u/wroHdQokrhdtNOApFuSql3x4xd5I0cmMVP227QtAXfatE3GPTzAa+TB
         LkYHgf9g5mqCmSabcu/xwPVuJKeqZCXx52LF26eFoNDnJ3NC+5OsBmTS/qf5Btv31LYQ
         p6mUCxuROr9z4ycTM9YKuRXpTEimussBC5YFD4f0XaOrr22O8c9BzHrSTwW64gosZ4KQ
         6fmsbnzEphx64RjigIaetfJKO6BbqtNw8Tt1vNrp6qSzEA3K3uP1eDdcyEfsTLFja2tr
         edygjF+dES4awkNNDaDQwxohdJvPfJniNmZbnGTj6UQgOa8+fFOxLi0J9wvdn3NT7p2q
         SzUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700312395; x=1700917195;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tWeYeGhv4+oULCCym1oagJtI9ntJIQQlmv612A1M6xA=;
        b=R+Xakm5FgpE5mjTz/kq9UquyYoI+IExA9ifKVOEfna6VKzLAg2MDHFcIb9go79z+MC
         Ublzt/oCyMEDB0X/gKP2fRWLarVOcxA2u0G+VveQ29wsFw9l34n7C4UWirweNgnLH3lo
         hfhydQdWSKb9ZtnnkSU1J/S+P06rgRR/syPTZ7UdYFpb5vjOIv9FeDKZPgElJV87jrnK
         TT7h5jX68IecgaXgulYglS8747dIUm6CwEBPCeLoXSFwVIJlLKxG6M8bdGfo1d7DqxPl
         MFUzQ5ouKzOJyquLrBaaBQcwwk31ye0HYOdN7bXD9qSEZMQVk4AiDoSxYex12MQjbj56
         7pWQ==
X-Gm-Message-State: AOJu0Yzs/INAU0UA8H10A/BDhyJ5KwdN1552KhZjgK5T9QzUGc2wz6+P
	NC6VKwN1YE8/VU83FrGjsUylBxuyN1JznJ0SjO3ypg==
X-Google-Smtp-Source: AGHT+IHlnK3TLKGD9rcPmZWBXA0kFrBWZWGpZTXzEyX30ZusdxQLCuiUdvm22Q7h7bM9bD5FA6TbvRd7uHB+sFvl1Cg=
X-Received: by 2002:a17:90b:4b8d:b0:27d:3f0c:f087 with SMTP id
 lr13-20020a17090b4b8d00b0027d3f0cf087mr2298002pjb.25.1700312395034; Sat, 18
 Nov 2023 04:59:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230918125730.1371985-1-apatel@ventanamicro.com>
 <20230918125730.1371985-5-apatel@ventanamicro.com> <20231025-dbbd1ae8936d3f31aa136179@orel>
In-Reply-To: <20231025-dbbd1ae8936d3f31aa136179@orel>
From: Anup Patel <apatel@ventanamicro.com>
Date: Sat, 18 Nov 2023 18:29:44 +0530
Message-ID: <CAK9=C2WDXj53Y2n=M-9OkdUJ7HSuOTQZn0AE0EpzijXdU-wzQQ@mail.gmail.com>
Subject: Re: [kvmtool PATCH v2 4/6] riscv: Add IRQFD support for in-kernel AIA irqchip
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com, maz@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Atish Patra <atishp@atishpatra.org>, 
	Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 25, 2023 at 6:47=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> On Mon, Sep 18, 2023 at 06:27:28PM +0530, Anup Patel wrote:
> > To use irqfd with in-kernel AIA irqchip, we add custom
> > irq__add_irqfd and irq__del_irqfd functions. This allows
> > us to defer actual KVM_IRQFD ioctl() until AIA irqchip
> > is initialized by KVMTOOL.
> >
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > ---
> >  riscv/include/kvm/kvm-arch.h | 11 ++++++
> >  riscv/irq.c                  | 73 ++++++++++++++++++++++++++++++++++++
> >  2 files changed, 84 insertions(+)
> >
> > diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.=
h
> > index cd37fc6..1a8af6a 100644
> > --- a/riscv/include/kvm/kvm-arch.h
> > +++ b/riscv/include/kvm/kvm-arch.h
> > @@ -98,11 +98,22 @@ extern void (*riscv_irqchip_generate_fdt_node)(void=
 *fdt, struct kvm *kvm);
> >  extern u32 riscv_irqchip_phandle;
> >  extern u32 riscv_irqchip_msi_phandle;
> >  extern bool riscv_irqchip_line_sensing;
> > +extern bool riscv_irqchip_irqfd_ready;
> >
> >  void plic__create(struct kvm *kvm);
> >
> >  void pci__generate_fdt_nodes(void *fdt);
> >
> > +int riscv__add_irqfd(struct kvm *kvm, unsigned int gsi, int trigger_fd=
,
> > +                  int resample_fd);
> > +
> > +void riscv__del_irqfd(struct kvm *kvm, unsigned int gsi, int trigger_f=
d);
> > +
> > +#define irq__add_irqfd riscv__add_irqfd
> > +#define irq__del_irqfd riscv__del_irqfd
> > +
> > +int riscv__setup_irqfd_lines(struct kvm *kvm);
> > +
> >  void riscv__generate_irq_prop(void *fdt, u8 irq, enum irq_type irq_typ=
e);
> >
> >  void riscv__irqchip_create(struct kvm *kvm);
> > diff --git a/riscv/irq.c b/riscv/irq.c
> > index b608a2f..e6c0939 100644
> > --- a/riscv/irq.c
> > +++ b/riscv/irq.c
> > @@ -12,6 +12,7 @@ void (*riscv_irqchip_generate_fdt_node)(void *fdt, st=
ruct kvm *kvm) =3D NULL;
> >  u32 riscv_irqchip_phandle =3D PHANDLE_RESERVED;
> >  u32 riscv_irqchip_msi_phandle =3D PHANDLE_RESERVED;
> >  bool riscv_irqchip_line_sensing =3D false;
> > +bool riscv_irqchip_irqfd_ready =3D false;
> >
> >  void kvm__irq_line(struct kvm *kvm, int irq, int level)
> >  {
> > @@ -46,6 +47,78 @@ void kvm__irq_trigger(struct kvm *kvm, int irq)
> >       }
> >  }
> >
> > +struct riscv_irqfd_line {
> > +     unsigned int            gsi;
> > +     int                     trigger_fd;
> > +     int                     resample_fd;
> > +     struct list_head        list;
> > +};
> > +
> > +static LIST_HEAD(irqfd_lines);
> > +
> > +int riscv__add_irqfd(struct kvm *kvm, unsigned int gsi, int trigger_fd=
,
> > +                  int resample_fd)
> > +{
> > +     struct riscv_irqfd_line *line;
> > +
> > +     if (riscv_irqchip_irqfd_ready)
> > +             return irq__common_add_irqfd(kvm, gsi, trigger_fd,
> > +                                          resample_fd);
> > +
> > +     /* Postpone the routing setup until we have a distributor */
>
> This comment comes from the Arm code. We probably want to replace
> distributor with "until the AIA is initialized" or something.

Okay, I will update.

>
> > +     line =3D malloc(sizeof(*line));
> > +     if (!line)
> > +             return -ENOMEM;
> > +
> > +     *line =3D (struct riscv_irqfd_line) {
> > +             .gsi            =3D gsi,
> > +             .trigger_fd     =3D trigger_fd,
> > +             .resample_fd    =3D resample_fd,
> > +     };
> > +     list_add(&line->list, &irqfd_lines);
> > +
> > +     return 0;
> > +}
> > +
> > +void riscv__del_irqfd(struct kvm *kvm, unsigned int gsi, int trigger_f=
d)
> > +{
> > +     struct riscv_irqfd_line *line;
> > +
> > +     if (riscv_irqchip_irqfd_ready) {
> > +             irq__common_del_irqfd(kvm, gsi, trigger_fd);
> > +             return;
> > +     }
> > +
> > +     list_for_each_entry(line, &irqfd_lines, list) {
> > +             if (line->gsi !=3D gsi)
> > +                     continue;
> > +
> > +             list_del(&line->list);
> > +             free(line);
> > +             break;
> > +     }
> > +}
> > +
> > +int riscv__setup_irqfd_lines(struct kvm *kvm)
> > +{
> > +     int ret;
> > +     struct riscv_irqfd_line *line, *tmp;
> > +
> > +     list_for_each_entry_safe(line, tmp, &irqfd_lines, list) {
> > +             ret =3D irq__common_add_irqfd(kvm, line->gsi, line->trigg=
er_fd,
> > +                                         line->resample_fd);
> > +             if (ret < 0) {
> > +                     pr_err("Failed to register IRQFD");
> > +                     return ret;
> > +             }
> > +
> > +             list_del(&line->list);
> > +             free(line);
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> >  void riscv__generate_irq_prop(void *fdt, u8 irq, enum irq_type irq_typ=
e)
> >  {
> >       u32 prop[2], size;
> > --
> > 2.34.1
> >
>
> Other than the comment,
>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Regards,
Anup

