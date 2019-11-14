Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAA3AFCA6C
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 17:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfKNQAu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 11:00:50 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24702 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726214AbfKNQAu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Nov 2019 11:00:50 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAEFsSff035617
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 11:00:48 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2w99d421fq-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 11:00:48 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 14 Nov 2019 16:00:46 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 14 Nov 2019 16:00:43 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAEG0fEe37748800
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 16:00:41 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2BEEA406A;
        Thu, 14 Nov 2019 16:00:41 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 71401A405C;
        Thu, 14 Nov 2019 16:00:41 +0000 (GMT)
Received: from dyn-9-152-224-131.boeblingen.de.ibm.com (unknown [9.152.224.131])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Nov 2019 16:00:41 +0000 (GMT)
Subject: Re: [RFC 21/37] KVM: S390: protvirt: Instruction emulation
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-22-frankja@linux.ibm.com>
 <20191114163819.4fb4bed1.cohuck@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Thu, 14 Nov 2019 17:00:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191114163819.4fb4bed1.cohuck@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="inn8F68ytwU9e9c4sIqhVBsNilow3Ta6d"
X-TM-AS-GCONF: 00
x-cbid: 19111416-4275-0000-0000-0000037DBCF6
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111416-4276-0000-0000-0000389123E2
Message-Id: <d25f2feb-2c40-efae-9970-e08c871de94e@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-14_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911140145
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--inn8F68ytwU9e9c4sIqhVBsNilow3Ta6d
Content-Type: multipart/mixed; boundary="FCnCkHKGqYIED1pdS398bmqp0uAAphmfy"

--FCnCkHKGqYIED1pdS398bmqp0uAAphmfy
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/14/19 4:38 PM, Cornelia Huck wrote:
> On Thu, 24 Oct 2019 07:40:43 -0400
> Janosch Frank <frankja@linux.ibm.com> wrote:
>=20
>> We have two new SIE exit codes 104 for a secure instruction
>> interception, on which the SIE needs hypervisor action to complete the=

>> instruction.
>>
>> And 108 which is merely a notification and provides data for tracking
>> and management, like for the lowcore we set notification bits for the
>> lowcore pages.
>=20
> What about the following:
>=20
> "With protected virtualization, we have two new SIE exit codes:
>=20
> - 104 indicates a secure instruction interception; the hypervisor needs=

>   to complete emulation of the instruction.
> - 108 is merely a notification providing data for tracking and
>   management in the hypervisor; for example, we set notification bits
>   for the lowcore pages."
>=20
> ?
>=20
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  arch/s390/include/asm/kvm_host.h |  2 ++
>>  arch/s390/kvm/intercept.c        | 23 +++++++++++++++++++++++
>>  2 files changed, 25 insertions(+)
>>
>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/=
kvm_host.h
>> index 2a8a1e21e1c3..a42dfe98128b 100644
>> --- a/arch/s390/include/asm/kvm_host.h
>> +++ b/arch/s390/include/asm/kvm_host.h
>> @@ -212,6 +212,8 @@ struct kvm_s390_sie_block {
>>  #define ICPT_KSS	0x5c
>>  #define ICPT_PV_MCHKR	0x60
>>  #define ICPT_PV_INT_EN	0x64
>> +#define ICPT_PV_INSTR	0x68
>> +#define ICPT_PV_NOT	0x6c
>=20
> Maybe ICPT_PV_NOTIF?

NOTF?

>=20
>>  	__u8	icptcode;		/* 0x0050 */
>>  	__u8	icptstatus;		/* 0x0051 */
>>  	__u16	ihcpu;			/* 0x0052 */
>> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
>> index b013a9c88d43..a1df8a43c88b 100644
>> --- a/arch/s390/kvm/intercept.c
>> +++ b/arch/s390/kvm/intercept.c
>> @@ -451,6 +451,23 @@ static int handle_operexc(struct kvm_vcpu *vcpu)
>>  	return kvm_s390_inject_program_int(vcpu, PGM_OPERATION);
>>  }
>> =20
>> +static int handle_pv_spx(struct kvm_vcpu *vcpu)
>> +{
>> +	u32 pref =3D *(u32 *)vcpu->arch.sie_block->sidad;
>> +
>> +	kvm_s390_set_prefix(vcpu, pref);
>> +	trace_kvm_s390_handle_prefix(vcpu, 1, pref);
>> +	return 0;
>> +}
>> +
>> +static int handle_pv_not(struct kvm_vcpu *vcpu)
>> +{
>> +	if (vcpu->arch.sie_block->ipa =3D=3D 0xb210)
>> +		return handle_pv_spx(vcpu);
>> +
>> +	return handle_instruction(vcpu);
>=20
> Hm... if I understood it correctly, we are getting this one because the=

> SIE informs us about things that it handled itself (but which we
> should be aware of). What can handle_instruction() do in this case?

There used to be an instruction which I could just pipe through normal
instruction handling. But I can't really remember what it was, too many
firmware changes in that area since then.

I'll mark it as a TODO for thinking about it with some coffee.

>=20
>> +}
>> +
>>  int kvm_handle_sie_intercept(struct kvm_vcpu *vcpu)
>>  {
>>  	int rc, per_rc =3D 0;
>> @@ -505,6 +522,12 @@ int kvm_handle_sie_intercept(struct kvm_vcpu *vcp=
u)
>>  		 */
>>  		rc =3D 0;
>>  	break;
>> +	case ICPT_PV_INSTR:
>> +		rc =3D handle_instruction(vcpu);
>> +		break;
>> +	case ICPT_PV_NOT:
>> +		rc =3D handle_pv_not(vcpu);
>> +		break;
>>  	default:
>>  		return -EOPNOTSUPP;
>>  	}
>=20



--FCnCkHKGqYIED1pdS398bmqp0uAAphmfy--

--inn8F68ytwU9e9c4sIqhVBsNilow3Ta6d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl3NeikACgkQ41TmuOI4
ufjPmBAAiYVxSY40wrV7Yk7+Up9eFqQ6ZECpcVeq3B01X+IxfqSJn+Ad9zfa6PFa
GQfzrGDDlYPzV5taLgino/0ZYTBC1ra/s+8DkUQIvkmXtSlGtP9S8CVJ32YEd0Jc
xtyd7KusXH04SX+OhaiTXAX128JaxeMv3ZXO87l/84t8qkfFEkszPQu6jR1QKgjA
nMb818QGTLmOHScyDBVOEAq0tgMU0WYEPzPMAuR6B5SlPdt5ciKg2J6hTpwK3o5Q
EB0x7YqCBKnH/DNr0U2b7QjXCR1beuWdnxBJTJ2gH0tw0XLhTRwllJpnCkWdjfr6
Ff6yMJlNCnWYCvqwkQXFjGZymmQih/AF9Wj3hRMsZOyaM+mPrqrkjhu9aaBsRxC7
tCFLcbf79ecIdDJIA1hNuCaRVZB6WImnpJbKbQg/f7VJSMb8BUncd+uJ07NFtdAe
L86ltSll+fN1mds6ORLQxuftW0C8P/FkP3t3dOX6vOTlzP+LlGlhPUU7r5MrM/2l
auE6dnGvm2MzzUo7QcSO1j1SYLdeomc6WW3PdCL+DYFZKQ+d1zG8OGH0JZT15jYa
XgFfKM4haA4YuFaYf+NpCr4SliM4TLjeWc0dJkhxrY9K1OqyVhT0t4k5pKWMehAw
WmIetlF7J19mGwe0+VpoCfMWpgQvdOed0ezuuj6RvJP8Iw7SXbo=
=w6Wb
-----END PGP SIGNATURE-----

--inn8F68ytwU9e9c4sIqhVBsNilow3Ta6d--

