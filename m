Return-Path: <kvm+bounces-5870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE257827E9B
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 07:02:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 593D5284B8D
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 06:02:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 521D379D4;
	Tue,  9 Jan 2024 06:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="WBFG7GGv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6BBA63B9
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 06:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3606c7a4cb5so22219455ab.3
        for <kvm@vger.kernel.org>; Mon, 08 Jan 2024 22:02:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1704780136; x=1705384936; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SC3vgopQgjhiGDVg61h7B4FeTMOwECveBgS++xiO8eY=;
        b=WBFG7GGvM3XBNR/M7iEsFJv6A/y3rb0NCkbfBbIh5ikXEUepcHVlVwS4R6/qCcxSb7
         0FhnBTA+k9lvZd3O2oPtTsA3xyWAq24Lak3nVCnYTQQAjCe4QEi7coT5XAAJnh4+1j2U
         QJTJbIF+Tr03qw04X5ee4abGDGWz3xlzds+zmWFJ9Ljk+200OmMDN8FP9ugigXkeFSyo
         0D8W9dervWEc3hoRBcMucKaor6QvMpHBLCTnVLLwQ7bjmuChKxNrWHcL1tS+aB/JR/4p
         5MFI8BpZnXN9WTKbSPpMk2VprhLRMcY6yJOQpMWMuKdCoRBqbDspRrR8xykXJeDb12C0
         1X3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704780136; x=1705384936;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SC3vgopQgjhiGDVg61h7B4FeTMOwECveBgS++xiO8eY=;
        b=wRhVfMt6+FFfpgGe3wYPqWC7QhyG45/2dFfUt3sWORMdCSolf8F1cfpv22NHCx/MiS
         hfMUFh4UyrSsFm6UUatXe5Anokf8t+h5sg7TrVQdbs0qywOhAQjQ/k3BM/T/c/2PKjdH
         pvXapx5AEYEkDWNVCoczrAXFjfw+zDKEvjyH/SHxsiGMUhW+6FnIrwTdlIgfRZNWKwn4
         Q0z1FSl3nsUrmk1MMBRmkF1eJyIJJNbmREYpw3fLdofG5696onaFmjl1G3PYp/oTSXoG
         7gnLxDh+QJJV3lTbEirh1LQi7hG2f2rtlJQjlRCnTUNS4cjIYKcwWAxrpnX6J6p20yHV
         9D4A==
X-Gm-Message-State: AOJu0YxU4u4ooA7wK7hnzIxfnl2ANNTqUAfHq34ozbKe+Chq42UtTZ8X
	NjsSbQCnOC3l2fjR2FX83FTegzBC5pfWiVAJsg0w9yPAXOzqlA==
X-Google-Smtp-Source: AGHT+IFA0x43cfGZLFFEgvDfSne2HckKcDx43xjiVRe/8xM5bLM0cMYAEPSjP4WKy2beNi8IBKBA4NKXiFrZYks/3V4=
X-Received: by 2002:a05:6e02:17c6:b0:360:976f:d0b8 with SMTP id
 z6-20020a056e0217c600b00360976fd0b8mr1218628ilu.44.1704780135686; Mon, 08 Jan
 2024 22:02:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy1QsMuAmr+DFxjkf3a2Ur91AX9AnddRnBHGM6+exkAn1g@mail.gmail.com>
 <CABgObfZN4_xvOHr8aukZZGZj5teWZ7rt5RJU5Y0YFewQk19FRw@mail.gmail.com>
 <20240102-c07d32a585f11ee80bd7b70b@orel> <CAAhSdy2_STfVNb6PB0o-hW+rn-K+U5BcYJWJO3m8vbeQEQ9BFw@mail.gmail.com>
In-Reply-To: <CAAhSdy2_STfVNb6PB0o-hW+rn-K+U5BcYJWJO3m8vbeQEQ9BFw@mail.gmail.com>
From: Anup Patel <anup@brainfault.org>
Date: Tue, 9 Jan 2024 11:32:05 +0530
Message-ID: <CAAhSdy0GO=5N2Fz0O-=xMqJ1ZK3GoqsW76kt8UevxhJRbEYmtw@mail.gmail.com>
Subject: Re: Re: [GIT PULL] KVM/riscv changes for 6.8 part #1
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Palmer Dabbelt <palmer@rivosinc.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@atishpatra.org>, 
	Atish Patra <atishp@rivosinc.com>, KVM General <kvm@vger.kernel.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Paolo,

On Thu, Jan 4, 2024 at 11:00=E2=80=AFAM Anup Patel <anup@brainfault.org> wr=
ote:
>
> Hi Paolo,
>
> On Wed, Jan 3, 2024 at 1:55=E2=80=AFAM Andrew Jones <ajones@ventanamicro.=
com> wrote:
> >
> > On Tue, Jan 02, 2024 at 07:24:26PM +0100, Paolo Bonzini wrote:
> > > On Sun, Dec 31, 2023 at 6:33=E2=80=AFAM Anup Patel <anup@brainfault.o=
rg> wrote:
> > > >
> > > > Hi Paolo,
> > > >
> > > > We have the following KVM RISC-V changes for 6.8:
> > > > 1) KVM_GET_REG_LIST improvement for vector registers
> > > > 2) Generate ISA extension reg_list using macros in get-reg-list sel=
ftest
> > > > 3) Steal time account support along with selftest
> > >
> > > Just one small thing I noticed on (3), do you really need cpu_to_le64
> > > and le64_to_cpu on RISC-V? It seems that it was copied from aarch64.
> > > No need to resend the PR anyway, of course.
> >
> > While Linux/KVM is only LE, the arch doesn't prohibit S-mode being
> > configured to use BE memory accesses, so I kept the conversions. They
> > at least provide some self-documenting of the code. The biggest
> > problem with them, though, is that I didn't use __le64 types and now
> > sparse is yelling at me. I patched that this morning, but didn't get
> > a chance to post yet. I could instead rip out the conversions to
> > quiet sparse, if that would be preferred.
>
> The SBI spec is quite explicit about endianness of data in shared
> memory. Also, the RISC-V priv spec allows BE load/store operations
> so eventually we might see BE platforms. I suggest keeping the LE
> conversion macros and __le32/__le64 data types.
>
> Regarding the sparse errors, Drew can send fix patches which I
> will include in the second PR for 6.8.
>
> I hope this is okay.
>

Friendly ping ?

Regards,
Anup

