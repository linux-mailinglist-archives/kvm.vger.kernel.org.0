Return-Path: <kvm+bounces-69116-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AC7NIulKd2msdwEAu9opvQ
	(envelope-from <kvm+bounces-69116-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 12:07:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DEFCB877D0
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 12:07:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 81D8630143E5
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 11:07:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DA383314B9;
	Mon, 26 Jan 2026 11:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="eFaTZb1g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC913002DC
	for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 11:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769425636; cv=pass; b=M1wQU10pdaIqW7Z+hoaWTiYJeUIz4DJo68wRMP5CwAtfDmLelCTMEYoJlmBfFEhxskaA+4tZT1oIhJ8hH61xcu7rdDZWHaDWPGjgdrF8/Sb2n2YopH12w0sPA8F4aQI7rnTYnwX9PDqrs1PdOtkEeKIRG2uU5TMweOupq9osnZU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769425636; c=relaxed/simple;
	bh=PvATDH7VSpfQ+pLct5J4149cOMCdeRyJf8+mE+EjVfI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XWKlBjOL9jHKmlFSSjIlEUBro9Wq9Fi8JeSllBdR8VFDTyxOb0YI09nx3Lc+NwRZFFcMhjfOVfdImDuYe2hlsCRRdzrX2VICkRE1f5f7bw0YjTNuw5D9Fui2eDSiEo113akukZ+AFgb0OgntpBNejmRwPIihCS6Rv7zsDXl1GxU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=eFaTZb1g; arc=pass smtp.client-ip=209.85.222.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-93f69720a7cso2422494241.1
        for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 03:07:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769425634; cv=none;
        d=google.com; s=arc-20240605;
        b=IGFXezyEnvjrG4lA6vbCs02VjiL7vh5wFBOd7T9RKsTIog1bnMVnjwFeq3OP+AiSt/
         e+18F220YV7YGCEFO023+/E12W0SF1ImGCXB0sNDKRcx6jb0/paWVYwIqeoGZjIpE5uI
         hw3DLgM5t0L3TV5XixJzdo3M2ChbL0fTzbGYdTk9qUP6kZ9MByAFB/bvgZwEPhdmGk5/
         4mCyYNKUketB01teXYq81El7plyUAp4nm1kC2RkXs/bTarGIfJTJpkedLCKpwDRDPqbc
         YZeKnck7b/6QcbV4/toUD5XeiJsaGh2d4YIJa6bXbYJEiI51F40eaqLzKBaJL4ZPAok7
         YCnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Jikz4suWiAmlsF3qFodUwFSeL7ZT9eIQaxTBBzP1rbc=;
        fh=cvAiybB2okJytE5ZlPJu/0RHusL4Q4lzx9hns8FfF0k=;
        b=YMHrC1VnBIKsJnlnRA6H86zRva/yG4xy7jwI5im3lpgGbtJduwYSVj3uz9/Tu8QKKf
         17rWubFYEt2S61yBYlVWvjqB+k0HtXtrc6z+PNq62keHPoER4gG/W4y0V42qYsupQXwZ
         AKg8G46Np/5+moyprrn1kuO58MNDVJ7BuyvGTeAHe78DNkMNZJYdiT+Ga2jcl6qbVQzv
         9qDxEkoT55sF85zojbSGFOawVjziiqm71Y2GQu2AQOFdNgeZKUyaVVIVj9SZirMc6VFO
         reN2SlrGVA3yLh/GBHuG4NgvMRSKRIAQ6LbE8lqNZFJfOWHFZF87gyioqZuWSrrgtcSf
         z65Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1769425634; x=1770030434; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jikz4suWiAmlsF3qFodUwFSeL7ZT9eIQaxTBBzP1rbc=;
        b=eFaTZb1gT5l6X0sQX680K6ahRy91omnXSDdv4OFt5QsNkaeZUY98L01xql+jTASJkJ
         AZDrf+7/XUicAAeqIMwWNnvHA4RFFmesZesA7Q3MHWKB8Sto5KQfu0ajijRkNiqls/ji
         9/r3z7AR5tyQS/jNRe3cqWebgCSultGrLvcfyFjzsN4e4fA3NXhG2AgUORyzC1MDzEOz
         pfVn80Fr3LHKrIT+UWKqUkONo8TUj3+O4Gm4wJRTz7rmasUAh449DJpXvmEYvrBoeWoT
         Bm6cJq9F7kMSc8ms/lfrwIcj0K0VxqfMj8lceFnyxXGN5AliWwTzFim6d7YxVw5eiD7J
         gkSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769425634; x=1770030434;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Jikz4suWiAmlsF3qFodUwFSeL7ZT9eIQaxTBBzP1rbc=;
        b=YxWyrjZYb7/ON4II2VMtvcDdkIPenqLdn3rsvu0lgQgaqtBCWMwqUr2zznsjm3ONkQ
         AiOgQOdStRX3wZyWMUimhaOYpzCcikBCGN/ynmxyx9i+NfunCM38ZG7j+1unkjcfqZby
         xjjdTV23W6/ztkoVnxn+Y/SQpP0Kxv9RJ19KOtyRh/K3TSam546ETnBUBSBsrFOcQot5
         +xMe3Uga0RORizM2kIdAy4IExFJGPv2aa6t4PLaxWoN+QEG+qr7fkbwlD+cKuPo1U5fH
         FDtMM6FI6QKCZBeZIXLwoYty90PuF193qL4gE4GM7eIYHzydgwPaVqt1IxEi/ADEZ9QX
         WHpw==
X-Forwarded-Encrypted: i=1; AJvYcCVj3VYV9Qnwyt5H2JtfoZG8/MaWT4XUpwY48ie33rQ5qZO63rvFgC3zh/tXHwS5kjtzqjU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/JtNHVzFcCHnIJI0/vx3hzsCxK3LwAXgmDLAGx4Fph4sMSk3f
	++w7Kplt6W3X+eFsR2Jd2EQMPeP7HEoVlhsIYpkk6qbrIS+sTpok55kOlcT7pyG9ZVhb5TPV8br
	Dg+CHvdBYp9S7Dm2AI4NGiJ8Dxa0wjX5ckawRBLdFcoEvN6NgPYHMTvCOUV3n
X-Gm-Gg: AZuq6aIFmWmBZuj0l2lwjLQzWas1/vSf7iT3FhsozTQKCnmiuaLYJDFYxIDe02AIlqi
	jLWAEmyJuerHoWGEhSlJmzpHqs/O48inGrXtZoLvyvnpUNDoyyWfK6lhzNE10xXKzB68154ErFY
	AlRKkO1n2C+sLVnQBD4ek27zf5fEPen6u1b5p6pzLlKPcaJ/JsI2rFouAb5S3fwo+X/fiyQOWTR
	D0K0+08ZH+RBolN0yJTgwt47KAM6T+KJj6gsWK03aKhNwYFLLAEeZT7ElHsASLNhLLkVMh1l7La
	kDFgZBmR
X-Received: by 2002:a05:6102:508d:b0:5f5:4d1c:89bd with SMTP id
 ada2fe7eead31-5f5762c8c17mr1115604137.1.1769425633883; Mon, 26 Jan 2026
 03:07:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260104133457.57742-1-luxu.kernel@bytedance.com> <CAAhSdy0krY4ou9TpGV=SKUKPNwgweB58QetUajb3HE5Jfy_RbA@mail.gmail.com>
In-Reply-To: <CAAhSdy0krY4ou9TpGV=SKUKPNwgweB58QetUajb3HE5Jfy_RbA@mail.gmail.com>
From: Xu Lu <luxu.kernel@bytedance.com>
Date: Mon, 26 Jan 2026 19:07:03 +0800
X-Gm-Features: AZwV_Qg9Lpwqzh241-drclbSZB5_WXa_xHTaLQJyXwpF4Hv4QYndrPF9zzxEs0w
Message-ID: <CAPYmKFsAcik3YjO19K1aoGHeqaq9qsx-JeHjoqLLAXp9-t-pKg@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v5] irqchip/riscv-imsic: Adjust the number
 of available guest irq files
To: Anup Patel <anup@brainfault.org>
Cc: atish.patra@linux.dev, pjw@kernel.org, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, alex@ghiti.fr, tglx@linutronix.de, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[bytedance.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[bytedance.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69116-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[bytedance.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[luxu.kernel@bytedance.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[brainfault.org:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,bytedance.com:email,bytedance.com:dkim,mail.gmail.com:mid]
X-Rspamd-Queue-Id: DEFCB877D0
X-Rspamd-Action: no action

On Mon, Jan 26, 2026 at 6:54=E2=80=AFPM Anup Patel <anup@brainfault.org> wr=
ote:
>
> On Sun, Jan 4, 2026 at 7:05=E2=80=AFPM Xu Lu <luxu.kernel@bytedance.com> =
wrote:
> >
> > Currently, KVM assumes the minimum of implemented HGEIE bits and
> > "BIT(gc->guest_index_bits) - 1" as the number of guest files available
> > across all CPUs. This will not work when CPUs have different number
> > of guest files because KVM may incorrectly allocate a guest file on a
> > CPU with fewer guest files.
> >
> > To address above, during initialization, calculate the number of
> > available guest interrupt files according to MMIO resources and
> > constrain the number of guest interrupt files that can be allocated
> > by KVM.
> >
> > Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
>
> Please carry Reviewed-by and Acked-by tags obtained in previous
> revisions. Next time, I will not take the patch if previous tags are
> missing.

Sorry about that. I thought the Reviewed-by and Acked-by tags belong
to the previous version so didn't carry them.

>
> Queued this patch for Linux-6.20.

Do I still need to resend the patch with Reviewed-by and Acked-by tags?

Best regards,
Xu Lu

>
> Regards,
> Anup
>
> > ---
> >  arch/riscv/kvm/aia.c                    |  2 +-
> >  drivers/irqchip/irq-riscv-imsic-state.c | 12 +++++++++++-
> >  include/linux/irqchip/riscv-imsic.h     |  3 +++
> >  3 files changed, 15 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
> > index dad3181856600..cac3c2b51d724 100644
> > --- a/arch/riscv/kvm/aia.c
> > +++ b/arch/riscv/kvm/aia.c
> > @@ -630,7 +630,7 @@ int kvm_riscv_aia_init(void)
> >          */
> >         if (gc)
> >                 kvm_riscv_aia_nr_hgei =3D min((ulong)kvm_riscv_aia_nr_h=
gei,
> > -                                           BIT(gc->guest_index_bits) -=
 1);
> > +                                           gc->nr_guest_files);
> >         else
> >                 kvm_riscv_aia_nr_hgei =3D 0;
> >
> > diff --git a/drivers/irqchip/irq-riscv-imsic-state.c b/drivers/irqchip/=
irq-riscv-imsic-state.c
> > index dc95ad856d80a..e8f20efb028be 100644
> > --- a/drivers/irqchip/irq-riscv-imsic-state.c
> > +++ b/drivers/irqchip/irq-riscv-imsic-state.c
> > @@ -794,7 +794,7 @@ static int __init imsic_parse_fwnode(struct fwnode_=
handle *fwnode,
> >
> >  int __init imsic_setup_state(struct fwnode_handle *fwnode, void *opaqu=
e)
> >  {
> > -       u32 i, j, index, nr_parent_irqs, nr_mmios, nr_handlers =3D 0;
> > +       u32 i, j, index, nr_parent_irqs, nr_mmios, nr_guest_files, nr_h=
andlers =3D 0;
> >         struct imsic_global_config *global;
> >         struct imsic_local_config *local;
> >         void __iomem **mmios_va =3D NULL;
> > @@ -888,6 +888,7 @@ int __init imsic_setup_state(struct fwnode_handle *=
fwnode, void *opaque)
> >         }
> >
> >         /* Configure handlers for target CPUs */
> > +       global->nr_guest_files =3D BIT(global->guest_index_bits) - 1;
> >         for (i =3D 0; i < nr_parent_irqs; i++) {
> >                 rc =3D imsic_get_parent_hartid(fwnode, i, &hartid);
> >                 if (rc) {
> > @@ -928,6 +929,15 @@ int __init imsic_setup_state(struct fwnode_handle =
*fwnode, void *opaque)
> >                 local->msi_pa =3D mmios[index].start + reloff;
> >                 local->msi_va =3D mmios_va[index] + reloff;
> >
> > +               /*
> > +                * KVM uses global->nr_guest_files to determine the ava=
ilable guest
> > +                * interrupt files on each CPU. Take the minimum number=
 of guest
> > +                * interrupt files across all CPUs to avoid KVM incorre=
ctly allocating
> > +                * an unexisted or unmapped guest interrupt file on som=
e CPUs.
> > +                */
> > +               nr_guest_files =3D (resource_size(&mmios[index]) - relo=
ff) / IMSIC_MMIO_PAGE_SZ - 1;
> > +               global->nr_guest_files =3D min(global->nr_guest_files, =
nr_guest_files);
> > +
> >                 nr_handlers++;
> >         }
> >
> > diff --git a/include/linux/irqchip/riscv-imsic.h b/include/linux/irqchi=
p/riscv-imsic.h
> > index 7494952c55187..43aed52385008 100644
> > --- a/include/linux/irqchip/riscv-imsic.h
> > +++ b/include/linux/irqchip/riscv-imsic.h
> > @@ -69,6 +69,9 @@ struct imsic_global_config {
> >         /* Number of guest interrupt identities */
> >         u32                                     nr_guest_ids;
> >
> > +       /* Number of guest interrupt files per core */
> > +       u32                                     nr_guest_files;
> > +
> >         /* Per-CPU IMSIC addresses */
> >         struct imsic_local_config __percpu      *local;
> >  };
> > --
> > 2.20.1
> >
> >

