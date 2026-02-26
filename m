Return-Path: <kvm+bounces-71921-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6GQ0Bo/en2kxegQAu9opvQ
	(envelope-from <kvm+bounces-71921-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 06:47:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D2FF1A118B
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 06:47:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B4D81305261E
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 05:47:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 028D82C11F8;
	Thu, 26 Feb 2026 05:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="Avc07ziP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F1042049
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 05:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772084865; cv=pass; b=gob4434D+c9vPDZD4bdjgdYxP3952Kkj4rGEGzBIL43aBpro9hcUwUiZtvXaPLQIinJzOkEaTzDyqWMKkFFoFTmyUDARGE/TFTQSLC5oOwq92bvW//pXVevWsdry56b9l2/Y4iWgdO1pJQfVYzPE9/3K9b/Db8ljxMJnBOxihzk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772084865; c=relaxed/simple;
	bh=AMrEO+vtkO4rCyaBLY1x4K+Li2oIznquYtMoRe4jXKk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gHMo3VJ3VjXSKx6wMqzL8btFlJGt/hwzOm0Mj89NoSrmH27nJvbPPIN5ehDyXXiFBEu2Hgyf61nINk9iYs7K5LfeNdkrNgtQkEbplNNIzxXW5igIhckn+V89hV6VfdLszZjOM4ZVIn5U3Q0ud1bDOAKmiONA7lSqAqBC5zrQ6ng=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=Avc07ziP; arc=pass smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-6774d63d2e0so234390eaf.1
        for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 21:47:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772084863; cv=none;
        d=google.com; s=arc-20240605;
        b=JPgnTGiR3ru8R6FTHuzTfoxHC/yetQygGfYTkSNLhAfwlhB+Bo//DPAsdWNy1nichJ
         QeqNXVVOtFdNn/nI9bBmh34xQinkey6JGsmQ9F2zNirB9oISpls0AgYi3j1vZwtmSF5R
         wfP7GjXlOf4BsHnqAJ0//6+G3f2ftmLjQjL8wC5a3JXqkoB6q0kASw09BrCmpn9QdIQu
         KlrNFF97fPNEewA3ravMhCrPa1FeGDgRA5eZ36ScAe3pVSWzMBVHFgHK2CYNbEJV83NU
         TLAMOGgZw1hDIDi6LV9ph3C+gR2BPRmjZI6x96wssjRe4wAXHcNX9rCN0Uknir8qtBwc
         nZLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=b3GT5Na22u0rkZZPCLAOp9C1u+Nx1823EYWE29L6QxQ=;
        fh=1WcvDPJ/CL5byE/mEfLxUUODBOIm+o/VzZ6oOTsBLcg=;
        b=cQJg0+kgUAV+t83u8hXBvHTbOY5hpfnE8oa2/vkCQv7KkjjFrrM57eM6KBgJXe8hTS
         vN3IDYPjWHxEUDw4yLxp8gYbmsLBCMF2JVhy6iTPH4KeqDZn4tSbfZcXrqZY3j7kIUve
         Iq0xYkl4gXc/bYL7oUfEB4p3tsklgNCyYH5djAprk0UWZZUy3r/x9te52E4ibmwuYxUg
         x+jp+TJ879nlSWmlHKgPAYX2UekmAXbjip0GACDR6s/OUGDQvLC3t0ZW8ZBaLSRMxklB
         e4sPig1x/E6PwIKYOOhroV+weMoDauLhtcJjRAs9Oi+6I8kfZLA6LsVFeCLugsgOOUMB
         9nyw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1772084863; x=1772689663; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b3GT5Na22u0rkZZPCLAOp9C1u+Nx1823EYWE29L6QxQ=;
        b=Avc07ziPMHMLeVhDOoPKSiu8GNN5byJ3e9t/qC0yIj07Y6BjNttpsJmiuAth8MQtYY
         36KhQkyCcWGljoHblBMvuHW39+Kg3TxgOLG2QzzCGmAhvDWJ3cHSvFHNzaNtTDVmXOIF
         qeblZbz8GICCi4vYOp9bF8O3TumccuKoHSLdSJWzRWv+6cVgabUq/csU0KyKK5aCOQrT
         E8JWGPExxqxhgiTS/ZOTAkdhTnaxczoqZJHXz12J2MPbSxCxrTJGiDDyyVGCANh5FnjQ
         oJq0S43vEn0B84KTm7yzibkwj253TXUAlZ4yGD+Hob8plkNn8mNXU0SmkmO5096GZt+Y
         1ptg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772084863; x=1772689663;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b3GT5Na22u0rkZZPCLAOp9C1u+Nx1823EYWE29L6QxQ=;
        b=R9jSWobPboqPHKI0eTD/56T+xnvVlATQmspkBMgJrLABnRAUghnDBjDopIUC+FR/MA
         aWJsDtS4iq2QBQ9n6coeFWaTR12pI14KfPJpHnlvkrjQfq5xXL0wxBjIf3Qew0TWuTMn
         6dcr1b2EuNkut2QZLrlXV8iRI/4dqMd9NeuAIJFc8gRBktFwlkxov4Lu43TW+tV4VVVS
         WZ8uHH9Mubm0cKA8qHNgqTI73OQT57liyn5iu7wCaQHdT//Yz/VeQ3nlCTHxdYvjURvj
         HwVE4BcwEcUYE7FFjL9JzEWP4TapjhnsG3/06MoiYDjxqz27uHVhLonOfsTNPVizeMno
         i+AA==
X-Forwarded-Encrypted: i=1; AJvYcCXzVkk2g57WoRPJBu94yC5cO2Zi8U9DJTgn7bzgWJiplZxS2+PS5Gjufvs4IhID30TxcKs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyiFBRclZM6maHZ1mn7Y37VXFQ4RKcmDq4xD08vIam4DeW5mq0+
	beYbo7wfnRPiswzcuwN3+/Armb3trVonj9uVtT5+2dmw7n4yKR7HGXaJiIurLFFtiZUHm8PdTGJ
	NZJj8Hr1Cl7gkohqdZTWMad+NcWJfU/Xep+LSB0w/og==
X-Gm-Gg: ATEYQzzno3E7DCyF6RwT25KF+J+VV2Uz6RpMi9NwYqOmGpwGoUgz7HfZ2/fy2dsAv9J
	Pi7nDoLIER5wC40aoF/fraX4KHXcP3iK3mqnNWeI7hMZPf5am2YeMLxdKZdNZ/236eSghd21hag
	12h7Y/fao/jsFho6ThjspmMj3jntoYEHcoLJrgS2BuCO4RjWWqKgYqji/BVMdC27EzBGDPydpFw
	OVwshNVPA7argH9pHWK+qS7lewa2pDX8Hw525xV7gyqJQScoF5XTgORfZNv5RjlXAD4rA3MdOnK
	i4RTs+chukHCr57JFL6jFMBkGpt3QT2xv24vDpfR2h9fN5Nio4GfYZyYi/Pwe3GSJaN7pk0+BPP
	UXZQFJHtkW3rDHjqtXjHtt3ZulAY=
X-Received: by 2002:a05:6820:1892:b0:679:a5d2:569b with SMTP id
 006d021491bc7-679ef97d50bmr1284924eaf.40.1772084862848; Wed, 25 Feb 2026
 21:47:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260116095731.24555-1-lukas.gerlach@cispa.de>
In-Reply-To: <20260116095731.24555-1-lukas.gerlach@cispa.de>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 26 Feb 2026 11:17:31 +0530
X-Gm-Features: AaiRm50VNfj9kpGvvhZpT9bmuFIeIxzxQ2bB45ExZQGoqQfOYd839ZCCNnG0AHA
Message-ID: <CAAhSdy1g7pYoF5uXMx4L9zVkRHd8Fj2SMgsc3MS7sQkh74eELw@mail.gmail.com>
Subject: Re: [PATCH] KVM: riscv: Fix Spectre-v1 in APLIC interrupt handling
To: Lukas Gerlach <lukas.gerlach@cispa.de>
Cc: atish.patra@linux.dev, pjw@kernel.org, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, alex@ghiti.fr, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	daniel.weber@cispa.de, marton.bognar@kuleuven.be, jo.vanbulck@kuleuven.be, 
	michael.schwarz@cispa.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	R_DKIM_ALLOW(-0.20)[brainfault-org.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
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
	TAGGED_FROM(0.00)[bounces-71921-lists,kvm=lfdr.de];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anup@brainfault.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[brainfault-org.20230601.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[brainfault-org.20230601.gappssmtp.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 5D2FF1A118B
X-Rspamd-Action: no action

On Fri, Jan 16, 2026 at 3:27=E2=80=AFPM Lukas Gerlach <lukas.gerlach@cispa.=
de> wrote:
>
> Guests can control IRQ indices via MMIO. Sanitize them with
> array_index_nospec() to prevent speculative out-of-bounds access
> to the aplic->irqs[] array.
>
> Similar to arm64 commit 41b87599c743 ("KVM: arm/arm64: vgic: fix possible
> spectre-v1 in vgic_get_irq()") and x86 commit 8c86405f606c ("KVM: x86:
> Protect ioapic_read_indirect() from Spectre-v1/L1TF attacks").
>
> Fixes: 74967aa208e2 ("RISC-V: KVM: Add in-kernel emulation of AIA APLIC")
> Signed-off-by: Lukas Gerlach <lukas.gerlach@cispa.de>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Queued this as fix for Linux-7.0-rcX

Regards,
Anup

> ---
>  arch/riscv/kvm/aia_aplic.c | 23 ++++++++++++-----------
>  1 file changed, 12 insertions(+), 11 deletions(-)
>
> diff --git a/arch/riscv/kvm/aia_aplic.c b/arch/riscv/kvm/aia_aplic.c
> index f59d1c0c8c43..a2b831e57ecd 100644
> --- a/arch/riscv/kvm/aia_aplic.c
> +++ b/arch/riscv/kvm/aia_aplic.c
> @@ -10,6 +10,7 @@
>  #include <linux/irqchip/riscv-aplic.h>
>  #include <linux/kvm_host.h>
>  #include <linux/math.h>
> +#include <linux/nospec.h>
>  #include <linux/spinlock.h>
>  #include <linux/swab.h>
>  #include <kvm/iodev.h>
> @@ -45,7 +46,7 @@ static u32 aplic_read_sourcecfg(struct aplic *aplic, u3=
2 irq)
>
>         if (!irq || aplic->nr_irqs <=3D irq)
>                 return 0;
> -       irqd =3D &aplic->irqs[irq];
> +       irqd =3D &aplic->irqs[array_index_nospec(irq, aplic->nr_irqs)];
>
>         raw_spin_lock_irqsave(&irqd->lock, flags);
>         ret =3D irqd->sourcecfg;
> @@ -61,7 +62,7 @@ static void aplic_write_sourcecfg(struct aplic *aplic, =
u32 irq, u32 val)
>
>         if (!irq || aplic->nr_irqs <=3D irq)
>                 return;
> -       irqd =3D &aplic->irqs[irq];
> +       irqd =3D &aplic->irqs[array_index_nospec(irq, aplic->nr_irqs)];
>
>         if (val & APLIC_SOURCECFG_D)
>                 val =3D 0;
> @@ -81,7 +82,7 @@ static u32 aplic_read_target(struct aplic *aplic, u32 i=
rq)
>
>         if (!irq || aplic->nr_irqs <=3D irq)
>                 return 0;
> -       irqd =3D &aplic->irqs[irq];
> +       irqd =3D &aplic->irqs[array_index_nospec(irq, aplic->nr_irqs)];
>
>         raw_spin_lock_irqsave(&irqd->lock, flags);
>         ret =3D irqd->target;
> @@ -97,7 +98,7 @@ static void aplic_write_target(struct aplic *aplic, u32=
 irq, u32 val)
>
>         if (!irq || aplic->nr_irqs <=3D irq)
>                 return;
> -       irqd =3D &aplic->irqs[irq];
> +       irqd =3D &aplic->irqs[array_index_nospec(irq, aplic->nr_irqs)];
>
>         val &=3D APLIC_TARGET_EIID_MASK |
>                (APLIC_TARGET_HART_IDX_MASK << APLIC_TARGET_HART_IDX_SHIFT=
) |
> @@ -116,7 +117,7 @@ static bool aplic_read_pending(struct aplic *aplic, u=
32 irq)
>
>         if (!irq || aplic->nr_irqs <=3D irq)
>                 return false;
> -       irqd =3D &aplic->irqs[irq];
> +       irqd =3D &aplic->irqs[array_index_nospec(irq, aplic->nr_irqs)];
>
>         raw_spin_lock_irqsave(&irqd->lock, flags);
>         ret =3D (irqd->state & APLIC_IRQ_STATE_PENDING) ? true : false;
> @@ -132,7 +133,7 @@ static void aplic_write_pending(struct aplic *aplic, =
u32 irq, bool pending)
>
>         if (!irq || aplic->nr_irqs <=3D irq)
>                 return;
> -       irqd =3D &aplic->irqs[irq];
> +       irqd =3D &aplic->irqs[array_index_nospec(irq, aplic->nr_irqs)];
>
>         raw_spin_lock_irqsave(&irqd->lock, flags);
>
> @@ -170,7 +171,7 @@ static bool aplic_read_enabled(struct aplic *aplic, u=
32 irq)
>
>         if (!irq || aplic->nr_irqs <=3D irq)
>                 return false;
> -       irqd =3D &aplic->irqs[irq];
> +       irqd =3D &aplic->irqs[array_index_nospec(irq, aplic->nr_irqs)];
>
>         raw_spin_lock_irqsave(&irqd->lock, flags);
>         ret =3D (irqd->state & APLIC_IRQ_STATE_ENABLED) ? true : false;
> @@ -186,7 +187,7 @@ static void aplic_write_enabled(struct aplic *aplic, =
u32 irq, bool enabled)
>
>         if (!irq || aplic->nr_irqs <=3D irq)
>                 return;
> -       irqd =3D &aplic->irqs[irq];
> +       irqd =3D &aplic->irqs[array_index_nospec(irq, aplic->nr_irqs)];
>
>         raw_spin_lock_irqsave(&irqd->lock, flags);
>         if (enabled)
> @@ -205,7 +206,7 @@ static bool aplic_read_input(struct aplic *aplic, u32=
 irq)
>
>         if (!irq || aplic->nr_irqs <=3D irq)
>                 return false;
> -       irqd =3D &aplic->irqs[irq];
> +       irqd =3D &aplic->irqs[array_index_nospec(irq, aplic->nr_irqs)];
>
>         raw_spin_lock_irqsave(&irqd->lock, flags);
>
> @@ -254,7 +255,7 @@ static void aplic_update_irq_range(struct kvm *kvm, u=
32 first, u32 last)
>         for (irq =3D first; irq <=3D last; irq++) {
>                 if (!irq || aplic->nr_irqs <=3D irq)
>                         continue;
> -               irqd =3D &aplic->irqs[irq];
> +               irqd =3D &aplic->irqs[array_index_nospec(irq, aplic->nr_i=
rqs)];
>
>                 raw_spin_lock_irqsave(&irqd->lock, flags);
>
> @@ -283,7 +284,7 @@ int kvm_riscv_aia_aplic_inject(struct kvm *kvm, u32 s=
ource, bool level)
>
>         if (!aplic || !source || (aplic->nr_irqs <=3D source))
>                 return -ENODEV;
> -       irqd =3D &aplic->irqs[source];
> +       irqd =3D &aplic->irqs[array_index_nospec(source, aplic->nr_irqs)]=
;
>         ie =3D (aplic->domaincfg & APLIC_DOMAINCFG_IE) ? true : false;
>
>         raw_spin_lock_irqsave(&irqd->lock, flags);
> --
> 2.51.0
>

