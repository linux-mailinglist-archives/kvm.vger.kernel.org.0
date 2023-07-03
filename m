Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E16574536C
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 02:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjGCA5V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Jul 2023 20:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjGCA5T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Jul 2023 20:57:19 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49F8DB0;
        Sun,  2 Jul 2023 17:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1688345836;
        bh=apqVPv3XQygSSOnIf/x9KRbD32JjzKgKRrGCU9iYzNE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t2vnoItum7LuYXL3O6aWvkKEJOilTAR7tfLlQGFPUmNTJPs0pw0uX10QnBbCVyBWX
         P5c+8Lt3jxIyM2YxG7TxWIImzdTPIAby4sTvwMIgOZrC0pUNu+4iOjlcKFD8hOQdj1
         M0aGShfv6w5NYqjc5N+yGlvyYRU1ctjYZD+oFB87ApUBYvm9YK86yXuOLyXW5uj7mv
         KeOQ6ptPFD2qU1FjI27v1k2deWCinA6czGxflfhAtbWgVbMakqZYgR8nkSGd3ShG+J
         FdSOvYRrhkI3moBm6VptcP4ddXVML5b7e6ds8+26obF3DvpElMtZOcmU+zRxAuj4Ud
         0rQcpO/E/JiAA==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4QvSF63ZKLz4wb1;
        Mon,  3 Jul 2023 10:57:14 +1000 (AEST)
Date:   Mon, 3 Jul 2023 10:57:13 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        ARM <linux-arm-kernel@lists.infradead.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: linux-next: manual merge of the kvm-x86 tree with the arm-soc
 tree
Message-ID: <20230703105713.5839c48d@canb.auug.org.au>
In-Reply-To: <20230623122037.16eb8bec@canb.auug.org.au>
References: <20230623122037.16eb8bec@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/c=JIyJ/lMrHd9876_yAmd+A";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/c=JIyJ/lMrHd9876_yAmd+A
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 23 Jun 2023 12:20:37 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>=20
> Today's linux-next merge of the kvm-x86 tree got a conflict in:
>=20
>   Documentation/process/maintainer-handbooks.rst
>=20
> between commit:
>=20
>   425d827ef91e ("Documentation/process: add soc maintainer handbook")
>=20
> from the arm-soc tree and commit:
>=20
>   63e2f55cabed ("Documentation/process: Add a maintainer handbook for KVM=
 x86")
>=20
> from the kvm-x86 tree.
>=20
> I fixed it up (and sorted the entries - see below) and can carry the
> fix as necessary. This is now fixed as far as linux-next is concerned,
> but any non trivial conflicts should be mentioned to your upstream
> maintainer when your tree is submitted for merging.  You may also want
> to consider cooperating with the maintainer of the conflicting tree to
> minimise any particularly complex conflicts.
>=20
>=20
> diff --cc Documentation/process/maintainer-handbooks.rst
> index fe24cb665fb7,d12cbbe2b7df..000000000000
> --- a/Documentation/process/maintainer-handbooks.rst
> +++ b/Documentation/process/maintainer-handbooks.rst
> @@@ -15,6 -15,6 +15,7 @@@ Contents
>      :numbered:
>      :maxdepth: 2
>  =20
>  -   maintainer-tip
>  -   maintainer-netdev
> +    maintainer-kvm-x86
>  +   maintainer-netdev
>  +   maintainer-soc
>  +   maintainer-tip

This is now a conflict between the kvm tree and the arm-soc tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/c=JIyJ/lMrHd9876_yAmd+A
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmSiHOkACgkQAVBC80lX
0GxJ2Af/UgmY1xH3huGwNAXHDSDaCOm9lMM+10q4QkiL5kgbNa+RIfspW8y5VkOz
LE0FmXuam/uxpC2aWYtcOLRi38kGefivsV0GF/YsF2hPXuqYoQec3aljn88lxa0Q
Kn3JJuuWEwphcx62pfqZ5uRl3m0GLDSKEokt5FYO/0Hac52yOkenjDF3xmShZALI
DHLvpJlynb0n4z/Mhd+hD0PTB7jOUOvgco/Hyp0FySVmn3hFSCTyibGW3nM96J6Q
R4dT7cHn3igU1s3K9kR6NRaJIuSYIU0Q3qNT7OIJYAxdGA4AW6jaNh8I8BQ53NpA
IIf7NStKp8vWdQdIEP6Ex9hgcGrstg==
=Z+KA
-----END PGP SIGNATURE-----

--Sig_/c=JIyJ/lMrHd9876_yAmd+A--
