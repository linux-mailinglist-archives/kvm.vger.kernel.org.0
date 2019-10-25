Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6A6E4576
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 10:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408057AbfJYIUK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 04:20:10 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57758 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405453AbfJYIUK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Oct 2019 04:20:10 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9P87JqV090922
        for <kvm@vger.kernel.org>; Fri, 25 Oct 2019 04:20:08 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vucdscpwt-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 25 Oct 2019 04:20:08 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Fri, 25 Oct 2019 09:20:06 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 25 Oct 2019 09:20:03 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9P8K1Rx13107668
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 08:20:01 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9AFF411C052;
        Fri, 25 Oct 2019 08:20:01 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09C3A11C05C;
        Fri, 25 Oct 2019 08:20:01 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.50.181])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Oct 2019 08:20:00 +0000 (GMT)
Subject: Re: [RFC 07/37] KVM: s390: protvirt: Secure memory is not mergeable
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-8-frankja@linux.ibm.com>
 <f80519a0-a8da-1a98-c450-b81dfcf2e897@redhat.com>
 <3f7cc352-56d8-f0c7-3cb2-7278b8262035@linux.ibm.com>
 <af9b9d01-4837-a48f-c9ce-2b20d9e8cb96@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Fri, 25 Oct 2019 10:20:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <af9b9d01-4837-a48f-c9ce-2b20d9e8cb96@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xKwOmXc5K3nk3GsGyDXduJKsFyFeUlPHy"
X-TM-AS-GCONF: 00
x-cbid: 19102508-4275-0000-0000-000003775AAF
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102508-4276-0000-0000-0000388A8771
Message-Id: <1552c0d9-8ef5-8afa-2936-6851a205e340@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-25_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910250078
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xKwOmXc5K3nk3GsGyDXduJKsFyFeUlPHy
Content-Type: multipart/mixed; boundary="dFQWTvqFpCjh1X7wtjolDityqBt4rVP5x"

--dFQWTvqFpCjh1X7wtjolDityqBt4rVP5x
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 10/25/19 10:04 AM, David Hildenbrand wrote:
> On 25.10.19 09:18, Janosch Frank wrote:
>> On 10/24/19 6:07 PM, David Hildenbrand wrote:
>>> On 24.10.19 13:40, Janosch Frank wrote:
>>>> KSM will not work on secure pages, because when the kernel reads a
>>>> secure page, it will be encrypted and hence no two pages will look t=
he
>>>> same.
>>>>
>>>> Let's mark the guest pages as unmergeable when we transition to secu=
re
>>>> mode.
>>>>
>>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>>> ---
>>>>    arch/s390/include/asm/gmap.h |  1 +
>>>>    arch/s390/kvm/kvm-s390.c     |  6 ++++++
>>>>    arch/s390/mm/gmap.c          | 28 ++++++++++++++++++----------
>>>>    3 files changed, 25 insertions(+), 10 deletions(-)
>>>>
>>>> diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gm=
ap.h
>>>> index 6efc0b501227..eab6a2ec3599 100644
>>>> --- a/arch/s390/include/asm/gmap.h
>>>> +++ b/arch/s390/include/asm/gmap.h
>>>> @@ -145,4 +145,5 @@ int gmap_mprotect_notify(struct gmap *, unsigned=
 long start,
>>>>   =20
>>>>    void gmap_sync_dirty_log_pmd(struct gmap *gmap, unsigned long dir=
ty_bitmap[4],
>>>>    			     unsigned long gaddr, unsigned long vmaddr);
>>>> +int gmap_mark_unmergeable(void);
>>>>    #endif /* _ASM_S390_GMAP_H */
>>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>>> index 924132d92782..d1ba12f857e7 100644
>>>> --- a/arch/s390/kvm/kvm-s390.c
>>>> +++ b/arch/s390/kvm/kvm-s390.c
>>>> @@ -2176,6 +2176,12 @@ static int kvm_s390_handle_pv(struct kvm *kvm=
, struct kvm_pv_cmd *cmd)
>>>>    		if (r)
>>>>    			break;
>>>>   =20
>>>> +		down_write(&current->mm->mmap_sem);
>>>> +		r =3D gmap_mark_unmergeable();
>>>> +		up_write(&current->mm->mmap_sem);
>>>> +		if (r)
>>>> +			break;
>>>> +
>>>>    		mutex_lock(&kvm->lock);
>>>>    		kvm_s390_vcpu_block_all(kvm);
>>>>    		/* FMT 4 SIE needs esca */
>>>> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
>>>> index edcdca97e85e..bf365a09f900 100644
>>>> --- a/arch/s390/mm/gmap.c
>>>> +++ b/arch/s390/mm/gmap.c
>>>> @@ -2548,6 +2548,23 @@ int s390_enable_sie(void)
>>>>    }
>>>>    EXPORT_SYMBOL_GPL(s390_enable_sie);
>>>>   =20
>>>> +int gmap_mark_unmergeable(void)
>>>> +{
>>>> +	struct mm_struct *mm =3D current->mm;
>>>> +	struct vm_area_struct *vma;
>>>> +
>>>> +	for (vma =3D mm->mmap; vma; vma =3D vma->vm_next) {
>>>> +		if (ksm_madvise(vma, vma->vm_start, vma->vm_end,
>>>> +				MADV_UNMERGEABLE, &vma->vm_flags)) {
>>>> +			mm->context.uses_skeys =3D 0;
>>>
>>> That skey setting does not make too much sense when coming via
>>> kvm_s390_handle_pv(). handle that in the caller?
>>
>> Hmm, I think the name of that variable is just plain wrong.
>> It should be "can_use_skeys" or "uses_unmergeable" (which would fit
>> better into the mm context anyway) and then we could add a
>> kvm->arch.uses_skeys to tell that we actually used them for migration
>> checks, etc..
>>
>> I had long discussions with Martin over these variable names a long ti=
me
>> ago..
>=20
> uses_skeys is set during s390_enable_skey(). that is used when we
>=20
> a) Call an skey instruction
> b) Migrate skeys
>=20
> So it should match "uses" or what am I missing?
>=20
> If you look at the users of "mm_uses_skeys(mm)" I think=20
> "uses_unmergeable" would actually be misleading. (e.g.,=20
> pgste_set_key()). it really means "somebody used skeys". The unmergable=
=20
> is just a required side effect.

Hmm, we couldn't check struct kvm from pgtable.c anyway.
Oh well, I still don't like it very much but your arguments are better
:-) Let's fix this.


--dFQWTvqFpCjh1X7wtjolDityqBt4rVP5x--

--xKwOmXc5K3nk3GsGyDXduJKsFyFeUlPHy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl2ysDAACgkQ41TmuOI4
ufgZOBAAs35/ljwhfxczO5mochYkquwPXsE457YhJw6b2PM5DItI2YeBJ0TZ+9wj
tr14D37xkAViLAOlqZkPzy2XoupRbA6dRADM5ILF6qgmPQS5nnkOZu4Xp9wIWoXW
T/MIRQnJrVdkuSGe0FGLPOcmzzykJzJ/tPlf0awksiB3U8ECj3vXVTqQqA+ekMJv
Ltg22XP8UljbFzHJ/IiNRqR0bBZ8u35DeLeEe5Fkn/QtXgQ+J5IhHatdyJQFEv14
tvVrXvwOOVT9z+sp0vso/S78O+G7NG0O16Hs+yZZ30NkmA0zJTw/jWPX1z8e6BaK
TIsInY2DRPg6bRt3c3HSlyP6uTZVscIqK+mrFNEbBeJoEFTuEAm84AlPRSutz2f9
Obz6zwtg1dJihIEN4MWADQKxeLJ0a1MzUmklbqJ7gpDoyvQpEVPw+Efc3aTPdCkl
/FXfmmNpaJ1zNhr1Qa+GtPOehg7BYsF5JsGXNozCksBYy8VMXm5VMgRvxLp12wr+
aWIkRukuKxx3CnrMumm6JOVI2/Ee3BB2ZWZVJ1NvkHxn1jWIBee2pBrjqu80lRAw
9G1kYWedDpkFR4mf/ojb9qV8j53SYFUl21Q3X8Gidm+jROygB5lfvE2jw8LPqGiA
wxYBB7lKLqNiGWUDCSf7bjg92Jyu+YuU344CR/UqiphEkWsFjww=
=vvWZ
-----END PGP SIGNATURE-----

--xKwOmXc5K3nk3GsGyDXduJKsFyFeUlPHy--

