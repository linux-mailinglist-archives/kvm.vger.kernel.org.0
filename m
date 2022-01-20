Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D06E494630
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 04:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358388AbiATDgX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 22:36:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232151AbiATDgW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 22:36:22 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F5DC061574;
        Wed, 19 Jan 2022 19:36:22 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4JfSpr0VjRz4xmx;
        Thu, 20 Jan 2022 14:36:19 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1642649780;
        bh=SQFUWSYH6b85H0qk+VmSPcOcr+KOF+oja5YY+V9CgJs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=McvjR4ncDckHiXlfITouI69ZfthqoCDodAYCZ/LHJma9K9+OtkPU+JirTymlGyxs+
         g4o2bg5OpnBcvow74dpkzwWP0XvPqWlInbX7xrNjjoPnFNH7L70GR8/LWTHgrsrQWF
         qOIK0xs2zozgs3rIbqLlVywK8CVpp3CtNTYTCOGi3BqVGoJ4eFJMdUDQkWOch4ZkJ1
         jqi7IBgfTYSn0f6wX/JEdNv201KaRHd8Dy8F3ekpe+NOdDYP1g8HO24pCDfx6TV0FZ
         vQ5UvrANQFgRKko4GjsLc2Td9nKSEblajwhZzurNqW4p57jbtf/6sN9JPdbu639Gqi
         QbY30H1h/p2Cg==
Date:   Thu, 20 Jan 2022 14:36:19 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     "Wang, Wei W" <wei.w.wang@intel.com>, KVM <kvm@vger.kernel.org>,
        "Zeng, Guang" <guang.zeng@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Linux Next Mailing List" <linux-next@vger.kernel.org>
Subject: Re: linux-next: build warning after merge of the kvm tree
Message-ID: <20220120143619.4803cb36@canb.auug.org.au>
In-Reply-To: <507a652f97de4e0fb26d604084ef6f25@intel.com>
References: <20220110195844.7de09681@canb.auug.org.au>
        <507a652f97de4e0fb26d604084ef6f25@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/HfHf2ONiXooc+6U6KWkks9p";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/HfHf2ONiXooc+6U6KWkks9p
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 11 Jan 2022 02:55:56 +0000 "Wang, Wei W" <wei.w.wang@intel.com> wro=
te:
>
> On Monday, January 10, 2022 4:59 PM, Stephen Rothwell wrote:
> > After merging the kvm tree, today's linux-next build (htmldocs) produce=
d this
> > warning:
> >=20
> > Documentation/virt/kvm/api.rst:5549: WARNING: Title underline too short.
> >=20
> > 4.42 KVM_GET_XSAVE2
> > ------------------ =20
>=20
> Should add one more "_" above.
> 4.42 KVM_GET_XSAVE2
> -------------------
> +-------------------
>=20
> Paolo, do you want us to send another patch to add it or you can just add=
 it?

I am still seeing this warning.

--=20
Cheers,
Stephen Rothwell

--Sig_/HfHf2ONiXooc+6U6KWkks9p
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmHo2LMACgkQAVBC80lX
0GzpAQf+NPzN/Q8H/rh9e9knNd7c5olE+Xwa1Iwvv8RVzj5FoiYjHJ4MhTVsnNkV
QO0M7Lr/J8w/43kmVckSEOLYBwrtgN6+XR7aR7cOBMZcNpksnqyQEboIVzRv2kDM
VSM9pHO0cz5Q46bTXtLS3/D01mmTb+h6ZXQPNRiyl+DsZFAkGlvpo7aqA5CeR2c+
qqwobv0t3hzQSbsqxc4EE+yMlr7Zj0jhBAu1zaaiOPnTF5lg25rkoLIxs5IK6gV2
zEWHwoxVK9yi2NAXnKkCIldyKJOFo7qfePLK6dzAgaNeBK7qSqMyfY8LQRrv9zdc
tBtehl7WTdUm8/gTsgHOiXUX7+GIUg==
=crtO
-----END PGP SIGNATURE-----

--Sig_/HfHf2ONiXooc+6U6KWkks9p--
