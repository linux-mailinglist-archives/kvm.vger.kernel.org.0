Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 493FAA0435
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 16:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbfH1OF6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 10:05:58 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59062 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726197AbfH1OF6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Aug 2019 10:05:58 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7SE2XSU153627
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2019 10:05:56 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2untju9jgq-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2019 10:05:55 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Wed, 28 Aug 2019 15:05:54 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 28 Aug 2019 15:05:51 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7SE5oZs56295488
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Aug 2019 14:05:50 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8136D42042;
        Wed, 28 Aug 2019 14:05:50 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C89B42047;
        Wed, 28 Aug 2019 14:05:50 +0000 (GMT)
Received: from dyn-9-152-224-131.boeblingen.de.ibm.com (unknown [9.152.224.131])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Aug 2019 14:05:50 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 4/4] s390x: Add storage key removal
 facility
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com
References: <20190828113615.4769-1-frankja@linux.ibm.com>
 <20190828113615.4769-5-frankja@linux.ibm.com>
 <3ea4cb74-4fe4-d2bd-7fe4-550df9c355e6@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Wed, 28 Aug 2019 16:05:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <3ea4cb74-4fe4-d2bd-7fe4-550df9c355e6@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="0OeHyVKPrG7I45JLwqYqU9mJj98aEfbsk"
X-TM-AS-GCONF: 00
x-cbid: 19082814-0012-0000-0000-00000343E95F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082814-0013-0000-0000-0000217E2689
Message-Id: <6af2ff95-013b-c366-24f8-f178f7bcd40a@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-28_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908280146
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0OeHyVKPrG7I45JLwqYqU9mJj98aEfbsk
Content-Type: multipart/mixed; boundary="8kLzLtWtd2bGNrw40NJHlL4rYpDV5xxnX";
 protected-headers="v1"
From: Janosch Frank <frankja@linux.ibm.com>
To: Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, david@redhat.com
Message-ID: <6af2ff95-013b-c366-24f8-f178f7bcd40a@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 4/4] s390x: Add storage key removal
 facility
References: <20190828113615.4769-1-frankja@linux.ibm.com>
 <20190828113615.4769-5-frankja@linux.ibm.com>
 <3ea4cb74-4fe4-d2bd-7fe4-550df9c355e6@redhat.com>
In-Reply-To: <3ea4cb74-4fe4-d2bd-7fe4-550df9c355e6@redhat.com>

--8kLzLtWtd2bGNrw40NJHlL4rYpDV5xxnX
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/28/19 2:02 PM, Thomas Huth wrote:
> On 28/08/2019 13.36, Janosch Frank wrote:
>> The storage key removal facility (stfle bit 169) makes all key related=

>> instructions result in a special operation exception if they handle a
>> key.
>>
>> Let's make sure that the skey and pfmf tests only run non key code
>> (pfmf) or not at all (skey).
>>
>> Also let's test this new facility. As lots of instructions are
>> affected by this, only some of them are tested for now.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  s390x/Makefile |   1 +
>>  s390x/pfmf.c   |  10 ++++
>>  s390x/skey.c   |   5 ++
>>  s390x/skrf.c   | 128 ++++++++++++++++++++++++++++++++++++++++++++++++=
+
>>  4 files changed, 144 insertions(+)
>>  create mode 100644 s390x/skrf.c
> [...]
>> +static void test_mvcos(void)
>> +{
>> +	uint64_t r3 =3D 64;
>> +	uint8_t *src =3D pagebuf;
>> +	uint8_t *dst =3D pagebuf + PAGE_SIZE;
>> +	/* K bit set, as well as keys */
>> +	register unsigned long oac asm("0") =3D 0xf002f002;
>> +
>> +	report_prefix_push("mvcos");
>> +	expect_pgm_int();
>> +	asm volatile("mvcos	%[dst],%[src],%[len]"
>> +		     : [dst] "+Q" (*(dst))
>> +		     : [src] "Q" (*(src)), [len] "d" (r3), "d" (oac)
>=20
> Just a nit: I think you could write "*dst" instead of "*(dst)" and
> "*src" instead of "*(src)".
>=20
>> +		     : "cc", "memory");
>> +	check_pgm_int_code(PGM_INT_CODE_SPECIAL_OPERATION);
>> +	report_prefix_pop();
>> +}
>> +
>> +static void test_spka(void)
>> +{
>> +	report_prefix_push("spka");
>> +	expect_pgm_int();
>> +	asm volatile("spka	0xf0(0)\n");
>> +	check_pgm_int_code(PGM_INT_CODE_SPECIAL_OPERATION);
>> +	report_prefix_pop();
>> +}
>> +
>> +static void test_tprot(void)
>> +{
>> +	report_prefix_push("tprot");
>> +	expect_pgm_int();
>> +	asm volatile("tprot	%[addr],0xf0(0)\n"
>> +		     : : [addr] "a" (pagebuf) : );
>> +	check_pgm_int_code(PGM_INT_CODE_SPECIAL_OPERATION);
>> +	report_prefix_pop();
>> +}
>> +
>> +int main(void)
>> +{
>> +	report_prefix_push("skrf");
>> +	if (!test_facility(169)) {
>> +		report_skip("storage key removal facility not available\n");
>> +		goto done;
>> +	}
>> +
>> +	test_facilities();
>> +	test_skey();
>> +	test_pfmf();
>> +	test_psw_key();
>> +	test_mvcos();
>> +	test_spka();
>> +	test_tprot();
>> +
>> +done:
>> +	report_prefix_pop();
>> +	return report_summary();
>> +}
>=20
> I can't say much about the technical details here (since I don't have
> the doc for that "removal facility"), but apart from that, the patch
> looks fine to me now.
>=20
> Acked-by: Thomas Huth <thuth@redhat.com>
>=20
> (and I'll wait one or two more days for additional reviews before
> queuing the patches)
>=20
Great, thank you!


--8kLzLtWtd2bGNrw40NJHlL4rYpDV5xxnX--

--0OeHyVKPrG7I45JLwqYqU9mJj98aEfbsk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl1mij4ACgkQ41TmuOI4
ufiF+A/8CTRfNQHGz4yxL7kg2grYAK4c/grtUomEOtc1grxk6jOroOsHw/fM/T6X
DlZ9xL3+mowx0pb3rQOmVRXdRQ39hnw5FwpqG/nQGIokSrJVLPVI36KP0tYOCPsQ
wU4btPArWrQ/chqIxzgNerZEII+uC2JcobMG/tU41JDlDxpGQXiYkLjum78uaJfc
jQ/fFJE2Hl5ojeGUK056S/X6o1kBAwTrOxY4xPyEk5QYyJ4W7VbCimUmLrQtrLFM
0a6i9Zk5QvYWqc3cgltBEqcMGo7cWZxdiunhRzqnY5hnYHoHfLHkiPUlMHDOt7EG
5zduX87Ky/QRew4ewcSfVqCKog/8tu4UnCjQ3Va0yBq3xLbRofMK/UIpbHYkuRh+
SJM3OATx3dVYtbbyIrnMxsGtQ9fdvaP0croaoVnxFX/7SB3bfK+/ucFbrTq9I0Nz
iDEqZlIbMtACgZ6TJi1WLQJXo0UIDOqKAw2PEOplxV+1ewlk4aQSQ6fOw9+9+t6+
uDtLMn5INHZHt3/Y8Enn/0Me+GcN3M5vLWlX4n3dtKlCW6fUvGo/a8Xk+pS76c1L
tSTLcboRKiIkGYm+K6X+lBriLzByNkIuPeTO9n7hqcpPphDmaA3pFQ58deC39Rgt
C3NrYY4VitEEOkykCfc0WdoLLMQ6mbgTnIbauefM4mzf1LgDMDI=
=asiH
-----END PGP SIGNATURE-----

--0OeHyVKPrG7I45JLwqYqU9mJj98aEfbsk--

