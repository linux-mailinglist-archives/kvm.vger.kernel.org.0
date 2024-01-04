Return-Path: <kvm+bounces-5621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B60C823BC6
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 06:30:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1968D287F37
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 05:30:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66FFA18E03;
	Thu,  4 Jan 2024 05:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="yMNjrg76"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253DA18640
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 05:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-36066190a99so377885ab.3
        for <kvm@vger.kernel.org>; Wed, 03 Jan 2024 21:30:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1704346237; x=1704951037; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F2ixpTVJPJvqrYlOE9jVUVHqg8qaW8lY49AbVHVK/go=;
        b=yMNjrg76cK/mWnUrjF8eugEM7vhu5fw+/udWph8jO/LnUf9U9dFzztNGn/pCa+do2B
         PTIJEYeF1WmRX+THKuqmMaGWmo/Wf2uohGuqXspw3GHXEqSCeDS4QDYhf+z+AV+sUVLJ
         axAxU5ZnTFE10d8LQngcyYkyhJLLYpDV0ObxpZ65F8lk28Sg+i04bB2F9S7TWSIHv3+0
         9YeQehxrWnEirgXgBZfXpHgRj/lZgAuI/DTnleex3og4CQiU81Jn1wUV6q2TfbWh6qxv
         ubd/suQRQJcWL9uXH6pMgX3pFJaCEsbAgtzMIdUExkbB1kidWFiFBdiOwqSMGAN5Lsql
         96Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704346237; x=1704951037;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F2ixpTVJPJvqrYlOE9jVUVHqg8qaW8lY49AbVHVK/go=;
        b=AtjwkUaq4EX3IF3JYPrF24Z5W4231NMQx+L1aOSzCqvGLqsS1G2mR78euD2CFqCPW/
         sI0+5lZJ11WSXPiVXRp6mQr9zNOwnP6YoB4eBdHBqTgF6PmJpW7OmOOYolB4BDxHpv5Q
         YnL4MMsKPg7tVId/qHnW8AdLdsyaMfj2gk90VXSCYNvNtB84Fo6n04QocXTF3yfWh2wK
         4O7OH7RkEsAoEOEc39xdfNiidbEgh/JF7lZLpKjTnJ7F+jRmONHqa6Pn/2+qBGJE9/8i
         JsOOdgmmy6LaRhHrMinNqzMRYKvWM5e8aLszcBDwQxC/tJjnSBTHwb1g5D1LDscA3Pf6
         DCoQ==
X-Gm-Message-State: AOJu0Yy/ERlEcGj76lSLujpcCLHXd6co1eW1y4RjufpsPNU7ReVDLVSc
	GO+nebjKADnaDTIzFe1uLEUoXXvGgHslE5WxKAYec7t17PoYqw==
X-Google-Smtp-Source: AGHT+IHGGBS0cD3yh40wy6CQgR75OfbGKBNuVs6ng214otd0OCP2GlKFDQSVXB8H0pgPPvYpTYPaOj16OfVLcHNEKm0=
X-Received: by 2002:a05:6e02:1d83:b0:35f:a33f:a181 with SMTP id
 h3-20020a056e021d8300b0035fa33fa181mr121135ila.15.1704346237045; Wed, 03 Jan
 2024 21:30:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy1QsMuAmr+DFxjkf3a2Ur91AX9AnddRnBHGM6+exkAn1g@mail.gmail.com>
 <CABgObfZN4_xvOHr8aukZZGZj5teWZ7rt5RJU5Y0YFewQk19FRw@mail.gmail.com> <20240102-c07d32a585f11ee80bd7b70b@orel>
In-Reply-To: <20240102-c07d32a585f11ee80bd7b70b@orel>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 4 Jan 2024 11:00:25 +0530
Message-ID: <CAAhSdy2_STfVNb6PB0o-hW+rn-K+U5BcYJWJO3m8vbeQEQ9BFw@mail.gmail.com>
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

On Wed, Jan 3, 2024 at 1:55=E2=80=AFAM Andrew Jones <ajones@ventanamicro.co=
m> wrote:
>
> On Tue, Jan 02, 2024 at 07:24:26PM +0100, Paolo Bonzini wrote:
> > On Sun, Dec 31, 2023 at 6:33=E2=80=AFAM Anup Patel <anup@brainfault.org=
> wrote:
> > >
> > > Hi Paolo,
> > >
> > > We have the following KVM RISC-V changes for 6.8:
> > > 1) KVM_GET_REG_LIST improvement for vector registers
> > > 2) Generate ISA extension reg_list using macros in get-reg-list selft=
est
> > > 3) Steal time account support along with selftest
> >
> > Just one small thing I noticed on (3), do you really need cpu_to_le64
> > and le64_to_cpu on RISC-V? It seems that it was copied from aarch64.
> > No need to resend the PR anyway, of course.
>
> While Linux/KVM is only LE, the arch doesn't prohibit S-mode being
> configured to use BE memory accesses, so I kept the conversions. They
> at least provide some self-documenting of the code. The biggest
> problem with them, though, is that I didn't use __le64 types and now
> sparse is yelling at me. I patched that this morning, but didn't get
> a chance to post yet. I could instead rip out the conversions to
> quiet sparse, if that would be preferred.

The SBI spec is quite explicit about endianness of data in shared
memory. Also, the RISC-V priv spec allows BE load/store operations
so eventually we might see BE platforms. I suggest keeping the LE
conversion macros and __le32/__le64 data types.

Regarding the sparse errors, Drew can send fix patches which I
will include in the second PR for 6.8.

I hope this is okay.

Regards,
Anup

