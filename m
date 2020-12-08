Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCAE12D2B72
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 13:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729613AbgLHMvv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 07:51:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57888 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729610AbgLHMvu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Dec 2020 07:51:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607431823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IJb0yL8t1J27rgEdifFpbwxMbbWe+gLBx9boQJ2XmHM=;
        b=Lobw89A57cmGzjEz80Wj/hiqS9yCAg4aL88zxb3Mbtwd68aiTvS9ZIqhe48HlIk+FJdbkb
        wHcRxDpKlKMLd7caEUFBSILj8uHrE2bTWWo2hxJuPBEwa1RSIRW1kNq/hz6c/eA9CP4NcM
        Q1MwX9mDhWy4JxZ0bVwXj6DPPOIHO1k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-464-KvBjyZkePhajU5E9LyZ3Nw-1; Tue, 08 Dec 2020 07:50:20 -0500
X-MC-Unique: KvBjyZkePhajU5E9LyZ3Nw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 594C2800D53;
        Tue,  8 Dec 2020 12:50:18 +0000 (UTC)
Received: from gondolin (ovpn-113-5.ams2.redhat.com [10.36.113.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE59236FA;
        Tue,  8 Dec 2020 12:50:07 +0000 (UTC)
Date:   Tue, 8 Dec 2020 13:50:05 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        pair@us.ibm.com, brijesh.singh@amd.com, frankja@linux.ibm.com,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, david@redhat.com,
        dgilbert@redhat.com, Eduardo Habkost <ehabkost@redhat.com>,
        qemu-devel@nongnu.org, qemu-s390x@nongnu.org, qemu-ppc@nongnu.org,
        berrange@redhat.com, thuth@redhat.com, pbonzini@redhat.com,
        rth@twiddle.net, mdroth@linux.vnet.ibm.com
Subject: Re: [for-6.0 v5 12/13] securable guest memory: Alter virtio default
 properties for protected guests
Message-ID: <20201208135005.100d56fb.cohuck@redhat.com>
In-Reply-To: <20201208112829.0f8fcdf4.pasic@linux.ibm.com>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
        <20201204054415.579042-13-david@gibson.dropbear.id.au>
        <d739cae2-9197-76a5-1c19-057bfe832187@de.ibm.com>
        <20201204091706.4432dc1e.cohuck@redhat.com>
        <038214d1-580d-6692-cd1e-701cd41b5cf8@de.ibm.com>
        <20201204154310.158b410e.pasic@linux.ibm.com>
        <20201208015403.GB2555@yekko.fritz.box>
        <20201208112829.0f8fcdf4.pasic@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=cohuck@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; boundary="Sig_/zPKYOXDOdv+NokJBOjze+4x";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/zPKYOXDOdv+NokJBOjze+4x
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 8 Dec 2020 11:28:29 +0100
Halil Pasic <pasic@linux.ibm.com> wrote:

> On Tue, 8 Dec 2020 12:54:03 +1100
> David Gibson <david@gibson.dropbear.id.au> wrote:
>=20
> > > > >>> +         * Virtio devices can't count on directly accessing gu=
est
> > > > >>> +         * memory, so they need iommu_platform=3Don to use nor=
mal DMA
> > > > >>> +         * mechanisms.  That requires also disabling legacy vi=
rtio
> > > > >>> +         * support for those virtio pci devices which allow it=
.
> > > > >>> +         */
> > > > >>> +        object_register_sugar_prop(TYPE_VIRTIO_PCI, "disable-l=
egacy",
> > > > >>> +                                   "on", true);
> > > > >>> +        object_register_sugar_prop(TYPE_VIRTIO_DEVICE, "iommu_=
platform",
> > > > >>> +                                   "on", false);     =20
> > > > >>
> > > > >> I have not followed all the history (sorry). Should we also set =
iommu_platform
> > > > >> for virtio-ccw? Halil?
> > > > >>   =20
> > > > >=20
> > > > > That line should add iommu_platform for all virtio devices, shoul=
dn't
> > > > > it?   =20
> > > >=20
> > > > Yes, sorry. Was misreading that with the line above.=20
> > > >    =20
> > >=20
> > > I believe this is the best we can get. In a sense it is still a
> > > pessimization,   =20
> >=20
> > I'm not really clear on what you're getting at here. =20
>=20
> By pessimiziation, I mean that we are going to indicate
> _F_PLATFORM_ACCESS even if it isn't necessary, because the guest never
> opted in for confidential/memory protection/memory encryption. We have
> discussed this before, and I don't see a better solution that works for
> everybody.

If you consider specifying the secure guest option as a way to tell
QEMU to make everything ready for running a secure guest, I'd certainly
consider it necessary. If you do not want to force it, you should not
do the secure guest preparation setup.

--Sig_/zPKYOXDOdv+NokJBOjze+4x
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEw9DWbcNiT/aowBjO3s9rk8bwL68FAl/Pdn0ACgkQ3s9rk8bw
L6/WxQ//f/A6jyDw7guGkEzpz6GouCnT9Rv+qkv2DwDmqMMApEcnKzUW1lF+xLn4
mpJMFa39IgSLzZgxLvSuVTEOPd2TT9kuJoRWatc4G5fZx5EM0yZGaARFJsXLykVp
G1/jn8gNfTe7l1y/EQx1resDpqjg/Tyjo98TZKRKFrOFkGRLJsEyVMI/5gDI+ZuZ
HmrIuR82ptPxWktd/iWkgkQvWv5WjZ47V0l6UKA0VDoXvVcfK/RGlO0nq+tXMrH9
b1jSRYG7jSQCWEXy2Ob/7TLRDlBI7ge0QKy73qumeoK9XOdH0WWZBFQOc3GUDt2I
R9sWJD+xiSs4381NktXN84iWzna41mpHVD5JWd3d65vA/Ad5kI/AmZrTvPZeh3GT
Iln47HOyYmbnmcey5ET65wL6b4HqfIVuWRrB46ue4QMrbXnSh8fsfjJ+tuj2TNl0
bigqqTHhXk4CbgWJF4rn+ppBHLtwycPfadU6jhGGl2Ld0Yj9CVShrOwtgyM1k/JW
MwrqOPpKTenX33/PhB1pl4B7mpXxGItb7FGmmn9qKQMPE1tIUTjdw9SdG3iBETCg
Y9LQEgStJbhtPQESKs93WoXawuTsP3L4Ij1zoMt9J3XytEd36KnhjFkYupTLub5h
foM4guYfcr0Npy0iQ3+3poCq9jnGo9jPi8SWdbrKQUIN0mU/jBI=
=RMCQ
-----END PGP SIGNATURE-----

--Sig_/zPKYOXDOdv+NokJBOjze+4x--

