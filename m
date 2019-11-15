Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 169EEFD820
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 09:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbfKOIuZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 03:50:25 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38814 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726365AbfKOIuZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Nov 2019 03:50:25 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAF8kZrJ099094
        for <kvm@vger.kernel.org>; Fri, 15 Nov 2019 03:50:24 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w9nux607x-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 15 Nov 2019 03:50:23 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Fri, 15 Nov 2019 08:50:21 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 15 Nov 2019 08:50:19 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAF8nfXY18022840
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Nov 2019 08:49:41 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8BFC44C05E;
        Fri, 15 Nov 2019 08:50:17 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C5F74C064;
        Fri, 15 Nov 2019 08:50:17 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.187.11])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 15 Nov 2019 08:50:17 +0000 (GMT)
Subject: Re: [PATCH] Fixup sida bouncing
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com
References: <ad0f9b90-3ce4-c2d2-b661-635fe439f7e2@redhat.com>
 <20191114162153.25349-1-frankja@linux.ibm.com>
 <016cea87-9097-ca8b-2d19-9f69cdff3af6@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Fri, 15 Nov 2019 09:50:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <016cea87-9097-ca8b-2d19-9f69cdff3af6@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MuO48CUThFw9wy8z6dfRU4EQBFZ79hOSI"
X-TM-AS-GCONF: 00
x-cbid: 19111508-0028-0000-0000-000003B7161C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111508-0029-0000-0000-0000247A2685
Message-Id: <87488647-8a49-d555-e3fc-3b218dd022d1@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-15_02:2019-11-14,2019-11-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 phishscore=0 mlxscore=0 malwarescore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 impostorscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911150081
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MuO48CUThFw9wy8z6dfRU4EQBFZ79hOSI
Content-Type: multipart/mixed; boundary="lT37JmWqnRYov4lxqNJkl1KEBcA24mlnw"

--lT37JmWqnRYov4lxqNJkl1KEBcA24mlnw
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/15/19 9:19 AM, Thomas Huth wrote:
> On 14/11/2019 17.21, Janosch Frank wrote:
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  arch/s390/kvm/kvm-s390.c | 19 +++++++++++++------
>>  1 file changed, 13 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index 0fa7c6d9ed0e..9820fde04887 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -4432,13 +4432,21 @@ static long kvm_s390_guest_mem_op(struct kvm_v=
cpu *vcpu,
>>  	if (mop->size > MEM_OP_MAX_SIZE)
>>  		return -E2BIG;
>> =20
>> -	/* Protected guests move instruction data over the satellite
>> +	/*
>> +	 * Protected guests move instruction data over the satellite
>>  	 * block which has its own size limit
>>  	 */
>>  	if (kvm_s390_pv_is_protected(vcpu->kvm) &&
>> -	    mop->size > ((vcpu->arch.sie_block->sidad & 0x0f) + 1) * PAGE_SI=
ZE)
>> +	    mop->size > ((vcpu->arch.sie_block->sidad & 0xff) + 1) * PAGE_SI=
ZE)
>>  		return -E2BIG;
>> =20
>> +	/* We can currently only offset into the one SIDA page. */
>> +	if (kvm_s390_pv_is_protected(vcpu->kvm)) {
>> +		mop->gaddr &=3D ~PAGE_MASK;
>> +		if (mop->gaddr + mop->size > PAGE_SIZE)
>> +			return -EINVAL;
>> +	}
>> +
>>  	if (!(mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY)) {
>>  		tmpbuf =3D vmalloc(mop->size);
>>  		if (!tmpbuf)
>> @@ -4451,6 +4459,7 @@ static long kvm_s390_guest_mem_op(struct kvm_vcp=
u *vcpu,
>>  	case KVM_S390_MEMOP_LOGICAL_READ:
>>  		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
>>  			if (kvm_s390_pv_is_protected(vcpu->kvm)) {
>> +				/* We can always copy into the SIDA */
>>  				r =3D 0;
>>  				break;
>>  			}
>> @@ -4461,8 +4470,7 @@ static long kvm_s390_guest_mem_op(struct kvm_vcp=
u *vcpu,
>>  		if (kvm_s390_pv_is_protected(vcpu->kvm)) {
>>  			r =3D 0;
>>  			if (copy_to_user(uaddr, (void *)vcpu->arch.sie_block->sidad +
>> -					 (mop->gaddr & ~PAGE_MASK),
>> -					 mop->size))
>> +					 mop->gaddr, mop->size))
>>  				r =3D -EFAULT;
>>  			break;
>>  		}
>> @@ -4485,8 +4493,7 @@ static long kvm_s390_guest_mem_op(struct kvm_vcp=
u *vcpu,
>>  		if (kvm_s390_pv_is_protected(vcpu->kvm)) {
>>  			r =3D 0;
>>  			if (copy_from_user((void *)vcpu->arch.sie_block->sidad +
>> -					   (mop->gaddr & ~PAGE_MASK), uaddr,
>> -					   mop->size))
>> +					   mop->gaddr, uaddr, mop->size))
>>  				r =3D -EFAULT;
>>  			break;
>>  		}
>>
>=20
> That looks better, indeed.
>=20
> Still, is there a way you could also verify that gaddr references the
> right page that is mirrored in the sidad?
>=20
>  Thomas
>=20

I'm not completely sure if I understand your question correctly.
Checking that is not possible here without also looking at the
instruction bytecode and register contents which would make this patch
ridiculously large with no real benefit.


--lT37JmWqnRYov4lxqNJkl1KEBcA24mlnw--

--MuO48CUThFw9wy8z6dfRU4EQBFZ79hOSI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl3OZsgACgkQ41TmuOI4
ufjwCA/+LnraTuBnM7cN+Q/BH8hA7Ks2kdYsEsnLo/T7qQQWFDepOmKkePSwTmna
oHBXccxws09lCD6if9PqxNJ5hNXOI9Er8WPqgdbKVCngpbZEMOMRZiLsSl8AqpJN
8qrhylIisEy960pV6t9uSf5jiDsA61hdBqBxTb/oZv0hR5jtAeRXF/bvTGc73KHb
vKB234nOyyR2ImMxef/0THoH7QiUtQ5FFdAEsXH1NeWQnsNt6XvlC2jjO5b3EOYN
xsTIqPizmhcj+CvKuihXww4nTQvJemGqEBmABrP3Q7xBvexfL8ssTwqbf64GJZqS
4p67yJOuPyCZMpQ1t+kAED3l8UTFECa0UYy6B829CXGIUlPm078V6GsfkaPc52WB
WBswH8D1l0D8maPUWJGttoypYAxJohlYD/r2rRa2irvSpJnMMce361MYqet6n9sZ
Ri2pKVwPb7lwiEyTEKxlN+3vomsT48IRbptbbT0PUGhBLfl9mSTYyXyANwl/X7xx
X+06mT8XlPVbXKVEc2/Pzmcjll9xShoREYumu+STRG18ceLLzKxkuHU+Kxt4nbev
efiWWVXNWXHrSnLxnp86eUgVCDDVV/Lfxi8wv6kQXSnl9gxB/7DRdjsEukwfoLxG
tKy5glMifV7gPMryBimmsRiNdcdcvB2I71+NbtQE3VLcTJete8E=
=0tfE
-----END PGP SIGNATURE-----

--MuO48CUThFw9wy8z6dfRU4EQBFZ79hOSI--

