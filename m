Return-Path: <kvm+bounces-90-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 316717DBD8F
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 17:13:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2215CB20F6F
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 16:13:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19EAC18E11;
	Mon, 30 Oct 2023 16:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kNeNHzK1"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6567A18C18
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 16:12:57 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 730C0C5
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 09:12:55 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a7af53bde4so45605837b3.0
        for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 09:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698682374; x=1699287174; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Tgkw7eW9dhnk+knrp7jJaqDTfZMev9xwF7TYvvMUsbc=;
        b=kNeNHzK1Sz8aeXqqKEvpbAb68aFVu1cPCqsiiJ2Dk5nqBE8kZYoB6bLegGvN5z67N3
         4vH+PUUME3MJxSCsJybvOeO8FPA2ANuh5XluvW0rg1Xj960dj7adVpAwWe9EK5qartPJ
         r64aSEzAT5AF/Rc1L5bixs6YJO9sxE1iqmJN5HGMCWRZGgQSEdF9b5hH10UiwIPd7S4Z
         ++c3NchvC+MXcwms1XNUJnfyFcVwnlxeaILjvLSb0G8GG+OWlPab7jKXg/kQVYfL4hkK
         0aVY1yD9qFv0DEHpuHcN17a34m0lJLVZ/jLuJUtpZpMsXmI5vAhZZwdNJvmC9aIaGOmV
         z2Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698682374; x=1699287174;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Tgkw7eW9dhnk+knrp7jJaqDTfZMev9xwF7TYvvMUsbc=;
        b=anYEpGpKoC7JtF1VnkesWNcB3Z4ps8O/9gTtrUQOZH4NJbN1wGrQ47cqMkxjnRet0X
         DG5PNRF0785S3kKsDpzPCXYemUQmLv14S6paPUokWOFuhvqJsvE9Kib0l56Jr4dhvUlv
         YHhqfB3JcRP6hyKk3NyAb/luFF5+o8ZK6qOQ7im9DSmXnwVpOAHJ4Mo/1jNAkIR40pvm
         HJC2t4nQHr9Oo+oh45XpeqQ4tTvwdhjTeXl9FBIDuiJrWqhVAJ2WMW0XnTRruKYYZjxs
         ZItp457eyXt8wbNS/p9qkpChhQN/pZFd+PubqJXQS2xmJjFC0KRv623cEXCpBsO28s2W
         Ex7A==
X-Gm-Message-State: AOJu0YxQvwSx5gkE430qwGL9UIjGjxOONUh01qxKJ2vQdn0i2FjN/1xk
	SXO2TOfUGEw8VCd2cFehweY+Hqg6HIE=
X-Google-Smtp-Source: AGHT+IHXERmhF1p7ZLDX+e5zNpxMNE30YgXaemlxnBQEovmUJpclQzlFIZqH7J8ykW6OvSDZcwj8yNLtP1w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:920b:0:b0:59b:f3a2:cd79 with SMTP id
 j11-20020a81920b000000b0059bf3a2cd79mr205625ywg.8.1698682374564; Mon, 30 Oct
 2023 09:12:54 -0700 (PDT)
Date: Mon, 30 Oct 2023 09:12:53 -0700
In-Reply-To: <20231029093928.138570-1-jose.pekkarinen@foxhound.fi>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231029093928.138570-1-jose.pekkarinen@foxhound.fi>
Message-ID: <ZT_WBanoip8zhxis@google.com>
Subject: Re: [PATCH] KVM: x86: replace do_div with div64_ul
From: Sean Christopherson <seanjc@google.com>
To: "=?utf-8?B?Sm9zw6k=?= Pekkarinen" <jose.pekkarinen@foxhound.fi>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, skhan@linuxfoundation.org, x86@kernel.org, 
	hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kernel-mentees@lists.linuxfoundation.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 29, 2023, Jos=C3=A9 Pekkarinen wrote:
> Reported by coccinelle, there is a do_div call that does
> 64-by-32 divisions even in 64bit platforms, this patch will
> move it to div64_ul macro that will decide the correct
> division function for the platform underneath. The output
> the warning follows:
>=20
> arch/x86/kvm/lapic.c:1948:1-7: WARNING: do_div() does a 64-by-32 division=
, please consider using div64_ul instead.
>=20
> Signed-off-by: Jos=C3=A9 Pekkarinen <jose.pekkarinen@foxhound.fi>
> ---
>  arch/x86/kvm/lapic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 3e977dbbf993..0b90c6ad5091 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1945,7 +1945,7 @@ static void start_sw_tscdeadline(struct kvm_lapic *=
apic)
>  	guest_tsc =3D kvm_read_l1_tsc(vcpu, rdtsc());
> =20
>  	ns =3D (tscdeadline - guest_tsc) * 1000000ULL;
> -	do_div(ns, this_tsc_khz);
> +	div64_ul(ns, this_tsc_khz);

Well this is silly, virtual_tsc_khz is a u32.

	unsigned long this_tsc_khz =3D vcpu->arch.virtual_tsc_khz;

struct kvm_vcpu_arch {=20

	...

	u32 virtual_tsc_khz;

}

I assume this will make coccinelle happy?

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 245b20973cae..31e9c84b8791 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1932,7 +1932,7 @@ static void start_sw_tscdeadline(struct kvm_lapic *ap=
ic)
        u64 ns =3D 0;
        ktime_t expire;
        struct kvm_vcpu *vcpu =3D apic->vcpu;
-       unsigned long this_tsc_khz =3D vcpu->arch.virtual_tsc_khz;
+       u32 this_tsc_khz =3D vcpu->arch.virtual_tsc_khz;
        unsigned long flags;
        ktime_t now;
=20


