Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15031AF805
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 10:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbfIKIdZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Sep 2019 04:33:25 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17418 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726696AbfIKIdZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Sep 2019 04:33:25 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8B8W0PB076165
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2019 04:33:24 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2uxv0rk19g-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2019 04:33:24 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Wed, 11 Sep 2019 09:33:22 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 11 Sep 2019 09:33:20 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8B8XJ4F41484454
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Sep 2019 08:33:19 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F6C6AE045;
        Wed, 11 Sep 2019 08:33:19 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7438CAE055;
        Wed, 11 Sep 2019 08:33:19 +0000 (GMT)
Received: from dyn-9-152-224-131.boeblingen.de.ibm.com (unknown [9.152.224.131])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 11 Sep 2019 08:33:19 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 4/6] s390x: Add initial smp code
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com
References: <20190905103951.36522-1-frankja@linux.ibm.com>
 <20190905103951.36522-5-frankja@linux.ibm.com>
 <51f23b0f-a928-1cd3-787d-31aed3ab7005@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Wed, 11 Sep 2019 10:33:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <51f23b0f-a928-1cd3-787d-31aed3ab7005@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="e9EgWm6zIZ4mCHv0RWLuP0iRQN6XxoYSw"
X-TM-AS-GCONF: 00
x-cbid: 19091108-4275-0000-0000-00000364618A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19091108-4276-0000-0000-00003876B844
Message-Id: <ca96ce20-a12c-9af1-bcf2-a795a5eab860@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-11_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1909110081
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--e9EgWm6zIZ4mCHv0RWLuP0iRQN6XxoYSw
Content-Type: multipart/mixed; boundary="sO5Vv5ZTSQzKOotYiLxXzI4A6V3kXs0l0";
 protected-headers="v1"
From: Janosch Frank <frankja@linux.ibm.com>
To: Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, david@redhat.com
Message-ID: <ca96ce20-a12c-9af1-bcf2-a795a5eab860@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 4/6] s390x: Add initial smp code
References: <20190905103951.36522-1-frankja@linux.ibm.com>
 <20190905103951.36522-5-frankja@linux.ibm.com>
 <51f23b0f-a928-1cd3-787d-31aed3ab7005@redhat.com>
In-Reply-To: <51f23b0f-a928-1cd3-787d-31aed3ab7005@redhat.com>

--sO5Vv5ZTSQzKOotYiLxXzI4A6V3kXs0l0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 9/9/19 5:37 PM, Thomas Huth wrote:
> On 05/09/2019 12.39, Janosch Frank wrote:
>> Let's add a rudimentary SMP library, which will scan for cpus and has
>> helper functions that manage the cpu state.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
> [...]
>> +/*Expected to be called from boot cpu */
>> +extern uint64_t *stackptr;
>> +void smp_setup(void)
>> +{
>> +	int i =3D 0;
>> +	unsigned short cpu0_addr =3D stap();
>> +	struct ReadCpuInfo *info =3D (void *)cpu_info_buffer;
>> +
>> +	spin_lock(&lock);
>> +	sclp_mark_busy();
>> +	info->h.length =3D PAGE_SIZE;
>> +	sclp_service_call(SCLP_READ_CPU_INFO, cpu_info_buffer);
>> +
>> +	if (smp_query_num_cpus() > 1)
>> +		printf("SMP: Initializing, found %d cpus\n", info->nr_configured);
>> +
>> +	cpus =3D calloc(info->nr_configured, sizeof(cpus));
>> +	for (i =3D 0; i < info->nr_configured; i++) {
>> +		if (info->entries[i].address =3D=3D cpu0_addr) {
>> +			cpu0 =3D &cpus[i];
>> +			cpu0->stack =3D stackptr;
>> +			cpu0->lowcore =3D (void *)0;
>> +			cpu0->active =3D true;
>=20
> So here cpus[i].active gets set to true ...
>=20
>> +		}
>> +		cpus[i].addr =3D info->entries[i].address;
>> +		cpus[i].active =3D false;
>=20
> ... but here it is set back to false.
>=20
> Maybe move the if-statement below this line?
>=20
>> +	}
>> +	spin_unlock(&lock);
>> +}
> [...]
>> diff --git a/s390x/cstart64.S b/s390x/cstart64.S
>> index 36f7cab..a45ea8f 100644
>> --- a/s390x/cstart64.S
>> +++ b/s390x/cstart64.S
>> @@ -172,6 +172,13 @@ diag308_load_reset:
>>  	lhi	%r2, 1
>>  	br	%r14
>> =20
>> +.globl smp_cpu_setup_state
>> +smp_cpu_setup_state:
>> +	xgr	%r1, %r1
>> +	lmg     %r0, %r15, 512(%r1)
>=20
> Can you use GEN_LC_SW_INT_GRS instead of 512?
>=20
>> +	lctlg   %c0, %c0, 776(%r1)
>=20
> ... and here GEN_LC_SW_INT_CR0 instead of 776?
>=20
> Apart from that, the patch looks fine to me.

Thanks, just fixed that



--sO5Vv5ZTSQzKOotYiLxXzI4A6V3kXs0l0--

--e9EgWm6zIZ4mCHv0RWLuP0iRQN6XxoYSw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIyBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl14sU8ACgkQ41TmuOI4
ufgNCQ/4/6tIA/YNoZbAOWqLpY1IHWAJsgSbYLg9JtYB/9qMKO3kkmVux5s3WdV1
vYrhgu7Z4/VjIclYuVG5o6tTA2VA3qfMWbP6FQFOCK8YbnS2Cu59b77LYRksxhn/
UZLN35beF/wjlwp2tX0xOZ74hNAaZfuIw0Rtxnvc+v5poIbZG1OYEFyUWIxm3LMS
mPIk1OKtIsPJbAFDRxwex86ASlEVBCipQe28fap4vgEBKsTfpjO9u8O85QUiAn1v
oQXSZINZq+hW54UtNiGUSXAAqYkU9B2wV93FG5l2gZWJDX5xsV/uW6MrHlFy8O4M
vcTDAM3w7Ib/Qau/yiKduBxnUBQTMED0+cZGsVP5WwWour8NXIQ193V1EnUiipdo
wjJu1sOFUrBgdVOilThrJBxJq6d5d8b1Bbjzn0JxUDJW3ujhTJ3wAcNfU3cjGu5V
tJ+KGdFUssVJBcB8IOQoAHUKDin254cNZzPkiFTH/x+QcxsBO0KSSkcwyvLQqit8
E/T8Xf22ZqBtVqOa7CchSXRZWEB/WVV5DnrJtahA6o3gMXvdnJutPfy/aG/3vILv
Yl//xiNrEzy+6O7Chnl25ybSTmlET4x0qcUiWO5WVoaI3MyboHpM4n/lO2Z8xCTb
689juM5TR60F9wDRqydSORBBuJB7sHKN5Y4v3pcIszGMaR0e3w==
=itzb
-----END PGP SIGNATURE-----

--e9EgWm6zIZ4mCHv0RWLuP0iRQN6XxoYSw--

