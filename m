Return-Path: <kvm+bounces-3107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE7FD800A07
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 12:47:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 032151C20AD0
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 11:47:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AC30219F8;
	Fri,  1 Dec 2023 11:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GPoWitbd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5AA1704
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 03:47:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701431244;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6uHVtje56LWat5Vmv+PcEyAck+di+XL9VN6HEiOJE+M=;
	b=GPoWitbd6ghvph4382uGlvJ8gRpNWuWmCjIVumwaw1h0HsuuL3vZk9Z/SRAfxQm8093/eP
	6XAsJTsKD4UUKAiGhJ8nPxnMgLdAJ3CEburMVmReV4JRaCdh9koEQjvdoQGQdNTpMIMNcv
	yqSMYV98lc5yxmHculR9LgEhBDsQYE4=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-541-UdzGCd2AOGKQx56PVrjMiw-1; Fri, 01 Dec 2023 06:47:23 -0500
X-MC-Unique: UdzGCd2AOGKQx56PVrjMiw-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-5d1b2153ba1so35315277b3.2
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 03:47:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701431242; x=1702036042;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6uHVtje56LWat5Vmv+PcEyAck+di+XL9VN6HEiOJE+M=;
        b=q276h+ro0xnj8v3X6pBwf1zKWxQYJRlD13C7W2B+xNpZ2ciOnA3hdqI3Y6oa75r5X4
         zs7EQJM1Cb1LfYGCrhXlQS4JKS0W6RzNR7v93nd4QMj9DC3dzeCqM08RzQvjcSxkglY3
         YEX3XBYxrBhDyXnyrd8a2ol7xbjkUJZqVviSs6IOjMN50MyarMCoah99S0sBlI71ErDr
         cpnjbvSV+Dk7m2MhXJ0B12B8dpALZ84aukgpPu3K9OaaassyxGJeMmSwFT21nJLR+zI1
         gKAOZZdgwe06k4dOxa8DWAtTvy4Uxbjpp5HVTMqpOdlSUSyBBBHij9RvRCK8rEhznTqt
         qpLg==
X-Gm-Message-State: AOJu0Yzz0/cK1BIc+Ms6zdzn+Hue666lbpjkjPYHjOUM9Wv2+0bIevLN
	w4c5EeeXguQ76q0/4fjUf63bQAul17yL7PHhs8Ak7KpJEd/iQoqB4ZM+QIvXIFb18YoYqsg4WLu
	DspELPmxrSxPthOeufhrz/MGkRpBB
X-Received: by 2002:a81:b60c:0:b0:5d4:226f:69a4 with SMTP id u12-20020a81b60c000000b005d4226f69a4mr1446072ywh.28.1701431241868;
        Fri, 01 Dec 2023 03:47:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGg2MuyiMF1tTj3uUQulmb0jD2AozD8K6xVD0pM3BW790ulvznuBYypSmkNfOvOQQkPXQZjksPtzVYkngc8Se0=
X-Received: by 2002:a81:b60c:0:b0:5d4:226f:69a4 with SMTP id
 u12-20020a81b60c000000b005d4226f69a4mr1446054ywh.28.1701431241604; Fri, 01
 Dec 2023 03:47:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231201104857.665737-1-dtatulea@nvidia.com> <20231201104857.665737-3-dtatulea@nvidia.com>
In-Reply-To: <20231201104857.665737-3-dtatulea@nvidia.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Fri, 1 Dec 2023 12:46:45 +0100
Message-ID: <CAJaqyWc3Xa9abmS+MxFbgQHUao0_=tcx4mres2AeDWqvtmZ5Jg@mail.gmail.com>
Subject: Re: [PATCH vhost 2/7] vdpa/mlx5: Split function into locked and
 unlocked variants
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Si-Wei Liu <si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Leon Romanovsky <leon@kernel.org>, virtualization@lists.linux-foundation.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Gal Pressman <galp@nvidia.com>, Parav Pandit <parav@nvidia.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 1, 2023 at 11:49=E2=80=AFAM Dragos Tatulea <dtatulea@nvidia.com=
> wrote:
>
> mlx5_vdpa_destroy_mr contains more logic than _mlx5_vdpa_destroy_mr.
> There is no reason for this to be the case. All the logic can go into
> the unlocked variant.
>
> Using the unlocked version is needed in a follow-up patch. And it also
> makes it more consistent with mlx5_vdpa_create_mr.
>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>

Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

> ---
>  drivers/vdpa/mlx5/core/mr.c | 31 ++++++++++++++++---------------
>  1 file changed, 16 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
> index 2197c46e563a..8c80d9e77935 100644
> --- a/drivers/vdpa/mlx5/core/mr.c
> +++ b/drivers/vdpa/mlx5/core/mr.c
> @@ -498,32 +498,32 @@ static void destroy_user_mr(struct mlx5_vdpa_dev *m=
vdev, struct mlx5_vdpa_mr *mr
>
>  static void _mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev, struct ml=
x5_vdpa_mr *mr)
>  {
> +       if (!mr)
> +               return;
> +
>         if (mr->user_mr)
>                 destroy_user_mr(mvdev, mr);
>         else
>                 destroy_dma_mr(mvdev, mr);
>
> +       for (int i =3D 0; i < MLX5_VDPA_NUM_AS; i++) {
> +               if (mvdev->mr[i] =3D=3D mr)
> +                       mvdev->mr[i] =3D NULL;
> +       }
> +
>         vhost_iotlb_free(mr->iotlb);
> +
> +       kfree(mr);
>  }
>
>  void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev,
>                           struct mlx5_vdpa_mr *mr)
>  {
> -       if (!mr)
> -               return;
> -
>         mutex_lock(&mvdev->mr_mtx);
>
>         _mlx5_vdpa_destroy_mr(mvdev, mr);
>
> -       for (int i =3D 0; i < MLX5_VDPA_NUM_AS; i++) {
> -               if (mvdev->mr[i] =3D=3D mr)
> -                       mvdev->mr[i] =3D NULL;
> -       }
> -
>         mutex_unlock(&mvdev->mr_mtx);
> -
> -       kfree(mr);
>  }
>
>  void mlx5_vdpa_update_mr(struct mlx5_vdpa_dev *mvdev,
> @@ -535,10 +535,7 @@ void mlx5_vdpa_update_mr(struct mlx5_vdpa_dev *mvdev=
,
>         mutex_lock(&mvdev->mr_mtx);
>
>         mvdev->mr[asid] =3D new_mr;
> -       if (old_mr) {
> -               _mlx5_vdpa_destroy_mr(mvdev, old_mr);
> -               kfree(old_mr);
> -       }
> +       _mlx5_vdpa_destroy_mr(mvdev, old_mr);
>
>         mutex_unlock(&mvdev->mr_mtx);
>
> @@ -546,8 +543,12 @@ void mlx5_vdpa_update_mr(struct mlx5_vdpa_dev *mvdev=
,
>
>  void mlx5_vdpa_destroy_mr_resources(struct mlx5_vdpa_dev *mvdev)
>  {
> +       mutex_lock(&mvdev->mr_mtx);
> +
>         for (int i =3D 0; i < MLX5_VDPA_NUM_AS; i++)
> -               mlx5_vdpa_destroy_mr(mvdev, mvdev->mr[i]);
> +               _mlx5_vdpa_destroy_mr(mvdev, mvdev->mr[i]);
> +
> +       mutex_unlock(&mvdev->mr_mtx);
>
>         prune_iotlb(mvdev->cvq.iotlb);
>  }
> --
> 2.42.0
>


