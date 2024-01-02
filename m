Return-Path: <kvm+bounces-5456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 100FE8220F3
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 19:24:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A253C1F22B79
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 18:24:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C58DC15ACC;
	Tue,  2 Jan 2024 18:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ApVH9yAQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B035815AC0
	for <kvm@vger.kernel.org>; Tue,  2 Jan 2024 18:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704219879;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YGtRjZmMmbNMYMYyioQRov4waYs86YugI8J9gTbyhEE=;
	b=ApVH9yAQG/TCII7IHBYtOsOPztGjtAl93s3Sfxvt4/47rsY/oQF1QvTYfCDvbSliVu1jMs
	CgRlZlfrAzrKZp+fgvteAduk21kDCs9HRw7sugXWnSh1OkLPokdiv95syNuj9xojMKr5GU
	Uf7XvMj5oVpGqMo1dTqJExHUV++1puQ=
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com
 [209.85.222.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-46-HxoiXWAjP5CHJBEavdjTWQ-1; Tue, 02 Jan 2024 13:24:38 -0500
X-MC-Unique: HxoiXWAjP5CHJBEavdjTWQ-1
Received: by mail-ua1-f71.google.com with SMTP id a1e0cc1a2514c-7cc3e45ef28so1851900241.2
        for <kvm@vger.kernel.org>; Tue, 02 Jan 2024 10:24:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704219878; x=1704824678;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YGtRjZmMmbNMYMYyioQRov4waYs86YugI8J9gTbyhEE=;
        b=l2zfwSprgiERKZ51LG3kcUXD6pNhjpTy0/Jo9xJr/A5pnSZlmL4rOHlDzqgUiizK/I
         GWyuLB1el13OeAXcodR2juceHPFvuHWnC6Eu34z0DJyplWb4NEjWe5XHpJ+4i1V5rqZS
         fOCHUXZ5cPPMkLyiudKVrRtVEoOpJkYghRAa+dC8CpKxDL5tDVwuSC5OFJoEoThSIXvk
         3Bop9Bb+GMZIoFBjk5GWldr/W9QrJPkF4/gFaWzX1aflVvXBFLjk0jVW5t/CFdCst3c9
         OILsdW13s6LZZYAxD/RPWP9qeB6sZJ/TrRcbYNCiKPT9/JvMEY6dv9KeudD5exmD45/g
         aBrw==
X-Gm-Message-State: AOJu0Yynx+B2+F4ReYgoeuPqgYyNLzbGZGgITiwqg/abj5NMPhV60Oqx
	DiT0yqHOb8jFeiCWwqEmrpQX4+ddlopL3fcF991hOlXyYqkvbu7B4+dtKifiaO2yRkCL2VVKj1u
	MHfJ1L+E5hkpMChvvFYPDZR7rIU+OxcShiEVm
X-Received: by 2002:a05:6102:10cd:b0:466:fc84:fc42 with SMTP id t13-20020a05610210cd00b00466fc84fc42mr6218398vsr.61.1704219877813;
        Tue, 02 Jan 2024 10:24:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHcEme0AwBsq2SkjvHwA5uTApX5CHKYtaxllcpJVnvL9RqA3a3vL5jSdm4AW4mhRpHLFagdJZOmrzHqOkhuoVA=
X-Received: by 2002:a05:6102:10cd:b0:466:fc84:fc42 with SMTP id
 t13-20020a05610210cd00b00466fc84fc42mr6218396vsr.61.1704219877601; Tue, 02
 Jan 2024 10:24:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy1QsMuAmr+DFxjkf3a2Ur91AX9AnddRnBHGM6+exkAn1g@mail.gmail.com>
In-Reply-To: <CAAhSdy1QsMuAmr+DFxjkf3a2Ur91AX9AnddRnBHGM6+exkAn1g@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 2 Jan 2024 19:24:26 +0100
Message-ID: <CABgObfZN4_xvOHr8aukZZGZj5teWZ7rt5RJU5Y0YFewQk19FRw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.8 part #1
To: Anup Patel <anup@brainfault.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Palmer Dabbelt <palmer@rivosinc.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@atishpatra.org>, 
	Atish Patra <atishp@rivosinc.com>, KVM General <kvm@vger.kernel.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 31, 2023 at 6:33=E2=80=AFAM Anup Patel <anup@brainfault.org> wr=
ote:
>
> Hi Paolo,
>
> We have the following KVM RISC-V changes for 6.8:
> 1) KVM_GET_REG_LIST improvement for vector registers
> 2) Generate ISA extension reg_list using macros in get-reg-list selftest
> 3) Steal time account support along with selftest

Just one small thing I noticed on (3), do you really need cpu_to_le64
and le64_to_cpu on RISC-V? It seems that it was copied from aarch64.
No need to resend the PR anyway, of course.

> Please pull.
>
> Please note that I will be sending another PR for 6.8 which will
> include two more changes:
> 1) KVM RISC-V report more ISA extensions through ONE_REG
> 2) RISC-V SBI v2.0 PMU improvements and Perf sampling in KVM guest
>
> Two separate PRs are because #1 (above) depends on a series
> merged by Palmer for 6.8 and #2 (above) requires little more testing.
> I hope you are okay with two separate PRs for 6.8.

Yes, sure. The more the merrier. :)  If you want to send only #1, that
may be better?

Paolo


