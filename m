Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D63B530C2E2
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 16:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234656AbhBBPCw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 10:02:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21236 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234847AbhBBPBh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 10:01:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612277992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kKeX0URGSb9UCbr0adu7KmORKEcxZbdiukW8R2TM+Cc=;
        b=O6YryjW1GbipyfADUR5Tlplum4cHMHaD/ZKXpzolx4Tes36as+ubVvc69i+Ft8KS6fVejW
        +gJRgwrlTKYMI7plhSLpBMnkiI0H2dx8KMrW+508MvhRZu0t/6sDM3pi90ucmCIpea7Y1K
        v9bTUu6egq+3Od2dO4Fof0LrD2OkiIs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-46-nsEX7khMPdmLOTnwF69CDw-1; Tue, 02 Feb 2021 09:59:49 -0500
X-MC-Unique: nsEX7khMPdmLOTnwF69CDw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 38F00809DCC;
        Tue,  2 Feb 2021 14:59:48 +0000 (UTC)
Received: from localhost (ovpn-115-185.ams2.redhat.com [10.36.115.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA4535C1CF;
        Tue,  2 Feb 2021 14:59:44 +0000 (UTC)
Date:   Tue, 2 Feb 2021 09:44:09 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Xie Yongji <xieyongji@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        linux-kernel@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH RFC v2 10/10] vdpa_sim_blk: handle VIRTIO_BLK_T_GET_ID
Message-ID: <20210202094409.GC243557@stefanha-x1.localdomain>
References: <20210128144127.113245-1-sgarzare@redhat.com>
 <20210128144127.113245-11-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vOmOzSkFvhd7u8Ms"
Content-Disposition: inline
In-Reply-To: <20210128144127.113245-11-sgarzare@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--vOmOzSkFvhd7u8Ms
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 28, 2021 at 03:41:27PM +0100, Stefano Garzarella wrote:
> Handle VIRTIO_BLK_T_GET_ID request, always answering the
> "vdpa_blk_sim" string.
>=20
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
> v2:
> - made 'vdpasim_blk_id' static [Jason]
> ---
>  drivers/vdpa/vdpa_sim/vdpa_sim_blk.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--vOmOzSkFvhd7u8Ms
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAZHukACgkQnKSrs4Gr
c8h6vwf6A8s+B0nRtzSJR6MXg9BA+xRNjCAn+XG2vIbw9UN3xOfy+bfM45Tnz58C
xdQzu+yQ6QJHdSaln3x1mXh8akmyIPNOCdPbCAarLIlART4VdlJyXL6PKUxKsVkr
gDxqCm+TFlZiFBx4ggoJcqnf394m9jQBVXHq4WBSS0CM+aETJaAD+4yKgT0Zl/C6
k0WXDgoZi+qWatdmTu8ReIPWsSNcWgx25ZCaW+wnXwE3lfrGLB2evVLlc7dVXRn8
Mf0BMYql/WQUD09a3G5XOlOSxeW28lXzeFhYnm4j8/yT+RSCrLmjkrxyIbz+mkf7
beNfB4Tg0kc3+Pw0DV1RNv6v+X9tKw==
=wZsq
-----END PGP SIGNATURE-----

--vOmOzSkFvhd7u8Ms--

