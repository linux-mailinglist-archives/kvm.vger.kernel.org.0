Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF40FFDB2E
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 11:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbfKOKU7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 05:20:59 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31978 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727142AbfKOKU7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Nov 2019 05:20:59 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAFAHdg8014279
        for <kvm@vger.kernel.org>; Fri, 15 Nov 2019 05:20:58 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2w9nsfhy8h-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 15 Nov 2019 05:20:57 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Fri, 15 Nov 2019 10:20:56 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 15 Nov 2019 10:20:54 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAFAKqoB66388140
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Nov 2019 10:20:53 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E0627AE055;
        Fri, 15 Nov 2019 10:20:52 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 93E6BAE04D;
        Fri, 15 Nov 2019 10:20:52 +0000 (GMT)
Received: from dyn-9-152-224-131.boeblingen.de.ibm.com (unknown [9.152.224.131])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 15 Nov 2019 10:20:52 +0000 (GMT)
Subject: Re: [RFC 31/37] KVM: s390: protvirt: Add diag 308 subcode 8 - 10
 handling
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-32-frankja@linux.ibm.com>
 <a1c263ff-954e-a7c3-28b4-e9bd866eb35f@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Fri, 15 Nov 2019 11:20:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <a1c263ff-954e-a7c3-28b4-e9bd866eb35f@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mNYpZWWMOSggPlAcZYjb8DkDdg1R4ughY"
X-TM-AS-GCONF: 00
x-cbid: 19111510-0016-0000-0000-000002C3DF1C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111510-0017-0000-0000-0000332585A8
Message-Id: <f9ecf949-3f0d-fb64-cc77-44974a71625e@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-15_02:2019-11-15,2019-11-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=3 adultscore=0
 spamscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 mlxlogscore=999 priorityscore=1501 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911150097
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mNYpZWWMOSggPlAcZYjb8DkDdg1R4ughY
Content-Type: multipart/mixed; boundary="0OjYKmcMSlh5SbpgqAJVhbT8Vo68SsmnL"

--0OjYKmcMSlh5SbpgqAJVhbT8Vo68SsmnL
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/15/19 11:04 AM, Thomas Huth wrote:
> On 24/10/2019 13.40, Janosch Frank wrote:
>> If the host initialized the Ultravisor, we can set stfle bit 161
>> (protected virtual IPL enhancements facility), which indicates, that
>> the IPL subcodes 8, 9 and are valid. These subcodes are used by a
>> normal guest to set/retrieve a IPIB of type 5 and transition into
>> protected mode.
>>
>> Once in protected mode, the VM will loose the facility bit, as each
>=20
> So should the bit be cleared in the host code again? ... I don't see
> this happening in this patch?
>=20
>  Thomas

No, KVM doesn't report stfle facilities in protected mode and we would
need to add it again in normal mode so just clearing it would be
pointless. In protected mode 8-10 do not intercept, so there's nothing
we need to do.

>=20
>=20
>> boot into protected mode has to go through non-protected. There is no
>> secure re-ipl with subcode 10 without a previous subcode 3.
>>
>> In protected mode, there is no subcode 4 available, as the VM has no
>> more access to its memory from non-protected mode. I.e. each IPL
>> clears.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  arch/s390/kvm/diag.c     | 6 ++++++
>>  arch/s390/kvm/kvm-s390.c | 5 +++++
>>  2 files changed, 11 insertions(+)
>>
>> diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
>> index 3fb54ec2cf3e..b951dbdcb6a0 100644
>> --- a/arch/s390/kvm/diag.c
>> +++ b/arch/s390/kvm/diag.c
>> @@ -197,6 +197,12 @@ static int __diag_ipl_functions(struct kvm_vcpu *=
vcpu)
>>  	case 4:
>>  		vcpu->run->s390_reset_flags =3D 0;
>>  		break;
>> +	case 8:
>> +	case 9:
>> +	case 10:
>> +		if (!test_kvm_facility(vcpu->kvm, 161))
>> +			return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
>> +		/* fall through */
>>  	default:
>>  		return -EOPNOTSUPP;
>>  	}
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index 500972a1f742..8947f1812b12 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -2590,6 +2590,11 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned =
long type)
>>  	if (css_general_characteristics.aiv && test_facility(65))
>>  		set_kvm_facility(kvm->arch.model.fac_mask, 65);
>> =20
>> +	if (is_prot_virt_host()) {
>> +		set_kvm_facility(kvm->arch.model.fac_mask, 161);
>> +		set_kvm_facility(kvm->arch.model.fac_list, 161);
>> +	}
>> +
>>  	kvm->arch.model.cpuid =3D kvm_s390_get_initial_cpuid();
>>  	kvm->arch.model.ibc =3D sclp.ibc & 0x0fff;
>> =20
>>
>=20



--0OjYKmcMSlh5SbpgqAJVhbT8Vo68SsmnL--

--mNYpZWWMOSggPlAcZYjb8DkDdg1R4ughY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl3OfAQACgkQ41TmuOI4
ufgQJRAAoBtCjfumzllkyZTQ/uQSqRqjPR7uB7phjpQCIiVKgk4A09wm/u7MA/Tq
oqOHdedilCE3bh49jB7GvS9mKpzbZd7Y4T0F9uvXgbgxR/6wge+5gLBU7vHUwJnU
D4ygrcDAV2EOQqUKACIL1TvJ6WCEqp7UrWpFNLfk61j3WPUaSIje/K6v61brTOGy
4PpKg/afmFugkj7vOBu7d6WLpmuKSeSU4gdrR6+NT1hO3/AHMqOrQaSB50BMlDgl
cN57Db2AnKJlCYM7yaWEL0yKKpLi93j/q7Kn88vo+9iM6AK+SbaEDuUHO4G/pisn
ZbICi1mb7Qki9kezlHl3pyUEzBaH/RrD2NdG0qov+EOz+yjpfC4GPa+Y2zNymz+D
+gBdSYCI6YSUjoZnbXJzy2b/90wgKfJq9CzcwLQ1nvfyPTJ6p7HmUZuuPAeOZLlN
rZbF4WFgfmTMMbbAUNcEjUgLcKRXTmp3zyOSx6AGntK9ohftz7+S/KtfGvgQwdj7
N7vRxUAPCfjOo55ePb2/BOFi9pV1MREC9SF/LBML+wI+18TCTbq2PpZeWARL+LO0
a1j/HqdaBYiInUgf9SdJzOwaXSzu6gWlacbp+K8x7LwfwSC7yRIEOnBO/dNd82Pz
sENSKN4ieGLqynBr3v6xW7SDhPbI69Pn+gdRm0q8V6OyET/Answ=
=Neg9
-----END PGP SIGNATURE-----

--mNYpZWWMOSggPlAcZYjb8DkDdg1R4ughY--

