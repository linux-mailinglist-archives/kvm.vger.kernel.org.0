Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8405A153075
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 13:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgBEMQt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 07:16:49 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27326 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726810AbgBEMQt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 07:16:49 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 015CE0Nm001977
        for <kvm@vger.kernel.org>; Wed, 5 Feb 2020 07:16:48 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xyphw5gx3-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 07:16:48 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Wed, 5 Feb 2020 12:16:46 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 5 Feb 2020 12:16:42 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 015CGfQL48037904
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Feb 2020 12:16:41 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F317FAE05A;
        Wed,  5 Feb 2020 12:16:40 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6F04AE04D;
        Wed,  5 Feb 2020 12:16:40 +0000 (GMT)
Received: from dyn-9-152-224-44.boeblingen.de.ibm.com (unknown [9.152.224.44])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  5 Feb 2020 12:16:40 +0000 (GMT)
Subject: Re: [RFCv2 21/37] KVM: S390: protvirt: Introduce instruction data
 area bounce buffer
To:     Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-22-borntraeger@de.ibm.com>
 <55220810-3e2f-6312-4199-2afb583d9ff2@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Wed, 5 Feb 2020 13:16:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <55220810-3e2f-6312-4199-2afb583d9ff2@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="axWfYl7f3fGps4efmhbpu9QUc5y2Qj4rh"
X-TM-AS-GCONF: 00
x-cbid: 20020512-4275-0000-0000-0000039E272F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020512-4276-0000-0000-000038B2513C
Message-Id: <47593ba3-43c0-c7d3-2f4f-e649e21cb29a@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-05_03:2020-02-04,2020-02-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 suspectscore=3 phishscore=0
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 adultscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002050100
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--axWfYl7f3fGps4efmhbpu9QUc5y2Qj4rh
Content-Type: multipart/mixed; boundary="iVPQKqtBxCxPvVVkBdkEDfGObjCChZj2x"

--iVPQKqtBxCxPvVVkBdkEDfGObjCChZj2x
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2/5/20 1:02 PM, Thomas Huth wrote:
> On 03/02/2020 14.19, Christian Borntraeger wrote:
>> From: Janosch Frank <frankja@linux.ibm.com>
>>
>> Now that we can't access guest memory anymore, we have a dedicated
>> sattelite block that's a bounce buffer for instruction data.
>>
>> We re-use the memop interface to copy the instruction data to / from
>> userspace. This lets us re-use a lot of QEMU code which used that
>> interface to make logical guest memory accesses which are not possible=

>> anymore in protected mode anyway.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
> [...]
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index eab741bc12c3..20969ce12096 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -466,7 +466,7 @@ struct kvm_translation {
>>  	__u8  pad[5];
>>  };
>> =20
>> -/* for KVM_S390_MEM_OP */
>> +/* for KVM_S390_MEM_OP and KVM_S390_SIDA_OP */
>>  struct kvm_s390_mem_op {
>>  	/* in */
>>  	__u64 gaddr;		/* the guest address */
>> @@ -475,11 +475,17 @@ struct kvm_s390_mem_op {
>>  	__u32 op;		/* type of operation */
>>  	__u64 buf;		/* buffer in userspace */
>>  	__u8 ar;		/* the access register number */
>> -	__u8 reserved[31];	/* should be set to 0 */
>> +	__u8 reserved21[3];	/* should be set to 0 */
>> +	__u32 offset;		/* offset into the sida */
>> +	__u8 reserved28[24];	/* should be set to 0 */
>>  };
>> +
>> +
>>  /* types for kvm_s390_mem_op->op */
>>  #define KVM_S390_MEMOP_LOGICAL_READ	0
>>  #define KVM_S390_MEMOP_LOGICAL_WRITE	1
>> +#define KVM_S390_MEMOP_SIDA_READ	2
>> +#define KVM_S390_MEMOP_SIDA_WRITE	3
>>  /* flags for kvm_s390_mem_op->flags */
>>  #define KVM_S390_MEMOP_F_CHECK_ONLY		(1ULL << 0)
>>  #define KVM_S390_MEMOP_F_INJECT_EXCEPTION	(1ULL << 1)
>> @@ -1510,6 +1516,7 @@ struct kvm_pv_cmd {
>>  /* Available with KVM_CAP_S390_PROTECTED */
>>  #define KVM_S390_PV_COMMAND		_IOW(KVMIO, 0xc5, struct kvm_pv_cmd)
>>  #define KVM_S390_PV_COMMAND_VCPU	_IOW(KVMIO, 0xc6, struct kvm_pv_cmd)=

>> +#define KVM_S390_SIDA_OP		_IOW(KVMIO, 0xc7, struct kvm_s390_mem_op)
>> =20
>>  /* Secure Encrypted Virtualization command */
>>  enum sev_cmd_id {
>>
>=20
> Uh, why the mix of a new ioctl with the existing mem_op stuff? Could yo=
u
> please either properly integrate this into the MEM_OP ioctl (and e.g.
> use gaddr as offset for the new SIDA_READ and SIDA_WRITE subcodes), or
> completely separate it for a new ioctl, i.e. introduce a new struct for=

> the new ioctl instead of recycling the struct kvm_s390_mem_op here?
> (and in case you ask me, I'd slightly prefer to integrate everything
> into MEM_OP instead of introducing a new ioctl here).

*cough* David and Christian didn't like the memop solution and it took
me a long time to get this to work properly in QEMU...

I wouldn't mind a dedicated struct.

>=20
> In any case, please also update Documentation/virt/kvm/api.txt with the=

> new SIDA functions.
>=20
>  Thanks,
>   Thomas
>=20



--iVPQKqtBxCxPvVVkBdkEDfGObjCChZj2x--

--axWfYl7f3fGps4efmhbpu9QUc5y2Qj4rh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl46sigACgkQ41TmuOI4
ufhBzg//Xy32Tz53jOLD8EbSj9bPGbCK1LLw0mr160y8/WNsyml/31ofa4E04o/w
EDFuMeKZC/vDIxNLvNbcRKT9Elqf0M86U6RjcMxKECYhXAiGMFSE5kFksy4oa46x
sGUR+P8Gnqd1ZjtSGX+5O/9LKwZct8w1VeUncK5zZ1DBET2bgsHjuS9U6rJH/EER
8KVK+NYvnFTCbi1sW6Ikr0hPENGv9me5KjrWuiDED3X6CbTm1W4T22hHdzNVt1Xo
T9sPBAkrS8sC6CrvVTyt6KL5keaIv71H59HawB9iAaCPK+peknpOVbVBMJ8FdnPI
STwb3gY2uvNg1yskh1ect69IVATXciuQG2sPEALknDO4M+HvBMtf7yg3W1Bht/rG
GGXJYG77aYMks3jhpL0Nr7i32S1Q8I+1lMSrHOup+/THtGNiVCABFbJDS7mdzOR/
3zB+uYKud9j1dQ94A6rlK/shheSMWvKX76D72Ejq3t7j0laEqjYnKfyW5ER4owix
awGN0fPQpJ8l/qjG7MLGQWbpwO2sKm1/4hx3lkxSZSoJKmhlWoOZ04fsPOVtboZI
33E4nfldahEk0/SzqP0dFZDnQM09krpGkO4leQ04tbXFNI0d5kBBdSblyc6+itiu
6za7DJ7yMZ5Jf8sbrh+PSfIE9qoEZb6taxzQpdfBD0Dl8gZm6cg=
=bCrn
-----END PGP SIGNATURE-----

--axWfYl7f3fGps4efmhbpu9QUc5y2Qj4rh--

