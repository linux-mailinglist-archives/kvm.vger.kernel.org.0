Return-Path: <kvm+bounces-72364-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +BRzJQqHpWkeDAYAu9opvQ
	(envelope-from <kvm+bounces-72364-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 13:48:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E439F1D908B
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 13:48:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 47D803063A2C
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 12:42:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5609379EDF;
	Mon,  2 Mar 2026 12:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="qEvRxe33"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24EA5375AB1
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 12:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772455326; cv=pass; b=fPYiwAnLXMGxijFsgXnDxHkesGMmYf7KNsWI9yee+W+MdPrla74+2IuMvJCbT1dus3lZd1FF//WwPHXMBJ2WOCJSwk6VeO+lsmNmuFTdzqVZ9crD2wKsjETr4DeS2McciTUa/UkhYe2oIF6BOAsoSpbsxfXO538OjcNGye49agE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772455326; c=relaxed/simple;
	bh=J8mcnPQRMM16AfzpwxoSnbUcufuk7yQKcrN91FwaIhU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p8jerC/7ku9CErxal160he/r2jAJXJ4i8mm4RTrWWAArkAgvvHyw6R4AR6a4exNqOichbrogTxr/mnJtHpNRvtF8BsgNIbN0XFmqcmubx+04ZoKYJ6CP+KLtPiyuy7m2i733vqYq+cLNYk6XXb0boOf6OlN9uU/ydLSduuT7Xp0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=qEvRxe33; arc=pass smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-662efd1bdd4so3321426eaf.0
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 04:42:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772455324; cv=none;
        d=google.com; s=arc-20240605;
        b=QGgeO/6eclxNQY9leC1PlUurv6yIXkbqDZO4saKPzV7RbV6+J7dfXxxSGy6MVq5s1s
         ABGlyP8tuy36beDAHiCB55C4p13+WJ40h3ljp2r7YQQX3l0ILFtNnIua9kBykJ1bgb9Q
         i69yOi6GSpCKJTXQL76vDO1wxqzPNssP7E0mS1ToPM7MJjmNDxaywBn7859G2pN4O4Ix
         SwVpXYywHGhkKTAXYG/ittetTaowlLEcO+OON11LxfyOpJUh2+5UHv68ITQ4jWZYb/rK
         Ylhqn4bvhh0Sr2fTXTttBa1tzne3HaSjbtrn1plak7mE5TEqukujqWIaU5TSrGOTXVxb
         qUoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TqH8bjVKYuJk4mYqZYpIrfX37amSQklOJO7cCy6+3yA=;
        fh=XIasJdVTQpa+TP0V/NrmNLozX3Z09Wtb2drXsoUO3Q4=;
        b=jjpH8V62kXDa1zbdPixU9ZRCeMNn2u3Le6zaEixFoj4fF1TLUEl0/TDLcFPf/xKnAB
         Jpw47//eeMlAGB5XTJ5We07WNvmkAF8JFfDCldVMkW0B6MuDikFLmzj29iagxBsBgjop
         OQ1maNii87cY+cTTNmP4n89g3/CpAqllJH45lkS15EJHN5sJoe/3ab91PnkghY9n93bG
         Hh0MSiILEwU4AImAxkNs8STzIqxRhcsyRXpN8vILx4E1OR8/ryVYLGzITj7nXbHHHN6z
         t2bO2xOYSEcJeUm0jCBKXjlrgyW4IcBMPiMY2OthpiCospMX9bfUu5/5Tm18rp3Kyr7F
         ZQSQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1772455324; x=1773060124; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TqH8bjVKYuJk4mYqZYpIrfX37amSQklOJO7cCy6+3yA=;
        b=qEvRxe33BqU3AV9DQnCfBMRsrcL7FkmO7rOWyGbRfJRz7i5Okw7BpqVt7Pp2c5nVLo
         XUn/043TrWyH00A/C/2SIMED1yn45ZYiZ25ksm16MATusXXPGBkeoScXxNMey5ZfKtAU
         JYcXuypxs4vgohn4ZadN1QAfjoTVPWXOAekjfOmvZfhaDzhPagnKSEgV43A00KtxAcOr
         2t9MLKIJfvsVoyw9GryD+O3n+6acso6SMjHq+uUQYkhdSbmt2imX/V338440UpiWxT0+
         UBDG/v66J625zrQM7o53qVUxb/xT33/QtL+A0xFEH1EnvA0VBTRMSGxwceDsoCHkJ1AX
         pPaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772455324; x=1773060124;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TqH8bjVKYuJk4mYqZYpIrfX37amSQklOJO7cCy6+3yA=;
        b=jTPCO9At2AjnERz8/uPWHknCVgy9OcVGqt7fWMPHt/clhOXyevs31deXhDNPvIEM/v
         kzYRPeJ83+kwFpzz0z1zAdyEDkR5Dzzw9+Oyy6eSPQCdpmI/59BJ28yW7PDp87rdLhQY
         9XyQYubKoWdW9LrkJJAtgnhwz1V5rVLDuCBardPb9M8WXksfdscoDW6GYWiewgl0pnBX
         qhtmtCccyEXSdwPr0eibBiXk542LxY5wN8bCAOqnWUR7ki51eMn+PxMnbHqbgf2ad0tJ
         WVn8Z3vrMCbBo/+GggYHuAaaLgUjKli2zp0xDNezoMJLgabV2kHuQtWpTYcRkuWibjc1
         By+g==
X-Forwarded-Encrypted: i=1; AJvYcCVGOvg2TOO0NVEN9f5tPtmybGC6u1bXaUxvti39kgctGs+3jKxE7xB3IKYUd5BBvNwzI5g=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUKYLfnlqf5A/Ad+Z1bnsYA9gERysrDtUCemD/vZ2iWvm/Fl01
	quWxqFkCk5p6zdGD3vr0B/mw4p/WN/nFYkqAIHUgOpEcygYPUTOv3hLuM2HgPIvMpV9pWgZMlN/
	XvQzymCc9fu6gOzQR/mlVZ2Piw3h7IqguHu99nBxeBw==
X-Gm-Gg: ATEYQzzJcvEtL/XvZGLdxVB5F4lIVj++H82arfCPnZZboBspdrhZDyERS9UF5qmEtcc
	M55yjI5adrEKDsVdKOHUt/bWGkxji7cFCiYFwgzUF3gbIMus87rx2L4UyLt5jxaueo3PwudkUXH
	G5kbWYsZZK6SrZKwC3ymPguFQBXesIlD3dHjtm0b6UQ50i8p3GOYyORJ+mdOr2x8dfpf8WNCfJH
	oVObHfcGWNLUQOHKJwsUCNWsh1z6do7Sl6dv/oBUXlrQJfrhex/THEdRavYMC16ife54mWEKexh
	UvrR/p49gEQtJtesTKFAPH9uqx6OesfcEcvObz1fjTHoEj/tbgUfElIg91ip8y9uaMZ6Cz8Z0L1
	U8pafxYf1fgTJAmrnkiX9OHCp0Q==
X-Received: by 2002:a05:6820:1620:b0:676:da17:64d9 with SMTP id
 006d021491bc7-679f22e84f4mr8372171eaf.23.1772455323813; Mon, 02 Mar 2026
 04:42:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260302085312.1649738-1-xujiakai2025@iscas.ac.cn>
In-Reply-To: <20260302085312.1649738-1-xujiakai2025@iscas.ac.cn>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 2 Mar 2026 18:11:50 +0530
X-Gm-Features: AaiRm509bQrteogflTnAc3RIlej5HAafhwmATthLgoCfptB4BOs28sm4hELHMqM
Message-ID: <CAAhSdy1sRgjRxfjpe7hRNwywUSZmsiErfwz6PoPRzPuTVkxTOQ@mail.gmail.com>
Subject: Re: [PATCH v2] RISC-V: KVM: Fix use-after-free in kvm_riscv_aia_aplic_has_attr()
To: Jiakai Xu <xujiakai2025@iscas.ac.cn>
Cc: linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Atish Patra <atish.patra@linux.dev>, Jiakai Xu <jiakaiPeanut@gmail.com>
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
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72364-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_NA(0.00)[brainfault.org];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.infradead.org,ghiti.fr,eecs.berkeley.edu,dabbelt.com,sifive.com,linux.dev,gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[brainfault-org.20230601.gappssmtp.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anup@brainfault.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.993];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid,iscas.ac.cn:email]
X-Rspamd-Queue-Id: E439F1D908B
X-Rspamd-Action: no action

On Mon, Mar 2, 2026 at 2:23=E2=80=AFPM Jiakai Xu <xujiakai2025@iscas.ac.cn>=
 wrote:
>
> Fuzzer reports a KASAN use-after-free bug triggered by a race
> between KVM_HAS_DEVICE_ATTR and KVM_SET_DEVICE_ATTR ioctls on the AIA
> device. The root cause is that aia_has_attr() invokes
> kvm_riscv_aia_aplic_has_attr() without holding dev->kvm->lock, while
> a concurrent aia_set_attr() may call aia_init() under that lock. When
> aia_init() fails after kvm_riscv_aia_aplic_init() has succeeded, it
> calls kvm_riscv_aia_aplic_cleanup() in its fail_cleanup_imsics path,
> which frees both aplic_state and aplic_state->irqs. The concurrent
> has_attr path can then dereference the freed aplic->irqs in
> aplic_read_pending():
>         irqd =3D &aplic->irqs[irq];   /* UAF here */
>
> KASAN report:
>  BUG: KASAN: slab-use-after-free in aplic_read_pending
>              arch/riscv/kvm/aia_aplic.c:119 [inline]
>  BUG: KASAN: slab-use-after-free in aplic_read_pending_word
>              arch/riscv/kvm/aia_aplic.c:351 [inline]
>  BUG: KASAN: slab-use-after-free in aplic_mmio_read_offset
>              arch/riscv/kvm/aia_aplic.c:406
>  Read of size 8 at addr ff600000ba965d58 by task 9498
>  Call Trace:
>   aplic_read_pending arch/riscv/kvm/aia_aplic.c:119 [inline]
>   aplic_read_pending_word arch/riscv/kvm/aia_aplic.c:351 [inline]
>   aplic_mmio_read_offset arch/riscv/kvm/aia_aplic.c:406
>   kvm_riscv_aia_aplic_has_attr arch/riscv/kvm/aia_aplic.c:566
>   aia_has_attr arch/riscv/kvm/aia_device.c:469
>  allocated by task 9473:
>   kvm_riscv_aia_aplic_init arch/riscv/kvm/aia_aplic.c:583
>   aia_init arch/riscv/kvm/aia_device.c:248 [inline]
>   aia_set_attr arch/riscv/kvm/aia_device.c:334
>  freed by task 9473:
>   kvm_riscv_aia_aplic_cleanup arch/riscv/kvm/aia_aplic.c:644
>   aia_init arch/riscv/kvm/aia_device.c:292 [inline]
>   aia_set_attr arch/riscv/kvm/aia_device.c:334
>
> Fix this race by acquiring dev->kvm->lock in aia_has_attr() before
> calling kvm_riscv_aia_aplic_has_attr(), consistent with the locking
> pattern used in aia_get_attr() and aia_set_attr().
>
> Fixes: 289a007b98b06d ("RISC-V: KVM: Expose APLIC registers as attributes=
 of AIA irqchip")
> Signed-off-by: Jiakai Xu <jiakaiPeanut@gmail.com>
> Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
> ---
> V1 -> V2:
> - Fixed the race by adding locking in aia_has_attr() instead of
>   introducing a new validation function, as suggested by Anup Patel.
> ---
>  arch/riscv/kvm/aia_device.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/riscv/kvm/aia_device.c b/arch/riscv/kvm/aia_device.c
> index b195a93add1ce..ef944d7097d29 100644
> --- a/arch/riscv/kvm/aia_device.c
> +++ b/arch/riscv/kvm/aia_device.c
> @@ -466,7 +466,9 @@ static int aia_has_attr(struct kvm_device *dev, struc=
t kvm_device_attr *attr)
>                 }
>                 break;
>         case KVM_DEV_RISCV_AIA_GRP_APLIC:
> +               mutex_lock(&dev->kvm->lock);
>                 return kvm_riscv_aia_aplic_has_attr(dev->kvm, attr->attr)=
;
> +               mutex_unlock(&dev->kvm->lock);

Need to do the following here:

    mutex_lock(&dev->kvm->lock);
    ret =3D kvm_riscv_aia_aplic_has_attr(dev->kvm, attr->attr);
    mutex_unlock(&dev->kvm->lock);
    return ret;

Regards,
Anup

