Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4982C9FEE
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 11:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729931AbgLAKgy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Dec 2020 05:36:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32204 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726026AbgLAKgy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Dec 2020 05:36:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606818927;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LH5UWQqwbd5/kxq4lkjgHhruTdGWdGIUaU1fDpEaKt0=;
        b=XHxMkk912o1VSgdNiK8k7A9b3BsRqjQDlma/NpftvgXADZhS/Ju9S2207rK1KTUNCE2zs9
        5sIru3F64bulppJUOJEKdLFhNPvdxnLAD6bhi2o9C/KeAYUChNaORrC76WeKOD+ac+xXk3
        MFQLvZ+NgJwwKyF19pDG7T7K1LTtWlo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-1nfKgaPoMiOisMNycFbxXw-1; Tue, 01 Dec 2020 05:35:25 -0500
X-MC-Unique: 1nfKgaPoMiOisMNycFbxXw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 030CF8558E2;
        Tue,  1 Dec 2020 10:35:24 +0000 (UTC)
Received: from localhost (ovpn-114-82.ams2.redhat.com [10.36.114.82])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8A2636F439;
        Tue,  1 Dec 2020 10:35:17 +0000 (UTC)
Date:   Tue, 1 Dec 2020 10:35:16 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Elena Afanasova <eafanasova@gmail.com>, kvm@vger.kernel.org,
        mst@redhat.com, john.g.johnson@oracle.com, dinechin@redhat.com,
        cohuck@redhat.com, felipe@nutanix.com,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Jag Raman <jag.raman@oracle.com>
Subject: Re: MMIO/PIO dispatch file descriptors (ioregionfd) design discussion
Message-ID: <20201201103516.GD567514@stefanha-x1.localdomain>
References: <CAFO2pHzmVf7g3z0RikQbYnejwcWRtHKV=npALs49eRDJdt4mJQ@mail.gmail.com>
 <0447ec50-6fe8-4f10-73db-e3feec2da61c@redhat.com>
 <20201126123659.GC1180457@stefanha-x1.localdomain>
 <c9f926fb-438c-9588-f018-dd040935e5e5@redhat.com>
 <20201127134403.GB46707@stefanha-x1.localdomain>
 <6001ed07-5823-365e-5235-8bfea0e72c7f@redhat.com>
 <20201130124702.GB422962@stefanha-x1.localdomain>
 <4c1af937-a176-be67-fbcc-2bcf965e0bbc@redhat.com>
MIME-Version: 1.0
In-Reply-To: <4c1af937-a176-be67-fbcc-2bcf965e0bbc@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GpGaEY17fSl8rd50"
Content-Disposition: inline
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--GpGaEY17fSl8rd50
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 01, 2020 at 12:05:04PM +0800, Jason Wang wrote:
>=20
> On 2020/11/30 =E4=B8=8B=E5=8D=888:47, Stefan Hajnoczi wrote:
> > On Mon, Nov 30, 2020 at 10:14:15AM +0800, Jason Wang wrote:
> > > On 2020/11/27 =E4=B8=8B=E5=8D=889:44, Stefan Hajnoczi wrote:
> > > > On Fri, Nov 27, 2020 at 11:39:23AM +0800, Jason Wang wrote:
> > > > > On 2020/11/26 =E4=B8=8B=E5=8D=888:36, Stefan Hajnoczi wrote:
> > > > > > On Thu, Nov 26, 2020 at 11:37:30AM +0800, Jason Wang wrote:
> > > > > > > On 2020/11/26 =E4=B8=8A=E5=8D=883:21, Elena Afanasova wrote:
> > > > > Or I wonder whether we can attach an eBPF program when trapping M=
MIO/PIO and
> > > > > allow it to decide how to proceed?
> > > > The eBPF program approach is interesting, but it would probably req=
uire
> > > > access to guest RAM and additional userspace state (e.g. device-spe=
cific
> > > > register values). I don't know the current status of Linux eBPF - i=
s it
> > > > possible to access user memory (it could be swapped out)?
> > >=20
> > > AFAIK it doesn't, but just to make sure I understand, any reason that=
 eBPF
> > > need to access userspace memory here?
> > Maybe we're thinking of different things. In the past I've thought abou=
t
> > using eBPF to avoid a trip to userspace for request submission and
> > completion, but that requires virtqueue parsing from eBPF and guest RAM
> > access.
>=20
>=20
> I see. I've=C2=A0 considered something similar. e.g using eBPF dataplane =
in
> vhost, but it requires a lot of work. For guest RAM access, we probably c=
an
> provide some eBPF helpers to do that but we need strong point to convince
> eBPF guys.
>=20
>=20
> >=20
> > Are you thinking about replacing ioctl(KVM_SET_IOREGION) and all the
> > necessary kvm.ko code with an ioctl(KVM_SET_IO_PROGRAM), where userspac=
e
> > can load an eBPF program into kvm.ko that gets executed when an MMIO/PI=
O
> > accesses occur?
>=20
>=20
> Yes.
>=20
>=20
> >   Wouldn't it need to write to userspace memory to store
> > the ring index that was written to the doorbell register, for example?
>=20
>=20
> The proram itself can choose want to do:
>=20
> 1) do datamatch and write/wakeup eventfd
>=20
> or
>=20
> 2) transport the write via an arbitrary fd as what has been done in this
> proposal, but the protocol is userspace defined
>
> > How would the program communicate with userspace (eventfd isn't enough)
> > and how can it handle synchronous I/O accesses like reads?
>=20
>=20
> I may miss something, but it can behave exactly as what has been proposed=
 in
> this patch?

I see. This seems to have two possible advantages:
1. Pushing the kvm.ko code into userspace thanks to eBPF. Less kernel
   code.
2. Allowing more flexibile I/O dispatch logic (e.g. ioeventfd-style
   datamatch) and communication protocols.

I think #1 is minor because the communication protocol is trivial,
struct kvm_io_device can be reused for dispatch, and eBPF will introduce
some complexity itself.

#2 is more interesting but I'm not sure how to use this extra
flexibility to get a big advantage. Maybe vfio-user applications could
install an eBPF program that speaks the vfio-user protocol instead of
the ioregionfd protocol, making it easier to integrate ioregionfd into
vfio-user programs?

My opinion is that eBPF complicates things and since we lack a strong
use case for that extra flexibility, I would stick to the ioregionfd
proposal.

Elena, Jason: Do you have any opinions on this?

Stefan

--GpGaEY17fSl8rd50
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/GHGQACgkQnKSrs4Gr
c8iCAggAyI96rYyyD3SlSuwAJyHu4Pbqg8Uj5mOHteBpqeHW/gmyi6WmOt71mZJd
EaKe4e707IbvFqXq3KN1gTh/Oi2Koo3fxeo7GMxACgkeVReZ/f6FAdI5hmAJKL+u
nzHMgQfZN0lxluhydSMN1+zlW5IS3SxAlbeRBJDVm5CgptNOpKKsLD9HsFeL+Ed/
OmoN1N0lqKY/Sq3uJHbx3gzCy8h9AHUReOyk1xCrN8v4XxR/fEJb3vkk59ZvhYOq
BAf0QbQozxBUQ3LTlyuGCMVuHzb/Hd0gnTRpww7wJkqquAzQPiyAU2+vTjtaXWrp
y/zj6IJ9pXsNCSdzy3/Md0PWc4sqTw==
=LrzM
-----END PGP SIGNATURE-----

--GpGaEY17fSl8rd50--

