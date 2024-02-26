Return-Path: <kvm+bounces-9839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 977B48672B5
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 12:11:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52B8528C6A8
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:11:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B8F01D535;
	Mon, 26 Feb 2024 11:11:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36DC91CD1D;
	Mon, 26 Feb 2024 11:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708945885; cv=none; b=iXAzncycZb0kxe5kT32xQoeXdYcNvE8LQ+SKJwmAYcq/y4Qr+iHvOH4wVR0EFjDiXuh27N/CgL+FLOhwctoVMdkQuhOyBs6oNRSEgpQgpbSKxYtB1WGc41R4UnCTZnGwNykOCJSudsfToXzUK7R8rm/Ap/RM5Kn2SsJpGTyznRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708945885; c=relaxed/simple;
	bh=5dziVRXpV/oZCZzb/hRctXC2CN+AIT/ZLDboQLpR9wo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PdgtKRqk4ZnNoukHAWHGrBsZmDDRlivzfgjWjjtSo/2LARBuWTuYt1VQ16pETZl10LKxIJ6YCClajqH+e0prN9w8yynb5LPaXPNRncDl7dun1cjl5ZN1kvGxfQYg68BEjYqyAVLlXYMv/hfGIctEujr9sMBHxIHZdToDPd7oBNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-608cf2e08f9so20424457b3.0;
        Mon, 26 Feb 2024 03:11:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708945882; x=1709550682;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dgfuxAE2YpvPdASIbIFbY2C7QlIAI+V4rm0xOdGjAEI=;
        b=YeFOofN2E/jw8pSVcTXAmjgC4aXJTKIqpqfdILfZkzB2VUESX1YAurPt9+f8/QqMDX
         V3EWFzTBIoiThRZXxGoclgwM3kRq9JPge+17m/coJGH6hnovLNt+FE+mjLn+pWtTd8ug
         SwbjLL8VZArOX1++GtyWzVQp3LShIiyvYJ34YpmUpSFL/Wh967336NW2MuVzPYaGfjsm
         jdZ5JPavdb+RDUrV0+/e/9GpBlyc9tPPFPx1we7H0VYyZsJyUT/Zsugu0OXwhXG1ncq5
         b0KRykPoalEdmXEPfZuYQeWNYOSyDJWouv3ft3bv+ihiq04XjXYmoIT4xrg47Puyljq0
         vJjA==
X-Forwarded-Encrypted: i=1; AJvYcCX7oKMoH8QcCN9XnnVOrZSKf2A1xHDaW9+30I4e4tFVu817k1ww7WXmvWqMOwumHFx5JzNZ/FF9MlMomTaTrykdpd2NM/uRZU9J9Ja2cBPKxA8FZJUbzAegi8eWhLTLKi/y
X-Gm-Message-State: AOJu0YyhlV1RJQU7aFW559HBo0in1hd+uLMtxRLk7wHe0ivUKslpHMsG
	8idiTpmQqkaPkph5zi3oX6/wEwozzrbBWxVXO7GUG02Dsnk3qP3egBBJCRUlgbQ=
X-Google-Smtp-Source: AGHT+IEIimbCW6SmVoEC3S3guqz0GeFbhBQw8mjsjsPDUPUMsZ//8AD0zou1OHQ6B0Ky0Vh1idWZzg==
X-Received: by 2002:a05:690c:3612:b0:608:b8b4:3df5 with SMTP id ft18-20020a05690c361200b00608b8b43df5mr6505009ywb.18.1708945881669;
        Mon, 26 Feb 2024 03:11:21 -0800 (PST)
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com. [209.85.219.178])
        by smtp.gmail.com with ESMTPSA id b3-20020a0dc003000000b0060447768630sm1117915ywd.124.2024.02.26.03.11.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Feb 2024 03:11:21 -0800 (PST)
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-dc6d24737d7so2444215276.0;
        Mon, 26 Feb 2024 03:11:21 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXE/d+8DK7BNPyXKnLFch288B1Oh+MH/O3ybx1h8M88Wgryzo1qEAP39R9IIm/nL4X5/EnLfvG2w3dzd9KSDLuDdCR6se/dspmQ9jnfPE8SHVPTQx9USt2GLB2izls8NDoz
X-Received: by 2002:a25:3618:0:b0:dc2:45af:aa5b with SMTP id
 d24-20020a253618000000b00dc245afaa5bmr3815370yba.59.1708945881235; Mon, 26
 Feb 2024 03:11:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1d1b873b59b208547439225aee1f24d6f2512a1f.1708945194.git.geert+renesas@glider.be>
In-Reply-To: <1d1b873b59b208547439225aee1f24d6f2512a1f.1708945194.git.geert+renesas@glider.be>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 26 Feb 2024 12:11:09 +0100
X-Gmail-Original-Message-ID: <CAMuHMdU3rMSe9SsdyvRmKiRVqMFMgFXDus3j2HqF6nhmRrAkDg@mail.gmail.com>
Message-ID: <CAMuHMdU3rMSe9SsdyvRmKiRVqMFMgFXDus3j2HqF6nhmRrAkDg@mail.gmail.com>
Subject: Re: [PATCH] vfio: amba: Rename pl330_ids[] to vfio_amba_ids[]
To: Antonios Motakis <antonios.motakis@huawei.com>
Cc: Eric Auger <eric.auger@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Geert Uytterhoeven <geert+renesas@glider.be>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

CC Antonios' new address
(time to update all references in the Linux kernel source tree?)

On Mon, Feb 26, 2024 at 12:09=E2=80=AFPM Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
> Obviously drivers/vfio/platform/vfio_amba.c started its life as a
> simplified copy of drivers/dma/pl330.c, but not all variable names were
> updated.
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  drivers/vfio/platform/vfio_amba.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/vfio/platform/vfio_amba.c b/drivers/vfio/platform/vf=
io_amba.c
> index 6464b3939ebcfb53..485c6f9161a91be0 100644
> --- a/drivers/vfio/platform/vfio_amba.c
> +++ b/drivers/vfio/platform/vfio_amba.c
> @@ -122,16 +122,16 @@ static const struct vfio_device_ops vfio_amba_ops =
=3D {
>         .detach_ioas    =3D vfio_iommufd_physical_detach_ioas,
>  };
>
> -static const struct amba_id pl330_ids[] =3D {
> +static const struct amba_id vfio_amba_ids[] =3D {
>         { 0, 0 },
>  };
>
> -MODULE_DEVICE_TABLE(amba, pl330_ids);
> +MODULE_DEVICE_TABLE(amba, vfio_amba_ids);
>
>  static struct amba_driver vfio_amba_driver =3D {
>         .probe =3D vfio_amba_probe,
>         .remove =3D vfio_amba_remove,
> -       .id_table =3D pl330_ids,
> +       .id_table =3D vfio_amba_ids,
>         .drv =3D {
>                 .name =3D "vfio-amba",
>                 .owner =3D THIS_MODULE,
> --
> 2.34.1

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds

