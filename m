Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD79E2AAD95
	for <lists+kvm@lfdr.de>; Sun,  8 Nov 2020 22:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728950AbgKHVOu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Nov 2020 16:14:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728802AbgKHVOs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Nov 2020 16:14:48 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 610DAC0613D2;
        Sun,  8 Nov 2020 13:14:48 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4CTn2F2Lkzz9sSf;
        Mon,  9 Nov 2020 08:14:45 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1604870085;
        bh=sHsrdtyoApORSTh9XibjncKZH6ivK8wvvlGihkLcXLc=;
        h=Date:From:To:Cc:Subject:From;
        b=jjTiDwENYuF+XznT6insmSbkGOX25UaHfj7Wwvm28BeuUnnRHb6QSZIbcJU3OCUEb
         RZm5N7lF33cP6eim93otkK+0DT+yD7uJz3wRMJ0yHvVq1SEoROSBGWiwz1H4eqJNk4
         K47Noy5ey/uM+iHANUdj4OMcSK5lTljpJGlnyTmoZrx0pqe4ldcGT+f3cso6l+sAwh
         f623vS1tudhAd8O25JkqzHKX9nr5iAOAOJuVx5qEjTTa9iycRZqKImz4388Hp8eLQa
         zBc0FWK7o0XxVET89M9yj+WyZlonzU0vVS1DrxxmyioY9rEvwI0NjdlcNPqHwPzvjD
         f0h2IftbE0Khg==
Date:   Mon, 9 Nov 2020 08:14:44 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the kvm-fixes tree
Message-ID: <20201109081444.6f15fca2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/g8Dq2eqNirQlOfxeCnJhU41";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/g8Dq2eqNirQlOfxeCnJhU41
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  cc4cb017678a ("KVM: x86: use positive error values for msr emulation that=
 causes #GP")

Fixes tag

  Fixes: 291f35fb2c1d1 ("KVM: x86: report negative values from wrmsr emulat=
ion to userspace")

has these problem(s):

  - Target SHA1 does not exist

Maybe you meant

Fixes: 7dffecaf4eab ("KVM: x86: report negative values from wrmsr emulation=
 to userspace")

--=20
Cheers,
Stephen Rothwell

--Sig_/g8Dq2eqNirQlOfxeCnJhU41
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl+oX8QACgkQAVBC80lX
0GyZAgf6Ay84tPkGhklJprzRbMEiZvxmNS0kj3J350wpFh4hELk6YmbSo/3wwL9W
Qbgt5Dhrgm4afuYnVOk4wkNrJbM+K98sVaW584KenEX09MLbGXGjsjHJxei6CmA/
QSiQwhjE4/XMAjkSXlcymyhYT0MqKSf/f708ZOSFTuZry7cy6A7I0sxwCkzAPzLa
j4ZHttoDEjHdlb5RUtQlIfuJQigNO3OmxFPoTHeR+qpdfjlamRK8ROF/jAlfNHN6
A3OyGb1sZRnegHIdSySvPl2E05CG3OYZCK69HVEeasC31OWQ27YgjozOo+uhe8kr
l4cFAGYxgpKEApcC77NqBLWw62fBIA==
=z+mH
-----END PGP SIGNATURE-----

--Sig_/g8Dq2eqNirQlOfxeCnJhU41--
