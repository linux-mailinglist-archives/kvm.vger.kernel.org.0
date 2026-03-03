Return-Path: <kvm+bounces-72503-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OMvDEEGDpmlQQwAAu9opvQ
	(envelope-from <kvm+bounces-72503-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 07:44:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 88B7B1E9BF3
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 07:44:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7A35030488C9
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 06:44:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94B953845DB;
	Tue,  3 Mar 2026 06:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="mp11mrGm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EEA1E230E
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 06:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772520246; cv=pass; b=FcEiHFAI4rdR7JuSBgpMr/LoXdyD3lxLEJDOv7RjgFpLjUANuznM87rYlzGBDV87+vgpj6MW0qT2t5fPOyNIG7sz5HiHe6Jqyxd3vu0rXAy6JjYGWtIddzeKqhU6X8Sq4uST6vs8+7MCZ0VoQDbM9EnnM8OtE99kuGiUqWuWt4I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772520246; c=relaxed/simple;
	bh=ESsglKKGA46RAPtFgL+9kL68OlVOnCWyY7CmoFZieF0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pAatS6xMhfYSONNkCH9/LQoUSsCtG+05tby7StZpsshYob7WK869mE5jVWBpwy8C2hLXQWjxH1ExEMRAgpqzAQHsEhYkTBPwiza6Wsqc8o/M2Uau2IqBczAAJ2SbHMVASQ5UXxknE39kwGxxrWenk2RWupxHEy3pFTHoubiN+EU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=mp11mrGm; arc=pass smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7d4c68f0e47so3602027a34.1
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 22:44:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772520244; cv=none;
        d=google.com; s=arc-20240605;
        b=aiOEgRLmZAn3nXmUKfBLUcO9c7G2T+Kn+5AHMK0QLFQc8OvJbXAOuekOcm4yq7hcdV
         q7a7ftR1mpAJKISgObsnctxlU8AA5Fuz57MgIr5ZC6WL7azmQ8guX6cAvkba8jPKRHVp
         K7wkBQKp0/ywhwr/yOOPXc/pIXi+bdcTHJV8/W6Kw+IvfV3CGXpYs2rC+oHDz9vgL9mZ
         G7OAR9cjvHmrBFkbKuYQm07y2DYSxg+bLU17RjHnzJEHhoIgbHYFKcsGV9HytRIKL4SN
         932c+MDo6QCCaG5PrYGq7txR9WYqs2ThmMCr78McWmlHizvMhlOfPnYt3ksIKacx02yl
         mRSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=17EAKC40n4lK2eGFWleJRr7p+vuvkxDQ7nWIiu0qbQ8=;
        fh=aOugJMne52C1rTjNBHEPVu4PxG34ZkzjeO9Ood4Z7kY=;
        b=aX7fvc8Br4oc7Ai8v+aZeDyCYm7hy87bNjM0KwLeDvcWWWKrKE22xw9nrQb6dRXonE
         nT6NJp/AOyqz00c3oswrdD40j5qs7Na/FBVo3l6Oneig0clBdX5bDg+Y8rvTPWTp+9Zj
         frZgFX6478Cq0S7pbjsXk0aO+B0XWkBRAOHaJNyKR1Yneq/v8uQF2pYAgnNas0K9inU2
         aRwtCHeYG/NMO26s4S+MU6f5vpGkLrbvcwR8k/5/M9xlMckau8eG1myNuZvLr+7/lrY3
         wfb+bhRDTtUgFjO8gfLxmbD7Vnc4PGWxxZRKNBJUofsy/SeGa4VZgsRj3DOVbphQSRAp
         BNKQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1772520244; x=1773125044; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=17EAKC40n4lK2eGFWleJRr7p+vuvkxDQ7nWIiu0qbQ8=;
        b=mp11mrGmG3u3jhes47uatQtQtOqhXMPMfPYUmjpIVuDqHRApoVuRoCInzyfxpKk8lq
         l7lFZ3WWyPuzBfsaMcmY/vcI06Fyb276FGiazu8LZZVs+a+jdBBJRvYj5AgQ3qUfKznd
         lVCNesHrK90E3tr0/lcz7KEqI8huVZZ+DdlbswffUbRBXv++5F0pHDDp6SsTBWGSX/gA
         pLPQmIA8lDNdP59xImWqVkxscsIE5A8Jhpfd72Po5IaRNPlWbzv60GqqqcMXVkRjemi+
         rWh5haFVIhuSBvKIralDGRyeBKiCcNLIA52LHSPUUPhbL2pbwuy9QnkipnJxunb6lfAu
         Jiow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772520244; x=1773125044;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=17EAKC40n4lK2eGFWleJRr7p+vuvkxDQ7nWIiu0qbQ8=;
        b=lC2nut1FccAvFHvuV67TeRXF65ey3x7Eqf861ErA+ITAoSe5qR/VbtSjhbM44/BSFS
         piG4yD3Tou6YUzc3Nm3HrRWBoTLPidAp7AdVEAziViw2uCgTkdjqikvT8zH38oaWr/hQ
         25NZvIR8z3W9H8g5Yx2iHkjQ8fyPdTMemvfK1zaMyo4ph6IH5eDTbF1/0BOjQIdr+syr
         LMIYBkW5UYaL/jhFyQTvtX0Nndvvvz+zRK16OS2LYr8ORTlKNnWmly5X6NxGLHt2tUtA
         a+zs5tCCezEyIpHDNA4xkoSdvYQeFY7KKuNJKQpKghRs+EwiE497K0+zoykuuDCr0+OC
         JHSg==
X-Forwarded-Encrypted: i=1; AJvYcCWPJKDSP3dBUVjvPuGXEUZXAOUiIRzWSHupX604M+NpskgpbZlI712sjqBt7yehuPiUBeE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzAax9Y608a8zeS2Xdn+aEeRXjDJ9YqJj3zJYCiF8Psf7Rt75Cg
	wqMMbvP3UWzhx1yXFk2nFvuxdymej8CSi/DVpojh2R4TyZMVWxd4OoONnUO8kloZPQzdNay14ca
	zm8dM+2GlFg0+GvWX/OLUw9IiXNwRFAtAFT3m5PCxdA==
X-Gm-Gg: ATEYQzzacHptd9VkUi20LdKFGdnUmWvAHLRGZyYLrmDTyRs2KgksNwHIh+D9q98o5ma
	0KObk4pXlgAyiwQq211OiAHknhfZ1s3Oq8j67kq3RlMeN8Bgn7U1lJKqHoDBierM9YHqZQ5N1Tg
	ylr1waIczKNEPvvd+8khpiMBfgF4S8RIH3gboZ1Dugy4ljE27SKRAEd0UKos9iqVwOZA/K61+lA
	J7fWL1ypsUxavHrIHFsEzCN+at8eJTmUbviYs9PxmS2jCEJU46vdWTFg0aBqgcWBnJCQxSx1opa
	VRd2LL+LWOqYk8Ydi77Sb2LLimyovlr18yxtbDr2lO5iieFRg2JregSk3lO71RC0NgGjcqQtYrq
	7i2EftTj/sy028Ahs/Bc+f7WHEw==
X-Received: by 2002:a05:6820:f00a:b0:679:a47e:14cd with SMTP id
 006d021491bc7-679faefe7f6mr7620383eaf.39.1772520244125; Mon, 02 Mar 2026
 22:44:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260302132703.1721415-1-xujiakai2025@iscas.ac.cn>
In-Reply-To: <20260302132703.1721415-1-xujiakai2025@iscas.ac.cn>
From: Anup Patel <anup@brainfault.org>
Date: Tue, 3 Mar 2026 12:13:53 +0530
X-Gm-Features: AaiRm52W3bsHcFj5BvkAB30rof0DvdN1BKJdtWYXJgZCd2MIdieX2ABHWmNP33s
Message-ID: <CAAhSdy0RbUCD4ZQp9dVF36rE1y7__dQvKHD2RXywggn+_EU-pA@mail.gmail.com>
Subject: Re: [PATCH v3] RISC-V: KVM: Fix use-after-free in kvm_riscv_aia_aplic_has_attr()
To: Jiakai Xu <xujiakai2025@iscas.ac.cn>
Cc: linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Atish Patra <atish.patra@linux.dev>, Jiakai Xu <jiakaiPeanut@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 88B7B1E9BF3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	R_DKIM_ALLOW(-0.20)[brainfault-org.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72503-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.992];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[brainfault.org:email,mail.gmail.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, Mar 2, 2026 at 6:57=E2=80=AFPM Jiakai Xu <xujiakai2025@iscas.ac.cn>=
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
> V2 -> V3:
> - Fixed incorrect locking pattern in aia_has_attr(): avoid returning
>   while holding dev->kvm->lock by storing the return value in a local
>   variable, unlocking, and then returning.
> V1 -> V2:
> - Fixed the race by adding locking in aia_has_attr() instead of
>   introducing a new validation function, as suggested by Anup Patel.
> ---
>  arch/riscv/kvm/aia_device.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/arch/riscv/kvm/aia_device.c b/arch/riscv/kvm/aia_device.c
> index b195a93add1ce..0722cbaed5ec9 100644
> --- a/arch/riscv/kvm/aia_device.c
> +++ b/arch/riscv/kvm/aia_device.c
> @@ -437,7 +437,7 @@ static int aia_get_attr(struct kvm_device *dev, struc=
t kvm_device_attr *attr)
>
>  static int aia_has_attr(struct kvm_device *dev, struct kvm_device_attr *=
attr)
>  {
> -       int nr_vcpus;
> +       int nr_vcpus, r =3D -ENXIO;
>
>         switch (attr->group) {
>         case KVM_DEV_RISCV_AIA_GRP_CONFIG:
> @@ -466,12 +466,15 @@ static int aia_has_attr(struct kvm_device *dev, str=
uct kvm_device_attr *attr)
>                 }
>                 break;
>         case KVM_DEV_RISCV_AIA_GRP_APLIC:
> -               return kvm_riscv_aia_aplic_has_attr(dev->kvm, attr->attr)=
;
> +               mutex_lock(&dev->kvm->lock);
> +               r =3D kvm_riscv_aia_aplic_has_attr(dev->kvm, attr->attr);
> +               mutex_unlock(&dev->kvm->lock);
> +               return r;

This needs to be a "break;" instead of "return r;".
I have taken care at the time of merging.

Reviewed-by: Anup Patel <anup@brainfault.org>

Queued this patch as fix for Linux-7.0-rcX

Regards,
Anup

>         case KVM_DEV_RISCV_AIA_GRP_IMSIC:
>                 return kvm_riscv_aia_imsic_has_attr(dev->kvm, attr->attr)=
;
>         }
>
> -       return -ENXIO;
> +       return r;
>  }
>
>  struct kvm_device_ops kvm_riscv_aia_device_ops =3D {
> --
> 2.34.1
>

