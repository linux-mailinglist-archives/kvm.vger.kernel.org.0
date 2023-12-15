Return-Path: <kvm+bounces-4586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A2A56814F5E
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 19:00:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 17C7A1F2598F
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 18:00:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED8CA46430;
	Fri, 15 Dec 2023 17:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SQKk3Az0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F5945BEE
	for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 17:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702663051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h++U50hN+X/POmGBCeysUUq1JPcL9OMnDXCoOtDvh9U=;
	b=SQKk3Az0qQuRAbGazU6k2d7ERFdzOAX9RmvgS0q2x+0iNpWuT+HHmAIZpMvmrP7w1FRXBI
	19fMR6BxbB/e7tHlNDECNP30kNAIFeeGs/4nKn9Afvl/3BlsQlWJ+yatNkGuSBnavjVWpF
	vXb3XsNUCp3ut3eTu+BFNKvVuM/zK+M=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-159-G9uR5vErNzS1B91u6SnX0A-1; Fri, 15 Dec 2023 12:57:30 -0500
X-MC-Unique: G9uR5vErNzS1B91u6SnX0A-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-5e4c255846aso5316617b3.1
        for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 09:57:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702663049; x=1703267849;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h++U50hN+X/POmGBCeysUUq1JPcL9OMnDXCoOtDvh9U=;
        b=ggwGG2j4IjzNf+yzU5GJX+2GC0OKNhLWsQMGIivhEWTst+/DLHGZXWX+QnU46d0JjV
         0gQ0tfOn70Rl317SQL4X9XJV9VOYzVzGWy/tMg4kMbmxxHpbqDRYqPQ+BvWrOKDg7AER
         jPsCHbxCi3diVdWbXwnDCVeFXSLsZCze1ethUh+pXtMUjxK8wMABXFN/7vnxGF+Ugvz1
         6MzVYMKpTY+Ze2qzcJyUT0zcc+tyKsKsGZnfzcElU0ZlqDrLEe+Q8cRdqli8ePGXfLPz
         4QULwBpwpbS7bAIsc5FZP1aIkU4AvV69eWzfzWRMUIC85KYs+4rlx22NAOSppjckCo+v
         PATw==
X-Gm-Message-State: AOJu0YxG8njtgaTxyB3RNmA1WWLP71pfrBHZ0wUfnuRr+4i2SVwv0EOl
	ixdcLI8V7SlRtEH2A8P6mdSBqZzvH5HBKXAZ3GLB6ZEgvR2mTUe0Hlft+iALp34KgPaxPH6iusX
	g5cQiQLPgSMrsxzZ/s6tRY+qjNCAlX0vKmnZa8so=
X-Received: by 2002:a0d:f583:0:b0:5d7:1940:b382 with SMTP id e125-20020a0df583000000b005d71940b382mr11071050ywf.78.1702663049523;
        Fri, 15 Dec 2023 09:57:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF7430/+tU94/q04Uagk69EzjcMYfYTJ6BP+3d8bTzJ0ew3e/PuQ2dInXS8ckZQ38VdMkqUi/WeEisLFgIaWfo=
X-Received: by 2002:a0d:f583:0:b0:5d7:1940:b382 with SMTP id
 e125-20020a0df583000000b005d71940b382mr11071041ywf.78.1702663049216; Fri, 15
 Dec 2023 09:57:29 -0800 (PST)
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
 <9c387650e7c22118370fa0fe3588ee009ce56f11.camel@nvidia.com> <0bfb42ee1248b82eaedd88bdc9e97e83919f2405.camel@nvidia.com>
In-Reply-To: <0bfb42ee1248b82eaedd88bdc9e97e83919f2405.camel@nvidia.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Fri, 15 Dec 2023 18:56:53 +0100
Message-ID: <CAJaqyWdv5xAXp2jiAj=z+3+Bu+6=sXiE0HtOZrMSSZmvVsHeJw@mail.gmail.com>
Subject: Re: [PATCH vhost v2 4/8] vdpa/mlx5: Mark vq addrs for modification in
 hw vq
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: "xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>, Parav Pandit <parav@nvidia.com>, 
	Gal Pressman <gal@nvidia.com>, 
	"virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"si-wei.liu@oracle.com" <si-wei.liu@oracle.com>, "mst@redhat.com" <mst@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, 
	"jasowang@redhat.com" <jasowang@redhat.com>, "leon@kernel.org" <leon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 15, 2023 at 3:13=E2=80=AFPM Dragos Tatulea <dtatulea@nvidia.com=
> wrote:
>
> On Fri, 2023-12-15 at 12:35 +0000, Dragos Tatulea wrote:
> > On Thu, 2023-12-14 at 19:30 +0100, Eugenio Perez Martin wrote:
> > > On Thu, Dec 14, 2023 at 4:51=E2=80=AFPM Dragos Tatulea <dtatulea@nvid=
ia.com> wrote:
> > > >
> > > > On Thu, 2023-12-14 at 08:45 -0500, Michael S. Tsirkin wrote:
> > > > > On Thu, Dec 14, 2023 at 01:39:55PM +0000, Dragos Tatulea wrote:
> > > > > > On Tue, 2023-12-12 at 15:44 -0800, Si-Wei Liu wrote:
> > > > > > >
> > > > > > > On 12/12/2023 11:21 AM, Eugenio Perez Martin wrote:
> > > > > > > > On Tue, Dec 5, 2023 at 11:46=E2=80=AFAM Dragos Tatulea <dta=
tulea@nvidia.com> wrote:
> > > > > > > > > Addresses get set by .set_vq_address. hw vq addresses wil=
l be updated on
> > > > > > > > > next modify_virtqueue.
> > > > > > > > >
> > > > > > > > > Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> > > > > > > > > Reviewed-by: Gal Pressman <gal@nvidia.com>
> > > > > > > > > Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > > > > > > > I'm kind of ok with this patch and the next one about state=
, but I
> > > > > > > > didn't ack them in the previous series.
> > > > > > > >
> > > > > > > > My main concern is that it is not valid to change the vq ad=
dress after
> > > > > > > > DRIVER_OK in VirtIO, which vDPA follows. Only memory maps a=
re ok to
> > > > > > > > change at this moment. I'm not sure about vq state in vDPA,=
 but vhost
> > > > > > > > forbids changing it with an active backend.
> > > > > > > >
> > > > > > > > Suspend is not defined in VirtIO at this moment though, so =
maybe it is
> > > > > > > > ok to decide that all of these parameters may change during=
 suspend.
> > > > > > > > Maybe the best thing is to protect this with a vDPA feature=
 flag.
> > > > > > > I think protect with vDPA feature flag could work, while on t=
he other
> > > > > > > hand vDPA means vendor specific optimization is possible arou=
nd suspend
> > > > > > > and resume (in case it helps performance), which doesn't have=
 to be
> > > > > > > backed by virtio spec. Same applies to vhost user backend fea=
tures,
> > > > > > > variations there were not backed by spec either. Of course, w=
e should
> > > > > > > try best to make the default behavior backward compatible wit=
h
> > > > > > > virtio-based backend, but that circles back to no suspend def=
inition in
> > > > > > > the current virtio spec, for which I hope we don't cease deve=
lopment on
> > > > > > > vDPA indefinitely. After all, the virtio based vdap backend c=
an well
> > > > > > > define its own feature flag to describe (minor difference in)=
 the
> > > > > > > suspend behavior based on the later spec once it is formed in=
 future.
> > > > > > >
> > > > > > So what is the way forward here? From what I understand the opt=
ions are:
> > > > > >
> > > > > > 1) Add a vdpa feature flag for changing device properties while=
 suspended.
> > > > > >
> > > > > > 2) Drop these 2 patches from the series for now. Not sure if th=
is makes sense as
> > > > > > this. But then Si-Wei's qemu device suspend/resume poc [0] that=
 exercises this
> > > > > > code won't work anymore. This means the series would be less we=
ll tested.
> > > > > >
> > > > > > Are there other possible options? What do you think?
> > > > > >
> > > > > > [0] https://github.com/siwliu-kernel/qemu/tree/svq-resume-wip
> > > > >
> > > > > I am fine with either of these.
> > > > >
> > > > How about allowing the change only under the following conditions:
> > > >   vhost_vdpa_can_suspend && vhost_vdpa_can_resume &&
> > > > VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK is set
> > > >
> > > > ?
> > >
> > > I think the best option by far is 1, as there is no hint in the
> > > combination of these 3 indicating that you can change device
> > > properties in the suspended state.
> > >
> > Sure. Will respin a v3 without these two patches.
> >
> > Another series can implement option 2 and add these 2 patches on top.
> Hmm...I misunderstood your statement and sent a erroneus v3. You said tha=
t
> having a feature flag is the best option.
>
> Will add a feature flag in v4: is this similar to the
> VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK flag?
>

Right, it should be easy to return it from .get_backend_features op if
the FW returns that capability, isn't it?

> Thanks,
> Dragos
>
> > > > Thanks,
> > > > Dragos
> > > >
> > > > > > Thanks,
> > > > > > Dragos
> > > > > >
> > > > > > > Regards,
> > > > > > > -Siwei
> > > > > > >
> > > > > > >
> > > > > > >
> > > > > > > >
> > > > > > > > Jason, what do you think?
> > > > > > > >
> > > > > > > > Thanks!
> > > > > > > >
> > > > > > > > > ---
> > > > > > > > >   drivers/vdpa/mlx5/net/mlx5_vnet.c  | 9 +++++++++
> > > > > > > > >   include/linux/mlx5/mlx5_ifc_vdpa.h | 1 +
> > > > > > > > >   2 files changed, 10 insertions(+)
> > > > > > > > >
> > > > > > > > > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/=
vdpa/mlx5/net/mlx5_vnet.c
> > > > > > > > > index f8f088cced50..80e066de0866 100644
> > > > > > > > > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > > > > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > > > > @@ -1209,6 +1209,7 @@ static int modify_virtqueue(struct =
mlx5_vdpa_net *ndev,
> > > > > > > > >          bool state_change =3D false;
> > > > > > > > >          void *obj_context;
> > > > > > > > >          void *cmd_hdr;
> > > > > > > > > +       void *vq_ctx;
> > > > > > > > >          void *in;
> > > > > > > > >          int err;
> > > > > > > > >
> > > > > > > > > @@ -1230,6 +1231,7 @@ static int modify_virtqueue(struct =
mlx5_vdpa_net *ndev,
> > > > > > > > >          MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, uid, n=
dev->mvdev.res.uid);
> > > > > > > > >
> > > > > > > > >          obj_context =3D MLX5_ADDR_OF(modify_virtio_net_q=
_in, in, obj_context);
> > > > > > > > > +       vq_ctx =3D MLX5_ADDR_OF(virtio_net_q_object, obj_=
context, virtio_q_context);
> > > > > > > > >
> > > > > > > > >          if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MAS=
K_STATE) {
> > > > > > > > >                  if (!is_valid_state_change(mvq->fw_state=
, state, is_resumable(ndev))) {
> > > > > > > > > @@ -1241,6 +1243,12 @@ static int modify_virtqueue(struct=
 mlx5_vdpa_net *ndev,
> > > > > > > > >                  state_change =3D true;
> > > > > > > > >          }
> > > > > > > > >
> > > > > > > > > +       if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK=
_VIRTIO_Q_ADDRS) {
> > > > > > > > > +               MLX5_SET64(virtio_q, vq_ctx, desc_addr, m=
vq->desc_addr);
> > > > > > > > > +               MLX5_SET64(virtio_q, vq_ctx, used_addr, m=
vq->device_addr);
> > > > > > > > > +               MLX5_SET64(virtio_q, vq_ctx, available_ad=
dr, mvq->driver_addr);
> > > > > > > > > +       }
> > > > > > > > > +
> > > > > > > > >          MLX5_SET64(virtio_net_q_object, obj_context, mod=
ify_field_select, mvq->modified_fields);
> > > > > > > > >          err =3D mlx5_cmd_exec(ndev->mvdev.mdev, in, inle=
n, out, sizeof(out));
> > > > > > > > >          if (err)
> > > > > > > > > @@ -2202,6 +2210,7 @@ static int mlx5_vdpa_set_vq_address=
(struct vdpa_device *vdev, u16 idx, u64 desc_
> > > > > > > > >          mvq->desc_addr =3D desc_area;
> > > > > > > > >          mvq->device_addr =3D device_area;
> > > > > > > > >          mvq->driver_addr =3D driver_area;
> > > > > > > > > +       mvq->modified_fields |=3D MLX5_VIRTQ_MODIFY_MASK_=
VIRTIO_Q_ADDRS;
> > > > > > > > >          return 0;
> > > > > > > > >   }
> > > > > > > > >
> > > > > > > > > diff --git a/include/linux/mlx5/mlx5_ifc_vdpa.h b/include=
/linux/mlx5/mlx5_ifc_vdpa.h
> > > > > > > > > index b86d51a855f6..9594ac405740 100644
> > > > > > > > > --- a/include/linux/mlx5/mlx5_ifc_vdpa.h
> > > > > > > > > +++ b/include/linux/mlx5/mlx5_ifc_vdpa.h
> > > > > > > > > @@ -145,6 +145,7 @@ enum {
> > > > > > > > >          MLX5_VIRTQ_MODIFY_MASK_STATE                    =
=3D (u64)1 << 0,
> > > > > > > > >          MLX5_VIRTQ_MODIFY_MASK_DIRTY_BITMAP_PARAMS      =
=3D (u64)1 << 3,
> > > > > > > > >          MLX5_VIRTQ_MODIFY_MASK_DIRTY_BITMAP_DUMP_ENABLE =
=3D (u64)1 << 4,
> > > > > > > > > +       MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_ADDRS           =
=3D (u64)1 << 6,
> > > > > > > > >          MLX5_VIRTQ_MODIFY_MASK_DESC_GROUP_MKEY          =
=3D (u64)1 << 14,
> > > > > > > > >   };
> > > > > > > > >
> > > > > > > > > --
> > > > > > > > > 2.42.0
> > > > > > > > >
> > > > > > >
> > > > > >
> > > > >
> > > >
> > >
> >
>


