Return-Path: <kvm+bounces-4641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2061E815C9A
	for <lists+kvm@lfdr.de>; Sun, 17 Dec 2023 00:54:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 52C881C21349
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 23:54:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B81F381A4;
	Sat, 16 Dec 2023 23:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="wNqrlGwC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB4937D17
	for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 23:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-50e3213cce0so232209e87.0
        for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 15:54:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1702770863; x=1703375663; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WntJQyn9d0EfCk0SDSkeTZwQkNZHb3LF+mvl4Xb0xIU=;
        b=wNqrlGwC3Sf+PGExqMprov2He6/QVoAfCREWXLMHLXBNgbdhd4fMjmD6zmG9Iy00Q7
         d3DUp1fLli3E1l974m3DhCegxkNY7kkumSX8akgCQss4GpuNrhHjPJBUJdyETRcGpOeX
         6zbHOmzQMJbHKGx0EYJE8XR0eU5Kmr1u9VumobVNk14AfC6leaN/KKODGpml+Beu/AOH
         yVYsazmfP8d4K+pIVF6ZPxl7DqM9obhHJyQSV/iwlRX5KWBMwEMlRwvujBggKPbyffnG
         cpaYFlkwLeYw2gzJueSXplWLad0eId7LpSYxKFezeKwbv4Os0ZIJsnGVpCat/gDxu68U
         pMSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702770863; x=1703375663;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WntJQyn9d0EfCk0SDSkeTZwQkNZHb3LF+mvl4Xb0xIU=;
        b=pqQGo1pGiR1EeXfYsHthNv7hk8tlsN5qvGkbLzem8+1B5+nryCEARKxtWT0bnxx7Nc
         J9o6PXyh/8XdWcY81lrvoHXJhSu/lHZGnflKyvrCodXh43ny/VaXdF7GOdTpB4uVM16V
         kk+94Sii3Zt0CwtB9M6hYXHSya2y2GMT1WetsQwub6eQggS7ChBqBdLKUGCIKiZFsDyD
         BIR2O7iI1VKW2rpw4N0zb5lpTUBcB5vFNhO8JEvreUqkh+qIRN34SAOXnBaUvYc5aj2h
         A7fsDCYq7p1QAn6XHL60Ab2Oht7NCG+xD2Ef0wA3GTflY/90VZ6ouIo3bwiFeyNpsYAu
         nMzQ==
X-Gm-Message-State: AOJu0YyjPN0iyP9fYtkuqOKwBCfkY9XgVLt1HP8lfD+f+Hs23v7F5IG2
	dkx65j/4XneijHJUEnmEwrhKU+dta7BHYqyctPARTA==
X-Google-Smtp-Source: AGHT+IE1/jRA2wUT3JVq0cBsvdnJ3jWI+itVMLElTEFYL5LSRsq0y7RSLiNPanS6wpM7Qe6VZVATfsJEmkHB+pXeq3Q=
X-Received: by 2002:a05:6512:b9c:b0:50c:180:2162 with SMTP id
 b28-20020a0565120b9c00b0050c01802162mr7539695lfv.99.1702770862548; Sat, 16
 Dec 2023 15:54:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231205024310.1593100-1-atishp@rivosinc.com> <20231205024310.1593100-3-atishp@rivosinc.com>
 <20231207-professed-component-84128c06befa@wendy> <CAAhSdy1vqGHeEMStu8Ft2Cz-_c=9e8ciwo9nBh=CDnEejEvp9w@mail.gmail.com>
In-Reply-To: <CAAhSdy1vqGHeEMStu8Ft2Cz-_c=9e8ciwo9nBh=CDnEejEvp9w@mail.gmail.com>
From: Atish Kumar Patra <atishp@rivosinc.com>
Date: Sat, 16 Dec 2023 15:54:11 -0800
Message-ID: <CAHBxVyFZvXo8pDLz_6jbowQt49N377WaRif55ZdQoq_WB5NTgg@mail.gmail.com>
Subject: Re: [RFC 2/9] drivers/perf: riscv: Add a flag to indicate SBI v2.0 support
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

On Thu, Dec 14, 2023 at 4:16=E2=80=AFAM Anup Patel <anup@brainfault.org> wr=
ote:
>
> On Thu, Dec 7, 2023 at 5:39=E2=80=AFPM Conor Dooley <conor.dooley@microch=
ip.com> wrote:
> >
> > On Mon, Dec 04, 2023 at 06:43:03PM -0800, Atish Patra wrote:
> > > SBI v2.0 added few functions to improve SBI PMU extension. In order
> > > to be backward compatible, the driver must use these functions only
> > > if SBI v2.0 is available.
> > >
> > > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> >
> > IMO this does not make sense in a patch of its own and should probably
> > be squashed with the first user for it.
>
> I agree. This patch should be squashed into patch4 where the
> flag is first used.
>

Done. Thanks.


> Regards,
> Anup
>
> >
> > > ---
> > >  drivers/perf/riscv_pmu_sbi.c | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > >
> > > diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sb=
i.c
> > > index 16acd4dcdb96..40a335350d08 100644
> > > --- a/drivers/perf/riscv_pmu_sbi.c
> > > +++ b/drivers/perf/riscv_pmu_sbi.c
> > > @@ -35,6 +35,8 @@
> > >  PMU_FORMAT_ATTR(event, "config:0-47");
> > >  PMU_FORMAT_ATTR(firmware, "config:63");
> > >
> > > +static bool sbi_v2_available;
> > > +
> > >  static struct attribute *riscv_arch_formats_attr[] =3D {
> > >       &format_attr_event.attr,
> > >       &format_attr_firmware.attr,
> > > @@ -1108,6 +1110,9 @@ static int __init pmu_sbi_devinit(void)
> > >               return 0;
> > >       }
> > >
> > > +     if (sbi_spec_version >=3D sbi_mk_version(2, 0))
> > > +             sbi_v2_available =3D true;
> > > +
> > >       ret =3D cpuhp_setup_state_multi(CPUHP_AP_PERF_RISCV_STARTING,
> > >                                     "perf/riscv/pmu:starting",
> > >                                     pmu_sbi_starting_cpu, pmu_sbi_dyi=
ng_cpu);
> > > --
> > > 2.34.1
> > >

