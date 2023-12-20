Return-Path: <kvm+bounces-4897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 82657819744
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 04:47:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BC0C287905
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 03:47:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FBDAC2D0;
	Wed, 20 Dec 2023 03:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FclPiHBj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEFEC8F51
	for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 03:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703044021;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=napYJyADeTJdk0SxBNP2ImYtRBQl1hD0AXWYIiJNkmk=;
	b=FclPiHBj69HD9TYYjbhu+XqN/6ExkSlQj6yqK8jSXSy5RtyIOY5U7r11AFqLKQwhzf/WYu
	rQjy5c7Tj99JJExZCozXNUpcISclpZlrjrb2EU5LW+uL9yYihv0NRFTPYZOw1OA+lAb0T4
	GSCKAY2QWV9qxpfEIbEAQJEn/Q4DQLY=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-637-up6KytXGP8mXuCzfUAumPQ-1; Tue, 19 Dec 2023 22:46:59 -0500
X-MC-Unique: up6KytXGP8mXuCzfUAumPQ-1
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-5905109ccb0so5151580eaf.2
        for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 19:46:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703044019; x=1703648819;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=napYJyADeTJdk0SxBNP2ImYtRBQl1hD0AXWYIiJNkmk=;
        b=vabjE0WnWI0/QkPudSAhXbhPtvKuRjFtkT/X8CLjJ0zFpoVK6PqDer4DwSx2+Yq9cm
         L2t81N7wrkLMjfebxyRpl3amZz8Xs2X1/wkE5XIC13P4l6a4tYUvt8WioZu1NR0VL9Xs
         R6/BFVIsae+0oFOW09Mt8YnW0DxANaQFygUUFUxD9y20nd5Oy0O2k7450Nw4r5lT47uf
         P65AIGUSZF9TCS+Xo8i2kMAfj8+YhE4BOHNZhdnB4jghvOuX+WgT8q60bxOJQRox+xyH
         lXQ6l6pRmfILVTi7m0MYrbxeYjb6/xYxMh+6+o5PU0rG3Mq4m4AykWHA8K9kcNr0iMrS
         xAdg==
X-Gm-Message-State: AOJu0YxJ5fy0794/QccGBxHbFEk2hthsHtZDrYssfhQ3T9Vxahuv24Qw
	BFV/LEBOGRHUFBnMx6VtAlqRK6y1AoqtNDutQye+z7JxEem0HDL2ytdg1vXAnABgAz8OA/pXvYa
	QtCATy3GiE3v5dRTDb7L58/GWs86k
X-Received: by 2002:a05:6808:16a4:b0:3b8:b063:6bae with SMTP id bb36-20020a05680816a400b003b8b0636baemr22969509oib.93.1703044019103;
        Tue, 19 Dec 2023 19:46:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IElhpIIeE3pYkItfjqsfaUqAiQoIkyVM1KCSOfw1aDXcSf/lBVZVSmNNga9y+gVgQFxuT/583tXyxQqET5EN58=
X-Received: by 2002:a05:6808:16a4:b0:3b8:b063:6bae with SMTP id
 bb36-20020a05680816a400b003b8b0636baemr22969495oib.93.1703044018850; Tue, 19
 Dec 2023 19:46:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231219180858.120898-1-dtatulea@nvidia.com> <20231219180858.120898-2-dtatulea@nvidia.com>
In-Reply-To: <20231219180858.120898-2-dtatulea@nvidia.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 20 Dec 2023 11:46:47 +0800
Message-ID: <CACGkMEsQSJT2ZLZanavwTR668XjHQDoYSz8fH5HnwDmeH5rZgQ@mail.gmail.com>
Subject: Re: [PATCH mlx5-vhost v4 01/15] vdpa/mlx5: Expose resumable vq capability
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Eugenio Perez Martin <eperezma@redhat.com>, 
	Si-Wei Liu <si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Leon Romanovsky <leon@kernel.org>, virtualization@lists.linux-foundation.org, 
	Gal Pressman <gal@nvidia.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Parav Pandit <parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 20, 2023 at 2:09=E2=80=AFAM Dragos Tatulea <dtatulea@nvidia.com=
> wrote:
>
> Necessary for checking if resumable vqs are supported by the hardware.
> Actual support will be added in a downstream patch.
>
> Reviewed-by: Gal Pressman <gal@nvidia.com>
> Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


> ---
>  include/linux/mlx5/mlx5_ifc.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.=
h
> index 6f3631425f38..9eaceaf6bcb0 100644
> --- a/include/linux/mlx5/mlx5_ifc.h
> +++ b/include/linux/mlx5/mlx5_ifc.h
> @@ -1236,7 +1236,8 @@ struct mlx5_ifc_virtio_emulation_cap_bits {
>
>         u8         reserved_at_c0[0x13];
>         u8         desc_group_mkey_supported[0x1];
> -       u8         reserved_at_d4[0xc];
> +       u8         freeze_to_rdy_supported[0x1];
> +       u8         reserved_at_d5[0xb];
>
>         u8         reserved_at_e0[0x20];
>
> --
> 2.43.0
>


