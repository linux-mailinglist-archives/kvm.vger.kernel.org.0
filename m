Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD4E199F06
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 21:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731396AbgCaT3G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 15:29:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40653 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728617AbgCaT3F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 15:29:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585682944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0om1tDTYIRQhTCKQFE/dlR8vuduWySdQ5AoKosLSrZY=;
        b=PHKfWWHdBUXMRI9Kjzy0tLqUBrtx7hhOVb1BIcMxnkH1MXXa723Ws0pGgvyRPJ+TewZN3I
        uNk4IOe/uFo62ANNT9+CnTS0CqcVLlmS3czMsnuPFfZKwxryUxUCo1IxxPrfcScAyXy54q
        //fh5FPrM3hdoLiXmJBfVes62FchPmo=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-W4tSTUCxMaihawZDUgm7eQ-1; Tue, 31 Mar 2020 15:29:02 -0400
X-MC-Unique: W4tSTUCxMaihawZDUgm7eQ-1
Received: by mail-lf1-f69.google.com with SMTP id r20so4661807lfm.7
        for <kvm@vger.kernel.org>; Tue, 31 Mar 2020 12:29:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0om1tDTYIRQhTCKQFE/dlR8vuduWySdQ5AoKosLSrZY=;
        b=p8BXKfETFE3oZmwG6kji7hmCcmK9bwCjn9fXN3Kn9jwEgS1LTGUAc6jnpF40WMsK7V
         pMevRNb4Ca69hm5BDGEm2T2s6hF60vj+9/bj+LnXfXThpLROdhgO25rTJZdr/ZlVrPFR
         LcXga+NPf7SMrH2MUmpG01TY1lO1y+SfrC52F1Ho7Lwz3cr0k77Jfl6EE1Fe1awMd8Vy
         TJVi6AvTIVwbg2v6kKaYuveOMHmDxAtUpuDp7e1fyiatcamymL2mWpF1DHc7sGSv1Zv/
         Is3zdSC1rngZmyFIcehCWBd0xCu6CGsdQn3AlBO6nrbPZurMDpUeP+T8R5SQfRd7Fx0F
         uqxg==
X-Gm-Message-State: AGi0PuaQNOVgl5JlchwhqymHbeIVJ4E5KIsGTXxW9X8LAB4oOkjktUQ3
        AqPZUPQz22upOuc4K8OCXgVliWpsLv2hnq12nTTK/nlNnleaFiy6OuufMYDfEn2q43rnYeXPzbt
        dhEOKtlHoji9efOFXw2jBl/Jh6kI+
X-Received: by 2002:ac2:5999:: with SMTP id w25mr12114697lfn.46.1585682940855;
        Tue, 31 Mar 2020 12:29:00 -0700 (PDT)
X-Google-Smtp-Source: APiQypLpr8IXJs16xd9lebdc8tNMXZ0SZbvwQ/5Eviy4mM3IuzpP1FdXPWR68xZuJdl3TyvgE3tEk6BojOLJ5/7gjZo=
X-Received: by 2002:ac2:5999:: with SMTP id w25mr12114683lfn.46.1585682940546;
 Tue, 31 Mar 2020 12:29:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200331180006.25829-1-eperezma@redhat.com> <20200331180006.25829-2-eperezma@redhat.com>
 <20200331142426-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200331142426-mutt-send-email-mst@kernel.org>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Tue, 31 Mar 2020 21:28:24 +0200
Message-ID: <CAJaqyWfaMb0ZojkeoPhM8b49wZnfwVFG7MbOsOqhRUgLJE_GCw@mail.gmail.com>
Subject: Re: [PATCH v2 1/8] vhost: Create accessors for virtqueues private_data
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 31, 2020 at 8:29 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Tue, Mar 31, 2020 at 07:59:59PM +0200, Eugenio P=C3=A9rez wrote:
> > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > ---
> >  drivers/vhost/net.c   | 28 +++++++++++++++-------------
> >  drivers/vhost/vhost.h | 28 ++++++++++++++++++++++++++++
> >  drivers/vhost/vsock.c | 14 +++++++-------
>
>
> Seems to be missing scsi and test.

Good point, changing them too!

>
>
> >  3 files changed, 50 insertions(+), 20 deletions(-)
> >
> > diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> > index e158159671fa..6c5e7a6f712c 100644
> > --- a/drivers/vhost/net.c
> > +++ b/drivers/vhost/net.c
> > @@ -424,7 +424,7 @@ static void vhost_net_disable_vq(struct vhost_net *=
n,
> >       struct vhost_net_virtqueue *nvq =3D
> >               container_of(vq, struct vhost_net_virtqueue, vq);
> >       struct vhost_poll *poll =3D n->poll + (nvq - n->vqs);
> > -     if (!vq->private_data)
> > +     if (!vhost_vq_get_backend_opaque(vq))
> >               return;
> >       vhost_poll_stop(poll);
> >  }
> > @@ -437,7 +437,7 @@ static int vhost_net_enable_vq(struct vhost_net *n,
> >       struct vhost_poll *poll =3D n->poll + (nvq - n->vqs);
> >       struct socket *sock;
> >
> > -     sock =3D vq->private_data;
> > +     sock =3D vhost_vq_get_backend_opaque(vq);
> >       if (!sock)
> >               return 0;
> >
> > @@ -524,7 +524,7 @@ static void vhost_net_busy_poll(struct vhost_net *n=
et,
> >               return;
> >
> >       vhost_disable_notify(&net->dev, vq);
> > -     sock =3D rvq->private_data;
> > +     sock =3D vhost_vq_get_backend_opaque(rvq);
> >
> >       busyloop_timeout =3D poll_rx ? rvq->busyloop_timeout:
> >                                    tvq->busyloop_timeout;
> > @@ -570,8 +570,10 @@ static int vhost_net_tx_get_vq_desc(struct vhost_n=
et *net,
> >
> >       if (r =3D=3D tvq->num && tvq->busyloop_timeout) {
> >               /* Flush batched packets first */
> > -             if (!vhost_sock_zcopy(tvq->private_data))
> > -                     vhost_tx_batch(net, tnvq, tvq->private_data, msgh=
dr);
> > +             if (!vhost_sock_zcopy(vhost_vq_get_backend_opaque(tvq)))
> > +                     vhost_tx_batch(net, tnvq,
> > +                                    vhost_vq_get_backend_opaque(tvq),
> > +                                    msghdr);
> >
> >               vhost_net_busy_poll(net, rvq, tvq, busyloop_intr, false);
> >
> > @@ -685,7 +687,7 @@ static int vhost_net_build_xdp(struct vhost_net_vir=
tqueue *nvq,
> >       struct vhost_virtqueue *vq =3D &nvq->vq;
> >       struct vhost_net *net =3D container_of(vq->dev, struct vhost_net,
> >                                            dev);
> > -     struct socket *sock =3D vq->private_data;
> > +     struct socket *sock =3D vhost_vq_get_backend_opaque(vq);
> >       struct page_frag *alloc_frag =3D &net->page_frag;
> >       struct virtio_net_hdr *gso;
> >       struct xdp_buff *xdp =3D &nvq->xdp[nvq->batched_xdp];
> > @@ -952,7 +954,7 @@ static void handle_tx(struct vhost_net *net)
> >       struct socket *sock;
> >
> >       mutex_lock_nested(&vq->mutex, VHOST_NET_VQ_TX);
> > -     sock =3D vq->private_data;
> > +     sock =3D vhost_vq_get_backend_opaque(vq);
> >       if (!sock)
> >               goto out;
> >
> > @@ -1121,7 +1123,7 @@ static void handle_rx(struct vhost_net *net)
> >       int recv_pkts =3D 0;
> >
> >       mutex_lock_nested(&vq->mutex, VHOST_NET_VQ_RX);
> > -     sock =3D vq->private_data;
> > +     sock =3D vhost_vq_get_backend_opaque(vq);
> >       if (!sock)
> >               goto out;
> >
> > @@ -1344,9 +1346,9 @@ static struct socket *vhost_net_stop_vq(struct vh=
ost_net *n,
> >               container_of(vq, struct vhost_net_virtqueue, vq);
> >
> >       mutex_lock(&vq->mutex);
> > -     sock =3D vq->private_data;
> > +     sock =3D vhost_vq_get_backend_opaque(vq);
> >       vhost_net_disable_vq(n, vq);
> > -     vq->private_data =3D NULL;
> > +     vhost_vq_set_backend_opaque(vq, NULL);
> >       vhost_net_buf_unproduce(nvq);
> >       nvq->rx_ring =3D NULL;
> >       mutex_unlock(&vq->mutex);
> > @@ -1528,7 +1530,7 @@ static long vhost_net_set_backend(struct vhost_ne=
t *n, unsigned index, int fd)
> >       }
> >
> >       /* start polling new socket */
> > -     oldsock =3D vq->private_data;
> > +     oldsock =3D vhost_vq_get_backend_opaque(vq);
> >       if (sock !=3D oldsock) {
> >               ubufs =3D vhost_net_ubuf_alloc(vq,
> >                                            sock && vhost_sock_zcopy(soc=
k));
> > @@ -1538,7 +1540,7 @@ static long vhost_net_set_backend(struct vhost_ne=
t *n, unsigned index, int fd)
> >               }
> >
> >               vhost_net_disable_vq(n, vq);
> > -             vq->private_data =3D sock;
> > +             vhost_vq_set_backend_opaque(vq, sock);
> >               vhost_net_buf_unproduce(nvq);
> >               r =3D vhost_vq_init_access(vq);
> >               if (r)
> > @@ -1575,7 +1577,7 @@ static long vhost_net_set_backend(struct vhost_ne=
t *n, unsigned index, int fd)
> >       return 0;
> >
> >  err_used:
> > -     vq->private_data =3D oldsock;
> > +     vhost_vq_set_backend_opaque(vq, oldsock);
> >       vhost_net_enable_vq(n, vq);
> >       if (ubufs)
> >               vhost_net_ubuf_put_wait_and_free(ubufs);
> > diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> > index a123fd70847e..0808188f7e8f 100644
> > --- a/drivers/vhost/vhost.h
> > +++ b/drivers/vhost/vhost.h
> > @@ -244,6 +244,34 @@ enum {
> >                        (1ULL << VIRTIO_F_VERSION_1)
> >  };
> >
> > +/**
> > + * vhost_vq_set_backend_opaque - Set backend opaque.
> > + *
> > + * @vq            Virtqueue.
> > + * @private_data  The private data.
> > + *
> > + * Context: Need to call with vq->mutex acquired.
> > + */
> > +static inline void vhost_vq_set_backend_opaque(struct vhost_virtqueue =
*vq,
> > +                                            void *private_data)
> > +{
> > +     vq->private_data =3D private_data;
> > +}
> > +
> > +/**
> > + * vhost_vq_get_backend_opaque - Get backend opaque.
> > + *
> > + * @vq            Virtqueue.
> > + * @private_data  The private data.
> > + *
> > + * Context: Need to call with vq->mutex acquired.
> > + * Return: Opaque previously set with vhost_vq_set_backend_opaque.
>
>
> I prefer opaque -> private data in comments.
>

Changing.

v3 sent.

Thanks!


> > + */
>
>
>
>
> > +static inline void *vhost_vq_get_backend_opaque(struct vhost_virtqueue=
 *vq)
> > +{
> > +     return vq->private_data;
> > +}
> > +
> >  static inline bool vhost_has_feature(struct vhost_virtqueue *vq, int b=
it)
> >  {
> >       return vq->acked_features & (1ULL << bit);
> > diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> > index c2d7d57e98cf..6e20dbe14acd 100644
> > --- a/drivers/vhost/vsock.c
> > +++ b/drivers/vhost/vsock.c
> > @@ -91,7 +91,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock=
,
> >
> >       mutex_lock(&vq->mutex);
> >
> > -     if (!vq->private_data)
> > +     if (!vhost_vq_get_backend_opaque(vq))
> >               goto out;
> >
> >       /* Avoid further vmexits, we're already processing the virtqueue =
*/
> > @@ -440,7 +440,7 @@ static void vhost_vsock_handle_tx_kick(struct vhost=
_work *work)
> >
> >       mutex_lock(&vq->mutex);
> >
> > -     if (!vq->private_data)
> > +     if (!vhost_vq_get_backend_opaque(vq))
> >               goto out;
> >
> >       vhost_disable_notify(&vsock->dev, vq);
> > @@ -533,8 +533,8 @@ static int vhost_vsock_start(struct vhost_vsock *vs=
ock)
> >                       goto err_vq;
> >               }
> >
> > -             if (!vq->private_data) {
> > -                     vq->private_data =3D vsock;
> > +             if (!vhost_vq_get_backend_opaque(vq)) {
> > +                     vhost_vq_set_backend_opaque(vq, vsock);
> >                       ret =3D vhost_vq_init_access(vq);
> >                       if (ret)
> >                               goto err_vq;
> > @@ -547,14 +547,14 @@ static int vhost_vsock_start(struct vhost_vsock *=
vsock)
> >       return 0;
> >
> >  err_vq:
> > -     vq->private_data =3D NULL;
> > +     vhost_vq_set_backend_opaque(vq, NULL);
> >       mutex_unlock(&vq->mutex);
> >
> >       for (i =3D 0; i < ARRAY_SIZE(vsock->vqs); i++) {
> >               vq =3D &vsock->vqs[i];
> >
> >               mutex_lock(&vq->mutex);
> > -             vq->private_data =3D NULL;
> > +             vhost_vq_set_backend_opaque(vq, NULL);
> >               mutex_unlock(&vq->mutex);
> >       }
> >  err:
> > @@ -577,7 +577,7 @@ static int vhost_vsock_stop(struct vhost_vsock *vso=
ck)
> >               struct vhost_virtqueue *vq =3D &vsock->vqs[i];
> >
> >               mutex_lock(&vq->mutex);
> > -             vq->private_data =3D NULL;
> > +             vhost_vq_set_backend_opaque(vq, NULL);
> >               mutex_unlock(&vq->mutex);
> >       }
> >
> > --
> > 2.18.1
>

