Return-Path: <kvm+bounces-5875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2106C82852C
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 12:34:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7234CB24693
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 11:34:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADBE7381AD;
	Tue,  9 Jan 2024 11:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aArYvIKP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67363381A2
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 11:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704800085;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GUN+/Kn6FQWRmlqVv9nbikCrbachpkInN5wWcNO9XHM=;
	b=aArYvIKPakj0xNjdQ4UhYnfb9lEYPu68fTgmwddKdf8CInb3dUAAh/VPcX8SlpOQGKssEV
	0gXG73lRbmSDH6Ta05+gQAtxWSqV7HjX2Vm5rS4v8uDUXmq9PmVI+vRtEh2W/t5GZaduJ8
	3O8V7SYMPHnlLd2C0QWVsJCmBEJZl1U=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-209-kiD3lzocO72W3KoLRifz4A-1; Tue, 09 Jan 2024 06:34:43 -0500
X-MC-Unique: kiD3lzocO72W3KoLRifz4A-1
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-5e7ac088580so48655927b3.1
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 03:34:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704800083; x=1705404883;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GUN+/Kn6FQWRmlqVv9nbikCrbachpkInN5wWcNO9XHM=;
        b=HNTZ0AhQDfGFPxXnuwPjAtOSLaLGXeQRZJUvXAq2iXxpK3F9FQR4l7ipnIgPFZPL24
         yBggP5QpZJitIpkCWQvTn4LmL6i6oA1ociAL60RLLGtXlKSWG3wIkIRpYIHKtDwLvFbu
         CQpz5Sa1TeQToR3AS95VRoqpdAJ4Q9G18V7MrYJlkRkC40STAri+kXdk2QbBndY0/fgz
         r0IbIlK2ZY638FtKicGRECiu2G1NY+pfKY/MR6vUALer7xLWPFU0qSzVeh+t1Cgj4gfG
         exB8bYDM0ctQTNVvREOdnb5kat17BmrIKqKegz+1ODXwyWT35ZtOmJ7IYi36f+7SuBUs
         wR8g==
X-Gm-Message-State: AOJu0Yw6LuUXKNoLz8bpOoz76V0QKLOIkqGow2zXfBAu52mf56VNWzah
	qZkn19jhaFvKq96U2MVX6fHz2Moo/xUvKGuQyBZauinPk2DByeq6aZ6LxH4MAGqpqyFaJEk8f54
	9OBRmGshXe+r1EFpTmdnpAGNZT6DE5ost5ODk
X-Received: by 2002:a81:a151:0:b0:5ea:5573:78d6 with SMTP id y78-20020a81a151000000b005ea557378d6mr3086086ywg.33.1704800083392;
        Tue, 09 Jan 2024 03:34:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF1hcgt6oRHbR/RjEpDAqM7iEdTO4DnRabG9ZjF0lgirNmr9/Bpj6VCQkN0AmvDDe5uKzdDfwgU9scOEoBOq1g=
X-Received: by 2002:a81:a151:0:b0:5ea:5573:78d6 with SMTP id
 y78-20020a81a151000000b005ea557378d6mr3086079ywg.33.1704800083167; Tue, 09
 Jan 2024 03:34:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy1QsMuAmr+DFxjkf3a2Ur91AX9AnddRnBHGM6+exkAn1g@mail.gmail.com>
 <CABgObfZN4_xvOHr8aukZZGZj5teWZ7rt5RJU5Y0YFewQk19FRw@mail.gmail.com>
 <20240102-c07d32a585f11ee80bd7b70b@orel> <CAAhSdy2_STfVNb6PB0o-hW+rn-K+U5BcYJWJO3m8vbeQEQ9BFw@mail.gmail.com>
 <CAAhSdy0GO=5N2Fz0O-=xMqJ1ZK3GoqsW76kt8UevxhJRbEYmtw@mail.gmail.com>
In-Reply-To: <CAAhSdy0GO=5N2Fz0O-=xMqJ1ZK3GoqsW76kt8UevxhJRbEYmtw@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 9 Jan 2024 12:34:30 +0100
Message-ID: <CABgObfZnTRGYcACubYyjNesaiQD_6rE_utusbFANyvE3F6R7Sw@mail.gmail.com>
Subject: Re: Re: [GIT PULL] KVM/riscv changes for 6.8 part #1
To: Anup Patel <anup@brainfault.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Palmer Dabbelt <palmer@rivosinc.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@atishpatra.org>, 
	Atish Patra <atishp@rivosinc.com>, KVM General <kvm@vger.kernel.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 9, 2024 at 7:02=E2=80=AFAM Anup Patel <anup@brainfault.org> wro=
te:
> > > On Tue, Jan 02, 2024 at 07:24:26PM +0100, Paolo Bonzini wrote:
> > > > On Sun, Dec 31, 2023 at 6:33=E2=80=AFAM Anup Patel <anup@brainfault=
.org> wrote:
> > > > > We have the following KVM RISC-V changes for 6.8:
> > > > > 1) KVM_GET_REG_LIST improvement for vector registers
> > > > > 2) Generate ISA extension reg_list using macros in get-reg-list s=
elftest
> > > > > 3) Steal time account support along with selftest
> > > >
> > > > Just one small thing I noticed on (3), do you really need cpu_to_le=
64
> > > > and le64_to_cpu on RISC-V? It seems that it was copied from aarch64=
.
> > > > No need to resend the PR anyway, of course.
>
> Friendly ping ?

Hi, I had already pulled but I was waiting for the last x86 tests to
finish. Everything is now in kvm.git.

I'll send the PR to Linus once a bunch of conflicting trees have been pulle=
d.

Paolo


