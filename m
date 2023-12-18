Return-Path: <kvm+bounces-4717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 61B45816D5C
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 13:07:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 790AD1C235CD
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 12:07:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37F6A4B121;
	Mon, 18 Dec 2023 12:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JeVUB9KQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4778A47F55
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 12:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702901224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zEMbOunsOZdnNlCB5bkkoErrGKIn0cES6qjb3XUNkLk=;
	b=JeVUB9KQMlQIkfFz+UuVePV2DeotT+OzNbVy/1g869YMWvo/tIskcJOv70ZMuNZFQwehJF
	mMcxiTaL8HyATHC7VVdIA/7GN+XUyI7jsSbm3MOZkYc7zJhIh4KLTEdeNpKcCbEB20uIYh
	veLOG3YKQNKMVsH+P2YeW+rBhtpe+xc=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-468-uPVJtrygON6ezLElELSJkQ-1; Mon, 18 Dec 2023 07:07:02 -0500
X-MC-Unique: uPVJtrygON6ezLElELSJkQ-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-5d3911218b3so35566847b3.1
        for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 04:07:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702901222; x=1703506022;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zEMbOunsOZdnNlCB5bkkoErrGKIn0cES6qjb3XUNkLk=;
        b=sNedqV6p/KJdPP7bRGLZhLFkWnA0LOacyd+tAB9PvBjs0VXodlDSImi0sQMeUDg0CD
         shUjpMOTYKwVGtctwi4bxWSMstE0gy6zZd/hAs0dXR+M74/CGCycaipkKfLodyXpGJZ/
         KiYEGo0QtX1G0uqZi7jKMJnazQCvZt43hZDOwgwjXaugCW+Uhk/K+5ID02bGE5lL5IKK
         LQkMG0ibn/1C5jj9My4RRNF8d5XUe6tp00NgxB+1utgQw0qR2rUUSFQQVhBdSkyQk+fT
         r+kL4UqpMD0dfs6H5BEAOkslWA6djyeOzQljnMgkalgSI2O+4cWVJ6s+iRoSKC1HWNSt
         QS1w==
X-Gm-Message-State: AOJu0YwYG99T4dmUu9st03fptmiyZxk39e9+f4wejq5Jo14gP9dg57ol
	U5HmcjP/jE1B5Mu46P0VqZBP0zdjTgnFBsDLKqQvC3gKedxSMy0VPVuD13FEGqqVATaHz3VuECv
	mCavNVadMAc8ayh5gCapwkSmkPBeh
X-Received: by 2002:a0d:f9c2:0:b0:5da:1bb:b2ad with SMTP id j185-20020a0df9c2000000b005da01bbb2admr13475749ywf.48.1702901221794;
        Mon, 18 Dec 2023 04:07:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHLFff6iZ49MJmaXqVZ4W07VbAjBvnfDI5U7hKqa+5ceOHuZsxVSXHdef6QIKXoXxTSPws85Fx00nSPZhezE4I=
X-Received: by 2002:a0d:f9c2:0:b0:5da:1bb:b2ad with SMTP id
 j185-20020a0df9c2000000b005da01bbb2admr13475711ywf.48.1702901219947; Mon, 18
 Dec 2023 04:06:59 -0800 (PST)
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
 <CAJaqyWf=ZtoSDGdhYrJdXMQuFvahzF5FtWkdShBmTGaewvQLrw@mail.gmail.com> <7c267819eb52f933251c118ba2d1ceb75043c5b2.camel@nvidia.com>
In-Reply-To: <7c267819eb52f933251c118ba2d1ceb75043c5b2.camel@nvidia.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Mon, 18 Dec 2023 13:06:23 +0100
Message-ID: <CAJaqyWccZJFdfww-_vmj4kJvJkWKFt_VBWmujfVTsFxHohkiZg@mail.gmail.com>
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

On Mon, Dec 18, 2023 at 11:52=E2=80=AFAM Dragos Tatulea <dtatulea@nvidia.co=
m> wrote:
>
> On Mon, 2023-12-18 at 11:16 +0100, Eugenio Perez Martin wrote:
> > On Sat, Dec 16, 2023 at 12:03=E2=80=AFPM Dragos Tatulea <dtatulea@nvidi=
a.com> wrote:
> > >
> > > On Fri, 2023-12-15 at 18:56 +0100, Eugenio Perez Martin wrote:
> > > > On Fri, Dec 15, 2023 at 3:13=E2=80=AFPM Dragos Tatulea <dtatulea@nv=
idia.com> wrote:
> > > > >
> > > > > On Fri, 2023-12-15 at 12:35 +0000, Dragos Tatulea wrote:
> > > > > > On Thu, 2023-12-14 at 19:30 +0100, Eugenio Perez Martin wrote:
> > > > > > > On Thu, Dec 14, 2023 at 4:51=E2=80=AFPM Dragos Tatulea <dtatu=
lea@nvidia.com> wrote:
> > > > > > > >
> > > > > > > > On Thu, 2023-12-14 at 08:45 -0500, Michael S. Tsirkin wrote=
:
> > > > > > > > > On Thu, Dec 14, 2023 at 01:39:55PM +0000, Dragos Tatulea =
wrote:
> > > > > > > > > > On Tue, 2023-12-12 at 15:44 -0800, Si-Wei Liu wrote:
> > > > > > > > > > >
> > > > > > > > > > > On 12/12/2023 11:21 AM, Eugenio Perez Martin wrote:
> > > > > > > > > > > > On Tue, Dec 5, 2023 at 11:46=E2=80=AFAM Dragos Tatu=
lea <dtatulea@nvidia.com> wrote:
> > > > > > > > > > > > > Addresses get set by .set_vq_address. hw vq addre=
sses will be updated on
> > > > > > > > > > > > > next modify_virtqueue.
> > > > > > > > > > > > >
> > > > > > > > > > > > > Signed-off-by: Dragos Tatulea <dtatulea@nvidia.co=
m>
> > > > > > > > > > > > > Reviewed-by: Gal Pressman <gal@nvidia.com>
> > > > > > > > > > > > > Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com=
>
> > > > > > > > > > > > I'm kind of ok with this patch and the next one abo=
ut state, but I
> > > > > > > > > > > > didn't ack them in the previous series.
> > > > > > > > > > > >
> > > > > > > > > > > > My main concern is that it is not valid to change t=
he vq address after
> > > > > > > > > > > > DRIVER_OK in VirtIO, which vDPA follows. Only memor=
y maps are ok to
> > > > > > > > > > > > change at this moment. I'm not sure about vq state =
in vDPA, but vhost
> > > > > > > > > > > > forbids changing it with an active backend.
> > > > > > > > > > > >
> > > > > > > > > > > > Suspend is not defined in VirtIO at this moment tho=
ugh, so maybe it is
> > > > > > > > > > > > ok to decide that all of these parameters may chang=
e during suspend.
> > > > > > > > > > > > Maybe the best thing is to protect this with a vDPA=
 feature flag.
> > > > > > > > > > > I think protect with vDPA feature flag could work, wh=
ile on the other
> > > > > > > > > > > hand vDPA means vendor specific optimization is possi=
ble around suspend
> > > > > > > > > > > and resume (in case it helps performance), which does=
n't have to be
> > > > > > > > > > > backed by virtio spec. Same applies to vhost user bac=
kend features,
> > > > > > > > > > > variations there were not backed by spec either. Of c=
ourse, we should
> > > > > > > > > > > try best to make the default behavior backward compat=
ible with
> > > > > > > > > > > virtio-based backend, but that circles back to no sus=
pend definition in
> > > > > > > > > > > the current virtio spec, for which I hope we don't ce=
ase development on
> > > > > > > > > > > vDPA indefinitely. After all, the virtio based vdap b=
ackend can well
> > > > > > > > > > > define its own feature flag to describe (minor differ=
ence in) the
> > > > > > > > > > > suspend behavior based on the later spec once it is f=
ormed in future.
> > > > > > > > > > >
> > > > > > > > > > So what is the way forward here? From what I understand=
 the options are:
> > > > > > > > > >
> > > > > > > > > > 1) Add a vdpa feature flag for changing device properti=
es while suspended.
> > > > > > > > > >
> > > > > > > > > > 2) Drop these 2 patches from the series for now. Not su=
re if this makes sense as
> > > > > > > > > > this. But then Si-Wei's qemu device suspend/resume poc =
[0] that exercises this
> > > > > > > > > > code won't work anymore. This means the series would be=
 less well tested.
> > > > > > > > > >
> > > > > > > > > > Are there other possible options? What do you think?
> > > > > > > > > >
> > > > > > > > > > [0] https://github.com/siwliu-kernel/qemu/tree/svq-resu=
me-wip
> > > > > > > > >
> > > > > > > > > I am fine with either of these.
> > > > > > > > >
> > > > > > > > How about allowing the change only under the following cond=
itions:
> > > > > > > >   vhost_vdpa_can_suspend && vhost_vdpa_can_resume &&
> > > > > > > > VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK is set
> > > > > > > >
> > > > > > > > ?
> > > > > > >
> > > > > > > I think the best option by far is 1, as there is no hint in t=
he
> > > > > > > combination of these 3 indicating that you can change device
> > > > > > > properties in the suspended state.
> > > > > > >
> > > > > > Sure. Will respin a v3 without these two patches.
> > > > > >
> > > > > > Another series can implement option 2 and add these 2 patches o=
n top.
> > > > > Hmm...I misunderstood your statement and sent a erroneus v3. You =
said that
> > > > > having a feature flag is the best option.
> > > > >
> > > > > Will add a feature flag in v4: is this similar to the
> > > > > VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK flag?
> > > > >
> > > >
> > > > Right, it should be easy to return it from .get_backend_features op=
 if
> > > > the FW returns that capability, isn't it?
> > > >
> > > Yes, that's easy. But I wonder if we need one feature bit for each ty=
pe of
> > > change:
> > > - VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND
> > > - VHOST_BACKEND_F_CHANGEABLE_VQ_STATE_IN_SUSPEND
> > >
> >
> > I'd say yes. Although we could configure SVQ initial state in userland
> > as different than 0 for this first step, it would be needed in the
> > long term.
> >
> > > Or would a big one VHOST_BACKEND_F_CAN_RECONFIG_VQ_IN_SUSPEND suffice=
?
> > >
> >
> > I'd say "reconfig vq" is not valid as mlx driver doesn't allow
> > changing queue sizes, for example, isn't it?
> >
> Modifying the queue size for a vq is indeed not supported by the mlx devi=
ce.
>
> > To define that it is
> > valid to change "all parameters" seems very confident.
> >
> Ack
>
> > > To me having individual feature bits makes sense. But it could also t=
akes too
> > > many bits if more changes are required.
> > >
> >
> > Yes, that's a good point. Maybe it is valid to define a subset of
> > features that can be changed., but I think it is way clearer to just
> > check for individual feature bits.
> >
> I will prepare extra patches with the 2 feature bits approach.
>
> Is it necessary to add checks in the vdpa core that block changing these
> properties if the state is driver ok and the device doesn't support the f=
eature?
>

Yes, I think it is better to protect for changes in vdpa core.

> > > Thanks,
> > > Dragos
> > >
> > > > > Thanks,
> > > > > Dragos
> > > > >
> > > > > > > > Thanks,
> > > > > > > > Dragos
> > > > > > > >
> > > > > > > > > > Thanks,
> > > > > > > > > > Dragos
> > > > > > > > > >
> > > > > > > > > > > Regards,
> > > > > > > > > > > -Siwei
> > > > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > > Jason, what do you think?
> > > > > > > > > > > >
> > > > > > > > > > > > Thanks!
> > > > > > > > > > > >
> > > > > > > > > > > > > ---
> > > > > > > > > > > > >   drivers/vdpa/mlx5/net/mlx5_vnet.c  | 9 ++++++++=
+
> > > > > > > > > > > > >   include/linux/mlx5/mlx5_ifc_vdpa.h | 1 +
> > > > > > > > > > > > >   2 files changed, 10 insertions(+)
> > > > > > > > > > > > >
> > > > > > > > > > > > > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/=
drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > > > > > > > > index f8f088cced50..80e066de0866 100644
> > > > > > > > > > > > > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > > > > > > > > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > > > > > > > > @@ -1209,6 +1209,7 @@ static int modify_virtqueue=
(struct mlx5_vdpa_net *ndev,
> > > > > > > > > > > > >          bool state_change =3D false;
> > > > > > > > > > > > >          void *obj_context;
> > > > > > > > > > > > >          void *cmd_hdr;
> > > > > > > > > > > > > +       void *vq_ctx;
> > > > > > > > > > > > >          void *in;
> > > > > > > > > > > > >          int err;
> > > > > > > > > > > > >
> > > > > > > > > > > > > @@ -1230,6 +1231,7 @@ static int modify_virtqueue=
(struct mlx5_vdpa_net *ndev,
> > > > > > > > > > > > >          MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr=
, uid, ndev->mvdev.res.uid);
> > > > > > > > > > > > >
> > > > > > > > > > > > >          obj_context =3D MLX5_ADDR_OF(modify_virt=
io_net_q_in, in, obj_context);
> > > > > > > > > > > > > +       vq_ctx =3D MLX5_ADDR_OF(virtio_net_q_obje=
ct, obj_context, virtio_q_context);
> > > > > > > > > > > > >
> > > > > > > > > > > > >          if (mvq->modified_fields & MLX5_VIRTQ_MO=
DIFY_MASK_STATE) {
> > > > > > > > > > > > >                  if (!is_valid_state_change(mvq->=
fw_state, state, is_resumable(ndev))) {
> > > > > > > > > > > > > @@ -1241,6 +1243,12 @@ static int modify_virtqueu=
e(struct mlx5_vdpa_net *ndev,
> > > > > > > > > > > > >                  state_change =3D true;
> > > > > > > > > > > > >          }
> > > > > > > > > > > > >
> > > > > > > > > > > > > +       if (mvq->modified_fields & MLX5_VIRTQ_MOD=
IFY_MASK_VIRTIO_Q_ADDRS) {
> > > > > > > > > > > > > +               MLX5_SET64(virtio_q, vq_ctx, desc=
_addr, mvq->desc_addr);
> > > > > > > > > > > > > +               MLX5_SET64(virtio_q, vq_ctx, used=
_addr, mvq->device_addr);
> > > > > > > > > > > > > +               MLX5_SET64(virtio_q, vq_ctx, avai=
lable_addr, mvq->driver_addr);
> > > > > > > > > > > > > +       }
> > > > > > > > > > > > > +
> > > > > > > > > > > > >          MLX5_SET64(virtio_net_q_object, obj_cont=
ext, modify_field_select, mvq->modified_fields);
> > > > > > > > > > > > >          err =3D mlx5_cmd_exec(ndev->mvdev.mdev, =
in, inlen, out, sizeof(out));
> > > > > > > > > > > > >          if (err)
> > > > > > > > > > > > > @@ -2202,6 +2210,7 @@ static int mlx5_vdpa_set_vq=
_address(struct vdpa_device *vdev, u16 idx, u64 desc_
> > > > > > > > > > > > >          mvq->desc_addr =3D desc_area;
> > > > > > > > > > > > >          mvq->device_addr =3D device_area;
> > > > > > > > > > > > >          mvq->driver_addr =3D driver_area;
> > > > > > > > > > > > > +       mvq->modified_fields |=3D MLX5_VIRTQ_MODI=
FY_MASK_VIRTIO_Q_ADDRS;
> > > > > > > > > > > > >          return 0;
> > > > > > > > > > > > >   }
> > > > > > > > > > > > >
> > > > > > > > > > > > > diff --git a/include/linux/mlx5/mlx5_ifc_vdpa.h b=
/include/linux/mlx5/mlx5_ifc_vdpa.h
> > > > > > > > > > > > > index b86d51a855f6..9594ac405740 100644
> > > > > > > > > > > > > --- a/include/linux/mlx5/mlx5_ifc_vdpa.h
> > > > > > > > > > > > > +++ b/include/linux/mlx5/mlx5_ifc_vdpa.h
> > > > > > > > > > > > > @@ -145,6 +145,7 @@ enum {
> > > > > > > > > > > > >          MLX5_VIRTQ_MODIFY_MASK_STATE            =
        =3D (u64)1 << 0,
> > > > > > > > > > > > >          MLX5_VIRTQ_MODIFY_MASK_DIRTY_BITMAP_PARA=
MS      =3D (u64)1 << 3,
> > > > > > > > > > > > >          MLX5_VIRTQ_MODIFY_MASK_DIRTY_BITMAP_DUMP=
_ENABLE =3D (u64)1 << 4,
> > > > > > > > > > > > > +       MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_ADDRS    =
       =3D (u64)1 << 6,
> > > > > > > > > > > > >          MLX5_VIRTQ_MODIFY_MASK_DESC_GROUP_MKEY  =
        =3D (u64)1 << 14,
> > > > > > > > > > > > >   };
> > > > > > > > > > > > >
> > > > > > > > > > > > > --
> > > > > > > > > > > > > 2.42.0
> > > > > > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > >
> > > > > > > > >
> > > > > > > >
> > > > > > >
> > > > > >
> > > > >
> > > >
> > >
> >
>


