Return-Path: <kvm+bounces-4812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CAB8B81893D
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 15:03:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D08D21C241CF
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 14:03:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 530CB1C29D;
	Tue, 19 Dec 2023 14:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dMzHYC5a"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25BB1A5B9
	for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 14:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702994588;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z7pBhfHOUQ5GeQwzcNE9zvKhjGxyQjhxQqPSb40q/TQ=;
	b=dMzHYC5aB8lkiqqiiyRz7Y12siFXtU7npRc31OLATXz5kZHd/aUtCEft5OCfQFhvaXtUYz
	LQ/aVwtr3aq/zXS2eb6ANiOJyUBWphiHusd7u5c3gip6o5em2T9nrKrfL4Ag87plE9wpX6
	OjLtnwTs2gjZepIxiweGjNYlkg5tLNs=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-529-znXBN3mkN7WQfMf85mt7-A-1; Tue, 19 Dec 2023 09:03:04 -0500
X-MC-Unique: znXBN3mkN7WQfMf85mt7-A-1
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-5e744f7ca3bso19592177b3.2
        for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 06:03:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702994584; x=1703599384;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z7pBhfHOUQ5GeQwzcNE9zvKhjGxyQjhxQqPSb40q/TQ=;
        b=wMMljweRAujlJr0IUmNihGdGzVubMDFUU3WigayWa7QZ/9EKBFAjfwYlc/gXhCI5od
         GjCUsLVgRekn45lu/BnjhcccfkJnWj6QxtbZqMX8U8TBBGv2Vf9V8tdCi79yfS8M7l5c
         qC+V2zZmTGqRsfl3UzNDQt5SIukTo9lPkFOz4O8nq/3jHlvnvFxvrayHH6BVcOayRhlk
         X6qNV9ut63PVM8D7x/xXKn+3XGwi9crxGI799ttIMtwxsAEgKU+vGUU4jOYhUj8dwOQg
         cQkoet28LAunh8h39LqEmQ8QXuKHB+6xD3cKl29MwUQP+XpSs7Tls45Bw4XFvSRWKVR2
         jZlQ==
X-Gm-Message-State: AOJu0YxkOdC90e4AUqLrF99tkdpfzQppI6Tw9Lu5v1Sn7AxgPYEUCHS0
	xLRKa75AoszQmOasMIo/VNK1eT0RHIZHhGQqcMBUEd2z5mZJAqofHYRfc+HxGM6W5H/YGDYXVhj
	BuN3hHZki3PutUPMif0m6Y366wpgp
X-Received: by 2002:a5b:f81:0:b0:db5:41fe:30c with SMTP id q1-20020a5b0f81000000b00db541fe030cmr10513360ybh.64.1702994584010;
        Tue, 19 Dec 2023 06:03:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEiU0YfzN07Vi8tPeRdLAu3jf0k0Strc/HI4vFI2e/A0/PT/h8UORzxQ4ReAVWzobSeFzElEt/DWZt36c0p7EQ=
X-Received: by 2002:a5b:f81:0:b0:db5:41fe:30c with SMTP id q1-20020a5b0f81000000b00db541fe030cmr10513339ybh.64.1702994583529;
 Tue, 19 Dec 2023 06:03:03 -0800 (PST)
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
 <CAJaqyWccZJFdfww-_vmj4kJvJkWKFt_VBWmujfVTsFxHohkiZg@mail.gmail.com>
 <8fc4e1f156b075ec3f4c65acc1e10439f767bf81.camel@nvidia.com>
 <CAJaqyWe-nfb4F2PxTKz3R=fKf6EZzSbKSPm_SwdXjxQCybVmdQ@mail.gmail.com> <60ed697361d5a366a3a9a7ce6c8d3602cba40491.camel@nvidia.com>
In-Reply-To: <60ed697361d5a366a3a9a7ce6c8d3602cba40491.camel@nvidia.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Tue, 19 Dec 2023 15:02:27 +0100
Message-ID: <CAJaqyWcRnz5p0QzwbpFzdnpwJaH3JmMFBBV4Pux88yU6A0x5ZA@mail.gmail.com>
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

On Tue, Dec 19, 2023 at 12:16=E2=80=AFPM Dragos Tatulea <dtatulea@nvidia.co=
m> wrote:
>
> On Tue, 2023-12-19 at 08:24 +0100, Eugenio Perez Martin wrote:
> > On Mon, Dec 18, 2023 at 2:58=E2=80=AFPM Dragos Tatulea <dtatulea@nvidia=
.com> wrote:
> > >
> > > On Mon, 2023-12-18 at 13:06 +0100, Eugenio Perez Martin wrote:
> > > > On Mon, Dec 18, 2023 at 11:52=E2=80=AFAM Dragos Tatulea <dtatulea@n=
vidia.com> wrote:
> > > > >
> > > > > On Mon, 2023-12-18 at 11:16 +0100, Eugenio Perez Martin wrote:
> > > > > > On Sat, Dec 16, 2023 at 12:03=E2=80=AFPM Dragos Tatulea <dtatul=
ea@nvidia.com> wrote:
> > > > > > >
> > > > > > > On Fri, 2023-12-15 at 18:56 +0100, Eugenio Perez Martin wrote=
:
> > > > > > > > On Fri, Dec 15, 2023 at 3:13=E2=80=AFPM Dragos Tatulea <dta=
tulea@nvidia.com> wrote:
> > > > > > > > >
> > > > > > > > > On Fri, 2023-12-15 at 12:35 +0000, Dragos Tatulea wrote:
> > > > > > > > > > On Thu, 2023-12-14 at 19:30 +0100, Eugenio Perez Martin=
 wrote:
> > > > > > > > > > > On Thu, Dec 14, 2023 at 4:51=E2=80=AFPM Dragos Tatule=
a <dtatulea@nvidia.com> wrote:
> > > > > > > > > > > >
> > > > > > > > > > > > On Thu, 2023-12-14 at 08:45 -0500, Michael S. Tsirk=
in wrote:
> > > > > > > > > > > > > On Thu, Dec 14, 2023 at 01:39:55PM +0000, Dragos =
Tatulea wrote:
> > > > > > > > > > > > > > On Tue, 2023-12-12 at 15:44 -0800, Si-Wei Liu w=
rote:
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > On 12/12/2023 11:21 AM, Eugenio Perez Martin =
wrote:
> > > > > > > > > > > > > > > > On Tue, Dec 5, 2023 at 11:46=E2=80=AFAM Dra=
gos Tatulea <dtatulea@nvidia.com> wrote:
> > > > > > > > > > > > > > > > > Addresses get set by .set_vq_address. hw =
vq addresses will be updated on
> > > > > > > > > > > > > > > > > next modify_virtqueue.
> > > > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > > > Signed-off-by: Dragos Tatulea <dtatulea@n=
vidia.com>
> > > > > > > > > > > > > > > > > Reviewed-by: Gal Pressman <gal@nvidia.com=
>
> > > > > > > > > > > > > > > > > Acked-by: Eugenio P=C3=A9rez <eperezma@re=
dhat.com>
> > > > > > > > > > > > > > > > I'm kind of ok with this patch and the next=
 one about state, but I
> > > > > > > > > > > > > > > > didn't ack them in the previous series.
> > > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > > My main concern is that it is not valid to =
change the vq address after
> > > > > > > > > > > > > > > > DRIVER_OK in VirtIO, which vDPA follows. On=
ly memory maps are ok to
> > > > > > > > > > > > > > > > change at this moment. I'm not sure about v=
q state in vDPA, but vhost
> > > > > > > > > > > > > > > > forbids changing it with an active backend.
> > > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > > Suspend is not defined in VirtIO at this mo=
ment though, so maybe it is
> > > > > > > > > > > > > > > > ok to decide that all of these parameters m=
ay change during suspend.
> > > > > > > > > > > > > > > > Maybe the best thing is to protect this wit=
h a vDPA feature flag.
> > > > > > > > > > > > > > > I think protect with vDPA feature flag could =
work, while on the other
> > > > > > > > > > > > > > > hand vDPA means vendor specific optimization =
is possible around suspend
> > > > > > > > > > > > > > > and resume (in case it helps performance), wh=
ich doesn't have to be
> > > > > > > > > > > > > > > backed by virtio spec. Same applies to vhost =
user backend features,
> > > > > > > > > > > > > > > variations there were not backed by spec eith=
er. Of course, we should
> > > > > > > > > > > > > > > try best to make the default behavior backwar=
d compatible with
> > > > > > > > > > > > > > > virtio-based backend, but that circles back t=
o no suspend definition in
> > > > > > > > > > > > > > > the current virtio spec, for which I hope we =
don't cease development on
> > > > > > > > > > > > > > > vDPA indefinitely. After all, the virtio base=
d vdap backend can well
> > > > > > > > > > > > > > > define its own feature flag to describe (mino=
r difference in) the
> > > > > > > > > > > > > > > suspend behavior based on the later spec once=
 it is formed in future.
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > > So what is the way forward here? From what I un=
derstand the options are:
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > 1) Add a vdpa feature flag for changing device =
properties while suspended.
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > 2) Drop these 2 patches from the series for now=
. Not sure if this makes sense as
> > > > > > > > > > > > > > this. But then Si-Wei's qemu device suspend/res=
ume poc [0] that exercises this
> > > > > > > > > > > > > > code won't work anymore. This means the series =
would be less well tested.
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > Are there other possible options? What do you t=
hink?
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > [0] https://github.com/siwliu-kernel/qemu/tree/=
svq-resume-wip
> > > > > > > > > > > > >
> > > > > > > > > > > > > I am fine with either of these.
> > > > > > > > > > > > >
> > > > > > > > > > > > How about allowing the change only under the follow=
ing conditions:
> > > > > > > > > > > >   vhost_vdpa_can_suspend && vhost_vdpa_can_resume &=
&
> > > > > > > > > > > > VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK is set
> > > > > > > > > > > >
> > > > > > > > > > > > ?
> > > > > > > > > > >
> > > > > > > > > > > I think the best option by far is 1, as there is no h=
int in the
> > > > > > > > > > > combination of these 3 indicating that you can change=
 device
> > > > > > > > > > > properties in the suspended state.
> > > > > > > > > > >
> > > > > > > > > > Sure. Will respin a v3 without these two patches.
> > > > > > > > > >
> > > > > > > > > > Another series can implement option 2 and add these 2 p=
atches on top.
> > > > > > > > > Hmm...I misunderstood your statement and sent a erroneus =
v3. You said that
> > > > > > > > > having a feature flag is the best option.
> > > > > > > > >
> > > > > > > > > Will add a feature flag in v4: is this similar to the
> > > > > > > > > VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK flag?
> > > > > > > > >
> > > > > > > >
> > > > > > > > Right, it should be easy to return it from .get_backend_fea=
tures op if
> > > > > > > > the FW returns that capability, isn't it?
> > > > > > > >
> > > > > > > Yes, that's easy. But I wonder if we need one feature bit for=
 each type of
> > > > > > > change:
> > > > > > > - VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND
> > > > > > > - VHOST_BACKEND_F_CHANGEABLE_VQ_STATE_IN_SUSPEND
> > > > > > >
> > > > > >
> > > > > > I'd say yes. Although we could configure SVQ initial state in u=
serland
> > > > > > as different than 0 for this first step, it would be needed in =
the
> > > > > > long term.
> > > > > >
> > > > > > > Or would a big one VHOST_BACKEND_F_CAN_RECONFIG_VQ_IN_SUSPEND=
 suffice?
> > > > > > >
> > > > > >
> > > > > > I'd say "reconfig vq" is not valid as mlx driver doesn't allow
> > > > > > changing queue sizes, for example, isn't it?
> > > > > >
> > > > > Modifying the queue size for a vq is indeed not supported by the =
mlx device.
> > > > >
> > > > > > To define that it is
> > > > > > valid to change "all parameters" seems very confident.
> > > > > >
> > > > > Ack
> > > > >
> > > > > > > To me having individual feature bits makes sense. But it coul=
d also takes too
> > > > > > > many bits if more changes are required.
> > > > > > >
> > > > > >
> > > > > > Yes, that's a good point. Maybe it is valid to define a subset =
of
> > > > > > features that can be changed., but I think it is way clearer to=
 just
> > > > > > check for individual feature bits.
> > > > > >
> > > > > I will prepare extra patches with the 2 feature bits approach.
> > > > >
> > > > > Is it necessary to add checks in the vdpa core that block changin=
g these
> > > > > properties if the state is driver ok and the device doesn't suppo=
rt the feature?
> > > > >
> > > >
> > > > Yes, I think it is better to protect for changes in vdpa core.
> > > >
> > > Hmmm... there is no suspended state available. I would only add check=
s for the
> > > DRIVER_OK state of the device because adding a is_suspended state/op =
seems out
> > > of scope for this series. Any thoughts?
> > >
> >
> > I can develop it so you can include it in your series for sure, I will
> > send it ASAP.
> >
> If it's a matter of:
> - Adding a suspended state to struct vhost_vdpa.
> - Setting it to true on successful device suspend.
> - Clearing it on successful device resume and device reset.
>
> I can add this patch. I'm just not sure about the locking part. But maybe=
 I can
> send it and we can debate on the code.
>

Yes, that was the plan basically.

I think vhost_vdpa_suspend / vhost_vdpa_resume are already called from
vhost_vdpa_unlocked_ioctl with the lock acquired, is that what you
mean?

Thanks!


