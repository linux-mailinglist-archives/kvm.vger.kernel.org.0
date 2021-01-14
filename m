Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F92F2F659A
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 17:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbhANQSZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 11:18:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30764 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725982AbhANQSY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Jan 2021 11:18:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610641018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EA4UpQ1IZhJnwtsg8Il/88NAze3jmey1mc8oMJiQl6Y=;
        b=U+NqDvMCFnIttKUASqqAGKyDrPcyobIM1klsSMaMxaJb2TYOyBUfvS2KyQti29g6zaJXI2
        p4Tki08n9r9XEubcFk0m65pKuojHqomnMPDd6oO/UMEbwUUkbOS/xfXAJYAVkZBaFuwIBY
        hrEdkApnJmAmtd4VJ4rMkEpaVfuP8vQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-9TEb_TkIOsCfBsJxTEe6bQ-1; Thu, 14 Jan 2021 11:16:54 -0500
X-MC-Unique: 9TEb_TkIOsCfBsJxTEe6bQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EEBB2806662;
        Thu, 14 Jan 2021 16:16:52 +0000 (UTC)
Received: from localhost (ovpn-115-113.ams2.redhat.com [10.36.115.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8EEE119C71;
        Thu, 14 Jan 2021 16:16:52 +0000 (UTC)
Date:   Thu, 14 Jan 2021 16:16:51 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Elena Afanasova <eafanasova@gmail.com>, kvm@vger.kernel.org,
        jag.raman@oracle.com, elena.ufimtseva@oracle.com
Subject: Re: [RFC 1/2] KVM: add initial support for KVM_SET_IOREGION
Message-ID: <20210114161651.GG292902@stefanha-x1.localdomain>
References: <29955fdc90d2efab7b79c91b9a97183e95243cc1.camel@gmail.com>
 <47e8b7e8-d9b8-b2a2-c014-05942d99452a@redhat.com>
 <20210105102517.GA31084@stefanha-x1.localdomain>
 <f9cd33f6-c30d-4e5a-bc45-8f42109fe1ce@redhat.com>
 <20210106150525.GB130669@stefanha-x1.localdomain>
 <32b49857-4ac7-0646-929d-c9238b50bc49@redhat.com>
 <20210107175311.GA168426@stefanha-x1.localdomain>
 <e22eaf2b-15f6-5b41-75a8-0e9b24e84e16@redhat.com>
 <20210113155205.GA270353@stefanha-x1.localdomain>
 <7bdcf76d-9eba-428a-bf40-0434934f24a9@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="B8ONY/mu/bqBak9m"
Content-Disposition: inline
In-Reply-To: <7bdcf76d-9eba-428a-bf40-0434934f24a9@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--B8ONY/mu/bqBak9m
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 14, 2021 at 12:05:00PM +0800, Jason Wang wrote:
>=20
> On 2021/1/13 =E4=B8=8B=E5=8D=8811:52, Stefan Hajnoczi wrote:
> > On Wed, Jan 13, 2021 at 10:38:29AM +0800, Jason Wang wrote:
> > > On 2021/1/8 =E4=B8=8A=E5=8D=881:53, Stefan Hajnoczi wrote:
> > > > On Thu, Jan 07, 2021 at 11:30:47AM +0800, Jason Wang wrote:
> > > > > On 2021/1/6 =E4=B8=8B=E5=8D=8811:05, Stefan Hajnoczi wrote:
> > > > > > On Wed, Jan 06, 2021 at 01:21:43PM +0800, Jason Wang wrote:
> > > > > > > On 2021/1/5 =E4=B8=8B=E5=8D=886:25, Stefan Hajnoczi wrote:
> > > > > > > > On Tue, Jan 05, 2021 at 11:53:01AM +0800, Jason Wang wrote:
> > > > > > > > > On 2021/1/5 =E4=B8=8A=E5=8D=888:02, Elena Afanasova wrote:
> > > > > > > > > > On Mon, 2021-01-04 at 13:34 +0800, Jason Wang wrote:
> > > > > > > > > > > On 2021/1/4 =E4=B8=8A=E5=8D=884:32, Elena Afanasova w=
rote:
> > > > > > > > > > > > On Thu, 2020-12-31 at 11:45 +0800, Jason Wang wrote:
> > > > > > > > > > > > > On 2020/12/29 =E4=B8=8B=E5=8D=886:02, Elena Afana=
sova wrote:
> > > > 2. If separate userspace threads process the virtqueues, then set u=
p the
> > > >      virtio-pci capabilities so the virtqueues have separate notifi=
cation
> > > >      registers:
> > > >      https://docs.oasis-open.org/virtio/virtio/v1.1/cs01/virtio-v1.=
1-cs01.html#x1-1150004
> > >=20
> > > Right. But this works only when PCI transport is used and queue index=
 could
> > > be deduced from the register address (separated doorbell).
> > >=20
> > > If we use MMIO or sharing the doorbell registers among all the virtqu=
eues
> > > (multiplexer is zero in the above case) , it can't work without datam=
atch.
> > True. Can you think of an application that needs to dispatch a shared
> > doorbell register to several threads?
>=20
>=20
> I think it depends on semantic of doorbell register. I guess one example =
is
> the virito-mmio multiqueue device.

Good point. virtio-mmio really needs datamatch if virtqueues are handled
by different threads.

> > If this is a case that real-world applications need then we should
> > tackle it. This is where eBPF would be appropriate. I guess the
> > interface would be something like:
> >=20
> >    /*
> >     * A custom demultiplexer function that returns the index of the <wf=
d,
> >     * rfd> pair to use or -1 to produce a KVM_EXIT_IOREGION_FAILURE that
> >     * userspace must handle.
> >     */
> >    int demux(const struct ioregionfd_cmd *cmd);
> >=20
> > Userspace can install an eBPF demux function as well as an array of
> > <wfd, rfd> fd pairs. The demux function gets to look at the cmd in order
> > to decide which fd pair it is sent to.
> >=20
> > This is how I think eBPF datamatch could work. It's not as general as in
> > our original discussion where we also talked about custom protocols
> > (instead of struct ioregionfd_cmd/struct ioregionfd_resp).
>=20
>=20
> Actually they are not conflict. We can make it a eBPF ioregion, then it's
> the eBPF program that can decide:
>=20
> 1) whether or not it need to do datamatch
> 2) how many file descriptors it want to use (store the fd in a map)
> 3) how will the protocol looks like
>=20
> But as discussed it could be an add-on on top of the hard logic of ioregi=
on
> since there could be case that eBPF may not be allowed not not supported.=
 So
> adding simple datamatch support as a start might be a good choice.

Let's go further. Can you share pseudo-code for the eBPF program's
function signature (inputs/outputs)?

Stefan

--B8ONY/mu/bqBak9m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAAbnMACgkQnKSrs4Gr
c8i9AwgAliWvISL6nVSOHnXQqLaJglJ37iMRSpJiPSOFQjk5e4BDhqjHnztYoz9C
Dv/0dkxljvHNkx/ELYg+qWeV+g9cWLVrE03U5lad2L+uu0mF0GwuLe/juGhPbYx/
NnIdex6k0KKIOLymId0qj1gf71KbzsIwHCVWsT+4o7tqjqmYY0vaIz+Nm8jWn+rZ
elWaNOz9ulTbJrQO+KLK0zfSsN97YEegR9eji/cxBdZUiTCgipdPYoNcyet5U1bD
lIqbliVEoMquvj/ORpWM7itlfCp9cV5DVyvdVfq7CQVjrdXisZyX0zkdoiKgCn2k
b7XcGKu/yKpKv6kojmQR22P2Dt272w==
=nREX
-----END PGP SIGNATURE-----

--B8ONY/mu/bqBak9m--

