Return-Path: <kvm+bounces-5186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CC87E81D055
	for <lists+kvm@lfdr.de>; Sat, 23 Dec 2023 00:09:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 80F731F2288E
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 23:09:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B93D533CDF;
	Fri, 22 Dec 2023 23:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QtKoudaa"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8D333CD5
	for <kvm@vger.kernel.org>; Fri, 22 Dec 2023 23:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703286570;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7QxUgPvjQkB1j5kGIAmIR0AepcZoAE0LvukWZgzWxmA=;
	b=QtKoudaaWkIL1PVZgkbGen7XUS0DWZmN8RyZ21yFTdPfLdmpdDh1jgse/9oOOa7X0B2JGa
	y8GXvPfh7jy4cfwVeTWiAkl9sWN3njwLla+ssOjqUcBcHbxX9Mx7HdCM8mozGrj/2mn9JH
	XCaziTZR3AUU5wMuDPhJ9cvDkjZRoVw=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-459-EXGk5dQVMFODRtPa3a7KrA-1; Fri, 22 Dec 2023 18:09:28 -0500
X-MC-Unique: EXGk5dQVMFODRtPa3a7KrA-1
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-6dbac6bb6b6so2515526a34.1
        for <kvm@vger.kernel.org>; Fri, 22 Dec 2023 15:09:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703286567; x=1703891367;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7QxUgPvjQkB1j5kGIAmIR0AepcZoAE0LvukWZgzWxmA=;
        b=Rd0K/IwJCQRHf5+elWBuzeGfIksBqBQDkydth+GI5YHay2+8Q8Jl1sf3ZIBA/tX3ul
         XZA1ENFViqq2/bnbeDr47SrkPLGl0GYCXcYQTzyXHzfoSKECqY+FVG0nvyTxArWslIRs
         Ob2wFaCJ6Qas2NcGPYCSobsH/DzI1x9oaTvvm4++WKDiWHctkp5wl+UR9D+Htj5ezGj9
         PMggw+Edp+IPLqN0owyPfFKtSmhkHOaijibu7/fOscN4n+cylzFZvnTuY+OVzYGgdmQz
         klqt3m0hA9YmMx+C9emD4vWDS3za3KpRpxByKTjgqg5yUtX9DxLbSGoOcXiNIlsHAoEs
         Y6og==
X-Gm-Message-State: AOJu0YyL1TbRJq+hgoTvYjCan0MMckzQUx4h0f6MSz6r/jvYBAJHB+Jo
	CMYXUUeXqP1au+pQfHDkwJovcPj5yPZvVq3TTWzlrGdvphoavMOVuw7ASy6HA7Ue/afwtaGTptf
	XIen7AkzK2+hkqP561smsJjPWhozJlvAxaiL/
X-Received: by 2002:a9d:62d9:0:b0:6db:d447:f5bd with SMTP id z25-20020a9d62d9000000b006dbd447f5bdmr185282otk.65.1703286567053;
        Fri, 22 Dec 2023 15:09:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFg9Yq1vo5iEsrWiv/QXqse3NghlwvPYK7/Mb/xVU6UpOEZcBLlscdLZBz2qpkJVWSDtgZNAWhFc0mk5T6/low=
X-Received: by 2002:a9d:62d9:0:b0:6db:d447:f5bd with SMTP id
 z25-20020a9d62d9000000b006dbd447f5bdmr185274otk.65.1703286566842; Fri, 22 Dec
 2023 15:09:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy3Rc+vub65qJ4JNngp5qTgm7YpsJCHZy+ff0=TN_ir03g@mail.gmail.com>
In-Reply-To: <CAAhSdy3Rc+vub65qJ4JNngp5qTgm7YpsJCHZy+ff0=TN_ir03g@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 23 Dec 2023 00:09:15 +0100
Message-ID: <CABgObfZuK+QcqBMQSU1ReXPBsHJvmXrwu8HxvUNhLVTqR4RWDw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv fixes for 6.7, take #1
To: Anup Patel <anup@brainfault.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Palmer Dabbelt <palmer@rivosinc.com>, 
	Atish Patra <atishp@atishpatra.org>, Atish Patra <atishp@rivosinc.com>, 
	Andrew Jones <ajones@ventanamicro.com>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 15, 2023 at 6:14=E2=80=AFPM Anup Patel <anup@brainfault.org> wr=
ote:
>
> Hi Paolo,
>
> We have two fixes for 6.7. Out of these, one fix is related to
> race condition in updating IMSIC swfile and second fix is
> for default prints in get-reg-list sefltest.
>
> Please pull.

Pulled, thanks.

Paolo

> Regards,
> Anup
>
> The following changes since commit a39b6ac3781d46ba18193c9dbb2110f31e9bff=
e9:
>
>   Linux 6.7-rc5 (2023-12-10 14:33:40 -0800)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-riscv/linux.git tags/kvm-riscv-fixes-6.7-1
>
> for you to fetch changes up to 4ad9843e1ea088bd2529290234c6c4c6374836a7:
>
>   RISCV: KVM: update external interrupt atomically for IMSIC swfile
> (2023-12-13 11:59:52 +0530)
>
> ----------------------------------------------------------------
> KVM/riscv fixes for 6.7, take #1
>
> - Fix a race condition in updating external interrupt for
>   trap-n-emulated IMSIC swfile
> - Fix print_reg defaults in get-reg-list selftest
>
> ----------------------------------------------------------------
> Andrew Jones (1):
>       KVM: riscv: selftests: Fix get-reg-list print_reg defaults
>
> Yong-Xuan Wang (1):
>       RISCV: KVM: update external interrupt atomically for IMSIC swfile
>
>  arch/riscv/kvm/aia_imsic.c                       | 13 +++++++++++++
>  tools/testing/selftests/kvm/riscv/get-reg-list.c | 10 ++++++----
>  2 files changed, 19 insertions(+), 4 deletions(-)
>


