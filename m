Return-Path: <kvm+bounces-69055-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oOCEO8WzdWlqHwEAu9opvQ
	(envelope-from <kvm+bounces-69055-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 07:10:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 415717FDFB
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 07:10:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7C9333009F25
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 06:10:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BDB83161AE;
	Sun, 25 Jan 2026 06:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="b++h4NX7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293DF5C613
	for <kvm@vger.kernel.org>; Sun, 25 Jan 2026 06:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769321408; cv=pass; b=jEpDgK7UIG8mfyl7ErLyi3MKL6hOgmMBfbHg58+m1nYIMj/8Z6DOX6BVCyCDirAiQIuE5RgAERheRDJ3Ec3GyyITdGGMY/Th8kTQdlWhow+N2mbqXSlMwof4kw5i2pl5Yr9i1jGUELIgN4C1CSa+5mGYWDCAUBK6DHjTe4wxHuc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769321408; c=relaxed/simple;
	bh=+LKj20w1nMOfFLIugpubn4SC7Iia6IKOJk73tlhKElQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P+EgecdoP8iJvFmDO/+9fMjXXiKQtyeKYdB5zMQCeCRYbBzUUxMmtO8JWzGaGsx3Z7VHN5wgszsH77JFDXkir4z0AxhxX6Kj0ge3zVGm0B6hh7sNGtpPAqTjJndu/EfhtJuhxZZ72Z9HR3W6FINxk5Cxm4vZgc9rDsBrmLY61bM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=b++h4NX7; arc=pass smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-40429b1d8baso951347fac.0
        for <kvm@vger.kernel.org>; Sat, 24 Jan 2026 22:10:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769321406; cv=none;
        d=google.com; s=arc-20240605;
        b=ffav92NfWFkYUT2dynJxINIztc5+UnBFFnmKNBQZ2SDBIowMm2QIvi0xuc/X9UvOXL
         Q8pJxT2pYqOcJKaG7pMAuLlGwx/EYYKxo87zIsif73a5BDtBWHqt713g3lhAjnZZLcGm
         oXZMrU8/dn13It3/S+94g25H/d/QmPFr8OWXa/MeTgdkIeq6nGAvdHBX+6Rj68KMHWDy
         +DNcVBZd2mshkacLEu/VPkPi8u4e3PXWcJklyPpcFHqYzOkY8UYLju/MfJ0IOhUshaBD
         Qdma2SFZnQa0D/Bqggg5VoUsqqxSoJJmohryM7/O4S+LzuYd3helqcdSYGYFmwrLpsXa
         B4Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WkWG8i5H6i4d8+T8dzsuYEcM3slSTCIiuQ3+RlWOG0s=;
        fh=SY546A4bzo4TWox7fB56m8eRdZ+RYbEpwnfI7XCFeMM=;
        b=X5KSBzXUAZ/Zvqzg0Xk2SxpDv4WJ82BP0Wu1t0Y/rQBLQVgQ00okUDgacF4c9tzX4n
         M953J1GdZCpRG4Fr8nlV0oAMUC17oUa89Z5pdMne1Kft4AqHhPMJ9vpoUgHXGP5/32SC
         WlIRzNTD1QHt7nrsK2GuN1BWJ7Ia3HduFvlwKg66rdIhKAXXecUykfB54xdItZvCWehQ
         OkqTZLpTdG+fNgh3P3tK237/yMaGxkIYsS/+FXaWoWJ5q7DRIEGuYvheR6t4rLQ1klLF
         vBoWs+QE4IhmMZAftfQxw2LbucHHvCKiw3z2Vk/9x0I1YYAPVpbMTrU6MliN12J56FgK
         FYmA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1769321406; x=1769926206; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WkWG8i5H6i4d8+T8dzsuYEcM3slSTCIiuQ3+RlWOG0s=;
        b=b++h4NX7bPPG6uWBxJFy2zLv+z0bAGL9PKluE/WVOx+oGrd2dfNaZYVu/+gOedGTFw
         rxFf7Ni+ezPt5xiuxskZ8j7KEm3Yc85x0ead+Y8fMGTmoi7o+wR96t+no98GbZKP/0Y9
         RfSmiAquNv2ayF6cTDUdSAJzrKrPe+QAeCv9WpSVESiOPspR+BmPdeI8zeGg7u4Huans
         lKkQCAHk4LDnKoBBPKTJZ5B3Z/Q+AZl4zLyoeZbeM2dC0xdy6LGCBfDlJMlpiLntRDxy
         Nli+RC18JO0Xjn19he+36V4LropIcVifKS7zM9STv+qFCZ85/ndgEB/9WWSxsZ43s7Cb
         Vn2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769321406; x=1769926206;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WkWG8i5H6i4d8+T8dzsuYEcM3slSTCIiuQ3+RlWOG0s=;
        b=m8qpP74GrV/ZyzjSd8sfbMpqjzqnnVd9JZBsrYtyyAuzjiuopA7IoDBQtEVzHnrV1m
         t1h37x7wumfUWqs/Kto9DX0/ITxbaEJxGsU9kCT/WL4Ttz0IcPn/Tr2GbHch8DukG5rN
         7vwSXhWgqn7lWNfhuxnxjcz+TJQDZLyBeNkGkTRc96ZW9uxD3pWtUwWuTfZTcr7T2+CJ
         /8IJV/fxsgidecm+E4LmrFg1hKbS8rt4oZNkWesTXpSeQSebYyVcDpNxJBnS1Bnx1aoc
         PESSwMzyi48HtfvpbpH/b207rHzGp/ZvVITXdpaZ7OuAafEL3Qzg6rRX9eJ7CBh8ML/c
         iTXA==
X-Forwarded-Encrypted: i=1; AJvYcCWY01Fu9NB3QtgcMhdIJDaWBFXWBoqk+tZMjH6yAev/+UKp5KbQgTB61/04fjuoUb8ye0w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8wg9RhejHGVzbY4iUDH1ydQRa33jkI8IeKqpBHMQLArGy06xj
	L7xW9vIs3WFiXm+TWQ+SkFe2HtY5Suswn3XVgrxdLuHrSLK/hc+Tpw/NqWpzpptdFNJ0wE55bsv
	xAZD14IldbQZjQbSxVZhV06BAnbbD/7H51nbC44JpoA==
X-Gm-Gg: AZuq6aI5e3zNZ8JxhgBhUkMep65M3p97YsKzZFkUKADGrXX1nCTJrx6+bu6N3FqxPbO
	vhJy45bfBg4tyJWnjpl4kEozi3VZl9OZwNXGBowceTU0jcW8ugZKMadIwhbT/R5O1/Xrsbdmrsc
	lThDA3GBKQbw16muG41DF3lOXC7USr8isHCZb4VzwmyzjVjplYYtdxKjxJhBPaEKWjTocvyZm4i
	enZtNlS5a2dodSXOWiNiboKd7XJbVeOnyUbQTUEhJ4ReULGjZPD+JABdHK/KE3l7kOrOL00VudS
	xr4jeWiXowD8hrTLYkKl3J49LcpLFR1Klbf/ocxsntiXiH27P66vi95q+ESo2e/E2NI=
X-Received: by 2002:a05:6820:4c10:b0:65f:6601:b348 with SMTP id
 006d021491bc7-662e04852c3mr466071eaf.62.1769321404333; Sat, 24 Jan 2026
 22:10:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260125060441.2437515-1-xujiakai2025@iscas.ac.cn>
In-Reply-To: <20260125060441.2437515-1-xujiakai2025@iscas.ac.cn>
From: Anup Patel <anup@brainfault.org>
Date: Sun, 25 Jan 2026 11:39:53 +0530
X-Gm-Features: AZwV_QiLy7Qn8vFdFMNh31JEJuULaHJbzToh_4mxXW9q7rEMkbJvRXHHKpISzlk
Message-ID: <CAAhSdy3dWRuJpLMBqrPJ99AqneWvJu1TuU7wW0Fom+awdBupDQ@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Fix null pointer dereference in kvm_riscv_aia_imsic_has_attr
To: Jiakai Xu <jiakaipeanut@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, Atish Patra <atish.patra@linux.dev>, 
	Jiakai Xu <xujiakai2025@iscas.ac.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	R_DKIM_ALLOW(-0.20)[brainfault-org.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
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
	TAGGED_FROM(0.00)[bounces-69055-lists,kvm=lfdr.de];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anup@brainfault.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[brainfault-org.20230601.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,brainfault.org:email,iscas.ac.cn:email]
X-Rspamd-Queue-Id: 415717FDFB
X-Rspamd-Action: no action

On Sun, Jan 25, 2026 at 11:34=E2=80=AFAM Jiakai Xu <jiakaipeanut@gmail.com>=
 wrote:
>
> Add a null pointer check for imsic_state before dereferencing it in
> kvm_riscv_aia_imsic_has_attr(). While the function checks that the
> vcpu exists, it doesn't verify that the vcpu's imsic_state has been
> initialized, leading to a null pointer dereference when accessed.
>
> This issue was discovered during fuzzing of RISC-V KVM code. The
> crash occurs when userspace calls KVM_HAS_DEVICE_ATTR ioctl on an
> AIA IMSIC device before the IMSIC state has been fully initialized
> for a vcpu.
>
> The crash manifests as:
>   Unable to handle kernel paging request at virtual address
>   dfffffff00000001
>   ...
>   epc : kvm_riscv_aia_imsic_has_attr+0x464/0x50e
>   arch/riscv/kvm/aia_imsic.c:998
>   ...
>   kvm_riscv_aia_imsic_has_attr+0x464/0x50e arch/riscv/kvm/aia_imsic.c:998
>   aia_has_attr+0x128/0x2bc arch/riscv/kvm/aia_device.c:471
>   kvm_device_ioctl_attr virt/kvm/kvm_main.c:4722 [inline]
>   kvm_device_ioctl+0x296/0x374 virt/kvm/kvm_main.c:4739
>   ...
>
> The fix adds a check to return -ENODEV if imsic_state is NULL, which
> is consistent with other error handling in the function and prevents
> the null pointer dereference.
>
> Reproducer and detailed analysis available at:
> https://github.com/j1akai/temp/tree/main/20260125

No need for a link to your personal repo over here.

Please add Fixes tag here.

>
> Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>

Otherwise, LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/kvm/aia_imsic.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
> index e597e86491c3b..9c58a66068447 100644
> --- a/arch/riscv/kvm/aia_imsic.c
> +++ b/arch/riscv/kvm/aia_imsic.c
> @@ -995,6 +995,9 @@ int kvm_riscv_aia_imsic_has_attr(struct kvm *kvm, uns=
igned long type)
>
>         isel =3D KVM_DEV_RISCV_AIA_IMSIC_GET_ISEL(type);
>         imsic =3D vcpu->arch.aia_context.imsic_state;
> +       if (!imsic)
> +               return -ENODEV;
> +
>         return imsic_mrif_isel_check(imsic->nr_eix, isel);
>  }
>
> --
> 2.34.1
>

