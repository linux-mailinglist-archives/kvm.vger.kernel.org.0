Return-Path: <kvm+bounces-72343-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mNiYBSVDpWkg7AUAu9opvQ
	(envelope-from <kvm+bounces-72343-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 08:58:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 75A521D4393
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 08:58:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 814BF3023DFF
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 07:57:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2D5338736C;
	Mon,  2 Mar 2026 07:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="KkeFGYO3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF0D335562
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 07:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772438234; cv=pass; b=W/uve/De5n927H7okY0qag+QN9iGeMVqAylc6GXPk3E9o8Hjx5nd11B5iK+POsd0qg5kbStvG5iHv3iyKtPubyU4IClnzOfut9KyytQ8CDWfDMHqD8HOycSzSO//EcVcJlURWiYH/xchbaPwVRsVskZgfLZBq90HoRcD9RmxnBU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772438234; c=relaxed/simple;
	bh=dctTorRnS+gZP+tjbeRsADcbZXE0DiCC91FuR/lgzS4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VksVTDp9EgX0KFdB7HHT8PLFPm/4AnBRXmgUXg6og8blGRNGlwWhoUt+KOIZFObThNXWb52U8SRN2uG5U410BtroVNs/m3aPRBN4pPmN2QqtsuxNWv84CUriOJOq6V23LyWONv3IcYTzWosztre1KsXwERnvyL0D2PGgTykXo0I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=KkeFGYO3; arc=pass smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-662f9aeb782so3385225eaf.3
        for <kvm@vger.kernel.org>; Sun, 01 Mar 2026 23:57:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772438232; cv=none;
        d=google.com; s=arc-20240605;
        b=Txjauu/JCrT7clGlekD1OeqcoHRcvQtFhI0PUDU74YYL3UViPdsrxOkZTituAnlYRr
         eZ8s+rddZ2XDau2bF1rLlAoj/fbsKloosy6cceEw+evMqHnWCjmNFgjLt37S6YlxKTjO
         k1r6ey6mRrHohb5Qy0MWKqcmY+j87MoPvOJ+AnioVffLWC6lQwYQuKhI7ledt0ITASQr
         NMik1Rp5lTvvWRdH/J1v3taF6NdiSRQRIrz672Av1h1yM55tUt33+poSjEbCfHx7PdY9
         FFjLG5aXojMrdImMLRuiBvRJycRX/3hqSW6klN1Ud9tDamPCOJ5Zjb6eIYVnt7kcrmOz
         ribg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sYw7BzIszduQmcIAASuAjoew5S5p7hWuqNEaXkq1rV0=;
        fh=SGo2MmD/OkfGFBB4Pt+YbCcZl06lvflPekczjVqCv8E=;
        b=OFhTQB1e3424VhRK6oxTiZHFBitwHdMhxnYMF7UE8r8GM0QEoED5kyLifdJgr+b7Y2
         XucEFObTUXBX4sgGTSrFJOxdl0h9nML/2XYQ0L9J73VxHpH0o5CwHQ3/h8T6VQWOcWkt
         brEUhUhRlmWdnM4tqil6xOjAKEdS+VmnqCtEE3lXeDoGxnqLt5b7dc4x/sFTD/1Tk5Ev
         ds6JIYgcJlqdbT9LLxaoj+Uk1I4emKYxhOUzjdsi8ckT2x6Z+cKhcNvQl5gu+g2d+a/L
         RxL5LHyog0OXNRkTWdVidPBetyjTeMM1InujCPGGKno4W3AOOnRypiuW9sGElcqBsnSf
         6Gzw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1772438232; x=1773043032; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sYw7BzIszduQmcIAASuAjoew5S5p7hWuqNEaXkq1rV0=;
        b=KkeFGYO3RZljS4t5zW8EwdxpE7GaLTd1SOzcMJuHthGi4tfNzDYy4B9fcQhYp1kL7W
         lH6EFaeHI08dX0O3XA057LIRbePECKvfS9a0P7p7fUtz1Vyloo5a8CubM2JhFPbE+nC9
         2ARXpr/smc7liIYRwaM5fLU7jSAr9KH7YRtHiJCq5nmB0sMwK+VkxuSZWJty3FgYe6mL
         7l0PHseEyIRAm6k/7RAqxBbwChpzWzcB0LC2JxfnsedG9hjt24/Vrrp9MHJOeYLac0yX
         ZcEpg0DWBqMPwksEjfNLW804nODppzK4xwfpXDN9/KQ7Nf065h6epErkrSty7+44iegB
         lZOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772438232; x=1773043032;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sYw7BzIszduQmcIAASuAjoew5S5p7hWuqNEaXkq1rV0=;
        b=fC2TwgJ4eLIWk3PyRDXRADN6V4XrBAfAAXsJRgGymIFHzjy6moGVa0kDgJ0XTw7rl9
         qbA+liDQrgpFapNA3/tMD37D1Z/hQF67bvDB1lLwfwuV6ECB4YTcdqStZ2RhBI3dZwfO
         slRhSwWiuyHYLU8bpunKD5mvNSYB2mxNgtEWA1NOU/V0DIF3W+cb5f0pXvT2w6g19pHk
         Tj9hr9xBlmRMjO/xX1qFD2eljBOPctuhPs0efb7+2QrGpZ/aGWHISPfNK/NPSQXK/ahE
         nFsHBoH8fEEvhDxlKZp/vIyqjS3E242+HhU0UZS37nEnhmlrM3M2DBO7Gg83wLs5BKSu
         oq5Q==
X-Forwarded-Encrypted: i=1; AJvYcCXGROMXXWJaH6BuKyU4MJxiYPvmXeLZIPtQYPisIIvUnG+EawslZwwkBZQC0Qa3KgTcLh0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzY+Qr9nfUA+JTAkCkmI+CHdo/P3o9HrTTdDQvbB+tGpOFI2bB3
	PkIivdsv3aivcAnyyrwtRaQw9yEn++emkC0H9iihWvMAwoYwBYOR4wPnAo+tR5b/KZBTstj6f43
	WWW0jUIsmf3q8BoV0ZBboqDMzLdCAJg9fJhUQF/THHQ==
X-Gm-Gg: ATEYQzzxz8tR/sucOP0cV1qmsL/gOHjC7T2ZiuIZRxJdiT+8ap9pb1snGbTTwnAJKmY
	zO+YeFu1Bis5n918zfEAcO2cXQ/73jnxr+xsspOUNzDBEcK8GUdT/o5rwKpk1obFp7EQgm76FSA
	57m86EhTHzd0F/MWf6fSjjdknEmZboSYlxfEFCkk6AgRLzK/54Ko7fZSU/hrOhPDNPbMgPxpg1T
	fQeq9BpJEV4kPLCQ3AEDrPXnwQneUq2C7ZRQdtp1YVrdAT4ie4XTZO7kmq6GIg8sJGl1geizfi3
	RcKIG3DyUqqRTWn1uQXzy5VNc6P2BrM7l4vUvGaImHmD6dkwrwf/tIhwqPia2j+l/gRl2zljDuv
	9NSw5myn48t71sYhqsia00gEbshw=
X-Received: by 2002:a05:6820:2083:b0:663:f65:1c92 with SMTP id
 006d021491bc7-679faef9814mr7063277eaf.49.1772438231609; Sun, 01 Mar 2026
 23:57:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260224104438.57727-1-xujiakai2025@iscas.ac.cn>
In-Reply-To: <20260224104438.57727-1-xujiakai2025@iscas.ac.cn>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 2 Mar 2026 13:27:00 +0530
X-Gm-Features: AaiRm50pyr6g5dnPfdIYyaLubJSF_te9LsJuAngs7UB_FiwXT0ux5z9Q5yJiHLM
Message-ID: <CAAhSdy38=Ho1H21AboHyN3AgqskRxqrPfrzP-uJmv80QjBPRrg@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Fix use-after-free in kvm_riscv_aia_aplic_has_attr()
To: Jiakai Xu <xujiakai2025@iscas.ac.cn>
Cc: linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	Atish Patra <atish.patra@linux.dev>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Jiakai Xu <jiakaiPeanut@gmail.com>
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
	TAGGED_FROM(0.00)[bounces-72343-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_NA(0.00)[brainfault.org];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.infradead.org,linux.dev,sifive.com,dabbelt.com,eecs.berkeley.edu,ghiti.fr,gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[brainfault-org.20230601.gappssmtp.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anup@brainfault.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.994];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,iscas.ac.cn:email,brainfault-org.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 75A521D4393
X-Rspamd-Action: no action

On Tue, Feb 24, 2026 at 4:14=E2=80=AFPM Jiakai Xu <xujiakai2025@iscas.ac.cn=
> wrote:
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
> The patch replaces the actual MMIO read in kvm_riscv_aia_aplic_has_attr()
> with a new aplic_mmio_has_offset() that only validates whether the given
> offset falls within a known APLIC region, without touching any
> dynamically allocated state. This is consistent with the KVM API
> documentation for KVM_HAS_DEVICE_ATTR:
>   "Tests whether a device supports a particular attribute. A successful
>    return indicates the attribute is implemented. It does not necessarily
>    indicate that the attribute can be read or written in the device's
>    current state."

This is not a hard requirement.

> The upper bounds of each region are taken directly from the
> RISC-V AIA specification, so the check is independent of the runtime
> values of nr_irqs and nr_words.
>
> This patch both fixes the use-after-free and makes the has_attr
> implementation semantically correct.
>
> Fixes: 289a007b98b06d ("RISC-V: KVM: Expose APLIC registers as attributes=
 of AIA irqchip")
> Signed-off-by: Jiakai Xu <jiakaiPeanut@gmail.com>
> Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
> ---
>  arch/riscv/kvm/aia_aplic.c | 28 ++++++++++++++++++++++++++--
>  1 file changed, 26 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/kvm/aia_aplic.c b/arch/riscv/kvm/aia_aplic.c
> index f59d1c0c8c43a..5e7a1055b2de6 100644
> --- a/arch/riscv/kvm/aia_aplic.c
> +++ b/arch/riscv/kvm/aia_aplic.c
> @@ -527,6 +527,31 @@ static struct kvm_io_device_ops aplic_iodoev_ops =3D=
 {
>         .write =3D aplic_mmio_write,
>  };
>
> +static int aplic_mmio_has_offset(struct kvm *kvm, gpa_t off)
> +{
> +       if ((off & 0x3) !=3D 0)
> +               return -EOPNOTSUPP;
> +
> +       if ((off =3D=3D APLIC_DOMAINCFG) ||
> +               (off >=3D APLIC_SOURCECFG_BASE && off < (APLIC_SOURCECFG_=
BASE + 1023 * 4)) ||
> +               (off >=3D APLIC_SETIP_BASE && off < (APLIC_SETIP_BASE + 3=
2 * 4)) ||
> +               (off =3D=3D APLIC_SETIPNUM) ||
> +               (off >=3D APLIC_CLRIP_BASE && off < (APLIC_CLRIP_BASE + 3=
2 * 4)) ||
> +               (off =3D=3D APLIC_CLRIPNUM) ||
> +               (off >=3D APLIC_SETIE_BASE && off < (APLIC_SETIE_BASE + 3=
2 * 4)) ||
> +               (off =3D=3D APLIC_SETIENUM) ||
> +               (off >=3D APLIC_CLRIE_BASE && off < (APLIC_CLRIE_BASE + 3=
2 * 4)) ||
> +               (off =3D=3D APLIC_CLRIENUM) ||
> +               (off =3D=3D APLIC_SETIPNUM_LE) ||
> +               (off =3D=3D APLIC_SETIPNUM_BE) ||
> +               (off =3D=3D APLIC_GENMSI) ||
> +               (off >=3D APLIC_TARGET_BASE && off < (APLIC_TARGET_BASE +=
 1203 * 4))
> +       )
> +               return 0;
> +       else
> +               return -ENODEV;
> +}
> +

This is changing the functional behavior of KVM_HAS_DEVICE_ATTR
for APLIC because now KVM_HAS_DEVICE_ATTR will return 0 even
for non-existent APLIC registers.

Instead, the correct fix is to just take dev->kvm->lock in aia_has_attr()
just like aia_get_attr() and aia_put_attr().

>  int kvm_riscv_aia_aplic_set_attr(struct kvm *kvm, unsigned long type, u3=
2 v)
>  {
>         int rc;
> @@ -558,12 +583,11 @@ int kvm_riscv_aia_aplic_get_attr(struct kvm *kvm, u=
nsigned long type, u32 *v)
>  int kvm_riscv_aia_aplic_has_attr(struct kvm *kvm, unsigned long type)
>  {
>         int rc;
> -       u32 val;
>
>         if (!kvm->arch.aia.aplic_state)
>                 return -ENODEV;
>
> -       rc =3D aplic_mmio_read_offset(kvm, type, &val);
> +       rc =3D aplic_mmio_has_offset(kvm, type);
>         if (rc)
>                 return rc;
>
> --
> 2.34.1
>

Regards,
Anup

