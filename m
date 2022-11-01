Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC04615473
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 22:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbiKAVvK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 17:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbiKAVvI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 17:51:08 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D6E617F
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 14:51:04 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4N23cQ6yTMz4xG6;
        Wed,  2 Nov 2022 08:51:02 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1667339463;
        bh=XsmISU6iyvIQtW7XEorFckANs8h/uXjylMsjSpUamTU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CbHvflimntBICJbgdR8EzYFhcEhEHTXaax/pkv47pI+bUMoyuzjKKlzLt3zhHf/Qk
         LJl87BzyPHzqsNSwG8DqT8gry5HMzMulOisjnqsJ2BNoUNODkHayn668txI9i2ChY/
         NtUe/X6zw5kq5eHUX7ie8f4pUjFaqE7/Ku1lEiGNY+9iyYqCR18lY+uv0GojcT/Inn
         M6Xvt6KxKctAj+H1aTFiesjNLxK3GLZ2NI3ntRGVv+WLKhO7ahMA9lTs5PJeHjJctd
         Cez7/WSET4LPl0XLpKSDsYfX1TZB46o5Pzgo86jUbv68X0fuObQpZ+n9hoKCZ65wgr
         sIQ3/LY/wSlwQ==
Date:   Wed, 2 Nov 2022 08:51:01 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     kvm@vger.kernel.org, iommu@lists.linux.dev
Subject: Re: iommufd branch into linux-next
Message-ID: <20221102085101.21efbd6b@canb.auug.org.au>
In-Reply-To: <Y2BpD9OuPOmUu6GJ@nvidia.com>
References: <Y2BpD9OuPOmUu6GJ@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/lZzlkd=Ghn_Dzb5Bf3RUyHN";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/lZzlkd=Ghn_Dzb5Bf3RUyHN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jason,

On Mon, 31 Oct 2022 21:32:15 -0300 Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> Can you include the new iommufd tree into linux-next please?
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git
>=20
> Branches 'for-next' and 'for-rc'
>=20
> You can read about what it is here:
>=20
> https://lore.kernel.org/all/0-v3-402a7d6459de+24b-iommufd_jgg@nvidia.com/

Added from today.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgement of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
        Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

--Sig_/lZzlkd=Ghn_Dzb5Bf3RUyHN
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmNhlMUACgkQAVBC80lX
0Gy8+Af+PAvG352aKlG9/FMuGS9U4PVytWO2qZ1ACEUO/QnMwo54uxib0b79em54
OevS8nT+jKhWSNn9qtVkdvUC5FS5jJGsvOGgz/8mGiGGmO26THKcHp9XJslbQr+s
Hi4+/pYttlFhLo3Y3aRy3cb136jFWrgTDbKvSw7jqpFKINbWhKaiD7y1M+e4YLEH
eXx40gIBRGH64Wvv/XYKTfRVkk7+5YVehr/SAtUIQfOX9AJke3ldmzMHulgobFzO
mbuBT8q6N6jEKt5MDrftWrKRbhTs9Vv+97eVE6zmqEleLxn0A/nTyLNrFtQdzWak
8ap7Ma7mwWgMKNsoYrmc2f5ZqB4NiQ==
=Ei9o
-----END PGP SIGNATURE-----

--Sig_/lZzlkd=Ghn_Dzb5Bf3RUyHN--
