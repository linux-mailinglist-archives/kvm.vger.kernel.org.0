Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 619FC30C2DE
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 16:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234894AbhBBPBy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 10:01:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48876 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232810AbhBBPBU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 10:01:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612277988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/nqgkmwEUBwFXFP1lcLQvcaHEBrgIYTBqrD9vTkcUJA=;
        b=HwHT1vsezS286M4X9t14W8sfSWBrYx4p7zgnwukWo8qA8hd23Faj67u0USfgea0FK6iE3j
        8Kc7BxujEMUZ3kQ8+hR1i7H91uU0dtlbS4Y4Dq0dv+bMuRexKYcf4zsmlCqYKcPQx0fmzd
        jCkQBVJdnuIoyp0KQCrevKroXpTgEXQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-6s0xieiNOxuNgw70t6dwzA-1; Tue, 02 Feb 2021 09:59:44 -0500
X-MC-Unique: 6s0xieiNOxuNgw70t6dwzA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B155BAFA82;
        Tue,  2 Feb 2021 14:59:43 +0000 (UTC)
Received: from localhost (ovpn-115-185.ams2.redhat.com [10.36.115.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 660F219C71;
        Tue,  2 Feb 2021 14:59:40 +0000 (UTC)
Date:   Tue, 2 Feb 2021 09:41:57 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Xie Yongji <xieyongji@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        linux-kernel@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH RFC v2 09/10] vdpa_sim_blk: implement ramdisk behaviour
Message-ID: <20210202094157.GB243557@stefanha-x1.localdomain>
References: <20210128144127.113245-1-sgarzare@redhat.com>
 <20210128144127.113245-10-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="XOIedfhf+7KOe/yw"
Content-Disposition: inline
In-Reply-To: <20210128144127.113245-10-sgarzare@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--XOIedfhf+7KOe/yw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 28, 2021 at 03:41:26PM +0100, Stefano Garzarella wrote:
> The previous implementation wrote only the status of each request.
> This patch implements a more accurate block device simulator,
> providing a ramdisk-like behavior.
>=20
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
> v2:
> - used %zd %zx to print size_t and ssize_t variables in dev_err()
> - removed unnecessary new line [Jason]
> - moved VIRTIO_BLK_T_GET_ID in another patch [Jason]
> - used push/pull instead of write/read terminology
> - added vdpasim_blk_check_range() to avoid overflows [Stefan]
> - use vdpasim*_to_cpu instead of le*_to_cpu
> - used vringh_kiov_length() helper [Jason]
> ---
>  drivers/vdpa/vdpa_sim/vdpa_sim_blk.c | 164 ++++++++++++++++++++++++---
>  1 file changed, 146 insertions(+), 18 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--XOIedfhf+7KOe/yw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAZHmQACgkQnKSrs4Gr
c8i2cwgAnejUJEOfV7h1JLqKBGsbMZ8G/rYq5Tpn2NYeHH+hHKUzJuYhhiy6A/dc
ApoMhiK73jMGntzRVlchJ9EzLdG3mWp1fV7nDHb3jfSefPaMn/+sqHpRte3gAtp5
6qRPQg86qq2acmxReSwEuLADmwkQ9IEfUobw+9Eh8eaL8Fam79/brxgeAi+jyTUi
Y6fHt/8yCLtpz+gp2FqWtmN0COcu6C6/I9yDwfIyhmn1jUtO7O8MUBDTEmOuY+TC
41AXprR3YIHGnEzaDphoqwmSN7NyWTmvQScwFA2HPDgVWe4VksizaICwg/Iz0IWD
lND4h139qSBuLPJKWi/2ReukfLcOjw==
=DBTx
-----END PGP SIGNATURE-----

--XOIedfhf+7KOe/yw--

