Return-Path: <kvm+bounces-4982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE0E381AFC5
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 08:47:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B4471C232E8
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 07:47:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED177156F7;
	Thu, 21 Dec 2023 07:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WAQqCzvq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB67154AC
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 07:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703144833;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PlcV0Wl9P/jGyxXi9Ck909fZjHTENS6mZGvZmebR75E=;
	b=WAQqCzvqYqSg5dxbPn0SlabbzYmcu2i3Uh1eF4t5vzRKoGTDS8oU+qzG0GUCJu4E5hEr3P
	wR9SlruRuZhPg64NmPRxgjKgRlT/c+1S3srr8cgzHDg2UkhlYNgIyTavt9eKY5d7s2Su6P
	ZCJG1oXgDEPYxYeFgLL8OtVjDd2Tvzc=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-LamSONHIMd2XWuQH32ovzg-1; Thu, 21 Dec 2023 02:47:11 -0500
X-MC-Unique: LamSONHIMd2XWuQH32ovzg-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-5e7547e98f1so17787927b3.1
        for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 23:47:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703144831; x=1703749631;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PlcV0Wl9P/jGyxXi9Ck909fZjHTENS6mZGvZmebR75E=;
        b=t30J9Q3yiohJ0UM0RDwpK82jcq3GZdR3K4ovMffyC+xLJadnPOzljUnJg1ccuQRVG0
         46uNorbw0L3YEs1greyHJDEDFvHtw8pmtEfa+NEYvfJ2Ew2nJZiEYsUWtZbmcZHd1lHX
         DLybdCnwByivLQj9vbqQ2iOF4Z/CCDI0ydSkqYDBjritAY8Y7ZFFBJYX86qEO1fyBDJV
         FuFubbkeKcS/kk23f2vtjd+ticFthvG4wg1m1wnLGQsKQjOIkqOsYmhAdHSbuiulwsvZ
         7zMarVhKUY17Bh/EYDQayuEhK3h7LC35sw/K3VMuut64tcOnC2loRK/XOzN1lcEkSCez
         cWNg==
X-Gm-Message-State: AOJu0YzlqX91kCmxJ4OXo1KW7twlG/fFEQdGTBfPBcSz8/MLnBCl6OhW
	hpLuOdLOSW3pDW+Vyha5bhaDx/397f4fL2QNDvqzG891tA0F5fFBJy1/vLcyPl/Gh+KqiVAJRsw
	VfWV5A7A/t22opZhngzlYFYwotbvCjbhg80iy
X-Received: by 2002:a0d:c884:0:b0:5e4:f37f:77bf with SMTP id k126-20020a0dc884000000b005e4f37f77bfmr137777ywd.44.1703144831321;
        Wed, 20 Dec 2023 23:47:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG4raem6zvLQ2SqFeGLOE9UsK5JmzVgNr2wDScKhZAihi30XayLStBJINxqev0P4dXtn5/fl8IbWI0WfvmYdcU=
X-Received: by 2002:a0d:c884:0:b0:5e4:f37f:77bf with SMTP id
 k126-20020a0dc884000000b005e4f37f77bfmr137764ywd.44.1703144831077; Wed, 20
 Dec 2023 23:47:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231219180858.120898-1-dtatulea@nvidia.com> <20231219180858.120898-3-dtatulea@nvidia.com>
 <CACGkMEv7xQkZYJAgAUK6C3oUrZ9vuUJdTKRzihXcNPb-iWdpJw@mail.gmail.com>
 <CACGkMEsaaDGi63__YrvsTC1HqgTaEWHvGokK1bJS5+m1XYM-6w@mail.gmail.com>
 <CAJaqyWdoaj8a7q1KrGqWmkYvAw_R_p0utcWvDvkyVm1nUOAxrA@mail.gmail.com> <CACGkMEuM7bXxsxHUs_SodiDQ2+akrLqqzWZBJSZEcnMASUkb+g@mail.gmail.com>
In-Reply-To: <CACGkMEuM7bXxsxHUs_SodiDQ2+akrLqqzWZBJSZEcnMASUkb+g@mail.gmail.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Thu, 21 Dec 2023 08:46:35 +0100
Message-ID: <CAJaqyWeBVVcTZEzZK=63Ymk85wnRFd+_wK56UfEHNXBH-qy1Zg@mail.gmail.com>
Subject: Re: [PATCH vhost v4 02/15] vdpa: Add VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND
 flag
To: Jason Wang <jasowang@redhat.com>
Cc: Dragos Tatulea <dtatulea@nvidia.com>, "Michael S . Tsirkin" <mst@redhat.com>, 
	Si-Wei Liu <si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Leon Romanovsky <leon@kernel.org>, virtualization@lists.linux-foundation.org, 
	Gal Pressman <gal@nvidia.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Parav Pandit <parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 21, 2023 at 3:03=E2=80=AFAM Jason Wang <jasowang@redhat.com> wr=
ote:
>
> On Wed, Dec 20, 2023 at 9:32=E2=80=AFPM Eugenio Perez Martin
> <eperezma@redhat.com> wrote:
> >
> > On Wed, Dec 20, 2023 at 5:06=E2=80=AFAM Jason Wang <jasowang@redhat.com=
> wrote:
> > >
> > > On Wed, Dec 20, 2023 at 11:46=E2=80=AFAM Jason Wang <jasowang@redhat.=
com> wrote:
> > > >
> > > > On Wed, Dec 20, 2023 at 2:09=E2=80=AFAM Dragos Tatulea <dtatulea@nv=
idia.com> wrote:
> > > > >
> > > > > The virtio spec doesn't allow changing virtqueue addresses after
> > > > > DRIVER_OK. Some devices do support this operation when the device=
 is
> > > > > suspended. The VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND flag
> > > > > advertises this support as a backend features.
> > > >
> > > > There's an ongoing effort in virtio spec to introduce the suspend s=
tate.
> > > >
> > > > So I wonder if it's better to just allow such behaviour?
> > >
> > > Actually I mean, allow drivers to modify the parameters during suspen=
d
> > > without a new feature.
> > >
> >
> > That would be ideal, but how do userland checks if it can suspend +
> > change properties + resume?
>
> As discussed, it looks to me the only device that supports suspend is
> simulator and it supports change properties.
>
> E.g:
>
> static int vdpasim_set_vq_address(struct vdpa_device *vdpa, u16 idx,
>                                   u64 desc_area, u64 driver_area,
>                                   u64 device_area)
> {
>         struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
>         struct vdpasim_virtqueue *vq =3D &vdpasim->vqs[idx];
>
>         vq->desc_addr =3D desc_area;
>         vq->driver_addr =3D driver_area;
>         vq->device_addr =3D device_area;
>
>         return 0;
> }
>

So in the current kernel master it is valid to set a different vq
address while the device is suspended in vdpa_sim. But it is not valid
in mlx5, as the FW will not be updated in resume (Dragos, please
correct me if I'm wrong). Both of them return success.

How can we know in the destination QEMU if it is valid to suspend &
set address? Should we handle this as a bugfix and backport the
change?

> >
> > The only way that comes to my mind is to make sure all parents return
> > error if userland tries to do it, and then fallback in userland.
>
> Yes.
>
> > I'm
> > ok with that, but I'm not sure if the current master & previous kernel
> > has a coherent behavior. Do they return error? Or return success
> > without changing address / vq state?
>
> We probably don't need to worry too much here, as e.g set_vq_address
> could fail even without suspend (just at uAPI level).
>

I don't get this, sorry. I rephrased my point with an example earlier
in the mail.


