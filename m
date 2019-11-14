Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19E68FCA7C
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 17:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfKNQEh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 11:04:37 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13410 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726482AbfKNQEh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Nov 2019 11:04:37 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAEG3VH4031102
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 11:04:35 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w92jm64nv-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 11:04:31 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 14 Nov 2019 16:04:22 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 14 Nov 2019 16:04:19 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAEG4IvO42729700
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 16:04:18 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B3F9A405C;
        Thu, 14 Nov 2019 16:04:18 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6FBDA4064;
        Thu, 14 Nov 2019 16:04:17 +0000 (GMT)
Received: from dyn-9-152-224-131.boeblingen.de.ibm.com (unknown [9.152.224.131])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Nov 2019 16:04:17 +0000 (GMT)
Subject: Re: [RFC 20/37] KVM: S390: protvirt: Introduce instruction data area
 bounce buffer
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-21-frankja@linux.ibm.com>
 <ad0f9b90-3ce4-c2d2-b661-635fe439f7e2@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Thu, 14 Nov 2019 17:04:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <ad0f9b90-3ce4-c2d2-b661-635fe439f7e2@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="LHV2TP065q4fcdyLCT5MnbeA9lSe9eCJf"
X-TM-AS-GCONF: 00
x-cbid: 19111416-0016-0000-0000-000002C3A71D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111416-0017-0000-0000-0000332549FF
Message-Id: <05b2ee44-5a6f-079d-61e0-defd01efd4d0@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-14_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911140147
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LHV2TP065q4fcdyLCT5MnbeA9lSe9eCJf
Content-Type: multipart/mixed; boundary="b79egI7UokBcavN5IBeTFrakOUwGwXgLU"

--b79egI7UokBcavN5IBeTFrakOUwGwXgLU
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/14/19 4:36 PM, Thomas Huth wrote:
> On 24/10/2019 13.40, Janosch Frank wrote:
>> Now that we can't access guest memory anymore, we have a dedicated
>> sattelite block that's a bounce buffer for instruction data.
>=20
> "satellite block that is ..."
>=20
>> We re-use the memop interface to copy the instruction data to / from
>> userspace. This lets us re-use a lot of QEMU code which used that
>> interface to make logical guest memory accesses which are not possible=

>> anymore in protected mode anyway.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  arch/s390/include/asm/kvm_host.h |  5 ++++-
>>  arch/s390/kvm/kvm-s390.c         | 31 +++++++++++++++++++++++++++++++=

>>  arch/s390/kvm/pv.c               |  9 +++++++++
>>  3 files changed, 44 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/=
kvm_host.h
>> index 5deabf9734d9..2a8a1e21e1c3 100644
>> --- a/arch/s390/include/asm/kvm_host.h
>> +++ b/arch/s390/include/asm/kvm_host.h
>> @@ -308,7 +308,10 @@ struct kvm_s390_sie_block {
>>  #define CRYCB_FORMAT2 0x00000003
>>  	__u32	crycbd;			/* 0x00fc */
>>  	__u64	gcr[16];		/* 0x0100 */
>> -	__u64	gbea;			/* 0x0180 */
>> +	union {
>> +		__u64	gbea;			/* 0x0180 */
>> +		__u64	sidad;
>> +	};
>>  	__u8    reserved188[8];		/* 0x0188 */
>>  	__u64   sdnxo;			/* 0x0190 */
>>  	__u8    reserved198[8];		/* 0x0198 */
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index 97d3a81e5074..6747cb6cf062 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -4416,6 +4416,13 @@ static long kvm_s390_guest_mem_op(struct kvm_vc=
pu *vcpu,
>>  	if (mop->size > MEM_OP_MAX_SIZE)
>>  		return -E2BIG;
>> =20
>> +	/* Protected guests move instruction data over the satellite
>> +	 * block which has its own size limit
>> +	 */
>> +	if (kvm_s390_pv_is_protected(vcpu->kvm) &&
>> +	    mop->size > ((vcpu->arch.sie_block->sidad & 0x0f) + 1) * PAGE_SI=
ZE)
>> +		return -E2BIG;
>> +
>>  	if (!(mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY)) {
>>  		tmpbuf =3D vmalloc(mop->size);
>>  		if (!tmpbuf)
>> @@ -4427,10 +4434,22 @@ static long kvm_s390_guest_mem_op(struct kvm_v=
cpu *vcpu,
>>  	switch (mop->op) {
>>  	case KVM_S390_MEMOP_LOGICAL_READ:
>>  		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
>> +			if (kvm_s390_pv_is_protected(vcpu->kvm)) {
>> +				r =3D 0;
>> +				break;
>=20
> Please add a short comment to the code why this is required / ok.
>=20
>> +			}
>>  			r =3D check_gva_range(vcpu, mop->gaddr, mop->ar,
>>  					    mop->size, GACC_FETCH);
>>  			break;
>>  		}
>> +		if (kvm_s390_pv_is_protected(vcpu->kvm)) {
>> +			r =3D 0;
>> +			if (copy_to_user(uaddr, (void *)vcpu->arch.sie_block->sidad +
>> +					 (mop->gaddr & ~PAGE_MASK),
>=20
> That looks bogus. Couldn't userspace use mop->gaddr =3D 4095 and mop->s=
ize
> =3D 4095 to read most of the page beyond the sidad page (assuming that =
it
> is mapped, too)?
> I think you have to take mop->gaddr into account in your new check at
> the beginning of the function, too.

Ah, right, that needs some fixing.

>=20
> Or should the ioctl maybe even be restricted to mop->gaddr =3D=3D 0 now=
? Is
> there maybe also a way to validate that gaddr & PAGE_MASK really matche=
s
> the page that we have in sidad?

There was one lonely usage of the ioctl where we still read from an
offset, either in IO or SCLP. Having 0 as a requirement would certainly
help, but I was a bit afraid of changing too many things in qemu.

>=20
>> +					 mop->size))
>> +				r =3D -EFAULT;
>> +			break;
>> +		}
>>  		r =3D read_guest(vcpu, mop->gaddr, mop->ar, tmpbuf, mop->size);
>>  		if (r =3D=3D 0) {
>>  			if (copy_to_user(uaddr, tmpbuf, mop->size))
>> @@ -4439,10 +4458,22 @@ static long kvm_s390_guest_mem_op(struct kvm_v=
cpu *vcpu,
>>  		break;
>>  	case KVM_S390_MEMOP_LOGICAL_WRITE:
>>  		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
>> +			if (kvm_s390_pv_is_protected(vcpu->kvm)) {
>> +				r =3D 0;
>> +				break;
>> +			}
>>  			r =3D check_gva_range(vcpu, mop->gaddr, mop->ar,
>>  					    mop->size, GACC_STORE);
>>  			break;
>>  		}
>> +		if (kvm_s390_pv_is_protected(vcpu->kvm)) {
>> +			r =3D 0;
>> +			if (copy_from_user((void *)vcpu->arch.sie_block->sidad +
>> +					   (mop->gaddr & ~PAGE_MASK), uaddr,
>> +					   mop->size))
>=20
> dito, of course.
>=20
>> +				r =3D -EFAULT;
>> +			break;
>> +		}
>>  		if (copy_from_user(tmpbuf, uaddr, mop->size)) {
>>  			r =3D -EFAULT;
>>  			break;
>=20
>  Thomas
>=20



--b79egI7UokBcavN5IBeTFrakOUwGwXgLU--

--LHV2TP065q4fcdyLCT5MnbeA9lSe9eCJf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl3NewEACgkQ41TmuOI4
ufgz0hAApNI27GtJjb9UxXU3LyiuWVhwMghvGethg4YF4+y26XA2w5Z4kIy5C/qV
l6A8xzn9CrQNTcLtEVBrnlXax8T7U7P8FXEWq1h4u644XN6Tyj7t0zKIHgv+kXo8
eXMKRmxaV8YoRo4aMNTpdPvLlkWEX/YgkKiToBaC9BkgDh9xeixhaTsrUiRkCwMf
oHwkXeHFGG7EyN6AS59YKN3F6Qv7TWVTR63l1p4banWZjlyRvMy8/zOCvHHWnJhu
OAivUD338DBBA8Q03VTb20m0L8MG6o2CNbYsUznjGAFrNLTQEm2+56xWxDfNmB9r
xnWb54X7Fe+bRv4GqtLbyI6KWXJwMNkfJzGxCl5dfccqFzPkyN2q9b8RbgydH0hK
4Tr7RieWf/xYx2G5xzpZEDqFkkUypDCdqNDpilS1xPkIRtw62avKqxz9jPw+uqx1
+CZ2r83Hh1X0us8jz6WJHxDYNDLzJIG1bgnj2m3bm/wTTGr32QI7ZcvdwB9xh5LH
1wtiF/6Vhu4nLsD7wV7rWvokQN6NK+BgVuJbAvavdxZsap2EVFKPgpuR/8pmElqd
xdD+crI38FvM3NRqCDoCxqx8iJL8h+caFkqB3HBdUoSXBjVcSB6wALxcWgaKGYxE
LSlVsKf3a1v72k4CcSn29gI4GoHhQTLPcRfaZmeX993W1hEcKYs=
=zJz+
-----END PGP SIGNATURE-----

--LHV2TP065q4fcdyLCT5MnbeA9lSe9eCJf--

