Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 523BBFDA3B
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 10:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbfKOJ7i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 04:59:38 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19934 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727135AbfKOJ7h (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Nov 2019 04:59:37 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAF9w2Id066171
        for <kvm@vger.kernel.org>; Fri, 15 Nov 2019 04:59:36 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w9nsjgk0f-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 15 Nov 2019 04:59:36 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Fri, 15 Nov 2019 09:59:34 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 15 Nov 2019 09:59:31 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAF9xUtQ46596454
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Nov 2019 09:59:30 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 49B7A11C04C;
        Fri, 15 Nov 2019 09:59:30 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E28E011C04A;
        Fri, 15 Nov 2019 09:59:29 +0000 (GMT)
Received: from dyn-9-152-224-131.boeblingen.de.ibm.com (unknown [9.152.224.131])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 15 Nov 2019 09:59:29 +0000 (GMT)
Subject: Re: [RFC 29/37] KVM: s390: protvirt: Sync pv state
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-30-frankja@linux.ibm.com>
 <e60f6e74-2d0f-36a8-cde7-1b6054370ba8@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Fri, 15 Nov 2019 10:59:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <e60f6e74-2d0f-36a8-cde7-1b6054370ba8@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GGVcwaYrLGzDsEyLZevegTNu5tPncZo8f"
X-TM-AS-GCONF: 00
x-cbid: 19111509-0008-0000-0000-0000032F3C49
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111509-0009-0000-0000-00004A4E4E45
Message-Id: <b016cee2-18b5-a621-62b0-f230adfc89ce@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-15_02:2019-11-15,2019-11-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 bulkscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0 impostorscore=0
 mlxlogscore=885 phishscore=0 suspectscore=3 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911150093
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GGVcwaYrLGzDsEyLZevegTNu5tPncZo8f
Content-Type: multipart/mixed; boundary="xlz7sHVn2vb8PVMz5aVKx2wSIRfkJDGvy"

--xlz7sHVn2vb8PVMz5aVKx2wSIRfkJDGvy
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/15/19 10:36 AM, Thomas Huth wrote:
> On 24/10/2019 13.40, Janosch Frank wrote:
>> Indicate via register sync if the VM is in secure mode.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  arch/s390/include/uapi/asm/kvm.h | 5 ++++-
>>  arch/s390/kvm/kvm-s390.c         | 7 ++++++-
>>  2 files changed, 10 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi=
/asm/kvm.h
>> index 436ec7636927..b44c02426c2e 100644
>> --- a/arch/s390/include/uapi/asm/kvm.h
>> +++ b/arch/s390/include/uapi/asm/kvm.h
>> @@ -231,11 +231,13 @@ struct kvm_guest_debug_arch {
>>  #define KVM_SYNC_GSCB   (1UL << 9)
>>  #define KVM_SYNC_BPBC   (1UL << 10)
>>  #define KVM_SYNC_ETOKEN (1UL << 11)
>> +#define KVM_SYNC_PV	(1UL << 12)
>> =20
>>  #define KVM_SYNC_S390_VALID_FIELDS \
>>  	(KVM_SYNC_PREFIX | KVM_SYNC_GPRS | KVM_SYNC_ACRS | KVM_SYNC_CRS | \
>>  	 KVM_SYNC_ARCH0 | KVM_SYNC_PFAULT | KVM_SYNC_VRS | KVM_SYNC_RICCB | =
\
>> -	 KVM_SYNC_FPRS | KVM_SYNC_GSCB | KVM_SYNC_BPBC | KVM_SYNC_ETOKEN)
>> +	 KVM_SYNC_FPRS | KVM_SYNC_GSCB | KVM_SYNC_BPBC | KVM_SYNC_ETOKEN | \=

>> +	 KVM_SYNC_PV)
>> =20
>>  /* length and alignment of the sdnx as a power of two */
>>  #define SDNXC 8
>> @@ -261,6 +263,7 @@ struct kvm_sync_regs {
>>  	__u8  reserved[512];	/* for future vector expansion */
>>  	__u32 fpc;		/* valid on KVM_SYNC_VRS or KVM_SYNC_FPRS */
>>  	__u8 bpbc : 1;		/* bp mode */
>> +	__u8 pv : 1;		/* pv mode */
>>  	__u8 reserved2 : 7;
>=20
> Don't you want to decrease the reserved2 bits to 6 ? ...

Ups

>=20
>>  	__u8 padding1[51];	/* riccb needs to be 64byte aligned */
>=20
> ... otherwise you might mess up the alignment here!
>=20
>>  	__u8 riccb[64];		/* runtime instrumentation controls block */
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index f623c64aeade..500972a1f742 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -2856,6 +2856,8 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
>>  		vcpu->run->kvm_valid_regs |=3D KVM_SYNC_GSCB;
>>  	if (test_kvm_facility(vcpu->kvm, 156))
>>  		vcpu->run->kvm_valid_regs |=3D KVM_SYNC_ETOKEN;
>> +	if (test_kvm_facility(vcpu->kvm, 161))
>> +		vcpu->run->kvm_valid_regs |=3D KVM_SYNC_PV;
>>  	/* fprs can be synchronized via vrs, even if the guest has no vx. Wi=
th
>>  	 * MACHINE_HAS_VX, (load|store)_fpu_regs() will work with vrs format=
=2E
>>  	 */
>> @@ -4136,6 +4138,7 @@ static void store_regs_fmt2(struct kvm_vcpu *vcp=
u, struct kvm_run *kvm_run)
>>  {
>>  	kvm_run->s.regs.gbea =3D vcpu->arch.sie_block->gbea;
>>  	kvm_run->s.regs.bpbc =3D (vcpu->arch.sie_block->fpf & FPF_BPBC) =3D=3D=
 FPF_BPBC;
>> +	kvm_run->s.regs.pv =3D 0;
>>  	if (MACHINE_HAS_GS) {
>>  		__ctl_set_bit(2, 4);
>>  		if (vcpu->arch.gs_enabled)
>> @@ -4172,8 +4175,10 @@ static void store_regs(struct kvm_vcpu *vcpu, s=
truct kvm_run *kvm_run)
>>  	/* Restore will be done lazily at return */
>>  	current->thread.fpu.fpc =3D vcpu->arch.host_fpregs.fpc;
>>  	current->thread.fpu.regs =3D vcpu->arch.host_fpregs.regs;
>> -	if (likely(!kvm_s390_pv_is_protected(vcpu->kvm)))
>> +	if (likely(!kvm_s390_pv_handle_cpu(vcpu)))
>=20
> Why change the if-statement now? Should this maybe rather be squashed
> into the patch that introduced the if-statement?

That was part of a cleanup that should have been done in other patches.

>=20
>>  		store_regs_fmt2(vcpu, kvm_run);
>> +	else
>> +		kvm_run->s.regs.pv =3D 1;
>>  }
>> =20
>>  int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kv=
m_run)
>>
>=20
>  Thomas
>=20



--xlz7sHVn2vb8PVMz5aVKx2wSIRfkJDGvy--

--GGVcwaYrLGzDsEyLZevegTNu5tPncZo8f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl3OdwEACgkQ41TmuOI4
ufgPCw//UnI4w96rOGqgcuFfQxLd071cr8WxXwEFqz+qUVYuuKgSTCs+7h2D6ycR
TDUe3VTVz84hvVZU8UojACJruivA37DLLSjPuLq/64kddKFqe17LSc8SPzeQHSt3
iionnE9IPZRRV2CDZm0upaLemmfQ9jeQ3vUvsPI2zyGADAk0lGjTxdJtdZ883HOj
wPrc6A7EJKyELCOdN1luhq1ckJF9/DG0sWnd0u8ngxTVCUy4UsxVJyajJ8KISbQq
SZL+GdUBERKW4R1Aya/7GUTRZicm4lsE0P+6mNL2ZCrsBUcwgesNpUsclaQXJ+nK
dQYfm7RdmzyDDLEzXvTFcPnLYh8BJa7aQbUoLHGsPFlYwZjR1mZsvkjkU7anPPvQ
tVw21quOIwS4rlM7hVpE0zujFg/Lf/bz47fIqH0qc0EIqk0MVn6pWB5+bKf2aZTr
Gbq7NWnAqA/1kt+zSVlXTEhY8QH5fSVmWf0RClI4lErzsaxjB98QbyMbUCfKjEPh
VDSgU+jIgIhigXknNpzTuxG5BBn3kUtflBU2v6IdeGhD+Bt+888Q0XNPvMu2e+NB
dGd8YIjSHcV6GkHQ06I3VkvQlyqpcZCXlzcMatjCzDdvNcBNGClFIZxwEe14zu48
h8GH4bju10+k+72j0RGPscrsYpiy71NkBxC4SR9CSYLzFcVprw0=
=qOXn
-----END PGP SIGNATURE-----

--GGVcwaYrLGzDsEyLZevegTNu5tPncZo8f--

