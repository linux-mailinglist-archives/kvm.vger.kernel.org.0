Return-Path: <kvm+bounces-72992-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YPglMap8qmkqSQEAu9opvQ
	(envelope-from <kvm+bounces-72992-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 08:05:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 711D621C43C
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 08:05:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 703263061600
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 07:04:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3C1F372B5A;
	Fri,  6 Mar 2026 07:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="jCs5iTLs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21014371076
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 07:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772780677; cv=pass; b=JC6bPKWfYn/PML+4TPu5RFTE74APeoycFGEa7LfF8fuZQY+T+VqU1aotRZTTYKDxBPzNZ515GZ3Lzo8bpfZv37YLuJEUMK/K3dtDQEslg350e6sh5kMOah7o7OnVnic94zQoQID3T5UECQk6WKeCb9uU/+JpKKRHzvGUUjAMPP4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772780677; c=relaxed/simple;
	bh=dhtII8dmf1sBf2SIW54TZ+6cqwlmdPdfPzEW3ZiC1Ks=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qeqWfTVT0lD5UXbCn6XwNtorsSBHdAPucsR5s2xC5fdFdy/qYPIKcHwHgVoMOjByKyqIwuUixZmEcwESmv83aCss5T1y4kDl73kcV1/1BxGPVcE7OJ7wCccD/NLdsS4FQ1CTpXfjz4snbweS4SNsOQzdlUNoqURwKAyrx4fN6hg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=jCs5iTLs; arc=pass smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7d4c85307b2so6086743a34.0
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 23:04:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772780675; cv=none;
        d=google.com; s=arc-20240605;
        b=idhJLT5ip+z4BvGQpKm8BwavYCkN9UGXrUANR62a8uDmWEYBOmd0GfwSAysS3s3JXl
         NDM3YgvQ8PFqT6aZS9FV/yZMu7VPMLLKnvZtwshP4hdHTeu8ulQTFqR7PiT1DywBhFmw
         mBRta/8ILiiG8wD66PQHd0ieb+LxI9+xfHGmxoTICY65m9TR1jJN7TAahfJtHMlHNf1l
         LJnd87uTka79FWun2PknEd3MRiYQ7g+MHPBn6eF7y+6dVtnULX0U8IlOxHqUF29q8wf7
         aTW9KLSFSLmyNL6MNoF/kRK19SyGiJrecbWC+T4pgRYi/BU946nBgBQQ/5E4AX9tJPvq
         0k0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ivXnTCaqI3lRQ19wdmdY/Vg2LOO+anvFx2bukYGj6N0=;
        fh=QYlh7rN+zmSx5zPgyqtaGjpJnayzA+5vQCRJi35o6II=;
        b=RyMxh33H02tQ03ZZgZDrP8eK8ZR80mHryRwZTczqKn59/4dZCo0UpToRFn1h275Bnk
         eKuWAtOOvF1MI0GrmzaWFMuhx1kJd3yQh21b+IUdLLPwiPVScHGw+WQejw3gjBDYGWKV
         O5WZnDdhGFrEoJIX6inqlq1kjUykai3zOxGD6RLB1Jn+C9MPpl5Ste2sI+cvjrOoyX69
         ECwVdxyXSR+nSKFeY3wDJ7usS4RpeAEbsZS7YhY3UPTtTxm2eT5RQf6sa15lQel2Gjy2
         WpUxflmNao3lF/auPmC4e7xkgOamfZcLHIpRXbtD0IjThoa7fUW8RD6PUHkhx4Seg16N
         KswA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1772780675; x=1773385475; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ivXnTCaqI3lRQ19wdmdY/Vg2LOO+anvFx2bukYGj6N0=;
        b=jCs5iTLsf1B/L1UaVlW62J5gTd4GPW3DSu5Bs11uZKuCYhk+n/l+1gCzN/eO7nbIPQ
         yhLQ+6BaZEMmG9FdWXA5zGFPry7tVqu0B6and2Qd+8cJHPnMd+bWkfQYXqrLK9ws3uV0
         2mUu0gWoCpTFFGDsTbBKvegctRftSmaHqcRcyObm1fgyddfoYGzBDIdUMuyW27a/CPkw
         I5uYHGtBT4zYAozCo7T5NZ/UEf7PHBRrD6nVmJnp2/kkKoEe5KuptZIvZQaYTR2JjQDn
         CHnE7l3Dd11Ly5letex8IzUYJmNraAE2Bc7y74cQoH+38dAn2Cq56qwE/a5J+LtEhIEp
         U8RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772780675; x=1773385475;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ivXnTCaqI3lRQ19wdmdY/Vg2LOO+anvFx2bukYGj6N0=;
        b=nsWc5PRhlxv2Hqh2J1+/mS+rZwKlVjqY2W7hpNrA40WNR3A/mSpVgc3BdfZ2T6WbeL
         4SRxuMy6p5D60GdB0Wbx4Jf7UWdewzydGb3RKlG1wQjGn03DaZRC+D9QlNV2q8tOQwMr
         6oBW+oeDVlsx/1Fwz9TMimalYwBRt1B5V2VwuTasWXX4ZqfxO+slwZITcjWaltvm/XT8
         L7dEnav/zO4jqHb/0BBNrC33iJUj6rDivw8seK7DnGxXx7EjBi0Qox+lXH8dngUu+d1v
         o2Pn6G+ry7QmMhNz3z8T6CxJI5rp8wc4C4aFpQydRqgszBs/tUaJZlxga8DxHnWlhk2X
         zPGA==
X-Forwarded-Encrypted: i=1; AJvYcCWmmVc5ExBPR84RHZtmguJ9lpu1vUiqzi2O4xNnsdgl76R45JJi+WRcXgnKgDG2a6ZUsnY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9Kd2QkgxCckJFSTUoNZ0LSgS5QYZUIpmKp6/F/SZLdQqKKxo9
	2V9SBFR32CPaSRqDjaMM4URYL71wyc2BV6hsKg14/6Gbfxd+ZaZaOXCD9/WmnYiTBXV+PmTgBpb
	pv4E+U8fvIpMNtemOpIPVBU64ASYVU50YEVisGO70KQ==
X-Gm-Gg: ATEYQzydPRh+oDwgH6Q8BdHCvs8vZ17Ajfcf/gcw8xuKCgYprlFPUsZHyaP4HCBdTN+
	GA6u8XPAZWli1brIcI7SdlWWS6DYN97ihrkdE28tIF+R6YlZUDEiAnz5EXpnt1lb1Xa51ZIPyuo
	Ieuex+ddjM06RWXzxXgD3WhbES81yQS7iNYKLuViz5FUVyeFof/RQivFXLJgSunCyYca9uovR1d
	j3Dj6WcOW11rf8JOH/OIRD5ttK5VHzdFDlKXGnkct9Vt4FihPPGR1dkwZlX4bKWDIP2TrBlzdZb
	SM5DW4T0sToDEvyN8mijoEeBI3QjhhE9Hn6eZvA60DuOxgJwrLIKreu/YwX9+2NMES6wIpz0PVZ
	wSFRMbePHASaipB31cNxwh620iA==
X-Received: by 2002:a05:6820:1787:b0:675:2e2e:569c with SMTP id
 006d021491bc7-67b9bca66c2mr902114eaf.25.1772780675004; Thu, 05 Mar 2026
 23:04:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260120080013.2153519-1-anup.patel@oss.qualcomm.com> <20260120080013.2153519-3-anup.patel@oss.qualcomm.com>
In-Reply-To: <20260120080013.2153519-3-anup.patel@oss.qualcomm.com>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 6 Mar 2026 12:34:22 +0530
X-Gm-Features: AaiRm52sAuSfM9cJRWnAGnwsD5n99Tkn6MwnQdCUOUYqaB6vd5qGlGeCvH3Tt3k
Message-ID: <CAAhSdy1tMeD2k4DXNd3m_qgrD+VOOML2Rd_q-ykcLXPv0UzMiA@mail.gmail.com>
Subject: Re: [PATCH 02/27] RISC-V: KVM: Fix error code returned for Ssaia ONE_REG
To: Anup Patel <anup.patel@oss.qualcomm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Atish Patra <atish.patra@linux.dev>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>, 
	Shuah Khan <shuah@kernel.org>, Andrew Jones <andrew.jones@oss.qualcomm.com>, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 711D621C43C
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	R_DKIM_ALLOW(-0.20)[brainfault-org.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
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
	TAGGED_FROM(0.00)[bounces-72992-lists,kvm=lfdr.de];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anup@brainfault.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[brainfault-org.20230601.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,mail.gmail.com:mid,qualcomm.com:email,brainfault-org.20230601.gappssmtp.com:dkim]
X-Rspamd-Action: no action

On Tue, Jan 20, 2026 at 1:30=E2=80=AFPM Anup Patel <anup.patel@oss.qualcomm=
.com> wrote:
>
> Return -ENOENT for Ssaia ONE_REG when Ssaia is not enabled
> for a VCPU.
>
> This will make Ssaia ONE_REG error codes consistent with
> other ONE_REG interfaces of KVM RISC-V.
>
> Fixes: 2a88f38cd58d ("RISC-V: KVM: return ENOENT in *_one_reg() when reg =
is unknown")
> Signed-off-by: Anup Patel <anup.patel@oss.qualcomm.com>

Queued this as fix for Linux-7.0-rcX

Regards,
Anup

> ---
>  arch/riscv/kvm/aia.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
> index dad318185660..31baea9f0589 100644
> --- a/arch/riscv/kvm/aia.c
> +++ b/arch/riscv/kvm/aia.c
> @@ -183,6 +183,8 @@ int kvm_riscv_vcpu_aia_get_csr(struct kvm_vcpu *vcpu,
>  {
>         struct kvm_vcpu_aia_csr *csr =3D &vcpu->arch.aia_context.guest_cs=
r;
>
> +       if (!riscv_isa_extension_available(vcpu->arch.isa, SSAIA))
> +               return -ENOENT;
>         if (reg_num >=3D sizeof(struct kvm_riscv_aia_csr) / sizeof(unsign=
ed long))
>                 return -ENOENT;
>
> @@ -199,6 +201,8 @@ int kvm_riscv_vcpu_aia_set_csr(struct kvm_vcpu *vcpu,
>  {
>         struct kvm_vcpu_aia_csr *csr =3D &vcpu->arch.aia_context.guest_cs=
r;
>
> +       if (!riscv_isa_extension_available(vcpu->arch.isa, SSAIA))
> +               return -ENOENT;
>         if (reg_num >=3D sizeof(struct kvm_riscv_aia_csr) / sizeof(unsign=
ed long))
>                 return -ENOENT;
>
> --
> 2.43.0
>

