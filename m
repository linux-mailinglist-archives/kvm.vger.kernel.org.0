Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 584062DD093
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 12:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbgLQLkj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 06:40:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60281 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726840AbgLQLki (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Dec 2020 06:40:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608205152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MgOj6EuRPRhgc87E1eKvG+ZcwKY4KgeCGuqpCKprihs=;
        b=hkCyy7VLVQrMcFW8YIq1R6+3YqSx35B9guwNkDODbH6VlF+laTUPt9pRwNe7y/arZGaLoI
        /yXrQm1NzIXgvSYr75wcWzwGszsSO81n1ocpjJJPbZqBjuRaMk1eeEmGMSripW8Tt8oiwD
        3tguQDzgQBdQUZ/2rE6V1M/uAqfNluQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-KUnFFOc5NUOpCTQHrf2Jbw-1; Thu, 17 Dec 2020 06:39:10 -0500
X-MC-Unique: KUnFFOc5NUOpCTQHrf2Jbw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4CB4A59;
        Thu, 17 Dec 2020 11:39:08 +0000 (UTC)
Received: from gondolin (ovpn-113-176.ams2.redhat.com [10.36.113.176])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A1E4F2C314;
        Thu, 17 Dec 2020 11:38:57 +0000 (UTC)
Date:   Thu, 17 Dec 2020 12:38:42 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     pair@us.ibm.com, pbonzini@redhat.com, frankja@linux.ibm.com,
        brijesh.singh@amd.com, dgilbert@redhat.com, qemu-devel@nongnu.org,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-ppc@nongnu.org,
        rth@twiddle.net, thuth@redhat.com, berrange@redhat.com,
        mdroth@linux.vnet.ibm.com, Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        david@redhat.com, Richard Henderson <richard.henderson@linaro.org>,
        borntraeger@de.ibm.com, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        pasic@linux.ibm.com
Subject: Re: [for-6.0 v5 11/13] spapr: PEF: prevent migration
Message-ID: <20201217123842.51063918.cohuck@redhat.com>
In-Reply-To: <20201217054736.GH310465@yekko.fritz.box>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
        <20201204054415.579042-12-david@gibson.dropbear.id.au>
        <20201214182240.2abd85eb.cohuck@redhat.com>
        <20201217054736.GH310465@yekko.fritz.box>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ukk4S5nSA=gXo.pxm5suYdZ";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/ukk4S5nSA=gXo.pxm5suYdZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 17 Dec 2020 16:47:36 +1100
David Gibson <david@gibson.dropbear.id.au> wrote:

> On Mon, Dec 14, 2020 at 06:22:40PM +0100, Cornelia Huck wrote:
> > On Fri,  4 Dec 2020 16:44:13 +1100
> > David Gibson <david@gibson.dropbear.id.au> wrote:
> >  =20
> > > We haven't yet implemented the fairly involved handshaking that will =
be
> > > needed to migrate PEF protected guests.  For now, just use a migration
> > > blocker so we get a meaningful error if someone attempts this (this i=
s the
> > > same approach used by AMD SEV).
> > >=20
> > > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > > Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > > ---
> > >  hw/ppc/pef.c | 9 +++++++++
> > >  1 file changed, 9 insertions(+)
> > >=20
> > > diff --git a/hw/ppc/pef.c b/hw/ppc/pef.c
> > > index 3ae3059cfe..edc3e744ba 100644
> > > --- a/hw/ppc/pef.c
> > > +++ b/hw/ppc/pef.c
> > > @@ -38,7 +38,11 @@ struct PefGuestState {
> > >  };
> > > =20
> > >  #ifdef CONFIG_KVM
> > > +static Error *pef_mig_blocker;
> > > +
> > >  static int kvmppc_svm_init(Error **errp) =20
> >=20
> > This looks weird? =20
>=20
> Oops.  Not sure how that made it past even my rudimentary compile
> testing.
>=20
> > > +
> > > +int kvmppc_svm_init(SecurableGuestMemory *sgm, Error **errp)
> > >  {
> > >      if (!kvm_check_extension(kvm_state, KVM_CAP_PPC_SECURABLE_GUEST)=
) {
> > >          error_setg(errp,
> > > @@ -54,6 +58,11 @@ static int kvmppc_svm_init(Error **errp)
> > >          }
> > >      }
> > > =20
> > > +    /* add migration blocker */
> > > +    error_setg(&pef_mig_blocker, "PEF: Migration is not implemented"=
);
> > > +    /* NB: This can fail if --only-migratable is used */
> > > +    migrate_add_blocker(pef_mig_blocker, &error_fatal); =20
> >=20
> > Just so that I understand: is PEF something that is enabled by the host
> > (and the guest is either secured or doesn't start), or is it using a
> > model like s390x PV where the guest initiates the transition into
> > secured mode? =20
>=20
> Like s390x PV it's initiated by the guest.
>=20
> > Asking because s390x adds the migration blocker only when the
> > transition is actually happening (i.e. guests that do not transition
> > into secure mode remain migratable.) This has the side effect that you
> > might be able to start a machine with --only-migratable that
> > transitions into a non-migratable machine via a guest action, if I'm
> > not mistaken. Without the new object, I don't see a way to block with
> > --only-migratable; with it, we should be able to do that. Not sure what
> > the desirable behaviour is here. =20
>=20
> Hm, I'm not sure what the best option is here either.

If we agree on anything, it should be as consistent across
architectures as possible :)

If we want to add the migration blocker to s390x even before the guest
transitions, it needs to be tied to the new object; if we'd make it
dependent on the cpu feature bit, we'd block migration of all machines
on hardware with SE and a recent kernel.

Is there a convenient point in time when PEF guests transition where
QEMU can add a blocker?

>=20
> >  =20
> > > +
> > >      return 0;
> > >  }
> > >   =20
> >  =20
>=20


--Sig_/ukk4S5nSA=gXo.pxm5suYdZ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIyBAEBCAAdFiEEw9DWbcNiT/aowBjO3s9rk8bwL68FAl/bQ0IACgkQ3s9rk8bw
L6+AFA/4tEcBhNhYOgLqWDrIgP/QxylFpcbIrcxUr5u3yx5AdGqesDKqSgOiMcQX
zNhP4JKbdrIPrgvWiGkknQnbXPy0Z4Ge1OUJ3eGMz+h3/L8cD7Kq51WMwTXK+NUB
hySnI3x7LbNUhAkTFr3jN7OC2GTn+x/c/tSx6kAOGJHWLgN0Mk6cdKvgEHwTRm/I
EW7GCEkpvQKS1ePdYaRHEjNtqFvP45PRg5Li/0hMEuQPkCGE1Wp0MV6kneQ8Z0cw
eY1e6BjBblCJV9ZInWKstJSQGDityJ6ln0xlmF/bhQrmGszs0Jyka/wPyVZdEb73
ypgU51dP6JDU9scKJSNNy/+oOpTDRHw50FrrS7NxF/AXd65QlOkRAveWtc+fWO4b
FH0XlxnAsDLrae8AcGSUtQZzXXebtVtqXQKjV+CtIrR0uEObCLgPRozEQ7bLVqzZ
AwzIOWRFHww/ILvnBxqK76HYfZW3Lc/goTPrpFctwiUvxzPuPau//H6ZgKwhDN+E
QspwFSgRS1hw/PqM/837nlAJcJJsW/9kZpXVeJt4vjyNJxvpysn8pJq/7QGCuolW
A1GvRARCQY/i+chjjobrrkGbN0n6Rro+2V/Mv2HAGR3CUo0uqRsd7nlhb+WHCLBI
wUk8dOlzAsBFNlGBywqOQTxPd9JRoPz7gJGyx6YiNCGS5P96Xg==
=07GC
-----END PGP SIGNATURE-----

--Sig_/ukk4S5nSA=gXo.pxm5suYdZ--

