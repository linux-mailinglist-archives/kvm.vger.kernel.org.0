Return-Path: <kvm+bounces-4959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 73CE081A44A
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 17:18:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0DEC21F26A4E
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 16:18:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B39794CB40;
	Wed, 20 Dec 2023 16:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UpqJKDJ7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AAC4AF97
	for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 16:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703088772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/R2O8TJ4542iZyXv/uB6h7A35AJkq8aJE1UHdDp43cM=;
	b=UpqJKDJ7PIVuzGsB7KG3IU8MHUq6lJvYRT5HZDhZXHfnpnHuguiENH9ojHkvulVU74/xYk
	q8vW+5bCYRhC9KVvclvOFl+r3oevDt77cNG8KULK3frBM6ijzJ4+85Xm1wndQM2Y4snU3k
	ZeV7e7FHUYNRNpnXGJkcp+Tj51dzWnE=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-144-lZ7IJ95sMC2O_nVWXIJY2Q-1; Wed, 20 Dec 2023 11:12:51 -0500
X-MC-Unique: lZ7IJ95sMC2O_nVWXIJY2Q-1
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-5e617562a65so56391047b3.1
        for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 08:12:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703088771; x=1703693571;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/R2O8TJ4542iZyXv/uB6h7A35AJkq8aJE1UHdDp43cM=;
        b=eW8E+pmCpurI+4PA0e0BT2sLXNfOARcLQFhNXHezFC3DJjmeTG59cwuA4Xj1lLIl+4
         IUG3prcgOr9MVl8SKwLPJ/i4TtpBduFOHSP33xmmhKhIrmNBUkr6tiJdGZfx+dnpzpaV
         gV9bwkkx0hHwK/I/t/d41jhVlECFh+J9LSy/GtxlHxGNQmIfQIaEb+1evkGqppFeQhwH
         ptl9urBLuratfBo9C35E2iNjMS2pXNZHyBZ0xj5nc33WkI7jeRdSgn0R4CgZ4pyoHGQ4
         D7q8FLCVgW6mOp3vrqOCEMxUqYkVfWeamtz2s2PkVNKdkiUkxb/EEujjIQmkPaSuXpD0
         kZ7g==
X-Gm-Message-State: AOJu0YxH5mJIZQHzWjGnmsZOOYSclhJcG337xMcpVOPgVMmujdwSzL3d
	7CGQk7E3DYn6rDj8OqD5vYkI4ukDt86l9kj/vAmqs16QF9wQzu5+mu/mcorAZGX3IiN6slSxhOE
	hh4WYHz+H73yK1HfnDHVxu+aXqi/y
X-Received: by 2002:a0d:c484:0:b0:5d7:1940:dd79 with SMTP id g126-20020a0dc484000000b005d71940dd79mr16406973ywd.79.1703088770850;
        Wed, 20 Dec 2023 08:12:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFl9HuJvZdKloOZeydrDbBWg/CYLQwNnyxXZYFdRHvKNBSwps+IR8b+dmnGiDTqDuL+cw7PJL7bJDjI3MeSc9E=
X-Received: by 2002:a0d:c484:0:b0:5d7:1940:dd79 with SMTP id
 g126-20020a0dc484000000b005d71940dd79mr16406957ywd.79.1703088770610; Wed, 20
 Dec 2023 08:12:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231219180858.120898-1-dtatulea@nvidia.com> <20231219180858.120898-6-dtatulea@nvidia.com>
In-Reply-To: <20231219180858.120898-6-dtatulea@nvidia.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Wed, 20 Dec 2023 17:12:14 +0100
Message-ID: <CAJaqyWfXnRNDzCL3GgdQby7ZmKxxRic5wsi2RTX24sa1Lz4F4g@mail.gmail.com>
Subject: Re: [PATCH vhost v4 05/15] vdpa: Accept VHOST_BACKEND_F_CHANGEABLE_VQ_STATE_IN_SUSPEND
 backend feature
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
> If userland sets this feature, allow it.
>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Suggested-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

> ---
>  drivers/vhost/vdpa.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 2250fcd90e5b..b4e8ddf86485 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -750,6 +750,7 @@ static long vhost_vdpa_unlocked_ioctl(struct file *fi=
lep,
>                                  BIT_ULL(VHOST_BACKEND_F_SUSPEND) |
>                                  BIT_ULL(VHOST_BACKEND_F_RESUME) |
>                                  BIT_ULL(VHOST_BACKEND_F_CHANGEABLE_VQ_AD=
DR_IN_SUSPEND) |
> +                                BIT_ULL(VHOST_BACKEND_F_CHANGEABLE_VQ_ST=
ATE_IN_SUSPEND) |
>                                  BIT_ULL(VHOST_BACKEND_F_ENABLE_AFTER_DRI=
VER_OK)))
>                         return -EOPNOTSUPP;
>                 if ((features & BIT_ULL(VHOST_BACKEND_F_SUSPEND)) &&
> --
> 2.43.0
>


