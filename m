Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A44FB2F4F42
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 16:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbhAMPxn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 10:53:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48244 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725773AbhAMPxn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 10:53:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610553136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H8D1i0KVkxfWhGz/c4/dBK06vC5FnRwBZHGKt3I3xFU=;
        b=S0hW6QPZqC5OPvoybzYRpLxXh54cjvrXMsBvFqJVnFsY4a72uOpphj04sAJbxOdVGl3PA5
        R3tJWCA6WQ4B5LAva5bSpXUoQEXleFz7Ik9o4EmQN+scE3ch7hIk9Ylgl5R6kGF2f+8fYp
        +lwUxo2Atl5jjobLYTITVVd+0O0MGTI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-225-7FHzBZV8NE678b9QBs73Xw-1; Wed, 13 Jan 2021 10:52:09 -0500
X-MC-Unique: 7FHzBZV8NE678b9QBs73Xw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9AFC5192D78C;
        Wed, 13 Jan 2021 15:52:08 +0000 (UTC)
Received: from localhost (ovpn-115-141.ams2.redhat.com [10.36.115.141])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3041F6F984;
        Wed, 13 Jan 2021 15:52:06 +0000 (UTC)
Date:   Wed, 13 Jan 2021 15:52:05 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Elena Afanasova <eafanasova@gmail.com>, kvm@vger.kernel.org,
        jag.raman@oracle.com, elena.ufimtseva@oracle.com
Subject: Re: [RFC 1/2] KVM: add initial support for KVM_SET_IOREGION
Message-ID: <20210113155205.GA270353@stefanha-x1.localdomain>
References: <0cc68c81d6fae042d8a84bf90dd77eecd4da7cc8.camel@gmail.com>
 <947ba980-f870-16fb-2ea5-07da617d6bb6@redhat.com>
 <29955fdc90d2efab7b79c91b9a97183e95243cc1.camel@gmail.com>
 <47e8b7e8-d9b8-b2a2-c014-05942d99452a@redhat.com>
 <20210105102517.GA31084@stefanha-x1.localdomain>
 <f9cd33f6-c30d-4e5a-bc45-8f42109fe1ce@redhat.com>
 <20210106150525.GB130669@stefanha-x1.localdomain>
 <32b49857-4ac7-0646-929d-c9238b50bc49@redhat.com>
 <20210107175311.GA168426@stefanha-x1.localdomain>
 <e22eaf2b-15f6-5b41-75a8-0e9b24e84e16@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
In-Reply-To: <e22eaf2b-15f6-5b41-75a8-0e9b24e84e16@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 13, 2021 at 10:38:29AM +0800, Jason Wang wrote:
>=20
> On 2021/1/8 =E4=B8=8A=E5=8D=881:53, Stefan Hajnoczi wrote:
> > On Thu, Jan 07, 2021 at 11:30:47AM +0800, Jason Wang wrote:
> > > On 2021/1/6 =E4=B8=8B=E5=8D=8811:05, Stefan Hajnoczi wrote:
> > > > On Wed, Jan 06, 2021 at 01:21:43PM +0800, Jason Wang wrote:
> > > > > On 2021/1/5 =E4=B8=8B=E5=8D=886:25, Stefan Hajnoczi wrote:
> > > > > > On Tue, Jan 05, 2021 at 11:53:01AM +0800, Jason Wang wrote:
> > > > > > > On 2021/1/5 =E4=B8=8A=E5=8D=888:02, Elena Afanasova wrote:
> > > > > > > > On Mon, 2021-01-04 at 13:34 +0800, Jason Wang wrote:
> > > > > > > > > On 2021/1/4 =E4=B8=8A=E5=8D=884:32, Elena Afanasova wrote:
> > > > > > > > > > On Thu, 2020-12-31 at 11:45 +0800, Jason Wang wrote:
> > > > > > > > > > > On 2020/12/29 =E4=B8=8B=E5=8D=886:02, Elena Afanasova=
 wrote:
> > 2. If separate userspace threads process the virtqueues, then set up the
> >     virtio-pci capabilities so the virtqueues have separate notification
> >     registers:
> >     https://docs.oasis-open.org/virtio/virtio/v1.1/cs01/virtio-v1.1-cs0=
1.html#x1-1150004
>=20
>=20
> Right. But this works only when PCI transport is used and queue index cou=
ld
> be deduced from the register address (separated doorbell).
>=20
> If we use MMIO or sharing the doorbell registers among all the virtqueues
> (multiplexer is zero in the above case) , it can't work without datamatch.

True. Can you think of an application that needs to dispatch a shared
doorbell register to several threads?

If this is a case that real-world applications need then we should
tackle it. This is where eBPF would be appropriate. I guess the
interface would be something like:

  /*
   * A custom demultiplexer function that returns the index of the <wfd,
   * rfd> pair to use or -1 to produce a KVM_EXIT_IOREGION_FAILURE that
   * userspace must handle.
   */
  int demux(const struct ioregionfd_cmd *cmd);

Userspace can install an eBPF demux function as well as an array of
<wfd, rfd> fd pairs. The demux function gets to look at the cmd in order
to decide which fd pair it is sent to.

This is how I think eBPF datamatch could work. It's not as general as in
our original discussion where we also talked about custom protocols
(instead of struct ioregionfd_cmd/struct ioregionfd_resp).

Stefan

--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl//FyUACgkQnKSrs4Gr
c8hEegf/a9ssrX4AD8VXXSxxbHuPAP4GxtbwHgBkxtuYWoJkj4GMk6yqVggi5jlD
SdShIcLTA0oJeM3mOHr2O69hlq+IVh9HOQL8voNJjGCdrw+TSxWMlovWbzoV7o7B
7x4Jup2LIxHIkRAJHjsNhogFDuBlmCGjTOOkM3UNTQ5RsJG86KNaudaSdjbU3gI5
2kJsZU0WJIpKZSonKJSJ9qrhTsXkeHbroPj0SwNaz5HRU2lokuJmTyxY2MNSfsmZ
d99HFWRcf50bDbo4NtYXnb7vhnsmFHPWYu+KfSCed7OLaLFguFAKrgq1lnpz+98L
pWGTaF/gtndZ/+5DEm7Xz4n9kHtm5g==
=P+I7
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--

