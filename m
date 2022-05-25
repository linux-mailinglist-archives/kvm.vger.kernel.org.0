Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 862725334E9
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 03:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241848AbiEYBrz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 21:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240652AbiEYBrx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 21:47:53 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5FA915823
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 18:47:52 -0700 (PDT)
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4L7DTw0FX7z4xYN; Wed, 25 May 2022 11:47:48 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1653443268;
        bh=EGg/NWkhqgS+TYzveXIrYzjI5grJ8CrjMPa5KXIW82M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UWqS+owz8XnLsimncATVeIZPrt+M5FSMuEOwndbyTqNU6V3m9T5RrOiUKdC6M8eJM
         96kqlDkNFXOvl8bB75zPZ9bQQnTvg3JmgnjeNIMXE9aPnU5ZigbKTlI2dlqH7NDGdl
         4vsah1OhKJGiAQF90Hs01kO2l/gCVEXNy1qBBjtY=
Date:   Wed, 25 May 2022 11:39:39 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        iommu@lists.linux-foundation.org,
        Joao Martins <joao.m.martins@oracle.com>
Subject: Re: [PATCH RFC 11/12] iommufd: vfio container FD ioctl compatibility
Message-ID: <Yo2I2zfDTEg8+PjE@yekko>
References: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <11-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <20220323165125.5efd5976.alex.williamson@redhat.com>
 <20220324003342.GV11336@nvidia.com>
 <20220324160403.42131028.alex.williamson@redhat.com>
 <YmqqXHsCTxVb2/Oa@yekko>
 <67692fa1-6539-3ec5-dcfe-c52dfd1e46b8@ozlabs.ru>
 <20220524132553.GR1343366@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="NTotmLiK/VZ5p5fr"
Content-Disposition: inline
In-Reply-To: <20220524132553.GR1343366@nvidia.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--NTotmLiK/VZ5p5fr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 24, 2022 at 10:25:53AM -0300, Jason Gunthorpe wrote:
> On Mon, May 23, 2022 at 04:02:22PM +1000, Alexey Kardashevskiy wrote:
>=20
> > Which means the guest RAM does not need to be all mapped in that base I=
OAS
> > suggested down this thread as that would mean all memory is pinned and
> > powervm won't be able to swap it out (yeah, it can do such thing now!).=
 Not
> > sure if we really want to support this or stick to a simpler design.
>=20
> Huh? How can it swap? Calling GUP is not optional. Either you call GUP
> at the start and there is no swap, or you call GUP for each vIOMMU
> hypercall.
>=20
> Since everyone says PPC doesn't call GUP during the hypercall - how is
> it working?

The current implementation does GUP during the pre-reserve.  I think
Alexey's talking about a new PowerVM (IBM hypervisor) feature; I don't
know how that works.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--NTotmLiK/VZ5p5fr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEoULxWu4/Ws0dB+XtgypY4gEwYSIFAmKNiLQACgkQgypY4gEw
YSLnFRAAhlmoBMol4J9baUS6tCTxZ0TBL5Vbqt8RKLryhFiIIQOrrB6kTU5uyYSX
vdyI/V7+cC2vjYmEDwUM8hnFi3cTpW+BMj4TeQSxEgIPHJ4tWs0yGuuhboVKhuJV
9h2iSi/SLdOc5ZELFwWZ5YTJc88EUzeDY+B+l3gL+PTxOW8WuBQmjQs+xw5Oaqhx
YY24PAoLnL/nmSOJU9jmb+1opQoah0WmziyMp5H/eX+n09XrI+OieVcgAJSvlCQ8
MJsuVokzY/cvJKJPtJRB+VKxrcavcivF6WWzcCz6e3tzkdcfOzWrEzKjfoo5pFM0
bpk5iAs34G3n+m+OGQHEKgKpRa5cGTj92Wzdic1IDAA10PRScGwJVKynImWxozKT
S1C4zjG87inJyYQ15DEYygNvRCrzNMEsbHm4NGlh4H9rTEwJ2s0DZyPUGmxOnf5E
qG64BxrmR6HhoLvuAehIok7rfEZL0EWK7xLwP8w6Q/G33W/Tpc9PpZT06SdZoKOm
tD7TFUqjjtIZwGDpggJLCiDZYF8xwaW4qnWwnpgms//pijFkaL41pxE0y/vS4lOA
uS5ATgjrMtsvaIqvygQg8eUhhUtbn08sHseYoriwWMbCMzBt8KJEXyvQ3wWvUIYp
K7DQMs+/yPDTXxFo86ZqBWwEFC8MCnVM4V8rs8Fti1k87TrZT3Y=
=9VPE
-----END PGP SIGNATURE-----

--NTotmLiK/VZ5p5fr--
