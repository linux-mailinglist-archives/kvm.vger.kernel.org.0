Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3C215D2FF
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 08:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728862AbgBNHlR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 02:41:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21970 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728773AbgBNHlR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 02:41:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581666074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9AH+9K6FkW+pS7y9tB+dRIaOPalyWaM9Mi1EFVqxmeQ=;
        b=PLV4gdiqXMux5OeT85wGX5+B1MnrbsuKjT2qoCjssJ9rm0a7R0oDZYj50/p55EeTiw6Mtv
        3N6Sd+kuXwe1P3W6t0JrQz/P0qOYVNwg0MRclR17vctm17toGdju86GSBrB881IQPOticu
        ni/o3eXnibzHyK28ytv9ENIgoXQ7kII=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-Gv8I_Z9TMjGCWiCugkInQA-1; Fri, 14 Feb 2020 02:41:10 -0500
X-MC-Unique: Gv8I_Z9TMjGCWiCugkInQA-1
Received: by mail-qv1-f70.google.com with SMTP id z9so5175957qvo.10
        for <kvm@vger.kernel.org>; Thu, 13 Feb 2020 23:41:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9AH+9K6FkW+pS7y9tB+dRIaOPalyWaM9Mi1EFVqxmeQ=;
        b=P1D56jeaiSqG7WikRvT95M05h4gPWAATMDE6w/1odNDuXJ7jsOd3uRTgWTav9GZAyl
         uGHj/fC6JiNtDhr/b/AONRS9wI2csXZcx1wgqQd+R1xribjF6B/jOFJpXkAOVnl0g3iK
         Q7OijHOAEEGRes4kiwlHHBtOVkBmEL1sGwm73BanDQRRogKH9MYOEJaUwIdTBuz9Nrem
         a0ApkGuNNatEovqx7F/oX8cDFn+9lr/bt07mD7mIdWQ7bHy9W99SK7V99r6T8iWGIMSG
         dFWPCoo1NT9coh6eIY5OukbSP/bFMi4bNBg4ZlLxIk31BY4CkIfW/HV4S1VYv2U+pi2Y
         IE2Q==
X-Gm-Message-State: APjAAAV5/Qym68pb0rwpeOUxOMl/cWso2sOB28DZTey/Ljo5874M6Po6
        G+PCyBzaOlBNHdFr7/IaZIzwQHKm80t5FHs5/d7C3SQe8uH19okDjz7fxhEOP3ixwPwqQpZN9Rj
        DWAc9/T6CyMBePb1nMoc+8Bx/zqNW
X-Received: by 2002:ac8:176f:: with SMTP id u44mr1455073qtk.379.1581666070285;
        Thu, 13 Feb 2020 23:41:10 -0800 (PST)
X-Google-Smtp-Source: APXvYqzbJpYEfdIZO/Iz53hVql41wATZvSjrzaMJqeYJxMLbgGQEKZWPSNFwizIFAAhfVXZ/o5Dfo0cO5Cu3d+E5qrU=
X-Received: by 2002:ac8:176f:: with SMTP id u44mr1455058qtk.379.1581666069907;
 Thu, 13 Feb 2020 23:41:09 -0800 (PST)
MIME-Version: 1.0
References: <20200107042401-mutt-send-email-mst@kernel.org>
 <b6e32f58e5d85ac5cc3141e9155fb140ae5cd580.camel@redhat.com>
 <1ade56b5-083f-bb6f-d3e0-3ddcf78f4d26@de.ibm.com> <20200206171349-mutt-send-email-mst@kernel.org>
 <5c860fa1-cef5-b389-4ebf-99a62afa0fe8@de.ibm.com> <20200207025806-mutt-send-email-mst@kernel.org>
 <97c93d38-ef07-e321-d133-18483d54c0c0@de.ibm.com> <CAJaqyWfngzP4d01B6+Sqt8FXN6jX7kGegjx8ie4no_1Er3igQA@mail.gmail.com>
 <43a5dbaa-9129-e220-8483-45c60a82c945@de.ibm.com> <e299afca8e22044916abbf9fbbd0bff6b0ee9e13.camel@redhat.com>
 <4c3f70b7-723a-8b0f-ac49-babef1bcc180@de.ibm.com> <50a79c3491ac483583c97df2fac29e2c3248fdea.camel@redhat.com>
 <8fbbfb49-99d1-7fee-e713-d6d5790fe866@de.ibm.com> <2364d0728c3bb4bcc0c13b591f774109a9274a30.camel@redhat.com>
 <bb9fb726-306c-5330-05aa-a86bd1b18097@de.ibm.com> <468983fad50a5e74a739f71487f0ea11e8d4dfd1.camel@redhat.com>
 <2dc1df65-1431-3917-40e5-c2b12096e2a7@de.ibm.com> <bd9c9b4d99abd20d5420583af5a4954ea1cf4618.camel@redhat.com>
 <e11ba53c-a5fa-0518-2e06-9296897ed529@de.ibm.com>
In-Reply-To: <e11ba53c-a5fa-0518-2e06-9296897ed529@de.ibm.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Fri, 14 Feb 2020 08:40:33 +0100
Message-ID: <CAJaqyWfJFArAdpOwehTn5ci-frqai+pazGgcn2VvQSebqGRVtg@mail.gmail.com>
Subject: Re: vhost changes (batched) in linux-next after 12/13 trigger random
 crashes in KVM guests after reboot
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi.

Were the vhost and vhost_net modules loaded with dyndbg=3D'+plt'? I miss
all the others regular debug traces on that one.

Thanks!

On Fri, Feb 14, 2020 at 8:34 AM Christian Borntraeger
<borntraeger@de.ibm.com> wrote:
>
> I did
> ping -c 20 -f ... ; reboot
> twice
>
> The ping after the first reboot showed .......E
>
> this was on the host console
>
> [   55.951885] CPU: 34 PID: 1908 Comm: CPU 0/KVM Not tainted 5.5.0+ #21
> [   55.951891] Hardware name: IBM 3906 M04 704 (LPAR)
> [   55.951892] Call Trace:
> [   55.951902]  [<0000001ede114132>] show_stack+0x8a/0xd0
> [   55.951906]  [<0000001edeb0672a>] dump_stack+0x8a/0xb8
> [   55.951915]  [<000003ff803736a6>] vhost_vring_ioctl+0x6fe/0x858 [vhost=
]
> [   55.951919]  [<000003ff8042a608>] vhost_net_ioctl+0x510/0x570 [vhost_n=
et]
> [   55.951924]  [<0000001ede3c4dd8>] do_vfs_ioctl+0x430/0x6f8
> [   55.951926]  [<0000001ede3c5124>] ksys_ioctl+0x84/0xb0
> [   55.951927]  [<0000001ede3c51ba>] __s390x_sys_ioctl+0x2a/0x38
> [   55.951931]  [<0000001edeb27f72>] system_call+0x2a6/0x2c8
> [   55.951949] CPU: 34 PID: 1908 Comm: CPU 0/KVM Not tainted 5.5.0+ #21
> [   55.951950] Hardware name: IBM 3906 M04 704 (LPAR)
> [   55.951951] Call Trace:
> [   55.951952]  [<0000001ede114132>] show_stack+0x8a/0xd0
> [   55.951954]  [<0000001edeb0672a>] dump_stack+0x8a/0xb8
> [   55.951956]  [<000003ff803736a6>] vhost_vring_ioctl+0x6fe/0x858 [vhost=
]
> [   55.951958]  [<000003ff8042a608>] vhost_net_ioctl+0x510/0x570 [vhost_n=
et]
> [   55.951959]  [<0000001ede3c4dd8>] do_vfs_ioctl+0x430/0x6f8
> [   55.951961]  [<0000001ede3c5124>] ksys_ioctl+0x84/0xb0
> [   55.951962]  [<0000001ede3c51ba>] __s390x_sys_ioctl+0x2a/0x38
> [   55.951964]  [<0000001edeb27f72>] system_call+0x2a6/0x2c8
> [   55.951997] Guest moved vq 0000000063d896c6 used index from 44 to 0
> [   56.609831] unexpected descriptor format for RX: out 0, in 0
> [   86.540460] CPU: 6 PID: 1908 Comm: CPU 0/KVM Not tainted 5.5.0+ #21
> [   86.540464] Hardware name: IBM 3906 M04 704 (LPAR)
> [   86.540466] Call Trace:
> [   86.540473]  [<0000001ede114132>] show_stack+0x8a/0xd0
> [   86.540477]  [<0000001edeb0672a>] dump_stack+0x8a/0xb8
> [   86.540486]  [<000003ff803736a6>] vhost_vring_ioctl+0x6fe/0x858 [vhost=
]
> [   86.540490]  [<000003ff8042a608>] vhost_net_ioctl+0x510/0x570 [vhost_n=
et]
> [   86.540494]  [<0000001ede3c4dd8>] do_vfs_ioctl+0x430/0x6f8
> [   86.540496]  [<0000001ede3c5124>] ksys_ioctl+0x84/0xb0
> [   86.540498]  [<0000001ede3c51ba>] __s390x_sys_ioctl+0x2a/0x38
> [   86.540501]  [<0000001edeb27f72>] system_call+0x2a6/0x2c8
> [   86.540524] CPU: 6 PID: 1908 Comm: CPU 0/KVM Not tainted 5.5.0+ #21
> [   86.540525] Hardware name: IBM 3906 M04 704 (LPAR)
> [   86.540526] Call Trace:
> [   86.540527]  [<0000001ede114132>] show_stack+0x8a/0xd0
> [   86.540528]  [<0000001edeb0672a>] dump_stack+0x8a/0xb8
> [   86.540531]  [<000003ff803736a6>] vhost_vring_ioctl+0x6fe/0x858 [vhost=
]
> [   86.540532]  [<000003ff8042a608>] vhost_net_ioctl+0x510/0x570 [vhost_n=
et]
> [   86.540534]  [<0000001ede3c4dd8>] do_vfs_ioctl+0x430/0x6f8
> [   86.540536]  [<0000001ede3c5124>] ksys_ioctl+0x84/0xb0
> [   86.540537]  [<0000001ede3c51ba>] __s390x_sys_ioctl+0x2a/0x38
> [   86.540538]  [<0000001edeb27f72>] system_call+0x2a6/0x2c8
> [   86.540570] unexpected descriptor format for RX: out 0, in 0
> [   86.540577] Unexpected header len for TX: 0 expected 0
>
>
> On 14.02.20 08:06, Eugenio P=C3=A9rez wrote:
> > Hi Christian.
> >
> > Sorry, that was meant to be applied over previous debug patch.
> >
> > Here I inline the one meant to be applied over eccb852f1fe6bede630e2e4f=
1a121a81e34354ab.
> >
> > Thanks!
> >
> > From d978ace99e4844b49b794d768385db3d128a4cc0 Mon Sep 17 00:00:00 2001
> > From: =3D?UTF-8?q?Eugenio=3D20P=3DC3=3DA9rez?=3D <eperezma@redhat.com>
> > Date: Fri, 14 Feb 2020 08:02:26 +0100
> > Subject: [PATCH] vhost: disable all features and trace last_avail_idx a=
nd
> >  ioctl calls
> >
> > ---
> >  drivers/vhost/net.c   | 20 +++++++++++++++++---
> >  drivers/vhost/vhost.c | 25 +++++++++++++++++++++++--
> >  drivers/vhost/vhost.h | 10 +++++-----
> >  3 files changed, 45 insertions(+), 10 deletions(-)
> >
> > diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> > index e158159671fa..e4d5f843f9c0 100644
> > --- a/drivers/vhost/net.c
> > +++ b/drivers/vhost/net.c
> > @@ -1505,10 +1505,13 @@ static long vhost_net_set_backend(struct vhost_=
net *n, unsigned index, int fd)
> >
> >       mutex_lock(&n->dev.mutex);
> >       r =3D vhost_dev_check_owner(&n->dev);
> > -     if (r)
> > +     if (r) {
> > +             pr_debug("vhost_dev_check_owner index=3D%u fd=3D%d rc r=
=3D%d", index, fd, r);
> >               goto err;
> > +     }
> >
> >       if (index >=3D VHOST_NET_VQ_MAX) {
> > +             pr_debug("vhost_dev_check_owner index=3D%u fd=3D%d MAX=3D=
%d", index, fd, VHOST_NET_VQ_MAX);
> >               r =3D -ENOBUFS;
> >               goto err;
> >       }
> > @@ -1518,22 +1521,26 @@ static long vhost_net_set_backend(struct vhost_=
net *n, unsigned index, int fd)
> >
> >       /* Verify that ring has been setup correctly. */
> >       if (!vhost_vq_access_ok(vq)) {
> > +             pr_debug("vhost_net_set_backend index=3D%u fd=3D%d !vhost=
_vq_access_ok", index, fd);
> >               r =3D -EFAULT;
> >               goto err_vq;
> >       }
> >       sock =3D get_socket(fd);
> >       if (IS_ERR(sock)) {
> >               r =3D PTR_ERR(sock);
> > +             pr_debug("vhost_net_set_backend index=3D%u fd=3D%d get_so=
cket err r=3D%d", index, fd, r);
> >               goto err_vq;
> >       }
> >
> >       /* start polling new socket */
> >       oldsock =3D vq->private_data;
> >       if (sock !=3D oldsock) {
> > +             pr_debug("sock=3D%p !=3D oldsock=3D%p index=3D%u fd=3D%d =
vq=3D%p", sock, oldsock, index, fd, vq);
> >               ubufs =3D vhost_net_ubuf_alloc(vq,
> >                                            sock && vhost_sock_zcopy(soc=
k));
> >               if (IS_ERR(ubufs)) {
> >                       r =3D PTR_ERR(ubufs);
> > +                     pr_debug("ubufs index=3D%u fd=3D%d err r=3D%d vq=
=3D%p", index, fd, r, vq);
> >                       goto err_ubufs;
> >               }
> >
> > @@ -1541,11 +1548,15 @@ static long vhost_net_set_backend(struct vhost_=
net *n, unsigned index, int fd)
> >               vq->private_data =3D sock;
> >               vhost_net_buf_unproduce(nvq);
> >               r =3D vhost_vq_init_access(vq);
> > -             if (r)
> > +             if (r) {
> > +                     pr_debug("init_access index=3D%u fd=3D%d r=3D%d v=
q=3D%p", index, fd, r, vq);
> >                       goto err_used;
> > +             }
> >               r =3D vhost_net_enable_vq(n, vq);
> > -             if (r)
> > +             if (r) {
> > +                     pr_debug("enable_vq index=3D%u fd=3D%d r=3D%d vq=
=3D%p", index, fd, r, vq);
> >                       goto err_used;
> > +             }
> >               if (index =3D=3D VHOST_NET_VQ_RX)
> >                       nvq->rx_ring =3D get_tap_ptr_ring(fd);
> >
> > @@ -1559,6 +1570,8 @@ static long vhost_net_set_backend(struct vhost_ne=
t *n, unsigned index, int fd)
> >
> >       mutex_unlock(&vq->mutex);
> >
> > +     pr_debug("sock=3D%p", sock);
> > +
> >       if (oldubufs) {
> >               vhost_net_ubuf_put_wait_and_free(oldubufs);
> >               mutex_lock(&vq->mutex);
> > @@ -1710,6 +1723,7 @@ static long vhost_net_ioctl(struct file *f, unsig=
ned int ioctl,
> >
> >       switch (ioctl) {
> >       case VHOST_NET_SET_BACKEND:
> > +             pr_debug("VHOST_NET_SET_BACKEND");
> >               if (copy_from_user(&backend, argp, sizeof backend))
> >                       return -EFAULT;
> >               return vhost_net_set_backend(n, backend.index, backend.fd=
);
> > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > index b5a51b1f2e79..ec25ba32fe81 100644
> > --- a/drivers/vhost/vhost.c
> > +++ b/drivers/vhost/vhost.c
> > @@ -1642,15 +1642,30 @@ long vhost_vring_ioctl(struct vhost_dev *d, uns=
igned int ioctl, void __user *arg
> >                       r =3D -EINVAL;
> >                       break;
> >               }
> > +
> > +             if (vq->last_avail_idx || vq->avail_idx) {
> > +                     pr_debug(
> > +                             "strange VHOST_SET_VRING_BASE [vq=3D%p][s=
.index=3D%u][s.num=3D%u]",
> > +                             vq, s.index, s.num);
> > +                     dump_stack();
> > +                     r =3D 0;
> > +                     break;
> > +             }
> >               vq->last_avail_idx =3D s.num;
> >               /* Forget the cached index value. */
> >               vq->avail_idx =3D vq->last_avail_idx;
> > +             pr_debug(
> > +                     "VHOST_SET_VRING_BASE [vq=3D%p][vq->last_avail_id=
x=3D%u][vq->avail_idx=3D%u][s.index=3D%u][s.num=3D%u]",
> > +                     vq, vq->last_avail_idx, vq->avail_idx, s.index, s=
.num);
> >               break;
> >       case VHOST_GET_VRING_BASE:
> >               s.index =3D idx;
> >               s.num =3D vq->last_avail_idx;
> >               if (copy_to_user(argp, &s, sizeof s))
> >                       r =3D -EFAULT;
> > +             pr_debug(
> > +                     "VHOST_GET_VRING_BASE [vq=3D%p][vq->last_avail_id=
x=3D%u][vq->avail_idx=3D%u][s.index=3D%u][s.num=3D%u]",
> > +                     vq, vq->last_avail_idx, vq->avail_idx, s.index, s=
.num);
> >               break;
> >       case VHOST_SET_VRING_KICK:
> >               if (copy_from_user(&f, argp, sizeof f)) {
> > @@ -2239,8 +2254,8 @@ static int fetch_buf(struct vhost_virtqueue *vq)
> >               vq->avail_idx =3D vhost16_to_cpu(vq, avail_idx);
> >
> >               if (unlikely((u16)(vq->avail_idx - last_avail_idx) > vq->=
num)) {
> > -                     vq_err(vq, "Guest moved used index from %u to %u"=
,
> > -                             last_avail_idx, vq->avail_idx);
> > +                     vq_err(vq, "Guest moved vq %p used index from %u =
to %u",
> > +                             vq, last_avail_idx, vq->avail_idx);
> >                       return -EFAULT;
> >               }
> >
> > @@ -2316,6 +2331,9 @@ static int fetch_buf(struct vhost_virtqueue *vq)
> >       BUG_ON(!(vq->used_flags & VRING_USED_F_NO_NOTIFY));
> >
> >       /* On success, increment avail index. */
> > +     pr_debug(
> > +             "[vq=3D%p][vq->last_avail_idx=3D%u][vq->avail_idx=3D%u][v=
q->ndescs=3D%d][vq->first_desc=3D%d]",
> > +             vq, vq->last_avail_idx, vq->avail_idx, vq->ndescs, vq->fi=
rst_desc);
> >       vq->last_avail_idx++;
> >
> >       return 0;
> > @@ -2432,6 +2450,9 @@ EXPORT_SYMBOL_GPL(vhost_get_vq_desc);
> >  /* Reverse the effect of vhost_get_vq_desc. Useful for error handling.=
 */
> >  void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n)
> >  {
> > +     pr_debug(
> > +             "DISCARD [vq=3D%p][vq->last_avail_idx=3D%u][vq->avail_idx=
=3D%u][n=3D%d]",
> > +             vq, vq->last_avail_idx, vq->avail_idx, n);
> >       vq->last_avail_idx -=3D n;
> >  }
> >  EXPORT_SYMBOL_GPL(vhost_discard_vq_desc);
> > diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> > index 661088ae6dc7..08f6d2ccb697 100644
> > --- a/drivers/vhost/vhost.h
> > +++ b/drivers/vhost/vhost.h
> > @@ -250,11 +250,11 @@ int vhost_init_device_iotlb(struct vhost_dev *d, =
bool enabled);
> >       } while (0)
> >
> >  enum {
> > -     VHOST_FEATURES =3D (1ULL << VIRTIO_F_NOTIFY_ON_EMPTY) |
> > -                      (1ULL << VIRTIO_RING_F_INDIRECT_DESC) |
> > -                      (1ULL << VIRTIO_RING_F_EVENT_IDX) |
> > -                      (1ULL << VHOST_F_LOG_ALL) |
> > -                      (1ULL << VIRTIO_F_ANY_LAYOUT) |
> > +     VHOST_FEATURES =3D /* (1ULL << VIRTIO_F_NOTIFY_ON_EMPTY) | */
> > +                      /* (1ULL << VIRTIO_RING_F_INDIRECT_DESC) | */
> > +                      /* (1ULL << VIRTIO_RING_F_EVENT_IDX) | */
> > +                      /* (1ULL << VHOST_F_LOG_ALL) | */
> > +                      /* (1ULL << VIRTIO_F_ANY_LAYOUT) | */
> >                        (1ULL << VIRTIO_F_VERSION_1)
> >  };
> >
> >
>

