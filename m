Return-Path: <kvm+bounces-4905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F20BF819786
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 05:06:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F5151C25102
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 04:06:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2D3010A1E;
	Wed, 20 Dec 2023 04:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MQHVrLdi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43DDCA41
	for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 04:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703045163;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=od6b06R9di1R/4iYBvwR9HNhISJUCGr44+UWNtXtRoc=;
	b=MQHVrLdiTnYXrw0TsTvqsw7g/+M4/YK//6u5ghkO6uJMkdtWueDTmWOVcYC0+84OnsPtBr
	CRJlyc3k2ErmsGfxbmvLCd7QsgMEhdsvofSjae84SHOrSeW3rffOP2KvbOaJHVkAiaklLC
	s+SaepToKj1tfMOCkQaWM2rvIRnM5Mo=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-439-AgpXBAXiNJKdRIqynw3OJA-1; Tue, 19 Dec 2023 23:06:01 -0500
X-MC-Unique: AgpXBAXiNJKdRIqynw3OJA-1
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-3b9d731fd1bso6594246b6e.1
        for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 20:06:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703045161; x=1703649961;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=od6b06R9di1R/4iYBvwR9HNhISJUCGr44+UWNtXtRoc=;
        b=OSf9Cg1NQiujZkD2b39yEcBeQSE5H9tP2xiG8ahMbjhN6kTjyXkiSfBmzhlbyL2HOs
         bzfI3Zl6zaNIqNPGWXgBoNUvNMjuiSaDmExVo22rKyUQCBHKJdrJV5bmOrDj+brtbnCh
         Xa/TzCFbybqF6/u4Nwf299tFqpbhzGpd/1TyCt/q5GdosfJW1nUMBTVnsrlA1Ox4LMN9
         dK+zyG9rIg1eCbNMQPbtRuQJbYeGBQhjKOtsAnPFnGvm4p+IjkDqIhvWtpTAQ+3/6s3H
         MlgBxrDn5OnuJvWZwvVoaokqMYuB6klYqanUgE+8XVXEVdlnwKjCnDRTzQSZNPbYEJVK
         aKTg==
X-Gm-Message-State: AOJu0Yys7PE4IDLVW8gyZgviHrR6EVTQoB0XBdHPMn2Od324HA1J80Ef
	xqLU+4qD8s+0z/xbe+1lTLu+xZ+wIzgiZ8MWFdBDq5CkuKtVVBVA0dcDfg0pduLFRwO5allNrEb
	ABaphbCVR1wmEdqd/Uw50x9rKlVKS
X-Received: by 2002:a05:6808:2022:b0:3bb:5f46:fc92 with SMTP id q34-20020a056808202200b003bb5f46fc92mr2662219oiw.32.1703045161219;
        Tue, 19 Dec 2023 20:06:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF7bNzJNP++sajjpkBSvZbj8fBXUFR3JlD7KqetxxL+4FHj3ZcsomiOKSot/CNkMhv11b5giD9zm5wB0LFKSTg=
X-Received: by 2002:a05:6808:2022:b0:3bb:5f46:fc92 with SMTP id
 q34-20020a056808202200b003bb5f46fc92mr2662209oiw.32.1703045161039; Tue, 19
 Dec 2023 20:06:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231219180858.120898-1-dtatulea@nvidia.com> <20231219180858.120898-3-dtatulea@nvidia.com>
 <CACGkMEv7xQkZYJAgAUK6C3oUrZ9vuUJdTKRzihXcNPb-iWdpJw@mail.gmail.com>
In-Reply-To: <CACGkMEv7xQkZYJAgAUK6C3oUrZ9vuUJdTKRzihXcNPb-iWdpJw@mail.gmail.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 20 Dec 2023 12:05:50 +0800
Message-ID: <CACGkMEsaaDGi63__YrvsTC1HqgTaEWHvGokK1bJS5+m1XYM-6w@mail.gmail.com>
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

On Wed, Dec 20, 2023 at 11:46=E2=80=AFAM Jason Wang <jasowang@redhat.com> w=
rote:
>
> On Wed, Dec 20, 2023 at 2:09=E2=80=AFAM Dragos Tatulea <dtatulea@nvidia.c=
om> wrote:
> >
> > The virtio spec doesn't allow changing virtqueue addresses after
> > DRIVER_OK. Some devices do support this operation when the device is
> > suspended. The VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND flag
> > advertises this support as a backend features.
>
> There's an ongoing effort in virtio spec to introduce the suspend state.
>
> So I wonder if it's better to just allow such behaviour?

Actually I mean, allow drivers to modify the parameters during suspend
without a new feature.

Thanks

>
> Thanks
>
>


