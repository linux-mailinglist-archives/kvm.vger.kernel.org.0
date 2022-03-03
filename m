Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5B194CC00F
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 15:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbiCCOgR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 09:36:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiCCOgQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 09:36:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 276D718E408
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 06:35:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646318130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fbMp/osdXrbtmQKZQG+gFlfsChHZaiPWRw8JRmKvmBY=;
        b=cr+8KpWo18lD04kSKEPxs0bKPGmc5cSyRx55DMgTN1RrbB3SBW7e45S+QuQ3ySRIiVEXVQ
        R569eASaI/1WxNaIjuKuQlvhXuB04SbQKsh/V/sh3nulNU7aBo7CrBOxAqOrhjhccCuHY+
        R3/3DnuRaMeeRfvVz/ZTIR20jLDdHnE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-341-yUGR4HvmN3egBnDEWX34gg-1; Thu, 03 Mar 2022 09:35:27 -0500
X-MC-Unique: yUGR4HvmN3egBnDEWX34gg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 393FF835DE0;
        Thu,  3 Mar 2022 14:35:25 +0000 (UTC)
Received: from localhost (unknown [10.39.194.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D22DB7C023;
        Thu,  3 Mar 2022 14:34:39 +0000 (UTC)
Date:   Thu, 3 Mar 2022 14:34:34 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Sergio Lopez <slp@redhat.com>
Cc:     qemu-devel@nongnu.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        kvm@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Fam Zheng <fam@euphon.net>,
        John G Johnson <john.g.johnson@oracle.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>,
        qemu-s390x@nongnu.org, vgoyal@redhat.com,
        Jagannathan Raman <jag.raman@oracle.com>,
        Kevin Wolf <kwolf@redhat.com>, qemu-block@nongnu.org,
        Eric Farman <farman@linux.ibm.com>
Subject: Re: [PATCH v3 4/4] docs: vhost-user: add subsection for non-Linux
 platforms
Message-ID: <YiDR+u76HLeaOTi5@stefanha-x1.localdomain>
References: <20220303115911.20962-1-slp@redhat.com>
 <20220303115911.20962-5-slp@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xlV0CQk1kqL67PjT"
Content-Disposition: inline
In-Reply-To: <20220303115911.20962-5-slp@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--xlV0CQk1kqL67PjT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 03, 2022 at 12:59:11PM +0100, Sergio Lopez wrote:
> Add a section explaining how vhost-user is supported on platforms
> other than Linux.
>=20
> Signed-off-by: Sergio Lopez <slp@redhat.com>
> ---
>  docs/interop/vhost-user.rst | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>=20
> diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
> index edc3ad84a3..590a626b92 100644
> --- a/docs/interop/vhost-user.rst
> +++ b/docs/interop/vhost-user.rst
> @@ -38,6 +38,24 @@ conventions <backend_conventions>`.
>  *Master* and *slave* can be either a client (i.e. connecting) or
>  server (listening) in the socket communication.
> =20
> +Support for platforms other than Linux
> +--------------------------------------
> +
> +While vhost-user was initially developed targeting Linux, nowadays is

s/is/it is/

> +supported on any platform that provides the following features:
> +
> +- The ability to share a mapping injected into the guest between
> +  multiple processes, so both QEMU and the vhost-user daemon servicing
> +  the device can access simultaneously the memory regions containing
> +  the virtqueues and the data associated with each request.

Please generalize this statement since there are other vhost-user
protocol features aside from guest RAM access that involve shared
memory:
1. VHOST_USER_SET_LOG_BASE
2. VHOST_USER_SET_INFLIGHT_FD

The exact requirement is:

  The vhost-user protocol relies on shared memory represented by a file
  descriptor so it can be passed over a UNIX domain socket and then
  mapped by the other process.

> +
> +- AF_UNIX sockets with SCM_RIGHTS, so QEMU can communicate with the
> +  vhost-user daemon and send it file descriptors when needed.
> +
> +- Either eventfd or pipe/pipe2. On platforms where eventfd is not
> +  available, QEMU will automatically fallback to pipe2 or, as a last

The noun is "fallback", the verb form is "fall back":
s/fallback/fall back/

It's worth mentioning that events are sent over pipe fds by writing an
8-byte value. The 8-byte value has no meaning and should not be
interpreted.

--xlV0CQk1kqL67PjT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmIg0foACgkQnKSrs4Gr
c8iyIwf5AXwYmNsSKaWRTXuqaGB80K0YsAtK7xDq9CNFNPYCIw6ujWqc2lL5BOhU
5LMnzPFM4SwFKXXQLjg49xg243nblZySvUY6IaV3Zo49m2DW7m83qmwt63+TmKdh
ahvmzw5R+uvYLQ/7HA/Y117Lc2Avxedpj4lCWKMFzogCVU0DZzvQKoCdr/1Efa/3
4ZMeJ6WQUhzqatQmIkhD63V6fpEIuxQ3mkJP0AGA4S3SPmUe4+Fiht9ulLtPV7ZX
r1o0mgwtxho/Nm0KXuCKR9OyVd2eqlmM9IrxoR6UK7a6ALVKI7YMJ4gCW1UZzska
z3CV3kUJQDKxuprkI8Ro7EOJi59HWA==
=h/kO
-----END PGP SIGNATURE-----

--xlV0CQk1kqL67PjT--

