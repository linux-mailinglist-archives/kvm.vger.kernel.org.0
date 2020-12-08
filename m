Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2D82D2215
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 05:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbgLHE14 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 23:27:56 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:51811 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725917AbgLHE14 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 23:27:56 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4CqnFt04XTz9sWH; Tue,  8 Dec 2020 15:27:13 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1607401634;
        bh=uLVhpwYG528GVhcRqrQTweFelo2TkxGiaGA/dKr/0bM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lqn+yBjIKUDr600AgLpAFD04mM9Wp3AaX+GvNEzqkQNFdEP1ODfrDvc6oU6jhI/a2
         QoMlC0oUdZZieNs3LTYq2WGyZIrit5TohVlUMFH8FKGs9ue9gtofhgHJoNk3RnexVv
         OGUIXq0B0wmrJAqV5jStuvp1fU78aLjXYUCMIEhI=
Date:   Tue, 8 Dec 2020 13:54:27 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>, pair@us.ibm.com,
        pbonzini@redhat.com, frankja@linux.ibm.com, brijesh.singh@amd.com,
        dgilbert@redhat.com, qemu-devel@nongnu.org,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-ppc@nongnu.org,
        rth@twiddle.net, thuth@redhat.com, berrange@redhat.com,
        mdroth@linux.vnet.ibm.com, Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        david@redhat.com, Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org, qemu-s390x@nongnu.org, pasic@linux.ibm.com
Subject: Re: [for-6.0 v5 00/13] Generalize memory encryption models
Message-ID: <20201208025427.GC2555@yekko.fritz.box>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
 <f2419585-4e39-1f3d-9e38-9095e26a6410@de.ibm.com>
 <20201204140205.66e205da.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zCKi3GIZzVBPywwA"
Content-Disposition: inline
In-Reply-To: <20201204140205.66e205da.cohuck@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--zCKi3GIZzVBPywwA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 04, 2020 at 02:02:05PM +0100, Cornelia Huck wrote:
> On Fri, 4 Dec 2020 09:06:50 +0100
> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
>=20
> > On 04.12.20 06:44, David Gibson wrote:
> > > A number of hardware platforms are implementing mechanisms whereby the
> > > hypervisor does not have unfettered access to guest memory, in order
> > > to mitigate the security impact of a compromised hypervisor.
> > >=20
> > > AMD's SEV implements this with in-cpu memory encryption, and Intel has
> > > its own memory encryption mechanism.  POWER has an upcoming mechanism
> > > to accomplish this in a different way, using a new memory protection
> > > level plus a small trusted ultravisor.  s390 also has a protected
> > > execution environment.
> > >=20
> > > The current code (committed or draft) for these features has each
> > > platform's version configured entirely differently.  That doesn't seem
> > > ideal for users, or particularly for management layers.
> > >=20
> > > AMD SEV introduces a notionally generic machine option
> > > "machine-encryption", but it doesn't actually cover any cases other
> > > than SEV.
> > >=20
> > > This series is a proposal to at least partially unify configuration
> > > for these mechanisms, by renaming and generalizing AMD's
> > > "memory-encryption" property.  It is replaced by a
> > > "securable-guest-memory" property pointing to a platform specific =20
> >=20
> > Can we do "securable-guest" ?
> > s390x also protects registers and integrity. memory is only one piece
> > of the puzzle and what we protect might differ from platform to=20
> > platform.
>=20
> I agree. Even technologies that currently only do memory encryption may
> be enhanced with more protections later.

That's a good point.  I've focused on the memory aspect because that's
what's most immediately relevant to qemu - the fact that we can't
directly access guest memory is something we have to deal with, and
has some uniformity regardless of the details of the protection scheme.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--zCKi3GIZzVBPywwA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl/O6uEACgkQbDjKyiDZ
s5KbMA/9ExkApThx4hNRM3f5oA+BqZr/5jCNsCZA5xKa1UCEygo2d2muolidB2Wb
sZKL4AU4/Rj+9FHDw42/ljrS3kKJTR/k3mlOq/Isk2YTSt8Qu4TKeVhI9LZ08CPz
usFtJ8Yzs/W+qSc+MDl+TJqwx1k9JYentrUVOEfkuw+LDwniWyAwOe4UVwqI50e6
xPtbNSsSiRsIYml4vLVLBhKq5ikby+ChR5AaxrLAkPDW+YtuWuWNQEYIy+iPPZQJ
HF1luL0pD3ev1jgj0A5vWhB5aSxQPlwqcDbI8Xx86kI1YimQWvEMbCl6Dloi9UCi
rOfdmQXmD+grIB3aPft/oeSbsRWtMYGd9W0yYCIWTXz3SIaNe016GfqIaQ7g4JrJ
farxYjmGLUYjtuJMzRYNNBEo57GCPuSLkaWtyz/fBzx0WOhmNkmq3SWrkHzyh6U5
THu9huxqo6PNhH/oD7MIex3ImueAh7hkd4pvBpyO8fqbkSoqePghoRWpFhrfdb7/
r3jrDHIMwiJmUmzrTDPsDC6SZJTcFlfKIEMYRQDEOlJwwJAm29UNMaO95wX0vo/k
pI0PBYyAX3aJccwxEnsbpIMXKLDX/yFkJkXZSpswYAzDkHS4F9iM1pL0z9ftM8is
p49C77scmF4onkmWZuC89/cD3OzbMvIa7baJaPz+HusySs9A8lo=
=N0un
-----END PGP SIGNATURE-----

--zCKi3GIZzVBPywwA--
