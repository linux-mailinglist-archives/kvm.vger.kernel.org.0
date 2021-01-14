Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE4672F6079
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 12:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbhANLrH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 06:47:07 -0500
Received: from ozlabs.org ([203.11.71.1]:34935 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726376AbhANLrH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 06:47:07 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DGjFY3GNfz9sWw; Thu, 14 Jan 2021 22:46:24 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1610624785;
        bh=eYbuUr6qAMHUVvbrkUhI4tEKX064pL2xN4y1mwUcdkk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SnB0dkdBea6XQiSw/7rTc29UoG6KVJCtdkskj9TTB9AQCaFYEwwBRY8Oy7C9cWtqx
         WdFn2amrNZAtHPSGHpLB207lZV92mD0Uc0hvbemwcy+upTtUJ0EU6MQJjhj5crxjNK
         geSWUb/+xptq1zjGiwTn18Gqy0HXkqj3KxpD6yK4=
Date:   Thu, 14 Jan 2021 22:45:45 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     brijesh.singh@amd.com, pair@us.ibm.com, dgilbert@redhat.com,
        pasic@linux.ibm.com, qemu-devel@nongnu.org, cohuck@redhat.com,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, mst@redhat.com,
        jun.nakajima@intel.com, thuth@redhat.com,
        pragyansri.pathi@intel.com, kvm@vger.kernel.org,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-s390x@nongnu.org,
        qemu-ppc@nongnu.org, frankja@linux.ibm.com,
        Greg Kurz <groug@kaod.org>, mdroth@linux.vnet.ibm.com,
        berrange@redhat.com, andi.kleen@intel.com
Subject: Re: [PATCH v7 13/13] s390: Recognize confidential-guest-support
 option
Message-ID: <20210114114545.GN435587@yekko.fritz.box>
References: <20210113235811.1909610-1-david@gibson.dropbear.id.au>
 <20210113235811.1909610-14-david@gibson.dropbear.id.au>
 <ba08f5da-e31f-7ae2-898d-a090c5c1b1cf@de.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="kUBUi7JBpjcBtem/"
Content-Disposition: inline
In-Reply-To: <ba08f5da-e31f-7ae2-898d-a090c5c1b1cf@de.ibm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--kUBUi7JBpjcBtem/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 14, 2021 at 10:10:02AM +0100, Christian Borntraeger wrote:
>=20
>=20
> On 14.01.21 00:58, David Gibson wrote:
> [...]
> > +int s390_pv_init(ConfidentialGuestSupport *cgs, Error **errp)
> > +{
> > +    if (!object_dynamic_cast(OBJECT(cgs), TYPE_S390_PV_GUEST)) {
> > +        return 0;
> > +    }
> > +
> > +    if (!s390_has_feat(S390_FEAT_UNPACK)) {
> > +        error_setg(errp,
> > +                   "CPU model does not support Protected Virtualizatio=
n");
> > +        return -1;
> > +    }
>=20
> I am triggering this and I guess this is because the cpu model is not yet=
 initialized at
> this point in time.

Bother.  I thought I'd put the s390_pv_init() call late enough to
avoid that, but I guess not.  Any chance you can debug that?  Working
on s390 is far from easy for me.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--kUBUi7JBpjcBtem/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmAALucACgkQbDjKyiDZ
s5JAKBAA1w2SA9W0omKgLMNME/uZ50d0y3qa9d6i6GGV5d8U4TAZOuMFN1PNq4kQ
Atzok35g1dAiEMj0c6sDdUIsf72CPUH6W4Q1E1Y/rKeNMu7M6BZfdzDEiO7P2WNr
GB9k3OWbfXSWMX2x2+upA0z7O6wwykjM2t4WZTymDlYkClVSOLZ6G5+oXvu/Tc6Y
QTJnqbROFEzEqGaY+SJNYhbZEgJW14lztltmI4Yh/iQ+ujjIHG/3E6XvHyk8sE7C
lFwrgbA/WKCx7X6icbaEYm1kfCwPfZPFVoUu6hktiP4D/5w13SRNczcz6SzaMpOR
XgjDHlGg+7wk6z/+G0D3rrpJqnUeEaOZVxst0nJJxmPSbHP/8s3aJ72XCTgBXHO3
p3c54pba4oV7/wkdV6vXEijQZvJTVR6d+DupKiLeTJXC7xuS/gOQ7u8NJK+8Qe+Y
whHZtkOUL5WJBPowVZbi7lBZqEgvlXhEiHCfmnLPY89puILY41OqRV0J23l3UGvn
xH5ZLB1eEd8N32ne/ULkElcg95cd4eZvzaFD5HPdLU5GEnf6g+1O5E58Lw0ncCx3
JazyplvuK27yIYiceCvEKUVvZ7RCLE3lC3LP2XyhChR83QLJGVIv6f4+GdkHYErC
BgKS8jrtULOaQUu7l/Q0rD7pGkUW2C6nDia7IbQ4oJLtxyD90Y8=
=xdMK
-----END PGP SIGNATURE-----

--kUBUi7JBpjcBtem/--
