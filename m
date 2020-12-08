Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE8382D26D4
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 10:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728646AbgLHJDk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 04:03:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728411AbgLHJDg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 04:03:36 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1925C061749
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 01:02:55 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id qw4so23521030ejb.12
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 01:02:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=heOnO8xtoXTUu7nkg7Tr0zoCny6XJ7I7y8VFkwKx3YI=;
        b=NAcUA4g6FpMBOE1Xlxt2Q1ElVyu7anh6kb/qyZlxlLM2F5boiqCY7XXrG73lLkjkTO
         G24s2g422BaJZe7uWJWbXmCoKCwFQGB7nP3ln4yb+t0aO74TxgVEvBrAK+i6Lg6p4ZRx
         4o+Nc01KscoeDYfhWOgT8Jke8eZgxT/e8fyJ9To8vxOA6OyyIKLwsBuznaAOAmwlcGmo
         1BePba9ADIsphBcP16NjyMjxqjyGLJLp4qwcAPlebCigeVxX5uR6f5HANjd0HIzTIgBH
         veF5YLY0e8cNXIPT+nO7CAqZ86TDl6IKWGH5eimx+JDkHCnAQWSJJQMO9G74fjFcjVhX
         t/GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=heOnO8xtoXTUu7nkg7Tr0zoCny6XJ7I7y8VFkwKx3YI=;
        b=TOUE9kWQtexwmroMU2GjHIuswyAXQjPFrGKPL35MX2RPoQhzT0HCLBufbV8H8stqZ3
         VnL6uhWOb3Gp6dqoR7Qw+DqvjYKJ/kgP/YboS6pK++per2PvMy/MD1ukNrd3OEfbJcEL
         9IATvYa0sloNHcW4no4fZIiIkz3Ol+q+R4M+KX5h9RIdevvU1egVJCg0M6I4B1+l/m0W
         DqpV+RkdffYex6SXtrX9fd19AC8/1yFgDccTpKvBYMvJey8DQwx7FNvySjdwi3PZnOv+
         2zlHnccGdU9ql8l2SbRNfOxB64FXo/PFn2qYpeDEJVgqzIOLrz/3/YpuOM/bRhWhCgMF
         uxDA==
X-Gm-Message-State: AOAM530zkPg02PtKUgnR8waZAqiz/ri0vjN1xmCbRg5g2MpQ603fnoKH
        mpSxl8MoPoy/0//sui3C+wE=
X-Google-Smtp-Source: ABdhPJwwqplxjiYTxGvk+CUu6nv9Om15+cCcDhpuWLQyJld3SKfxflSD8GOU2YNR5fW6/sN9mUvT0g==
X-Received: by 2002:a17:906:4d52:: with SMTP id b18mr21499156ejv.405.1607418174634;
        Tue, 08 Dec 2020 01:02:54 -0800 (PST)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id x16sm6694407ejb.38.2020.12.08.01.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 01:02:53 -0800 (PST)
Date:   Tue, 8 Dec 2020 09:02:52 +0000
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
Subject: Re: [RFC PATCH 24/27] vhost: iommu changes
Message-ID: <20201208090252.GW203660@stefanha-x1.localdomain>
References: <20201120185105.279030-1-eperezma@redhat.com>
 <20201120185105.279030-25-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="pEAjBjStGYT6H+Py"
Content-Disposition: inline
In-Reply-To: <20201120185105.279030-25-eperezma@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--pEAjBjStGYT6H+Py
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2020 at 07:51:02PM +0100, Eugenio P=E9rez wrote:
> diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
> index eebfac4455..cb44b9997f 100644
> --- a/hw/virtio/vhost.c
> +++ b/hw/virtio/vhost.c
> @@ -1109,6 +1109,10 @@ static int vhost_sw_live_migration_start(struct vh=
ost_dev *dev)
> =20
>      assert(dev->vhost_ops->vhost_set_vring_enable);
>      dev->vhost_ops->vhost_set_vring_enable(dev, false);
> +    if (vhost_dev_has_iommu(dev)) {
> +        r =3D vhost_backend_invalidate_device_iotlb(dev, 0, -1ULL);
> +        assert(r =3D=3D 0);
> +    }
> =20
>      for (idx =3D 0; idx < dev->nvqs; ++idx) {
>          struct vhost_virtqueue *vq =3D &dev->vqs[idx];
> @@ -1269,6 +1273,19 @@ int vhost_device_iotlb_miss(struct vhost_dev *dev,=
 uint64_t iova, int write)
> =20
>      trace_vhost_iotlb_miss(dev, 1);
> =20
> +    if (dev->sw_lm_enabled) {
> +        uaddr =3D iova;
> +        len =3D 4096;
> +        ret =3D vhost_backend_update_device_iotlb(dev, iova, uaddr, len,
> +                                                IOMMU_RW);

It would be nice to look up the available memory so
vhost_backend_update_device_iotlb() can be called with a much bigger
[uaddr, uaddr+len) range. This will reduce the number of iotlb misses.

Will vIOMMU be required for this feature? If not, then the vring needs
to be added to the vhost memory regions because vhost will not send QEMU
iotlb misses.

--pEAjBjStGYT6H+Py
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/PQTwACgkQnKSrs4Gr
c8g3Ggf/ezALRa8CClAoD8oR71XoA1kVIcse2cg110kSgP3P6FQZ4K8P3eagY4KQ
MZOEBk/dhIcMAMUhqDGhKvCOgFzp4rxXGLJWWpVRqWXnyt+3pbt+qbRN1K6Mnw5m
yYr0IR/vdzG0tDl7Oy5n5igf8gbTiNAiO82jgonHy6KLiw8vhEqB/fdBVQOjorQn
4QbiOck2C58BSE+8G7iXFHCJWtoQd0O3zIgxDGsecDrDZYIP3RKcpd3EQfXUKDgc
8pESaRJsNfEfiM485waNw2fA9C4cV9tkWe9qup607f1Hgj6qw+1/Wboy+y4A86B2
0RfBLz7wh4oXLsoYnD1JLzTW2e3qXw==
=ebuW
-----END PGP SIGNATURE-----

--pEAjBjStGYT6H+Py--
