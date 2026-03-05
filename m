Return-Path: <kvm+bounces-72820-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YOhMJJeFqWkd9gAAu9opvQ
	(envelope-from <kvm+bounces-72820-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 14:31:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AA212129B7
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 14:31:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C7E6D30447CD
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 13:30:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98B1B3A4F3F;
	Thu,  5 Mar 2026 13:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="QSyEpkA/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BCF3A1D07
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 13:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772717453; cv=pass; b=hEsRH5WAf28GDcdvttCzj6csJx1ebB9UcorGAiXWXWrAK2Y+jA2We5ZgvPd/kiDaVDaqSZuCTG++aHPLd/jUG4vq36y3urtb5b8jsbHeEkyeD9GJN/++UwMZAunmMtJPzieZxpPA6h69WOZuPYvIWweRD2fN6xYqM6aTGmUR89E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772717453; c=relaxed/simple;
	bh=tn+BPDxEF8XbZhSozbqESD2kZuabWE6dTZ9JPii6b9E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gHPHOdRrPYo2DCzJcksFlRQtXbA0Iz8Pogc8YhOlLqU0vuiA+CRweXNDBEOEkgoWJU1OXtHdLj+4MSknudajt/LV4AMTxiKK0PVmWlIVgAw2FXrLnlOcS8s3IUn6610z+jZCakE4Kh9OhuctkCL/QKq+czvSu+Pjv17/8LOPfcE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=QSyEpkA/; arc=pass smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-408778a8ec4so1825215fac.0
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 05:30:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772717451; cv=none;
        d=google.com; s=arc-20240605;
        b=YwH3euaskxS/vG+RwPAwH7oMokP0BUUOH9ImL4S7sg2DFJ/bwBYJWfC1WW22mMaQ43
         IE8q+Gnqv8aiHP/p0efI17JSVo7ZIjtgilJ86CxOuiVj3UOdzyShmt+MQVWkJvE+UJKg
         z9tbp585j3CcMhOYo7mBDzeoum6j+U6Nu20AUvMzsOpnURTq6LMDTkc/FvL2f5kKirOS
         eSLWb4adQX3w9f6lFa50fR1PRNhcSfBjD7SADABfvIDyXHomzlNwdjXJjwmz6OB94hO1
         EAy4huejnVgPsm13hoxhAnHAJCN5Kr3+aBmJdxGrQciWhYUyAOeme/nh1X6D4zmeNZpo
         ZHAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HeQt/T2ObEDlxLbQETck0lulq4qla31hbkK+l9bn/Ho=;
        fh=XbR1do48qWt8WEvxAzhsb0LnIdWG2TtDFLbkL3So4ak=;
        b=WhdjF+YBhr3LFmiT26afT8eytbGsDFnvhhYY5I3zclJD58DOyz8xWclsN7CnmWTRD/
         rUuxgxRf5jZR//wvnNQ2jJ+1Gc7vs7wLpiHPlyVp4oKjqQoFzaLSJyEHtokUSBRPlkiQ
         ZlC/EVZoKYMPU50+WOgFs1QqA5jV4K3MQAbiYAnAA5gRrf4M3dnhkbkbDUPaflaCIVRn
         pGzCcDw2qeNrOxQpXGPBZ71O5Zc5bWP9dboAXSWngdgiOm4XPp+JxoPM1mRvEesQo6yR
         Y4Az4UDyNxYvZkAcbiqVj3k2xlToW/dwbQCr+PkorDKYhgiBbFCKXKPWRsGfMYqgR5jJ
         looA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1772717451; x=1773322251; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HeQt/T2ObEDlxLbQETck0lulq4qla31hbkK+l9bn/Ho=;
        b=QSyEpkA/6q3Sj+QSNfe3actY5BKZg1CIM8vmwVUEKWFzCiEY7zencFpSNtw2y1gjKq
         44SRlTsDDb2ioZlkFRsqUicY+5PiTLBbjyyukvaeB8B6HONPNVqsDIwhUEOl2USVo9gD
         5SQgaqgIdDBJnqJa9CxjhjO+6kQtx2Fo2+LfyPXdsoQnk8VtJzFy2qouSIgegjTGPw6I
         jufG6ojcvADLpBLzZ8kIjiVNG28FaET4UBnMz3hRXrtLAYTa40M5HXNit7c2K32jlD8x
         UdzKHTAo5v3QVagl7ztqmGg7t2q3Z41Q6MnrjLCEtl3FTocNMkFb4UTFB1VKf3S0o+uH
         YSYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772717451; x=1773322251;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HeQt/T2ObEDlxLbQETck0lulq4qla31hbkK+l9bn/Ho=;
        b=DHklFTRk/+VG1565XS+WU1mV8SpACzKNd04vLMYLMCuhwuBGCZf6zlRbcAA5aIdD0a
         OK59eqf6Zl4ThFrmufrCMGXnp3G8oRUjyNSaq9f8/RaV2m6vlbQyvz84OpDnD64lsASN
         Cv75PeMSlfrh6kC2Hdg4qjSfIHXyg8xGLXhcrpXuOqvL23FdesybtB7MsT7geRSWwGvf
         SOPndDIBJgdEriUPFpaDw2Zss0m44uTWEZyMOeRTcRVNss3DEQ5rKSCpMm5kNTZXizqA
         H5hOGKTvI0chDc78XOOj0AvWOHWvwqBnTs2pzvwFpAuQ33lX3cxlTAOipOyzyEFrokQR
         bTcQ==
X-Forwarded-Encrypted: i=1; AJvYcCXCnT7ckU8GOgXrqfWHBTYoqG3fQo1HlHaUfCV0loPy6cgzfs2LukdsHlppnlHNFFrZ2MU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyF3hIOhg5DU1tRrvI0zuxbXQBkNSQhG9Ewy68K0NXEOj4H1Abk
	Ix1VzVqBnUYnF5S/6j9AKKKg3lzKdp4rhHtal3qnauAbbmV/UJf8xuNNeyq8HpWyqZo2Y2G14nf
	8mXeP5sr6XJoUrf7tASK7HPAwufPCwpiYE6gSzqMVUA==
X-Gm-Gg: ATEYQzwgfcCxH1sF5JFHvx/g3wTjCjsFpZYwkALTkUmKY43e0Q4qtcGO3NsrChJ+0pf
	7BM9HdEnMEbgnw5yJHSzt0yMW3hcztMHyQFjORpMcPolCRbqHQnl707c8QXFInndB9jfVFfTiTq
	AI6ErwkQFfUUAuUxMjAzfIzIXyvUz5A5SQVAlTaRHQ3uV6aoFrPrawZQ+eLPEVrpOTI9rkgl4H2
	WKA7mZ81NXWyNRBchBlxrLg/fOSw/9RzEN45BhQB6s3itSzIHnPm90uO+S+LE/tl4rgspCslL9/
	Iy5MvhPQKY+czIavGClvKtmIVLMAUR8os8fTZ04ideA+oSHTpqvzLhbmwXWbqVdDDWae359vvAG
	jYmCbDQCjO8/Mgvcp/NbJa4VbRw==
X-Received: by 2002:a05:6820:4c14:b0:66e:61cc:80e9 with SMTP id
 006d021491bc7-67b177492dfmr3329436eaf.47.1772717450875; Thu, 05 Mar 2026
 05:30:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260304080804.2281721-1-xujiakai2025@iscas.ac.cn>
In-Reply-To: <20260304080804.2281721-1-xujiakai2025@iscas.ac.cn>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 5 Mar 2026 19:00:38 +0530
X-Gm-Features: AaiRm52bujvrz1wVs7wPhlkcz9NjaN9CVJbTQxzpaKmaFZPorRalJg79gkEOupo
Message-ID: <CAAhSdy0zfm19ucQ3c354VZ5RDEN+ztG1ZRHzVReGYAXS+aid_g@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Fix potential UAF in kvm_riscv_aia_imsic_has_attr()
To: Jiakai Xu <xujiakai2025@iscas.ac.cn>
Cc: linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>, 
	Albert Ou <aou@eecs.berkeley.edu>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Alexandre Ghiti <alex@ghiti.fr>, Jiakai Xu <jiakaiPeanut@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5AA212129B7
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	R_DKIM_ALLOW(-0.20)[brainfault-org.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72820-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_NA(0.00)[brainfault.org];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.infradead.org,linux.dev,kernel.org,eecs.berkeley.edu,dabbelt.com,ghiti.fr,gmail.com];
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
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,mail.gmail.com:mid,brainfault-org.20230601.gappssmtp.com:dkim]
X-Rspamd-Action: no action

On Wed, Mar 4, 2026 at 1:38=E2=80=AFPM Jiakai Xu <xujiakai2025@iscas.ac.cn>=
 wrote:
>
> The KVM_DEV_RISCV_AIA_GRP_APLIC branch of aia_has_attr() was identified
> to have a race condition with concurrent KVM_SET_DEVICE_ATTR ioctls,
> leading to a use-after-free bug.
>
> Upon analyzing the code, it was discovered that the
> KVM_DEV_RISCV_AIA_GRP_IMSIC branch of aia_has_attr() suffers from the sam=
e
> lack of synchronization. It invokes kvm_riscv_aia_imsic_has_attr() withou=
t
> holding dev->kvm->lock.
>
> While aia_has_attr() is running, a concurrent aia_set_attr() could call
> aia_init() under the dev->kvm->lock. If aia_init() fails, it may trigger
> kvm_riscv_vcpu_aia_imsic_cleanup(), which frees imsic_state. Without prop=
er
> locking, kvm_riscv_aia_imsic_has_attr() could attempt to access imsic_sta=
te
> while it is being deallocated.
>
> Although this specific path has not yet been reported by a fuzzer, it
> is logically identical to the APLIC issue. Fix this by acquiring the
> dev->kvm->lock before calling kvm_riscv_aia_imsic_has_attr(), ensuring
> consistency with the locking pattern used for other AIA attribute groups.
>
> Fixes: 5463091a51cf ("RISC-V: KVM: Expose IMSIC registers as attributes o=
f AIA irqchip")
> Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
> Signed-off-by: Jiakai Xu <jiakaiPeanut@gmail.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Queued this patch as fix for Linux-7.0-rcX

Thanks,
Anup


> ---
>  arch/riscv/kvm/aia_device.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/arch/riscv/kvm/aia_device.c b/arch/riscv/kvm/aia_device.c
> index fb901947aefe..9a45c85239fe 100644
> --- a/arch/riscv/kvm/aia_device.c
> +++ b/arch/riscv/kvm/aia_device.c
> @@ -471,7 +471,10 @@ static int aia_has_attr(struct kvm_device *dev, stru=
ct kvm_device_attr *attr)
>                 mutex_unlock(&dev->kvm->lock);
>                 break;
>         case KVM_DEV_RISCV_AIA_GRP_IMSIC:
> -               return kvm_riscv_aia_imsic_has_attr(dev->kvm, attr->attr)=
;
> +               mutex_lock(&dev->kvm->lock);
> +               r =3D kvm_riscv_aia_imsic_has_attr(dev->kvm, attr->attr);
> +               mutex_unlock(&dev->kvm->lock);
> +               break;
>         }
>
>         return r;
> --
> 2.34.1
>

