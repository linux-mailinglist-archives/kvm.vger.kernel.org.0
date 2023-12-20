Return-Path: <kvm+bounces-4954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 37C1881A402
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 17:14:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CAE701F235CA
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 16:14:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7398246558;
	Wed, 20 Dec 2023 16:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HQMNA0l8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429D54643B
	for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 16:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703088604;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YBF/2A/nktRQkyV9wK9FTmKMlXm8fHaSo0cgylBofKE=;
	b=HQMNA0l8wMNiVRAB2m4LJAvq8QJKlEVCZng7X8Kbh1PMJ29jx2mvpa4JNrFHSdRNdFsPb0
	Xc8LjG9sGPdFJ/zhD0NAazVcfrITZmrNbypBc5vCp5Oc0DXJsICr/aMzr04jX5/qIAAdV1
	urf54TXYOT9udkkE8Uae+JA/ILtwM04=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-407-c_M9rrfJPwqu9fp-h7lbSA-1; Wed, 20 Dec 2023 11:10:01 -0500
X-MC-Unique: c_M9rrfJPwqu9fp-h7lbSA-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-5deda822167so80033167b3.1
        for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 08:10:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703088601; x=1703693401;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YBF/2A/nktRQkyV9wK9FTmKMlXm8fHaSo0cgylBofKE=;
        b=ZNKiJX/7ga6XZx8G2IIWX/XVbjctFCJlaD6qLhx9fSZCUSbB+CSC+vu/Dajq9UObrz
         BaECFpkq9+Sd05RKT+EQ+/uo+j3RlNaz33ZZtozXFH4N/x7J3m3fRCD/BHO5N/TgEBHt
         3FojPWKI5huO4bhhVUcpo8l1Qjmvclh/4t0yVXqtw/tXJb5iKdK1wCU+pEqICspLBvH1
         zFAHb9AgLwu/xNjjiodX8NpCXDgD7qxtpUV/a+To28jiRfAyEk5fSRW1HcNtaOzNT4FY
         mH/e6YrciAGvR53NyANzV4HL42VRB/1CWBJ96dyBWUPoVphOwq7XZqzkkylRN4tN+GCV
         YK1Q==
X-Gm-Message-State: AOJu0YzrIhdQdak3CowPfYljmSaIS6D2ekXTl6a1ERP3AXhyGquf41OP
	qPBTjJCdX1mSitubZy8L7zKNpyXENHlASiKSAeH583n4UXjJxTlmi47cpiEZRD2wy/drZicgr5j
	WhA9+2pKCPhy36JF8ga3k6SOenWNg
X-Received: by 2002:a81:4ec9:0:b0:5e5:ebd3:b1dd with SMTP id c192-20020a814ec9000000b005e5ebd3b1ddmr4627326ywb.10.1703088601330;
        Wed, 20 Dec 2023 08:10:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE+IU3w6JnHUfVUtttpnXPZjgZ7nb7xBxPxfi9miRXjvISa+OseECRxvd3Zk1HEe8rGhYPjUps3bz6+ROD1cps=
X-Received: by 2002:a81:4ec9:0:b0:5e5:ebd3:b1dd with SMTP id
 c192-20020a814ec9000000b005e5ebd3b1ddmr4627306ywb.10.1703088601106; Wed, 20
 Dec 2023 08:10:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231219180858.120898-1-dtatulea@nvidia.com> <20231219180858.120898-3-dtatulea@nvidia.com>
In-Reply-To: <20231219180858.120898-3-dtatulea@nvidia.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Wed, 20 Dec 2023 17:09:24 +0100
Message-ID: <CAJaqyWeOJSne+qfj1pq_bgzML2Hc49MBCQm735fqrRThkeJAyQ@mail.gmail.com>
Subject: Re: [PATCH vhost v4 02/15] vdpa: Add VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND
 flag
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
> The virtio spec doesn't allow changing virtqueue addresses after
> DRIVER_OK. Some devices do support this operation when the device is
> suspended. The VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND flag
> advertises this support as a backend features.
>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Suggested-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> ---
>  include/uapi/linux/vhost_types.h | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhost_=
types.h
> index d7656908f730..aacd067afc89 100644
> --- a/include/uapi/linux/vhost_types.h
> +++ b/include/uapi/linux/vhost_types.h
> @@ -192,5 +192,9 @@ struct vhost_vdpa_iova_range {
>  #define VHOST_BACKEND_F_DESC_ASID    0x7
>  /* IOTLB don't flush memory mapping across device reset */
>  #define VHOST_BACKEND_F_IOTLB_PERSIST  0x8
> +/* Device supports changing virtqueue addresses when device is suspended
> + * and is in state DRIVER_OK.
> + */
> +#define VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND  0x9
>

If we go by feature flag,

Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

>  #endif
> --
> 2.43.0
>


