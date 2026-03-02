Return-Path: <kvm+bounces-72368-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uML8BTCOpWmoDgYAu9opvQ
	(envelope-from <kvm+bounces-72368-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 14:18:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 82D6C1D9A33
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 14:18:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5AA5C308413D
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 13:14:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 041543E0C44;
	Mon,  2 Mar 2026 13:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="ono3hbmM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80CD3E0C54
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 13:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772457247; cv=pass; b=R42pYHR3XMi13t2vKA7FR/EsBKoUEEbv77Cd0zL9hvxRqtjNJMgfUEhxyWyadVTUU/CseDlkHmHoCMhB0hhQI0nwoKsGBKWgBK1Yopv7R8Nakcy+Y9ReXteuj1UWLaXko+D+CkDkV5uTtsfiSt1d9g5yYo6j64b19WH+h7wM4i8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772457247; c=relaxed/simple;
	bh=0UpnAxuBAUbdFN779TXqxAdZ3d1Uv3/Ald0VQ5Y3MBo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mkHO0hPdJbQCwfq2hvEKasrRpXBPMCCTKd+ZZEAmWTsnKUxuJDlZfyG9W39Eckl8Y6gzmZHo3PGFZH2N4sWpxfB8CSg4NYSsos6EKGysnDmxuPqKaOAigcPvpFruWNthzDhH8a6DX3N1D7VDDvhMUXogRDV+zgswabpvbzIazMk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=ono3hbmM; arc=pass smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7d4c3896e32so2445587a34.0
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 05:14:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772457245; cv=none;
        d=google.com; s=arc-20240605;
        b=e3OXKUjCUJiA//b056P1dcG2a/1wQHAg0jbW9DgVofzZHLYMenCVwQ63zx90N5odxT
         y6adLoLYBbD68lmgCPJgoEM/YhpxBPFg0zgNnp20YjiwJclvuoliwFI1iDiDh852MklF
         2SrfYlubatT16qcXNT9pnJecPpW9zC20u1OZorz9QKtZ6vW8Z27xwNBh8S6KWxvay4mb
         fg3MVBR4TL5sTEnUKA29ozN++Nk/lB+GHEcBcIPE7Meqv9wQ1fXBnSWhFeIv7Lk1wvVv
         h4myE5buq+lkKwLREJcon02CVXFyGFdVRlKlq20F7NXTMIs4xgOp1Y/vfv1MUddzLQs6
         h8gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=q2A3GQhW+RrNinQHVvkLJ5ITVUV3MtufvJzOYRFjrHY=;
        fh=5ux0q0VziaO1KLq5XK/k5JtRY3CVBdf7mqz9BhChC2Y=;
        b=MNxuoGsKEKc9uhDyIxKV3Q1HQFVg8HcWyGDkI18Ov6iu8GId5F6jbOCps9o9RpESzD
         mJV+gPElnVrbH5Ng4K+JezzaTPHp3C/gDvs97nxhJeAlalzknHx5wVtyzCGAgFI9AAT0
         6GsZz64ZRZ0XYTC+9v1XoIk/cYYAHQ0mZhkqXzJ+dxtNledzV48VqRFBdGVZT9BSNj/8
         Jry27E7PWXfVQmDLL7g+XalQI8Tsx5yrNTVF8g3q6llmiguVTA6mqyD28H8ivp3FFih9
         HRj5JPSn+l/LkqXNRUQvzaHSmViSL45pFymYQ+zvZB3ZfYg7giu0SlyyYUphKnCRPGrU
         41oQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1772457245; x=1773062045; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q2A3GQhW+RrNinQHVvkLJ5ITVUV3MtufvJzOYRFjrHY=;
        b=ono3hbmMhe4WZT8WzKMDNASf1rcefsJ0evEG8UGaV0Aj6LHGKyG+MvEjqhlQZn3SqE
         NmCpHeegndXxCXyPTI/ViES9YnNd2X2rpWVpBEQC0Tm8f2VAE4b2DYm2Geo1WqdGM35Z
         6MTqLGfS6q1y0CgKrjaF8NvI8U4T9oDXcmTLTAJo2wsjWUScIGja8J+lekA7EswSCGib
         XHrFlcMiYLZne+4AJZGtKNxPOPvbursVrLVQfKsJN7VLacD9/TqOJYGqhfz3T/20tpFI
         scDLRRuhhkdZHqZqHcKeTxnphcY6FXqmzT05Ym/L+T7eNzIQgkMWFXFw74bDgBKvw1Uf
         dItw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772457245; x=1773062045;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=q2A3GQhW+RrNinQHVvkLJ5ITVUV3MtufvJzOYRFjrHY=;
        b=vc2kqmgfScDn/wCUb2KmsbUEFTJfRQvDK16eYvN4plkwzv1WAoQVCfZe/lDdfvUV4Z
         KK4nkTMpcxQ1UlB3YfkY+BCuQ1FyKMSIOpX3j+qjizUGXPn0vrhjnAFgfz1IX+h62Bvc
         Uomz/3JldRbLvX0AdsrjEXup5HA86R+yDt6O0MmXbSuBh/ovNsuM9uotvAFU3f9YjOR5
         JO0QoQo+38nVslgo1ou1DsCjmc1PCTna2QXxqFon43dLDIYUQBJBNz65Wu0jWN+KVtXa
         Uy9LM2P7vokCE+nphJf0AhdcBO9eSUiJTJAWhyC7JEcWDt0vr2r3OS9+99eQO08A6CLG
         P4Lg==
X-Forwarded-Encrypted: i=1; AJvYcCXsCLOy7yxlYUmr+x0TadZiPxvkU+nfplRmSxE59GZbGr45QUK4NQD3K4YY3L+W17lBIrU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhN/5cufEGEwF8j2fUh1NH/hP8YtGCAci3R0LpiBvwNGtJx9ll
	devw9SzC+yoM+YdYKL8+zDxCEFAK5aNzbl3H8+I/Oponpxg2nK27rWoO4pAKNVqDj3Jah5aTgD6
	tgyyCC5YUHWeyDXjjhmPLftZJ1Wisra2nRsFxy6eF4w==
X-Gm-Gg: ATEYQzxcz2Zjbj3si7rOnwhiH//kJ8cb0t+TMQXSw5dfE4CpVQma25hpuj5/ihI19D/
	QwvDiA+qER2aVjri80B+5MDQPNO+Tw89lRbk4dHMUc5iXVryd2EPXo2VbYgDHbCQV1Dlrp8Oxgo
	4ynWQwX9upKLfU4aFl0oYg1YfMFZ+vezwhs7q3pjtfMcp0wrK5hiC2637qU2bODy+rkYhc/uBKl
	lA7m6CuCW+lydSZyCBdk5UMNDNlJ4W+A2yIZZaU+79vnIIBvduihJ1SPc8crh7S/ff2IHuqveK0
	ZjMcxGSCOi8t7F1rN6GhWeI/GWEESaH60v8ae3870G6d8GXdss6M4yRYxpfHfMedqirVunz2dTO
	hpoKGWGOzvscClGsw0oYGTM83qQ==
X-Received: by 2002:a05:6820:290b:b0:679:9802:7cd7 with SMTP id
 006d021491bc7-679faf194bfmr5794292eaf.40.1772457244644; Mon, 02 Mar 2026
 05:14:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260228152226.2116895-1-ethantidmore06@gmail.com>
In-Reply-To: <20260228152226.2116895-1-ethantidmore06@gmail.com>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 2 Mar 2026 18:43:53 +0530
X-Gm-Features: AaiRm53b0DPXsxrpiSTrmcHPiPDsc5YZtwK0BzdP4iIWyQHt1ODVlWYlaZYCUFQ
Message-ID: <CAAhSdy0k416xVG9uiTYKgeqhMKZvKQbSSuqNaPgkgCQVTdvHBw@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Fix out-of-bounds by 1
To: Ethan Tidmore <ethantidmore06@gmail.com>
Cc: atish.patra@linux.dev, pjw@kernel.org, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, alex@ghiti.fr, ajones@ventanamicro.com, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
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
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_NA(0.00)[brainfault.org];
	FREEMAIL_TO(0.00)[gmail.com];
	TAGGED_FROM(0.00)[bounces-72368-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 82D6C1D9A33
X-Rspamd-Action: no action

On Sat, Feb 28, 2026 at 8:52=E2=80=AFPM Ethan Tidmore <ethantidmore06@gmail=
.com> wrote:
>
> The array kvpmu->pmc is defined as:
>
> struct kvm_pmc pmc[RISCV_KVM_MAX_COUNTERS];
>
> So, accessing it with index RISCV_KVM_MAX_COUNTERS would be
> out-of-bounds by 1.
>
> Change index check from > to >=3D.
>
> Detected by Smatch:
> arch/riscv/kvm/vcpu_pmu.c:528 kvm_riscv_vcpu_pmu_ctr_info() error:
> buffer overflow 'kvpmu->pmc' 64 <=3D 64
>
> Fixes: 8f0153ecd3bf1 ("RISC-V: KVM: Add skeleton support for perf")
> Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>

Radim had already sent a similar which was merged.
Refer, https://lore.kernel.org/r/20260227134617.23378-1-radim.krcmar@oss.qu=
alcomm.com

Regards,
Anup

> ---
>  arch/riscv/kvm/vcpu_pmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> index 3a4d54aa96d8..51a12f90fb30 100644
> --- a/arch/riscv/kvm/vcpu_pmu.c
> +++ b/arch/riscv/kvm/vcpu_pmu.c
> @@ -520,7 +520,7 @@ int kvm_riscv_vcpu_pmu_ctr_info(struct kvm_vcpu *vcpu=
, unsigned long cidx,
>  {
>         struct kvm_pmu *kvpmu =3D vcpu_to_pmu(vcpu);
>
> -       if (cidx > RISCV_KVM_MAX_COUNTERS || cidx =3D=3D 1) {
> +       if (cidx >=3D RISCV_KVM_MAX_COUNTERS || cidx =3D=3D 1) {
>                 retdata->err_val =3D SBI_ERR_INVALID_PARAM;
>                 return 0;
>         }
> --
> 2.53.0
>

