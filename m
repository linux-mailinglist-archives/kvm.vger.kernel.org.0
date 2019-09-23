Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEF2EBB1CC
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 12:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407491AbfIWKAN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 06:00:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40136 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407478AbfIWKAM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 06:00:12 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 324D6301D67F;
        Mon, 23 Sep 2019 10:00:12 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-120.ams2.redhat.com [10.36.116.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 53D215C1B2;
        Mon, 23 Sep 2019 10:00:03 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] s390x: Fix stsi unaligned test and add
 selector tests
To:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org
References: <20190920075020.1698-1-frankja@linux.ibm.com>
 <9dd9362d-f8e2-a573-3833-376039dbc570@redhat.com>
 <97e39625-6675-6d01-b1da-dd6d0758c943@redhat.com>
 <b78fcfa7-7c80-b1c2-aecb-e72b6df91dbc@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=thuth@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat
Message-ID: <db5878e4-96a6-0937-852d-b7b98f40e77c@redhat.com>
Date:   Mon, 23 Sep 2019 11:59:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <b78fcfa7-7c80-b1c2-aecb-e72b6df91dbc@linux.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ldgZ45SAN2yODzH2ORLoxHZtVps224aLj"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Mon, 23 Sep 2019 10:00:12 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ldgZ45SAN2yODzH2ORLoxHZtVps224aLj
Content-Type: multipart/mixed; boundary="clfnqYnxDuNN2lgCgKy4li4dBro6hvCwQ";
 protected-headers="v1"
From: Thomas Huth <thuth@redhat.com>
To: Janosch Frank <frankja@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org
Message-ID: <db5878e4-96a6-0937-852d-b7b98f40e77c@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] s390x: Fix stsi unaligned test and add
 selector tests
References: <20190920075020.1698-1-frankja@linux.ibm.com>
 <9dd9362d-f8e2-a573-3833-376039dbc570@redhat.com>
 <97e39625-6675-6d01-b1da-dd6d0758c943@redhat.com>
 <b78fcfa7-7c80-b1c2-aecb-e72b6df91dbc@linux.ibm.com>
In-Reply-To: <b78fcfa7-7c80-b1c2-aecb-e72b6df91dbc@linux.ibm.com>

--clfnqYnxDuNN2lgCgKy4li4dBro6hvCwQ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 23/09/2019 11.48, Janosch Frank wrote:
> On 9/23/19 10:10 AM, Thomas Huth wrote:
>> On 20/09/2019 10.10, David Hildenbrand wrote:
>>> On 20.09.19 09:50, Janosch Frank wrote:
>>>> Alignment and selectors test order is not specified and so, if you
>>>> have an unaligned address and invalid selectors it's up to the
>>>> hypervisor to decide which error is presented.
>>>>
>>>> Let's add valid selectors to the unaligned test and add selector
>>>> tests.
>>>>
>>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>>> ---
>>>>  s390x/stsi.c | 4 +++-
>>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/s390x/stsi.c b/s390x/stsi.c
>>>> index 7232cb0..c5bd0a2 100644
>>>> --- a/s390x/stsi.c
>>>> +++ b/s390x/stsi.c
>>>> @@ -35,7 +35,7 @@ static void test_specs(void)
>>>> =20
>>>>  	report_prefix_push("unaligned");
>>>>  	expect_pgm_int();
>>>> -	stsi(pagebuf + 42, 1, 0, 0);
>>>> +	stsi(pagebuf + 42, 1, 1, 1);
>>>>  	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
>>>>  	report_prefix_pop();
>>>> =20
>>>> @@ -71,6 +71,8 @@ static inline unsigned long stsi_get_fc(void *addr=
)
>>>>  static void test_fc(void)
>>>>  {
>>>>  	report("invalid fc",  stsi(pagebuf, 7, 0, 0) =3D=3D 3);
>>
>> While you're at it, wouldn't it be better to use "(pagebuf, 7, 1, 1)" =
here?
>=20
> The selectors depend on the command, so they need to be checked after
> the command. I don't think it would make much sense to change the zeroe=
s
> here.

OK, fair. Patche queued.

 Thomas


--clfnqYnxDuNN2lgCgKy4li4dBro6hvCwQ--

--ldgZ45SAN2yODzH2ORLoxHZtVps224aLj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEJ7iIR+7gJQEY8+q5LtnXdP5wLbUFAl2Il6IACgkQLtnXdP5w
LbUSmBAAoWevoCJxjRUxD4eXfO0J5ZslKukVj3NSYhh0yBdRmwjRNQnF3AeGVDTv
hAnzpFB69kFfiR1IlMpf2szliyeOFqbfq10miEzlN5oom0pRt6Jk6T+aV1iHRTaV
olEiBTay37O+mTlmjPokc22DHHyMc9bRIwS7PAA2hCHcWDbZvBqYkuEMxdcL0QyC
7r5T7Q7eg1+qWt1+a7k1OrlzGqrqXM+p0ltZFFUbA5Z3KrA2uCwtDxhsSFIP8o56
YEhsoCD8FOC5jsUqhzYivo7hM4ol5pOl/yMFeeaCgVmK/VK9VfdUVRNj8imk2kfR
m8mPkzcN8hzNF/uBOagNFW9gc66rdZBr6eWVCkKFSyoZaUsN+AjfwYhkGqyuLFLw
Hx6mCHLryDr+oajOtmPO/Tm723zubBqSj9IXxYb+IJy4TPsqBPdnYA0URvVHLBxH
Eozkx89t0BsfLQ6/WOlbVVheUkwBXDwSRSKYQ7cyKhUpEBKYck04jVL7cRDDxtnd
UP2+nxvr1ILWcRhNYT9bs1TAt71cf2jiyp/jyp2kednCnKNNuwRGTOITd9NtLc+j
ne15RPO2cX2lCGVt+01IDSwqZks6mu3TOwOpoF7R58YRokPAqKZ0BI5VYaMvFf9j
fv01MoibPD7W+F3vIFkP2ATd2mAmtOLvbZvC1yPiHPqDi45+/Pc=
=/T/G
-----END PGP SIGNATURE-----

--ldgZ45SAN2yODzH2ORLoxHZtVps224aLj--
