Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 383B810D70F
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2019 15:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbfK2OdW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Nov 2019 09:33:22 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31800 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726843AbfK2OdV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 Nov 2019 09:33:21 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xATEXHfk130459
        for <kvm@vger.kernel.org>; Fri, 29 Nov 2019 09:33:20 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wk221pq15-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 29 Nov 2019 09:33:19 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Fri, 29 Nov 2019 14:33:16 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 29 Nov 2019 14:33:13 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xATEWWw222872518
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Nov 2019 14:32:32 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B5E3EA4053;
        Fri, 29 Nov 2019 14:33:11 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 095C4A404D;
        Fri, 29 Nov 2019 14:33:11 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.188.128])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 29 Nov 2019 14:33:10 +0000 (GMT)
Subject: Re: [PATCH] KVM: s390: Add new reset vcpu API
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, borntraeger@de.ibm.com, mihajlov@linux.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20191129142122.21528-1-frankja@linux.ibm.com>
 <bc1d057f-03a0-b850-dff8-a7156bfe3274@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Fri, 29 Nov 2019 15:33:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <bc1d057f-03a0-b850-dff8-a7156bfe3274@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="BR9NIGIspKQOZIcJnRcJi4Ezs6P0isVVF"
X-TM-AS-GCONF: 00
x-cbid: 19112914-0028-0000-0000-000003C1AC2B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19112914-0029-0000-0000-00002484BB37
Message-Id: <8e1aa1af-d929-e36b-f341-aa7dbe27f6a4@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-29_04:2019-11-29,2019-11-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 spamscore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911290126
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BR9NIGIspKQOZIcJnRcJi4Ezs6P0isVVF
Content-Type: multipart/mixed; boundary="iHS6fPCUWAnOpMZyUFwpZBryG4qHF1gzN"

--iHS6fPCUWAnOpMZyUFwpZBryG4qHF1gzN
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/29/19 3:31 PM, David Hildenbrand wrote:
> On 29.11.19 15:21, Janosch Frank wrote:
>> The architecture states that we need to reset local IRQs for all CPU
>> resets. Because the old reset interface did not support the normal CPU=

>> reset we never did that.
>>
>> Now that we have a new interface, let's properly clear out local IRQs
>> and let this commit be a reminder.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  arch/s390/kvm/kvm-s390.c | 25 ++++++++++++++++++++++++-
>>  include/uapi/linux/kvm.h |  7 +++++++
>>  2 files changed, 31 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index d9e6bf3d54f0..2f74ff46b176 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -529,6 +529,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, =
long ext)
>>  	case KVM_CAP_S390_CMMA_MIGRATION:
>>  	case KVM_CAP_S390_AIS:
>>  	case KVM_CAP_S390_AIS_MIGRATION:
>> +	case KVM_CAP_S390_VCPU_RESETS:
>>  		r =3D 1;
>>  		break;
>>  	case KVM_CAP_S390_HPAGE_1M:
>> @@ -3293,6 +3294,25 @@ static int kvm_arch_vcpu_ioctl_initial_reset(st=
ruct kvm_vcpu *vcpu)
>>  	return 0;
>>  }
>> =20
>> +static int kvm_arch_vcpu_ioctl_reset(struct kvm_vcpu *vcpu, unsigned =
long type)
>> +{
>> +	int rc =3D -EINVAL;
>> +
>> +	switch (type) {
>> +	case KVM_S390_VCPU_RESET_NORMAL:
>> +		rc =3D 0;
>> +		kvm_clear_async_pf_completion_queue(vcpu);
>> +		kvm_s390_clear_local_irqs(vcpu);
>> +		break;
>> +	case KVM_S390_VCPU_RESET_INITIAL:
>> +		/* fallthrough */
>> +	case KVM_S390_VCPU_RESET_CLEAR:
>> +		rc =3D kvm_arch_vcpu_ioctl_initial_reset(vcpu);
>=20
> As we now have two interfaces to achieve the same thing (initial reset)=
,
> I do wonder if we should simply introduce
>=20
> KVM_S390_NORMAL_RESET
> KVM_S390_CLEAR_RESET
>=20
> instead ...
>=20
> Then you can do KVM_S390_NORMAL_RESET for the bugfix and
> KVM_S390_CLEAR_RESET later for PV.
>=20
> Does anything speak against that?

Apart from loosing one more ioctl number probably not



--iHS6fPCUWAnOpMZyUFwpZBryG4qHF1gzN--

--BR9NIGIspKQOZIcJnRcJi4Ezs6P0isVVF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl3hLCYACgkQ41TmuOI4
ufg0hxAAhFsT3xaNo5wjdsMM9EnfglzO8FespiGRhjq8Zp5gKZFcuC/oCevB/vuh
qEO8mTgML3VDLgAjJBZW9AdSLW2xNP7sdd6Z1u7H3mtA36QU+abRqRpRIzUOWuuk
fN+wMqtzQCP+jq4EcQMS49iRlbw76EtGDMTgCqaHeuhfnonCT6eC76xEsqndIgYm
tYEUB4XtHOZz40zAmiE6g25kaJhsPCkUDC7uDEx/nRuQyI9S+hSKIuGCt1/Hg/U2
oL+XGxTqc8/PXvHfaIFhwxIyh9fWXzZWzCRTDsN5qDMEB3+YbxbU4PwoC4ZXYaqI
erW2xM2mnUfrKUvXIVPWYskJ5oUADPcZKvnrKlOKAwZea02a7EjHDBKCnfz3LNds
t7Ci4eADiR1s6MTtwKNDFaGgz5dCW/otXDrPBfcYSX+xP36ZoIMbkywOX3e1w3L/
KKx8/v4uzqbgVdNSJbw9Y6RrL2HzAyPCfqG10xTFOpLBudMRP/LpCx+JrzMD6pH1
e9MxW0SbO6C7eA/ZU1PqOcHbsRbMO4YOC9hwHCCb8w4moJu65XiRfjI7ayd95asb
ga3IOZFUmnOkTAzU/x0FgtgRhUcr6YnyR6+1x0Ai0v6XTYiSYEPabSiY2Qc/NY/t
x2InzGDE86Q8CJQewayjBrGMMgmsvgu10Aws8rykS9/vP+mhqH8=
=MFLK
-----END PGP SIGNATURE-----

--BR9NIGIspKQOZIcJnRcJi4Ezs6P0isVVF--

