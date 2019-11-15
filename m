Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B673FDA45
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 11:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfKOKB0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 05:01:26 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21942 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727004AbfKOKBZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Nov 2019 05:01:25 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAF9w6YG087567
        for <kvm@vger.kernel.org>; Fri, 15 Nov 2019 05:01:24 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w9nuh0evt-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 15 Nov 2019 05:01:24 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Fri, 15 Nov 2019 10:01:22 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 15 Nov 2019 10:01:19 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAFA1HRR57671878
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Nov 2019 10:01:17 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92BAA11C05B;
        Fri, 15 Nov 2019 10:01:17 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3ABC511C05E;
        Fri, 15 Nov 2019 10:01:17 +0000 (GMT)
Received: from dyn-9-152-224-131.boeblingen.de.ibm.com (unknown [9.152.224.131])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 15 Nov 2019 10:01:17 +0000 (GMT)
Subject: Re: [RFC 26/37] KVM: s390: protvirt: Only sync fmt4 registers
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-27-frankja@linux.ibm.com>
 <197c1218-3171-3e22-caf8-47cdab58caf8@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Fri, 15 Nov 2019 11:01:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <197c1218-3171-3e22-caf8-47cdab58caf8@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="PdhOTjLoZjYXjs1szoQtZlknVfAmDU2P3"
X-TM-AS-GCONF: 00
x-cbid: 19111510-0028-0000-0000-000003B71B35
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111510-0029-0000-0000-0000247A2BEF
Message-Id: <c89c28a9-15f9-0a40-4815-4f50883c93d3@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-15_02:2019-11-15,2019-11-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 spamscore=0 clxscore=1015 malwarescore=0 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=3 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1911150093
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PdhOTjLoZjYXjs1szoQtZlknVfAmDU2P3
Content-Type: multipart/mixed; boundary="1guMIYcNAznUAlPhQ2sQsZhbgu0Qy4zZn"

--1guMIYcNAznUAlPhQ2sQsZhbgu0Qy4zZn
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/15/19 10:02 AM, Thomas Huth wrote:
> On 24/10/2019 13.40, Janosch Frank wrote:
>> A lot of the registers are controlled by the Ultravisor and never
>> visible to KVM. Also some registers are overlayed, like gbea is with
>> sidad, which might leak data to userspace.
>>
>> Hence we sync a minimal set of registers for both SIE formats and then=

>> check and sync format 2 registers if necessary.
>>
>> Also we disable set/get one reg for the same reason. It's an old
>> interface anyway.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  arch/s390/kvm/kvm-s390.c | 138 +++++++++++++++++++++++---------------=
-
>>  1 file changed, 82 insertions(+), 56 deletions(-)
>>
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index 17a78774c617..f623c64aeade 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -2997,7 +2997,8 @@ static void kvm_s390_vcpu_initial_reset(struct k=
vm_vcpu *vcpu)
>>  	/* make sure the new fpc will be lazily loaded */
>>  	save_fpu_regs();
>>  	current->thread.fpu.fpc =3D 0;
>> -	vcpu->arch.sie_block->gbea =3D 1;
>> +	if (!kvm_s390_pv_is_protected(vcpu->kvm))
>> +		vcpu->arch.sie_block->gbea =3D 1;
>>  	vcpu->arch.sie_block->pp =3D 0;
>>  	vcpu->arch.sie_block->fpf &=3D ~FPF_BPBC;
>>  	vcpu->arch.pfault_token =3D KVM_S390_PFAULT_TOKEN_INVALID;
>> @@ -3367,6 +3368,10 @@ static int kvm_arch_vcpu_ioctl_get_one_reg(stru=
ct kvm_vcpu *vcpu,
>>  			     (u64 __user *)reg->addr);
>>  		break;
>>  	case KVM_REG_S390_GBEA:
>> +		if (kvm_s390_pv_is_protected(vcpu->kvm)) {
>> +			r =3D 0;
>> +			break;
>> +		}
>>  		r =3D put_user(vcpu->arch.sie_block->gbea,
>>  			     (u64 __user *)reg->addr);
>>  		break;
>> @@ -3420,6 +3425,10 @@ static int kvm_arch_vcpu_ioctl_set_one_reg(stru=
ct kvm_vcpu *vcpu,
>>  			     (u64 __user *)reg->addr);
>>  		break;
>>  	case KVM_REG_S390_GBEA:
>> +		if (kvm_s390_pv_is_protected(vcpu->kvm)) {
>> +			r =3D 0;
>> +			break;
>> +		}
>=20
> Wouldn't it be better to return EINVAL in this case? ... the callers
> definitely do not get what they expected here...
>=20
>  Thomas
>=20

Hrm, new QEMUs will use cpu run anyway and hence I guess it would make
sense as old QEMUs hopefully won't have pv support.


--1guMIYcNAznUAlPhQ2sQsZhbgu0Qy4zZn--

--PdhOTjLoZjYXjs1szoQtZlknVfAmDU2P3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl3Od2wACgkQ41TmuOI4
ufhyng//U7oBygOGsq1WSOMtR5WkCWlExYl0QexBSk80lP1Q41AjlFBEd/agzo8F
e3CORr53g+xNdle1TX4cAr+jpu5cJ/hFv/pAFyU4GqT5/H97DOotV7FXYEZHqXKj
tih9O5b1CMw2+s5ZAtAda3Z0LbhP0B+nAitXQ8Jeoj7Kb/cDAJftcZbKZ7MbD1Jw
l0JoGDDeo1Xp5MuqcL06j1yMrDRGGVUZPsh6UFJjarC44oolJLA5Mi6FIgYP9PKr
uw+Sl9NGk+y9u5kPH1SlxQKFsGryLsrs1ooJuT/JndDJMw/nO+34ZjeXS/CoNnSG
fQwBbE2M3zYvfLWR9UmjSHRYi+za/0YNwwgcBrgHPifdpuhK5EOAnlinmT0NmMyE
B2t93rAa2mskyRN/YGVU66XZ3TUSGxZiZ5tn4BeR+/HNVX44+U9T0Ct/xAVvArLV
JrGwOgGbuPu/hsRnLrUeSa6dmldHR3zGExKuAHyFNwwcBhQbQpPBzD69Bqs0QKer
/k+v0WsaWULWP8o8/WG0CghWmJqJGioWpXFEB+sYQGz10vkHax9W0fgvPUKbPW+3
0NDXks99lWClSOzloAchvuOqxJwwkinUoc/uM8WfT2DiFV1Fh8Qu9oIiIDeEfQEO
Dim9UaRRremdSFG7XAamqmVyzlGuWeBxsPKn3hDGUSLkDUYZE4E=
=k+mg
-----END PGP SIGNATURE-----

--PdhOTjLoZjYXjs1szoQtZlknVfAmDU2P3--

