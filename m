Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45B9A3084D5
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 06:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbhA2FJh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 00:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbhA2FJN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jan 2021 00:09:13 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF35EC061574
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 21:08:29 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DRljS0Wg7z9sWK; Fri, 29 Jan 2021 16:08:27 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1611896908;
        bh=UpjBtnK3bIInQ+D9FHH4Ry5exZuZTlVEokrF10s4D8U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D/ppOCzCDGlh7rw23FWLPUHdlA9zt6mIGtvAwHoggTa1toHAvR3qlKvTk2jBcGlAd
         +EFaeODPyVYmP8U3FPP1nRXJkLa163v9i/YKLXLaD/NPuD5m1RSAkybrN0TFCqYggS
         M15P7133EvK5p+PWD5q7aBfMp14l+NoUX51YT0AI=
Date:   Fri, 29 Jan 2021 13:36:31 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     brijesh.singh@amd.com, pair@us.ibm.com, dgilbert@redhat.com,
        pasic@linux.ibm.com, qemu-devel@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Hildenbrand <david@redhat.com>, borntraeger@de.ibm.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, mst@redhat.com,
        jun.nakajima@intel.com, thuth@redhat.com,
        pragyansri.pathi@intel.com, kvm@vger.kernel.org,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-s390x@nongnu.org,
        qemu-ppc@nongnu.org, frankja@linux.ibm.com,
        Greg Kurz <groug@kaod.org>, mdroth@linux.vnet.ibm.com,
        berrange@redhat.com, andi.kleen@intel.com
Subject: Re: [PATCH v7 09/13] confidential guest support: Update documentation
Message-ID: <20210129023631.GI6951@yekko.fritz.box>
References: <20210113235811.1909610-1-david@gibson.dropbear.id.au>
 <20210113235811.1909610-10-david@gibson.dropbear.id.au>
 <20210115163646.2ecdc329.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ev7mvGV+3JQuI2Eo"
Content-Disposition: inline
In-Reply-To: <20210115163646.2ecdc329.cohuck@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--ev7mvGV+3JQuI2Eo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 15, 2021 at 04:36:46PM +0100, Cornelia Huck wrote:
> On Thu, 14 Jan 2021 10:58:07 +1100
> David Gibson <david@gibson.dropbear.id.au> wrote:
>=20
> > Now that we've implemented a generic machine option for configuring var=
ious
> > confidential guest support mechanisms:
> >   1. Update docs/amd-memory-encryption.txt to reference this rather than
> >      the earlier SEV specific option
> >   2. Add a docs/confidential-guest-support.txt to cover the generalitie=
s of
> >      the confidential guest support scheme
> >=20
> > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > ---
> >  docs/amd-memory-encryption.txt      |  2 +-
> >  docs/confidential-guest-support.txt | 43 +++++++++++++++++++++++++++++
> >  2 files changed, 44 insertions(+), 1 deletion(-)
> >  create mode 100644 docs/confidential-guest-support.txt
> >=20
> > diff --git a/docs/amd-memory-encryption.txt b/docs/amd-memory-encryptio=
n.txt
> > index 80b8eb00e9..145896aec7 100644
> > --- a/docs/amd-memory-encryption.txt
> > +++ b/docs/amd-memory-encryption.txt
> > @@ -73,7 +73,7 @@ complete flow chart.
> >  To launch a SEV guest
> > =20
> >  # ${QEMU} \
> > -    -machine ...,memory-encryption=3Dsev0 \
> > +    -machine ...,confidential-guest-support=3Dsev0 \
> >      -object sev-guest,id=3Dsev0,cbitpos=3D47,reduced-phys-bits=3D1
> > =20
> >  Debugging
> > diff --git a/docs/confidential-guest-support.txt b/docs/confidential-gu=
est-support.txt
> > new file mode 100644
> > index 0000000000..2790425b38
> > --- /dev/null
> > +++ b/docs/confidential-guest-support.txt
>=20
> Maybe make this a proper .rst from the start and hook this up into the
> system guide? It is already almost there.

Hrm.  I considered it, but didn't really want to spend the time
integrating it into the overall structure of the system guide.  I kind
of want to get this dang thing wrapped up.

>=20
> > @@ -0,0 +1,43 @@
> > +Confidential Guest Support
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> > +
> > +Traditionally, hypervisors such as qemu have complete access to a
>=20
> s/qemu/QEMU/ ?

Fixed.

>=20
> > +guest's memory and other state, meaning that a compromised hypervisor
> > +can compromise any of its guests.  A number of platforms have added
> > +mechanisms in hardware and/or firmware which give guests at least some
> > +protection from a compromised hypervisor.  This is obviously
> > +especially desirable for public cloud environments.
> > +
> > +These mechanisms have different names and different modes of
> > +operation, but are often referred to as Secure Guests or Confidential
> > +Guests.  We use the term "Confidential Guest Support" to distinguish
> > +this from other aspects of guest security (such as security against
> > +attacks from other guests, or from network sources).
> > +
> > +Running a Confidential Guest
> > +----------------------------
> > +
> > +To run a confidential guest you need to add two command line parameter=
s:
> > +
> > +1. Use "-object" to create a "confidential guest support" object.  The
> > +   type and parameters will vary with the specific mechanism to be
> > +   used
> > +2. Set the "confidential-guest-support" machine parameter to the ID of
> > +   the object from (1).
> > +
> > +Example (for AMD SEV)::
> > +
> > +    qemu-system-x86_64 \
> > +        <other parameters> \
> > +        -machine ...,confidential-guest-support=3Dsev0 \
> > +        -object sev-guest,id=3Dsev0,cbitpos=3D47,reduced-phys-bits=3D1
> > +
> > +Supported mechanisms
> > +--------------------
> > +
> > +Currently supported confidential guest mechanisms are:
> > +
> > +AMD Secure Encrypted Virtualization (SEV)
> > +    docs/amd-memory-encryption.txt
> > +
> > +Other mechanisms may be supported in future.
>=20
> LGTM.
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--ev7mvGV+3JQuI2Eo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmATdK4ACgkQbDjKyiDZ
s5KHFg//Z0GS2Ob2qP60avL0Smk2/C0AfzV/os/f/mZJGxr5NF0aisVRimkbcgqN
kDhR+ZKHMQIFNLpXEFG+K2v4SzBwAVo8Sxja/U+kicZcKyb31zHbkqwE+OJnEcL6
h1YiousDZwfp6IiFt1goYTAIj66kbGDWyNTeZsM48ev6jVjPS3ZkuiwedVRMuCBi
BBHYAOs3gDfbvG65rJiYaPGAbVWUTSBlO/SxvZb4vr3+0GejB/JngEl96qJsuIbR
oPVO1HlGssucBNRylPHtb67jWZWppzKKvFojodPJbbM7SS5isvg8Pi/DkCuUZLmG
RZorg3znbS+ICS8nNH2UE1UlW2jSNr6BYQ1XCznupINPW75F8h0Cse6VsbCmmN/u
cSFU21m4Jcu28cGWX4fA8B+CpLiH2lbkU6ErKzOec/q1YR4gmlJaLk6XUp0tokzg
2Smzz8WGppqYpsCLrd9wCASP806EkYMlvMdpZ50j8oFQ/YjfRQYALANyxsFzJ06H
y8anrKu0A8DLQAGa9Xwyqvv7p1D2onp6wr3Qrex2WJynv52x7L2+aTZs7RBinIYA
0tzwRAaaZZpB07oGWY4KvGttxGCNZHLmSrlB7KccB5cgxw8XNMrbkEg2KHBlv619
c2lP+RT3boMbn+2+K+EDyRQncguhqNM83eLZ6pnp2s5Q6g4lPxk=
=s81I
-----END PGP SIGNATURE-----

--ev7mvGV+3JQuI2Eo--
