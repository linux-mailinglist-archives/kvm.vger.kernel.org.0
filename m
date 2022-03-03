Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD8764CC017
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 15:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234087AbiCCOhn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 09:37:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiCCOhm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 09:37:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3457318E408
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 06:36:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646318216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AnN3CL0Yr+2KSSK8B7tjt5KtSlE+6Zqm6PpSEreuDss=;
        b=VN1vWD8aRqqHxEmzqP+DAfuaUN7c9klG9Fk2Hhb6AH0lHv5nAFsPGhpEHe70kacwitOYkU
        l2Ua9RW6Gb9N43Y2pq+yt0Gw41oZLj95Wf0FBch3mrubcXd+nrun7h+YuHO1uPSW2R+DDB
        VOVU5zZeaXe9q77IJvsZZ4uCg7Qsq3I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-vboblWWDMB6H-XSC-7AU3Q-1; Thu, 03 Mar 2022 09:36:53 -0500
X-MC-Unique: vboblWWDMB6H-XSC-7AU3Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56AFA1006AA5;
        Thu,  3 Mar 2022 14:36:51 +0000 (UTC)
Received: from localhost (unknown [10.39.194.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F2D5084974;
        Thu,  3 Mar 2022 14:35:46 +0000 (UTC)
Date:   Thu, 3 Mar 2022 14:35:09 +0000
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
Subject: Re: [PATCH v3 0/4] Enable vhost-user to be used on BSD systems
Message-ID: <YiDSHaJlGQSYBNbs@stefanha-x1.localdomain>
References: <20220303115911.20962-1-slp@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="BJA7GgC+FrdGbkM/"
Content-Disposition: inline
In-Reply-To: <20220303115911.20962-1-slp@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--BJA7GgC+FrdGbkM/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 03, 2022 at 12:59:07PM +0100, Sergio Lopez wrote:
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
> Sergio Lopez (4):
>   event_notifier: add event_notifier_get_wfd()
>   vhost: use wfd on functions setting vring call fd
>   configure, meson: allow enabling vhost-user on all POSIX systems
>   docs: vhost-user: add subsection for non-Linux platforms
>=20
>  configure                     |  4 ++--
>  docs/interop/vhost-user.rst   | 18 ++++++++++++++++++
>  hw/virtio/vhost.c             |  6 +++---
>  include/qemu/event_notifier.h |  1 +
>  meson.build                   |  2 +-
>  util/event_notifier-posix.c   |  5 +++++
>  6 files changed, 30 insertions(+), 6 deletions(-)
>=20
> --=20
> 2.35.1
>=20
>=20

I posted comments on the vhost-user.rst patch. Otherwise:

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--BJA7GgC+FrdGbkM/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmIg0h0ACgkQnKSrs4Gr
c8g9/gf/Xsx0QMCqyJ/eiPBnY6EH9Gq4v8FXdQp1992zu2QADuLvlaIqnulGQqyO
aBrDNSerETPYHr57PMQH5S9Mv0XYwSkd2AhfVp5Gd32/uDNNRNmMhrCtSFkL5i52
j24OU9zdqT+LFQBLxdkyFdHQSIvjZsu+FHRsN9iE4geVC57WF9YEUvN/OeIyt0Og
fbn9hSnyK1VqY+dR0RdX1f6DGS7P0AI8PQjoYVvWStbEOzvc2N1Hpa5yKmEmwVv9
AmRgcY8Gi6QaGoNCOTGDJQqXftedeOI7notUZS9ISgz4OkXezn2yyauHgesQ/ljT
QVcAi1DZgTw06wz/JE3fr7vpR8/zYA==
=yrC1
-----END PGP SIGNATURE-----

--BJA7GgC+FrdGbkM/--

