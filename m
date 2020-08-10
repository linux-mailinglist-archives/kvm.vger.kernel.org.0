Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4184C240977
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 17:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728795AbgHJPc1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 11:32:27 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:20339 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728589AbgHJPc0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Aug 2020 11:32:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597073545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PxbtnYCs0MOgNACR/giZ70CKOPW+ZZtW/ibOFAJhquU=;
        b=IEuLV7e4vZTQnbuZclnBImF8wIBW/BQKanKv5ZQeLqFXEmdta6siGrlNKFEsPOH09XXis8
        IIdVUx3B+bIjFh6jMbhSL8+rUDVK6jq3t/6j6gC2D0xA7Dtd9+j/s10lD4Dz2OGQI0EgF4
        tti+u47F46zFxGz+xrGsmRRXxCaDtYI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-YA4EqkyDN42luryL0-Ciug-1; Mon, 10 Aug 2020 11:32:21 -0400
X-MC-Unique: YA4EqkyDN42luryL0-Ciug-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BEF5E1326E1;
        Mon, 10 Aug 2020 15:32:19 +0000 (UTC)
Received: from gondolin (ovpn-112-218.ams2.redhat.com [10.36.112.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5172419C4F;
        Mon, 10 Aug 2020 15:32:15 +0000 (UTC)
Date:   Mon, 10 Aug 2020 17:32:05 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, linux-s390@vger.kernel.org,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 3/3] s390x: Ultravisor guest API test
Message-ID: <20200810173205.2daaaca1.cohuck@redhat.com>
In-Reply-To: <2b5634bf-c39b-13db-924a-5efcbaddb238@linux.ibm.com>
References: <20200807111555.11169-1-frankja@linux.ibm.com>
        <20200807111555.11169-4-frankja@linux.ibm.com>
        <20200810165004.02c4b5bf.cohuck@redhat.com>
        <2b5634bf-c39b-13db-924a-5efcbaddb238@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=cohuck@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; boundary="Sig_/BC7o8XmTtcg=gn4V63ImQbZ";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/BC7o8XmTtcg=gn4V63ImQbZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 10 Aug 2020 17:27:36 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 8/10/20 4:50 PM, Cornelia Huck wrote:
> > On Fri,  7 Aug 2020 07:15:55 -0400
> > Janosch Frank <frankja@linux.ibm.com> wrote:

> >> +static inline int share(unsigned long addr, u16 cmd)
> >> +{
> >> +=09struct uv_cb_share uvcb =3D {
> >> +=09=09.header.cmd =3D cmd,
> >> +=09=09.header.len =3D sizeof(uvcb),
> >> +=09=09.paddr =3D addr
> >> +=09};
> >> +
> >> +=09uv_call(0, (u64)&uvcb);
> >> +=09return uvcb.header.rc; =20
> >=20
> > Any reason why you're not checking rc and cc here... =20
>=20
> Well, this is a helper function not a test function.
> Since I can only return one value and since I'm lazy, I chose to ignore
> the CC and went for the uvcb rc. That's basically also the answer for
> your following questions.

Maybe I'm just confused regarding the command execution here.

>=20
>=20
> Alright, I'll remove the helpers and execute those tests the hard way.

As a plus point, you see exactly what is being done.

--Sig_/BC7o8XmTtcg=gn4V63ImQbZ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEw9DWbcNiT/aowBjO3s9rk8bwL68FAl8xaHUACgkQ3s9rk8bw
L69FERAAhu8U5akqpyGLZhJaIrjOXKQte1PYtnUL65iaytZFmcgRTQlMnhF7kI/1
5dQnLV04lvdTonCP8Aklxb4ozv+8ntGfBO9fpln/SQ6xehIJEhWfg0xDworVCVjt
3ncfBJiPKRWi4MM9iXgc92juz3CU33TrzX0PYrEsImiaHlUhApkdJi88msu+mMRn
DCyLqBufAik66LRqJDDWh5pCYK6QI2Of3RjKIVVKptpQ6WvZINm+G/YEr7sZel9Q
SZRqkPmjU8Y5RTuq3UWb0RcwhEtfYHB/u8yjbqMeVtEaT/7OTMfzCn8kBaNk1bj3
d0mpiUM2VhxCXS7jHL0oybsniFYJFXxEKM/RzEsIC1g5EQZbdsXlyQwYxP1Gx9k5
eBvbOVDNnT9Ab53hk2SJR/T50xN9caxnSAoXw6bISaeFMCmJtBPx6OlPLbZpqTl1
0KAsL7Xr0df2UQfRvMlIPgS1J4a4SA72UaBWa/HxdpVgxZrbLIh7+xxZh9F8128j
RBQg0GzNM3cs3nKGcoUVg9IJza3hTsYaxfl+l54AA0Uan6ARZ7EDUOGPL5JoXjly
5qYx5N6xuS07XbVul5Exd82LIq7V4bO+QmWt4OVWVvHrXtK6dV8910lDRZKgVE8K
QrzmQm6Iz5HtETgFdUhRukJ+qaP1xr8FbnsSag5+IvM2WBX/adY=
=SiD4
-----END PGP SIGNATURE-----

--Sig_/BC7o8XmTtcg=gn4V63ImQbZ--

