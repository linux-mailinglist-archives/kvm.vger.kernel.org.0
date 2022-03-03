Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7724CBA95
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 10:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbiCCJps (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 04:45:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbiCCJpr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 04:45:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A58A2178697
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 01:45:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646300700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZLR7FIVPSrpsftBawiMhIAD/dDls0xOqPd3OqR5iq4U=;
        b=dcWRcVXWAKwgpTBj5THpeLTwJNwjNvD6EFoPH/fMjClMLGp/0yNOgZAh2Gu/x573scV8lL
        pOJ/3NyDuoJ5xRJU8SSXyRsbO59v7PybeawAtyTdzcw04X2gsQ2qfeL55G+ovRbcztqZYP
        RyERSA3qjbfROXX/+SVHnA0udkSwWwo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-Awc9O7BuNuWVzn63dnBHig-1; Thu, 03 Mar 2022 04:44:57 -0500
X-MC-Unique: Awc9O7BuNuWVzn63dnBHig-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 46EB880EDA3;
        Thu,  3 Mar 2022 09:44:55 +0000 (UTC)
Received: from localhost (unknown [10.39.194.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 297A56E1A6;
        Thu,  3 Mar 2022 09:44:12 +0000 (UTC)
Date:   Thu, 3 Mar 2022 09:44:11 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Sergio Lopez <slp@redhat.com>
Cc:     qemu-devel@nongnu.org, Halil Pasic <pasic@linux.ibm.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        qemu-block@nongnu.org, vgoyal@redhat.com,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        kvm@vger.kernel.org, Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Cornelia Huck <cohuck@redhat.com>, qemu-s390x@nongnu.org,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>,
        Kevin Wolf <kwolf@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Fam Zheng <fam@euphon.net>,
        John G Johnson <john.g.johnson@oracle.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Jagannathan Raman <jag.raman@oracle.com>
Subject: Re: [PATCH v2 0/3] Enable vhost-user to be used on BSD systems
Message-ID: <YiCN67eJqf/5zyZw@stefanha-x1.localdomain>
References: <20220302180318.28893-1-slp@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5MAEvHPCnDQHB7UG"
Content-Disposition: inline
In-Reply-To: <20220302180318.28893-1-slp@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--5MAEvHPCnDQHB7UG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 02, 2022 at 07:03:15PM +0100, Sergio Lopez wrote:
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

Please update the vhost-user protocol specification. It mentions eventfd
and there needs to be a note explaining how pipes are used instead on
non-Linux platforms.

Stefan

--5MAEvHPCnDQHB7UG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEyBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmIgjesACgkQnKSrs4Gr
c8hJFQf41zixo62gwAD9UcnFVO/2tddUO56dhlF+DONIXVi8O8z09ZeNLu5fwhXV
2uVTQuXttFj0eBHDuaYgt7aIkxXmUfzUMJt9DMwKOsGQk4MzxOCw3hnLJX8V66id
2c4TzYG3HXkb6t+s1vHS2SpUB+9S7GPxSY9WvUVym+HPqu0M3ygYse1UiLvx/qMj
O0p/UYdKxLu8B577FCVf7EQA3AfAyozrniQpVMM6weZe5OFWdknnuLKpF8ickphf
Z4pmdqD1ysIbTkSGqlUXBvNqnbIbbKdn01LvXOfb7kQbk5oe/SCvE7A4CcDuLq64
QrjSC3hQOf3qdDgRMxfuXggnZvcI
=LQYc
-----END PGP SIGNATURE-----

--5MAEvHPCnDQHB7UG--

