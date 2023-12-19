Return-Path: <kvm+bounces-4773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C4A4818239
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 08:26:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2D753B24A9D
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 07:26:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAAF38BE8;
	Tue, 19 Dec 2023 07:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fNDgjXbC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6BA13ADA
	for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 07:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702970720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UkWc107WslIsjYWu6NdM2GJXQDzS36cheHCrid7fhLY=;
	b=fNDgjXbCY21+DrbNPHVV0vxADHmRHjIvFtryCY11bYOzieWZR1ULynzpdWKWDfX/DoOStV
	rushMglNiQ9NwXtNfYiwb2/V9qGqaRnAOV0FB1SiGvbnvtajWWh7dv40I+SRbgSfnrKQa4
	uH7X8XQYFlarq3lzDLK1PBI77NnHoQ0=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-646-Df_JBa2dNzignaeyHhFIzg-1; Tue, 19 Dec 2023 02:25:08 -0500
X-MC-Unique: Df_JBa2dNzignaeyHhFIzg-1
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-5e49d5aa692so46962517b3.0
        for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 23:25:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702970707; x=1703575507;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UkWc107WslIsjYWu6NdM2GJXQDzS36cheHCrid7fhLY=;
        b=uoJV3MAEvLE3t8S+OH/FAHjUqcnjDCfMQlXpFHtKE1phCa5xWGjXtw6pk6QdHKwjBi
         F3fiaJqR+t86wXXk5GTQUTDR2sh02QrziG3oZJan1+pWklKIgsWAIt4x98qTdmxdtKrl
         f28r3Rc+/hMvZtFQt7nN/hX/vNmVM/Hc7RGgseRB8ewVkGRkJxp7TUjXZRRzeLwfZZm8
         r6ZSs4MKFkuqFafCLpdPXc+hbex3W4SCWua2mLkW/3rgl5B+1sb2YS5uLjK/ODfuLS9r
         mkfY5Ya5jXF2WgkNWsCUsnr2fZBnmTBjq+9JlHU+RcWvCL0VsxEYIH7sbU6O0KZNxlQd
         Swdw==
X-Gm-Message-State: AOJu0YyYN7Wdfef2lrK1bKYre8qj7PgdIkr29xJW/9kEjoTFqT0sJ7LP
	o0v6eG3C2Ia/5xKLR0+d9Kv3Nt7v64iLXbV6XnDMStHy7fXDajUGLyXHAjXBil4uRR0bL/ygT8R
	x7PcRn10nmGrxZtpe6JuidIMj0duE
X-Received: by 2002:a81:7104:0:b0:5d7:1940:53e6 with SMTP id m4-20020a817104000000b005d7194053e6mr14464208ywc.94.1702970707597;
        Mon, 18 Dec 2023 23:25:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH1LsE3GaGAqWsW9AqPXMjRpH1qS88ZdQ93CYYePfjGI0qB+i6GhOZQWF/TSQzNAhO+bQMFD+JCyc35qdgjV5A=
X-Received: by 2002:a81:7104:0:b0:5d7:1940:53e6 with SMTP id
 m4-20020a817104000000b005d7194053e6mr14464199ywc.94.1702970707330; Mon, 18
 Dec 2023 23:25:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231205104609.876194-1-dtatulea@nvidia.com> <20231205104609.876194-5-dtatulea@nvidia.com>
 <CAJaqyWeEY9LNTE8QEnJgLhgS7HiXr5gJEwwPBrC3RRBsAE4_7Q@mail.gmail.com>
 <27312106-07b9-4719-970c-b8e1aed7c4eb@oracle.com> <075cf7d1ada0ee4ee30d46b993a1fe21acfe9d92.camel@nvidia.com>
 <20231214084526-mutt-send-email-mst@kernel.org> <9a6465a3d6c8fde63643fbbdde60d5dd84b921d4.camel@nvidia.com>
 <CAJaqyWfF9eVehQ+wutMDdwYToMq=G1+War_7wANmnyuONj=18g@mail.gmail.com>
 <9c387650e7c22118370fa0fe3588ee009ce56f11.camel@nvidia.com>
 <0bfb42ee1248b82eaedd88bdc9e97e83919f2405.camel@nvidia.com>
 <CAJaqyWdv5xAXp2jiAj=z+3+Bu+6=sXiE0HtOZrMSSZmvVsHeJw@mail.gmail.com>
 <161c7e63d9c7f64afc959b1ea4a068ee2ddafa6c.camel@nvidia.com>
 <CAJaqyWf=ZtoSDGdhYrJdXMQuFvahzF5FtWkdShBmTGaewvQLrw@mail.gmail.com>
 <7c267819eb52f933251c118ba2d1ceb75043c5b2.camel@nvidia.com>
 <CAJaqyWccZJFdfww-_vmj4kJvJkWKFt_VBWmujfVTsFxHohkiZg@mail.gmail.com> <8fc4e1f156b075ec3f4c65acc1e10439f767bf81.camel@nvidia.com>
In-Reply-To: <8fc4e1f156b075ec3f4c65acc1e10439f767bf81.camel@nvidia.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Tue, 19 Dec 2023 08:24:31 +0100
Message-ID: <CAJaqyWe-nfb4F2PxTKz3R=fKf6EZzSbKSPm_SwdXjxQCybVmdQ@mail.gmail.com>
Subject: Re: [PATCH vhost v2 4/8] vdpa/mlx5: Mark vq addrs for modification in
 hw vq
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: "xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>, Parav Pandit <parav@nvidia.com>, 
	Gal Pressman <gal@nvidia.com>, 
	"virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"si-wei.liu@oracle.com" <si-wei.liu@oracle.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"mst@redhat.com" <mst@redhat.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	"jasowang@redhat.com" <jasowang@redhat.com>, "leon@kernel.org" <leon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 18, 2023 at 2:58=E2=80=AFPM Dragos Tatulea <dtatulea@nvidia.com=
> wrote:
>
> On Mon, 2023-12-18 at 13:06 +0100, Eugenio Perez Martin wrote:
> > On Mon, Dec 18, 2023 at 11:52=E2=80=AFAM Dragos Tatulea <dtatulea@nvidi=
a.com> wrote:
> > >
> > > On Mon, 2023-12-18 at 11:16 +0100, Eugenio Perez Martin wrote:
> > > > On Sat, Dec 16, 2023 at 12:03=E2=80=AFPM Dragos Tatulea <dtatulea@n=
vidia.com> wrote:
> > > > >
> > > > > On Fri, 2023-12-15 at 18:56 +0100, Eugenio Perez Martin wrote:
> > > > > > On Fri, Dec 15, 2023 at 3:13=E2=80=AFPM Dragos Tatulea <dtatule=
a@nvidia.com> wrote:
> > > > > > >
> > > > > > > On Fri, 2023-12-15 at 12:35 +0000, Dragos Tatulea wrote:
> > > > > > > > On Thu, 2023-12-14 at 19:30 +0100, Eugenio Perez Martin wro=
te:
> > > > > > > > > On Thu, Dec 14, 2023 at 4:51=E2=80=AFPM Dragos Tatulea <d=
tatulea@nvidia.com> wrote:
> > > > > > > > > >
> > > > > > > > > > On Thu, 2023-12-14 at 08:45 -0500, Michael S. Tsirkin w=
rote:
> > > > > > > > > > > On Thu, Dec 14, 2023 at 01:39:55PM +0000, Dragos Tatu=
lea wrote:
> > > > > > > > > > > > On Tue, 2023-12-12 at 15:44 -0800, Si-Wei Liu wrote=
:
> > > > > > > > > > > > >
> > > > > > > > > > > > > On 12/12/2023 11:21 AM, Eugenio Perez Martin wrot=
e:
> > > > > > > > > > > > > > On Tue, Dec 5, 2023 at 11:46=E2=80=AFAM Dragos =
Tatulea <dtatulea@nvidia.com> wrote:
> > > > > > > > > > > > > > > Addresses get set by .set_vq_address. hw vq a=
ddresses will be updated on
> > > > > > > > > > > > > > > next modify_virtqueue.
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > Signed-off-by: Dragos Tatulea <dtatulea@nvidi=
a.com>
> > > > > > > > > > > > > > > Reviewed-by: Gal Pressman <gal@nvidia.com>
> > > > > > > > > > > > > > > Acked-by: Eugenio P=C3=A9rez <eperezma@redhat=
.com>
> > > > > > > > > > > > > > I'm kind of ok with this patch and the next one=
 about state, but I
> > > > > > > > > > > > > > didn't ack them in the previous series.
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > My main concern is that it is not valid to chan=
ge the vq address after
> > > > > > > > > > > > > > DRIVER_OK in VirtIO, which vDPA follows. Only m=
emory maps are ok to
> > > > > > > > > > > > > > change at this moment. I'm not sure about vq st=
ate in vDPA, but vhost
> > > > > > > > > > > > > > forbids changing it with an active backend.
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > Suspend is not defined in VirtIO at this moment=
 though, so maybe it is
> > > > > > > > > > > > > > ok to decide that all of these parameters may c=
hange during suspend.
> > > > > > > > > > > > > > Maybe the best thing is to protect this with a =
vDPA feature flag.
> > > > > > > > > > > > > I think protect with vDPA feature flag could work=
, while on the other
> > > > > > > > > > > > > hand vDPA means vendor specific optimization is p=
ossible around suspend
> > > > > > > > > > > > > and resume (in case it helps performance), which =
doesn't have to be
> > > > > > > > > > > > > backed by virtio spec. Same applies to vhost user=
 backend features,
> > > > > > > > > > > > > variations there were not backed by spec either. =
Of course, we should
> > > > > > > > > > > > > try best to make the default behavior backward co=
mpatible with
> > > > > > > > > > > > > virtio-based backend, but that circles back to no=
 suspend definition in
> > > > > > > > > > > > > the current virtio spec, for which I hope we don'=
t cease development on
> > > > > > > > > > > > > vDPA indefinitely. After all, the virtio based vd=
ap backend can well
> > > > > > > > > > > > > define its own feature flag to describe (minor di=
fference in) the
> > > > > > > > > > > > > suspend behavior based on the later spec once it =
is formed in future.
> > > > > > > > > > > > >
> > > > > > > > > > > > So what is the way forward here? From what I unders=
tand the options are:
> > > > > > > > > > > >
> > > > > > > > > > > > 1) Add a vdpa feature flag for changing device prop=
erties while suspended.
> > > > > > > > > > > >
> > > > > > > > > > > > 2) Drop these 2 patches from the series for now. No=
t sure if this makes sense as
> > > > > > > > > > > > this. But then Si-Wei's qemu device suspend/resume =
poc [0] that exercises this
> > > > > > > > > > > > code won't work anymore. This means the series woul=
d be less well tested.
> > > > > > > > > > > >
> > > > > > > > > > > > Are there other possible options? What do you think=
?
> > > > > > > > > > > >
> > > > > > > > > > > > [0] https://github.com/siwliu-kernel/qemu/tree/svq-=
resume-wip
> > > > > > > > > > >
> > > > > > > > > > > I am fine with either of these.
> > > > > > > > > > >
> > > > > > > > > > How about allowing the change only under the following =
conditions:
> > > > > > > > > >   vhost_vdpa_can_suspend && vhost_vdpa_can_resume &&
> > > > > > > > > > VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK is set
> > > > > > > > > >
> > > > > > > > > > ?
> > > > > > > > >
> > > > > > > > > I think the best option by far is 1, as there is no hint =
in the
> > > > > > > > > combination of these 3 indicating that you can change dev=
ice
> > > > > > > > > properties in the suspended state.
> > > > > > > > >
> > > > > > > > Sure. Will respin a v3 without these two patches.
> > > > > > > >
> > > > > > > > Another series can implement option 2 and add these 2 patch=
es on top.
> > > > > > > Hmm...I misunderstood your statement and sent a erroneus v3. =
You said that
> > > > > > > having a feature flag is the best option.
> > > > > > >
> > > > > > > Will add a feature flag in v4: is this similar to the
> > > > > > > VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK flag?
> > > > > > >
> > > > > >
> > > > > > Right, it should be easy to return it from .get_backend_feature=
s op if
> > > > > > the FW returns that capability, isn't it?
> > > > > >
> > > > > Yes, that's easy. But I wonder if we need one feature bit for eac=
h type of
> > > > > change:
> > > > > - VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND
> > > > > - VHOST_BACKEND_F_CHANGEABLE_VQ_STATE_IN_SUSPEND
> > > > >
> > > >
> > > > I'd say yes. Although we could configure SVQ initial state in userl=
and
> > > > as different than 0 for this first step, it would be needed in the
> > > > long term.
> > > >
> > > > > Or would a big one VHOST_BACKEND_F_CAN_RECONFIG_VQ_IN_SUSPEND suf=
fice?
> > > > >
> > > >
> > > > I'd say "reconfig vq" is not valid as mlx driver doesn't allow
> > > > changing queue sizes, for example, isn't it?
> > > >
> > > Modifying the queue size for a vq is indeed not supported by the mlx =
device.
> > >
> > > > To define that it is
> > > > valid to change "all parameters" seems very confident.
> > > >
> > > Ack
> > >
> > > > > To me having individual feature bits makes sense. But it could al=
so takes too
> > > > > many bits if more changes are required.
> > > > >
> > > >
> > > > Yes, that's a good point. Maybe it is valid to define a subset of
> > > > features that can be changed., but I think it is way clearer to jus=
t
> > > > check for individual feature bits.
> > > >
> > > I will prepare extra patches with the 2 feature bits approach.
> > >
> > > Is it necessary to add checks in the vdpa core that block changing th=
ese
> > > properties if the state is driver ok and the device doesn't support t=
he feature?
> > >
> >
> > Yes, I think it is better to protect for changes in vdpa core.
> >
> Hmmm... there is no suspended state available. I would only add checks fo=
r the
> DRIVER_OK state of the device because adding a is_suspended state/op seem=
s out
> of scope for this series. Any thoughts?
>

I can develop it so you can include it in your series for sure, I will
send it ASAP.

Thanks!


