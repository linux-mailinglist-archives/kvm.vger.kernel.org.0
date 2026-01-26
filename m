Return-Path: <kvm+bounces-69113-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QL+7DRJJd2l9dwEAu9opvQ
	(envelope-from <kvm+bounces-69113-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 11:59:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A000B87678
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 11:59:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3C5523044D41
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 10:54:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A630C32AAD1;
	Mon, 26 Jan 2026 10:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="0A66vpd9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5560632E6B1
	for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 10:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769424868; cv=pass; b=Ei77lj87i9FLOJWXQzWDKp3ElWyFw4Rh8LohTJdc6QnwiNlWom2G3+ifstSKj1fI9nPF1FrMfHQvnhwYxiUZRO9ijvJp8EpuUG9WbL+xHLjvKis57NozYuXnys15BttmHKZ+yvZw2vGpm6vyTSbnisWoMLz2J7DAte5maHYy/cA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769424868; c=relaxed/simple;
	bh=E20anVh3L0P89qAJwUSSqQZuCnIzED3kYnnVvc8RlJM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fOjP8Y5lPoLGHf4i/bKVDK90OTlfpCogOkHFr3wXUkE/FzxLa7bF5ojDQi3dydrhjssEByfg2YB+9xZe/WS5B605APvUknZLd+dEq9PN2nCZcfXpC+VZWQDQp6FAudHDLlERJ1mRclbYPB+dWh/20DnhCRxr/ir3MQn5qHZF62o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=0A66vpd9; arc=pass smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-661077c4d36so3838176eaf.0
        for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 02:54:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769424865; cv=none;
        d=google.com; s=arc-20240605;
        b=S3kBS+qEUMJej+G5Sq6t9hq9hZEmGez+EdnudXzOd0fRUojGsuNBJ+eqAtyju+SU9f
         NELApJXup5XxUQTy+deSQ37J6MxKYS3v/7bYiRn57LXDPeqTirqa9RfhciUjPrUNToui
         XXYDx+mKvy5tbOmBmI5q/szTFjld0hWIW5VYrZunfu0WWgSL5cAAKQrS8e826xnXshN/
         DJA4hCHc01aS2k2FsTCEaIpSrgCBA9rR3YKA0YsYbU6wIFmqu2LYViTZITCAcRS0m4UG
         m5T6DeleJ0JBL7nbwlrgtR9BE4nqcZWdiJGnrtL7TQDcM1hZtvVa0vcQDOdkwvlZnA9a
         +MAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lTdfseGGZOBXUDrJx1ZMNK+31Qww06+nWrd3/i+ViQg=;
        fh=vqrSUXO9wfSKWlKKGZMQ9+kb4TSk4cMqWabcRPS3S+w=;
        b=PCzKetTJHAVzlNxeCzMVTwtJbjbj3jUD4NuosPypoT/R/Mj5bin9hOkFHdrnHI95YY
         t+GdPNwe9T9mavLFC3NnV9gK1PGT0TQdtbtK46fmOeLYakwljZWwuOulSDFiqHpavHZl
         mKM8oi/FBAs1Twdm3iDvrL7mONK1CjY75zGesKR895Y+FjByyBSXoq+CehwIC4A3yY2K
         o5EU8Dlo1SiUEu+8KllnRbgUVqPVsjR01YM/b+q9qC6A2kD3SC3u983xS7CeO2qn02lv
         YAhsoQ3URMzACeqnqETxXzod7Wxp/nPG6JY1tega+QC0IhvyeHxzzqTvcok0PqPS8Qsz
         C4tQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1769424865; x=1770029665; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lTdfseGGZOBXUDrJx1ZMNK+31Qww06+nWrd3/i+ViQg=;
        b=0A66vpd9pHd/LTwf+V1EANdJksOP0bOOJOROp88I5u0u9aRt0s63CG1ucldIEmXgGi
         ckNKIK4ozNdmrjG71oeYSbnx0A/DU9/QxuR42fWn3JWx4Rq6o1z1XRiEuTNbFGvk10Ek
         xHDtBgsUBe44/miUzkmDQKbJ/AGutzB9GXtAGvRQw7pNr8UtErPaSz2GgBcOXYeuZPmb
         f/3JPgmfemCAhmcKsOugfwR+PxWEnKwaaHxdR34Uxrut0nSXQphhTudA8ftdvJO1nMBo
         hN9dZVLA/PxYumvR6QJpykz+3x/jYr8Lyo6gjJ8zO5lg7Lz6Tqs2zrJMRAlwbdPunPh5
         0gaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769424865; x=1770029665;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lTdfseGGZOBXUDrJx1ZMNK+31Qww06+nWrd3/i+ViQg=;
        b=WBUwg2VoxPO0++JuvO6v34xKGFrTydiFcM36eXW+Bzkx4dd3D0UDbadyilTew8rz67
         o4t8eshtm54+CLImKj5ZmBbRM86SG03ZkPKffPsPm1m1Np1fUItFxFdnv7Y1oDDMAvl8
         BCovBrzAVlYR8ViLeSGFpnVWxDQl/OUjOp7yUF5NdumvUhYwMjDLq1OK03x5RFBZh9Uz
         ShwsRBwHvU4YLcoPOcXZ1XsT1tcqiB8KJJQiwUPzI3TR3syFaso82RUPzgFJj0iLYaHS
         Lfkkt7UJRrVlR6S0uJsGqdrRS2/B4b4LPFOFBYxVj3P3HtJOfni3K86YVa+Oi4Djvfux
         DmVQ==
X-Forwarded-Encrypted: i=1; AJvYcCWtp6dNz0D63TW5T5vBTi636camWtQzcn/ydVQ2iPAIbtEoZn3HJgFIsTf097fKvvuaebM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwEgvFc1B6rrUGrwWX4Rc4A0iOYd4T+ttzW56cOZ/D/bmB6vos3
	z3EkrAE2fNbNlwg1FEIGw5SVsZykyZq6F+o1lLpUOoJwYwFVqJ2x2CI2ANZmpWIxw4/RS7/jPCk
	A3QUW0GqycMW0DnrU44ZFTKr7AP5wI4E+UTWmIPi5gQ==
X-Gm-Gg: AZuq6aKB7/7wXvVkUH0AyxzM1/9ECh4ZTDWWdT3I6f7QCI2UkPjK5gsKgm4NaUgj4MP
	ZQ8uo5ghNruBl0nwxwYnVdRcogpNXMOsXOfPXy0k5C+eJ3tlxe+yXxrXVib+2u2gPSoHIW4wBtp
	+JTN9T/f8l9yQEBhvC035BGPZGAaYVjvAQwXOYgFGTKNElnHCkgoS/My4+4d3kWOJAwyTasrg6w
	+FmjpB7aTObyWQrLYTxZw30VGKimtT3jUnjOsz/tNgYQDGXW7Qu4ug/+p5xam2MUON6CqiPLLKp
	ioaRTm6I6uPStXtGO3FuW2Qvg1wldgcxn/+ZQVaXqKwrvNrhflgP9jCK+KN5vFMeg7G4
X-Received: by 2002:a05:6820:985:b0:65f:cda0:e00d with SMTP id
 006d021491bc7-662e0a2ad14mr1878453eaf.17.1769424865038; Mon, 26 Jan 2026
 02:54:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260104133457.57742-1-luxu.kernel@bytedance.com>
In-Reply-To: <20260104133457.57742-1-luxu.kernel@bytedance.com>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 26 Jan 2026 16:24:14 +0530
X-Gm-Features: AZwV_QglBY6cl8dy5KVwFFrQ4xZeu7w6ijLW_ze3gtLkx6nEKiZ9nXTtQ7Ab3Ms
Message-ID: <CAAhSdy0krY4ou9TpGV=SKUKPNwgweB58QetUajb3HE5Jfy_RbA@mail.gmail.com>
Subject: Re: [PATCH v5] irqchip/riscv-imsic: Adjust the number of available
 guest irq files
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[brainfault-org.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[brainfault.org];
	TAGGED_FROM(0.00)[bounces-69113-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[brainfault-org.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anup@brainfault.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid,bytedance.com:email]
X-Rspamd-Queue-Id: A000B87678
X-Rspamd-Action: no action

On Sun, Jan 4, 2026 at 7:05=E2=80=AFPM Xu Lu <luxu.kernel@bytedance.com> wr=
ote:
>
> Currently, KVM assumes the minimum of implemented HGEIE bits and
> "BIT(gc->guest_index_bits) - 1" as the number of guest files available
> across all CPUs. This will not work when CPUs have different number
> of guest files because KVM may incorrectly allocate a guest file on a
> CPU with fewer guest files.
>
> To address above, during initialization, calculate the number of
> available guest interrupt files according to MMIO resources and
> constrain the number of guest interrupt files that can be allocated
> by KVM.
>
> Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>

Please carry Reviewed-by and Acked-by tags obtained in previous
revisions. Next time, I will not take the patch if previous tags are
missing.

Queued this patch for Linux-6.20.

Regards,
Anup

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
> index dc95ad856d80a..e8f20efb028be 100644
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
ly allocating
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
>

