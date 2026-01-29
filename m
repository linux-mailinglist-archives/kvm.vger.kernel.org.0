Return-Path: <kvm+bounces-69535-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4N6mF+M/e2mNCwIAu9opvQ
	(envelope-from <kvm+bounces-69535-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 12:09:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BC847AF6D6
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 12:09:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A8B0E30120F9
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 11:09:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B493D385EFB;
	Thu, 29 Jan 2026 11:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G7eIyCHQ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8CE385EC6
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 11:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769684941; cv=none; b=BlFqTk+6elJM88BiYKOJkZe9nIAly/AplnzlRTJxRx5dxndWLVVomBoi/FdyOK4aVw1gLDbDMNC2Z29QLOKMVWUBYt4RgIalyW7ksB4D0l+zlo3DanDXV9Lh1uJOwcDEQGon8aSiTqIWQj4JfqZUTA52Q5ZiWhXndqaKN/1+BPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769684941; c=relaxed/simple;
	bh=Zm5nVaUmDomhelfJ0OOFh2uwBMUINqvX7H9mQHWFywQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G1rbLfgXZKoWA7K3ovsrsLr6oG0NUn/jePaZzv1ndxQMaGeP9Dds8VePdTLGCzqhUfgPEZJJBPhmBboIZCpjnxURJuLHtbes8CLju3Lr/7NU1u9tF8P25rJDeuc1schFdOw6AHzlewABB63+5O87paJW70l0iSEwFrTP7TyMukE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G7eIyCHQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C216C2BC87
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 11:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769684941;
	bh=Zm5nVaUmDomhelfJ0OOFh2uwBMUINqvX7H9mQHWFywQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=G7eIyCHQmVhnPUOp8Nlblqdw5C6qRjMvrmZreXtXXWsjFXsiKr6RxaACaP/yQoayh
	 1L42nTvJT7OgxQj2TfCLjH47JcYboHJ8A5L+C8aTjfnMgjJD6gpa89aY56yYAIJZ/P
	 5kyhRbJNsleFR6fYHBGSv+XejHw+LYZfW+D6jFRF7X07THkxnYEmsnczWlypzFKhmX
	 F5z2LXRnCFM8dZNK6jW9PvHtEVLyVSngzSn2Q9xhIhao5BcJ745iLB8H9DUlcLG+Xp
	 qtYGBjio1AG7dE7NR0WIjlXKY4ToBE9CDHbzgcPX7s7A8UqFVxE+I4UwKNXskL0GBS
	 lilku0yiEMzsA==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b884a84e622so125071366b.1
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 03:09:01 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXTT8lmvNdsXm8KdruUdbfFxaPZq+O5cG+E77eqaMNyZJP4/rOlnJl9p6ARTEbBiIgvesg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhZZRUhCE7moiAWIKIJdlVPBvXltPwg9BFKp2NL+JDPJZEq3sX
	uQLt0tHIgJcfaMSdJuKznlvz5m2L7qhvFEnANwC59WpN+4m3T5bDwhfu1jd9P8nVNFxTO9K+/cO
	gx4gF/h6DHhqJaoSrQrz+4kWFIqoJKJ4=
X-Received: by 2002:a17:907:7207:b0:b73:a2ce:540f with SMTP id
 a640c23a62f3a-b8dab2da697mr545573566b.17.1769684940063; Thu, 29 Jan 2026
 03:09:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260126024840.2308379-1-maobibo@loongson.cn> <CAAhV-H66uH1TpaKTsqNtSqKYUDatJWj+zAuw-MYE88BqOF0XTA@mail.gmail.com>
 <60b5e543-226c-3c15-09ed-c3c5ccfeb699@loongson.cn>
In-Reply-To: <60b5e543-226c-3c15-09ed-c3c5ccfeb699@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Thu, 29 Jan 2026 19:08:48 +0800
X-Gmail-Original-Message-ID: <CAAhV-H57b14qY+5jqe+Fd5FTQq6jrhurfNBCqBqwG6SUpKFhTw@mail.gmail.com>
X-Gm-Features: AZwV_QhJQXt51VkJgg5i8ghAZ4okSd3PtkuyELjz24byOkoUjHxF1C1KSBtz5vk
Message-ID: <CAAhV-H57b14qY+5jqe+Fd5FTQq6jrhurfNBCqBqwG6SUpKFhTw@mail.gmail.com>
Subject: Re: [PATCH v2] LoongArch: KVM: Add more CPUCFG mask bit
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
	TAGGED_FROM(0.00)[bounces-69535-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,loongson.cn:email]
X-Rspamd-Queue-Id: BC847AF6D6
X-Rspamd-Action: no action

On Thu, Jan 29, 2026 at 6:00=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
>
>
> On 2026/1/29 =E4=B8=8B=E5=8D=885:26, Huacai Chen wrote:
> > Hi, Bibo,
> >
> > On Mon, Jan 26, 2026 at 10:48=E2=80=AFAM Bibo Mao <maobibo@loongson.cn>=
 wrote:
> >>
> >> With LA664 CPU there are more features supported which are indicated
> >> in CPUCFG2 bit24:30 and CPUCFG3 bit17 and bit 23. KVM hypervisor can
> >> not enable or disable these features and there is no KVM exception
> >> when instructions of these features are used in guest mode.
> >>
> >> Here add more CPUCFG mask support with LA664 CPU type.
> >>
> >> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >> ---
> >>    1. Rebase on the latest version since some common CPUCFG bit macro
> >>       definitions are merged.
> >>    2. Modifiy the comments explaining why it comes from feature detect
> >>       of host CPU.
> >> ---
> >>   arch/loongarch/kvm/vcpu.c | 15 +++++++++++++++
> >>   1 file changed, 15 insertions(+)
> >>
> >> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> >> index 656b954c1134..a9608469fa7a 100644
> >> --- a/arch/loongarch/kvm/vcpu.c
> >> +++ b/arch/loongarch/kvm/vcpu.c
> >> @@ -652,6 +652,8 @@ static int _kvm_setcsr(struct kvm_vcpu *vcpu, unsi=
gned int id, u64 val)
> >>
> >>   static int _kvm_get_cpucfg_mask(int id, u64 *v)
> >>   {
> >> +       unsigned int config;
> >> +
> >>          if (id < 0 || id >=3D KVM_MAX_CPUCFG_REGS)
> >>                  return -EINVAL;
> >>
> >> @@ -684,9 +686,22 @@ static int _kvm_get_cpucfg_mask(int id, u64 *v)
> >>                  if (cpu_has_ptw)
> >>                          *v |=3D CPUCFG2_PTW;
> >>
> >> +               /*
> >> +                * The capability indication of some features are the =
same
> >> +                * between host CPU and guest vCPU, and there is no sp=
ecial
> >> +                * feature detect method with vCPU. Also KVM hyperviso=
r can
> >> +                * not enable or disable these features.
> >> +                *
> >> +                * Here use host CPU detected features for vCPU
> >> +                */
> >> +               config =3D read_cpucfg(LOONGARCH_CPUCFG2);
> >> +               *v |=3D config & (CPUCFG2_FRECIPE | CPUCFG2_DIV32 | CP=
UCFG2_LAM_BH);
> >> +               *v |=3D config & (CPUCFG2_LAMCAS | CPUCFG2_LLACQ_SCREL=
 | CPUCFG2_SCQ);
> >>                  return 0;
> >>          case LOONGARCH_CPUCFG3:
> >>                  *v =3D GENMASK(16, 0);
> >> +               config =3D read_cpucfg(LOONGARCH_CPUCFG3);
> >> +               *v |=3D config & (CPUCFG3_DBAR_HINTS | CPUCFG3_SLDORDE=
R_STA);
> > What about adding CPUCFG3_ALDORDER_STA and CPUCFG3_ASTORDER_STA here, t=
oo?
> I am ok to add these bits.
>
> It is strange that there is both capability bit and status bit. AFAIK
> cpucfg is read-only, status bit means that it will change at runtime. I
> will negotiate with HW guys about these bits.
OK, then maybe capability bits should also be added here.

Huacai

>
> Regards
> Bibo Mao
> >
> > Huacai
> >
> >>                  return 0;
> >>          case LOONGARCH_CPUCFG4:
> >>          case LOONGARCH_CPUCFG5:
> >>
> >> base-commit: 63804fed149a6750ffd28610c5c1c98cce6bd377
> >> --
> >> 2.39.3
> >>
> >>
>
>

