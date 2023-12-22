Return-Path: <kvm+bounces-5124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 468AF81C582
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 08:30:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6AB001C24F6D
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 07:30:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64CF19470;
	Fri, 22 Dec 2023 07:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JTP6EH1P"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED149449
	for <kvm@vger.kernel.org>; Fri, 22 Dec 2023 07:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703230241;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+EJav2ollk7Wrw6PZTSNsiC1bKhoPeUSKA1iI5tWpbw=;
	b=JTP6EH1PR3HggFBzhimqGJX4mGVhDB2UgtloU0cFcmfTtDuMvoXOPQSaMarmiS4a8EtQoG
	Q6HpVltlP5ov/njaJ66t4A4dnwd9sZc6KIlh9ZwVH7HYwKTK7C12zWSW2jRJ58SVS9ivSW
	MLPWcdapnXKs/D8rzLje6QKm+01YHQ8=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-425-Ouvu8ffZPM2OnA46DiNgfQ-1; Fri, 22 Dec 2023 02:30:40 -0500
X-MC-Unique: Ouvu8ffZPM2OnA46DiNgfQ-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-5e73bd9079eso30563467b3.2
        for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 23:30:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703230239; x=1703835039;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+EJav2ollk7Wrw6PZTSNsiC1bKhoPeUSKA1iI5tWpbw=;
        b=No+xwJixK4wHfI90a+Hu5baMBzCaj+4ff1eDiN28toDL4PssJ9TxX2NeMFslhrxL+B
         ZGlWezRaggQJeo/gP9x4gx8DVA7RN+fbYinInIqeFG4z0+eSz9mVgYcNGbDqnHOWAOMw
         jgLNaJ9XqeJfX0PYpYI8UDcLhVRlt0BR5NpvJUg+l0SGRWTJLIcazbqsKA9/+KCZU8s3
         agI90HLkeYKmZxaG9wzMWpb5DQya5Mk1iFP+cqmpGs/F6TGTXmwt9TV1IHEbyAEuJ/ke
         +uW6+8F7wDL818hDP7q2bGMFxHFMGKzhMt60ov18qCthfZMofYIwlYG3v2zfmJ3DCMyY
         YOoQ==
X-Gm-Message-State: AOJu0Yy4n5kdmDGHjCVKOtYOw6K9YciKL+hi5nk+yd63arVq0TaRASWO
	mi4N6zDmKS8aL0x2onua8vshk1uNSS0Oa95/YAEiqax5dems2OFOHYNOq9m0tICNXEp+pKzhgIG
	rinxphvBABFYiL+ZMaC3JjpO1rF/8g97DhRCB
X-Received: by 2002:a25:9786:0:b0:db7:dacf:6fc7 with SMTP id i6-20020a259786000000b00db7dacf6fc7mr646485ybo.79.1703230239519;
        Thu, 21 Dec 2023 23:30:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH8YItA8gFhGHjgXrx6o4QGUVdd4gv9Xd6JURZ6NcScKFP3OufVhDw9Bxyt1SO5CDJOyWsQvvIkZJ+uz6gfMjA=
X-Received: by 2002:a25:9786:0:b0:db7:dacf:6fc7 with SMTP id
 i6-20020a259786000000b00db7dacf6fc7mr646480ybo.79.1703230239234; Thu, 21 Dec
 2023 23:30:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231219180858.120898-1-dtatulea@nvidia.com> <20231219180858.120898-3-dtatulea@nvidia.com>
 <CACGkMEv7xQkZYJAgAUK6C3oUrZ9vuUJdTKRzihXcNPb-iWdpJw@mail.gmail.com>
 <CACGkMEsaaDGi63__YrvsTC1HqgTaEWHvGokK1bJS5+m1XYM-6w@mail.gmail.com>
 <CAJaqyWdoaj8a7q1KrGqWmkYvAw_R_p0utcWvDvkyVm1nUOAxrA@mail.gmail.com>
 <CACGkMEuM7bXxsxHUs_SodiDQ2+akrLqqzWZBJSZEcnMASUkb+g@mail.gmail.com>
 <CAJaqyWeBVVcTZEzZK=63Ymk85wnRFd+_wK56UfEHNXBH-qy1Zg@mail.gmail.com>
 <70adc734331c1289dceb3bcdc991f3da7e4db2f0.camel@nvidia.com>
 <CAJaqyWeUHiZXMFkNBpinCsJAXojtPkGz+SjzUNDPx5W=qqON1w@mail.gmail.com>
 <c03eb2bb3ad76e28be2bb9b9e4dee4c3bc062ea7.camel@nvidia.com>
 <CAJaqyWevZX5TKpaLiJwu2nD7PHFsHg+TEZ=iPdWvrH4jyPV+cA@mail.gmail.com> <17abeefd02c843cddf64efbeadde49ad15c365a1.camel@nvidia.com>
In-Reply-To: <17abeefd02c843cddf64efbeadde49ad15c365a1.camel@nvidia.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Fri, 22 Dec 2023 08:30:03 +0100
Message-ID: <CAJaqyWewQgCuZahEzd8ff8tPP=YLUkitEoxTK4GjC-Cd45hj3g@mail.gmail.com>
Subject: Re: [PATCH vhost v4 02/15] vdpa: Add VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND
 flag
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: "xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>, Parav Pandit <parav@nvidia.com>, 
	Gal Pressman <gal@nvidia.com>, 
	"virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"si-wei.liu@oracle.com" <si-wei.liu@oracle.com>, "jasowang@redhat.com" <jasowang@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, 
	"mst@redhat.com" <mst@redhat.com>, "leon@kernel.org" <leon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 21, 2023 at 4:07=E2=80=AFPM Dragos Tatulea <dtatulea@nvidia.com=
> wrote:
>
> On Thu, 2023-12-21 at 15:55 +0100, Eugenio Perez Martin wrote:
> > On Thu, Dec 21, 2023 at 3:38=E2=80=AFPM Dragos Tatulea <dtatulea@nvidia=
.com> wrote:
> > >
> > > On Thu, 2023-12-21 at 13:08 +0100, Eugenio Perez Martin wrote:
> > > > On Thu, Dec 21, 2023 at 12:52=E2=80=AFPM Dragos Tatulea <dtatulea@n=
vidia.com> wrote:
> > > > >
> > > > > On Thu, 2023-12-21 at 08:46 +0100, Eugenio Perez Martin wrote:
> > > > > > On Thu, Dec 21, 2023 at 3:03=E2=80=AFAM Jason Wang <jasowang@re=
dhat.com> wrote:
> > > > > > >
> > > > > > > On Wed, Dec 20, 2023 at 9:32=E2=80=AFPM Eugenio Perez Martin
> > > > > > > <eperezma@redhat.com> wrote:
> > > > > > > >
> > > > > > > > On Wed, Dec 20, 2023 at 5:06=E2=80=AFAM Jason Wang <jasowan=
g@redhat.com> wrote:
> > > > > > > > >
> > > > > > > > > On Wed, Dec 20, 2023 at 11:46=E2=80=AFAM Jason Wang <jaso=
wang@redhat.com> wrote:
> > > > > > > > > >
> > > > > > > > > > On Wed, Dec 20, 2023 at 2:09=E2=80=AFAM Dragos Tatulea =
<dtatulea@nvidia.com> wrote:
> > > > > > > > > > >
> > > > > > > > > > > The virtio spec doesn't allow changing virtqueue addr=
esses after
> > > > > > > > > > > DRIVER_OK. Some devices do support this operation whe=
n the device is
> > > > > > > > > > > suspended. The VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_=
SUSPEND flag
> > > > > > > > > > > advertises this support as a backend features.
> > > > > > > > > >
> > > > > > > > > > There's an ongoing effort in virtio spec to introduce t=
he suspend state.
> > > > > > > > > >
> > > > > > > > > > So I wonder if it's better to just allow such behaviour=
?
> > > > > > > > >
> > > > > > > > > Actually I mean, allow drivers to modify the parameters d=
uring suspend
> > > > > > > > > without a new feature.
> > > > > > > > >
> > > > > > > >
> > > > > > > > That would be ideal, but how do userland checks if it can s=
uspend +
> > > > > > > > change properties + resume?
> > > > > > >
> > > > > > > As discussed, it looks to me the only device that supports su=
spend is
> > > > > > > simulator and it supports change properties.
> > > > > > >
> > > > > > > E.g:
> > > > > > >
> > > > > > > static int vdpasim_set_vq_address(struct vdpa_device *vdpa, u=
16 idx,
> > > > > > >                                   u64 desc_area, u64 driver_a=
rea,
> > > > > > >                                   u64 device_area)
> > > > > > > {
> > > > > > >         struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
> > > > > > >         struct vdpasim_virtqueue *vq =3D &vdpasim->vqs[idx];
> > > > > > >
> > > > > > >         vq->desc_addr =3D desc_area;
> > > > > > >         vq->driver_addr =3D driver_area;
> > > > > > >         vq->device_addr =3D device_area;
> > > > > > >
> > > > > > >         return 0;
> > > > > > > }
> > > > > > >
> > > > > >
> > > > > > So in the current kernel master it is valid to set a different =
vq
> > > > > > address while the device is suspended in vdpa_sim. But it is no=
t valid
> > > > > > in mlx5, as the FW will not be updated in resume (Dragos, pleas=
e
> > > > > > correct me if I'm wrong). Both of them return success.
> > > > > >
> > > > > In the current state, there is no resume. HW Virtqueues will just=
 get re-created
> > > > > with the new address.
> > > > >
> > > >
> > > > Oh, then all of this is effectively transparent to the userspace
> > > > except for the time it takes?
> > > >
> > > Not quite: mlx5_vdpa_set_vq_address will save the vq address only on =
the SW vq
> > > representation. Only later will it will call into the FW to update th=
e FW. Later
> > > means:
> > > - On DRIVER_OK state, when the VQs get created.
> > > - On .set_map when the VQs get re-created (before this series) / upda=
ted (after
> > > this series)
> > > - On .resume (after this series).
> > >
> > > So if the .set_vq_address is called when the VQ is in DRIVER_OK but n=
ot
> > > suspended those addresses will be set later for later.
> > >
> >
> > Ouch, that is more in the line of my thoughts :(.
> >
> > > > In that case you're right, we don't need feature flags. But I think=
 it
> > > > would be great to also move the error return in case userspace trie=
s
> > > > to modify vq parameters out of suspend state.
> > > >
> > > On the driver side or on the core side?
> > >
> >
> > Core side.
> >
> Checking my understanding: instead of the feature flags there would be a =
check
> (for .set_vq_addr and .set_vq_state) to return an error if they are calle=
d under
> DRIVER_OK and not suspended state?
>

Yes, correct. Per Jason's message, it should be enough with two
independent series:
* Patches 6, 7 and 8 of this series, just checking for suspend state
and not feature flags.
* Your v2.

Thanks!

> > It does not have to be part of this series, I meant it can be proposed
> > in a separate series and applied before the parent driver one.
> >
> > > Thanks
> > > > Thanks!
> > > >
> > > >
> > > > > > How can we know in the destination QEMU if it is valid to suspe=
nd &
> > > > > > set address? Should we handle this as a bugfix and backport the
> > > > > > change?
> > > > > >
> > > > > > > >
> > > > > > > > The only way that comes to my mind is to make sure all pare=
nts return
> > > > > > > > error if userland tries to do it, and then fallback in user=
land.
> > > > > > >
> > > > > > > Yes.
> > > > > > >
> > > > > > > > I'm
> > > > > > > > ok with that, but I'm not sure if the current master & prev=
ious kernel
> > > > > > > > has a coherent behavior. Do they return error? Or return su=
ccess
> > > > > > > > without changing address / vq state?
> > > > > > >
> > > > > > > We probably don't need to worry too much here, as e.g set_vq_=
address
> > > > > > > could fail even without suspend (just at uAPI level).
> > > > > > >
> > > > > >
> > > > > > I don't get this, sorry. I rephrased my point with an example e=
arlier
> > > > > > in the mail.
> > > > > >
> > > > >
> > > >
> > >
> >
>


