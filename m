Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 199322D246E
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 08:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbgLHHfa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 02:35:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbgLHHfa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 02:35:30 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF21CC061749
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 23:34:49 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id ga15so23248329ejb.4
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 23:34:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KDNQai3ANvzHnuzmpGlNQLHSGL47jHO8xbQVoARcp+Y=;
        b=Ql2AB5GySJ65IFMHnw4MwFF+6A1fSxUbm0S/QCOsRh1e9K/RdvI9O9Yt/4u9lp/8zU
         WXpOxpcxkqc0ECWU/gBhCpde+JT2de7S+dnMJ/ThfJ2V2LjxOF40eH+xPBzu+Q/qIrx+
         IwJMliL/zNWO3P9FiZ3xRymHceBHcF2+A/XrgHm9IFQRlZCouH6KOsfRn0s5kND6IZsW
         ogcY6Q8BQynWXyWAzonWHDSrCT8Sypi5HvX/2Vh7p2n6UQ6hmXMEakUREVC0a87Bb0xI
         dc7Jx8nAnn6wruao79UPpFzmcbZp7kLhkcFlYOKujv5rwvsUxw/3IHEMFG9ts7W0/Zd7
         gtMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KDNQai3ANvzHnuzmpGlNQLHSGL47jHO8xbQVoARcp+Y=;
        b=iQ1HTgoCMIQ6LpmTCyvifQxdyB95nUwZW9YVao1wSMtXkfzctMzcM0HMXSw5eE5dK/
         ZnLUgjH1MHDqYt0EVHk5B0PoESADyKXdN4rmJO/buk1ReoYBjxxprDYYPWmXSeOB+7HG
         qFsiNVzo5p1pt8DcCPlGll+qsINNvPubeVRwEb/o+tsyZWECD22fFWSmT7cZ6ixkUPAz
         SaKNZnVlR+73ZZ02Q3mrgfNb5NHzmHaOt7IfU8Alt4Aw+e6cZ22CT9ZCZatb9IPvv1z0
         TE+wqPrJYS+Q9UmDEqwpcywzbj9y6MNSkxJRq668roeDDxpIJCUb1cRhWk/F5PkbAKcY
         5RnQ==
X-Gm-Message-State: AOAM532NyBjjDCvgQXpA1Evz3Tdtc3iHr3tyV9GFmlvZq7ihDQU4fp7u
        dP+7EEZEZthd+87veG9SPE8=
X-Google-Smtp-Source: ABdhPJyAJ58CckXILtlZ1T1LSuVkaaFCXE8XFbVwePtP2qOXF2umzTx1ojn2UCAcCz94h+QkAZmFtg==
X-Received: by 2002:a17:907:444f:: with SMTP id on23mr22557982ejb.300.1607412888472;
        Mon, 07 Dec 2020 23:34:48 -0800 (PST)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id mb15sm14605264ejb.9.2020.12.07.23.34.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 23:34:47 -0800 (PST)
Date:   Tue, 8 Dec 2020 07:34:46 +0000
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
Cc:     qemu-devel@nongnu.org, Lars Ganrot <lars.ganrot@gmail.com>,
        virtualization@lists.linux-foundation.org,
        Salil Mehta <mehta.salil.lnk@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Liran Alon <liralon@gmail.com>,
        Rob Miller <rob.miller@broadcom.com>,
        Max Gurtovoy <maxgu14@gmail.com>,
        Alex Barba <alex.barba@broadcom.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jim Harford <jim.harford@broadcom.com>,
        Jason Wang <jasowang@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Christophe Fontaine <cfontain@redhat.com>,
        vm <vmireyno@marvell.com>, Daniel Daly <dandaly0@gmail.com>,
        Michael Lilja <ml@napatech.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Nitin Shrivastav <nitin.shrivastav@broadcom.com>,
        Lee Ballard <ballle98@gmail.com>,
        Dmytro Kazantsev <dmytro.kazantsev@gmail.com>,
        Juan Quintela <quintela@redhat.com>, kvm@vger.kernel.org,
        Howard Cai <howard.cai@gmail.com>,
        Xiao W Wang <xiao.w.wang@intel.com>,
        Sean Mooney <smooney@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Eli Cohen <eli@mellanox.com>, Siwei Liu <loseweigh@gmail.com>,
        Stephen Finucane <stephenfin@redhat.com>
Subject: Re: [RFC PATCH 09/27] vhost: Route host->guest notification through
 qemu
Message-ID: <20201208073446.GP203660@stefanha-x1.localdomain>
References: <20201120185105.279030-1-eperezma@redhat.com>
 <20201120185105.279030-10-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="CKf/2jVYos1l2hij"
Content-Disposition: inline
In-Reply-To: <20201120185105.279030-10-eperezma@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--CKf/2jVYos1l2hij
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2020 at 07:50:47PM +0100, Eugenio P=E9rez wrote:
> Signed-off-by: Eugenio P=E9rez <eperezma@redhat.com>
> ---
>  hw/virtio/vhost-sw-lm-ring.c |  3 +++
>  hw/virtio/vhost.c            | 20 ++++++++++++++++++++
>  2 files changed, 23 insertions(+)

I'm not sure I understand what is going here. The guest notifier masking
feature exists to support MSI masking semantics. It looks like this
patch repurposes the notifier to decouple the vhost hdev from the virtio
device's irqfd? But this breaks MSI masking. I think you need to set up
your own eventfd and assign it to the vhost hdev's call fd instead of
using the mask notifier.

>=20
> diff --git a/hw/virtio/vhost-sw-lm-ring.c b/hw/virtio/vhost-sw-lm-ring.c
> index 0192e77831..cbf53965cd 100644
> --- a/hw/virtio/vhost-sw-lm-ring.c
> +++ b/hw/virtio/vhost-sw-lm-ring.c
> @@ -50,6 +50,9 @@ VhostShadowVirtqueue *vhost_sw_lm_shadow_vq(struct vhos=
t_dev *dev, int idx)
>      r =3D dev->vhost_ops->vhost_set_vring_kick(dev, &file);
>      assert(r =3D=3D 0);
> =20
> +    vhost_virtqueue_mask(dev, dev->vdev, idx, true);
> +    vhost_virtqueue_pending(dev, idx);

Why is the mask notifier cleared? Could we lose a guest notification
here?

> +
>      return svq;
>  }
> =20
> diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
> index 1d55e26d45..9352c56bfa 100644
> --- a/hw/virtio/vhost.c
> +++ b/hw/virtio/vhost.c
> @@ -960,12 +960,29 @@ static void handle_sw_lm_vq(VirtIODevice *vdev, Vir=
tQueue *vq)
>      vhost_vring_kick(svq);
>  }
> =20
> +static void vhost_handle_call(EventNotifier *n)
> +{
> +    struct vhost_virtqueue *hvq =3D container_of(n,
> +                                              struct vhost_virtqueue,
> +                                              masked_notifier);
> +    struct vhost_dev *vdev =3D hvq->dev;
> +    int idx =3D vdev->vq_index + (hvq =3D=3D &vdev->vqs[0] ? 0 : 1);

vhost-net-specific hack

> +    VirtQueue *vq =3D virtio_get_queue(vdev->vdev, idx);
> +
> +    if (event_notifier_test_and_clear(n)) {
> +        virtio_queue_invalidate_signalled_used(vdev->vdev, idx);
> +        virtio_notify_irqfd(vdev->vdev, vq);

/* TODO push used elements into vq? */

--CKf/2jVYos1l2hij
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/PLJYACgkQnKSrs4Gr
c8j+8gf+OhTHgPK0WzErs2NE4d0Ejs/ALV8z04626r9RXEFYC2Dmt4SiTUraP6EZ
P9Y5q2kAblCrBmheQQumXy/5QrGI1I/FCEtxRA1HFtSTfw8rElmzyKKMlv0I+aLY
06411eTjLH7Zcbw0DXBoCq/D34+j3B4s1XZK/sMWOtPofAxgzEAs24h+pmhkmHMz
y7vx211Io+dCP1BFJygv99K9fkMz3ZPYP9x9EBd49ySIaaIUQzEO+0knT1hVgd3w
28S8DYYxyu1XIrang6jbi9qxidnxf0VI1AhaibRWbBSYIrZeioGSeVUmJl32LrBR
fqt3IvJyBw52U11v0zbmStbzogfVOA==
=xYDv
-----END PGP SIGNATURE-----

--CKf/2jVYos1l2hij--
