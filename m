Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD7D2F2A63
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 09:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731720AbhALIyV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 03:54:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729530AbhALIyV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 03:54:21 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015EDC061795
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 00:53:40 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DFPW60FVFz9sXH; Tue, 12 Jan 2021 19:53:37 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1610441618;
        bh=+TA4eGKgi7+nqgfxxmX3Nrl1NwY20XrjYaBaNltay9E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K6Ewfaq6i2wS7AE5/prxFaflhjhM5nx26gpMoFqarrOL3RVqY3zjrBjgKXrZNQpXm
         VWO/jxLfbWlt9sRAY6ZXvYSsteh3mpuR8EIcLPGVxmUiSV26EwophKt6pG+lTgNyHv
         1tUpoyrYfWJakWzTJyNdFXiravVks6xwywtMuwM8=
Date:   Tue, 12 Jan 2021 19:36:46 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     pasic@linux.ibm.com, brijesh.singh@amd.com, pair@us.ibm.com,
        dgilbert@redhat.com, qemu-devel@nongnu.org, andi.kleen@intel.com,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Greg Kurz <groug@kaod.org>, frankja@linux.ibm.com,
        thuth@redhat.com, mdroth@linux.vnet.ibm.com,
        richard.henderson@linaro.org, kvm@vger.kernel.org,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <ehabkost@redhat.com>, david@redhat.com,
        Cornelia Huck <cohuck@redhat.com>, mst@redhat.com,
        qemu-s390x@nongnu.org, pragyansri.pathi@intel.com,
        jun.nakajima@intel.com
Subject: Re: [PATCH v6 10/13] spapr: Add PEF based confidential guest support
Message-ID: <20210112083646.GB427679@yekko.fritz.box>
References: <20210112044508.427338-1-david@gibson.dropbear.id.au>
 <20210112044508.427338-11-david@gibson.dropbear.id.au>
 <7d8775df-b3fb-deff-44f2-2e41c83a67ca@de.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Bn2rw/3z4jIqBvZU"
Content-Disposition: inline
In-Reply-To: <7d8775df-b3fb-deff-44f2-2e41c83a67ca@de.ibm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--Bn2rw/3z4jIqBvZU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 12, 2021 at 08:56:53AM +0100, Christian Borntraeger wrote:
>=20
>=20
> On 12.01.21 05:45, David Gibson wrote:
> [...]
> > diff --git a/include/hw/ppc/pef.h b/include/hw/ppc/pef.h
> > new file mode 100644
> > index 0000000000..7c92391177
> > --- /dev/null
> > +++ b/include/hw/ppc/pef.h
> > @@ -0,0 +1,26 @@
> > +/*
> > + * PEF (Protected Execution Facility) for POWER support
> > + *
> > + * Copyright David Gibson, Redhat Inc. 2020
> > + *
> > + * This work is licensed under the terms of the GNU GPL, version 2 or =
later.
> > + * See the COPYING file in the top-level directory.
> > + *
> > + */
> > +
> > +#ifndef HW_PPC_PEF_H
> > +#define HW_PPC_PEF_H
> > +
> > +int pef_kvm_init(ConfidentialGuestSupport *cgs, Error **errp);
> > +
> > +#ifdef CONFIG_KVM
> > +void kvmppc_svm_off(Error **errp);
> > +#else
> > +static inline void kvmppc_svm_off(Error **errp)
> > +{
> > +}
> > +#endif
> > +
> > +
> > +#endif /* HW_PPC_PEF_H */
> > +
>=20
> In case you do a respin,=20
>=20
> git am says
> Applying: confidential guest support: Update documentation
> Applying: spapr: Add PEF based confidential guest support
> .git/rebase-apply/patch:254: new blank line at EOF.
> +
> warning: 1 line adds whitespace errors.
> Applying: spapr: PEF: prevent migration

Oops, corrected.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--Bn2rw/3z4jIqBvZU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl/9X5wACgkQbDjKyiDZ
s5LDoA//b64TM4HncZs/IndLXBQpLjxaM1GSnhMcDx5rU4LEbjQa+jZrevP8N1aj
rLJNYdxogd5n1r0tREKWYYdil6uRw5+MfYWLFLf+fy0kqML1suUvAhq6pOgrtEAj
Ju+bfrQa9HfId1XdhlQ3jTqY+h5jE8D9Tf2nm+zcOt1Do5Gr1d2dy9gn8G3qTNqE
LFt/cEXZRU49Dagj4TFXGzs1yLZxv4bDMA4uOiekheRIwptXoKf67blahy2461qe
yY2n00WNoda4uxHRbdaVq6P5OD49AaQfA4KbY/xc1jKr4eqth65+Bujh1C1f1Lnu
QBhp1W+qNjJ1YRuBmoJGfU6wXgYWtIYF3JkiJzzQs7ubmGyGWI3i2X3766xRChk0
CEWiXBKjq+J3jgmu0oZ3L4ENvmXR2/kMYNK6GEJXRYZowcoAEfjsx4ByP1J7ePKf
NfrCuE7KXZiVoWS9ITfy6MKszSy6DYDRv/vlLUin/Of6/WF/7CIaGr3WDjHUKiMW
1C9xbzR7LBDjlL22DHC+qbuk6v5spHnC/K7Vw6jpfQCrHkEfh6eLag9rpS6TIeB/
2bmrELh/ZuAJfUvhcYZFMvXkW2zOIPVPsJ3cWlNCddekFWRbnpk8446ODYprdHlI
X6Q00lPWrVCIsQN1LTEIgPSxDw5SybFCZz1F+5817u3KepRyoSU=
=NYCn
-----END PGP SIGNATURE-----

--Bn2rw/3z4jIqBvZU--
