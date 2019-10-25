Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05BB6E4439
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 09:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406738AbfJYHSP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 03:18:15 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32832 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1733140AbfJYHSO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Oct 2019 03:18:14 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9P7Hxls138080
        for <kvm@vger.kernel.org>; Fri, 25 Oct 2019 03:18:12 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vuuvw13w2-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 25 Oct 2019 03:18:12 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Fri, 25 Oct 2019 08:18:11 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 25 Oct 2019 08:18:07 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9P7I50m62587024
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 07:18:06 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AEE7711C05C;
        Fri, 25 Oct 2019 07:18:05 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2970511C04A;
        Fri, 25 Oct 2019 07:18:05 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.50.181])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Oct 2019 07:18:05 +0000 (GMT)
Subject: Re: [RFC 07/37] KVM: s390: protvirt: Secure memory is not mergeable
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-8-frankja@linux.ibm.com>
 <f80519a0-a8da-1a98-c450-b81dfcf2e897@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Fri, 25 Oct 2019 09:18:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <f80519a0-a8da-1a98-c450-b81dfcf2e897@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SoRVdOudvxYJlOh2AU47xiMDhOFyxbUU3"
X-TM-AS-GCONF: 00
x-cbid: 19102507-0028-0000-0000-000003AF415C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102507-0029-0000-0000-00002471763E
Message-Id: <3f7cc352-56d8-f0c7-3cb2-7278b8262035@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-25_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910250069
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SoRVdOudvxYJlOh2AU47xiMDhOFyxbUU3
Content-Type: multipart/mixed; boundary="q88LVDfuCAAcL3xALLcX8QyiLWyOxcWlA"

--q88LVDfuCAAcL3xALLcX8QyiLWyOxcWlA
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 10/24/19 6:07 PM, David Hildenbrand wrote:
> On 24.10.19 13:40, Janosch Frank wrote:
>> KSM will not work on secure pages, because when the kernel reads a
>> secure page, it will be encrypted and hence no two pages will look the=

>> same.
>>
>> Let's mark the guest pages as unmergeable when we transition to secure=

>> mode.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/gmap.h |  1 +
>>   arch/s390/kvm/kvm-s390.c     |  6 ++++++
>>   arch/s390/mm/gmap.c          | 28 ++++++++++++++++++----------
>>   3 files changed, 25 insertions(+), 10 deletions(-)
>>
>> diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap=
=2Eh
>> index 6efc0b501227..eab6a2ec3599 100644
>> --- a/arch/s390/include/asm/gmap.h
>> +++ b/arch/s390/include/asm/gmap.h
>> @@ -145,4 +145,5 @@ int gmap_mprotect_notify(struct gmap *, unsigned l=
ong start,
>>  =20
>>   void gmap_sync_dirty_log_pmd(struct gmap *gmap, unsigned long dirty_=
bitmap[4],
>>   			     unsigned long gaddr, unsigned long vmaddr);
>> +int gmap_mark_unmergeable(void);
>>   #endif /* _ASM_S390_GMAP_H */
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index 924132d92782..d1ba12f857e7 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -2176,6 +2176,12 @@ static int kvm_s390_handle_pv(struct kvm *kvm, =
struct kvm_pv_cmd *cmd)
>>   		if (r)
>>   			break;
>>  =20
>> +		down_write(&current->mm->mmap_sem);
>> +		r =3D gmap_mark_unmergeable();
>> +		up_write(&current->mm->mmap_sem);
>> +		if (r)
>> +			break;
>> +
>>   		mutex_lock(&kvm->lock);
>>   		kvm_s390_vcpu_block_all(kvm);
>>   		/* FMT 4 SIE needs esca */
>> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
>> index edcdca97e85e..bf365a09f900 100644
>> --- a/arch/s390/mm/gmap.c
>> +++ b/arch/s390/mm/gmap.c
>> @@ -2548,6 +2548,23 @@ int s390_enable_sie(void)
>>   }
>>   EXPORT_SYMBOL_GPL(s390_enable_sie);
>>  =20
>> +int gmap_mark_unmergeable(void)
>> +{
>> +	struct mm_struct *mm =3D current->mm;
>> +	struct vm_area_struct *vma;
>> +
>> +	for (vma =3D mm->mmap; vma; vma =3D vma->vm_next) {
>> +		if (ksm_madvise(vma, vma->vm_start, vma->vm_end,
>> +				MADV_UNMERGEABLE, &vma->vm_flags)) {
>> +			mm->context.uses_skeys =3D 0;
>=20
> That skey setting does not make too much sense when coming via=20
> kvm_s390_handle_pv(). handle that in the caller?

Hmm, I think the name of that variable is just plain wrong.
It should be "can_use_skeys" or "uses_unmergeable" (which would fit
better into the mm context anyway) and then we could add a
kvm->arch.uses_skeys to tell that we actually used them for migration
checks, etc..

I had long discussions with Martin over these variable names a long time
ago..



--q88LVDfuCAAcL3xALLcX8QyiLWyOxcWlA--

--SoRVdOudvxYJlOh2AU47xiMDhOFyxbUU3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl2yoawACgkQ41TmuOI4
ufinRhAAj5YSe7xor8wefoJDpOGf/HBEfbVUj7oyeZ46N++V5/lj8MKobrACYN5d
a/RlUD9gu0zdCnViOjOTi5Y/pFqjLcK0bkB6RCDJvmB80bnmmLk3odyWys88ShKI
0mECo0ygoZnpQt6wcD1kxuZ1rDk5A6GW58Qom/c9aHXh1CTpqkXgaOJlIHY+8HbM
3SpCLG1caRuAJWIwVxLPctEARLEZwgBgvHAUyh8kGrlwLk8akegKauW6RmUYjduf
sSj8wZldklzf36vIM/zaWBSUgxAMBbJcozHV9S79YYBCWWhuUZJ8uFF5iWCPAhnT
kjsfqFoS3vZy5hCcclRBnvinB4tXvC0ckbZ3kwmXGu8Asr2kAv6GyQVSQzos4T1S
OowEo1LkKvakG9dgrCcR6m33NsgohZ4lC6yGYiHpCjAkXgTBJ96fYeh89BBrJoCQ
E+bdEIIHDTjc/h61dc8swcpkMssTfRjjRFOsTgdZrf9aIZ0iGqH8xDiTaO85BezX
TC7O8sOkyM1MFvkCfQqvrxhsq+m5AOeDp7wm8Hsv07kslZHkXCIVTje7swK6u5Pj
gP7aLTt/nnQb2WNO7Bz8TaozwbtphUh70TkYds1Qi+XmObhiLPTNppJaJda2on50
dvvvuKr+UVpE6rC8ZP7D+4JoCKNzFt8vLNS/yaTMBQYP9h4GWNs=
=wKEB
-----END PGP SIGNATURE-----

--SoRVdOudvxYJlOh2AU47xiMDhOFyxbUU3--

