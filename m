Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2F54CA8FC
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 16:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243418AbiCBPZJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 10:25:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233513AbiCBPZH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 10:25:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E2D10B0EAF
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 07:24:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646234663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z6lfQ+/8B9B8XXN0ZdlMjhPgwhvJKUM8Y2F/+Ltg6o4=;
        b=DwrH3I5fkHJIT6Ja3z6PvAfqj0THZJ8qRubBWp35yRhoyHZxNmu3khJNEVnH4/j0nGnFTZ
        FlSZFsClQOXN8oAqxVkFFXfZLB+ZPOA9XML+u/ykFqQBYO6paMcA3hr/qorxYtMRFW/fyK
        s7rdz7evqc1KQzoWJQH6BsoBj4uyE2A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-c2TNa6KhOqWVA4ExXpU9SA-1; Wed, 02 Mar 2022 10:24:19 -0500
X-MC-Unique: c2TNa6KhOqWVA4ExXpU9SA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD93683DBC7;
        Wed,  2 Mar 2022 15:24:17 +0000 (UTC)
Received: from localhost (unknown [10.33.36.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3DABF7DE56;
        Wed,  2 Mar 2022 15:23:22 +0000 (UTC)
Date:   Wed, 2 Mar 2022 16:23:42 +0100
From:   Sergio Lopez <slp@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     qemu-devel@nongnu.org, vgoyal@redhat.com,
        Fam Zheng <fam@euphon.net>, kvm@vger.kernel.org,
        Jagannathan Raman <jag.raman@oracle.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, qemu-block@nongnu.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-s390x@nongnu.org, Matthew Rosato <mjrosato@linux.ibm.com>,
        John G Johnson <john.g.johnson@oracle.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH 1/2] Allow returning EventNotifier's wfd
Message-ID: <20220302152342.3hlzw3ih2agqqu6c@mhamilton>
References: <20220302113644.43717-1-slp@redhat.com>
 <20220302113644.43717-2-slp@redhat.com>
 <20220302081234.2378ef33.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hojutzklhzfoy7i3"
Content-Disposition: inline
In-Reply-To: <20220302081234.2378ef33.alex.williamson@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--hojutzklhzfoy7i3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 02, 2022 at 08:12:34AM -0700, Alex Williamson wrote:
> On Wed,  2 Mar 2022 12:36:43 +0100
> Sergio Lopez <slp@redhat.com> wrote:
>=20
> > event_notifier_get_fd(const EventNotifier *e) always returns
> > EventNotifier's read file descriptor (rfd). This is not a problem when
> > the EventNotifier is backed by a an eventfd, as a single file
> > descriptor is used both for reading and triggering events (rfd =3D=3D
> > wfd).
> >=20
> > But, when EventNotifier is backed by a pipefd, we have two file
> > descriptors, one that can only be used for reads (rfd), and the other
> > only for writes (wfd).
> >=20
> > There's, at least, one known situation in which we need to obtain wfd
> > instead of rfd, which is when setting up the file that's going to be
> > sent to the peer in vhost's SET_VRING_CALL.
> >=20
> > Extend event_notifier_get_fd() to receive an argument which indicates
> > whether the caller wants to obtain rfd (false) or wfd (true).
>=20
> There are about 50 places where we add the false arg here and 1 where
> we use true.  Seems it would save a lot of churn to hide this
> internally, event_notifier_get_fd() returns an rfd, a new
> event_notifier_get_wfd() returns the wfd.  Thanks,

I agree. In fact, that's what I implemented in the first place. I
changed to this version in which event_notifier_get_fd() is extended
because it feels more "correct". But yes, the pragmatic option would
be adding a new event_notifier_get_wfd().

I'll wait for more reviews, and unless someone voices against it, I'll
respin the patches with that strategy (I already have it around here).

Thanks,
Sergio.

--hojutzklhzfoy7i3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAmIfi/0ACgkQ9GknjS8M
AjW30g/5AVF1V3bVZd+v78w4CUyPhe4tKgcG/N+U8UoR2Scy9eN7EmLRlIZSIoJY
/3D+MEgFFqvYKw8v6QqdjoXfXVaDsSx3o3nCjiaNojxeDGdnBi/2cTXizKFJbPAQ
59xJEtCECjonYzCX1nooCUO732GJcZTU05BDUMwMQpAseioDiR9wj/G27usLFFPb
9UyhYLtE/njCUAob7nr8wQCr3iqHuDMHw9r/dfjAKde2oPGFQjiGUVRj8cbtbrcI
ru1fF7vP52YZnPVXr+b8lKDurQ6wH2BRllxg42DvUI0qh2obkwIZeSB6Bj/4Vya5
b51W5fwKRYX1GPvQ/aGA5qHZPYe3vft/CvAan6QWDDVkbGxZE4IOHZWWUgfoReO+
5kKrdNkU3BkSeVBWvNBlmQxtIDY5VNKX3Up98FGlu0GduiRol5vaaLKULoI5tZHd
jgSJmMyL8kj2aoGSR/GBd4A6H6ePSD+TvJSqORQrWKAE6pPYngU7dHZGvnkxCnrm
4thiBI9xArEi98Cf6gwwsEjQ4OxiCjSZVKMbXRvm2FY9a7HnCCLr3EVV4DXNPwbE
fSKCM7G3O+spIToJTAfq7pUrSO46EBq75WbYWhC7V4h8vSaZNeAvEzk3JU/2P/yn
pzSGfA66Vi7F4VoQRekREHuNs3fp/Zm3aPnywISy4icF3Z0+X9Q=
=Yb7b
-----END PGP SIGNATURE-----

--hojutzklhzfoy7i3--

