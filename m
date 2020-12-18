Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6D92DE221
	for <lists+kvm@lfdr.de>; Fri, 18 Dec 2020 12:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbgLRLnN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Dec 2020 06:43:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51256 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725710AbgLRLnN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Dec 2020 06:43:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608291706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tj9t6kN2UP0QofxsrhdX5RQQ+0Plma+TZ/8BZUbHoM8=;
        b=WFWS3Cluz9FIHEvAr5m+jveVSsvVQPvbEEY6DyDbYQlJc5r2AUphYnq9ihyxn4ua1Gvo8R
        jxU25Bj8sfgwsdiCE6nDkD8j3c3nFFu9RammXbRoYd6uSNZWZznYi7AwnQcgQ6vGEDe1sB
        3A6eYr219lwR+9seKztlis88HEeONxo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-530-Rc_xfMdyM36z5eYhxgiqBA-1; Fri, 18 Dec 2020 06:41:44 -0500
X-MC-Unique: Rc_xfMdyM36z5eYhxgiqBA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 31065B810E;
        Fri, 18 Dec 2020 11:41:42 +0000 (UTC)
Received: from gondolin (ovpn-113-130.ams2.redhat.com [10.36.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 37C1010013C0;
        Fri, 18 Dec 2020 11:41:26 +0000 (UTC)
Date:   Fri, 18 Dec 2020 12:41:11 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Greg Kurz <groug@kaod.org>
Cc:     David Gibson <david@gibson.dropbear.id.au>, <pair@us.ibm.com>,
        <brijesh.singh@amd.com>, <frankja@linux.ibm.com>,
        <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, <david@redhat.com>,
        <qemu-devel@nongnu.org>, <dgilbert@redhat.com>,
        <pasic@linux.ibm.com>, <borntraeger@de.ibm.com>,
        <qemu-s390x@nongnu.org>, <qemu-ppc@nongnu.org>,
        <berrange@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        <thuth@redhat.com>, <pbonzini@redhat.com>, <rth@twiddle.net>,
        <mdroth@linux.vnet.ibm.com>, Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [for-6.0 v5 11/13] spapr: PEF: prevent migration
Message-ID: <20201218124111.4957eb50.cohuck@redhat.com>
In-Reply-To: <20201217151530.54431f0e@bahia.lan>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
        <20201204054415.579042-12-david@gibson.dropbear.id.au>
        <20201214182240.2abd85eb.cohuck@redhat.com>
        <20201217054736.GH310465@yekko.fritz.box>
        <20201217123842.51063918.cohuck@redhat.com>
        <20201217151530.54431f0e@bahia.lan>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=cohuck@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; boundary="Sig_/Vylb/u9=rJguPKl=nAXsyuP";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/Vylb/u9=rJguPKl=nAXsyuP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 17 Dec 2020 15:15:30 +0100
Greg Kurz <groug@kaod.org> wrote:

> On Thu, 17 Dec 2020 12:38:42 +0100
> Cornelia Huck <cohuck@redhat.com> wrote:
>=20
> > On Thu, 17 Dec 2020 16:47:36 +1100
> > David Gibson <david@gibson.dropbear.id.au> wrote:
> >  =20
> > > On Mon, Dec 14, 2020 at 06:22:40PM +0100, Cornelia Huck wrote: =20
> > > > On Fri,  4 Dec 2020 16:44:13 +1100
> > > > David Gibson <david@gibson.dropbear.id.au> wrote:
> > > >    =20
> > > > > We haven't yet implemented the fairly involved handshaking that w=
ill be
> > > > > needed to migrate PEF protected guests.  For now, just use a migr=
ation
> > > > > blocker so we get a meaningful error if someone attempts this (th=
is is the
> > > > > same approach used by AMD SEV).
> > > > >=20
> > > > > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > > > > Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > > > > ---
> > > > >  hw/ppc/pef.c | 9 +++++++++
> > > > >  1 file changed, 9 insertions(+)
> > > > >=20
> > > > > diff --git a/hw/ppc/pef.c b/hw/ppc/pef.c
> > > > > index 3ae3059cfe..edc3e744ba 100644
> > > > > --- a/hw/ppc/pef.c
> > > > > +++ b/hw/ppc/pef.c
> > > > > @@ -38,7 +38,11 @@ struct PefGuestState {
> > > > >  };
> > > > > =20
> > > > >  #ifdef CONFIG_KVM
> > > > > +static Error *pef_mig_blocker;
> > > > > +
> > > > >  static int kvmppc_svm_init(Error **errp)   =20
> > > >=20
> > > > This looks weird?   =20
> > >=20
> > > Oops.  Not sure how that made it past even my rudimentary compile
> > > testing.
> > >  =20
> > > > > +
> > > > > +int kvmppc_svm_init(SecurableGuestMemory *sgm, Error **errp)
> > > > >  {
> > > > >      if (!kvm_check_extension(kvm_state, KVM_CAP_PPC_SECURABLE_GU=
EST)) {
> > > > >          error_setg(errp,
> > > > > @@ -54,6 +58,11 @@ static int kvmppc_svm_init(Error **errp)
> > > > >          }
> > > > >      }
> > > > > =20
> > > > > +    /* add migration blocker */
> > > > > +    error_setg(&pef_mig_blocker, "PEF: Migration is not implemen=
ted");
> > > > > +    /* NB: This can fail if --only-migratable is used */
> > > > > +    migrate_add_blocker(pef_mig_blocker, &error_fatal);   =20
> > > >=20
> > > > Just so that I understand: is PEF something that is enabled by the =
host
> > > > (and the guest is either secured or doesn't start), or is it using =
a
> > > > model like s390x PV where the guest initiates the transition into
> > > > secured mode?   =20
> > >=20
> > > Like s390x PV it's initiated by the guest.
> > >  =20
> > > > Asking because s390x adds the migration blocker only when the
> > > > transition is actually happening (i.e. guests that do not transitio=
n
> > > > into secure mode remain migratable.) This has the side effect that =
you
> > > > might be able to start a machine with --only-migratable that
> > > > transitions into a non-migratable machine via a guest action, if I'=
m
> > > > not mistaken. Without the new object, I don't see a way to block wi=
th
> > > > --only-migratable; with it, we should be able to do that. Not sure =
what
> > > > the desirable behaviour is here.   =20
> > >  =20
>=20
> The purpose of --only-migratable is specifically to prevent the machine
> to transition to a non-migrate state IIUC. The guest transition to
> secure mode should be nacked in this case.

Yes, that's what happens for s390x: The guest tries to transition, QEMU
can't add a migration blocker and fails the instruction used for
transitioning, the guest sees the error.

The drawback is that we see the failure only when we already launched
the machine and the guest tries to transition. If I start QEMU with
--only-migratable, it will refuse to start when non-migratable devices
are configured in the command line, so I see the issue right from the
start. (For s390x, that would possibly mean that we should not even
present the cpu feature bit when only_migratable is set?)

>=20
> > > Hm, I'm not sure what the best option is here either. =20
> >=20
> > If we agree on anything, it should be as consistent across
> > architectures as possible :)
> >=20
> > If we want to add the migration blocker to s390x even before the guest
> > transitions, it needs to be tied to the new object; if we'd make it
> > dependent on the cpu feature bit, we'd block migration of all machines
> > on hardware with SE and a recent kernel.
> >=20
> > Is there a convenient point in time when PEF guests transition where
> > QEMU can add a blocker?
> >  =20
> > >  =20
> > > >    =20
> > > > > +
> > > > >      return 0;
> > > > >  }
> > > > >     =20
> > > >    =20
> > >  =20
> >  =20
>=20


--Sig_/Vylb/u9=rJguPKl=nAXsyuP
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEw9DWbcNiT/aowBjO3s9rk8bwL68FAl/clVcACgkQ3s9rk8bw
L68GvRAAmnQKPZJpT4e4zfPtZUbsiBZNlDXG1PccwMMYQg5aPzggivFHXkLrSiCY
ajxpSsCV4wm7blL/edi5FfxCpF+P73C76xPEW60VqEoKul0asKqNgPygd+5/poO7
zJStU9OY2+kidBworPRHxCibHU6zTY5sRc+An11IXkVARugZqZicuBrYfyBERfpX
go//D9Dcj7BjOho7ektBKsedTOutMQd76Cvi5QBv/Br6eYBjCPBU5PwK7PWOx5vS
Sq1ihjhc30CqcFzWyUSW7eb2Xq63JIIUzeapEAZzGbfkKXywk/nvL2vPn5Dsoeg9
8A3FN2O6u1w2G9KmVEgiF1QPrMyhfpHpQsQC2kNL8qhnkEy4k2TMW37e0sdeOhlk
axR3IygoX63ZwlxcrHijqS/0K7lAUlLcQ8DBgQO526ivNREbyzQqH2mWfmU6MUlx
s9KgSLca0auR0gGULUVwAMlxO6azTR+szPUMn7HD0pjzCDx+T29G+WMOw2QbbjVK
QU0FfRqN33H0GJZp5J6PVhwopVoslmfkxyk44SMnTFxEbysgcC97bPlPaLmDjPuJ
SgszIX+l2k8KLubnnhS9+6iYiMUZH8h9UYr0rCZX5rKlhRnUAw+Gw/wXd8bBG6BZ
nJ+kJa1Ipl5Dm7ZNfhWWyw1L7RKamzoBdXrnTWJ1IboGGFWQ8cg=
=adiW
-----END PGP SIGNATURE-----

--Sig_/Vylb/u9=rJguPKl=nAXsyuP--

