Return-Path: <kvm+bounces-72991-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ANouFX18qmkqSQEAu9opvQ
	(envelope-from <kvm+bounces-72991-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 08:04:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4218721C418
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 08:04:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0134A3013FC2
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 07:04:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48C18372B39;
	Fri,  6 Mar 2026 07:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="JcGnauH/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4438120E6E2
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 07:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772780662; cv=pass; b=FLGwiAlSdmVx+ID6hyAPaz5gA0oki++3IPH9PBL99HItjZr8/wNqaWKs4nQeMzMe3SpuA1SgYE8Dlw9OvKpe2MeHrhLoUdCrmyUoJ1pCOda5wS/ODzYa1P04fYwX6io+1pzKICqWPEp6RpsPSc4KK3wVL1Rjg1z6tST/SUrgHSI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772780662; c=relaxed/simple;
	bh=lsFUimBeCGgmklTw1L3UbOz6SoEZi8IM6pklxGvk5YI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K41FRwJhR4SDytYrXWWDtLA60GK0nuSPGI2kgGrz0xEz/5LPeXAZ2KcPbXc+01yeOetumLX+liEBJLt7REomvPYJjjx53EkhRvNBfrG1B4SE7DoEuCWAEp28NcjKI/yRn6W6HEm4nmPNs8+ikKmkBN55GhwsgnFVc5hatIlqO+Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=JcGnauH/; arc=pass smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-45effa36240so6487776b6e.1
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 23:04:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772780660; cv=none;
        d=google.com; s=arc-20240605;
        b=SqbSCGrXaLZRYll++MSQsWNzGYGQDv/6ASPead57C6UQl+nfKYe/iPC0s5VF01EFbd
         jINiRZEHCNyMrvfDxX1Rb/Y2b+Q2N1DPjvBo6X60xvZvF2KvGrS1/cI5rpyag6APfYW3
         aTVJR0VNi/JjAS3qCjBOV9Jut8s0QK9OS4VG/9El4GqGCb7wU/5r4shDq34hU0IjB0sS
         QaAH06Vwb/4ItbtXgu4/M9sBgvn5yGsmvZB22cji3CPFKMjoYtnIZtnvC3je2qKQBBAX
         8T0QSPUEa47Kbm3osP9oUHxDQhh20RW0tJJ31xYTo6nZGcCta01VXlf2KR5fe5Y7LHBz
         Oz2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yREeU4CE/jhwdCxENgT8cCU88WTqOERvy7IPLNknu0s=;
        fh=BrnESQOsnRwLQGzq7kfPcnSBBvd2vjPI5ggBmayQip4=;
        b=kIqhuoVcz1FxGOLSTABuXLZtHRJtsLMEASPsxr92t3HxFmDXRjkIbWnZsJTDUdk/XM
         ea3R1fS28Fr0g2SFSmhnqi8EJkuPTv28vRuYwe9GGjNU3MQkjezhqFt8zdIVH0J5bStL
         ihu/9EmxsMqHqNSlDgcUCCBGP3mL4E1r6QGt3o+N9u/5EAug9MiBfoLNOLjpPPwBU32K
         CxMw//WG8HwolpKhBVHWgYOAodbHg3KmAWa6bGrPZAIXf9LfGcoPi9CiXYClCApWDW8E
         pYcpcv/F0y/N9w2DxY+xg0J8cVBKmIiyiFJrJZK4+gCxy+5wv/B5UPfvAbU7RnP8X3uk
         tCZg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1772780660; x=1773385460; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yREeU4CE/jhwdCxENgT8cCU88WTqOERvy7IPLNknu0s=;
        b=JcGnauH/ED44P0zpJan4LSxkA+6CBJO9JIwmBoT2WYcUiEWUOnyORkykLxyCew7QA3
         vjBbEhOjtfWpVBp9+r3zqSmNWEdB/2nralkgizyH8ylWNeJ3geWiDgzHS8TNbndeElvu
         uyUDMFPZMs9X1nwHjfQyuMwX9H/3YvdvKCM+1C98OtbB62z6t/WWCvZQ4iN2JRH0JX4U
         0Q2ZmVQ6YR93zfLlhe81r0VFEn2wbGrj2+hVJ1lJhVC0uwiNhFZcw6GHPFPHxAL0QASm
         XVeAZgS+a8JWjJWYcVfwfNY55dPP62oDR7u/2VQSaim7vHrQENPh2zlepfw3jMGYEzC2
         qJQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772780660; x=1773385460;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yREeU4CE/jhwdCxENgT8cCU88WTqOERvy7IPLNknu0s=;
        b=U1VJS5zsJDgWisQBqf1bcQCAO0yw6zXGXLVYYpVHa1b13bNvF1sDzIilLiugqMWGLP
         s3jgGfybQu7sTjinURjvPWA2xvCk782vtTYoy3TNGy5RPzoMObQXY/hAjdQDXAO5s8Jl
         2+EguKjYcIIv82EvzqmiHIqWuF6jlC3MV1NR7LL7aaSaw0d3h8lkAmoA6pdxlQOGz0Tg
         xgE1y2MiNWfsD/3FbD50gAxw9C/3rDOBCfpB5pgyWWrA3b5zaiQKKT/4RHGaz+ONabMX
         pAmXdtOa2m9PVdbPfxCKoDzwoOXZNutxkERMLUf2ZY1pp4UL9gdwxpMFu/HYNMBDPRpD
         qhcg==
X-Forwarded-Encrypted: i=1; AJvYcCW0K5KvArqNLV59FTlMP3p+IzV1WzbbxhRNFq2oeq4GdBMbbwFIreFdTgzXxnZIhKdTitg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6d+akjcUrxhjuL8a5q5u815lPvGu9Pn01ozggJlZ7txL6qfeW
	zdDsNaYhWGejLl30XuzeYZNBG0ByVmR5uKGTqj2bEuzA8KCsmA8NmD5A35mMeTaDN6UrQn1MgAy
	QUXpD0972KLm1qN7qQQAXnlLMGPl3Iq3AjgQnuuje+A==
X-Gm-Gg: ATEYQzyGq7k7ETrfwkYbHT3UcFNrX23MMfzfg4erwBkqS9S+r2ZcVCGDMHs3DTWWP5Y
	r4TO0wWZj1bgMqW9WDzXJKOij/X3J5m56GybRKqwC/bqr7DBoMzBTaOiGg1lxfvgSsdY1CJZKG6
	GAtVRJFFju2ss+1ISG1a2DW5Rzbsh8NLGpcxrwb1h/ThQS4Hk74PYjP+C+1kskVDuZlEiPC9oNw
	1e2nnRqVW1snMNLeyO9+4Rs3oSptmH4F08iv9Whcyk97u1R5Jb6AIG91Ee0ZUCtTtu2TX5n8wxB
	k9+P5oVmEXFPUwbJNJgqXECXZPjFTIKfs8CZ8fy3Y9+CK0c1bj4B97oDL6fKnmCyqAc5UO5jCSo
	EGj02IrcLjoYzgI00GOlyOMbbcQ==
X-Received: by 2002:a05:6820:1b05:b0:674:62e7:190f with SMTP id
 006d021491bc7-67b9bca7baamr925571eaf.17.1772780660047; Thu, 05 Mar 2026
 23:04:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260120080013.2153519-1-anup.patel@oss.qualcomm.com> <20260120080013.2153519-2-anup.patel@oss.qualcomm.com>
In-Reply-To: <20260120080013.2153519-2-anup.patel@oss.qualcomm.com>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 6 Mar 2026 12:34:08 +0530
X-Gm-Features: AaiRm533kBoYnXDCQRSDQXrP3bNbpBpz22jiDNqrmWLzZZYwaIGtUWbuuXDPWwo
Message-ID: <CAAhSdy2u3C2JyakhnSZxuSO2ecJsaz9DXWkRp96CArqHz4Ce9w@mail.gmail.com>
Subject: Re: [PATCH 01/27] RISC-V: KVM: Fix error code returned for Smstateen ONE_REG
To: Anup Patel <anup.patel@oss.qualcomm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Atish Patra <atish.patra@linux.dev>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>, 
	Shuah Khan <shuah@kernel.org>, Andrew Jones <andrew.jones@oss.qualcomm.com>, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4218721C418
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	R_DKIM_ALLOW(-0.20)[brainfault-org.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[brainfault.org];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-72991-lists,kvm=lfdr.de];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anup@brainfault.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[brainfault-org.20230601.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,qualcomm.com:email,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,brainfault-org.20230601.gappssmtp.com:dkim]
X-Rspamd-Action: no action

On Tue, Jan 20, 2026 at 1:30=E2=80=AFPM Anup Patel <anup.patel@oss.qualcomm=
.com> wrote:
>
> Return -ENOENT for Smstateen ONE_REG when:
> 1) Smstateen is not enabled for a VCPU
> 2) When ONE_REG id is out of range
>
> This will make Smstateen ONE_REG error codes consistent
> with other ONE_REG interfaces of KVM RISC-V.
>
> Fixes: c04913f2b54e ("RISCV: KVM: Add sstateen0 to ONE_REG")
> Signed-off-by: Anup Patel <anup.patel@oss.qualcomm.com>

Queued this as fix for Linux-7.0-rcX

Regards,
Anup

> ---
>  arch/riscv/kvm/vcpu_onereg.c | 18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
> index e7ab6cb00646..6dab4deed86d 100644
> --- a/arch/riscv/kvm/vcpu_onereg.c
> +++ b/arch/riscv/kvm/vcpu_onereg.c
> @@ -549,9 +549,11 @@ static inline int kvm_riscv_vcpu_smstateen_set_csr(s=
truct kvm_vcpu *vcpu,
>  {
>         struct kvm_vcpu_smstateen_csr *csr =3D &vcpu->arch.smstateen_csr;
>
> +       if (!riscv_isa_extension_available(vcpu->arch.isa, SMSTATEEN))
> +               return -ENOENT;
>         if (reg_num >=3D sizeof(struct kvm_riscv_smstateen_csr) /
>                 sizeof(unsigned long))
> -               return -EINVAL;
> +               return -ENOENT;
>
>         ((unsigned long *)csr)[reg_num] =3D reg_val;
>         return 0;
> @@ -563,9 +565,11 @@ static int kvm_riscv_vcpu_smstateen_get_csr(struct k=
vm_vcpu *vcpu,
>  {
>         struct kvm_vcpu_smstateen_csr *csr =3D &vcpu->arch.smstateen_csr;
>
> +       if (!riscv_isa_extension_available(vcpu->arch.isa, SMSTATEEN))
> +               return -ENOENT;
>         if (reg_num >=3D sizeof(struct kvm_riscv_smstateen_csr) /
>                 sizeof(unsigned long))
> -               return -EINVAL;
> +               return -ENOENT;
>
>         *out_val =3D ((unsigned long *)csr)[reg_num];
>         return 0;
> @@ -595,10 +599,7 @@ static int kvm_riscv_vcpu_get_reg_csr(struct kvm_vcp=
u *vcpu,
>                 rc =3D kvm_riscv_vcpu_aia_get_csr(vcpu, reg_num, &reg_val=
);
>                 break;
>         case KVM_REG_RISCV_CSR_SMSTATEEN:
> -               rc =3D -EINVAL;
> -               if (riscv_has_extension_unlikely(RISCV_ISA_EXT_SMSTATEEN)=
)
> -                       rc =3D kvm_riscv_vcpu_smstateen_get_csr(vcpu, reg=
_num,
> -                                                             &reg_val);
> +               rc =3D kvm_riscv_vcpu_smstateen_get_csr(vcpu, reg_num, &r=
eg_val);
>                 break;
>         default:
>                 rc =3D -ENOENT;
> @@ -640,10 +641,7 @@ static int kvm_riscv_vcpu_set_reg_csr(struct kvm_vcp=
u *vcpu,
>                 rc =3D kvm_riscv_vcpu_aia_set_csr(vcpu, reg_num, reg_val)=
;
>                 break;
>         case KVM_REG_RISCV_CSR_SMSTATEEN:
> -               rc =3D -EINVAL;
> -               if (riscv_has_extension_unlikely(RISCV_ISA_EXT_SMSTATEEN)=
)
> -                       rc =3D kvm_riscv_vcpu_smstateen_set_csr(vcpu, reg=
_num,
> -                                                             reg_val);
> +               rc =3D kvm_riscv_vcpu_smstateen_set_csr(vcpu, reg_num, re=
g_val);
>                 break;
>         default:
>                 rc =3D -ENOENT;
> --
> 2.43.0
>

