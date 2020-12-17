Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42DD32DD43F
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 16:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728429AbgLQPcy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 10:32:54 -0500
Received: from 2.mo51.mail-out.ovh.net ([178.33.255.19]:44096 "EHLO
        2.mo51.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727160AbgLQPcy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Dec 2020 10:32:54 -0500
X-Greylist: delayed 4202 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Dec 2020 10:32:52 EST
Received: from mxplan5.mail.ovh.net (unknown [10.108.4.102])
        by mo51.mail-out.ovh.net (Postfix) with ESMTPS id 5C1002496CD;
        Thu, 17 Dec 2020 15:15:37 +0100 (CET)
Received: from kaod.org (37.59.142.98) by DAG8EX1.mxp5.local (172.16.2.71)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Thu, 17 Dec
 2020 15:15:31 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-98R002eb1eb60c-f1ce-4f5a-a695-035b055ce97f,
                    D250AAD16230E071DBA8D0F8473359178B71E032) smtp.auth=groug@kaod.org
X-OVh-ClientIp: 82.253.208.248
Date:   Thu, 17 Dec 2020 15:15:30 +0100
From:   Greg Kurz <groug@kaod.org>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     David Gibson <david@gibson.dropbear.id.au>, <pair@us.ibm.com>,
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
Message-ID: <20201217151530.54431f0e@bahia.lan>
In-Reply-To: <20201217123842.51063918.cohuck@redhat.com>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
        <20201204054415.579042-12-david@gibson.dropbear.id.au>
        <20201214182240.2abd85eb.cohuck@redhat.com>
        <20201217054736.GH310465@yekko.fritz.box>
        <20201217123842.51063918.cohuck@redhat.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/q5z.CNi9D8q2e6l2k8nde8k";
        protocol="application/pgp-signature"; micalg=pgp-sha256
X-Originating-IP: [37.59.142.98]
X-ClientProxiedBy: DAG5EX2.mxp5.local (172.16.2.42) To DAG8EX1.mxp5.local
 (172.16.2.71)
X-Ovh-Tracer-GUID: 70f337f8-bdb8-4bf1-8a81-ebe8f5481bfe
X-Ovh-Tracer-Id: 7495115682604226969
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedujedrudelgedgiedtucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfgjfhfogggtihesghdtreerredtvdenucfhrhhomhepifhrvghgucfmuhhriicuoehgrhhouhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnheplefggfefueegudegkeevieevveejfffhuddvgeffteekieevueefgfeltdfgieetnecukfhppedtrddtrddtrddtpdefjedrheelrddugedvrdelkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehmgihplhgrnhehrdhmrghilhdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepghhrohhugheskhgrohgurdhorhhgpdhrtghpthhtohepvghhrggskhhoshhtsehrvgguhhgrthdrtghomh
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/q5z.CNi9D8q2e6l2k8nde8k
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 17 Dec 2020 12:38:42 +0100
Cornelia Huck <cohuck@redhat.com> wrote:

> On Thu, 17 Dec 2020 16:47:36 +1100
> David Gibson <david@gibson.dropbear.id.au> wrote:
>=20
> > On Mon, Dec 14, 2020 at 06:22:40PM +0100, Cornelia Huck wrote:
> > > On Fri,  4 Dec 2020 16:44:13 +1100
> > > David Gibson <david@gibson.dropbear.id.au> wrote:
> > >  =20
> > > > We haven't yet implemented the fairly involved handshaking that wil=
l be
> > > > needed to migrate PEF protected guests.  For now, just use a migrat=
ion
> > > > blocker so we get a meaningful error if someone attempts this (this=
 is the
> > > > same approach used by AMD SEV).
> > > >=20
> > > > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > > > Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > > > ---
> > > >  hw/ppc/pef.c | 9 +++++++++
> > > >  1 file changed, 9 insertions(+)
> > > >=20
> > > > diff --git a/hw/ppc/pef.c b/hw/ppc/pef.c
> > > > index 3ae3059cfe..edc3e744ba 100644
> > > > --- a/hw/ppc/pef.c
> > > > +++ b/hw/ppc/pef.c
> > > > @@ -38,7 +38,11 @@ struct PefGuestState {
> > > >  };
> > > > =20
> > > >  #ifdef CONFIG_KVM
> > > > +static Error *pef_mig_blocker;
> > > > +
> > > >  static int kvmppc_svm_init(Error **errp) =20
> > >=20
> > > This looks weird? =20
> >=20
> > Oops.  Not sure how that made it past even my rudimentary compile
> > testing.
> >=20
> > > > +
> > > > +int kvmppc_svm_init(SecurableGuestMemory *sgm, Error **errp)
> > > >  {
> > > >      if (!kvm_check_extension(kvm_state, KVM_CAP_PPC_SECURABLE_GUES=
T)) {
> > > >          error_setg(errp,
> > > > @@ -54,6 +58,11 @@ static int kvmppc_svm_init(Error **errp)
> > > >          }
> > > >      }
> > > > =20
> > > > +    /* add migration blocker */
> > > > +    error_setg(&pef_mig_blocker, "PEF: Migration is not implemente=
d");
> > > > +    /* NB: This can fail if --only-migratable is used */
> > > > +    migrate_add_blocker(pef_mig_blocker, &error_fatal); =20
> > >=20
> > > Just so that I understand: is PEF something that is enabled by the ho=
st
> > > (and the guest is either secured or doesn't start), or is it using a
> > > model like s390x PV where the guest initiates the transition into
> > > secured mode? =20
> >=20
> > Like s390x PV it's initiated by the guest.
> >=20
> > > Asking because s390x adds the migration blocker only when the
> > > transition is actually happening (i.e. guests that do not transition
> > > into secure mode remain migratable.) This has the side effect that you
> > > might be able to start a machine with --only-migratable that
> > > transitions into a non-migratable machine via a guest action, if I'm
> > > not mistaken. Without the new object, I don't see a way to block with
> > > --only-migratable; with it, we should be able to do that. Not sure wh=
at
> > > the desirable behaviour is here. =20
> >=20

The purpose of --only-migratable is specifically to prevent the machine
to transition to a non-migrate state IIUC. The guest transition to
secure mode should be nacked in this case.

> > Hm, I'm not sure what the best option is here either.
>=20
> If we agree on anything, it should be as consistent across
> architectures as possible :)
>=20
> If we want to add the migration blocker to s390x even before the guest
> transitions, it needs to be tied to the new object; if we'd make it
> dependent on the cpu feature bit, we'd block migration of all machines
> on hardware with SE and a recent kernel.
>=20
> Is there a convenient point in time when PEF guests transition where
> QEMU can add a blocker?
>=20
> >=20
> > >  =20
> > > > +
> > > >      return 0;
> > > >  }
> > > >   =20
> > >  =20
> >=20
>=20


--Sig_/q5z.CNi9D8q2e6l2k8nde8k
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEtIKLr5QxQM7yo0kQcdTV5YIvc9YFAl/baAIACgkQcdTV5YIv
c9b/tQ/9EY1sZYjVLPCl4rDkpINniFQpBYvmoIj5KjiVi5cp8g/LWvK/XvvXgoDX
gz3aKzE7cOGJo2BN6BjitohZxgOWWz1wTdqaPP29rzvNAd7iCeByM47tvJ1WBDey
6vBgmdaJZraYX+lcDE6sC7T4dRohZd5Jb0lh+ova937iT5gc8bhdP+AcOgYc/plo
sSB7wHBGUyT2Ror812RXPTns58hmVf/+gPK0eaAb/hE8h/rxieEH8zZJJ0c86ZSU
q+NYb6w4Ylu927EPPnyiaJsZV327GgLnBTRAdG7yi3ndaYDZZi07+ydxazbH6R5U
sP2PXPnxhFUjFc05S7ljcgj3xE9eijLf1Wa7MSH649dXXNNm/tojkXGWrqDi9Lul
HhtmaNUgfal1ufhq7BIiUUr5CNsoaeH5iiIxdcrwqInZaA0pTAdVra375QvRY9ZW
xWTZyEX0+UOQToMqYvyeFp1TvEzPtFy6tmTL48Tnoxjm/jLawgtad2X5pY+HjbnV
HcD1mzwu/7IBX0f+L6KMaYLoOHNPa9O385sgb5kbnEqmCYfiu/h++zP6pgntW9G2
7yAvkaMhOMA4egNHh8iShtxAFLYMFXv99qKSj9MrPWEq14oKeYmD+mzwEQz8UNHl
obBwnSDFFncLrOUbxgVtOPZ2lPF/0o/dNoGcvhpPYWco72TwFQk=
=gjRQ
-----END PGP SIGNATURE-----

--Sig_/q5z.CNi9D8q2e6l2k8nde8k--
