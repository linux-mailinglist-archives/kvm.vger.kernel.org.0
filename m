Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD4ED3FEFC3
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 17:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhIBPBi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 11:01:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53335 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234375AbhIBPBh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Sep 2021 11:01:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630594839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NhX65RT1ifaHwGOlvzI1CW4C3zVZPOJhKK0Ufgw3iQA=;
        b=AltfSdXLJK+WZRlqSfErRdZLaPtlidHct3OZ8Tf0D8wyyuiHPwUCv2vHYS6M6Dl9VT7lE0
        g3drDdFBy3GDasoHcNFp2ApANDLuKuqdhZm/3Bb3m0GVCxbmQEj8FhpwjhEdcynkt3YKP4
        EVpvLVVRUx0327IbAKqBpfQnD0CEMsU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-q_HuT_iJNrmGjPs7czfHew-1; Thu, 02 Sep 2021 11:00:37 -0400
X-MC-Unique: q_HuT_iJNrmGjPs7czfHew-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC6E0100C60C;
        Thu,  2 Sep 2021 15:00:35 +0000 (UTC)
Received: from localhost (unknown [10.39.194.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 64D651AC7E;
        Thu,  2 Sep 2021 15:00:32 +0000 (UTC)
Date:   Thu, 2 Sep 2021 16:00:31 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, oren@nvidia.com, linux-block@vger.kernel.org,
        axboe@kernel.dk
Subject: Re: [PATCH 1/1] virtio-blk: remove unneeded "likely" statements
Message-ID: <YTDnD1c8rk3SWcx9@stefanha-x1.localdomain>
References: <20210830120111.22661-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wVBj43Tcb8AeCyD2"
Content-Disposition: inline
In-Reply-To: <20210830120111.22661-1-mgurtovoy@nvidia.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--wVBj43Tcb8AeCyD2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 30, 2021 at 03:01:11PM +0300, Max Gurtovoy wrote:
> Usually we use "likely/unlikely" to optimize the fast path. Remove
> redundant "likely" statements in the control path to ease on the code.
>=20
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> ---
>  drivers/block/virtio_blk.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

It would be nice to tweak the commit description before merging this. I
had trouble parsing the second sentence. If I understand correctly the
purpose of this patch is to make the code simpler and easier to read:

  s/ease on the code/simplify the code and make it easier to read/

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--wVBj43Tcb8AeCyD2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmEw5w8ACgkQnKSrs4Gr
c8jUHQf/VJ5hb++9DIHpheWC7yNi4OPiAS2B/1vypNz2ryOtT/6dEWtuLPgyw/fy
eD2d5GkdqujwQvl09h4esZpK1zVAdCj5J6L4R1m5RH6DqVG2GYnNzx1AdD8w0tgG
kMlizFNxPdlU6LSbJ+CPIky0FaleRbYEKjtUTJ9rjLwEYg9gCbEfZhR8dGt3jXca
tYM81eATEMjuUSa+G6tePeTUCuGX/zljWb+IjEfLONNy4cNWCfwY1+77iLDAf62q
bARLaXudlC/tyKjQguEF8GqvkvMRnYv9uQRV6YjpY6uchBaNh+X4kBF9XnQnBvtU
Nws0aRuTL+wQcNp9/vwVW9i6e+JFCQ==
=sHMp
-----END PGP SIGNATURE-----

--wVBj43Tcb8AeCyD2--

