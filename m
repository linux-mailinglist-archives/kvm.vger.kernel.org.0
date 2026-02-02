Return-Path: <kvm+bounces-69825-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AKD9AgBzgGkw8QIAu9opvQ
	(envelope-from <kvm+bounces-69825-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 10:48:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BC156CA457
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 10:48:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8ABDE3019126
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 09:48:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 518562DEA61;
	Mon,  2 Feb 2026 09:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eCINpOMg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BF22652B6
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 09:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770025714; cv=none; b=GpXkGvb7YxNi06T4dyDYp4KeMYih0Y+NIDjrd3j7jcFqlrxlN+h/w/QM8T73VSXAVMiHCB4mGT5Qw+orRKH/qNasIEddQFfYPs8iTL8VylUu/rWCIVelrgr4tPHWx2jzCnnLZMeMt0XXuimdjo9AcfQVDSUWPRiVibFjs5K/eA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770025714; c=relaxed/simple;
	bh=vWwVuDVwjMwFP5MTUalu6/VQMN54yDsQ+cxjHswApBI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jCl6zEHIjTS4cwUMBiG0/lZYfiY6BN2vIW9iRh05ZGcoEMPiJPI3vyaOWohfvg6BAMPBOLR99Mu5yvpUo0uhm05xWM8uQKG9nvt0+YRmispkmDhTXeVEF+5fp/Y68vFh1YEEbdxDa/h6TYMv6DKjmspVuVDxAXW6eudRqAStxCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eCINpOMg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 459EAC116D0
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 09:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770025714;
	bh=vWwVuDVwjMwFP5MTUalu6/VQMN54yDsQ+cxjHswApBI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=eCINpOMg5MfpzBW4OPEilbSwGrQ1586+5OZRZssKSe60inj9QsQyvVzDBWo2S2SkE
	 V3WvhWg2o2tkpxZ96FhmzP450sfjNtFLiue/pbDWHA6ox1FNfDIllSonCA3uCnYLlx
	 dDyUVEMiChsUnRnv2/SmIxdzuusKs+eRKaEOkbIA+pHTLFbw7eEt+ltJREXPBUxTDy
	 aIiPCV7UVkRhJAyYS8KCR9/bFsXiJHpofHbJMv2iPfX1fCVlLFECbutsKbeARN60fP
	 Oqp71vqB23YSY4CRa7TxSUkMOq1V6RvchP1G6n7lghEJpEXXrZzAZLTc0dYqOwDJdL
	 jOZ2e9u2jKVdQ==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b885e8c6700so698168866b.0
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 01:48:34 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUTXXQX2F6gLK5KsUKVA5pCOk5HC8TTPViJaqnhxfaOtwfWKJ8T0hlEhy2VNyBUZ2z49uM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjIcO0vj9LmCQ3omlx9aN/lD1u2MCRE+HNibwDAfkFvrI3XHpi
	Z4COksJcNs2wBN2wlPkovOBJEyDsZsLsKd1L05NmpFLgj+qCDdH4Ppu1mATAaxDl9n76cujcTvQ
	kFBvtPcOnRiNG5dnUKECq4902f7h7dy4=
X-Received: by 2002:a17:907:1b1d:b0:b87:1d71:f44d with SMTP id
 a640c23a62f3a-b8dff591487mr634836666b.11.1770025712817; Mon, 02 Feb 2026
 01:48:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260202082631.1678388-1-maobibo@loongson.cn>
In-Reply-To: <20260202082631.1678388-1-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 2 Feb 2026 17:48:22 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6in768UbTqxjrwxXynPPRxAsoeksbau6O5_o5fg8DEyw@mail.gmail.com>
X-Gm-Features: AZwV_Qi0gZeeCqTwzuZaQYUNF6jPu6KS9q96SV5QUjuHZAnfP1IgFBac4zZuwI8
Message-ID: <CAAhV-H6in768UbTqxjrwxXynPPRxAsoeksbau6O5_o5fg8DEyw@mail.gmail.com>
Subject: Re: [PATCH v3] LoongArch: KVM: Add more CPUCFG mask bit
To: Bibo Mao <maobibo@loongson.cn>
Cc: WANG Xuerui <kernel@xen0n.name>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69825-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chenhuacai@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[loongson.cn:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: BC156CA457
X-Rspamd-Action: no action

Applied with some small changes, thanks.

Huacai

On Mon, Feb 2, 2026 at 4:26=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrote=
:
>
> With LA664 CPU there are more features supported which are indicated
> in CPUCFG2 bit24:30 and CPUCFG3 bit17 and bit 23. KVM hypervisor
> cannot enable or disable these features and there is no KVM exception
> when instructions of these features are executed in guest mode.
>
> Here add more CPUCFG mask support with LA664 CPU type.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
> v2 ... v3:
>   1. Add CPUCFG3_ALDORDER_STA and CPUCFG3_ASTORDER_STA in cpucfg3.
>   2. Disable bit CPUCFG3_SFB since VM does not support SFB controling.
>   3. Add checking with max supported page directory level and max virtual
>      address width.
>
> v1 ... v2:
>   1. Rebase on the latest version since some common CPUCFG bit macro
>      definitions are merged.
>   2. Modifiy the comments explaining why it comes from feature detect
>      of host CPU.
> ---
>  arch/loongarch/kvm/vcpu.c | 32 +++++++++++++++++++++++++++++---
>  1 file changed, 29 insertions(+), 3 deletions(-)
>
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index 656b954c1134..7bea5e162a4d 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -652,6 +652,8 @@ static int _kvm_setcsr(struct kvm_vcpu *vcpu, unsigne=
d int id, u64 val)
>
>  static int _kvm_get_cpucfg_mask(int id, u64 *v)
>  {
> +       unsigned int config;
> +
>         if (id < 0 || id >=3D KVM_MAX_CPUCFG_REGS)
>                 return -EINVAL;
>
> @@ -684,9 +686,26 @@ static int _kvm_get_cpucfg_mask(int id, u64 *v)
>                 if (cpu_has_ptw)
>                         *v |=3D CPUCFG2_PTW;
>
> +               /*
> +                * The capability indication of some features are the sam=
e
> +                * between host CPU and guest vCPU, and there is no speci=
al
> +                * feature detect method with vCPU. Also KVM hypervisor c=
an
> +                * not enable or disable these features.
> +                *
> +                * Here use host CPU detected features for vCPU
> +                */
> +               config =3D read_cpucfg(LOONGARCH_CPUCFG2);
> +               *v |=3D config & (CPUCFG2_FRECIPE | CPUCFG2_DIV32 | CPUCF=
G2_LAM_BH);
> +               *v |=3D config & (CPUCFG2_LAMCAS | CPUCFG2_LLACQ_SCREL | =
CPUCFG2_SCQ);
>                 return 0;
>         case LOONGARCH_CPUCFG3:
> -               *v =3D GENMASK(16, 0);
> +               /*
> +                * VM does not support memory order and SFB setting
> +                * only support memory order display
> +                */
> +               *v =3D read_cpucfg(LOONGARCH_CPUCFG3) & GENMASK(23, 0);
> +               *v &=3D ~(CPUCFG3_ALDORDER_CAP | CPUCFG3_ASTORDER_CAP | C=
PUCFG3_SLDORDER_CAP);
> +               *v &=3D ~CPUCFG3_SFB;
>                 return 0;
>         case LOONGARCH_CPUCFG4:
>         case LOONGARCH_CPUCFG5:
> @@ -716,7 +735,7 @@ static int _kvm_get_cpucfg_mask(int id, u64 *v)
>
>  static int kvm_check_cpucfg(int id, u64 val)
>  {
> -       int ret;
> +       int ret, host;
>         u64 mask =3D 0;
>
>         ret =3D _kvm_get_cpucfg_mask(id, &mask);
> @@ -746,9 +765,16 @@ static int kvm_check_cpucfg(int id, u64 val)
>                         /* LASX architecturally implies LSX and FP but va=
l does not satisfy that */
>                         return -EINVAL;
>                 return 0;
> +       case LOONGARCH_CPUCFG3:
> +               host =3D read_cpucfg(LOONGARCH_CPUCFG3);
> +               if ((val & CPUCFG3_SPW_LVL) > (host & CPUCFG3_SPW_LVL))
> +                       return -EINVAL;
> +               if ((val & CPUCFG3_RVAMAX) > (host & CPUCFG3_RVAMAX))
> +                       return -EINVAL;
> +               return 0;
>         case LOONGARCH_CPUCFG6:
>                 if (val & CPUCFG6_PMP) {
> -                       u32 host =3D read_cpucfg(LOONGARCH_CPUCFG6);
> +                       host =3D read_cpucfg(LOONGARCH_CPUCFG6);
>                         if ((val & CPUCFG6_PMBITS) !=3D (host & CPUCFG6_P=
MBITS))
>                                 return -EINVAL;
>                         if ((val & CPUCFG6_PMNUM) > (host & CPUCFG6_PMNUM=
))
>
> base-commit: 18f7fcd5e69a04df57b563360b88be72471d6b62
> --
> 2.39.3
>
>

