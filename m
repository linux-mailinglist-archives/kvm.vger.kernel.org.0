Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A310A66F0
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 12:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728490AbfICK6W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 06:58:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57656 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbfICK6W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 06:58:22 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 96C23307CDFC;
        Tue,  3 Sep 2019 10:58:21 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-117-51.ams2.redhat.com [10.36.117.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 172835D9E1;
        Tue,  3 Sep 2019 10:58:17 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 4/5] s390x: STSI tests
To:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org
References: <20190826163502.1298-1-frankja@linux.ibm.com>
 <20190826163502.1298-5-frankja@linux.ibm.com>
 <72cc113e-63a2-d389-d1fb-b0b9e84fc863@redhat.com>
 <1416cb79-09b6-8067-041f-16522860cd88@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=thuth@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat
Message-ID: <57f0dc1f-b610-5008-9869-14ce12caed04@redhat.com>
Date:   Tue, 3 Sep 2019 12:58:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1416cb79-09b6-8067-041f-16522860cd88@linux.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="U4Hg9xWCMZZRL4o3yFh0uKFWTYxwD81Us"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Tue, 03 Sep 2019 10:58:21 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--U4Hg9xWCMZZRL4o3yFh0uKFWTYxwD81Us
Content-Type: multipart/mixed; boundary="SU2hSD3LdPHMkrMTwIcKnvjL2Gh8uEgGi";
 protected-headers="v1"
From: Thomas Huth <thuth@redhat.com>
To: Janosch Frank <frankja@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org
Message-ID: <57f0dc1f-b610-5008-9869-14ce12caed04@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 4/5] s390x: STSI tests
References: <20190826163502.1298-1-frankja@linux.ibm.com>
 <20190826163502.1298-5-frankja@linux.ibm.com>
 <72cc113e-63a2-d389-d1fb-b0b9e84fc863@redhat.com>
 <1416cb79-09b6-8067-041f-16522860cd88@linux.ibm.com>
In-Reply-To: <1416cb79-09b6-8067-041f-16522860cd88@linux.ibm.com>

--SU2hSD3LdPHMkrMTwIcKnvjL2Gh8uEgGi
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 03/09/2019 12.53, Janosch Frank wrote:
> On 8/30/19 2:07 PM, David Hildenbrand wrote:
>> On 26.08.19 18:35, Janosch Frank wrote:
>>> For now let's concentrate on the error conditions.
>>>
>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>> ---
> [...]
>>> +static inline unsigned long stsi_get_fc(void *addr)
>>> +{
>>> +	register unsigned long r0 asm("0") =3D 0;
>>> +	register unsigned long r1 asm("1") =3D 0;
>>> +	int cc;
>>> +
>>> +	asm volatile("stsi	0(%3)\n"
>>> +		     "ipm	%[cc]\n"
>>> +		     "srl	%[cc],28\n"
>>> +		     : "+d" (r0), [cc] "=3Dd" (cc)
>>> +		     : "d" (r1), "a" (addr)
>>
>> maybe [addr], so you can avoid the %3 above
>=20
> Sure, maybe Thomas can also fix that on picking for the previous patch?=


Yes, I can do that.

>>
>>> +		     : "cc", "memory");
>>> +	assert(!cc);
>>> +	return r0 >> 28;
>>
>> I think I'd prefer "get_configuration_level()" and move it to an heade=
r
>> - because the fc actually allows more values (0, 15 ...) - however the=

>> level can be used as an fc.
>=20
> The rename works for me, but that's currently used only once, so why
> should it go to a header file?
>=20
> I though about starting lib/s390x/asm/misc-instr.h if we have enough (>=
=3D
> 2) instruction definitions which are shared.

Let's keep it here until we need it in another file, too - then we can
still move it to a header instead.

 Thomas


--SU2hSD3LdPHMkrMTwIcKnvjL2Gh8uEgGi--

--U4Hg9xWCMZZRL4o3yFh0uKFWTYxwD81Us
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEJ7iIR+7gJQEY8+q5LtnXdP5wLbUFAl1uR0QACgkQLtnXdP5w
LbU2QBAAl9mQq1Bid6irF8bZ0X6iMTsI6QtS/1/QFBE7qrxUiNlqoZG/nfKBdQjN
4fA24EqqGRJDZYfBk04ZOyTgaJtSp01/bCfkU/C/ODXTACL0pCfOF/5nuXGj2Gmr
JtFGDVqcHj30POEpAH3qGQDw9WNUFvPZYXUjCfNJVRLYmIduTCuXazeZr+YUNKHi
Xza3mKGi+FZvZnKfJaR61F+HNt5fLGWM4objmGZlj6akWBRMqDXdHkvtxvkLe6Xw
SO3VV4uqhoZS4xCagcpTBMh8uBxzyJDB/lD64rdUO0xfrOTYuDq2JGDHEPpAT1e6
Vxor5zSzRYzRkS9Jz4XuOucxM2vfmdoCO2zgPcqGG3tJUa4XJhcL1koCObAvVm15
4lnFVHFgQHlCaSOuCvMAW3rL/MvPfiGZ3nD5KypuFGQuLXvVDryfzGC2JOXiTWRc
pPl/zDy2AcUtEEocIuKmrCm55eVVL9ZpU7hnLcxfrLWf/kSjspAftFQeT4reC63j
5Yrub7CH5qGt6tEMFdXDzc76FTdIcVOnwwT9033CpmkHsvPA7wyI8xgiFHUBSvaD
DQCz1jlGbdVMUeeVOeYFRtKk+5JX/bZF46mWlYZjD14SXhNCEwXORPF/Loy3UK4y
/Galp9PA2sTTtzPyTlT49zFyibCwvkKneODvhPjV68W6g7kvaIU=
=dzoS
-----END PGP SIGNATURE-----

--U4Hg9xWCMZZRL4o3yFh0uKFWTYxwD81Us--
