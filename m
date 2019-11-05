Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5B92EFF7A
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 15:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389496AbfKEOLP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 09:11:15 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27714 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389386AbfKEOLP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Nov 2019 09:11:15 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xA5EAJcS101026
        for <kvm@vger.kernel.org>; Tue, 5 Nov 2019 09:11:12 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2w39a1mej1-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2019 09:11:12 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Tue, 5 Nov 2019 14:11:10 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 5 Nov 2019 14:11:06 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xA5EB5tp50331870
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Nov 2019 14:11:05 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25905A4057;
        Tue,  5 Nov 2019 14:11:05 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B359BA4059;
        Tue,  5 Nov 2019 14:11:04 +0000 (GMT)
Received: from dyn-9-152-224-131.boeblingen.de.ibm.com (unknown [9.152.224.131])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Nov 2019 14:11:04 +0000 (GMT)
Subject: Re: [RFC 19/37] KVM: s390: protvirt: Add new gprs location handling
To:     David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        imbrenda@linux.ibm.com, mihajlov@linux.ibm.com, mimu@linux.ibm.com,
        cohuck@redhat.com, gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-20-frankja@linux.ibm.com>
 <2eba24a5-063d-1e93-acf0-1153963facfe@redhat.com>
 <8f7a9da4-2a49-9e3f-573e-199cd71fc99c@de.ibm.com>
 <1588a5e9-9bd9-428d-5b05-114a9307ceee@linux.ibm.com>
 <658457c3-398b-7dde-2c6d-073e4d3feac8@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Tue, 5 Nov 2019 15:11:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <658457c3-398b-7dde-2c6d-073e4d3feac8@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="j5z2E7ASSGUk6j80Smahq6WOTCS1yBPRR"
X-TM-AS-GCONF: 00
x-cbid: 19110514-0016-0000-0000-000002C0EED5
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19110514-0017-0000-0000-000033226627
Message-Id: <6a013d0c-e056-05e4-f9e4-276a0d57b51c@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-05_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=839 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1911050118
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--j5z2E7ASSGUk6j80Smahq6WOTCS1yBPRR
Content-Type: multipart/mixed; boundary="1mtzXQVWn4YynBMtNCDAZCukWPcXJmVVT"

--1mtzXQVWn4YynBMtNCDAZCukWPcXJmVVT
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/5/19 2:55 PM, David Hildenbrand wrote:
> On 05.11.19 13:39, Janosch Frank wrote:
>> On 11/5/19 1:01 PM, Christian Borntraeger wrote:
>>>
>>>
>>> On 04.11.19 12:25, David Hildenbrand wrote:
>>>> On 24.10.19 13:40, Janosch Frank wrote:
>>>>> Guest registers for protected guests are stored at offset 0x380.
>>>>>
>>>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>>>> ---
>>>>>  =C2=A0 arch/s390/include/asm/kvm_host.h |=C2=A0 4 +++-
>>>>>  =C2=A0 arch/s390/kvm/kvm-s390.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 | 11 +++++++++++
>>>>>  =C2=A0 2 files changed, 14 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/a=
sm/kvm_host.h
>>>>> index 0ab309b7bf4c..5deabf9734d9 100644
>>>>> --- a/arch/s390/include/asm/kvm_host.h
>>>>> +++ b/arch/s390/include/asm/kvm_host.h
>>>>> @@ -336,7 +336,9 @@ struct kvm_s390_itdb {
>>>>>  =C2=A0 struct sie_page {
>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct kvm_s390_sie_block sie_block=
;
>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct mcck_volatile_info mcck_info=
;=C2=A0=C2=A0=C2=A0 /* 0x0200 */
>>>>> -=C2=A0=C2=A0=C2=A0 __u8 reserved218[1000];=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 /* 0x0218 */
>>>>> +=C2=A0=C2=A0=C2=A0 __u8 reserved218[360];=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 /* 0x0218 */
>>>>> +=C2=A0=C2=A0=C2=A0 __u64 pv_grregs[16];=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 /* 0x380 */
>>>>> +=C2=A0=C2=A0=C2=A0 __u8 reserved400[512];
>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct kvm_s390_itdb itdb;=C2=A0=C2=
=A0=C2=A0 /* 0x0600 */
>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __u8 reserved700[2304];=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* 0x0700 */
>>>>>  =C2=A0 };
>>>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>>>> index 490fde080107..97d3a81e5074 100644
>>>>> --- a/arch/s390/kvm/kvm-s390.c
>>>>> +++ b/arch/s390/kvm/kvm-s390.c
>>>>> @@ -3965,6 +3965,7 @@ static int vcpu_post_run(struct kvm_vcpu *vcp=
u, int exit_reason)
>>>>>  =C2=A0 static int __vcpu_run(struct kvm_vcpu *vcpu)
>>>>>  =C2=A0 {
>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int rc, exit_reason;
>>>>> +=C2=A0=C2=A0=C2=A0 struct sie_page *sie_page =3D (struct sie_page =
*)vcpu->arch.sie_block;
>>>>>  =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * We try to hold kvm->srcu du=
ring most of vcpu_run (except when run-
>>>>> @@ -3986,8 +3987,18 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)=

>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 guest_enter=
_irqoff();
>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __disable_c=
pu_timer_accounting(vcpu);
>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 local_irq_e=
nable();
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (kvm_s390_pv_is_prot=
ected(vcpu->kvm)) {
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 memcpy(sie_page->pv_grregs,
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vcpu->run->s.regs.gprs,
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sizeof(sie_page->pv_grregs));
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 exit_reason=
 =3D sie64a(vcpu->arch.sie_block,
>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vcpu->=
run->s.regs.gprs);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (kvm_s390_pv_is_prot=
ected(vcpu->kvm)) {
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 memcpy(vcpu->run->s.regs.gprs,
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sie_page->pv_grregs,
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sizeof(sie_page->pv_grregs));
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>
>>>> sie64a will load/save gprs 0-13 from to vcpu->run->s.regs.gprs.
>>>>
>>>> I would have assume that this is not required for prot virt, because=
 the HW has direct access via the sie block?
>>>
>>> Yes, that is correct. The load/save in sie64a is not necessary for pv=
 guests.
>>>
>>>>
>>>>
>>>> 1. Would it make sense to have a specialized sie64a() (or a paramete=
r, e.g., if you pass in NULL in r3), that optimizes this loading/saving? =
Eventually we can also optimize which host registers to save/restore then=
=2E
>>>
>>> Having 2 kinds of sie64a seems not very nice for just saving a small =
number of cycles.
>>>
>>>>
>>>> 2. Avoid this copying here. We have to store the state to vcpu->run-=
>s.regs.gprs when returning to user space and restore the state when comi=
ng from user space.
>>>
>>> I like this proposal better than the first one and
>=20
> It was actually an additional proposal :)
>=20
> 1. avoids unnecessary saving/loading/saving/restoring
> 2. avoids the two memcpy
>=20
>>>>
>>>> Also, we access the GPRS from interception handlers, there we might =
use wrappers like
>>>>
>>>> kvm_s390_set_gprs()
>>>> kvm_s390_get_gprs()
>>>
>>> having register accessors might be useful anyway.
>>> But I would like to defer that to a later point in time to keep the c=
hanges in here
>>> minimal?
>>>
>>> We can add a "TODO" comment in here so that we do not forget about th=
is
>>> for a future patch. Makes sense?
>=20
> While it makes sense, I guess one could come up with a patch for 2. in =

> less than 30 minutes ... but yeah, whatever you prefer. ;)
>=20

Just to get it fully right we'd need to:
a. Synchronize registers into/from vcpu run in sync_regs/store_regs
b. Sprinkle get/set_gpr(int nr) over most of the files in arch/s390/kvm

That's your proposal?



--1mtzXQVWn4YynBMtNCDAZCukWPcXJmVVT--

--j5z2E7ASSGUk6j80Smahq6WOTCS1yBPRR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl3BgvgACgkQ41TmuOI4
ufiToxAAup3uQ7MINQh2WP27IOjjt5Sey5H6hcpTU9Olm5732hmYRIlYy1jovD/T
N99PkxRo4OypLB5dd8CbmxQ+w/2VKATxR3DNIlr6m00zp8rbanttzy21T51uO6ts
pUUDOOwFlz77Arq+wiT7nZpLbtvCmVljr4dcnwx/R5BYi2Ir13pbtO4drqr0JhfY
oIAt56VTltuI49QnpbjvRAMKMDx8t4VsgHH9UqOl9NFZupM/8Er5i70ot8Rsl3PK
dMbL5gm5jS5Gv4EF4eV4pgsJ1mH6dOnY2ZOEVtj2Rxz889si40bhjgMY6ZBjRgQI
leLxgYj0bqYkGwFpw4WE9ufWKoPsD0OBwmTXNnne1Z1MUM8KgVirP6eBRXWEKc4E
7RtO5q+fgAdqg7dfSybXQjzGmQMlUopTsfG5KB7YNyUGbqiWSVfq6dgVnPXtefdg
1Z8KrDly3SoJEDLlqz3Lc+DSTKUc2MxRqab9OBugyW4JVlSUym9dmdNtHk+397U3
0BAAbSkQegZDn7OJkiUY9aPzTftApIS21jeEB9e6a3+C41vyQTvPiRDynvzEN6fR
yki6gykeV6pAcIzyWJ0Vnjvm8j4BpiyFa650sRXkcGn1ewgth5VEVqh2G/AdpQuB
zOdR71YprPfAH39XX0M67erx2nUSURqTMU6D4326FEJVpM/whEI=
=OaOc
-----END PGP SIGNATURE-----

--j5z2E7ASSGUk6j80Smahq6WOTCS1yBPRR--

