Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14DD522E9D2
	for <lists+kvm@lfdr.de>; Mon, 27 Jul 2020 12:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgG0KOW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 06:14:22 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:55287 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726139AbgG0KOV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Jul 2020 06:14:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595844859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4D0FWDrKJstlq/XsZeHElwDKoN8X35sOGZ0PfymHnEM=;
        b=F5hjjDAU9Bu+Bdq3EYaleNlgxpDXx/Ps8k2YGA/Ymgflo5z5OTqWYhEhnE/26xjeXwCYnT
        RhqIdPvJf2eTqEc1ioaTNG5yiarDaeyVIaL1jR0UqeM96a36BKJ3SJY69ylbaziCOTC7X2
        RKP9zuVgjsYqPwOQ9usce9XGM2MVys8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-G-pOi4wSNeeaR-wJkvC9vA-1; Mon, 27 Jul 2020 06:14:16 -0400
X-MC-Unique: G-pOi4wSNeeaR-wJkvC9vA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44F1A58;
        Mon, 27 Jul 2020 10:14:14 +0000 (UTC)
Received: from localhost (ovpn-114-74.ams2.redhat.com [10.36.114.74])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0A8195FC36;
        Mon, 27 Jul 2020 10:14:04 +0000 (UTC)
Date:   Mon, 27 Jul 2020 11:14:03 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc:     Stefan Hajnoczi <stefanha@gmail.com>,
        Nikos Dragazis <ndragazis@arrikto.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        "John G. Johnson" <john.g.johnson@oracle.com>,
        Andra-Irina Paraschiv <andraprs@amazon.com>,
        kvm <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        Maxime Coquelin <maxime.coquelin@redhat.com>,
        Alexander Graf <graf@amazon.com>,
        Thanos Makatos <thanos.makatos@nutanix.com>,
        Jag Raman <jag.raman@oracle.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Eric Auger <eric.auger@redhat.com>
Subject: Re: Inter-VM device emulation (call on Mon 20th July 2020)
Message-ID: <20200727101403.GF380177@stefanha-x1.localdomain>
References: <86d42090-f042-06a1-efba-d46d449df280@arrikto.com>
 <20200715112342.GD18817@stefanha-x1.localdomain>
 <CAJSP0QU78mAK-DiOYXvTOEa3=CAEy1rQtyTBe5rrKDs=yfptAg@mail.gmail.com>
 <874kq1w3bz.fsf@linaro.org>
MIME-Version: 1.0
In-Reply-To: <874kq1w3bz.fsf@linaro.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ULyIDA2m8JTe+TiX"
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--ULyIDA2m8JTe+TiX
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 21, 2020 at 11:49:04AM +0100, Alex Benn=E9e wrote:
> Stefan Hajnoczi <stefanha@gmail.com> writes:
> > 2. Alexander Graf's idea for a new Linux driver that provides an
> > enforcing software IOMMU. This would be a character device driver that
> > is mmapped by the device emulation process (either vhost-user-style on
> > the host or another VMM for inter-VM device emulation). The Driver VMM
> > can program mappings into the device and the page tables in the device
> > emulation process will be updated. This way the Driver VMM can share
> > memory specific regions of guest RAM with the device emulation process
> > and revoke those mappings later.
>=20
> I'm wondering if there is enough plumbing on the guest side so a guest
> can use the virtio-iommu to mark out exactly which bits of memory the
> virtual device can have access to? At a minimum the virtqueues need to
> be accessible and for larger transfers maybe a bounce buffer. However
> for speed you want as wide as possible mapping but no more. It would be
> nice for example if a block device could load data directly into the
> guests block cache (zero-copy) but without getting a view of the kernels
> internal data structures.

Maybe Jean-Philippe or Eric can answer that?

> Another thing that came across in the call was quite a lot of
> assumptions about QEMU and Linux w.r.t virtio. While our project will
> likely have Linux as a guest OS we are looking specifically at enabling
> virtio for Type-1 hypervisors like Xen and the various safety certified
> proprietary ones. It is unlikely that QEMU would be used as the VMM for
> these deployments. We want to work out what sort of common facilities
> hypervisors need to support to enable virtio so the daemons can be
> re-usable and maybe setup with a minimal shim for the particular
> hypervisor in question.

The vhost-user protocol together with the backend program conventions
define the wire protocol and command-line interface (see
docs/interop/vhost-user.rst).

vhost-user is already used by other VMMs today. For example,
cloud-hypervisor implements vhost-user.

I'm sure there is room for improvement, but it seems like an incremental
step given that vhost-user already tries to cater for this scenario.

Are there any specific gaps you have identified?

Stefan

--ULyIDA2m8JTe+TiX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl8eqOsACgkQnKSrs4Gr
c8jVuwf/dMUfwXbg5feyaXcjXesUe7kmUPUmxngBBKTNJLAhQpXl8THNOWOAr4B9
2XqUijee0eoY9I8n21RsE/wxYbNpk9NFcSINwwoC8qVAnw4nLEX53QZ9d0dHJqx+
s/3/ONnt1Wn+BOabXpqqhRIGjKCBo3UeT5HGnylNTDEphRnFCDMLg/g19Ekh8yvA
arrCWAKNICAI+LwHsjXf73RrsD6e5s4MdBfjwDARY/0rQFmgo/9Mci8Wm25f8jr6
qpepR/vh4HgZ4BirwOO/D5wPDCq6aVYY79+qRfaIsE/Sgl6tVwXAt71KtfG1Hp5e
6TedqkApkqZjK7WpdsBRDaPvRMtJAQ==
=4idR
-----END PGP SIGNATURE-----

--ULyIDA2m8JTe+TiX--

