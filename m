Return-Path: <kvm+bounces-4961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E53DD81A529
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 17:31:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5C4891F24CD0
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 16:31:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AA122D614;
	Wed, 20 Dec 2023 16:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sx3FdSrE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06EC225CA
	for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 16:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703089900;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IgZDAP5MsLlemQXzE+yHPnrJJciIAnmmc9CrE5dpHC4=;
	b=Sx3FdSrEl8SfJC0OUF1JBPvaldcaiYPkWVbFaTo636Got2yCEaC/6Z/45Y+DFfBW7eO1pc
	az8wrjOveS57PtmO+hALSq4G3lRN54naOvEbsD4alvzGtpRnK/rJd5EMwMh+caIqFkFXYI
	VsDu5YkVizUkrmLYYoNAfymsqhELfY0=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-159-Kl1ysGhwNw-Y__g8faNXUQ-1; Wed, 20 Dec 2023 11:31:38 -0500
X-MC-Unique: Kl1ysGhwNw-Y__g8faNXUQ-1
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-5e8d966fbc0so5043297b3.1
        for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 08:31:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703089898; x=1703694698;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IgZDAP5MsLlemQXzE+yHPnrJJciIAnmmc9CrE5dpHC4=;
        b=t/mt5CO3giwqHw6iJio2BNjQln7nFDUxrr01MZQfIBjzDoZJ57PYfxFhvVrX9V2DS6
         QVIVRBAJ1d92/ZpqhrHN34j6zCp/Q8H6FSnDEIwglNkMFgbON0P6jeyuHEsyZft76qDh
         /pHAeYLYYH1qm8pOHb+AZ5gSFZUJWQapfkL5EIt3Cr5wMCyo/09JFaSgnH/QUmS3hFC3
         CqVogIRyaKzQkzhJn1YgKLH5hfmUTMVA0hSPyYuvKICPbU1JZd9TOH6HHrhJUD39pgcN
         +lw3pLl0DqYhx/cB0lOB8s8EkbdwqqugLgP/YHYVXKPZUK1swFxLxsXp/661uiSmBbQY
         LKpg==
X-Gm-Message-State: AOJu0Yxp/O7Hq6iH09EqR5I9gD6dW/DUebC3FEZUNh8OGod0jzLBiGNk
	ltaLHZynNFULK9/t9yrmCpNXygIfzJFoC70nUhMY7dztl7yX5upCdtDJaCPdsoS+fAqa1eYk2xQ
	exmOOKSgdlOc0y8xGmCXGdb2nOBqf
X-Received: by 2002:a0d:dd82:0:b0:5e6:e9d0:990b with SMTP id g124-20020a0ddd82000000b005e6e9d0990bmr1808821ywe.32.1703089898120;
        Wed, 20 Dec 2023 08:31:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG1KXR2BgnYGD0+xnFjeY7zp2Hbz1GeSRtIDMZmECKqn9k3gArnzq6WK6nrkxuFCZoLxJrHlOvpLl9D9VtzDrA=
X-Received: by 2002:a0d:dd82:0:b0:5e6:e9d0:990b with SMTP id
 g124-20020a0ddd82000000b005e6e9d0990bmr1808809ywe.32.1703089897863; Wed, 20
 Dec 2023 08:31:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231219180858.120898-1-dtatulea@nvidia.com> <20231219180858.120898-8-dtatulea@nvidia.com>
In-Reply-To: <20231219180858.120898-8-dtatulea@nvidia.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Wed, 20 Dec 2023 17:31:01 +0100
Message-ID: <CAJaqyWet3m8HmHRTJNshQgCn0jqyrO476j0Z-rwwqyDNj4B66w@mail.gmail.com>
Subject: Re: [PATCH vhost v4 07/15] vdpa: Block vq address change in DRIVER_OK
 unless device supports it
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Si-Wei Liu <si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Leon Romanovsky <leon@kernel.org>, virtualization@lists.linux-foundation.org, 
	Gal Pressman <gal@nvidia.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Parav Pandit <parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 19, 2023 at 7:09=E2=80=AFPM Dragos Tatulea <dtatulea@nvidia.com=
> wrote:
>
> Virtqueue address change during DRIVE_OK is not supported by the virtio
> standard. Allow this op in DRIVER_OK only for devices that support
> changing the address during DRIVER_OK if the device is suspended.
>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Suggested-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

> ---
>  drivers/vhost/vdpa.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 00b4fa8e89f2..6bfa3391935a 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -625,6 +625,29 @@ static long vhost_vdpa_resume(struct vhost_vdpa *v)
>         return ret;
>  }
>
> +static bool vhost_vdpa_vq_config_allowed(struct vhost_vdpa *v, unsigned =
int cmd)
> +{
> +       struct vdpa_device *vdpa =3D v->vdpa;
> +       const struct vdpa_config_ops *ops =3D vdpa->config;
> +       int feature;
> +
> +       if (!(ops->get_status(vdpa) & VIRTIO_CONFIG_S_DRIVER_OK))
> +               return true;
> +
> +       if (!v->suspended)
> +               return false;
> +
> +       switch (cmd) {
> +       case VHOST_SET_VRING_ADDR:
> +               feature =3D VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND=
;
> +               break;
> +       default:
> +               return false;
> +       }
> +
> +       return v->vdev.vqs && vhost_backend_has_feature(v->vdev.vqs[0], f=
eature);
> +}
> +
>  static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cm=
d,
>                                    void __user *argp)
>  {
> @@ -703,6 +726,9 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa =
*v, unsigned int cmd,
>
>         switch (cmd) {
>         case VHOST_SET_VRING_ADDR:
> +               if (!vhost_vdpa_vq_config_allowed(v, cmd))
> +                       return -EOPNOTSUPP;
> +
>                 if (ops->set_vq_address(vdpa, idx,
>                                         (u64)(uintptr_t)vq->desc,
>                                         (u64)(uintptr_t)vq->avail,
> --
> 2.43.0
>


