Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70F614CD2C1
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 11:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238020AbiCDKvT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 05:51:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233928AbiCDKvS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 05:51:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E126C41F86
        for <kvm@vger.kernel.org>; Fri,  4 Mar 2022 02:50:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646391030;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BSTaLr+NvfDXVC5SCfeAPB5Wqc0CyU+6cZPlDm/2vsM=;
        b=Za3pkpDxnC83OOyIRY3a/0LCaEFDlOEODa7eGO0OudC/Q60Y4BCi/wQU63w4fQti6ik1va
        Lf43hMeuUyE3AzxSF6rXUxGfoZeU0K+RIXbI/M4GcsvwtjwpqjFtGP3r4/KcWmjNBWzNP2
        yISXbwjpdwKxL911y8b+E5Tq8dvwZoM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-31-Jb7Oy0RFMKeBTBZYB3cCXA-1; Fri, 04 Mar 2022 05:50:26 -0500
X-MC-Unique: Jb7Oy0RFMKeBTBZYB3cCXA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 605C61091DA1;
        Fri,  4 Mar 2022 10:50:24 +0000 (UTC)
Received: from localhost (unknown [10.33.36.250])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA1442B3B7;
        Fri,  4 Mar 2022 10:50:23 +0000 (UTC)
Date:   Fri, 4 Mar 2022 11:50:43 +0100
From:   Sergio Lopez <slp@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     qemu-devel@nongnu.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        kvm@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Fam Zheng <fam@euphon.net>,
        John G Johnson <john.g.johnson@oracle.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        qemu-s390x@nongnu.org, vgoyal@redhat.com,
        Jagannathan Raman <jag.raman@oracle.com>,
        Kevin Wolf <kwolf@redhat.com>, qemu-block@nongnu.org,
        Eric Farman <farman@linux.ibm.com>
Subject: Re: [PATCH v3 4/4] docs: vhost-user: add subsection for non-Linux
 platforms
Message-ID: <20220304105043.agaor6txfgtd2zek@mhamilton>
References: <20220303115911.20962-1-slp@redhat.com>
 <20220303115911.20962-5-slp@redhat.com>
 <20220304053326-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="c7vjzt7v36rtj4td"
Content-Disposition: inline
In-Reply-To: <20220304053326-mutt-send-email-mst@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--c7vjzt7v36rtj4td
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 04, 2022 at 05:35:01AM -0500, Michael S. Tsirkin wrote:
> On Thu, Mar 03, 2022 at 12:59:11PM +0100, Sergio Lopez wrote:
> > Add a section explaining how vhost-user is supported on platforms
> > other than Linux.
> >=20
> > Signed-off-by: Sergio Lopez <slp@redhat.com>
> > ---
> >  docs/interop/vhost-user.rst | 18 ++++++++++++++++++
> >  1 file changed, 18 insertions(+)
> >=20
> > diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
> > index edc3ad84a3..590a626b92 100644
> > --- a/docs/interop/vhost-user.rst
> > +++ b/docs/interop/vhost-user.rst
> > @@ -38,6 +38,24 @@ conventions <backend_conventions>`.
> >  *Master* and *slave* can be either a client (i.e. connecting) or
> >  server (listening) in the socket communication.
> > =20
> > +Support for platforms other than Linux
>=20
>=20
> It's not just Linux - any platform without eventfd.
>=20
> So I think we should have a section explaining that whereever
> spec says eventfd it can be a pipe if system does not
> support creating eventfd.

I'm confused. This is exactly what this subsection intends to do...

Thanks,
Sergio.

> > +--------------------------------------
> > +
> > +While vhost-user was initially developed targeting Linux, nowadays is
> > +supported on any platform that provides the following features:
> > +
> > +- The ability to share a mapping injected into the guest between
> > +  multiple processes, so both QEMU and the vhost-user daemon servicing
> > +  the device can access simultaneously the memory regions containing
> > +  the virtqueues and the data associated with each request.
> > +
> > +- AF_UNIX sockets with SCM_RIGHTS, so QEMU can communicate with the
> > +  vhost-user daemon and send it file descriptors when needed.
> > +
> > +- Either eventfd or pipe/pipe2. On platforms where eventfd is not
> > +  available, QEMU will automatically fallback to pipe2 or, as a last
> > +  resort, pipe.
> > +
> >  Message Specification
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > =20
> > --=20
> > 2.35.1
>=20

--c7vjzt7v36rtj4td
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAmIh7wAACgkQ9GknjS8M
AjWilxAAnNIS1WAe3sQyLr2mX/rC0JeslU2CIVCvEgfZ2kTACBdNG3bKmyWkA+xX
8L0hYdVfomAilkkMa4TV9LJvS7/fSnpf13xGgX9mvG4SNF87vg/AAfk/gxFGboK7
Mu7lO14ykgqhMV2jy4QclFkaHXtmbdPwfIzUfUg3KNKmHqxeGZxhx5VnQlJhtG4w
OwQnZuXMDRfNLuFgfrKvk8K0RlHqStq58x1qcX7NgSmwYcgV1Rc5OVzmIMkRqEOU
laut4PzBLXEtloSSKkpkIF+3UZzklL1UKBnv8LsFN9/qJb/pCytclle+f8PtQuIs
Gn87SyJwouQ+lYlr7piRwFHjTgf9LA/MBEmyeOPAmKgAXPdZW4XAO0PdhUpTjjjs
hY6GJNQv0kKZEONvooZcQsFxpsAbBahKAKZV+9DTPEq9C49YZG970cadUAwDSbw+
sNdcWX1nR1UGsXVEE9DsLHNQUWkBnPmfzpWHHPhGGMxnlVLGcXchHL/P2lJEHgTb
zSf05+kg0+AkxcYsOs1zoSpEWTzJ+7lP8qkstN4AbfCfKzmxCJGtTquHzKaJzI3+
Xj5a6Rt7+NEnisq3UT/xyiGPxBFHkgEUSp1qZXgmANRQ/N7psY1UBEoxNwq/kSYv
S3JMFzi6KwsUp9d9KnYfhmzpYSvJhZGuK/SearMcCxjzaUym8k0=
=Yuan
-----END PGP SIGNATURE-----

--c7vjzt7v36rtj4td--

