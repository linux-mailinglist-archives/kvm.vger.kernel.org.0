Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E843F2EC01E
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 16:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbhAFPG6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 10:06:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32433 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726244AbhAFPG5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Jan 2021 10:06:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609945530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fYex91jA6x2qKKHkVZTfUQgO63knxON/afs5s1CqX+c=;
        b=BgXXo23H6h0vg7z6i3sl2Eavn+asLtfWiIsPAZRlK7Sd6eckuMFmq0i8wNo5MaMquYhZOn
        7QCVm06eWgEJVmH7tZHpevuCBPRAXN6HKPSJ1VocKXEv3amnEBQ+bMvWvRbhRHN8X2NsNC
        9WYfbTAtMrY/dr5tn/NNZNiJlGKhaNs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-539-bzuZCdR_M3qUSfSnOXgp2Q-1; Wed, 06 Jan 2021 10:05:27 -0500
X-MC-Unique: bzuZCdR_M3qUSfSnOXgp2Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9BACB9CC03;
        Wed,  6 Jan 2021 15:05:26 +0000 (UTC)
Received: from localhost (ovpn-113-208.ams2.redhat.com [10.36.113.208])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F35410021AA;
        Wed,  6 Jan 2021 15:05:26 +0000 (UTC)
Date:   Wed, 6 Jan 2021 15:05:25 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Elena Afanasova <eafanasova@gmail.com>, kvm@vger.kernel.org,
        jag.raman@oracle.com, elena.ufimtseva@oracle.com
Subject: Re: [RFC 1/2] KVM: add initial support for KVM_SET_IOREGION
Message-ID: <20210106150525.GB130669@stefanha-x1.localdomain>
References: <cover.1609231373.git.eafanasova@gmail.com>
 <d4af2bcbd2c6931a24ba99236248529c3bfb6999.1609231374.git.eafanasova@gmail.com>
 <d79bdf44-9088-e005-3840-03f6bad22ed7@redhat.com>
 <0cc68c81d6fae042d8a84bf90dd77eecd4da7cc8.camel@gmail.com>
 <947ba980-f870-16fb-2ea5-07da617d6bb6@redhat.com>
 <29955fdc90d2efab7b79c91b9a97183e95243cc1.camel@gmail.com>
 <47e8b7e8-d9b8-b2a2-c014-05942d99452a@redhat.com>
 <20210105102517.GA31084@stefanha-x1.localdomain>
 <f9cd33f6-c30d-4e5a-bc45-8f42109fe1ce@redhat.com>
MIME-Version: 1.0
In-Reply-To: <f9cd33f6-c30d-4e5a-bc45-8f42109fe1ce@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="H+4ONPRPur6+Ovig"
Content-Disposition: inline
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--H+4ONPRPur6+Ovig
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 06, 2021 at 01:21:43PM +0800, Jason Wang wrote:
>=20
> On 2021/1/5 =E4=B8=8B=E5=8D=886:25, Stefan Hajnoczi wrote:
> > On Tue, Jan 05, 2021 at 11:53:01AM +0800, Jason Wang wrote:
> > > On 2021/1/5 =E4=B8=8A=E5=8D=888:02, Elena Afanasova wrote:
> > > > On Mon, 2021-01-04 at 13:34 +0800, Jason Wang wrote:
> > > > > On 2021/1/4 =E4=B8=8A=E5=8D=884:32, Elena Afanasova wrote:
> > > > > > On Thu, 2020-12-31 at 11:45 +0800, Jason Wang wrote:
> > > > > > > On 2020/12/29 =E4=B8=8B=E5=8D=886:02, Elena Afanasova wrote:
> > > > > > > > This vm ioctl adds or removes an ioregionfd MMIO/PIO region=
.
> > > > > > > How about FAST_MMIO?
> > > > > > >=20
> > > > > > I=E2=80=99ll add KVM_IOREGION_FAST_MMIO flag support. So this m=
ay be
> > > > > > suitable
> > > > > > for triggers which could use posted writes. The struct
> > > > > > ioregionfd_cmd
> > > > > > size bits and the data field will be unused in this case.
> > > > > Note that eventfd checks for length and have datamatch support. D=
o
> > > > > we
> > > > > need to do something similar.
> > > > >=20
> > > > Do you think datamatch support is necessary for ioregionfd?
> > >=20
> > > I'm not sure. But if we don't have this support, it probably means we=
 can't
> > > use eventfd for ioregionfd.
> > This is an interesting question because ioregionfd and ioeventfd have
> > different semantics. While it would be great to support all ioeventfd
> > features in ioregionfd, I'm not sure that is possible. I think ioeventf=
d
> > will remain useful for devices that only need a doorbell write register=
.
> >=20
> > The differences:
> >=20
> > 1. ioeventfd has datamatch. This could be implemented in ioregionfd so
> >     that a datamatch failure results in the classic ioctl(KVM_RETURN)
> >     MMIO/PIO exit reason and the VMM can handle the access.
> >=20
> >     I'm not sure if this feature is useful though. Most of the time
> >     ioregionfd users want to handle all accesses to the region and the
> >     VMM may not even know how to handle register accesses because they
> >     can only be handled in a dedicated thread or an out-of-process
> >     device.
>=20
>=20
> It's about whether or not the current semantic of ioregion is sufficient =
for
> implementing doorbell.
>=20
> E.g in the case of virtio, the virtqueue index is encoded in the write to
> the doorbell. And if a single MMIO area is used for all virtqueues,
> datamatch is probably a must in this case.

struct ioregionfd_cmd contains not just the register offset, but also
the value written by the guest. Therefore datamatch is not necessary.

Datamatch would only be useful as some kind of more complex optimization
where different values writtent to the same register dispatch to
different fds.

> > > > > I guess the idea is to have a generic interface to let eventfd wo=
rk
> > > > > for
> > > > > ioregion as well.
> > > > >=20
> > > > It seems that posted writes is the only "fast" case in ioregionfd. =
So I
> > > > was thinking about using FAST_MMIO for this case only. Maybe in som=
e
> > > > cases it will be better to just use ioeventfd. But I'm not sure.
> > >=20
> > > To be a generic infrastructure, it's better to have this, but we can =
listen
> > > from the opinion of others.
> > I think we want both FAST_MMIO and regular MMIO options for posted
> > writes:
> >=20
> > 1. FAST_MMIO - ioregionfd_cmd size and data fields are zero and do not
> >     contain information about the nature of the guest access. This is
> >     fine for ioeventfd doorbell style registers because we don't need
> >     that information.
>=20
>=20
> Is FAST_MMIO always for doorbell? If not, we probably need the size and
> data.

My understanding is that FAST_MMIO only provides the guest physical
address and no additional information. In fact, I'm not even sure if we
know whether the access is a read or a write.

So there is extremely limited information to work with and it's
basically only useful for doorbell writes.

> > 2. Regular MMIO - ioregionfd_cmd size and data fields contain valid dat=
a
> >     about the nature of the guest access. This is needed when the devic=
e
> >     register is more than a simple "kick" doorbell. For example, if the
> >     device needs to know the value that the guest wrote.
> >=20
> > I suggest defining an additional KVM_SET_IOREGION flag called
> > KVM_IOREGION_FAST_MMIO that can be set together with
> > KVM_IOREGION_POSTED_WRITES.
>=20
>=20
> If we need to expose FAST_MMIO to userspace, we probably need to define i=
ts
> semantics which is probably not easy since it's an architecture
> optimization.

Maybe the name KVM_IOREGION_FAST_MMIO name should be changed to
something more specific like KVM_IOREGION_OFFSET_ONLY, meaning that only
the offset field is valid.

I haven't checked if and how other architectures implement FAST_MMIO,
but they will at least be able to provide the offset :).

> > KVM_IOREGION_PIO cannot be used together with KVM_IOREGION_FAST_MMIO.
> >=20
> > In theory KVM_IOREGION_POSTED_WRITES doesn't need to be set with
> > KVM_IOREGION_FAST_MMIO. Userspace would have to send back a struct
> > ioregionfd_resp to acknowledge that the write has been handled.
>=20
>=20
> Right, and it also depends on whether or not the hardware support (e.g
> whether or not it can decode the instructions).

The KVM_IOREGION_FAST_MMIO flag should be documented as an optimization
hint. If hardware doesn't support FAST_MMIO then struct ioregionfd_cmd
will contain all fields. Userspace will be able to process the cmd
either way.

Stefan

--H+4ONPRPur6+Ovig
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/10bUACgkQnKSrs4Gr
c8iLvwgAq+L7035forG8ztElKZcRsTHV/5nfZr20ruGRiBfIWX/Mav9cF55gd2+p
2/BDRBvXDTNFN+6PbuZZTu3r5NFYcPob2i5nSgEqTO6hkBT8w+Ph/5EONbE4pY99
LO+uNli6i/9RccS0pwM0uDuHvsC/c+ysua6DPlokKUTMnVfpLor4yzNdk1/IW+BW
9CSh7zOXBN3Awg3e/rUmp+O9n4fOpD/aHR7af4Sg6nyB77RFpJwa6f+1EiqhXnG0
uPlX5zEF23TaS8xwOM69L3DjPWT25z76ftGoJSsj8a2RJ5lM0i5VqfWJ1S4h/Wep
l9YnSMl7/y1D6+FiLSe4UrGo85kIWQ==
=xrbX
-----END PGP SIGNATURE-----

--H+4ONPRPur6+Ovig--

