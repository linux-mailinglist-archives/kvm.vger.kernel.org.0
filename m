Return-Path: <kvm+bounces-4898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B198819746
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 04:47:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CEF151F26FB6
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 03:47:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0781511CBA;
	Wed, 20 Dec 2023 03:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SOLHtiW/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F42101CC
	for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 03:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703044025;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p/vQXoPNMgDSJ6FFgQIPBRO9b+agcxWACE4WdtqeGI8=;
	b=SOLHtiW/aP7pOxhD+tYsG7yLjN4EqLgNvceNG/wH6SWnP9Ghl0Po+htPCbo42bGWudIPn+
	hkSPBHOe6pCEoG3gPEOpOhsh6XkqBjlFdbBHbkm9VKQMAH/8lfeCbQxfsu/iWr+ebb+ijV
	qGxfnD3tXH3K39SrJw3CR44LqXqlY04=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-297-LYk03PiiOoqDsdNqaWsKJA-1; Tue, 19 Dec 2023 22:47:03 -0500
X-MC-Unique: LYk03PiiOoqDsdNqaWsKJA-1
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-6d9e45e03f6so6734568a34.0
        for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 19:47:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703044023; x=1703648823;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p/vQXoPNMgDSJ6FFgQIPBRO9b+agcxWACE4WdtqeGI8=;
        b=oHAqku5TkrYImuXxdZKfzLZkkN0jH/EmLnDFQsSw8p5avqW/g5/d0k/zIHd0wqpyLg
         J1Lqmbf9nxmTKZKT6ErEQIDJinEq2kTAiBWJs/2pg+7nItfI3sLC/7Xe6OVxWgsFeJvD
         xeYJ7cA7DqGtl4d0F+MYT9g/TqOhxXYOU039I+Ogkuqtu/8rsQpR7qkDjd6a2oj5a/K6
         LUXCTqTlG/1EWE4X6SsMRpG/tBG3Hv2wnguPgAvwAd+VmVy7zkqV8w9z4BgLihwO9uKW
         PI/FoXM0Qc/n95Q4IKmNvrQvdh9vDzHHUpWpwEEgX+UBxWflmR+P9/0KHfNlRFnAnJYS
         2iGg==
X-Gm-Message-State: AOJu0YwThf33W958rrsCzvT2yHcDYH65VM0jwX+BsRHLwpKh4TWpGe9/
	O8TqS1TJCBxhqv5nxJamnTV+RbN4m4I70BI4oAix5HkeMSmCXqK4vsvTT+0mkDQQxcH4zkvULhR
	73XZS9o8bqcHZyoz3YEh1Rqc86prf
X-Received: by 2002:a05:6830:314e:b0:6da:9f4:b8ae with SMTP id c14-20020a056830314e00b006da09f4b8aemr22021577ots.56.1703044023057;
        Tue, 19 Dec 2023 19:47:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHIs2Wjk/16EeCUCdnTE0IInvJAC3dqM8k2VmrDNOl462BjFxZNDUjZ28Ndoi8Vx4L+v6TQm+Hy7dwwcIb9+Pg=
X-Received: by 2002:a05:6830:314e:b0:6da:9f4:b8ae with SMTP id
 c14-20020a056830314e00b006da09f4b8aemr22021566ots.56.1703044022892; Tue, 19
 Dec 2023 19:47:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231219180858.120898-1-dtatulea@nvidia.com> <20231219180858.120898-3-dtatulea@nvidia.com>
In-Reply-To: <20231219180858.120898-3-dtatulea@nvidia.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 20 Dec 2023 11:46:50 +0800
Message-ID: <CACGkMEv7xQkZYJAgAUK6C3oUrZ9vuUJdTKRzihXcNPb-iWdpJw@mail.gmail.com>
Subject: Re: [PATCH vhost v4 02/15] vdpa: Add VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND
 flag
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
> The virtio spec doesn't allow changing virtqueue addresses after
> DRIVER_OK. Some devices do support this operation when the device is
> suspended. The VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND flag
> advertises this support as a backend features.

There's an ongoing effort in virtio spec to introduce the suspend state.

So I wonder if it's better to just allow such behaviour?

Thanks


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
>  #endif
> --
> 2.43.0
>


