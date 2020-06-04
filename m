Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9DCF1EDB87
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 05:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgFDDFE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 23:05:04 -0400
Received: from ozlabs.org ([203.11.71.1]:50355 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726118AbgFDDFD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 23:05:03 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49crHK1n9tz9sSc;
        Thu,  4 Jun 2020 13:05:00 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1591239901;
        bh=oFVbgP1R1QPEnlBkINM2rOnIrnrRGtuWrg9EHyvWszI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FFgTe2AKhcGRnvFcCuhH4ohzoilYpjIoTU2muryt4T7fp64RfpY1RF9J6vmWUG6/3
         wy8vwjjPapK6dB9uL9IimiYZXHjDYmArMMrQTENelXFvs3A9fJTD71y1SMdZPtmgW9
         a+UkTF4W1RCMDYyMXyLtk1vFTbA/s34c4DDPE11RIL4bVgqpacxBV5Wbbai5tFHkL3
         5EoQtgsoYZopxQrMqQggf5LQvGSP3Hiq9TPp+FUOIYHC1eaZVC1L60jJFXJeZyuzvD
         F0ad2WkwlJ4tX1c/21lhF/cl7qwXTjI7i24DreQEN8CdhQnP2/YicmZrD7XCNTpiLk
         tZhQNz8OiwLFw==
Date:   Thu, 4 Jun 2020 13:05:00 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>
Subject: Re: linux-next: manual merge of the kvm tree with the s390 tree
Message-ID: <20200604130500.5b42014e@canb.auug.org.au>
In-Reply-To: <20200529164613.526f5865@canb.auug.org.au>
References: <20200529164613.526f5865@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/FodOnekiCk/xymcSjgVI_zB";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/FodOnekiCk/xymcSjgVI_zB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 29 May 2020 16:46:13 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the kvm tree got a conflict in:
>=20
>   arch/s390/kvm/vsie.c
>=20
> between commit:
>=20
>   0b0ed657fe00 ("s390: remove critical section cleanup from entry.S")
>=20
> from the s390 tree and commit:
>=20
>   d075fc3154be ("KVM: s390: vsie: Move conditional reschedule")
>=20
> from the kvm tree.
>=20
> diff --cc arch/s390/kvm/vsie.c
> index 4fde24a1856e,ef05b4e167fb..000000000000
> --- a/arch/s390/kvm/vsie.c
> +++ b/arch/s390/kvm/vsie.c
> @@@ -1000,9 -1000,9 +1000,6 @@@ static int do_vsie_run(struct kvm_vcpu=20
>  =20
>   	handle_last_fault(vcpu, vsie_page);
>  =20
> - 	if (need_resched())
> - 		schedule();
>  -	if (test_cpu_flag(CIF_MCCK_PENDING))
>  -		s390_handle_mcck();
> --
>   	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
>  =20
>   	/* save current guest state of bp isolation override */

This is now a conflict between the s390 tree and Linus' tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/FodOnekiCk/xymcSjgVI_zB
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl7YZNwACgkQAVBC80lX
0GwPsQf8CGKbVZ9HGrBHINGGEjuVqGkVwhAjRIZg4ZZ/n9+3Z8hPV7vCWLy3e718
WmfsLjzh+xgKk0ixJSkwMU6MiRanKRhRpRfU4am7SsySn3XlzR8IKzhUWQhIEh90
pA7DguWdEhRi3wlWbWkWzQm+MZgAHIq6WdQu93GZOK8F5YVAPylsxNfJE5eCzDMf
R9roXewRjjn+jW9wLPzOwLuH5QfA0Nd6DBpd1zGqzJKuxLfKjKPVPVRw5FX9XXrg
8gS5pkChS59bp4PXBPaH+vflqRk+OjafXEfZtnEaqXiCQ1U7JthA2UHOEnnABrUu
G5fNnFXHhVwY3YvNeIxTxULrnlh2kg==
=RTlh
-----END PGP SIGNATURE-----

--Sig_/FodOnekiCk/xymcSjgVI_zB--
