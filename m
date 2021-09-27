Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38204419054
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 10:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233340AbhI0IEP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 04:04:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23128 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233326AbhI0IEN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Sep 2021 04:04:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632729755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WYdrd60a/bnHP4r9+0eIKSKk9RqPVq0ho2CMR0yVDMk=;
        b=Pc3ZpAlRSzUglsnr6orz2GXDJsMDEdecY7MfB+O1laZN0OBNHx2IY4HfTdTkMkvFGNAt+H
        xp4mDyBWnaIf8aLHzMQvdIhNkiuB89JUOQ3RPyFStpQhjxZIqdZqekx2sKmH92CN4Pzs4r
        fne3ohOhJxtxPI/0onRuSsj9Mrm0/hE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-565-E-PhM04ZMqS7zs1XRnhvbA-1; Mon, 27 Sep 2021 04:02:32 -0400
X-MC-Unique: E-PhM04ZMqS7zs1XRnhvbA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 96E88100CCC6;
        Mon, 27 Sep 2021 08:02:30 +0000 (UTC)
Received: from localhost (unknown [10.39.192.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9A84160C13;
        Mon, 27 Sep 2021 08:02:21 +0000 (UTC)
Date:   Mon, 27 Sep 2021 10:02:20 +0200
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, oren@nvidia.com, nitzanc@nvidia.com,
        israelr@nvidia.com, hch@infradead.org, linux-block@vger.kernel.org,
        axboe@kernel.dk
Subject: Re: [PATCH 1/2] virtio: introduce virtio_dev_to_node helper
Message-ID: <YVF6jOfF7sqWWiBl@stefanha-x1.localdomain>
References: <20210926145518.64164-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4fVC5S2hVXKz+qy4"
Content-Disposition: inline
In-Reply-To: <20210926145518.64164-1-mgurtovoy@nvidia.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--4fVC5S2hVXKz+qy4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 26, 2021 at 05:55:17PM +0300, Max Gurtovoy wrote:
> Also expose numa_node field as a sysfs attribute. Now virtio device
> drivers will be able to allocate memory that is node-local to the
> device. This significantly helps performance and it's oftenly used in
> other drivers such as NVMe, for example.
>=20
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> ---
>  drivers/virtio/virtio.c | 10 ++++++++++
>  include/linux/virtio.h  | 13 +++++++++++++
>  2 files changed, 23 insertions(+)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--4fVC5S2hVXKz+qy4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmFReocACgkQnKSrs4Gr
c8gT+QgAg0wer2CY+2rCDIWjcsfv8yyqVsHfHaJ9TLzdC+6JHfOmPuyD99Fx8FzQ
TbExtXhcMxGkHXDcOrH6Zn2Z/l6B8ki2htsnlVXM6O6eu6xvZ6AHl1g/DDxIqERQ
iQ9IRW9PzjsI0X3vCGuBFk9/R+O7OW9WYOi486lAJpflkUt+YEl/1LZ7uebwiBC8
2fv8WaBYmjKMpsLC624qer0MHB7JNQCXOl6BjUvi0biYe28w03WKaVH2N9cPVVzF
GoVCfCSuKGxdn8i2VdzYNdXAmkSlkYBHGKc/XfW6rZMaJ56YGlcE+cfiuwcs9P5U
Ep65hjfmwiGrb94XyDrmov2vIaGlhQ==
=Ex/F
-----END PGP SIGNATURE-----

--4fVC5S2hVXKz+qy4--

