Return-Path: <kvm+bounces-5067-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BDD581B57C
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 13:09:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C873428514B
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 12:09:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E0EB6E5AA;
	Thu, 21 Dec 2023 12:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P16zovW2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329AD6E2B3
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 12:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703160547;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u2zddOQ1qeYa0ve/5dlXq/cgaEaRPGUue1VUy/g3vDE=;
	b=P16zovW23++TbKf9GYzsdnwGBdVIZT0rtU5lkxXzHqy1IO8Qun2IRYgxL4j7X1ZaiSv2PC
	bkWxfPxLZm9PCmaJkp7v7eAQ7BGbOKiT57K7+w/daUVV5Ss55w8CMBX54MkaeALLR6NXJA
	BdItMIiAxIEIJVPpMlDu4ZxnqbBzdr4=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-226-xr-n7I2YP_i5QIRd3CIaKw-1; Thu, 21 Dec 2023 07:09:05 -0500
X-MC-Unique: xr-n7I2YP_i5QIRd3CIaKw-1
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-5e76b663ef3so13227767b3.1
        for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 04:09:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703160545; x=1703765345;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u2zddOQ1qeYa0ve/5dlXq/cgaEaRPGUue1VUy/g3vDE=;
        b=RMDc79g0QbAsD5fTi+X73GsyD0dPd6J9CeTVfGfk7VnVhgSv6pyk4cxYqm0mo4SPiX
         nwiD4w2WYXPAVqqAPMeT3OZRfvbnOZhz1fs/IaiTE8fiview0eiiwIDvLZtIMuYCGB+u
         7UQwo08PuLu5XbZpXPEEc5xJHO/8CxBosTTP4ndgwc/7So3EvfHYW6PtJeC36Fdkffis
         KGWYApiZuD6KeQwvpqjKzm5csOBPim0L21C6Ia6+zReuPJ7vsZ+z1A+O5XbLhLVde2nU
         Q80sFhRwLu3knDznFhYTJijtbbNxNPYvcNl09DAmwA202r6Iy84ErLwCSpDb2aLYAChY
         RtzQ==
X-Gm-Message-State: AOJu0YwiYWoWklaQSk0PqNHqOvATyvkzDAwJVknDGMnQLkd4hZdIHzoO
	FVCirdsxBCo9XB6IMSJobkp79Av3qPtWPtQfAe8/O1Pth7AKoc7q7qJ8sw7znfaEfmvU92K9cTL
	kUktUGyXR8DCrmfHtsF++Lf9C/Kmp
X-Received: by 2002:a0d:eacc:0:b0:5e8:d7b2:cdcd with SMTP id t195-20020a0deacc000000b005e8d7b2cdcdmr1029740ywe.48.1703160544744;
        Thu, 21 Dec 2023 04:09:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE+wUNNsjF8vEWQGGMpBGoBAUApRdPfu53AYtmvTV2W30g5Q9Sc3RlTNwEHeRRatnR6DBa23ya1wKjB1B+7qt4=
X-Received: by 2002:a0d:eacc:0:b0:5e8:d7b2:cdcd with SMTP id
 t195-20020a0deacc000000b005e8d7b2cdcdmr1029718ywe.48.1703160543744; Thu, 21
 Dec 2023 04:09:03 -0800 (PST)
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
 <CAJaqyWeBVVcTZEzZK=63Ymk85wnRFd+_wK56UfEHNXBH-qy1Zg@mail.gmail.com> <70adc734331c1289dceb3bcdc991f3da7e4db2f0.camel@nvidia.com>
In-Reply-To: <70adc734331c1289dceb3bcdc991f3da7e4db2f0.camel@nvidia.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Thu, 21 Dec 2023 13:08:27 +0100
Message-ID: <CAJaqyWeUHiZXMFkNBpinCsJAXojtPkGz+SjzUNDPx5W=qqON1w@mail.gmail.com>
Subject: Re: [PATCH vhost v4 02/15] vdpa: Add VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND
 flag
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: "jasowang@redhat.com" <jasowang@redhat.com>, 
	"xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>, Parav Pandit <parav@nvidia.com>, 
	"virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, Gal Pressman <gal@nvidia.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"si-wei.liu@oracle.com" <si-wei.liu@oracle.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"mst@redhat.com" <mst@redhat.com>, Saeed Mahameed <saeedm@nvidia.com>, "leon@kernel.org" <leon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 21, 2023 at 12:52=E2=80=AFPM Dragos Tatulea <dtatulea@nvidia.co=
m> wrote:
>
> On Thu, 2023-12-21 at 08:46 +0100, Eugenio Perez Martin wrote:
> > On Thu, Dec 21, 2023 at 3:03=E2=80=AFAM Jason Wang <jasowang@redhat.com=
> wrote:
> > >
> > > On Wed, Dec 20, 2023 at 9:32=E2=80=AFPM Eugenio Perez Martin
> > > <eperezma@redhat.com> wrote:
> > > >
> > > > On Wed, Dec 20, 2023 at 5:06=E2=80=AFAM Jason Wang <jasowang@redhat=
.com> wrote:
> > > > >
> > > > > On Wed, Dec 20, 2023 at 11:46=E2=80=AFAM Jason Wang <jasowang@red=
hat.com> wrote:
> > > > > >
> > > > > > On Wed, Dec 20, 2023 at 2:09=E2=80=AFAM Dragos Tatulea <dtatule=
a@nvidia.com> wrote:
> > > > > > >
> > > > > > > The virtio spec doesn't allow changing virtqueue addresses af=
ter
> > > > > > > DRIVER_OK. Some devices do support this operation when the de=
vice is
> > > > > > > suspended. The VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND =
flag
> > > > > > > advertises this support as a backend features.
> > > > > >
> > > > > > There's an ongoing effort in virtio spec to introduce the suspe=
nd state.
> > > > > >
> > > > > > So I wonder if it's better to just allow such behaviour?
> > > > >
> > > > > Actually I mean, allow drivers to modify the parameters during su=
spend
> > > > > without a new feature.
> > > > >
> > > >
> > > > That would be ideal, but how do userland checks if it can suspend +
> > > > change properties + resume?
> > >
> > > As discussed, it looks to me the only device that supports suspend is
> > > simulator and it supports change properties.
> > >
> > > E.g:
> > >
> > > static int vdpasim_set_vq_address(struct vdpa_device *vdpa, u16 idx,
> > >                                   u64 desc_area, u64 driver_area,
> > >                                   u64 device_area)
> > > {
> > >         struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
> > >         struct vdpasim_virtqueue *vq =3D &vdpasim->vqs[idx];
> > >
> > >         vq->desc_addr =3D desc_area;
> > >         vq->driver_addr =3D driver_area;
> > >         vq->device_addr =3D device_area;
> > >
> > >         return 0;
> > > }
> > >
> >
> > So in the current kernel master it is valid to set a different vq
> > address while the device is suspended in vdpa_sim. But it is not valid
> > in mlx5, as the FW will not be updated in resume (Dragos, please
> > correct me if I'm wrong). Both of them return success.
> >
> In the current state, there is no resume. HW Virtqueues will just get re-=
created
> with the new address.
>

Oh, then all of this is effectively transparent to the userspace
except for the time it takes?

In that case you're right, we don't need feature flags. But I think it
would be great to also move the error return in case userspace tries
to modify vq parameters out of suspend state.

Thanks!


> > How can we know in the destination QEMU if it is valid to suspend &
> > set address? Should we handle this as a bugfix and backport the
> > change?
> >
> > > >
> > > > The only way that comes to my mind is to make sure all parents retu=
rn
> > > > error if userland tries to do it, and then fallback in userland.
> > >
> > > Yes.
> > >
> > > > I'm
> > > > ok with that, but I'm not sure if the current master & previous ker=
nel
> > > > has a coherent behavior. Do they return error? Or return success
> > > > without changing address / vq state?
> > >
> > > We probably don't need to worry too much here, as e.g set_vq_address
> > > could fail even without suspend (just at uAPI level).
> > >
> >
> > I don't get this, sorry. I rephrased my point with an example earlier
> > in the mail.
> >
>


