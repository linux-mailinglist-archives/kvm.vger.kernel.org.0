Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4A13F482D
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 12:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232338AbhHWKFT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 06:05:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25692 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232144AbhHWKFS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Aug 2021 06:05:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629713075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vt2o0y6T/PidcpWu/Q2Vn+bKqtgu+iFP1bn5zMbE4Wo=;
        b=CxJgHcTdDCGrAcNP1BfyEhbXjFwX0+Zjvseny+xiSGl5Ejlx+QQmruBSUidLglvkMxDVdC
        3SrZjb1ThJXwdJj0qhx+CMr0BB6wu6e6FB0XG97Rm/WhbVDT1meUwuk6a93CjrMC6dzxqq
        /+kXr7Jpl1F3qVQL+4AUdL+MYjjqt8w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-SQxE48x9NB-gP2eBAC56NA-1; Mon, 23 Aug 2021 06:04:34 -0400
X-MC-Unique: SQxE48x9NB-gP2eBAC56NA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E19C0801A92;
        Mon, 23 Aug 2021 10:04:32 +0000 (UTC)
Received: from localhost (unknown [10.39.194.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D1F15D9D3;
        Mon, 23 Aug 2021 10:04:29 +0000 (UTC)
Date:   Mon, 23 Aug 2021 11:04:23 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        nab@daterainc.com
Subject: Re: [PATCH] vhost scsi: Convert to SPDX identifier
Message-ID: <YSNyp3VpgEgX/53I@stefanha-x1.localdomain>
References: <20210821123320.734-1-caihuoqing@baidu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6h2eKcyYkGGKJcwh"
Content-Disposition: inline
In-Reply-To: <20210821123320.734-1-caihuoqing@baidu.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--6h2eKcyYkGGKJcwh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 21, 2021 at 08:33:20PM +0800, Cai Huoqing wrote:
> use SPDX-License-Identifier instead of a verbose license text
>=20
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> ---
>  drivers/vhost/scsi.c | 14 +-------------
>  1 file changed, 1 insertion(+), 13 deletions(-)

I have CCed Nic.

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index 46f897e41217..532e204f2b1b 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -1,24 +1,12 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /***********************************************************************=
********
>   * Vhost kernel TCM fabric driver for virtio SCSI initiators
>   *
>   * (C) Copyright 2010-2013 Datera, Inc.
>   * (C) Copyright 2010-2012 IBM Corp.
>   *
> - * Licensed to the Linux Foundation under the General Public License (GP=
L) version 2.
> - *
>   * Authors: Nicholas A. Bellinger <nab@daterainc.com>
>   *          Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
>   ***********************************************************************=
*****/
> =20
>  #include <linux/module.h>
> --=20
> 2.25.1
>=20

--6h2eKcyYkGGKJcwh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmEjcqcACgkQnKSrs4Gr
c8huGgf9EGXjN0ece/7icZoSIWIeooKpfRYrOTF35aW6dhXKXoXO2NYFlTqmwI6b
nl3jRY4jGk3htjwg1Axp9Yvd781YY16jqkEOSHJ9jaq7TpC9H65EKDUMlmzKzIYK
LZnsQltlwjnksFZxZQas/oX6RyE6K27xaKGOA0wYRDrIzdo3rOlWJyY+m6VLnPVt
Qs6bV39ZGVnRZgM49LmBHZw/MMq8hcrpjacCTPzno1T5HS/1KjISVgIpBCg6nxUL
5DzKB+3UnW8M0ow8OOmxz+8WsuTq+dSmCYE2WSoYHPEjL+Rjci76RUIiXhHAguIO
m2dVbB4tYyR+rrFytQrORTOSVVMrxA==
=LmNU
-----END PGP SIGNATURE-----

--6h2eKcyYkGGKJcwh--

