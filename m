Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD54BEA2E0
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2019 18:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727666AbfJ3R6S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Oct 2019 13:58:18 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12332 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727657AbfJ3R6S (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Oct 2019 13:58:18 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9UHJ3Ib134155
        for <kvm@vger.kernel.org>; Wed, 30 Oct 2019 13:58:17 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vyea82vce-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 30 Oct 2019 13:58:16 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Wed, 30 Oct 2019 17:58:14 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 30 Oct 2019 17:58:11 -0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9UHwA8a42729704
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Oct 2019 17:58:10 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F01B442041;
        Wed, 30 Oct 2019 17:58:09 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58E0B42045;
        Wed, 30 Oct 2019 17:58:09 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.34.29])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 30 Oct 2019 17:58:09 +0000 (GMT)
Subject: Re: [RFC 12/37] KVM: s390: protvirt: Handle SE notification
 interceptions
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-13-frankja@linux.ibm.com>
 <a3d3923a-4047-9d6e-8caf-a07c294e8c7a@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Wed, 30 Oct 2019 18:58:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <a3d3923a-4047-9d6e-8caf-a07c294e8c7a@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9njPz0MR3Ie7OdJLYN1ViX9BYSDd8kC5A"
X-TM-AS-GCONF: 00
x-cbid: 19103017-0012-0000-0000-0000035F386F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19103017-0013-0000-0000-0000219A7F89
Message-Id: <5a9facd2-3981-ff55-d861-e818cad3fd18@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-30_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910300152
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9njPz0MR3Ie7OdJLYN1ViX9BYSDd8kC5A
Content-Type: multipart/mixed; boundary="o2tJgswU0X4rSbn7KY5x9f3YsFhghwkUP"

--o2tJgswU0X4rSbn7KY5x9f3YsFhghwkUP
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 10/30/19 4:50 PM, David Hildenbrand wrote:
> On 24.10.19 13:40, Janosch Frank wrote:
>> Since KVM doesn't emulate any form of load control and load psw
>> instructions anymore, we wouldn't get an interception if PSWs or CRs
>> are changed in the guest. That means we can't inject IRQs right after
>> the guest is enabled for them.
>>
>> The new interception codes solve that problem by being a notification
>> for changes to IRQ enablement relevant bits in CRs 0, 6 and 14, as
>> well a the machine check mask bit in the PSW.
>>
>> No special handling is needed for these interception codes, the KVM
>> pre-run code will consult all necessary CRs and PSW bits and inject
>> IRQs the guest is enabled for.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/kvm_host.h |  2 ++
>>   arch/s390/kvm/intercept.c        | 18 ++++++++++++++++++
>>   2 files changed, 20 insertions(+)
>>
>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/=
kvm_host.h
>> index d4fd0f3af676..6cc3b73ca904 100644
>> --- a/arch/s390/include/asm/kvm_host.h
>> +++ b/arch/s390/include/asm/kvm_host.h
>> @@ -210,6 +210,8 @@ struct kvm_s390_sie_block {
>>   #define ICPT_PARTEXEC	0x38
>>   #define ICPT_IOINST	0x40
>>   #define ICPT_KSS	0x5c
>> +#define ICPT_PV_MCHKR	0x60
>> +#define ICPT_PV_INT_EN	0x64
>>   	__u8	icptcode;		/* 0x0050 */
>>   	__u8	icptstatus;		/* 0x0051 */
>>   	__u16	ihcpu;			/* 0x0052 */
>> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
>> index a389fa85cca2..acc1710fc472 100644
>> --- a/arch/s390/kvm/intercept.c
>> +++ b/arch/s390/kvm/intercept.c
>> @@ -480,6 +480,24 @@ int kvm_handle_sie_intercept(struct kvm_vcpu *vcp=
u)
>>   	case ICPT_KSS:
>>   		rc =3D kvm_s390_skey_check_enable(vcpu);
>>   		break;
>> +	case ICPT_PV_MCHKR:
>> +		/*
>> +		 * A protected guest changed PSW bit 13 to one and is now
>> +		 * enabled for interrupts. The pre-run code will check
>> +		 * the registers and inject pending MCHKs based on the
>> +		 * PSW and CRs. No additional work to do.
>> +		 */
>> +		rc =3D 0;
>> +		break;
>> +	case  ICPT_PV_INT_EN:
>> +		/*
>> +		 * A protected guest changed CR 0,6,14 and may now be
>> +		 * enabled for interrupts. The pre-run code will check
>> +		 * the registers and inject pending IRQs based on the
>> +		 * CRs. No additional work to do.
>> +		 */
>> +		rc =3D 0;
>> +	break;
>=20
> Wrong indentation.
>=20
> Maybe simply
>=20
> case ICPT_PV_MCHKR:
> ICPT_PV_INT_EN:
> 	/*
> 	 * PSW bit 13 or a CR (0, 6, 14) changed and we might now be
>           * able to deliver interrupts. pre-run code will take care of
>           * this.
> 	 */
> 	rc =3D 0;
> 	break;

Sounds good, I'll fix it



--o2tJgswU0X4rSbn7KY5x9f3YsFhghwkUP--

--9njPz0MR3Ie7OdJLYN1ViX9BYSDd8kC5A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl25zzAACgkQ41TmuOI4
ufhnohAAsMxqj1o3usNXOyEMnqZ24bQqsAeI7ah1WRUKybCAnmGGGIT2MIJrmrJz
2PlzVXV1WVlyY0aJPmO+JR10WDlcSDgzEwErogeNlnG56FNpw5GQgwtOHTxQU6m7
411lxMoU1dtAsxRKtKEBSyg4s0g6AAz632MtRor6SQ7hF7e24ZSodeCX6wctuoen
CHaBoD92+LqwYWdsiPiescldlQuGixxdy0UIXtoalYSpKrLZZWhllslX+6Pa7R6M
ncy/Lx53Fotg+qnYukuzwLFNfTmweYbUrkX5rH0WmBPfGPP71mr1P0aiHbvM/SlB
kHGf0ccsVD9hUmYSiIMZkJN8zfVmojRq6mf6N7whAUvrhZAT19uNpFGvIezIBlG3
/tpacBdl4Lpsh2KT4sNFlU1WAPvZa6LHeZmmSn/6Erym7HG5pIl+EpHmuGwW2n73
HPfjDqLkvU5Bi2RrQdEHzYG6BI48e/XYSwRv6GJaPeKFcp54GHhqMbgFQ5H9xSU5
PNhyxacUhPkjgXj+EdZ4zDSMozQ4yAQ4FsLqnM/9I4fpa8Zvlz6VeTCm2ftTNrfU
6MpuDAFyskJya54woLA5/NmU+/aceHGXOK+lyi3MS5UpLMVCBi41PMZ1bZu/6XP6
+C6to7DeYQy+a3qkRiL+4W2g0/gr0rfKunvD0f2A/7coVKNvi8k=
=ATAQ
-----END PGP SIGNATURE-----

--9njPz0MR3Ie7OdJLYN1ViX9BYSDd8kC5A--

