Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5D38216FBD
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 17:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbgGGPJv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 11:09:51 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37374 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727791AbgGGPJu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Jul 2020 11:09:50 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 067F3F6U051627
        for <kvm@vger.kernel.org>; Tue, 7 Jul 2020 11:09:49 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 324pxsh7aw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 07 Jul 2020 11:09:49 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 067F3xDo055785
        for <kvm@vger.kernel.org>; Tue, 7 Jul 2020 11:09:49 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 324pxsh79x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jul 2020 11:09:49 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 067F4Hap007905;
        Tue, 7 Jul 2020 15:09:47 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 322hd7uj44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jul 2020 15:09:46 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 067F8NhF56099152
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Jul 2020 15:08:23 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BBB48A405F;
        Tue,  7 Jul 2020 15:09:44 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7397CA4066;
        Tue,  7 Jul 2020 15:09:44 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.183.94])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  7 Jul 2020 15:09:44 +0000 (GMT)
Subject: Re: [kvm-unit-tests v2 PATCH] s390x/cpumodel: The missing DFP
 facility on TCG is expected
To:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20200707104205.25085-1-thuth@redhat.com>
 <20200707134415.39e47538.cohuck@redhat.com>
 <ca2ad96f-1d74-723f-e6c0-7345a90b35f8@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <09d34daa-a770-defd-260c-81d3c5c49a3d@linux.ibm.com>
Date:   Tue, 7 Jul 2020 17:09:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <ca2ad96f-1d74-723f-e6c0-7345a90b35f8@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JWQEVcZ7cpcywhhufcY7bmPxfTwBMwYKw"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-07_08:2020-07-07,2020-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 cotscore=-2147483648 suspectscore=2 adultscore=0
 mlxlogscore=999 spamscore=0 priorityscore=1501 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007070109
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JWQEVcZ7cpcywhhufcY7bmPxfTwBMwYKw
Content-Type: multipart/mixed; boundary="bOoHGeCIDgZ3WtDuDEF2PR0SzsBW9ldiB"

--bOoHGeCIDgZ3WtDuDEF2PR0SzsBW9ldiB
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/7/20 1:45 PM, David Hildenbrand wrote:
> On 07.07.20 13:44, Cornelia Huck wrote:
>> On Tue,  7 Jul 2020 12:42:05 +0200
>> Thomas Huth <thuth@redhat.com> wrote:
>>
>>> When running the kvm-unit-tests with TCG on s390x, the cpumodel test
>>> always reports the error about the missing DFP (decimal floating poin=
t)
>>> facility. This is kind of expected, since DFP is not required for
>>> running Linux and thus nobody is really interested in implementing
>>> this facility in TCG. Thus let's mark this as an expected error inste=
ad,
>>> so that we can run the kvm-unit-tests also with TCG without getting
>>> test failures that we do not care about.
>>>
>>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>>> ---
>>>  v2:
>>>  - Rewrote the logic, introduced expected_tcg_fail flag
>>>  - Use manufacturer string instead of VM name to detect TCG
>>>
>>>  s390x/cpumodel.c | 49 ++++++++++++++++++++++++++++++++++++++++++----=
--
>>>  1 file changed, 43 insertions(+), 6 deletions(-)
>>
>> (...)
>>
>>> +static bool is_tcg(void)
>>> +{
>>> +	const char qemu_ebcdic[] =3D { 0xd8, 0xc5, 0xd4, 0xe4 };
>>> +	bool ret =3D false;
>>> +	uint8_t *buf;
>>> +
>>> +	buf =3D alloc_page();
>>> +	if (!buf)
>>> +		return false;
>>> +
>>> +	if (stsi(buf, 1, 1, 1)) {
>>> +		goto out;
>>> +	}
>>
>> This does an alloc_page() and a stsi() every time you call it...
>>
>>> +
>>> +	/*
>>> +	 * If the manufacturer string is "QEMU" in EBCDIC, then we are on T=
CG
>>> +	 * (otherwise the string is "IBM" in EBCDIC)
>>> +	 */
>>> +	if (!memcmp(&buf[32], qemu_ebcdic, sizeof(qemu_ebcdic)))
>>> +		ret =3D  true;
>>> +out:
>>> +	free_page(buf);
>>> +	return ret;
>>> +}
>>> +
>>> +
>>>  int main(void)
>>>  {
>>>  	int i;
>>> @@ -46,11 +81,13 @@ int main(void)
>>> =20
>>>  	report_prefix_push("dependency");
>>
>> ...so maybe cache the value for is_tcg() here instead of checking
>> multiple times in the loop?
>=20
> Maybe move it to common code and do the detection early during boot? Th=
e
> n provide is_tcg() or sth. like that. Could be helpful in other context=

> maybe.
>=20

Well we also already have a check for zvm 6 with stsi 3.2.2 in skey.c
I'm not completely convinced that I want to loose two pages and a few
cycles on every startup for two separate test cases.



--bOoHGeCIDgZ3WtDuDEF2PR0SzsBW9ldiB--

--JWQEVcZ7cpcywhhufcY7bmPxfTwBMwYKw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl8EkDgACgkQ41TmuOI4
ufjxBg/+KgqLoYTlArU+xfuClFwjyCKofUtqfGx0V9ucZP9Et8BEtW2eemm7vG2O
jK808aWu8ul5YFjfkQclPTMGi1VxRdRxYBzvNbHy6mburA179h8CPwaFgTNCFHqH
pz6XjLbTVcI8QxTSqshCYfQToxMiFHMLPnAW4w5FSD5siK0yCSti6qoOjEgbBydZ
+ZiBVouiCrkqmSs301/sYuRANn+T2sciEr9t6kVFR1qeV2rjxB6ObvqdJlXGqxMG
e7tDdRpD4hZj1m1s/Olx1FnICm3RByWltVmFTvHsGDIyOzdavx9lpjrQMNno5AaY
na79abEbd4gWWIJKNno00wuq1pjqIqQtyIvBvruWSYJfoFzL5iVqhK0w8RYnls3K
2wdmsgKT+KO+bUA210Y4dKNkKMXQvg+fQOlRqyN/q1/+bk0d0uvOm8Aq2hvyOF8X
P3lBxyQAY9nvb8ZMmF8rxwQUrrCb17wq4q1+yLmZWY8RITZeXXoPEb24uUSMEmxt
Ao1gMdRwLrI77RVgHKXs17WSDPrnw6UWh+dPzQ0fZDwvKPulpDtVSDy92Xb5p5yN
FIrMBF/wnyJtYY9safVrQcjxk6nx94lwwalGlBkD6mSogUTidH0n9sUUAoeoRlnF
NK5KJtC86SD7egWYt2XajtQefM3g1QqfzAdDHSSzgSl9yGj+e/M=
=TgeK
-----END PGP SIGNATURE-----

--JWQEVcZ7cpcywhhufcY7bmPxfTwBMwYKw--

