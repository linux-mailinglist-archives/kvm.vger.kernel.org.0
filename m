Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C17E3084D8
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 06:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbhA2FJj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 00:09:39 -0500
Received: from ozlabs.org ([203.11.71.1]:44309 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230367AbhA2FJO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jan 2021 00:09:14 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DRljR5jdZz9sW0; Fri, 29 Jan 2021 16:08:27 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1611896907;
        bh=ecrGEu4SVBXZGERHxeftb3q2l9rSohBTiQPV1z2yOGM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kdoNZLglcO6FZb+uStqcLmDVdFH96iNnRD/5yHaVqYgQypGQ+ZfyL75AvecyuciHg
         wk6LQXg0bPobyNywyZavb+3ijbzIEKv/9ZMDYjnFnbWs0ptQxpFQQ8MWy1mgtZgMqb
         qNibVRSe0CzDX5pguBuEe3zHBB1OaBFtKzDfYe5Y=
Date:   Fri, 29 Jan 2021 13:32:09 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     brijesh.singh@amd.com, pair@us.ibm.com, pasic@linux.ibm.com,
        qemu-devel@nongnu.org, cohuck@redhat.com,
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
Subject: Re: [PATCH v7 02/13] confidential guest support: Introduce new
 confidential guest support class
Message-ID: <20210129023209.GH6951@yekko.fritz.box>
References: <20210113235811.1909610-1-david@gibson.dropbear.id.au>
 <20210113235811.1909610-3-david@gibson.dropbear.id.au>
 <20210118185124.GG9899@work-vm>
 <20210121010643.GG5174@yekko.fritz.box>
 <20210121090807.GA3072@work-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="U3BNvdZEnlJXqmh+"
Content-Disposition: inline
In-Reply-To: <20210121090807.GA3072@work-vm>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--U3BNvdZEnlJXqmh+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 21, 2021 at 09:08:07AM +0000, Dr. David Alan Gilbert wrote:
> * David Gibson (david@gibson.dropbear.id.au) wrote:
> > On Mon, Jan 18, 2021 at 06:51:24PM +0000, Dr. David Alan Gilbert wrote:
> > > * David Gibson (david@gibson.dropbear.id.au) wrote:
> > > > Several architectures have mechanisms which are designed to protect=
 guest
> > > > memory from interference or eavesdropping by a compromised hypervis=
or.  AMD
> > > > SEV does this with in-chip memory encryption and Intel's MKTME can =
do
> > >                                                            ^^^^^
> > > (and below) My understanding is that it's Intel TDX that's the VM
> > > equivalent.
> >=20
> > I thought MKTME could already do memory encryption and TDX extended
> > that to... more?  I'll adjust the comment to say TDX anyway, since
> > that seems to be the newer name.
>=20
> My understanding was MKTME does the memory encryption, but doesn't
> explicitly wire that into VMs or attestation of VMs or anything like
> that.  TDX wires that encryption to VMs and provides all the other glue
> that goes with attestation and the like.

Ok.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--U3BNvdZEnlJXqmh+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmATc6kACgkQbDjKyiDZ
s5K9Mg//WMoGmMP8WJ3naEJtzNNsXe1jRRVTFp54CK0UyqFcHiOiPxu79vD0SnS6
zqdtGq+DcgT9Rdd08RrVElNT5tox6E020Yav0gzxA1r6Pv7fNCQeXJqMi+mN77V+
2lONuEOrN9bQsI2DsDIayi2xF7iXvjtXkqeSCW9qWbXXwoW2p0Zz/yo4kRm/6JN5
tHngK47T5OrtUPCdYLB2DUNPWonxpoQVs09G+WZmcWC3g3T8mvcHFjILS/FDrSs7
czvVfwKsuIMnUxxES00hON+ErpIYZwE6hs7woo8EZbRmN2uSTNW+foJOTvuy7bEk
c2JBGwKkZdKwfBqx06QaSsrTd4y3I6+hLT3ggc6J5s3wjzTbh8nXbQBIM8YOsN+S
fwJLfNpfoL8xg9DSX7pZOvNsuyBbNrIvnosg+EEUFYtBq2wo6ORMkBgRYASP5OZI
B1vMLHhuVM4ciARgS0jgT0nxg7rDoNv/1gDGjHmdfA62B4LS118DLYutzouaEbvE
MQlLm2E2Gi7/eW3b8Pz1uXgp22dQxysJ0kADamvnSS7eD0G199XTLvJIfb4yaN2b
shgsjJPtgvl+oBOAz1ZPOrijN6+7pIZPZZ82vjyPg6bZfcnjDJjQn/+eLHoPAj+p
yQJhKYBa9+Om1GgPUXur+lEg8ZJxxYOjztxewlWnXvwYH300CT0=
=NVEn
-----END PGP SIGNATURE-----

--U3BNvdZEnlJXqmh+--
