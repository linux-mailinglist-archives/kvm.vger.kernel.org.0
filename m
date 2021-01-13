Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB1952F42A9
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 04:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725816AbhAMD4G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 22:56:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbhAMD4G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 22:56:06 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CDB6C061575
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 19:55:26 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DFtrW0Jfdz9sVk; Wed, 13 Jan 2021 14:55:22 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1610510123;
        bh=o7jXXA2x7GaNbEYM/sFXeiqik+g/ZU0VZqQwQ7IcERk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AVWI8b1Ih8PLZQU8EUPb6fZwb0Als/xvHN+pUXR4G/24xnkdlGtDeK1neaQes+J38
         icvzVQFzC4ETsAg/lKNdLsjTfxAjVf1FxRJVaMuRT53PxGau2O+dPuVm3cxRcwoo3Y
         rfJDjViwsUcYNXfNGLDghMRbuIs+AVqZLbQ0I/Tw=
Date:   Wed, 13 Jan 2021 13:09:28 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Cc:     pasic@linux.ibm.com, brijesh.singh@amd.com, pair@us.ibm.com,
        dgilbert@redhat.com, qemu-devel@nongnu.org, andi.kleen@intel.com,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Greg Kurz <groug@kaod.org>, frankja@linux.ibm.com,
        thuth@redhat.com, Christian Borntraeger <borntraeger@de.ibm.com>,
        mdroth@linux.vnet.ibm.com, richard.henderson@linaro.org,
        kvm@vger.kernel.org, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <ehabkost@redhat.com>, david@redhat.com,
        Cornelia Huck <cohuck@redhat.com>, mst@redhat.com,
        qemu-s390x@nongnu.org, pragyansri.pathi@intel.com,
        jun.nakajima@intel.com
Subject: Re: [PATCH v6 02/13] confidential guest support: Introduce new
 confidential guest support class
Message-ID: <20210113020928.GK435587@yekko.fritz.box>
References: <20210112044508.427338-1-david@gibson.dropbear.id.au>
 <20210112044508.427338-3-david@gibson.dropbear.id.au>
 <20210112094617.GB1360503@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Qo8f1a4rgWw9S/zY"
Content-Disposition: inline
In-Reply-To: <20210112094617.GB1360503@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--Qo8f1a4rgWw9S/zY
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 12, 2021 at 09:46:17AM +0000, Daniel P. Berrang=E9 wrote:
> On Tue, Jan 12, 2021 at 03:44:57PM +1100, David Gibson wrote:
> > Several architectures have mechanisms which are designed to protect gue=
st
> > memory from interference or eavesdropping by a compromised hypervisor. =
 AMD
> > SEV does this with in-chip memory encryption and Intel's MKTME can do
> > similar things.  POWER's Protected Execution Framework (PEF) accomplish=
es a
> > similar goal using an ultravisor and new memory protection features,
> > instead of encryption.
> >=20
> > To (partially) unify handling for these, this introduces a new
> > ConfidentialGuestSupport QOM base class.  "Confidential" is kind of vag=
ue,
> > but "confidential computing" seems to be the buzzword about these schem=
es,
> > and "secure" or "protected" are often used in connection to unrelated
> > things (such as hypervisor-from-guest or guest-from-guest security).
> >=20
> > The "support" in the name is significant because in at least some of the
> > cases it requires the guest to take specific actions in order to protect
> > itself from hypervisor eavesdropping.
> >=20
> > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > ---
> >  backends/confidential-guest-support.c     | 30 +++++++++++++++
> >  backends/meson.build                      |  1 +
> >  include/exec/confidential-guest-support.h | 46 +++++++++++++++++++++++
> >  include/qemu/typedefs.h                   |  1 +
> >  target/i386/sev.c                         |  3 +-
> >  5 files changed, 80 insertions(+), 1 deletion(-)
> >  create mode 100644 backends/confidential-guest-support.c
> >  create mode 100644 include/exec/confidential-guest-support.h
> >=20
> > diff --git a/backends/confidential-guest-support.c b/backends/confident=
ial-guest-support.c
> > new file mode 100644
> > index 0000000000..2c7793c74f
> > --- /dev/null
> > +++ b/backends/confidential-guest-support.c
> > @@ -0,0 +1,30 @@
> > +/*
> > + * QEMU Confidential Guest support
> > + *
> > + * Copyright: David Gibson, Red Hat Inc. 2020
> > + *
> > + * Authors:
> > + *  David Gibson <david@gibson.dropbear.id.au>
> > + *
> > + * This work is licensed under the terms of the GNU GPL, version 2 or
> > + * later.  See the COPYING file in the top-level directory.
> > + *
> > + */
> > +
> > +#include "qemu/osdep.h"
> > +
> > +#include "exec/confidential-guest-support.h"
> > +
> > +static const TypeInfo confidential_guest_support_info =3D {
> > +    .parent =3D TYPE_OBJECT,
> > +    .name =3D TYPE_CONFIDENTIAL_GUEST_SUPPORT,
> > +    .class_size =3D sizeof(ConfidentialGuestSupportClass),
> > +    .instance_size =3D sizeof(ConfidentialGuestSupport),
> > +};
> > +
> > +static void confidential_guest_support_register_types(void)
> > +{
> > +    type_register_static(&confidential_guest_support_info);
> > +}
> > +
> > +type_init(confidential_guest_support_register_types)
>=20
> This should all be replaced by OBJECT_DEFINE_TYPE

Ah, didn't know about that one.  I also appear to be the first user...

> > diff --git a/backends/meson.build b/backends/meson.build
> > index 484456ece7..d4221831fc 100644
> > --- a/backends/meson.build
> > +++ b/backends/meson.build
> > @@ -6,6 +6,7 @@ softmmu_ss.add([files(
> >    'rng-builtin.c',
> >    'rng-egd.c',
> >    'rng.c',
> > +  'confidential-guest-support.c',
> >  ), numa])
> > =20
> >  softmmu_ss.add(when: 'CONFIG_POSIX', if_true: files('rng-random.c'))
> > diff --git a/include/exec/confidential-guest-support.h b/include/exec/c=
onfidential-guest-support.h
> > new file mode 100644
> > index 0000000000..f9cf170802
> > --- /dev/null
> > +++ b/include/exec/confidential-guest-support.h
> > @@ -0,0 +1,46 @@
> > +/*
> > + * QEMU Confidential Guest support
> > + *   This interface describes the common pieces between various
> > + *   schemes for protecting guest memory or other state against a
> > + *   compromised hypervisor.  This includes memory encryption (AMD's
> > + *   SEV and Intel's MKTME) or special protection modes (PEF on POWER,
> > + *   or PV on s390x).
> > + *
> > + * Copyright: David Gibson, Red Hat Inc. 2020
> > + *
> > + * Authors:
> > + *  David Gibson <david@gibson.dropbear.id.au>
> > + *
> > + * This work is licensed under the terms of the GNU GPL, version 2 or
> > + * later.  See the COPYING file in the top-level directory.
> > + *
> > + */
> > +#ifndef QEMU_CONFIDENTIAL_GUEST_SUPPORT_H
> > +#define QEMU_CONFIDENTIAL_GUEST_SUPPORT_H
> > +
> > +#ifndef CONFIG_USER_ONLY
> > +
> > +#include "qom/object.h"
> > +
> > +#define TYPE_CONFIDENTIAL_GUEST_SUPPORT "confidential-guest-support"
> > +#define CONFIDENTIAL_GUEST_SUPPORT(obj)                               =
     \
> > +    OBJECT_CHECK(ConfidentialGuestSupport, (obj),                     =
     \
> > +                 TYPE_CONFIDENTIAL_GUEST_SUPPORT)
> > +#define CONFIDENTIAL_GUEST_SUPPORT_CLASS(klass)                       =
     \
> > +    OBJECT_CLASS_CHECK(ConfidentialGuestSupportClass, (klass),        =
     \
> > +                       TYPE_CONFIDENTIAL_GUEST_SUPPORT)
> > +#define CONFIDENTIAL_GUEST_SUPPORT_GET_CLASS(obj)                     =
     \
> > +    OBJECT_GET_CLASS(ConfidentialGuestSupportClass, (obj),            =
     \
> > +                     TYPE_CONFIDENTIAL_GUEST_SUPPORT)
> > +
>=20
> This should all be replaced by  OBJECT_DECLARE_TYPE

Also done, no thanks to the incorrect documentation in
docs/devel/qom.rst (it says OBJECT_DECLARE_SIMPLE_TYPE takes 4
arguments rather than 2.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--Qo8f1a4rgWw9S/zY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl/+VlYACgkQbDjKyiDZ
s5I7hw//TEYwsjDu6VQzuX+y0rVU7OWCIuPQn4G+soTK4Nav5/yBGkQniKwF2x0l
x4ujV5oszyBXwCDw9GPvrb2HSxC7q8PmPk6Dv+iT+A/R6s6qtqW7q1KPBwaj4EAj
S0Zu46DJZDC45dMcRpabDm0hUuyCUoqumyOmUBUIYx/Q7IQiR8A478RWEjkr8hvR
oBenmG+1YCkiEG3Ruh6n3RDZ2W8yBlLP5tvhm3KxaJJPDit8zt/0k6pc0HmqKyVY
JCFzu0phwNRb0Ksyqr0mh4+p1hYyvEh6Q9obXRKzZJ+ssyH5GYbayHsGh/O0KXhb
V5huqmFk1iCXFVW7Pan2y2szvOv6i/fH7Pyx01/kaEo1wonll8oiq4Xg6QsvJG1I
LRxLi2lmKjClDGpzgGD8ReJ1Oz3ABnHf58517UHN8NVbNBRl/aMmAV6utPEyjJ/f
Qp9+hfbaLsgbmTQRBs/JOml+PpahmmFHQMiD02nlM1oMiiC1iq7Is0SuShegDrCO
JY5CRIfePoB8tLORzCvmcfQJYbXoWtjt18NTtfWTgTZgsSLY/cgVikU7WPRAIyV5
EYMiiOoyCsnJyrhrFJX79+Z7DLfpM7JJz0oNI7cZS5B+BdeLrTLBx9FvFZ6m/I4L
eQ6ciI1vhDqF5EsENIZ1g9jBUC2BQ+Bf2BMziGP9+xY3Toe3etY=
=gIdm
-----END PGP SIGNATURE-----

--Qo8f1a4rgWw9S/zY--
