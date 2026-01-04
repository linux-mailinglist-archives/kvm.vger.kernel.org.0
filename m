Return-Path: <kvm+bounces-66986-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 56C4ECF0FA5
	for <lists+kvm@lfdr.de>; Sun, 04 Jan 2026 14:16:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F0217302D2BE
	for <lists+kvm@lfdr.de>; Sun,  4 Jan 2026 13:16:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88D103009C7;
	Sun,  4 Jan 2026 13:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="Kvkkc4Wt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C7B2FFDEC
	for <kvm@vger.kernel.org>; Sun,  4 Jan 2026 13:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767532593; cv=none; b=Xg7K6ElhhYLNsuie77/fnijOvrtT+x/A5Li8oq9Gh/YYCMVgKDS/MlcTEPeCIfcpoGsJY6RPnsm2SzDHeRD63vxB5SBP+kYYPoKmLLMq7/1SXvT1w/zWt3qE4EjsAL9dNzPVmMWfWVLccEMDSmQ+xIykwbMXAL2n1on937g3gqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767532593; c=relaxed/simple;
	bh=jVjjkFSCtpS7Blnl2Mesl911My3HQMdUTDRRCZUpMHk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MOZRdPipOWBE2GiKQeC1Vb6+dB7XTSqedkT2y5SwJ9njXsWi53srXTgT6FeZx1XGJyG3IfWDWyCgJB8TlH90i3PJLqZqCjhesPuHiGZTGl1m8BupEEkUBzheKyxMVlsnVmxCBkyELLtbH/4XiRGJzHtNFphJaiWfBxsh6o6uaEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=Kvkkc4Wt; arc=none smtp.client-ip=209.85.161.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-65ec86c5e70so4732454eaf.3
        for <kvm@vger.kernel.org>; Sun, 04 Jan 2026 05:16:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1767532588; x=1768137388; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kpw5c66615tZNKatmV43J/ND8KGZ/2GF5fblepdu7i8=;
        b=Kvkkc4WtOZGxWh6A91yFcNIxU7332U889LJSSjtIKEDjUA5K9/RriCzg5B75Px5IcL
         u4sTpcWTM0BwYdUm/oISHrmmzTVoA8Wxbjx76qlYBsAgtCvUN6p8H2oaq0m7qTfvrQqN
         +J3xr8aONoOClCdMTigTsM/xxXVt/dU3btiggfaiyj9RGDEquXVv/J2Fddq61zDL7QYt
         1jF71yQuhkdDjFg3jDvp7R0tEaCv9LDCrYnrR9KCBl+nxROsc3NUdoWedMyoN0VZWe9T
         w3BhD0TiapONHK1D4yYaJLTkNFQ3z90tv2Wqi5p3kBzxwlf+twQQRd+gQtIb2l+CpiFp
         /aGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767532588; x=1768137388;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Kpw5c66615tZNKatmV43J/ND8KGZ/2GF5fblepdu7i8=;
        b=rZKqb9BlLkoHJaLleyskPkDEqxy6m1yANJPP2B5FYTkwMxqfX3BKV5heRxKqutPL5b
         v4e004q8dwVZzXWs8bQ7flLumTd8yem1kZkRJCdE0B5AEZ4fQ4hrIqdDs2NGmOMlSMET
         d3RYIDjhtH4Sgi/RXTIoa8cW+yixaKRwpYF/DVRQqykePhqYjDmlZI4HcNgM3Tii0HMt
         58/PjKKHDGg9bM9J4VklYgbNuqgO6salGptMpq4hY2YcborLlDaekNZwI/VIOTA2BbUE
         94ck2f88BvIvq/hSD3IFQOe9y3TIYjyMQdKVkPQO6DDs79ROSzZRDCCJ36NTASG0Y9sa
         UNZw==
X-Forwarded-Encrypted: i=1; AJvYcCU/bQ3Jvdy8Z+omcHigOWw47/wRiKyNpgvHwY1eUky7Jxjn2vpx+inixXdnXHMdZuKbb3Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGtxTcRKShFRA2Tnwfb7D/XBb6F6N1vMBdAm5H+LdP3R4pTu2+
	CsoAillEGyDnxeX7mex5nGv5wzsF6+exdZ6P6dq5VjPX5iDxIpWB01ownk64CRT0OKaPT5GDRMk
	jgsxhtLfYeBdH48akkn1J0mQE+Nw+AuqDb1HK7LJThw==
X-Gm-Gg: AY/fxX4TzSwEPzzjX9K40GJkGHwDctgzsyN8w5optGAvdek8qj6QqdYgxGhlzKPuWYW
	Af9xsyLv+/eE8uFcW8GNYEDIQNXg5CZlynbnDtuC73reDAFaRRadh6ksl5HnvgKQ0r42m0FPKbA
	+pNEP9GiO/nYyY/s1EYecv6bu4j5rgg9s5ZX22WPilpKADizG5JeNOPT5XwR9iYEQn9Mh5jnOSD
	bdgjK9evkyjgjADkqS/Uvb0x1olC85Km7odkf+JLChUOprGliqFlfsI6K7FQhlgJteH2MF/N5V9
	signDNPAHAv/eS7A5tmmuCBHNiNrBWqk79zj+fU//ZSaPbewo+aYJTF+PpW3R4uMOGvn
X-Google-Smtp-Source: AGHT+IGT244la+14L6U18Uxy9GYJPnBgP9sTDS9KacVXfRCEDc5zScFpVVMALlU5LWz1Jl7huKZAKKZcDb8ssT4GVXY=
X-Received: by 2002:a4a:d676:0:b0:65f:fec:9d73 with SMTP id
 006d021491bc7-65f0fecac13mr3549160eaf.31.1767532588514; Sun, 04 Jan 2026
 05:16:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251222093718.26223-1-luxu.kernel@bytedance.com>
In-Reply-To: <20251222093718.26223-1-luxu.kernel@bytedance.com>
From: Anup Patel <anup@brainfault.org>
Date: Sun, 4 Jan 2026 18:46:17 +0530
X-Gm-Features: AQt7F2p6TPTBqgurXOAwdOn8HSUO6amlD4OSN8ElokLgnxoYr3h1zNDHtjswIrA
Message-ID: <CAAhSdy0dcMhmENZ9cMkE7Rh8u93sRiYozxEWgJ0tvHVUiRdykw@mail.gmail.com>
Subject: Re: [PATCH v4] irqchip/riscv-imsic: Adjust the number of available
 guest irq files
To: Xu Lu <luxu.kernel@bytedance.com>
Cc: atish.patra@linux.dev, pjw@kernel.org, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, alex@ghiti.fr, tglx@linutronix.de, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 22, 2025 at 3:07=E2=80=AFPM Xu Lu <luxu.kernel@bytedance.com> w=
rote:
>
> Currently, KVM assumes the minimum of implemented HGEIE bits and
> "BIT(gc->guest_index_bits) - 1" as the number of guest files available
> across all CPUs. This will not work when CPUs have different number
> of guest files because KVM may incorrectly allocate a guest file on a CPU
> with fewer guest files.
>
> To address above, during initialization, we calculate the number of

/, we calculate .../, calculate .../

> available guest interrupt files according to MMIO resources and constrain
> the number of guest interrupt files that can be allocated by KVM.
>
> Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
> ---
>  arch/riscv/kvm/aia.c                    |  2 +-
>  drivers/irqchip/irq-riscv-imsic-state.c | 12 +++++++++++-
>  include/linux/irqchip/riscv-imsic.h     |  3 +++
>  3 files changed, 15 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
> index dad3181856600..cac3c2b51d724 100644
> --- a/arch/riscv/kvm/aia.c
> +++ b/arch/riscv/kvm/aia.c
> @@ -630,7 +630,7 @@ int kvm_riscv_aia_init(void)
>          */
>         if (gc)
>                 kvm_riscv_aia_nr_hgei =3D min((ulong)kvm_riscv_aia_nr_hge=
i,
> -                                           BIT(gc->guest_index_bits) - 1=
);
> +                                           gc->nr_guest_files);
>         else
>                 kvm_riscv_aia_nr_hgei =3D 0;
>
> diff --git a/drivers/irqchip/irq-riscv-imsic-state.c b/drivers/irqchip/ir=
q-riscv-imsic-state.c
> index dc95ad856d80a..cccca38983577 100644
> --- a/drivers/irqchip/irq-riscv-imsic-state.c
> +++ b/drivers/irqchip/irq-riscv-imsic-state.c
> @@ -794,7 +794,7 @@ static int __init imsic_parse_fwnode(struct fwnode_ha=
ndle *fwnode,
>
>  int __init imsic_setup_state(struct fwnode_handle *fwnode, void *opaque)
>  {
> -       u32 i, j, index, nr_parent_irqs, nr_mmios, nr_handlers =3D 0;
> +       u32 i, j, index, nr_parent_irqs, nr_mmios, nr_guest_files, nr_han=
dlers =3D 0;
>         struct imsic_global_config *global;
>         struct imsic_local_config *local;
>         void __iomem **mmios_va =3D NULL;
> @@ -888,6 +888,7 @@ int __init imsic_setup_state(struct fwnode_handle *fw=
node, void *opaque)
>         }
>
>         /* Configure handlers for target CPUs */
> +       global->nr_guest_files =3D BIT(global->guest_index_bits) - 1;
>         for (i =3D 0; i < nr_parent_irqs; i++) {
>                 rc =3D imsic_get_parent_hartid(fwnode, i, &hartid);
>                 if (rc) {
> @@ -928,6 +929,15 @@ int __init imsic_setup_state(struct fwnode_handle *f=
wnode, void *opaque)
>                 local->msi_pa =3D mmios[index].start + reloff;
>                 local->msi_va =3D mmios_va[index] + reloff;
>
> +               /*
> +                * KVM uses global->nr_guest_files to determine the avail=
able guest
> +                * interrupt files on each CPU. Take the minimum number o=
f guest
> +                * interrupt files across all CPUs to avoid KVM incorrect=
ly allocatling

s/allocatling/allocating/

> +                * an unexisted or unmapped guest interrupt file on some =
CPUs.
> +                */
> +               nr_guest_files =3D (resource_size(&mmios[index]) - reloff=
) / IMSIC_MMIO_PAGE_SZ - 1;
> +               global->nr_guest_files =3D min(global->nr_guest_files, nr=
_guest_files);
> +
>                 nr_handlers++;
>         }
>
> diff --git a/include/linux/irqchip/riscv-imsic.h b/include/linux/irqchip/=
riscv-imsic.h
> index 7494952c55187..43aed52385008 100644
> --- a/include/linux/irqchip/riscv-imsic.h
> +++ b/include/linux/irqchip/riscv-imsic.h
> @@ -69,6 +69,9 @@ struct imsic_global_config {
>         /* Number of guest interrupt identities */
>         u32                                     nr_guest_ids;
>
> +       /* Number of guest interrupt files per core */
> +       u32                                     nr_guest_files;
> +
>         /* Per-CPU IMSIC addresses */
>         struct imsic_local_config __percpu      *local;
>  };
> --
> 2.20.1
>

Otherwise, it looks good to me.

Reviewed-by: Anup Patel <anup@brainfault.org>

@tglx, Is it okay to take this through the KVM RISC-V tree
since this change focuses on guest files used by KVM ?

Regards,
Anup

