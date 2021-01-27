Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FAA8306717
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 23:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236945AbhA0WQJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 17:16:09 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:37418 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbhA0WQD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jan 2021 17:16:03 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 88E5B1C0B8E; Wed, 27 Jan 2021 23:15:05 +0100 (CET)
Date:   Wed, 27 Jan 2021 23:15:05 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Adrian Catangiu <acatan@amazon.com>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, gregkh@linuxfoundation.org,
        graf@amazon.com, arnd@arndb.de, ebiederm@xmission.com,
        rppt@kernel.org, 0x7f454c46@gmail.com, borntraeger@de.ibm.com,
        Jason@zx2c4.com, jannh@google.com, w@1wt.eu, colmmacc@amazon.com,
        luto@kernel.org, tytso@mit.edu, ebiggers@kernel.org,
        dwmw@amazon.co.uk, bonzini@gnu.org, sblbir@amazon.com,
        raduweis@amazon.com, corbet@lwn.net, mst@redhat.com,
        mhocko@kernel.org, rafael@kernel.org, mpe@ellerman.id.au,
        areber@redhat.com, ovzxemul@gmail.com, avagin@gmail.com,
        ptikhomirov@virtuozzo.com, gil@azul.com, asmehra@redhat.com,
        dgunigun@redhat.com, vijaysun@ca.ibm.com, oridgar@gmail.com,
        ghammer@redhat.com
Subject: Re: [PATCH v4 1/2] drivers/misc: sysgenid: add system generation id
 driver
Message-ID: <20210127221505.GB24799@amd>
References: <1610453760-13812-1-git-send-email-acatan@amazon.com>
 <1610453760-13812-2-git-send-email-acatan@amazon.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="qlTNgmc+xy1dBmNv"
Content-Disposition: inline
In-Reply-To: <1610453760-13812-2-git-send-email-acatan@amazon.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--qlTNgmc+xy1dBmNv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> - Solution
>=20
> The System Generation ID is a simple concept meant to alleviate the
> issue by providing a monotonically increasing u32 counter that changes
> each time the VM or container is restored from a snapshot.

I'd make it u64.

But as people explained, this has race problems that may be impossible
to solve?

Best regards,
								Pavel
							=09
--=20
http://www.livejournal.com/~pavelmachek

--qlTNgmc+xy1dBmNv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmAR5ekACgkQMOfwapXb+vIeRACdFFlEw9Qzjgj/nAuNJzxFeb2z
28wAoKXL22jBt2ohyVp9BgmFr64wldNZ
=T3KQ
-----END PGP SIGNATURE-----

--qlTNgmc+xy1dBmNv--
