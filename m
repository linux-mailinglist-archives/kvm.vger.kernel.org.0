Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86E972ED619
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 18:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728563AbhAGRyq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 12:54:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46335 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728149AbhAGRyq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Jan 2021 12:54:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610041999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=f/OdWK75v8NuDBXgGHj5Fx3mx6y+gGdIr52181tLCJk=;
        b=GoUOOKyM7yBuUV3N/CNSyu1DfXr7IGgpDB+4Ut/NxBUzMLfTJAE6YbhfvznJ1RKVzraFfv
        1lIt1OTco875N1gpAllvkOKstlCCs7TpkR6qiReDFfKhV8y1apwRs9D+KxDFNBv61OGn2u
        NN828Zvp2niZT0gKSCcWUmv8a7n9Ssk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-6l5eMuE8MHyTAq2ynpaINg-1; Thu, 07 Jan 2021 12:53:14 -0500
X-MC-Unique: 6l5eMuE8MHyTAq2ynpaINg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3F50D10766BF;
        Thu,  7 Jan 2021 17:53:13 +0000 (UTC)
Received: from localhost (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D2FF410013C0;
        Thu,  7 Jan 2021 17:53:12 +0000 (UTC)
Date:   Thu, 7 Jan 2021 17:53:11 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Elena Afanasova <eafanasova@gmail.com>, kvm@vger.kernel.org,
        jag.raman@oracle.com, elena.ufimtseva@oracle.com
Subject: Re: [RFC 1/2] KVM: add initial support for KVM_SET_IOREGION
Message-ID: <20210107175311.GA168426@stefanha-x1.localdomain>
References: <d4af2bcbd2c6931a24ba99236248529c3bfb6999.1609231374.git.eafanasova@gmail.com>
 <d79bdf44-9088-e005-3840-03f6bad22ed7@redhat.com>
 <0cc68c81d6fae042d8a84bf90dd77eecd4da7cc8.camel@gmail.com>
 <947ba980-f870-16fb-2ea5-07da617d6bb6@redhat.com>
 <29955fdc90d2efab7b79c91b9a97183e95243cc1.camel@gmail.com>
 <47e8b7e8-d9b8-b2a2-c014-05942d99452a@redhat.com>
 <20210105102517.GA31084@stefanha-x1.localdomain>
 <f9cd33f6-c30d-4e5a-bc45-8f42109fe1ce@redhat.com>
 <20210106150525.GB130669@stefanha-x1.localdomain>
 <32b49857-4ac7-0646-929d-c9238b50bc49@redhat.com>
MIME-Version: 1.0
In-Reply-To: <32b49857-4ac7-0646-929d-c9238b50bc49@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 07, 2021 at 11:30:47AM +0800, Jason Wang wrote:
>=20
> On 2021/1/6 =E4=B8=8B=E5=8D=8811:05, Stefan Hajnoczi wrote:
> > On Wed, Jan 06, 2021 at 01:21:43PM +0800, Jason Wang wrote:
> > > On 2021/1/5 =E4=B8=8B=E5=8D=886:25, Stefan Hajnoczi wrote:
> > > > On Tue, Jan 05, 2021 at 11:53:01AM +0800, Jason Wang wrote:
> > > > > On 2021/1/5 =E4=B8=8A=E5=8D=888:02, Elena Afanasova wrote:
> > > > > > On Mon, 2021-01-04 at 13:34 +0800, Jason Wang wrote:
> > > > > > > On 2021/1/4 =E4=B8=8A=E5=8D=884:32, Elena Afanasova wrote:
> > > > > > > > On Thu, 2020-12-31 at 11:45 +0800, Jason Wang wrote:
> > > > > > > > > On 2020/12/29 =E4=B8=8B=E5=8D=886:02, Elena Afanasova wro=
te:
> > > > > > > > > > This vm ioctl adds or removes an ioregionfd MMIO/PIO re=
gion.
> > > > > > > > > How about FAST_MMIO?
> > > > > > > > >=20
> > > > > > > > I=E2=80=99ll add KVM_IOREGION_FAST_MMIO flag support. So th=
is may be
> > > > > > > > suitable
> > > > > > > > for triggers which could use posted writes. The struct
> > > > > > > > ioregionfd_cmd
> > > > > > > > size bits and the data field will be unused in this case.
> > > > > > > Note that eventfd checks for length and have datamatch suppor=
t. Do
> > > > > > > we
> > > > > > > need to do something similar.
> > > > > > >=20
> > > > > > Do you think datamatch support is necessary for ioregionfd?
> > > > > I'm not sure. But if we don't have this support, it probably mean=
s we can't
> > > > > use eventfd for ioregionfd.
> > > > This is an interesting question because ioregionfd and ioeventfd ha=
ve
> > > > different semantics. While it would be great to support all ioevent=
fd
> > > > features in ioregionfd, I'm not sure that is possible. I think ioev=
entfd
> > > > will remain useful for devices that only need a doorbell write regi=
ster.
> > > >=20
> > > > The differences:
> > > >=20
> > > > 1. ioeventfd has datamatch. This could be implemented in ioregionfd=
 so
> > > >      that a datamatch failure results in the classic ioctl(KVM_RETU=
RN)
> > > >      MMIO/PIO exit reason and the VMM can handle the access.
> > > >=20
> > > >      I'm not sure if this feature is useful though. Most of the tim=
e
> > > >      ioregionfd users want to handle all accesses to the region and=
 the
> > > >      VMM may not even know how to handle register accesses because =
they
> > > >      can only be handled in a dedicated thread or an out-of-process
> > > >      device.
> > >=20
> > > It's about whether or not the current semantic of ioregion is suffici=
ent for
> > > implementing doorbell.
> > >=20
> > > E.g in the case of virtio, the virtqueue index is encoded in the writ=
e to
> > > the doorbell. And if a single MMIO area is used for all virtqueues,
> > > datamatch is probably a must in this case.
> > struct ioregionfd_cmd contains not just the register offset, but also
> > the value written by the guest. Therefore datamatch is not necessary.
> >=20
> > Datamatch would only be useful as some kind of more complex optimizatio=
n
> > where different values writtent to the same register dispatch to
> > different fds.
>=20
>=20
> That's exactly the case of virtio. Consider queue 1,2 shares the MMIO
> register. We need use datamatch to dispatch the notification to different
> eventfds.

I can see two options without datamatch:

1. If both virtqueues are handled by the same userspace thread then only
   1 fd is needed. ioregionfd sends the value written to the register,
   so userspace is able to distinguish between the virtqueues.

2. If separate userspace threads process the virtqueues, then set up the
   virtio-pci capabilities so the virtqueues have separate notification
   registers:
   https://docs.oasis-open.org/virtio/virtio/v1.1/cs01/virtio-v1.1-cs01.htm=
l#x1-1150004

With ioeventfd 2 fds are needed in case #1 because the data value
written to the register is not communicated to userspace. But ioregionfd
does not have this limitation, so I'm not sure whether datamatch is
really needed in ioregionfd?

Or is there a use case that I missed?

> > > > > > > I guess the idea is to have a generic interface to let eventf=
d work
> > > > > > > for
> > > > > > > ioregion as well.
> > > > > > >=20
> > > > > > It seems that posted writes is the only "fast" case in ioregion=
fd. So I
> > > > > > was thinking about using FAST_MMIO for this case only. Maybe in=
 some
> > > > > > cases it will be better to just use ioeventfd. But I'm not sure=
.
> > > > > To be a generic infrastructure, it's better to have this, but we =
can listen
> > > > > from the opinion of others.
> > > > I think we want both FAST_MMIO and regular MMIO options for posted
> > > > writes:
> > > >=20
> > > > 1. FAST_MMIO - ioregionfd_cmd size and data fields are zero and do =
not
> > > >      contain information about the nature of the guest access. This=
 is
> > > >      fine for ioeventfd doorbell style registers because we don't n=
eed
> > > >      that information.
> > >=20
> > > Is FAST_MMIO always for doorbell? If not, we probably need the size a=
nd
> > > data.
> > My understanding is that FAST_MMIO only provides the guest physical
> > address and no additional information. In fact, I'm not even sure if we
> > know whether the access is a read or a write.
> >=20
> > So there is extremely limited information to work with and it's
> > basically only useful for doorbell writes.
> >=20
> > > > 2. Regular MMIO - ioregionfd_cmd size and data fields contain valid=
 data
> > > >      about the nature of the guest access. This is needed when the =
device
> > > >      register is more than a simple "kick" doorbell. For example, i=
f the
> > > >      device needs to know the value that the guest wrote.
> > > >=20
> > > > I suggest defining an additional KVM_SET_IOREGION flag called
> > > > KVM_IOREGION_FAST_MMIO that can be set together with
> > > > KVM_IOREGION_POSTED_WRITES.
> > >=20
> > > If we need to expose FAST_MMIO to userspace, we probably need to defi=
ne its
> > > semantics which is probably not easy since it's an architecture
> > > optimization.
> > Maybe the name KVM_IOREGION_FAST_MMIO name should be changed to
> > something more specific like KVM_IOREGION_OFFSET_ONLY, meaning that onl=
y
> > the offset field is valid.
>=20
>=20
> Or we can do like what eventfd did, implies FAST_MMIO when memory_size is
> zero (kvm_assign_ioeventfd()):
>=20
> =C2=A0=C2=A0=C2=A0 if (!args->len && bus_idx =3D=3D KVM_MMIO_BUS) {
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 ret =3D kvm_assign_ioeventfd_idx(kv=
m, KVM_FAST_MMIO_BUS, args);
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 if (ret < 0)
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 goto fast_fail;
> =C2=A0=C2=A0=C2=A0 }

Yes!

> > I haven't checked if and how other architectures implement FAST_MMIO,
> > but they will at least be able to provide the offset :).
> >=20
> > > > KVM_IOREGION_PIO cannot be used together with KVM_IOREGION_FAST_MMI=
O.
> > > >=20
> > > > In theory KVM_IOREGION_POSTED_WRITES doesn't need to be set with
> > > > KVM_IOREGION_FAST_MMIO. Userspace would have to send back a struct
> > > > ioregionfd_resp to acknowledge that the write has been handled.
> > >=20
> > > Right, and it also depends on whether or not the hardware support (e.=
g
> > > whether or not it can decode the instructions).
> > The KVM_IOREGION_FAST_MMIO flag should be documented as an optimization
> > hint. If hardware doesn't support FAST_MMIO then struct ioregionfd_cmd
> > will contain all fields. Userspace will be able to process the cmd
> > either way.
>=20
>=20
> You mean always have a fallback to MMIO for FAST_MMIO? That should be fin=
e
> but looks less optimal than the implying FAST_MMIO for zero length. I sti=
ll
> think introducing "FAST_MMIO" may bring confusion for users ...

Regarding the fallback, my understanding is that ioeventfds are always
placed on both the MMIO and FAST_MMIO bus when len is zero. That way
architectures that don't support FAST_MMIO will still dispatch those
ioeventfds. In virt/kvm/eventfd.c:kvm_assign_ioeventfd():

  ret =3D kvm_assign_ioeventfd_idx(kvm, bus_idx, args);
  ...
  if (!args->len && bus_idx =3D=3D KVM_MMIO_BUS) {
      ret =3D kvm_assign_ioeventfd_idx(kvm, KVM_FAST_MMIO_BUS, args);

So ioeventfd is already doing this fallback thing.

Let's follow ioeventfd:
1. len=3D0 means the size/data fields are not needed. Userspace cannot
   rely on these fields being valid.
2. There is an automatic fallback to the slow MMIO bus so that slow path
   accesses are still detected by the ioregion.

The explicit KVM_IOREGION_FAST_MMIO flag I mentioned is not needed.

Stefan

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/3SocACgkQnKSrs4Gr
c8ioZAf/eRO+tIL/OlUsSEJm+3dnRW0G/NcRTkj7DzFa7WVqxBMQ0t2OtffIkWp9
UBDchNOvZuprUoYbgkvwixhJYzDUmxl/5HIKs9nhZCtQqpxoWGsnQaDY/ieDdoW/
XfQBx1hvUwYoqXhIqzcN7c2Y8+B8aQekpMZ+J+/8XmVKslaqRtRtkM/Bjulh9EWe
KGgx4VD3Ic+k+bjcVQCJQCMqTQHGk90S8b1wOQB6O3+SdM86eL1g8TCpzeEKQL0e
XMcyjB2N101toGWrHv48GradXBJmSpwDX3Qf7bvzEa+B0YxDMwyBbTsKJpgIkdry
pc3BfXf+Qc3X/MJ5JiD0hqegx53gqg==
=zy4T
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--

