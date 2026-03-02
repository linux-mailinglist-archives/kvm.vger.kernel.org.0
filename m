Return-Path: <kvm+bounces-72367-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WHuDJnyMpWmoDgYAu9opvQ
	(envelope-from <kvm+bounces-72367-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 14:11:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C9B11D986F
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 14:11:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A184B302FEB5
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 13:10:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14E043E0C51;
	Mon,  2 Mar 2026 13:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="IWV46Do5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD7D3E0C68
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 13:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772457018; cv=pass; b=FTlECgs3nQ0YyksaNoKovj2RJ8SmzKDanGrTTx/kV4My94fs8OiCNHuF9qT+mSQtHHISvt3bGj2tHe1l4tozLKZ1/0UeePYW+4JthfcCthfCfdOUSAPzLdyUGvYF2F2D2KV5GP9iuMOtbKxYw11GdA7VhPyHihf7v0LY53XwmjU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772457018; c=relaxed/simple;
	bh=FvDk5vmnGRXC0snVOMq2qREWUjXYhKgSQiUxU4TNVk8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ib7qSPpWzin4WY2Au3r6g3+ijnENLr1rJ0uJjw0gYkXKyzxa3eNUQAmmpTZJWPx93uH+GD58JT1mYqKTXBik/mAMqHQgsRtVBta+5vv3soparniFVY3E8fuzJQLOGDpjbjEPEZsdmyaCTHTRGBWt5zLLPWYOREGxL6Y3uT/cJvg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=IWV46Do5; arc=pass smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7d4c383f2fcso2733219a34.0
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 05:10:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772457014; cv=none;
        d=google.com; s=arc-20240605;
        b=UGVLqF/LzAj6vOf0o7pMVYdLNM3nJpY7HL4A8m2RUIePUafcFcNvrly1dWuUm91/Rn
         XR1+F3UFCaJELVvlfPNWWJymVDhDFSO/EAN1vwPMtauNjlcvNxn91Tla8/FxCiWSEHCA
         NGa6FmKya55vCTWFGYHm+xHl0q9fXwpH8Dkv0Usudr9T8zITV7pkvG2RV2Lcv+1nWY85
         idr+ijUf2v7NaxbH7+bApi5Z0B2k4u/1rZ8vLaebPFl8w5r8Nn5La9gPjSlTgR97W1YK
         dMgr4dvPuTNwZor/BIK420fX9rxTfczXltG7Dvhzh1+FZZHJkhGKnJCowoEJGJ+ZUXca
         UcLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=M3t7J1xADn6LVhsHjUSboELrYldQwpli53K6JflTiRU=;
        fh=M1ZeWmroDPtGd5oCHzwvcHU62HkD5rGK0VgNl3X+bvY=;
        b=huE3ctRFnmdWcyRVDeva50UbdwiAL+4Oyhiyzi9EK38fTfvi2Iv0hxgZ1iR2Dv0yc8
         eOQiokLo2O46hbWMLeVh8yQGAnqnLUNTmJlfaNvqQ+5eCoAZ6p5P8rUDI0vXDcDCIt/1
         a7Tv5fK5MN6g8oTlMvcrAFY75CpTkj5VeVyOwL/THCWDsnqCg/QtQrj0KzqK67WH4Yg2
         UFag9A4bypVDEVo1Aig1V8NNh4q2mWvvxHHFYi5i4FEVEE0h7BOCmHr/yktyHevMVMgz
         gqX0iywOp23Hirv1Hl33vCTPjmFOZA/tHrisT70CyK1Rm+kFXCyrbpft95jDmZAhlr5N
         z5Lw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1772457014; x=1773061814; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M3t7J1xADn6LVhsHjUSboELrYldQwpli53K6JflTiRU=;
        b=IWV46Do5sJZZeDb6Gj3JBmxXvKOoDYgQEe3PGX3W8FTmc/zS0qS/KzxOL4HIouF1f0
         LrE2XXfohLGHlU6X4qumF17tiPEmHIVFK6JVln29puxRbfrZAZ45mrOJ6gQq+KTsFP+f
         CY33+IEh1Etqt/QTPZT8WqP3g7LQOVUGFWgc07AkKi22vuoP6AwH/2vdEI0F2C5XE4Ws
         Mc7YNduVFqxWkY6nQkQsaWv8x9lRWDd7VIFDbfz9625ZKVQRjJwcGlCgjYms85PyCEs5
         femeOBGKBBmlwzesW7HuDpo0ThOHbp8d0ac3C8dyYJAxERVwR4911/Zozrc4KoLJnCAi
         PL1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772457014; x=1773061814;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=M3t7J1xADn6LVhsHjUSboELrYldQwpli53K6JflTiRU=;
        b=VDBLcm+jMeBM9/QzEtMDuusWBGzSMPgQM4UW3J2mYYhQCp8UKn0NQZJEWRJ/CRFuWY
         Qe0obgb65Lxn+lHHQqVmlOq7XjXodCXB7I1pL+aqgBSVAinFO4ZyALUGx5SoSvGwvx83
         uzVdP8GufwIKG8PLZz4U7PyFXWHyDrPnfpYDI5bUQxYSvExVpnzDSpKr+dy/cjhMOFCv
         iCgt19Kjxb4VdByMlMn2JPg1L5XOY6ydJAGdwudOBiu++NKlO3E6B4RjtvbfqdPSJaZd
         0ObZn8l1GZlf+e//uENMBb74g2k6Og2VeULUwDtINJ8k/++7TePGFuAUsyEfWDvZPrNb
         CPYg==
X-Forwarded-Encrypted: i=1; AJvYcCXS7fGvtF+EAJGGUPhpU5oEc936P+Xm9zYAAEEB6nZf9FG61Uk+bH8ym6URGiby/kezKKw=@vger.kernel.org
X-Gm-Message-State: AOJu0YziIIU7JzQaHlU0fHbueRyffLe3OWUjjwxIXSX9zooPQiAlM4SG
	XZydfEtpy0Hhve/mSvnkDbO2xm3iAj9xK3uD012I4YIBDG+4X4Nn6ZWGTA2uDk1JK89WMmplLIS
	kjsFC0rdZOmxpagoVQvXOVI9Zu1AmCVZmX5D/pl6GJA==
X-Gm-Gg: ATEYQzylCZVTh+uS4zqn90v98pZFaGAL229h2N0Z+JuM0T1goMCCsdv5Ty+aHX2Ue73
	LZSipbSuuDmEW7353XtmuximPlxOuORQ175tdDr+DVxma/M9X3MjCkLCRZj2fucixePkKyf+zVq
	kLwqUUsSQLw1o4SXIoySBTULsUKFeRUsuLxoc/DZMBhTBkcu0bSy9lR5JQSPmmRl0Pmr4Dr5tKN
	eGdWIPBO2apfjKF5EJXUDLgzo73mPSmNJQp5CRoQ/TwxNHk1TgPTF4j0cjexfQQwxjQ3pxKoEPE
	XY/kbDU77Yrfd5ebpQXzT9EfGrEajS8WbwlFHNeYNkQ2iKdyXcY7Hhqkjj1t2FBrGoI3RL2IY6V
	+bLf1Nw1S6EXI5t521qlJLSzk0Q==
X-Received: by 2002:a05:6820:8c1:b0:66f:280d:56b0 with SMTP id
 006d021491bc7-679fae14ee6mr6760772eaf.16.1772457013949; Mon, 02 Mar 2026
 05:10:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260227134617.23378-1-radim.krcmar@oss.qualcomm.com>
In-Reply-To: <20260227134617.23378-1-radim.krcmar@oss.qualcomm.com>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 2 Mar 2026 18:40:02 +0530
X-Gm-Features: AaiRm53jXd9YVl6VuWiDg3obNBJDRJ9uNjSZTeCJ9xO4OconUTj78RYwM-DvnGI
Message-ID: <CAAhSdy34OW-3n6z0BdWNShwYzwkmpr5L6MOXEypmCMqUOBu4zg@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: fix off-by-one array access in SBI PMU
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <radim.krcmar@oss.qualcomm.com>
Cc: kvm-riscv@lists.infradead.org, Lukas Gerlach <lukas.gerlach@cispa.de>, 
	Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org, 
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
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[brainfault.org];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-72367-lists,kvm=lfdr.de];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anup@brainfault.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[brainfault-org.20230601.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,qualcomm.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5C9B11D986F
X-Rspamd-Action: no action

On Fri, Feb 27, 2026 at 7:20=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99
<radim.krcmar@oss.qualcomm.com> wrote:
>
> The indexed array only has RISCV_KVM_MAX_COUNTERS elements.
> The out-of-bound access could have been performed by a guest, but it
> could only access another guest accessible data.
>
> Fixes: 8f0153ecd3bf ("RISC-V: KVM: Add skeleton support for perf")
> Signed-off-by: Radim Kr=C4=8Dm=C3=A1=C5=99 <radim.krcmar@oss.qualcomm.com=
>

Thanks for catching.

Reviewed-by: Anup Patel <anup@brainfault.org>

Queued this patch as fixes for Linux-7.0-rcX.

Thanks,
Anup

> ---
>  arch/riscv/kvm/vcpu_pmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> index 4d8d5e9aa53d..aec6b293968b 100644
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
> 2.51.2
>

