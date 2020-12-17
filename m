Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5F522DCC6C
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 07:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgLQGWH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 01:22:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbgLQGWH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Dec 2020 01:22:07 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C34C0617A7
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 22:21:27 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4CxMMT2yg5z9sW4; Thu, 17 Dec 2020 17:21:25 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1608186085;
        bh=YdCuD3Vy9G1qMy5stSqn/dM/yhe8CwLet1I0HgO67Rw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iBbMpNbC3XPPzWAhHsMoBhBreH3Kbth7scDIaAZMhmxLv1i2o4/nd9PPeSgKbAJcy
         OVKpptPfSrTTnXgRvY2fEEAgN3Ls4cy36Y0KvIJm9O4KyoljhW2Ytla8cazRS+DgDA
         xGVEhZejg7koVC2Ph1pj5gVDlabbCTDU/A0XHy9U=
Date:   Thu, 17 Dec 2020 17:21:16 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        pair@us.ibm.com, pbonzini@redhat.com, frankja@linux.ibm.com,
        brijesh.singh@amd.com, qemu-devel@nongnu.org,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-ppc@nongnu.org,
        rth@twiddle.net, thuth@redhat.com, berrange@redhat.com,
        mdroth@linux.vnet.ibm.com, Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        david@redhat.com, Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org, qemu-s390x@nongnu.org, pasic@linux.ibm.com
Subject: Re: [for-6.0 v5 00/13] Generalize memory encryption models
Message-ID: <20201217062116.GK310465@yekko.fritz.box>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
 <f2419585-4e39-1f3d-9e38-9095e26a6410@de.ibm.com>
 <20201204140205.66e205da.cohuck@redhat.com>
 <20201204130727.GD2883@work-vm>
 <20201204141229.688b11e4.cohuck@redhat.com>
 <20201208025728.GD2555@yekko.fritz.box>
 <20201208134308.2afa0e3e.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mGCtrYeZ202LI9ZG"
Content-Disposition: inline
In-Reply-To: <20201208134308.2afa0e3e.cohuck@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--mGCtrYeZ202LI9ZG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 08, 2020 at 01:43:08PM +0100, Cornelia Huck wrote:
> On Tue, 8 Dec 2020 13:57:28 +1100
> David Gibson <david@gibson.dropbear.id.au> wrote:
>=20
> > On Fri, Dec 04, 2020 at 02:12:29PM +0100, Cornelia Huck wrote:
> > > On Fri, 4 Dec 2020 13:07:27 +0000
> > > "Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:
> > >  =20
> > > > * Cornelia Huck (cohuck@redhat.com) wrote: =20
> > > > > On Fri, 4 Dec 2020 09:06:50 +0100
> > > > > Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> > > > >    =20
> > > > > > On 04.12.20 06:44, David Gibson wrote:   =20
> > > > > > > A number of hardware platforms are implementing mechanisms wh=
ereby the
> > > > > > > hypervisor does not have unfettered access to guest memory, i=
n order
> > > > > > > to mitigate the security impact of a compromised hypervisor.
> > > > > > >=20
> > > > > > > AMD's SEV implements this with in-cpu memory encryption, and =
Intel has
> > > > > > > its own memory encryption mechanism.  POWER has an upcoming m=
echanism
> > > > > > > to accomplish this in a different way, using a new memory pro=
tection
> > > > > > > level plus a small trusted ultravisor.  s390 also has a prote=
cted
> > > > > > > execution environment.
> > > > > > >=20
> > > > > > > The current code (committed or draft) for these features has =
each
> > > > > > > platform's version configured entirely differently.  That doe=
sn't seem
> > > > > > > ideal for users, or particularly for management layers.
> > > > > > >=20
> > > > > > > AMD SEV introduces a notionally generic machine option
> > > > > > > "machine-encryption", but it doesn't actually cover any cases=
 other
> > > > > > > than SEV.
> > > > > > >=20
> > > > > > > This series is a proposal to at least partially unify configu=
ration
> > > > > > > for these mechanisms, by renaming and generalizing AMD's
> > > > > > > "memory-encryption" property.  It is replaced by a
> > > > > > > "securable-guest-memory" property pointing to a platform spec=
ific     =20
> > > > > >=20
> > > > > > Can we do "securable-guest" ?
> > > > > > s390x also protects registers and integrity. memory is only one=
 piece
> > > > > > of the puzzle and what we protect might differ from platform to=
=20
> > > > > > platform.
> > > > > >    =20
> > > > >=20
> > > > > I agree. Even technologies that currently only do memory encrypti=
on may
> > > > > be enhanced with more protections later.   =20
> > > >=20
> > > > There's already SEV-ES patches onlist for this on the SEV side.
> > > >=20
> > > > <sigh on haggling over the name>
> > > >=20
> > > > Perhaps 'confidential guest' is actually what we need, since the
> > > > marketing folks seem to have started labelling this whole idea
> > > > 'confidential computing'. =20
> >=20
> > That's not a bad idea, much as I usually hate marketing terms.  But it
> > does seem to be becoming a general term for this style of thing, and
> > it doesn't overlap too badly with other terms ("secure" and
> > "protected" are also used for hypervisor-from-guest and
> > guest-from-guest protection).
> >=20
> > > It's more like a 'possibly confidential guest', though. =20
> >=20
> > Hmm.  What about "Confidential Guest Facility" or "Confidential Guest
> > Mechanism"?  The implication being that the facility is there, whether
> > or not the guest actually uses it.
> >=20
>=20
> "Confidential Guest Enablement"? The others generally sound fine to me
> as well, though; not sure if "Facility" might be a bit confusing, as
> that term is already a bit overloaded.

Well, "facility" is a bit overloaded, but IMO "enablement" is even
more so.  I think I'll go with "confidential guest support" in the
next spin.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--mGCtrYeZ202LI9ZG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl/a+NkACgkQbDjKyiDZ
s5LepRAAvDUtft5znuifkMn2ShJlgnkETHq9L4+yDdDH8eke4VQ+qo9rNcFua2ZC
JJXp0JtkHbffpncC6ELcedewIf+iLlccfNvnkdK1weRbzZJfLPL2PTVbmmNbbqVw
Ms2yLpF/5wRHBbYaEAs3iEs8T/0R00Z7R959/UlHhQjtQ/AdJJA1Sy006v7GCxXN
ui44bSpNVrJYkEZ5mNb+nSXXF2Y3U9c8imSidp5AJhkOoH0H0RfmJuwU/Yjtu0dv
QP+ELz1gga4gOmZoHx6GbY2jWF1FgD51O2HgWn7q7Pj0PE1myNRQWa4xvLazScwa
9uqhrYrs8VKVxQUMG2t+rEz/JoP4sK86lCr7GCWzJG2DS5yDnhBznDKmwTklldPH
ovdA8ExYp1AE9XXDcLe+hNv2UbjL61FFz5Ot3wYKEL6LOKZhsTydW/YR5z4Txg/j
MEY3dIGMT5GAVdnPvpKzIcuHMSpRqGbYY6NYuJzFy9Lul0ZQEodEnkwtLkvJ5COH
mHBuiwwUQrflTCx64oDQsF4dgzRfTqese6lrTZOOzSLTd1XSuMgvjhfrWP/6FPk/
eb8E5lFmsKA7G+GOkfC9SqwjgIEUvUQhyzLUXHCtSt9JM/m9cW2sdNBSUkBJ5mV0
8Gt21ST1FmgptBZDUZsdADzd0G0sAw6KFWTPHCnGPypcxggZBKg=
=Vq8q
-----END PGP SIGNATURE-----

--mGCtrYeZ202LI9ZG--
