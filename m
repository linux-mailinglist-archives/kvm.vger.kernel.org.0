Return-Path: <kvm+bounces-69345-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2CnqBJcmemlk3QEAu9opvQ
	(envelope-from <kvm+bounces-69345-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 16:09:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 817B9A38AA
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 16:09:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2C394300D9A4
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 15:09:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F170E369220;
	Wed, 28 Jan 2026 15:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="eR7/rc//"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE09F35292A
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 15:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769612939; cv=pass; b=PgQzFpzn8v4BcrtSApMxXBPPbdkBAfl+9cL3kCAGr4skO9u3an2ZPTEDoNgRRu5zPf997Pc5O4rIug+TNhAmG9QtK+DChYLr8OruR18QEX/sDtVsqaeqG1yp7ymfPHnoCE9N5P8C8i1W/DzotMUjtScsylQBicVFTAsK2mBNvgM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769612939; c=relaxed/simple;
	bh=2vIIfffTNNcgcjN5R0wPRAfod4H4EfKgIF6jZgv76do=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PhCnpUuFs8u0I62k6ZhSbiqJhmelw1jFe2VsSWZ+QQBN5UGJzOUEagKLu87sUhaMBMfm3Nfrj2QNfeE/HNRXONpIXvoZoUjvS5BQHEYiqBEY2k2mYx1V9vkGEHfJvSGdf9rNRgqy5MmzkYu4CAQFShy3SCwEZ4Sz0kXO1PgIlV8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=eR7/rc//; arc=pass smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-45c733ccc32so2249307b6e.0
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 07:08:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769612936; cv=none;
        d=google.com; s=arc-20240605;
        b=C5rW1oiJrjvL1D150CsY6CK+ennk6Q1a08NppPRc8JTV+ZsCKozzbPyLI6XGJs0uXW
         l36sYeYc9DRQ3MwvcY7AXztGNVmKvLxUsHAIHZa52oaKX2oJYtnyCpKKJReaxLrMqkdF
         n5v5feMJ3Ly1T6yvM2G7AoKWlGDLDVolGaUWeMHiAQlqf2MbRVvAa8CaufvcPjSpIQhz
         MNx6bE4/2QwQZxcbpfuHze9Jd/1taoShjfJ5lmuv52TD19Itk+JK7ppBCzwFl4LJXB66
         3zY/PAdTe6j8zUHzB4ngxvV3VGUt6TcqGjN15pTVHd6gehuQdw2Lc0x2xHOAN3WGsmD4
         8P1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AxMPzN53EYgjdk6Vy1nZn5p3hSqaa1HYt69dzR2C85k=;
        fh=mIydKQut2v0IsB7bGe4u8AZEBY4fYCCzH6VZEjkNthU=;
        b=Qd5iCGTh2lqMzTDyPbIksaHtxXKPXxPAMAZojJ3Ob0rlMXZdAVrRxwiYLIXuYeO+CV
         20iDn/yB5cUe5zqPjDWgUHSW6iBbPGGtKHrxKAdyUDAJLrVDEA4e/Zcj4xrQg4GzGUyc
         NnkYzNOMr+h8Dn3OiKwjs9xNJsfwTh51pKiWz5XRrmlNt8/YlQ9NNguoKMnldBxDM0nl
         oGypvhJC4xcHEyxb84TJZg1qdZOd6hlOvzzXFtVUUqdF5yrI2kggbOsea/IxqzG3mxnu
         9ocFDfzPhfKRGGAAw4k3XktaTQobkYbHKZnRLUrxSfngriSZucoLsg1U+HiMU390iRjq
         tLuQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1769612936; x=1770217736; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AxMPzN53EYgjdk6Vy1nZn5p3hSqaa1HYt69dzR2C85k=;
        b=eR7/rc//uCyjL1keUphNWAse0ijISfQESoCLEGX+eHTfycDt8XPlc2iN1UqQsGXfoP
         tI0q59o3mr549yXUAvFCKPaxBOIJxLGwIb9TatjKn+9C0bHYthyj881QsJqpdQqd6quO
         k/3XxGROCIYBUrs6Yub2mRh3HZ16spgbgshQE0RLh43bcXEvBKV1cF+EXkW7mtqYbkjZ
         FOxBB7PuLZ0HV42EMEEK5mblUsJcPKBpDC2MQHCBI1JlKP1KlknhR/Gcy238Kv4+xdMx
         yUofIDliOD5NSsIBB1e5uHEP++WVAnBu2ujvHvKKd215wmgYENWR2tlQFRsWOd2C/UP0
         RcDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769612936; x=1770217736;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AxMPzN53EYgjdk6Vy1nZn5p3hSqaa1HYt69dzR2C85k=;
        b=sXE5ESksU8Zfv3M19lRhGjgQZGyBSkYnMS1044/62lgPcOP+O/prnIBJi3C4y3J3vD
         A7hdJ3RxxmDl8iJwBQp/Q7TQVcwDmzIf/LDDJqvTaiC3/xiQV+bTIIIW9ElqQbMh2k4K
         7/7Oj7Lfpbxn9UntwCCR3IYeFCVDF4vyLuGHBH9MPzmuAUlBdJy2P7owU0QsqOEsC4EB
         Cj5qrSe9Y7DDCxj5aj9ZJjzGxdrTtVFzdtrHL3pk6V6ddKfHn4lFCiO9ai1mO1h0poEj
         tg+e37KJzKfTcIfl4ONTJkWtN63y3LJZvL5Py+bG5cVpe69liDjClwqNhcd1bkszTRlQ
         uVAQ==
X-Forwarded-Encrypted: i=1; AJvYcCUYu+P1LeEotJ2jhLH8sdXl5CIZIjuEHlcdKQj11NFg9KwHBxK6OY/HiBE2tdTNYb9hOPY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdSaWPnMVXWWa3wSutZxG0VYNCAvclbkBmIwIohE4528cT9UZX
	i9R9EV2Phyhk1lGQXsbHQcoSzErWRTsCkgdxhn9bLUeQ2QKHrEPWdXRX9fiDsVUnxwo2ZeXfpDL
	vQp6iMYsURKkNNdSwjhqnQVhkPZh6mC2jfMpjTwyCLmk8dQ+NrCbT
X-Gm-Gg: AZuq6aJL8/z4AJHxqDd9T1uefeAdXryGLVSwGJWsJzJPZ8s8nBrHYDqU2Pi2JKHzpXM
	B9vnaCkJMzhc3Qut0DeljLBLA9BA3hsxLp0rwcyw57DJrb88VA0vugeE5bFhzC3FudzP3X+J7Al
	8n+ObS+GjVjLuOdk/7X9nV9MokpoMP9vtAGgMIuyIVuNgi7hlEYLcYyOs1m05RPMIyWUM0UW4jq
	vabPi4jgwQ3LjyAH8zWLywSmJ6Yw5LDQa3Z8+sqJWSucl9JO0pNGXP4g0CaOstOADmeGIj3EIj8
	l+/wdeNfrc+hn2Tb1R1TKtwxoqhTYyfN42LLhP9wWUkL1WnmsThQX/S2AmI=
X-Received: by 2002:a4a:edc5:0:b0:662:ffb2:c5eb with SMTP id
 006d021491bc7-662ffb2c7dbmr710171eaf.38.1769612936518; Wed, 28 Jan 2026
 07:08:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260127072219.3366607-1-xujiakai2025@iscas.ac.cn>
In-Reply-To: <20260127072219.3366607-1-xujiakai2025@iscas.ac.cn>
From: Anup Patel <anup@brainfault.org>
Date: Wed, 28 Jan 2026 20:38:45 +0530
X-Gm-Features: AZwV_QgU7EEvN2RGRe6P5jSnLHFztiDjeyvI6uk4oEgv6ph_m4-rthrrImh9DQ4
Message-ID: <CAAhSdy2z+8X3mgdfh5NOyJdJrH91honoAKzru+q8y1_D4pakRw@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Fix null pointer dereference in kvm_riscv_aia_imsic_rw_attr()
To: Jiakai Xu <jiakaipeanut@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Jiakai Xu <xujiakai2025@iscas.ac.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	R_DKIM_ALLOW(-0.20)[brainfault-org.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[brainfault.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69345-lists,kvm=lfdr.de];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anup@brainfault.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[brainfault-org.20230601.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,mail.gmail.com:mid,brainfault.org:email,iscas.ac.cn:email]
X-Rspamd-Queue-Id: 817B9A38AA
X-Rspamd-Action: no action

On Tue, Jan 27, 2026 at 12:52=E2=80=AFPM Jiakai Xu <jiakaipeanut@gmail.com>=
 wrote:
>
> Add a null pointer check for imsic_state before dereferencing it in
> kvm_riscv_aia_imsic_rw_attr(). While the function checks that the
> vcpu exists, it doesn't verify that the vcpu's imsic_state has been
> initialized, leading to a null pointer dereference when accessed.
>
> The crash manifests as:
>   Unable to handle kernel paging request at virtual address
>   dfffffff00000006
>   ...
>   kvm_riscv_aia_imsic_rw_attr+0x2d8/0x854 arch/riscv/kvm/aia_imsic.c:958
>   aia_set_attr+0x2ee/0x1726 arch/riscv/kvm/aia_device.c:354
>   kvm_device_ioctl_attr virt/kvm/kvm_main.c:4744 [inline]
>   kvm_device_ioctl+0x296/0x374 virt/kvm/kvm_main.c:4761
>   vfs_ioctl fs/ioctl.c:51 [inline]
>   ...
>
> The fix adds a check to return -ENODEV if imsic_state is NULL and moves
> isel assignment after imsic_state NULL check.
>
> Fixes: 5463091a51cfaa ("RISC-V: KVM: Expose IMSIC registers as attributes=
 of AIA irqchip")
> Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
> Signed-off-by: Jiakai Xu <jiakaiPeanut@gmail.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Queued this for Linux-6.20

Thanks,
Anup


> ---
>  arch/riscv/kvm/aia_imsic.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
> index e597e86491c3b..bd7081e70036d 100644
> --- a/arch/riscv/kvm/aia_imsic.c
> +++ b/arch/riscv/kvm/aia_imsic.c
> @@ -952,8 +952,10 @@ int kvm_riscv_aia_imsic_rw_attr(struct kvm *kvm, uns=
igned long type,
>         if (!vcpu)
>                 return -ENODEV;
>
> -       isel =3D KVM_DEV_RISCV_AIA_IMSIC_GET_ISEL(type);
>         imsic =3D vcpu->arch.aia_context.imsic_state;
> +       if (!imsic)
> +               return -ENODEV;
> +       isel =3D KVM_DEV_RISCV_AIA_IMSIC_GET_ISEL(type);
>
>         read_lock_irqsave(&imsic->vsfile_lock, flags);
>
> --
> 2.34.1
>

