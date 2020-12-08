Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1C02D2B53
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 13:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729316AbgLHMpJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 07:45:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35030 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725881AbgLHMpI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Dec 2020 07:45:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607431421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9NjwKxT/SFtSebETsZkqlQUYSJrNizbHsL2kPkriiiI=;
        b=Rowk3x/L720c3YANCmjb3F5tyt8DqoSIfUy7JLBiX+0ygDVLzOTFlc96pRBu5+XIa4DnVo
        Zg140yLbvQ25BpmR2OZYxo55V+iFge/lRA6r78zFqZjbN2vuUQqk1hyG3a4nXZyWd7t6FH
        rUy+LlOq03FCw/EdEn8SRcO339/B76s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-114-n86cLAbHN0u98jWvn_X04A-1; Tue, 08 Dec 2020 07:43:38 -0500
X-MC-Unique: n86cLAbHN0u98jWvn_X04A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 42CF887950E;
        Tue,  8 Dec 2020 12:43:36 +0000 (UTC)
Received: from gondolin (ovpn-113-5.ams2.redhat.com [10.36.113.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 62FC41001901;
        Tue,  8 Dec 2020 12:43:24 +0000 (UTC)
Date:   Tue, 8 Dec 2020 13:43:08 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     David Gibson <david@gibson.dropbear.id.au>
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
Message-ID: <20201208134308.2afa0e3e.cohuck@redhat.com>
In-Reply-To: <20201208025728.GD2555@yekko.fritz.box>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
        <f2419585-4e39-1f3d-9e38-9095e26a6410@de.ibm.com>
        <20201204140205.66e205da.cohuck@redhat.com>
        <20201204130727.GD2883@work-vm>
        <20201204141229.688b11e4.cohuck@redhat.com>
        <20201208025728.GD2555@yekko.fritz.box>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=cohuck@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; boundary="Sig_/zU8XNVbQwRALPRxAVzVqthS";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/zU8XNVbQwRALPRxAVzVqthS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 8 Dec 2020 13:57:28 +1100
David Gibson <david@gibson.dropbear.id.au> wrote:

> On Fri, Dec 04, 2020 at 02:12:29PM +0100, Cornelia Huck wrote:
> > On Fri, 4 Dec 2020 13:07:27 +0000
> > "Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:
> >  =20
> > > * Cornelia Huck (cohuck@redhat.com) wrote: =20
> > > > On Fri, 4 Dec 2020 09:06:50 +0100
> > > > Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> > > >    =20
> > > > > On 04.12.20 06:44, David Gibson wrote:   =20
> > > > > > A number of hardware platforms are implementing mechanisms wher=
eby the
> > > > > > hypervisor does not have unfettered access to guest memory, in =
order
> > > > > > to mitigate the security impact of a compromised hypervisor.
> > > > > >=20
> > > > > > AMD's SEV implements this with in-cpu memory encryption, and In=
tel has
> > > > > > its own memory encryption mechanism.  POWER has an upcoming mec=
hanism
> > > > > > to accomplish this in a different way, using a new memory prote=
ction
> > > > > > level plus a small trusted ultravisor.  s390 also has a protect=
ed
> > > > > > execution environment.
> > > > > >=20
> > > > > > The current code (committed or draft) for these features has ea=
ch
> > > > > > platform's version configured entirely differently.  That doesn=
't seem
> > > > > > ideal for users, or particularly for management layers.
> > > > > >=20
> > > > > > AMD SEV introduces a notionally generic machine option
> > > > > > "machine-encryption", but it doesn't actually cover any cases o=
ther
> > > > > > than SEV.
> > > > > >=20
> > > > > > This series is a proposal to at least partially unify configura=
tion
> > > > > > for these mechanisms, by renaming and generalizing AMD's
> > > > > > "memory-encryption" property.  It is replaced by a
> > > > > > "securable-guest-memory" property pointing to a platform specif=
ic     =20
> > > > >=20
> > > > > Can we do "securable-guest" ?
> > > > > s390x also protects registers and integrity. memory is only one p=
iece
> > > > > of the puzzle and what we protect might differ from platform to=
=20
> > > > > platform.
> > > > >    =20
> > > >=20
> > > > I agree. Even technologies that currently only do memory encryption=
 may
> > > > be enhanced with more protections later.   =20
> > >=20
> > > There's already SEV-ES patches onlist for this on the SEV side.
> > >=20
> > > <sigh on haggling over the name>
> > >=20
> > > Perhaps 'confidential guest' is actually what we need, since the
> > > marketing folks seem to have started labelling this whole idea
> > > 'confidential computing'. =20
>=20
> That's not a bad idea, much as I usually hate marketing terms.  But it
> does seem to be becoming a general term for this style of thing, and
> it doesn't overlap too badly with other terms ("secure" and
> "protected" are also used for hypervisor-from-guest and
> guest-from-guest protection).
>=20
> > It's more like a 'possibly confidential guest', though. =20
>=20
> Hmm.  What about "Confidential Guest Facility" or "Confidential Guest
> Mechanism"?  The implication being that the facility is there, whether
> or not the guest actually uses it.
>=20

"Confidential Guest Enablement"? The others generally sound fine to me
as well, though; not sure if "Facility" might be a bit confusing, as
that term is already a bit overloaded.

--Sig_/zU8XNVbQwRALPRxAVzVqthS
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEw9DWbcNiT/aowBjO3s9rk8bwL68FAl/PdNwACgkQ3s9rk8bw
L68BRA//TCOIZrF+v+dXbOq+uR5phW4kslQrUTC7M7RK7pWVrmP7OJizDIuOfNj4
ev+p+5nspO1c5gYh/m/kU4qy/dwkrR/q/AdZm19lft5fRb/77NFWALdqq6ftH0YK
7IOogAYlmIo2qg1L1ETQdig4MRCNnrThf7NILYU4mHNVWj7TQkwoJEOA0ow00qze
Svd5myUVZqVD3tX6AbKl/kW7/F8oY0kHUWd8zL5JkvG4OtNKrwdv+eIpPTzatTNA
Xr8z5j2VDHhQRFaw/gQg1RJBRSV9eCJbXQ1SpVUdPxBz04hQxYBg8MpfPSlI/ECV
+f6NTiXuUxHpguyKy4gLODcwgDIG5D81FljHYsQc2JS+M0mbqaHZcf5nb7oFhtFt
sLBAOrc6NLG1LjupzExH1LaXZSxjuOEDh7Ow9bTU06DhkxXu32LRundLKcENXVv5
X4Ob1IEFt28djLiDSFJxRyj1K8Yz4vR1QVKulmTD7U9HvXXOCm2EpRLEnO4S/nHf
HBk5fpvQmY8g3eG2/CdZHbc1OI0HNXpfiWCmFYnF3/cB+aVg9dNF2614vQxLTyQN
tFG+4xJxrpkXizwaTnDHRuU80jCPL668UH3cetBOc5L2Q0gbR9EhbKta6X50ZFix
i4B1hE3MnQh28dMTU7w2Z1hdbJLGJ3hINDXfTvoTKAhNEII+FKU=
=Z85K
-----END PGP SIGNATURE-----

--Sig_/zU8XNVbQwRALPRxAVzVqthS--

