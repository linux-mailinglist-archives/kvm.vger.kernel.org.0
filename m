Return-Path: <kvm+bounces-50297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A96DAE3BB2
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 12:07:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACD563A4014
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 10:04:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD3C2217730;
	Mon, 23 Jun 2025 10:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Hi/ggJub"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6D91953BB
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 10:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750673075; cv=none; b=W7Lyucdyq+N9HNJekIUhpM0jrj+jYE9K8yFvSTvX5rD3z2xih+tH+M6kCh7iCLGIIFzlAo7hoPm4b0K1HmE47nSwcx2mTkI20ESG6oZRZOJEgkNa74IrWs1IkWcfRT/5HHpYjK8Jow9nMw4ppuhK0tI7qGrl7WE6HLZmni4Gkvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750673075; c=relaxed/simple;
	bh=JQDW2gTsoLVK187JuY0wEWiF6jBFSRBP7iPLXBKcrBk=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=l/dw2zP1R3pgZr/POYdZhqskpgCPoTF56+s8e2mU3QeSSR65LinbuJnhG3SxlgHBtBCDx7qRRfnyhYsTHKBvSonGHB5wjcekk2s8borRTrFe1WFJxbVLS4eLWk/He5KBHprvxQvbA4Ic5byWbHfQ4Hiax3uDbrjzDyi74nu0STc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Hi/ggJub; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3a4eb4acf29so235088f8f.0
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 03:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1750673071; x=1751277871; darn=vger.kernel.org;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q72uVLN6Dd/lEgG34G+gl19V3OHTLM7bT/jbIRgpIbI=;
        b=Hi/ggJub9mtTLPb6UUgm9Vo42fb7WIis5vUo0kXcUjBHUkbFxRTD/vhqYcPpUnhy+o
         wTr3QviXRYrpVLK2XD08TuOEe+zK+K5FSahT89tah/UT52xMQBV/RJVNX66q70gKbgEU
         J9QMW0XFECw191RawhilpSlavFToBKgxTs+f5mrvK5twmrNfkLZ6IXlPgB3Y+0Zx5O2X
         FeSCTvlU6haoQVGfe/lKHXLoPnMbpm9gSMnFVS9jC7NeDSZzd9CSkHNn33lZPhBpZ3QF
         +jBPidHflxTiYZJZ0OiMw8yQPySeQ3OdmDNsVwk4NNk9kQS7znPBt8EO5uNs0qhBIqqQ
         Vozw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750673071; x=1751277871;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=q72uVLN6Dd/lEgG34G+gl19V3OHTLM7bT/jbIRgpIbI=;
        b=HwAvj8y8FzCLknFJfvNLjgWsUNLg9wNJAKVC1rKDqJUmPike6OyhaJFEo+GFIysacp
         QElTKJIlYN1tzqM8h4b09XER0F59UNYb+MfgU5OaXXB8WrUNUhLNyx3ecRqv8p4ZZvgV
         k/ZSMTyiFYdyDJmyQshxHkZ4GrQzAI8WhmTVCKzMHMhPQJ2cUVGkuXjrkqsbhKAi3svd
         Q623ni01RoYnPTpMi5kGYRU9+yaYuAOM0Mo6Sp8/azGD2v/ahVffM4GqncL7PJI697Aw
         omEbFK0tDNnWa2jXy/wZbGQPkZ+6nbv4HdzZyAyY7BxM23aCNSZMAMM/kcUC4YDUzZ4m
         rvSw==
X-Forwarded-Encrypted: i=1; AJvYcCXgUwGHQ8xTTZjhx+nc9ZyEuQYyTl/MGwS9F6mnWSy3KITpMBQ12gFygB8K5ocjvlv0meE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz83TJlZ/bVOix4Ev71BmsyQzNerhzGg+8civG18eNq4CD/6gQE
	SYjO6X95jVwQ7wxbuGz4RvJb0Pu31ZEpC9tU0l9vOsMM69dXkPtymFW2sLnx6su3NaQ=
X-Gm-Gg: ASbGnctrJlFcFhcvhzldAz6a5LZI5HRM7fxKyGv+jj2ecy3rnYSSqB71qumCCBVAVyG
	uDSxALOGlnn4O213ORfzo2dzTSXmBRqXWhunPuXnX+Fq8WyWbt0OAru4DUMZLyZx+2SrGG7N4sZ
	5nN99soK78/nWVWm/IxQ9V7m/rs3qjE/UicVNwTkjcfX9CYzcvYmL7ih3lQc41JgahGu/8VMaQF
	oshRr+SbK4bDM4rSAnxocyA+F0V7q5PwFuZJJ7ywMwgcMgxFEUWxCLr/aB7013yPMS/+iePz+NB
	RINJvfcQ9ziwvVrVbQPxCpFhop1gZZNEbRFl/hCJ6EZVo3S0BrAxpDKIwXIoqjoKOBg=
X-Google-Smtp-Source: AGHT+IFs2pQCa+3bKTkdor2w3FPfdSYUbedMYRtHjGttAZlhUfRN/r/Qxtzp7NLRxL4SrXakOUW0PA==
X-Received: by 2002:a05:6000:24c8:b0:3a4:e193:e6e7 with SMTP id ffacd0b85a97d-3a6d12e995amr3291773f8f.5.1750673071422;
        Mon, 23 Jun 2025 03:04:31 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200:8947:973b:de:93b7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d0f19f9esm9077130f8f.39.2025.06.23.03.04.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jun 2025 03:04:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 23 Jun 2025 12:04:30 +0200
Message-Id: <DATTT5U64J4L.3UTDRVT2YP7GT@ventanamicro.com>
Subject: Re: [External] Re: [PATCH] RISC-V: KVM: Delegate illegal
 instruction fault
Cc: <anup@brainfault.org>, <atish.patra@linux.dev>,
 <paul.walmsley@sifive.com>, <palmer@dabbelt.com>, <aou@eecs.berkeley.edu>,
 <alex@ghiti.fr>, <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
 <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
 "linux-riscv" <linux-riscv-bounces@lists.infradead.org>
To: "Xu Lu" <luxu.kernel@bytedance.com>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
References: <20250620091720.85633-1-luxu.kernel@bytedance.com>
 <DARCHDIZG7IP.2VTEVNMVX8R1E@ventanamicro.com>
 <CAPYmKFvcnDJWXAUEX8oY6seQrgwKiZjDqrJ_R2rJ4kWq7RQUSg@mail.gmail.com>
In-Reply-To: <CAPYmKFvcnDJWXAUEX8oY6seQrgwKiZjDqrJ_R2rJ4kWq7RQUSg@mail.gmail.com>

2025-06-22T18:11:49+08:00, Xu Lu <luxu.kernel@bytedance.com>:
> Hi Radim,
>
> On Fri, Jun 20, 2025 at 8:04=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrc=
mar@ventanamicro.com> wrote:
>>
>> 2025-06-20T17:17:20+08:00, Xu Lu <luxu.kernel@bytedance.com>:
>> > Delegate illegal instruction fault to VS mode in default to avoid such
>> > exceptions being trapped to HS and redirected back to VS.
>> >
>> > Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
>> > ---
>> > diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/as=
m/kvm_host.h
>> > @@ -48,6 +48,7 @@
>> > +                                      BIT(EXC_INST_ILLEGAL)    | \
>>
>> You should also remove the dead code in kvm_riscv_vcpu_exit.
>
> I only want to delegate it by default. And KVM may still want to
> delegate different exceptions for different VMs like what it does for
> EXC_BREAKPOINT.

(I think we could easily reintroduce the code if KVM wants to do that in
 the future.  I also think that it's bad that this patch is doing an
 observable change without userspace involvement -- the counting of KVM
 SBI PMU events, but others will probably disagree with me on this.)

>                 So maybe it is better to reserve these codes?

Possibly, the current is acceptable if you have considered the
implications on PMU events.

>> And why not delegate the others as well?
>> (EXC_LOAD_MISALIGNED, EXC_STORE_MISALIGNED, EXC_LOAD_ACCESS,
>>  EXC_STORE_ACCESS, and EXC_INST_ACCESS.)
>
> Thanks for the reminder. I will have a test and resend the patch if it wo=
rks.

The misaligned exceptions are already being worked on, so don't waste
your time on them, sorry.

