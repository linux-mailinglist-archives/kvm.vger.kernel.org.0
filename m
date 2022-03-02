Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46F6C4CAC70
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 18:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244254AbiCBRuE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 12:50:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiCBRuD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 12:50:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 93F052A246
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 09:49:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646243358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KHov4rSdmNSpCoaSX9M+1g7hJvbhTgSvzT20Bw+TISY=;
        b=DmZLPnB/drdNyWIq8WIEoKRcJ2GLHJsKdM5J3Gpaz44lg/j5KA6b+WREYdBP0mP9lH8qC8
        4c3aXkRnnDLOubOCgY+VeskaA9NWh8Xg+iWxuZfHXEfxHanvLwWtLHAC22f71kx/FJJgpP
        pEzbNblEwm8gyLotsa7ztE5IkHIfeZw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-403-tAcapSSUMKiCycft13Cvow-1; Wed, 02 Mar 2022 12:49:15 -0500
X-MC-Unique: tAcapSSUMKiCycft13Cvow-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 96EB751FC;
        Wed,  2 Mar 2022 17:49:13 +0000 (UTC)
Received: from localhost (unknown [10.33.36.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DDD25865A4;
        Wed,  2 Mar 2022 17:48:53 +0000 (UTC)
Date:   Wed, 2 Mar 2022 18:49:13 +0100
From:   Sergio Lopez <slp@redhat.com>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org,
        vgoyal@redhat.com, Fam Zheng <fam@euphon.net>, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Jagannathan Raman <jag.raman@oracle.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, qemu-block@nongnu.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
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
Subject: Re: [PATCH 2/2] Allow building vhost-user in BSD
Message-ID: <20220302174913.bcrnlhgkpvjayyrw@mhamilton>
References: <20220302113644.43717-1-slp@redhat.com>
 <20220302113644.43717-3-slp@redhat.com>
 <66b68bcc-8d7e-a5f7-5e6c-b2d20c26ab01@redhat.com>
 <8dfc9854-4d59-0759-88d0-d502ae7c552f@gmail.com>
 <20220302173009.26auqvy4t4rx74td@mhamilton>
 <85ed0856-308a-7774-a751-b20588f3d9cd@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tpkexuwipkv6mgvo"
Content-Disposition: inline
In-Reply-To: <85ed0856-308a-7774-a751-b20588f3d9cd@gmail.com>
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


--tpkexuwipkv6mgvo
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 02, 2022 at 06:38:07PM +0100, Philippe Mathieu-Daud=E9 wrote:
> On 2/3/22 18:31, Sergio Lopez wrote:
> > On Wed, Mar 02, 2022 at 06:18:59PM +0100, Philippe Mathieu-Daud=E9 wrot=
e:
> > > On 2/3/22 18:10, Paolo Bonzini wrote:
> > > > On 3/2/22 12:36, Sergio Lopez wrote:
> > > > > With the possibility of using pipefd as a replacement on operating
> > > > > systems that doesn't support eventfd, vhost-user can also work on=
 BSD
> > > > > systems.
> > > > >=20
> > > > > This change allows enabling vhost-user on BSD platforms too and
> > > > > makes libvhost_user (which still depends on eventfd) a linux-only
> > > > > feature.
> > > > >=20
> > > > > Signed-off-by: Sergio Lopez <slp@redhat.com>
> > > >=20
> > > > I would just check for !windows.
> > >=20
> > > What about Darwin / Haiku / Illumnos?
> >=20
> > It should work on every system providing pipe() or pipe2(), so I guess
> > Paolo's right, every platform except Windows. FWIW, I already tested
> > it with Darwin.
>=20
> Wow, nice.
>=20
> So maybe simply check for pipe/pipe2 rather than !windows?
>=20

Is it worth it? In "configure", CONFIG_POSIX is set to "y" if the
target isn't "mingw32", and CONFIG_POSIX brings "util/oslib-posix.c"
into the build, which expects to have either pipe or pipe2.

Thanks,
Sergio.

--tpkexuwipkv6mgvo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAmIfrhgACgkQ9GknjS8M
AjVzrRAAsTcf522XpDZJHdkqrJ4iY87nqERGww2Xz99TuNvzoxVAuvfbGTa4O6ZQ
Vf8GUpbfJcvvwaQu/Cb0KbZCYY/7o/KKAWSYeLYO4SvA0aoSqExJoeLVYf9nhgaq
RGpuZLgMWC1LGNeXf3QeQHcSZaQ6XqZn8aAAO+oeX+tK6kql05l2ZxE/p+Hs+RnP
3Wr+yxUZnr0ljHOUWZ7luQ0+C9bKso9WQhKXiS59cPRg3tK3bx0OP1gyyxwD1+gB
268XBEDOgcH9jBXZpQx//iyPQJJQNWnXHdDhW0w/WmkAdt/DaHkEYmfKWV/oAzoq
TdCx6Eh5OKzBoOYBd/CXpLbdxoWPHtvzZ+UUbxBdco+jNuhUmn8hquC32GtmTR05
o+H5WCcQvVmAvk75sOUlEgkRHaZcmnply1bIBf5pea40pFzbTimjEnnqwxGfNBrD
eplli9xkBixcArtWDafK21YJsva/8TxkzgysGUb5JlHLRx78PkJ0C7sNFympBpBN
oTQYx5T5PLhfYQEacbaGWcWS2T15mw3oCXAltJopULif5nijp83xY+tlKJVRiFgM
RNB1M/aB2/cpcEOI75xx2glEt9GeJUMgqAcco4VCkifFb3n8tIFh/01vEfABvNMc
i6crm15PxBagb9QUpk9+HxEAduKR6BAaCRtWlySn++KtKNgXkWk=
=+Zlf
-----END PGP SIGNATURE-----

--tpkexuwipkv6mgvo--

