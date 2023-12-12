Return-Path: <kvm+bounces-4227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E3B680F592
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 19:33:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17C86281F88
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 18:33:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F9467D88D;
	Tue, 12 Dec 2023 18:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sg+GXmAM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD5ACA
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 10:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702406017;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DY4Ho2xtxV0ldC2dQ8P0wLgCZVZkQ1qv4NfOBypcZ+I=;
	b=Sg+GXmAMvgKZcqzMioHXAJe+4Csu0BFtp/sL7e0B2R/p3ZyrUuUfbVQ0fCKiraK7sgUBM4
	HexWSZ9hFhi4nu0iSDfwF5RGavrArznBRAczGaZEl42D6/73FSF93rrFBPrt+NOnNcfJ5N
	X+1GE0Yygf2nQKowS6AA1jl5Z5sKIS8=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-JiU71vBpNv-Ec0bxxj2G0g-1; Tue, 12 Dec 2023 13:33:34 -0500
X-MC-Unique: JiU71vBpNv-Ec0bxxj2G0g-1
Received: by mail-yb1-f200.google.com with SMTP id 3f1490d57ef6-db548f8dae4so6148883276.3
        for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 10:33:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702406014; x=1703010814;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DY4Ho2xtxV0ldC2dQ8P0wLgCZVZkQ1qv4NfOBypcZ+I=;
        b=eSEB7q4WGuSWfzyF5AQPnWJyYjTiC0YYJGgLDd7LNWreO6PTrAL+am6rDCMMbX/LLZ
         zQEfukYcZWyZ28bF0yqIyZnR4WWPtcaubRlHHyGoCeHNPkhl2ZvAWhx0OYtubLKim6NT
         6x4r97u6dQ9XGIPbpCbhUoH6aE7WBkTvjqvlRqoViCY/hmKNvH5DQZH9LQTPlWJ9RhVN
         r/4doVZ2DCkAY7aauTS0ghHdnCxBsR0g3SgxkQhpBvGsJW2+e64oRPVJHaRflwG6IgC7
         MuTwHB3PpLuEpxIyB4tmH0wyX5X2d35HyEKRVAwOm6HoAvHyonm+l+CaNVrlwpnF9Sae
         dnZA==
X-Gm-Message-State: AOJu0YyNTCsJkFeqygr5g/1v79VR74oBXndC8oedeL1MzZwbP1d36yED
	LrTjllb++cQAwLDjFXSKWlfIK6TdKWcfjqieQYv+XjYheBa/PqHyJl3F0MkXKDbolESrvIu5kaf
	MHhPnB/YUMoi8t+gianClEeGDlX8H
X-Received: by 2002:a25:694e:0:b0:db7:dad0:76d4 with SMTP id e75-20020a25694e000000b00db7dad076d4mr4083016ybc.112.1702406013888;
        Tue, 12 Dec 2023 10:33:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGgHGmEdl6YUM2TV851wK+4D25Di/15UW9oEJOx2YbjevvT2YLhlXlylB0hU41DH45mMWlAUyKq8X2SP6Z8qeI=
X-Received: by 2002:a25:694e:0:b0:db7:dad0:76d4 with SMTP id
 e75-20020a25694e000000b00db7dad076d4mr4083010ybc.112.1702406013590; Tue, 12
 Dec 2023 10:33:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231205104609.876194-1-dtatulea@nvidia.com> <20231205104609.876194-9-dtatulea@nvidia.com>
In-Reply-To: <20231205104609.876194-9-dtatulea@nvidia.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Tue, 12 Dec 2023 19:32:57 +0100
Message-ID: <CAJaqyWcZou64q2VBgVdJMK3KbJVx9eduRiju8vjXnKa8gv52ng@mail.gmail.com>
Subject: Re: [PATCH vhost v2 8/8] vdpa/mlx5: Add mkey leak detection
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Si-Wei Liu <si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Leon Romanovsky <leon@kernel.org>, virtualization@lists.linux-foundation.org, 
	Gal Pressman <gal@nvidia.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Parav Pandit <parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 5, 2023 at 11:47=E2=80=AFAM Dragos Tatulea <dtatulea@nvidia.com=
> wrote:
>
> Track allocated mrs in a list and show warning when leaks are detected
> on device free or reset.
>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Reviewed-by: Gal Pressman <gal@nvidia.com>

Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

> ---
>  drivers/vdpa/mlx5/core/mlx5_vdpa.h |  2 ++
>  drivers/vdpa/mlx5/core/mr.c        | 23 +++++++++++++++++++++++
>  drivers/vdpa/mlx5/net/mlx5_vnet.c  |  2 ++
>  3 files changed, 27 insertions(+)
>
> diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/=
mlx5_vdpa.h
> index 1a0d27b6e09a..50aac8fe57ef 100644
> --- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
> +++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
> @@ -37,6 +37,7 @@ struct mlx5_vdpa_mr {
>         bool user_mr;
>
>         refcount_t refcount;
> +       struct list_head mr_list;
>  };
>
>  struct mlx5_vdpa_resources {
> @@ -95,6 +96,7 @@ struct mlx5_vdpa_dev {
>         u32 generation;
>
>         struct mlx5_vdpa_mr *mr[MLX5_VDPA_NUM_AS];
> +       struct list_head mr_list_head;
>         /* serialize mr access */
>         struct mutex mr_mtx;
>         struct mlx5_control_vq cvq;
> diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
> index c7dc8914354a..4758914ccf86 100644
> --- a/drivers/vdpa/mlx5/core/mr.c
> +++ b/drivers/vdpa/mlx5/core/mr.c
> @@ -508,6 +508,8 @@ static void _mlx5_vdpa_destroy_mr(struct mlx5_vdpa_de=
v *mvdev, struct mlx5_vdpa_
>
>         vhost_iotlb_free(mr->iotlb);
>
> +       list_del(&mr->mr_list);
> +
>         kfree(mr);
>  }
>
> @@ -560,12 +562,31 @@ void mlx5_vdpa_update_mr(struct mlx5_vdpa_dev *mvde=
v,
>         mutex_unlock(&mvdev->mr_mtx);
>  }
>
> +static void mlx5_vdpa_show_mr_leaks(struct mlx5_vdpa_dev *mvdev)
> +{
> +       struct mlx5_vdpa_mr *mr;
> +
> +       mutex_lock(&mvdev->mr_mtx);
> +
> +       list_for_each_entry(mr, &mvdev->mr_list_head, mr_list) {
> +
> +               mlx5_vdpa_warn(mvdev, "mkey still alive after resource de=
lete: "
> +                                     "mr: %p, mkey: 0x%x, refcount: %u\n=
",
> +                                      mr, mr->mkey, refcount_read(&mr->r=
efcount));
> +       }
> +
> +       mutex_unlock(&mvdev->mr_mtx);
> +
> +}
> +
>  void mlx5_vdpa_destroy_mr_resources(struct mlx5_vdpa_dev *mvdev)
>  {
>         for (int i =3D 0; i < MLX5_VDPA_NUM_AS; i++)
>                 mlx5_vdpa_update_mr(mvdev, NULL, i);
>
>         prune_iotlb(mvdev->cvq.iotlb);
> +
> +       mlx5_vdpa_show_mr_leaks(mvdev);
>  }
>
>  static int _mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
> @@ -592,6 +613,8 @@ static int _mlx5_vdpa_create_mr(struct mlx5_vdpa_dev =
*mvdev,
>         if (err)
>                 goto err_iotlb;
>
> +       list_add_tail(&mr->mr_list, &mvdev->mr_list_head);
> +
>         return 0;
>
>  err_iotlb:
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/ml=
x5_vnet.c
> index 133cbb66dcfe..778821bab7d9 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -3722,6 +3722,8 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *=
v_mdev, const char *name,
>         if (err)
>                 goto err_mpfs;
>
> +       INIT_LIST_HEAD(&mvdev->mr_list_head);
> +
>         if (MLX5_CAP_GEN(mvdev->mdev, umem_uid_0)) {
>                 err =3D mlx5_vdpa_create_dma_mr(mvdev);
>                 if (err)
> --
> 2.42.0
>


