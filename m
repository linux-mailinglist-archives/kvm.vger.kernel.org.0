Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 784941F3FF4
	for <lists+kvm@lfdr.de>; Tue,  9 Jun 2020 17:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731007AbgFIP5q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jun 2020 11:57:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45007 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728888AbgFIP5o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jun 2020 11:57:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591718263;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fNs9jeteGY+3kn+q6WZJCMkhC/sM0vD18diT76nN1QA=;
        b=eo0rULpoWv+IVYeHlDQ2KRlrEqtH1wj/nssK/N99SJq/MGnFQRTup+2sVdHa9G8K/rxxMs
        E0SnP9OLuMAzBD9TFycxcCMX9koY4IM8DMMvw3jBFkb8GyMC7kHzeQO7fESXGfNh80HOno
        152qGBVXcSpzsYn59hzrXCKJQyEp4pY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-nxwQf534OEWcZiQKhDJzQA-1; Tue, 09 Jun 2020 11:57:35 -0400
X-MC-Unique: nxwQf534OEWcZiQKhDJzQA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2820107ACCD;
        Tue,  9 Jun 2020 15:57:33 +0000 (UTC)
Received: from gondolin (ovpn-114-205.ams2.redhat.com [10.36.114.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F2D8719D61;
        Tue,  9 Jun 2020 15:57:27 +0000 (UTC)
Date:   Tue, 9 Jun 2020 17:57:15 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, frankja@linux.ibm.com, dgilbert@redhat.com,
        pair@us.ibm.com, qemu-ppc@nongnu.org, kvm@vger.kernel.org,
        mdroth@linux.vnet.ibm.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [RFC v2 18/18] guest memory protection: Alter virtio default
 properties for protected guests
Message-ID: <20200609175715.26dc7bf8.cohuck@redhat.com>
In-Reply-To: <20200609174046.0a0d83b9.pasic@linux.ibm.com>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
        <20200521034304.340040-19-david@gibson.dropbear.id.au>
        <20200606162014-mutt-send-email-mst@kernel.org>
        <20200607030735.GN228651@umbus.fritz.box>
        <20200609121641.5b3ffa48.cohuck@redhat.com>
        <20200609174046.0a0d83b9.pasic@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; boundary="Sig_/1m1XVfImDtpqQRNdANZgJAd";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/1m1XVfImDtpqQRNdANZgJAd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 9 Jun 2020 17:40:46 +0200
Halil Pasic <pasic@linux.ibm.com> wrote:

> On Tue, 9 Jun 2020 12:16:41 +0200
> Cornelia Huck <cohuck@redhat.com> wrote:
>=20
> > On Sun, 7 Jun 2020 13:07:35 +1000
> > David Gibson <david@gibson.dropbear.id.au> wrote:
> >  =20
> > > On Sat, Jun 06, 2020 at 04:21:31PM -0400, Michael S. Tsirkin wrote: =
=20
> > > > On Thu, May 21, 2020 at 01:43:04PM +1000, David Gibson wrote:   =20
> > > > > The default behaviour for virtio devices is not to use the platfo=
rms normal
> > > > > DMA paths, but instead to use the fact that it's running in a hyp=
ervisor
> > > > > to directly access guest memory.  That doesn't work if the guest'=
s memory
> > > > > is protected from hypervisor access, such as with AMD's SEV or PO=
WER's PEF.
> > > > >=20
> > > > > So, if a guest memory protection mechanism is enabled, then apply=
 the
> > > > > iommu_platform=3Don option so it will go through normal DMA mecha=
nisms.
> > > > > Those will presumably have some way of marking memory as shared w=
ith the
> > > > > hypervisor or hardware so that DMA will work.
> > > > >=20
> > > > > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > > > > ---
> > > > >  hw/core/machine.c | 11 +++++++++++
> > > > >  1 file changed, 11 insertions(+)
> > > > >=20
> > > > > diff --git a/hw/core/machine.c b/hw/core/machine.c
> > > > > index 88d699bceb..cb6580954e 100644
> > > > > --- a/hw/core/machine.c
> > > > > +++ b/hw/core/machine.c
> > > > > @@ -28,6 +28,8 @@
> > > > >  #include "hw/mem/nvdimm.h"
> > > > >  #include "migration/vmstate.h"
> > > > >  #include "exec/guest-memory-protection.h"
> > > > > +#include "hw/virtio/virtio.h"
> > > > > +#include "hw/virtio/virtio-pci.h"
> > > > > =20
> > > > >  GlobalProperty hw_compat_5_0[] =3D {};
> > > > >  const size_t hw_compat_5_0_len =3D G_N_ELEMENTS(hw_compat_5_0);
> > > > > @@ -1159,6 +1161,15 @@ void machine_run_board_init(MachineState *=
machine)
> > > > >           * areas.
> > > > >           */
> > > > >          machine_set_mem_merge(OBJECT(machine), false, &error_abo=
rt);
> > > > > +
> > > > > +        /*
> > > > > +         * Virtio devices can't count on directly accessing gues=
t
> > > > > +         * memory, so they need iommu_platform=3Don to use norma=
l DMA
> > > > > +         * mechanisms.  That requires disabling legacy virtio su=
pport
> > > > > +         * for virtio pci devices
> > > > > +         */
> > > > > +        object_register_sugar_prop(TYPE_VIRTIO_PCI, "disable-leg=
acy", "on");
> > > > > +        object_register_sugar_prop(TYPE_VIRTIO_DEVICE, "iommu_pl=
atform", "on");
> > > > >      }
> > > > >     =20
> > > >=20
> > > > I think it's a reasonable way to address this overall.
> > > > As Cornelia has commented, addressing ccw as well   =20
> > >=20
> > > Sure.  I was assuming somebody who actually knows ccw could do that a=
s
> > > a follow up. =20
> >=20
> > FWIW, I think we could simply enable iommu_platform for protected
> > guests for ccw; no prereqs like pci's disable-legacy.
> >  =20
>=20
> For s390x having a memory-encryption object is not prereq for doing
> protected virtualization, so the scheme does not work for us right now.

Yeah, that would obviously need to be added first.

>=20
> I hope Jansoch will chime in after he is back from his vacation. IMHO
> having a memory-protection object will come in handy for migration,
> but the presence or absence of this object should be largely transparent
> to the user (and not something that needs to be explicitly managed via
> command line). AFAIU this object is in the end it is just QEMU plumbing.
>=20
> > >  =20
> > > > as cases where user has
> > > > specified the property manually could be worth-while.   =20
> > >=20
> > > I don't really see what's to be done there.  I'm assuming that if the
> > > user specifies it, they know what they're doing - particularly with
> > > nonstandard guests there are some odd edge cases where those
> > > combinations might work, they're just not very likely. =20
> >=20
> > If I understood Halil correctly, devices without iommu_platform
> > apparently can crash protected guests on s390. Is that supposed to be a
> > "if it breaks, you get to keep the pieces" situation, or do we really
> > want to enforce iommu_platform? =20
>=20
> I strongly oppose to adopting the "if it breaks, you get to keep the
> pieces" strategy here. It is borderline acceptable on startup, although
> IMHO not preferable, but a device hotplug bringing down a guest that is
> already running userspace is not acceptable at all.

There's still the option to fail to add such a device, though.

--Sig_/1m1XVfImDtpqQRNdANZgJAd
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEw9DWbcNiT/aowBjO3s9rk8bwL68FAl7fsVsACgkQ3s9rk8bw
L6/luw//crG/w8vGDPyO1tMEdwanZmr0GSRCJVQWv7IH0x4Sp18c0cgu3/Fqk323
KZIEf8LLb4IpyOG6jGiahYSWpO0ugn/cF9ABraTpQxCDqoJwnw6O1yoZ+/PizZRJ
cydd16TNwC4ygTxJJ+SE5ozuG4/QzsDn0h5njD4WuAuGQcAwZQUfyy+XrGNgEN3n
sTFSsbvuYgGBlu+WADUo5WyuSc79QppRasLQX/p4+u6M1Laye588SN871BNyU3Uu
svo+iCBmy+PImc0wpDmTx7laJNiNOuOMrTuf+EEqnq0SEBjXGMX3Q8WewheoZomB
PavCkM3eBx620jsaBv8dUb18NjD8+ijLZmTprbpSu0zMcmwV1Q90GebZPXC6Tk+s
XBsBt8bcmGzZ5AU5NiMw1VoWVmGLEbnnyZ4zuGxxs1AjtU4rXeWxB40KStaS8f0+
7iZCd+UEMQUZdx/1qZJS3+ftfmfotI5j/3dCoB9ZLR/UbXCQoFdAUPTCew4WO2Im
6IRttLEfSBqu6HueaazUTG92XFegYQCI/Zfa//n7l0KV2e+BGcVW4KTP582nTqCN
KD6vMj16rUupVaT5PiqNor9ICRm53MlHBa6f49dGSlX4o+9EOQXGsp5XFURxxZOa
o9rrmXlMDmLibgZmi34EZ+c9lXMtF0mp4oHf+W6LRFvAsd33mGM=
=jAji
-----END PGP SIGNATURE-----

--Sig_/1m1XVfImDtpqQRNdANZgJAd--

