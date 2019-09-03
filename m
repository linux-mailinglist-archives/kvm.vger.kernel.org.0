Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7179AA66D0
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 12:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728538AbfICKyA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 06:54:00 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39090 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727667AbfICKyA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Sep 2019 06:54:00 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x83ArVar083996
        for <kvm@vger.kernel.org>; Tue, 3 Sep 2019 06:53:58 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2uspsmg2hw-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2019 06:53:58 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Tue, 3 Sep 2019 11:53:56 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 3 Sep 2019 11:53:53 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x83ArqQq60162074
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 Sep 2019 10:53:52 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E89E11C064;
        Tue,  3 Sep 2019 10:53:52 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2BE6511C050;
        Tue,  3 Sep 2019 10:53:52 +0000 (GMT)
Received: from dyn-9-152-224-131.boeblingen.de.ibm.com (unknown [9.152.224.131])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  3 Sep 2019 10:53:52 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v3 4/5] s390x: STSI tests
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com
References: <20190826163502.1298-1-frankja@linux.ibm.com>
 <20190826163502.1298-5-frankja@linux.ibm.com>
 <72cc113e-63a2-d389-d1fb-b0b9e84fc863@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Tue, 3 Sep 2019 12:53:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <72cc113e-63a2-d389-d1fb-b0b9e84fc863@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WJ0H9jSHmz8ogVGCPHJRNlirSKFh2J5jA"
X-TM-AS-GCONF: 00
x-cbid: 19090310-0012-0000-0000-000003460EF9
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19090310-0013-0000-0000-000021805CB3
Message-Id: <1416cb79-09b6-8067-041f-16522860cd88@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-03_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1909030114
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WJ0H9jSHmz8ogVGCPHJRNlirSKFh2J5jA
Content-Type: multipart/mixed; boundary="0itr30hXF7pbH80W8UjG2VBBAufEUKvoe";
 protected-headers="v1"
From: Janosch Frank <frankja@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, thuth@redhat.com
Message-ID: <1416cb79-09b6-8067-041f-16522860cd88@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 4/5] s390x: STSI tests
References: <20190826163502.1298-1-frankja@linux.ibm.com>
 <20190826163502.1298-5-frankja@linux.ibm.com>
 <72cc113e-63a2-d389-d1fb-b0b9e84fc863@redhat.com>
In-Reply-To: <72cc113e-63a2-d389-d1fb-b0b9e84fc863@redhat.com>

--0itr30hXF7pbH80W8UjG2VBBAufEUKvoe
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/30/19 2:07 PM, David Hildenbrand wrote:
> On 26.08.19 18:35, Janosch Frank wrote:
>> For now let's concentrate on the error conditions.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
[...]
>> +static inline unsigned long stsi_get_fc(void *addr)
>> +{
>> +	register unsigned long r0 asm("0") =3D 0;
>> +	register unsigned long r1 asm("1") =3D 0;
>> +	int cc;
>> +
>> +	asm volatile("stsi	0(%3)\n"
>> +		     "ipm	%[cc]\n"
>> +		     "srl	%[cc],28\n"
>> +		     : "+d" (r0), [cc] "=3Dd" (cc)
>> +		     : "d" (r1), "a" (addr)
>=20
> maybe [addr], so you can avoid the %3 above

Sure, maybe Thomas can also fix that on picking for the previous patch?

>=20
>> +		     : "cc", "memory");
>> +	assert(!cc);
>> +	return r0 >> 28;
>=20
> I think I'd prefer "get_configuration_level()" and move it to an header=

> - because the fc actually allows more values (0, 15 ...) - however the
> level can be used as an fc.

The rename works for me, but that's currently used only once, so why
should it go to a header file?

I though about starting lib/s390x/asm/misc-instr.h if we have enough (>=3D=

2) instruction definitions which are shared.

>=20
>=20
>> +}
>> +
>> +static void test_fc(void)
>> +{
>> +	report("invalid fc",  stsi(pagebuf, 7, 0, 0) =3D=3D 3);
>> +	report("query fc >=3D 2",  stsi_get_fc(pagebuf) >=3D 2);
>> +}
>> +
>> +int main(void)
>> +{
>> +	report_prefix_push("stsi");
>> +	test_priv();
>> +	test_specs();
>> +	test_fc();
>> +	return report_summary();
>> +}
>> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
>> index 9dd288a..cc79a4e 100644
>> --- a/s390x/unittests.cfg
>> +++ b/s390x/unittests.cfg
>> @@ -68,3 +68,6 @@ file =3D cpumodel.elf
>>  [diag288]
>>  file =3D diag288.elf
>>  extra_params=3D-device diag288,id=3Dwatchdog0 --watchdog-action injec=
t-nmi
>> +
>> +[stsi]
>> +file =3D stsi.elf
>>
>=20
> Apart from that
>=20
> Reviewed-by: David Hildenbrand <david@redhat.com>
>=20



--0itr30hXF7pbH80W8UjG2VBBAufEUKvoe--

--WJ0H9jSHmz8ogVGCPHJRNlirSKFh2J5jA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl1uRj8ACgkQ41TmuOI4
ufhj5RAAtLRt+3CDUSNIIoo0hlQQ357cOl/Wde/bVwqo+P3ZGIV6kDwMNvtk/tTk
cLnF9lVdefvL45f9q9ayyIf5HenVectQBR0GwsqPQaWB3Dn1C85pFnrWx28nOWm2
rW3LPgilvN+lM6NPfv/N35/aYnH7GOUSuEG8G8NQwqM6pHK+FtaRr2iWPG/8Ar8B
hbtaJTeT4oYCrversunfm/hhPFA5cKM6rCzmfxsN/j/Cw1j5wL6CmuTskESwISK9
ZnN91tTVTLYAjfawnvpGiDBllBYz2QOHbsk4aYFP40kN+rMUjpzN/dqkkWcyy+N8
JqaFVBZDLQdJbAbDAJaonY9qKuXdXSK0RqY0J6eJOLfZOPMB9naSRW8MkLVM/9sx
VWKdiPmzwbpzkAWFkGVoNmN9bhfnjKeu+2d6sGsqgcaG6pPYbC1Z9GBdmDkGlpsn
74L/ZUauZynDJ7Q72wMPOMPvTtfVlhz9al46h9ZsdsSmNYRADUXpOqrYkX6JYaFt
5sjXUpKtPJoA1J3y1BfndYbs8zhnRuLHxxPPNHz1lhP7Q2Sgo4razOGAa5IvjzoY
zjRnt9umuh5Lc7c9zRaNuLJXN/dT23Xcx6oDrN6gcqeldlNi9pzgPxU7P2nCwL+E
k25OuqAIB9sguIu+hUmrBQwrG7J3+pwEqqUwKW1ASU71RSDBjvg=
=0VhO
-----END PGP SIGNATURE-----

--WJ0H9jSHmz8ogVGCPHJRNlirSKFh2J5jA--

