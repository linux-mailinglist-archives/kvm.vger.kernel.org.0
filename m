Return-Path: <kvm+bounces-69346-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yOo+NvEnemlk3QEAu9opvQ
	(envelope-from <kvm+bounces-69346-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 16:14:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AC147A3994
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 16:14:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A88CF3041327
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 15:09:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7DDB36AB48;
	Wed, 28 Jan 2026 15:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="xOBVxERT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4E136A024
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 15:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769612942; cv=pass; b=M8S87UwFMouhIw1rlovIUa22Oang9ZBUHdaCRSiVjRBZgONTtBvtxOz/xFcCKgVojiMsQu3H+O7ZoBAFgGvhJJxOJAmH/m8F1NK62h58e10a2W8T7dsjL7H2ElJXsbSXqsxbaMjtWVQ8o+CQ0Jws4BPrT4Y8GKnnKiJWrtrcHRA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769612942; c=relaxed/simple;
	bh=45Q5SQsl0ccYHeZus6jO7wMxVgh8kiL+MyA4KNGG/BA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZK6ncOo6aSz9qdKEvHv917hCq+5nHTPw/Pb68L0qGYM83MnNL56jcbz6FYJ2vY+pPCsiN7AFUYOQVWwjBfxSrb6PbKL2mgOgMwOeaUdglRBIADa7q/rkpet+ZAlgBTbAsII/eUViFb5vfOkv70kP0YTZUKSQwblpynOuUqZB8g4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=xOBVxERT; arc=pass smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7cfcb46ffc9so596196a34.0
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 07:09:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769612940; cv=none;
        d=google.com; s=arc-20240605;
        b=jXp1FGlXxGLFEp0SxiIYbk0RRRFs5Hb7M29JpDeoFFPkKf9LVBhHMK7F5CW5kz1JhJ
         bW5WU7KmxFvNCabjIZCXUMTGyV3bpnBlkw716CUYZldxVkS0DlZo8zAFQwQHPQJ0oQcc
         0OQz1CLNcgbQx7iA+o+Xs1UJ6VZ+ff/cU3JtoIPK5OCusAgPZNC0gLoxb5rfVzu3FQOZ
         yWqde9NQFqlWHJPhjbFjraOq4DD2Su/RZcm89mo4ebhg8pjCI4ZTWT1oCWPV1kkZ+pGx
         GgodO4BAkTq2R0E/8XWI103bXaCAkJJB7IN+mJdL69fl5ScmqGVyHzzrxMb2X9vTCr7u
         ocjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xImSaumXjiTjPnMx4RKwPEYhdrOmxFBV6+72e58SeRA=;
        fh=CFyFjxnZqVxUcsRc+FCIxpUu4BIL1+bqCwIc0rF7wrg=;
        b=beRzaYs+AGwidOHk3JowSEtYeld9XRYcNhAr5yKgCL6QsL1uECqh0jhNCCWZdR5Mzo
         16HgZFyAP5qMaO7anXdGddG+Upd+9uU0s9mR7Wj95sqnDVjVp4YzRXZWW4NEgW3/pKmj
         N2Bk1GDHiSZtmrB5W3byUt6PYEcXjFB84IltmMtUW365i3Wq3KF0q1rhmPWskDFTCe3b
         RQCcdWcEjuKVuMesG6BUGAMwF6ky6tmfxG9R9xAOhsR7L70qniL5TZJZaRLpnp3lIC4L
         yqHVpX4ZBRHzwF5unDXbP5z5zWaS76JSFtolJCMghzwcW5Kcn8TzBgUUj0TYVo/3KF35
         +hag==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1769612940; x=1770217740; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xImSaumXjiTjPnMx4RKwPEYhdrOmxFBV6+72e58SeRA=;
        b=xOBVxERTXdSeUuRfRGTJALKpYE1QO2z6HBGTWw+8M4WUf4OL/En0p8ZaGHlcgp0hAe
         ooi2y+wqQXwAyh86dBuVc5TvbqND6WWWGKjG/RcrTIzOxQBykFBZ0lMWBFiOMyEaKrL8
         C+69oVwJyYIb+yK7r1NxHAeZZceNQItNSNqZNelZV/MGMKGHfFJAoOocDEdi7jLmj4RP
         iToJFI4695xjTZgSIDskmf57wYD8V/nzJxUT///PifmLJd/0yUsPVwS39gNfLwv29Elk
         jAz0GYcGTXLSpU96hvmxhdShaHzbVb4kdD30MxNZapiNv+qLykUv0Mh9X+zon2ShjrpS
         un2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769612940; x=1770217740;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xImSaumXjiTjPnMx4RKwPEYhdrOmxFBV6+72e58SeRA=;
        b=IrgbTf4sNwIlC0Pb++A7QnrgK6Sw8iDFfcwVBaN492DdfA56bHvccGtCuB448rJn3V
         zDAKi0zoV3ou4p1w21I/E4Uyt3aPQ8wYl8GRHQV+y3udUVbBEECUF+GIB4ndMQry9N1n
         Ip9rpxSrxKmh/J1fpRJlxj1ElNhKHaGwRXbO2tYBGxVZ2B/G8TF0RAiB0o2GHG/AZzkO
         moYGWy+CUfyT7MmUs3dln8fkVoZ7Dqyucpx6XPsjbAHsnovUl3gKUphewB2F6Xcp7qrT
         vl4m+SB3WXTqA3EYEdCBgUgQvHlN9WV6YqSpnqZIMf0avpV0+01sBwrr5KxHQWtSKFi8
         InJA==
X-Forwarded-Encrypted: i=1; AJvYcCVMslUaHQvLrfA6iBKdoue1aZmT6K9E2kkyIWLJtypmKox6XTDul/JnMXsCPvIGbwvcz7g=@vger.kernel.org
X-Gm-Message-State: AOJu0YyA3GNN4KSxc3zeuiodqr642y12jwqOoYhDUApDIVoqUJfZf10z
	hL2RXlxMqFuFUI08jXptAvLGCL08Cq1pOrBs4toKWQoVJZalbrkgk3Mpvw40IME/d4kl8bez9Ex
	7ElZKo2Ol0Zo9ENUAYPVTJvMy0bd6cTv9eQhduzsIyA==
X-Gm-Gg: AZuq6aITAcITN/MBiuGyYT3P+oOX0Z9iP2MCBGFb5fyKVDpsBMwElJhKdLTE/oSjCCJ
	Q3M+GBtrRGzWLJC0VOjjPwVZMqnneDn2MLdkv3To8Cu+2xV6k6utOfurXLavOfhwHzzNQIhYCQk
	3l8AMZyMGUXeQjlRvpi+KOeBEvch/7hS43aB49MnxVzVVTeIghXG5WIaJEksDJ6cJXlUOXY/kLQ
	Rww3QWDClcvOz0skMWgdwXcHd8b3WBuyokFXIasn6vAY5QT3DlhY09hBEaOGO8bvBpwNq4Fypo2
	a1JD796a18PI5A+Kh/wR+DpwZd0METxnDLqluNp87aDlzHfTg1iEIAc+kxI=
X-Received: by 2002:a05:6820:1c9f:b0:662:fb9f:9562 with SMTP id
 006d021491bc7-662fb9f97b2mr1829587eaf.36.1769612940354; Wed, 28 Jan 2026
 07:09:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260127084313.3496485-1-xujiakai2025@iscas.ac.cn>
In-Reply-To: <20260127084313.3496485-1-xujiakai2025@iscas.ac.cn>
From: Anup Patel <anup@brainfault.org>
Date: Wed, 28 Jan 2026 20:38:49 +0530
X-Gm-Features: AZwV_Qh8I6bUk6UmnyFbVlzL4EfGOlNYkPHELnidmBp1u2PFu_cRJl5OIdn6_MM
Message-ID: <CAAhSdy3DEXBniBDqyRpPxidB8gO6L_8bHMbJotX16eXyD0mYgg@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Skip IMSIC update if vCPU IMSIC state is not initialized
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_NA(0.00)[brainfault.org];
	FREEMAIL_TO(0.00)[gmail.com];
	TAGGED_FROM(0.00)[bounces-69346-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[brainfault-org.20230601.gappssmtp.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anup@brainfault.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[brainfault-org.20230601.gappssmtp.com:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,mail.gmail.com:mid,brainfault.org:email,iscas.ac.cn:email]
X-Rspamd-Queue-Id: AC147A3994
X-Rspamd-Action: no action

On Tue, Jan 27, 2026 at 2:13=E2=80=AFPM Jiakai Xu <jiakaipeanut@gmail.com> =
wrote:
>
> kvm_riscv_vcpu_aia_imsic_update() assumes that the vCPU IMSIC state has
> already been initialized and unconditionally accesses imsic->vsfile_lock.
> However, in fuzzed ioctl sequences, the AIA device may be initialized at
> the VM level while the per-vCPU IMSIC state is still NULL.
>
> This leads to invalid access when entering the vCPU run loop before
> IMSIC initialization has completed.
>
> The crash manifests as:
>   Unable to handle kernel paging request at virtual address
>   dfffffff00000006
>   ...
>   kvm_riscv_vcpu_aia_imsic_update arch/riscv/kvm/aia_imsic.c:801
>   kvm_riscv_vcpu_aia_update arch/riscv/kvm/aia_device.c:493
>   kvm_arch_vcpu_ioctl_run arch/riscv/kvm/vcpu.c:927
>   ...
>
> Add a guard to skip the IMSIC update path when imsic_state is NULL. This
> allows the vCPU run loop to continue safely.
>
> This issue was discovered during fuzzing of RISC-V KVM code.
>
> Fixes: db8b7e97d6137a ("RISC-V: KVM: Add in-kernel virtualization of AIA =
IMSIC")
> Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
> Signed-off-by: Jiakai Xu <jiakaiPeanut@gmail.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Queued this patch for Linux-6.20

Thanks,
Anup


> ---
>  arch/riscv/kvm/aia_imsic.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
> index e597e86491c3b..a7d387e280d49 100644
> --- a/arch/riscv/kvm/aia_imsic.c
> +++ b/arch/riscv/kvm/aia_imsic.c
> @@ -797,6 +797,10 @@ int kvm_riscv_vcpu_aia_imsic_update(struct kvm_vcpu =
*vcpu)
>         if (kvm->arch.aia.mode =3D=3D KVM_DEV_RISCV_AIA_MODE_EMUL)
>                 return 1;
>
> +       /* IMSIC vCPU state may not be initialized yet */
> +       if (!imsic)
> +               return 1;
> +
>         /* Read old IMSIC VS-file details */
>         read_lock_irqsave(&imsic->vsfile_lock, flags);
>         old_vsfile_hgei =3D imsic->vsfile_hgei;
> --
> 2.34.1
>

