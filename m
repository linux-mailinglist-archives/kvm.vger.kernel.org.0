Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8362E41DACF
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 15:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350868AbhI3NTA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 09:19:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33966 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350892AbhI3NSx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Sep 2021 09:18:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633007831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ub2cuF6uoFeoONiyB+zLFzfZqc8TQZ4SekwA42Xxx5o=;
        b=G8NXWksxpp/vL6GfYRmDFy/mXJLlqJlqraWo4fConRQrVOTg4R5xIIKkG/ZChMHC2Xtar4
        RnRmRGR7REFzATjFs1Bnw9ohqmVcrrd2d9k3uw2CrwIXNLAHMXmDzLTvoXc+Ykv9kuHRSG
        9nfyUvGztkl6aZLmk6Wjj+B+2Apn7ZI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-116-ELitbxyHMQ6EYqaJ2AMj5Q-1; Thu, 30 Sep 2021 09:17:09 -0400
X-MC-Unique: ELitbxyHMQ6EYqaJ2AMj5Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C5857801B3D;
        Thu, 30 Sep 2021 13:17:07 +0000 (UTC)
Received: from localhost (unknown [10.39.195.132])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 245F860657;
        Thu, 30 Sep 2021 13:16:56 +0000 (UTC)
Date:   Thu, 30 Sep 2021 14:16:56 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, oren@nvidia.com, nitzanc@nvidia.com,
        israelr@nvidia.com, hch@infradead.org, linux-block@vger.kernel.org,
        axboe@kernel.dk
Subject: Re: [PATCH 2/2] virtio-blk: set NUMA affinity for a tagset
Message-ID: <YVW4yIkWWEUMsBLp@stefanha-x1.localdomain>
References: <20210926145518.64164-1-mgurtovoy@nvidia.com>
 <20210926145518.64164-2-mgurtovoy@nvidia.com>
 <YVF8RBZSaJs9BScd@stefanha-x1.localdomain>
 <21295187-41c4-5fb6-21c3-28004eb7c5d8@nvidia.com>
 <YVK6hdcrXwQHrXQ9@stefanha-x1.localdomain>
 <f15e1115-25c1-5b9a-223c-db122251d4c1@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="IKMqPhUCzPj7W18T"
Content-Disposition: inline
In-Reply-To: <f15e1115-25c1-5b9a-223c-db122251d4c1@nvidia.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--IKMqPhUCzPj7W18T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 29, 2021 at 06:07:52PM +0300, Max Gurtovoy wrote:
>=20
> On 9/28/2021 9:47 AM, Stefan Hajnoczi wrote:
> > On Mon, Sep 27, 2021 at 08:39:30PM +0300, Max Gurtovoy wrote:
> > > On 9/27/2021 11:09 AM, Stefan Hajnoczi wrote:
> > > > On Sun, Sep 26, 2021 at 05:55:18PM +0300, Max Gurtovoy wrote:
> > > > > To optimize performance, set the affinity of the block device tag=
set
> > > > > according to the virtio device affinity.
> > > > >=20
> > > > > Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> > > > > ---
> > > > >    drivers/block/virtio_blk.c | 2 +-
> > > > >    1 file changed, 1 insertion(+), 1 deletion(-)
> > > > >=20
> > > > > diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_bl=
k.c
> > > > > index 9b3bd083b411..1c68c3e0ebf9 100644
> > > > > --- a/drivers/block/virtio_blk.c
> > > > > +++ b/drivers/block/virtio_blk.c
> > > > > @@ -774,7 +774,7 @@ static int virtblk_probe(struct virtio_device=
 *vdev)
> > > > >    	memset(&vblk->tag_set, 0, sizeof(vblk->tag_set));
> > > > >    	vblk->tag_set.ops =3D &virtio_mq_ops;
> > > > >    	vblk->tag_set.queue_depth =3D queue_depth;
> > > > > -	vblk->tag_set.numa_node =3D NUMA_NO_NODE;
> > > > > +	vblk->tag_set.numa_node =3D virtio_dev_to_node(vdev);
> > > > >    	vblk->tag_set.flags =3D BLK_MQ_F_SHOULD_MERGE;
> > > > >    	vblk->tag_set.cmd_size =3D
> > > > >    		sizeof(struct virtblk_req) +
> > > > I implemented NUMA affinity in the past and could not demonstrate a
> > > > performance improvement:
> > > > https://lists.linuxfoundation.org/pipermail/virtualization/2020-Jun=
e/048248.html
> > > >=20
> > > > The pathological case is when a guest with vNUMA has the virtio-blk=
-pci
> > > > device on the "wrong" host NUMA node. Then memory accesses should c=
ross
> > > > NUMA nodes. Still, it didn't seem to matter.
> > > I think the reason you didn't see any improvement is since you didn't=
 use
> > > the right device for the node query. See my patch 1/2.
> > That doesn't seem to be the case. Please see
> > drivers/base/core.c:device_add():
> >=20
> >    /* use parent numa_node */
> >    if (parent && (dev_to_node(dev) =3D=3D NUMA_NO_NODE))
> >            set_dev_node(dev, dev_to_node(parent));
> >=20
> > IMO it's cleaner to use dev_to_node(&vdev->dev) than to directly access
> > the parent.
> >=20
> > Have I missed something?
>=20
> but dev_to_node(dev) is 0 IMO.
>=20
> who set it to NUMA_NO_NODE ?

drivers/virtio/virtio.c:register_virtio_device():

  device_initialize(&dev->dev);

drivers/base/core.c:device_initialize():

  set_dev_node(dev, -1);

Stefan

--IKMqPhUCzPj7W18T
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmFVuMgACgkQnKSrs4Gr
c8ie0AgAk1gREryODkpkpku94YvDaPnLrUsaDjpYIUT5SIDf1VzYzzYFQF6Gqv90
6xfbA76qc9yVtFEs3WY/pCeCasVX2AHrTrqyu6aacIrmMtHgE6ha5Qroyik0KJe9
0E2LIcjMCB/D6zOQCGPmNeaYJzczdKYf2S7e0Sjf6u5ziDMaOMnJilZYXEJBcOll
urEzjQhWuqwBX1NVYOk4pc9+Twvboo5L++7au82DPa/h92vYx7q+UeLFEjrp/lbd
OssLss9CMFMMVoR27LL45I11W/4EnRjDslkkARKLXJeUevxUYyIdQDLy9bZTN4tX
7+5a0eDo2g4nVGAS+tUJ2Et0x0u2HA==
=/Lgo
-----END PGP SIGNATURE-----

--IKMqPhUCzPj7W18T--

