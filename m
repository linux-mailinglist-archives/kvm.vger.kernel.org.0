Return-Path: <kvm+bounces-69144-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WJUDCnlwd2m8gAEAu9opvQ
	(envelope-from <kvm+bounces-69144-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 14:47:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D6678910D
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 14:47:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8289F3017252
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 13:38:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD42333A6F9;
	Mon, 26 Jan 2026 13:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="ZnoMeVqv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A8D1DED57
	for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 13:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769434685; cv=pass; b=rPCRCGp1hYARkqh5r/TwTa298o3Fc/07H6zD4g0ti0GaAFN/DjWA50cKxmgZ9BgUVkcxxV9M/c3U5lfIYXk6koQFi86g58TC9t9vz+jYqFcPf0o5VN7yRq9JvyzhRtqii9tUwdnqznbO7lZkgGp1Ig5ADFFTwrjahgIAHR1593s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769434685; c=relaxed/simple;
	bh=SCg98QQoNgDDnwq5R7GOmjPd1EPRpOnjHZW1L4IHq9I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lw48DEsJwCuG+GoQTafzMrQ7j3PwUESr0plPzai4L8EJ9KJcL/uSrRdLovYRm8BLgU3oeCm8TN2ifCBFGqsNqBnBnmoxy0ZJrL1Ftxo+Ci4UD1i2/0SUlWjySBCwflr2QINGlSzcNqDNqV6JHhsQXuV0f0oXUm1Q91OxgwioFOA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=ZnoMeVqv; arc=pass smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-66105b0b931so1785997eaf.1
        for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 05:38:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769434683; cv=none;
        d=google.com; s=arc-20240605;
        b=Hzhy16xBhuyoILvLv267NTt9A5Q54CcwKzZv6q7q2HUM2wN72Cxj8dL08sbpHdk88B
         45UpvH6qxQihG3HAPOo4XGIF9brEZZDien1NiEvjqbQERaHZrlFhfEgc2QSt8aKLAp5N
         zawRGJBz0oZ6InpB8kt7sT2mtw8jkydb1WMyxLoQsMj9N4PedTx00NGwzPu/Xvkk1J63
         6e4Pmi2Mg79xOOdE6O5Y7yveaD52B0OHwXaw9bnO3lHgmu7cR/WnTlKzyvpA47H3IyVa
         hE8Wtp0l2EchLwbVNZpTKREaqEkU1PLkVoB3QnSPNqBlET02a5V9W7sOqMZSBO491U7y
         Q+pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=96Z1qB+0/8HWcxvjUdd3tF4AdTtqAyIJQA/+cb2JhLI=;
        fh=8LXlxNypTYnYDlm9XeI211mwxGStyXcMxc4jKh0tNC0=;
        b=cmZvDh+fXZocifXsU5jqRbF7nisuoombEO4byETu+3bD3UOXwC/wSbdmkPdtke+rQy
         DDyIW5ddeyB+IOeXgwZVRexTjB4HJrhNdTM+aoM8wKARiZROc9PT6RIsFZ6Yern+7GaQ
         fwyssPjKXDtay0VTyx+FkHXXeHy3sKoxwtIFeCeq+QVgUfF8ko1v7yDXmR2Rvb/bhJ8A
         OUQH90ZwlYTaYUfyH918T2EBn0ax4OIlh9mEqYnwi6Y5RfLdwWiOs9Qjh7MAIioZ7lxa
         RRaO8yZ6ASYHFx3CCkINAjqz5/pNT2FCL/Xb7udTPvCekmBdC7rjDwZPFXIIzxvIdfDL
         Phow==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1769434683; x=1770039483; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=96Z1qB+0/8HWcxvjUdd3tF4AdTtqAyIJQA/+cb2JhLI=;
        b=ZnoMeVqvw694i81KRgBanJDMpNG6+yyGUJUmeI5KseUpDhrS1yU2e3dyUOWFhKRRw7
         ifcyAkd7Ed42Pfa45Nvr/WY3SxOk1Gv3hmC8IesufemT7y+nE0ZDZwk2oeH8Z1ezkGbt
         G2XGa3caENnv00euqszOZ0Bmi8ExMIUXUdPxHj3VgWUvDlkTPGsPE8RWCixAchpRiG4k
         vna36QTUXjVZwTP/WNrKr4ahOfrIH7rFJx240ORlot0njz/en9XpuMuhgXY6l/dQU4Fs
         MtYbGiqFejkLySMGNL0HND5cZtF8BcxEsE6hntv9X7kJ+vDPyzeiaunL3huj4TWyjhGX
         KmdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769434683; x=1770039483;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=96Z1qB+0/8HWcxvjUdd3tF4AdTtqAyIJQA/+cb2JhLI=;
        b=Bc/wGDOKMxI3vK+b3vdg3IJ622wTRnHTmeSnHQzhjKwjzPvV9JfPSMghCrDWJdi2qD
         FksrXwdkredan7PP3VCVt+m/hN09mpXR5gnd1vQkdvyW3R3Ui0c09DX+l6QrF89rT3Gs
         sYA/JLu4gtKKtLjHDwLNqqCA/57x6GNOWTAQ5BrUjSJPpyCmehfSrB9nnp2diLWgn22h
         1dRCo8ej8ZaqOBmOJyD2uZAHwd/b329ZSxmsf2EEufv+MDG0CGieVHkmksonWJ/ecYcy
         tIl0yVB1MjVnUGea7ihQMz5FHHLUcxXhSVLvFF9tCFA4E70i7eYNhAaTfeOiTbPw7m1d
         RS9Q==
X-Forwarded-Encrypted: i=1; AJvYcCV6IgcJHQW7c7A/0VNc88rmacvafGukGmSflMeRTJG122VDj1C1rJyNZx9MCUkL7K0VlB8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVUSrnC4PNaLqqdERm+McwauHgFQH/aZFWcVkbq+MlIbbClQ2n
	ih30+TE/E26NHAa9nNfqU561l0wB7eyTr68hHrFxSqZ9bZJoi7ZRzCNRG/NRgdNfcm6WEbVkSTK
	J5lunBDSf22SFfVKI1QIIxy6dNjctUo0mltu/m9/XDg==
X-Gm-Gg: AZuq6aKCr877l+/AwNMYLTxa/lSYbGf35bf9BA9eFwqUDh1XVhsUNW7OMGUEn5VD1Wp
	cxhUw544t3alif/wHlnFXinIwRmyo/wFa8slb7uiA1RxxhlW1frGaHOFOjRAPOZqkKOe+cwyw+1
	6cDBLuu5aO1CgoiwSkXRc81nrFCUJb9+QNpErcOm+S4n0qWmfipOk7zLdwgKp7waCRBQev619Fv
	m15rtUtHkNOsKfD7bQxz8az8OTHcBcPVgdHG8qDhdoT4tolFYJmIU6BqJtv4pwCkSNdOt4TDZ/j
	CfRg2/uSWGEXkXwRxwBBE+o3w1wru11tPVh5o739Q2a8O3R2ETPdQtAqB83AG86sBTpn
X-Received: by 2002:a05:6820:290d:b0:659:9a49:8f84 with SMTP id
 006d021491bc7-662e046ea71mr2158364eaf.73.1769434683283; Mon, 26 Jan 2026
 05:38:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260104133457.57742-1-luxu.kernel@bytedance.com>
 <CAAhSdy0krY4ou9TpGV=SKUKPNwgweB58QetUajb3HE5Jfy_RbA@mail.gmail.com> <CAPYmKFsAcik3YjO19K1aoGHeqaq9qsx-JeHjoqLLAXp9-t-pKg@mail.gmail.com>
In-Reply-To: <CAPYmKFsAcik3YjO19K1aoGHeqaq9qsx-JeHjoqLLAXp9-t-pKg@mail.gmail.com>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 26 Jan 2026 19:07:52 +0530
X-Gm-Features: AZwV_QiWDQAHwP8r7oo-R1yw79afIMzBCOPPal9VnywBIszKSCNUlvHToHzr7Ps
Message-ID: <CAAhSdy0YGdKjdzROdyE6gG=LCvHd7nQbWuW4a+thB5vr47QuSQ@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v5] irqchip/riscv-imsic: Adjust the number
 of available guest irq files
To: Xu Lu <luxu.kernel@bytedance.com>
Cc: atish.patra@linux.dev, pjw@kernel.org, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, alex@ghiti.fr, tglx@linutronix.de, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[brainfault-org.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[brainfault.org];
	TAGGED_FROM(0.00)[bounces-69144-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[brainfault-org.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anup@brainfault.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[brainfault-org.20230601.gappssmtp.com:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,bytedance.com:email,brainfault.org:email,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 3D6678910D
X-Rspamd-Action: no action

On Mon, Jan 26, 2026 at 4:37=E2=80=AFPM Xu Lu <luxu.kernel@bytedance.com> w=
rote:
>
> On Mon, Jan 26, 2026 at 6:54=E2=80=AFPM Anup Patel <anup@brainfault.org> =
wrote:
> >
> > On Sun, Jan 4, 2026 at 7:05=E2=80=AFPM Xu Lu <luxu.kernel@bytedance.com=
> wrote:
> > >
> > > Currently, KVM assumes the minimum of implemented HGEIE bits and
> > > "BIT(gc->guest_index_bits) - 1" as the number of guest files availabl=
e
> > > across all CPUs. This will not work when CPUs have different number
> > > of guest files because KVM may incorrectly allocate a guest file on a
> > > CPU with fewer guest files.
> > >
> > > To address above, during initialization, calculate the number of
> > > available guest interrupt files according to MMIO resources and
> > > constrain the number of guest interrupt files that can be allocated
> > > by KVM.
> > >
> > > Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
> >
> > Please carry Reviewed-by and Acked-by tags obtained in previous
> > revisions. Next time, I will not take the patch if previous tags are
> > missing.
>
> Sorry about that. I thought the Reviewed-by and Acked-by tags belong
> to the previous version so didn't carry them.
>
> >
> > Queued this patch for Linux-6.20.
>
> Do I still need to resend the patch with Reviewed-by and Acked-by tags?

I have included the tags at the time of the merging patch.

Regards,
Anup

>
> Best regards,
> Xu Lu
>
> >
> > Regards,
> > Anup
> >
> > > ---
> > >  arch/riscv/kvm/aia.c                    |  2 +-
> > >  drivers/irqchip/irq-riscv-imsic-state.c | 12 +++++++++++-
> > >  include/linux/irqchip/riscv-imsic.h     |  3 +++
> > >  3 files changed, 15 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
> > > index dad3181856600..cac3c2b51d724 100644
> > > --- a/arch/riscv/kvm/aia.c
> > > +++ b/arch/riscv/kvm/aia.c
> > > @@ -630,7 +630,7 @@ int kvm_riscv_aia_init(void)
> > >          */
> > >         if (gc)
> > >                 kvm_riscv_aia_nr_hgei =3D min((ulong)kvm_riscv_aia_nr=
_hgei,
> > > -                                           BIT(gc->guest_index_bits)=
 - 1);
> > > +                                           gc->nr_guest_files);
> > >         else
> > >                 kvm_riscv_aia_nr_hgei =3D 0;
> > >
> > > diff --git a/drivers/irqchip/irq-riscv-imsic-state.c b/drivers/irqchi=
p/irq-riscv-imsic-state.c
> > > index dc95ad856d80a..e8f20efb028be 100644
> > > --- a/drivers/irqchip/irq-riscv-imsic-state.c
> > > +++ b/drivers/irqchip/irq-riscv-imsic-state.c
> > > @@ -794,7 +794,7 @@ static int __init imsic_parse_fwnode(struct fwnod=
e_handle *fwnode,
> > >
> > >  int __init imsic_setup_state(struct fwnode_handle *fwnode, void *opa=
que)
> > >  {
> > > -       u32 i, j, index, nr_parent_irqs, nr_mmios, nr_handlers =3D 0;
> > > +       u32 i, j, index, nr_parent_irqs, nr_mmios, nr_guest_files, nr=
_handlers =3D 0;
> > >         struct imsic_global_config *global;
> > >         struct imsic_local_config *local;
> > >         void __iomem **mmios_va =3D NULL;
> > > @@ -888,6 +888,7 @@ int __init imsic_setup_state(struct fwnode_handle=
 *fwnode, void *opaque)
> > >         }
> > >
> > >         /* Configure handlers for target CPUs */
> > > +       global->nr_guest_files =3D BIT(global->guest_index_bits) - 1;
> > >         for (i =3D 0; i < nr_parent_irqs; i++) {
> > >                 rc =3D imsic_get_parent_hartid(fwnode, i, &hartid);
> > >                 if (rc) {
> > > @@ -928,6 +929,15 @@ int __init imsic_setup_state(struct fwnode_handl=
e *fwnode, void *opaque)
> > >                 local->msi_pa =3D mmios[index].start + reloff;
> > >                 local->msi_va =3D mmios_va[index] + reloff;
> > >
> > > +               /*
> > > +                * KVM uses global->nr_guest_files to determine the a=
vailable guest
> > > +                * interrupt files on each CPU. Take the minimum numb=
er of guest
> > > +                * interrupt files across all CPUs to avoid KVM incor=
rectly allocating
> > > +                * an unexisted or unmapped guest interrupt file on s=
ome CPUs.
> > > +                */
> > > +               nr_guest_files =3D (resource_size(&mmios[index]) - re=
loff) / IMSIC_MMIO_PAGE_SZ - 1;
> > > +               global->nr_guest_files =3D min(global->nr_guest_files=
, nr_guest_files);
> > > +
> > >                 nr_handlers++;
> > >         }
> > >
> > > diff --git a/include/linux/irqchip/riscv-imsic.h b/include/linux/irqc=
hip/riscv-imsic.h
> > > index 7494952c55187..43aed52385008 100644
> > > --- a/include/linux/irqchip/riscv-imsic.h
> > > +++ b/include/linux/irqchip/riscv-imsic.h
> > > @@ -69,6 +69,9 @@ struct imsic_global_config {
> > >         /* Number of guest interrupt identities */
> > >         u32                                     nr_guest_ids;
> > >
> > > +       /* Number of guest interrupt files per core */
> > > +       u32                                     nr_guest_files;
> > > +
> > >         /* Per-CPU IMSIC addresses */
> > >         struct imsic_local_config __percpu      *local;
> > >  };
> > > --
> > > 2.20.1
> > >
> > >

