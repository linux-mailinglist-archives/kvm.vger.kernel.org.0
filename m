Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC63E4CF59B
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 10:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237064AbiCGJaN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 04:30:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238458AbiCGJ3N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 04:29:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 26DA566FA8
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 01:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646645195;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G6zuLw2xFtTzT2CO4X/m2kFHpe+2zt7etCbaJPRh76U=;
        b=SxDd5DE8hILKHDX34Z6eocFEjiFcrxTP6v/kHbUna3Us2nJMmeHr2SCDxWsQgGT1B+MHC9
        WVW1ioevlEcOxxbUw/0APDUxw9RnjaRSAc38B048lJT8aNoTr4fZ6HCkbRq+2ChyfFc1Wp
        Q9bksSOn9EX1+m20zzyVLb+4ZlE0dr4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-4gWxIgl5Of-_wy-91_hrbw-1; Mon, 07 Mar 2022 04:26:32 -0500
X-MC-Unique: 4gWxIgl5Of-_wy-91_hrbw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 855B8835DE9;
        Mon,  7 Mar 2022 09:26:30 +0000 (UTC)
Received: from localhost (unknown [10.39.193.253])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 913EA7FCF0;
        Mon,  7 Mar 2022 09:25:58 +0000 (UTC)
Date:   Mon, 7 Mar 2022 09:25:45 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Sergio Lopez <slp@redhat.com>
Cc:     qemu-devel@nongnu.org, Matthew Rosato <mjrosato@linux.ibm.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>,
        Fam Zheng <fam@euphon.net>, kvm@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>, qemu-block@nongnu.org,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-s390x@nongnu.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        John G Johnson <john.g.johnson@oracle.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Jagannathan Raman <jag.raman@oracle.com>, vgoyal@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>
Subject: Re: [PATCH v4 0/4] Enable vhost-user to be used on BSD systems
Message-ID: <YiXPmahXN9aUyR/N@stefanha-x1.localdomain>
References: <20220304100854.14829-1-slp@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="E1RPB9JPYPPGj8HQ"
Content-Disposition: inline
In-Reply-To: <20220304100854.14829-1-slp@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--E1RPB9JPYPPGj8HQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 04, 2022 at 11:08:50AM +0100, Sergio Lopez wrote:
> Since QEMU is already able to emulate ioeventfd using pipefd, we're alrea=
dy
> pretty close to supporting vhost-user on non-Linux systems.
>=20
> This two patches bridge the gap by:
>=20
> 1. Adding a new event_notifier_get_wfd() to return wfd on the places where
>    the peer is expected to write to the notifier.
>=20
> 2. Modifying the build system to it allows enabling vhost-user on BSD.
>=20
> v1->v2:
>   - Drop: "Allow returning EventNotifier's wfd" (Alex Williamson)
>   - Add: "event_notifier: add event_notifier_get_wfd()" (Alex Williamson)
>   - Add: "vhost: use wfd on functions setting vring call fd"
>   - Rename: "Allow building vhost-user in BSD" to "configure, meson: allow
>     enabling vhost-user on all POSIX systems"
>   - Instead of making possible enabling vhost-user on Linux and BSD syste=
ms,
>     allow enabling it on all non-Windows platforms. (Paolo Bonzini)
>=20
> v2->v3:
>   - Add a section to docs/interop/vhost-user.rst explaining how vhost-user
>     is supported on non-Linux platforms. (Stefan Hajnoczi)
>=20
> v3->v4:
>   - Some documentation fixes. (Stefan Hajnoczi)
>   - Pick up Reviewed-by tags.
>=20
> Sergio Lopez (4):
>   event_notifier: add event_notifier_get_wfd()
>   vhost: use wfd on functions setting vring call fd
>   configure, meson: allow enabling vhost-user on all POSIX systems
>   docs: vhost-user: add subsection for non-Linux platforms
>=20
>  configure                     |  4 ++--
>  docs/interop/vhost-user.rst   | 20 ++++++++++++++++++++
>  hw/virtio/vhost.c             |  6 +++---
>  include/qemu/event_notifier.h |  1 +
>  meson.build                   |  2 +-
>  util/event_notifier-posix.c   |  5 +++++
>  6 files changed, 32 insertions(+), 6 deletions(-)
>=20
> --=20
> 2.35.1
>=20
>=20

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--E1RPB9JPYPPGj8HQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmIlz5kACgkQnKSrs4Gr
c8h+MggAvksCQVHckjPNZKCDFTTE6r2ZZA5gLLh27xZ3WjgwwGztCIVOPL48vHSt
rJpX4GVmQ/Sm/UzxtwjBw9s0UWlhRCnNwCGgVQOsoWzpkSbcT8GJ9CjlM/u++wvH
KANgmYr7dND2Sa/LchoD2zf3/89r+VJeBOq9qmIFUv30ZiBU6xslhpThYVUwqjeZ
4thRMM760mpmpkfSG9hPPcnHvCFXHssmOwYTLfkjm2ZO8haHoavVeiD6gnWqE3DK
UVOw2/sdTkutZpCgNggwHHJb4Kd7MZ+QTnzSlvmlOK23TPs5j828UqjoIdFu0PL3
wQaQwm8ok/xrRSkDKzAWeyn2wOIZ7w==
=YFmW
-----END PGP SIGNATURE-----

--E1RPB9JPYPPGj8HQ--

