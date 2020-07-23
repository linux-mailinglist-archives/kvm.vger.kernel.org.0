Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA7BE22AEB6
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 14:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgGWMLJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 08:11:09 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:32823 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726714AbgGWMLJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Jul 2020 08:11:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595506267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sMz7BBE1lm3ibUnflSfo3rjVKWSzvxBiUHpzRGJsFvI=;
        b=bMhE8E8yo8ejarPuF+SeLUtkO4g2ATCR2D0FlBptuUJa/DdRUgABbVoqufPTZ9eI0NwZ7Y
        STHAzBxFyudxtCWRqGyuTxI5wky2JZ2XmrlQAepnFQzsZkV299XT3mUCb205Yw34lxkQiG
        RXEhYqjOakMx/brAG5oXKC0M17CTcAI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-yaOW_WrkMFyAQfSBQzFahw-1; Thu, 23 Jul 2020 08:11:05 -0400
X-MC-Unique: yaOW_WrkMFyAQfSBQzFahw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 11CFFE918;
        Thu, 23 Jul 2020 12:11:04 +0000 (UTC)
Received: from gondolin (ovpn-112-228.ams2.redhat.com [10.36.112.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B13F660CC0;
        Thu, 23 Jul 2020 12:10:59 +0000 (UTC)
Date:   Thu, 23 Jul 2020 14:10:43 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 2/3] s390x: skrf: Add exception new skey
 test and add test to unittests.cfg
Message-ID: <20200723141043.7efadd30.cohuck@redhat.com>
In-Reply-To: <acc2a56c-6157-32e1-f305-48bf5a2a285d@linux.ibm.com>
References: <20200717145813.62573-1-frankja@linux.ibm.com>
        <20200717145813.62573-3-frankja@linux.ibm.com>
        <78da93f7-118d-2c1d-582a-092232f36108@redhat.com>
        <032c1103-3020-9deb-a307-70ded3bdb55e@linux.ibm.com>
        <1aa0a21c-90c9-0214-1869-87cc60a46548@redhat.com>
        <acc2a56c-6157-32e1-f305-48bf5a2a285d@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; boundary="Sig_/0TVu14uH5pq=jSEwlA3r1+N";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/0TVu14uH5pq=jSEwlA3r1+N
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 21 Jul 2020 17:03:10 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 7/21/20 4:28 PM, Thomas Huth wrote:
> > On 21/07/2020 10.52, Janosch Frank wrote: =20
> >> On 7/21/20 9:28 AM, Thomas Huth wrote: =20
> >>> On 17/07/2020 16.58, Janosch Frank wrote: =20
> >>>> If a exception new psw mask contains a key a specification exception
> >>>> instead of a special operation exception is presented. =20
> >>>
> >>> I have troubles parsing that sentence... could you write that differe=
ntly?
> >>> (and: "s/a exception/an exception/") =20
> >>
> >> How about:
> >>
> >> When an exception psw new with a storage key in its mask is loaded fro=
m
> >> lowcore a specification exception is raised instead of the special
> >> operation exception that is normally presented when skrf is active. =
=20
> >=20
> > Still a huge beast of a sentence. Could you maybe make two sentences ou=
t
> > of it? For example:
> >=20
> > " ... is raised. This differs from the normal case where ..." =20
>=20
> When an exception psw new with a storage key in its mask is loaded from
> lowcore a specification exception is raised. This behavior differs from
> the one that is presented when trying to execute skey related
> instructions which will raise special operation exceptions.

s/psw new/new psw/ ?

(And probably a comma after 'lowcore'.)

"This differs from the behaviour when trying to execute skey related
instructions, which will result in special operation exceptions."

?

--Sig_/0TVu14uH5pq=jSEwlA3r1+N
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEw9DWbcNiT/aowBjO3s9rk8bwL68FAl8ZfkMACgkQ3s9rk8bw
L68gLQ/8CT6FLav/Lge15kEtPJ+fSaEhOPf5XBBkqcCb+YajlNrdJLbfgLZpwLGE
wNdWHzlBhpw6M/Fd8Isg1zKkD4VTkhvKHO9QoxMtlk9wX5qSajrHecmnqh0iF5w4
cF7pzyY3nGZsQsGqEa/HtTiheWyeHw+K+hPamijNYdqQ3lcPd78L7T9/IOmP59m9
3xoja88Bu+gkqS9at90z8Be6D58o+wNIznDtxQANtzog0m7NPTNEoXdn9NHDWBuh
2hQUyewqDOR3XY/k1ejLgHLK2bhkANzgxwMkIT0RX/6KhNo1yh7npoLDwQfoYGzT
piG3Brh2tU1QWBqzmRESldDGk5DbQbJn6dnIvqkdHHXpbzWjrR+Zbx5h5IyBZ/op
9RrKWfuQy8arwfrh+PPfLp/6OC1K/H9kO5GTq6wDC4OOYUmQARVB49su7Jpxic6s
U/xCOAHSHMNhvfwsa9TKq0bo8aCWBOwGQYHqI2S2i3r1kLM/Wahhc7rmHOxJAm0Z
yy96vvDTXNVaMDipJeXlPdEABBVVeUIsOBZK2uTw5w6u97dV3YnKZOmTiCxbri1+
ZY2FzFXn3LI1MvHyYAJ05vlFuH9tuiyu0D+lknQDAj3x9gws/YH9Ey1WAA/2nHox
pH2N44KiOE32/WHEtdFsEuOAyYqnWYl65jFTtqBFu1yTqlGAxbs=
=GHmA
-----END PGP SIGNATURE-----

--Sig_/0TVu14uH5pq=jSEwlA3r1+N--

