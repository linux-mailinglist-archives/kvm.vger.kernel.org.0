Return-Path: <kvm+bounces-1347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B45E7E6C76
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 15:33:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 14DC41F213C6
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 14:33:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 945D92030E;
	Thu,  9 Nov 2023 14:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AgJSADrK"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC0B200A0
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 14:33:20 +0000 (UTC)
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8924330EB
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 06:33:19 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-53e2308198eso1456201a12.1
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 06:33:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699540397; x=1700145197; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p/p9yeW43NcSMER0YQpwehxYcbDOe/wAYZ9SJZyRksQ=;
        b=AgJSADrKUTpsO3qMXnMf0V7+zJtO5o/xlnjS5N6Iev6Zy+zc63pNgCMPo8bHWOW3uH
         KHeyUMbTyn5euTAAvRfJX0wxmlx5gUVOwFSCBeiXCM/gh1ADwfxqMZ5nI8xhh5AxGe8/
         58mS5IES51h1squ24Ta+rwTOTpwN5ppzX/GhdUrkGlfq0qACah9aN5VCVyyqFm8e1pqp
         o00lVJGi4biA84501dukFF6X/agy2vogg1y+U/WogTAGccFbKI7e4fD2tsOcy6Rxi8z3
         e/rMoiZ0vtSv1Z+uz4inpRw5KiOujo3ii+18w4AFHHiJv3oKkFSntwFA29m4yUsxozXA
         oM+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699540397; x=1700145197;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p/p9yeW43NcSMER0YQpwehxYcbDOe/wAYZ9SJZyRksQ=;
        b=ngqexuOtgjovhcBLovCykm4WjIu1SwpPcbY9bwke/5Qm6bQYpGAf55SIw45ebbLtTy
         uVwjf5HWRVpjJyWfw1T5RHJoWTcvJVUlSfgI1O9TsrXktDKg9xzzFLEnrSwFG5WYW547
         7ZtbHC2W5FIUekOinEbMmio3w+jWM0VBhSgh38yKIBAvDvJVCrCi34eE0LhW8yxLwOkb
         PItMFTIIx4u4xqxm9PNcbVjdsqFoQlGHju/Xfs4HvMRE+g0QZY1agM5BPTVqVrSxiKUU
         Ln/u3MbtUg/9865chYAXPr9QsBwPQNVy+QDuKuC9VXv5F7OknmIEZMbhLmLfwfEPDUvS
         aHpw==
X-Gm-Message-State: AOJu0Yx/ZLNzq7pKyBiS7F2BMXJ/4u260D+TtmPmqdlnxJn/136jYgB4
	BuafEvG3FzufGU1xzokPh9+ZcSIOQZSTIrn41ZQ6Vg==
X-Google-Smtp-Source: AGHT+IG357JpQyVxWaJjqbV8YiVbKX+wpl5yjOXXCxYoMHlCTyZk6gVT3AeKgF8otnbJuRZg7j8Xbtz/KkJPUM7pYnw=
X-Received: by 2002:a17:907:a0b:b0:9e2:8206:2ea9 with SMTP id
 bb11-20020a1709070a0b00b009e282062ea9mr3873060ejc.60.1699540396832; Thu, 09
 Nov 2023 06:33:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231107092149.404842-1-dwmw2@infradead.org> <20231107092149.404842-7-dwmw2@infradead.org>
In-Reply-To: <20231107092149.404842-7-dwmw2@infradead.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 9 Nov 2023 14:33:06 +0000
Message-ID: <CAFEAcA8McSqwXyAg1+9_DOjy5PU==FRja_gjkdXAAqjr7QtLQA@mail.gmail.com>
Subject: Re: [PULL 06/15] hw/xen: automatically assign device index to block devices
To: David Woodhouse <dwmw2@infradead.org>
Cc: qemu-devel@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>, 
	Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, 
	Stefano Stabellini <sstabellini@kernel.org>, Anthony Perard <anthony.perard@citrix.com>, 
	Paul Durrant <paul@xen.org>, =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, 
	Richard Henderson <richard.henderson@linaro.org>, Eduardo Habkost <eduardo@habkost.net>, 
	Jason Wang <jasowang@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org, 
	xen-devel@lists.xenproject.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 7 Nov 2023 at 09:24, David Woodhouse <dwmw2@infradead.org> wrote:
>
> From: David Woodhouse <dwmw@amazon.co.uk>
>
> There's no need to force the user to assign a vdev. We can automatically
> assign one, starting at xvda and searching until we find the first disk
> name that's unused.
>
> This means we can now allow '-drive if=3Dxen,file=3Dxxx' to work without =
an
> explicit separate -driver argument, just like if=3Dvirtio.
>
> Rip out the legacy handling from the xenpv machine, which was scribbling
> over any disks configured by the toolstack, and didn't work with anything
> but raw images.

Hi; Coverity points out an issue in this code (CID 1523906):

> +/*
> + * Find a free device name in the xvda =E2=86=92 xvdfan range and set it=
 in
> + * blockdev->props.vdev. Our definition of "free" is that there must
> + * be no other disk or partition with the same disk number.
> + *
> + * You are technically permitted to have all of hda, hda1, sda, sda1,
> + * xvda and xvda1 as *separate* PV block devices with separate backing
> + * stores. That doesn't make it a good idea. This code will skip xvda
> + * if *any* of those "conflicting" devices already exists.
> + *
> + * The limit of xvdfan (disk 4095) is fairly arbitrary just to avoid a
> + * stupidly sized bitmap, but Linux as of v6.6 doesn't support anything
> + * higher than that anyway.
> + */
> +static bool xen_block_find_free_vdev(XenBlockDevice *blockdev, Error **e=
rrp)
> +{
> +    XenBus *xenbus =3D XEN_BUS(qdev_get_parent_bus(DEVICE(blockdev)));
> +    unsigned long used_devs[BITS_TO_LONGS(MAX_AUTO_VDEV)];
> +    XenBlockVdev *vdev =3D &blockdev->props.vdev;
> +    char fe_path[XENSTORE_ABS_PATH_MAX + 1];
> +    char **existing_frontends;
> +    unsigned int nr_existing =3D 0;
> +    unsigned int vdev_nr;
> +    int i, disk =3D 0;
> +
> +    snprintf(fe_path, sizeof(fe_path), "/local/domain/%u/device/vbd",
> +             blockdev->xendev.frontend_id);
> +
> +    existing_frontends =3D qemu_xen_xs_directory(xenbus->xsh, XBT_NULL, =
fe_path,
> +                                               &nr_existing);
> +    if (!existing_frontends && errno !=3D ENOENT) {

Here we check whether existing_frontends is NULL, implying it
might be NULL (and the && in the condition means we might not
take this error-exit path even if it is NULL)...

> +        error_setg_errno(errp, errno, "cannot read %s", fe_path);
> +        return false;
> +    }
> +
> +    memset(used_devs, 0, sizeof(used_devs));
> +    for (i =3D 0; i < nr_existing; i++) {
> +        if (qemu_strtoui(existing_frontends[i], NULL, 10, &vdev_nr)) {

...but here we deref existing_frontends, implying it can't be NULL.

> +            free(existing_frontends[i]);
> +            continue;
> +        }
> +
> +        free(existing_frontends[i]);
> +
> +        disk =3D vdev_to_diskno(vdev_nr);
> +        if (disk < 0 || disk >=3D MAX_AUTO_VDEV) {
> +            continue;
> +        }
> +
> +        set_bit(disk, used_devs);
> +    }
> +    free(existing_frontends);

thanks
-- PMM

