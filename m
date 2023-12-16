Return-Path: <kvm+bounces-4640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B8B66815C98
	for <lists+kvm@lfdr.de>; Sun, 17 Dec 2023 00:54:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 77A221C215A6
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 23:54:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61CF237D02;
	Sat, 16 Dec 2023 23:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="jX5E6oi0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1ED374CD
	for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 23:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-50e23c620e8so1355881e87.1
        for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 15:54:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1702770857; x=1703375657; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zrVvV1utl9GFRZ2LZ5WcICVBPuOzU+o2aQHc1q2IHuo=;
        b=jX5E6oi0H7s1I6GmgXD5DFApKaiBNmfCpzpeKGXuJ7rwEkYo0JjRwEUd6kWMEnUbPF
         VFtBzL4pilvY/nykek25tDLvsvtIW2zpnNUaGp1pbZOnxX2LAp2FW2v6rv2Qm9nZRJ//
         D9qVHs6VccmhP7Mge/aQWfjYULg9jHL+cH9uZavxDLoN47exSlyA/B7B/Dsfsg9ePTCn
         F9jIT3Zwy88Wf09ruUvfQ8qbMyEkuoO9xXHlOeGuk/LvAhXbn2YE6AQ+/t7+Xz1B/bC1
         BF5Wb7SOeTvFX2vT0PdMgzGzCtLoK6NcdhFGFuslmi76A88C+JOUXu5exN3izGiRbY5Y
         GLxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702770857; x=1703375657;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zrVvV1utl9GFRZ2LZ5WcICVBPuOzU+o2aQHc1q2IHuo=;
        b=lQqAmRmORATH/pcz39NlyGrgRZvGZf20idg7PotzWjO34Rm0WipB8dKdjsoab1wBzI
         RrBtnk4/EPp/2ocaava864bnDY1gbX2mqUT8Jl4CzVasPZi5RF5Tv80gUlZgMY57aPVY
         enN/Ewe2OpSCu2/WOuCCnks5g7I8jRF0Q/VVKLlJgVEaAlQqzjoEtlBSHnYDDZNkVCON
         39oTN58ItHkqT6vf9F6KXNVcHi6KYOcBG+5H4AgqmM/Gc4GCgFO0+XKhtajlBz06W6QT
         wB5tuSExgX716AbxHdNqcGVXXXtb3bHgQd+Z5IgAlyP7JOO5nNqjpO5Z43v999E/emm6
         ZQHw==
X-Gm-Message-State: AOJu0YzF5IU10T1gSSKkaBrSB70sU2HWAvQimluoRG2efUWpeGIx2KUH
	4iWKS6niIB9IKFlu7HzvTlCypnU1vSKN8GhELCQfqw==
X-Google-Smtp-Source: AGHT+IHCk7xG4MDxAwpDBg6B7k1zu+srSh/WBB8mQwajIiQw78mVZPMw1Rp9thftw8ABC4FzjfI8TzSLAb+wvu2Wd2o=
X-Received: by 2002:ac2:4c4f:0:b0:50e:17ea:905 with SMTP id
 o15-20020ac24c4f000000b0050e17ea0905mr3172436lfk.91.1702770857122; Sat, 16
 Dec 2023 15:54:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231205024310.1593100-1-atishp@rivosinc.com> <20231205024310.1593100-5-atishp@rivosinc.com>
 <20231207-fidgeting-plywood-8347d9d346be@wendy> <CAAhSdy3yK8CoQGZYT6j_xiKozt8viVXHogqVzUS7TxHs2Q_0Tw@mail.gmail.com>
In-Reply-To: <CAAhSdy3yK8CoQGZYT6j_xiKozt8viVXHogqVzUS7TxHs2Q_0Tw@mail.gmail.com>
From: Atish Kumar Patra <atishp@rivosinc.com>
Date: Sat, 16 Dec 2023 15:54:06 -0800
Message-ID: <CAHBxVyGs0kry-d1jcKWmR_AXm41hrUuvXAZxk+ht-AXS28mZqA@mail.gmail.com>
Subject: Re: [RFC 4/9] drivers/perf: riscv: Read upper bits of a firmware counter
To: Anup Patel <anup@brainfault.org>
Cc: Conor Dooley <conor.dooley@microchip.com>, linux-kernel@vger.kernel.org, 
	Alexandre Ghiti <alexghiti@rivosinc.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Atish Patra <atishp@atishpatra.org>, Guo Ren <guoren@kernel.org>, 
	Icenowy Zheng <uwu@icenowy.me>, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 14, 2023 at 4:30=E2=80=AFAM Anup Patel <anup@brainfault.org> wr=
ote:
>
> On Thu, Dec 7, 2023 at 6:03=E2=80=AFPM Conor Dooley <conor.dooley@microch=
ip.com> wrote:
> >
> > On Mon, Dec 04, 2023 at 06:43:05PM -0800, Atish Patra wrote:
> > > SBI v2.0 introduced a explicit function to read the upper bits
> > > for any firmwar counter width that is longer than XLEN. Currently,
> > > this is only applicable for RV32 where firmware counter can be
> > > 64 bit.
> >
> > The v2.0 spec explicitly says that this function returns the upper
> > 32 bits of the counter for rv32 and will always return 0 for rv64
> > or higher. The commit message here seems overly generic compared to
> > the actual definition in the spec, and makes it seem like it could
> > be used with a 128 bit counter on rv64 to get the upper 64 bits.
> >
> > I tried to think about what "generic" situation the commit message
> > had been written for, but the things I came up with would all require
> > changes to the spec to define behaviour for FID #5 and/or FID #1, so
> > in the end I couldn't figure out the rationale behind the non-committal
> > wording used here.
> >
The intention was to show that this can be extended in the future for
other XLEN systems
(obviously with spec modification). But I got your point. We can
update it whenever we have
such systems and the spec. Modified the commit text to match what is
in the spec .

> > >
> > > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > > ---
> > >  drivers/perf/riscv_pmu_sbi.c | 11 +++++++++--
> > >  1 file changed, 9 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sb=
i.c
> > > index 40a335350d08..1c9049e6b574 100644
> > > --- a/drivers/perf/riscv_pmu_sbi.c
> > > +++ b/drivers/perf/riscv_pmu_sbi.c
> > > @@ -490,16 +490,23 @@ static u64 pmu_sbi_ctr_read(struct perf_event *=
event)
> > >       struct hw_perf_event *hwc =3D &event->hw;
> > >       int idx =3D hwc->idx;
> > >       struct sbiret ret;
> > > -     union sbi_pmu_ctr_info info;
> > >       u64 val =3D 0;
> > > +     union sbi_pmu_ctr_info info =3D pmu_ctr_list[idx];
> > >
> > >       if (pmu_sbi_is_fw_event(event)) {
> > >               ret =3D sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_FW_R=
EAD,
> > >                               hwc->idx, 0, 0, 0, 0, 0);
> > >               if (!ret.error)
> > >                       val =3D ret.value;
> > > +#if defined(CONFIG_32BIT)
> >
> > Why is this not IS_ENABLED()? The code below uses one. You could then
> > fold it into the if statement below.
> >

Done.

> > > +             if (sbi_v2_available && info.width >=3D 32) {
> >
> >  >=3D 32? I know it is from the spec, but why does the spec define it a=
s
> >  "One less than number of bits in CSR"? Saving bits in the structure I
> >  guess?
>
> Yes, it is for using fewer bits in counter_info.
>
> The maximum width of a HW counter is 64 bits. The absolute value 64
> requires 7 bits in counter_info whereas absolute value 63 requires 6 bits
> in counter_info. Also, a HW counter if it exists will have at least 1 bit
> implemented otherwise the HW counter does not exist.
>
> Regards,
> Anup
>
> >
> > > +                     ret =3D sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUN=
TER_FW_READ_HI,
> > > +                                     hwc->idx, 0, 0, 0, 0, 0);
> >
> > > +                     if (!ret.error)
> > > +                             val =3D val | ((u64)ret.value << 32);
> >
> > If the first ecall fails but the second one doesn't won't we corrupt
> > val by only setting the upper bits? If returning val =3D=3D 0 is the th=
ing
> > to do in the error case (which it is in the existing code) should the
> > first `if (!ret.error)` become `if (ret.error)` -> `return 0`?
> >

Sure. Fixed it.

> >
> > > +                             val =3D val | ((u64)ret.value << 32);
> >
> > Also, |=3D ?
> >

Done.


> > Cheers,
> > Conor.
> >
> > > +             }
> > > +#endif
> > >       } else {
> > > -             info =3D pmu_ctr_list[idx];
> > >               val =3D riscv_pmu_ctr_read_csr(info.csr);
> > >               if (IS_ENABLED(CONFIG_32BIT))
> > >                       val =3D ((u64)riscv_pmu_ctr_read_csr(info.csr +=
 0x80)) << 31 | val;
> > > --
> > > 2.34.1
> > >

