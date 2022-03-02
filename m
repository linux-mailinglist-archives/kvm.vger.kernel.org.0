Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE8F4CA9C9
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 17:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239124AbiCBQHf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 11:07:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbiCBQHe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 11:07:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4B5D27004C
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 08:06:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646237210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GrD0BGmgCrrsW/ZxtnaRp1GXNLCgNzTcWE7WkwLyYBQ=;
        b=RJbwBEq5XYtY/m+mSIjJ6YgAnAoLmb1VoqCvbhm7DY6IYrwehwvYd7oWrwZhskl36k/4RL
        rd5GIr6RRuMkaC79MbAM+ry57VbnRWma/wxi9GOOEAs+jzpql4dgoGuCgxWd8jic4aTQYC
        rEB7pyMRzzdaah926A4hI63Q7+ckwoY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-453-r_JR-YQUPYuwlJ8otLygLg-1; Wed, 02 Mar 2022 11:06:46 -0500
X-MC-Unique: r_JR-YQUPYuwlJ8otLygLg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6ACD1091DA1;
        Wed,  2 Mar 2022 16:06:43 +0000 (UTC)
Received: from localhost (unknown [10.39.195.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 103FD8395F;
        Wed,  2 Mar 2022 16:06:42 +0000 (UTC)
Date:   Wed, 2 Mar 2022 16:06:41 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Sergio Lopez <slp@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        qemu-devel@nongnu.org, vgoyal@redhat.com,
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
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-s390x@nongnu.org, Matthew Rosato <mjrosato@linux.ibm.com>,
        John G Johnson <john.g.johnson@oracle.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH 1/2] Allow returning EventNotifier's wfd
Message-ID: <Yh+WESUBI9spkHvd@stefanha-x1.localdomain>
References: <20220302113644.43717-1-slp@redhat.com>
 <20220302113644.43717-2-slp@redhat.com>
 <20220302081234.2378ef33.alex.williamson@redhat.com>
 <20220302152342.3hlzw3ih2agqqu6c@mhamilton>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="CckaM7tvrQIX+lck"
Content-Disposition: inline
In-Reply-To: <20220302152342.3hlzw3ih2agqqu6c@mhamilton>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--CckaM7tvrQIX+lck
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 02, 2022 at 04:23:42PM +0100, Sergio Lopez wrote:
> On Wed, Mar 02, 2022 at 08:12:34AM -0700, Alex Williamson wrote:
> > On Wed,  2 Mar 2022 12:36:43 +0100
> > Sergio Lopez <slp@redhat.com> wrote:
> >=20
> > > event_notifier_get_fd(const EventNotifier *e) always returns
> > > EventNotifier's read file descriptor (rfd). This is not a problem when
> > > the EventNotifier is backed by a an eventfd, as a single file
> > > descriptor is used both for reading and triggering events (rfd =3D=3D
> > > wfd).
> > >=20
> > > But, when EventNotifier is backed by a pipefd, we have two file
> > > descriptors, one that can only be used for reads (rfd), and the other
> > > only for writes (wfd).
> > >=20
> > > There's, at least, one known situation in which we need to obtain wfd
> > > instead of rfd, which is when setting up the file that's going to be
> > > sent to the peer in vhost's SET_VRING_CALL.
> > >=20
> > > Extend event_notifier_get_fd() to receive an argument which indicates
> > > whether the caller wants to obtain rfd (false) or wfd (true).
> >=20
> > There are about 50 places where we add the false arg here and 1 where
> > we use true.  Seems it would save a lot of churn to hide this
> > internally, event_notifier_get_fd() returns an rfd, a new
> > event_notifier_get_wfd() returns the wfd.  Thanks,
>=20
> I agree. In fact, that's what I implemented in the first place. I
> changed to this version in which event_notifier_get_fd() is extended
> because it feels more "correct". But yes, the pragmatic option would
> be adding a new event_notifier_get_wfd().
>=20
> I'll wait for more reviews, and unless someone voices against it, I'll
> respin the patches with that strategy (I already have it around here).

I had the same thought looking through the patch before I read Alex's
suggestion. A separate get_wfd() function makes sense to me.

Stefan

--CckaM7tvrQIX+lck
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmIflhEACgkQnKSrs4Gr
c8gUbwf+MaJ1cHSEuImrkqURTdFKqXovAS0lAPUlBsdIv36iSJWxNCfsWsP7nNQR
ZnaIbqFNhCLC6YoZcEg/sezcGI/H3qfkG88Fv+wuEWBR5CWDoLnNhQGksC+A+jwD
BnPvhEMXDWM/GAmjvQrNAfFZeVtvspRtVHg1xDvz1kfUrMup3Qpmz6VcdRZCEKHR
HUkimVWmgOqRTDBA9Mcn32nFjqv1kWgaleItUOQXGq+gLXs4ri4CUuBDZcGRF/T7
EgciAL062l4PjdATLM/Y42p1YMkROJhMEa30n4Ov/Ore/BjjFFAb+u+tcDJGo/DN
wtItDgzVaRAoQ31EvfDE4kTgLyDjnw==
=7Tst
-----END PGP SIGNATURE-----

--CckaM7tvrQIX+lck--

