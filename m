Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE0715412F
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 10:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbgBFJcT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 04:32:19 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14530 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727778AbgBFJcT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Feb 2020 04:32:19 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0169Tknr045655
        for <kvm@vger.kernel.org>; Thu, 6 Feb 2020 04:32:17 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xyhn3u0fg-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2020 04:32:16 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 6 Feb 2020 09:32:15 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 6 Feb 2020 09:32:12 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0169WAhu48824504
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Feb 2020 09:32:11 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E474411C050;
        Thu,  6 Feb 2020 09:32:10 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 962C111C04C;
        Thu,  6 Feb 2020 09:32:10 +0000 (GMT)
Received: from dyn-9-152-224-44.boeblingen.de.ibm.com (unknown [9.152.224.44])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  6 Feb 2020 09:32:10 +0000 (GMT)
Subject: Re: [RFCv2 21/37] KVM: S390: protvirt: Introduce instruction data
 area bounce buffer
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-22-borntraeger@de.ibm.com>
 <55220810-3e2f-6312-4199-2afb583d9ff2@redhat.com>
 <47593ba3-43c0-c7d3-2f4f-e649e21cb29a@linux.ibm.com>
 <7539e1d3-79c6-3581-b3fb-afa545bb81d2@redhat.com>
 <456828bf-fb85-66ca-6887-9e505690ee6a@de.ibm.com>
 <8337e8c6-ca7f-7c61-6156-61fd3c26143f@de.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Thu, 6 Feb 2020 10:32:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <8337e8c6-ca7f-7c61-6156-61fd3c26143f@de.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ngGaI9IYW9DuERqaV1FeUyzlVPpuxie4y"
X-TM-AS-GCONF: 00
x-cbid: 20020609-0028-0000-0000-000003D7EE2C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020609-0029-0000-0000-0000249C4F5E
Message-Id: <ac0c387b-e38b-35ba-70e3-dc49e5e3c288@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-05_06:2020-02-04,2020-02-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 malwarescore=0 suspectscore=3 phishscore=0 clxscore=1015
 adultscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 lowpriorityscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002060074
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ngGaI9IYW9DuERqaV1FeUyzlVPpuxie4y
Content-Type: multipart/mixed; boundary="3ngLof24zNLzmdLMWScLmlZDrPJUyWkBu"

--3ngLof24zNLzmdLMWScLmlZDrPJUyWkBu
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2/6/20 10:20 AM, Christian Borntraeger wrote:
>=20
>=20
> On 06.02.20 10:07, Christian Borntraeger wrote:
>> On 05.02.20 18:00, Thomas Huth wrote:
>>
>>>>>
>>>>> Uh, why the mix of a new ioctl with the existing mem_op stuff? Coul=
d you
>>>>> please either properly integrate this into the MEM_OP ioctl (and e.=
g.
>>>>> use gaddr as offset for the new SIDA_READ and SIDA_WRITE subcodes),=
 or
>>>>> completely separate it for a new ioctl, i.e. introduce a new struct=
 for
>>>>> the new ioctl instead of recycling the struct kvm_s390_mem_op here?=

>>>>> (and in case you ask me, I'd slightly prefer to integrate everythin=
g
>>>>> into MEM_OP instead of introducing a new ioctl here).
>>>>
>>>> *cough* David and Christian didn't like the memop solution and it to=
ok
>>>> me a long time to get this to work properly in QEMU...
>>>
>>> I also don't like to re-use MEMOP_LOGICAL_READ and MEMOP_LOGICAL_WRIT=
E
>>> for the SIDA like you've had it in RFC v1 ... but what's wrong with
>>> using KVM_S390_MEMOP_SIDA_READ and KVM_S390_MEMOP_SIDA_WRITE with the=

>>> MEM_OP ioctl directly?
>>>
>>>  Thomas
>>>
>>
>> In essence something like the following?
>>
>> @@ -4583,6 +4618,9 @@ static long kvm_s390_guest_mem_op(struct kvm_vcp=
u *vcpu,
>>                 }
>>                 r =3D write_guest(vcpu, mop->gaddr, mop->ar, tmpbuf, m=
op->size);
>>                 break;
>> +       case KVM_S390_MEMOP_SIDA_READ:
>> +       case KVM_S390_MEMOP_SIDA_WRITE:
>> +               kvm_s390_guest_sida_op(vcpu, mop);
>=20
> a break; here
>=20
>>         default:
>>                 r =3D -EINVAL;
>>         }
>>
>>
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index ea2b4d66e0c3..6e029753c955 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1519,7 +1519,6 @@ struct kvm_pv_cmd {
>>  /* Available with KVM_CAP_S390_PROTECTED */
>>  #define KVM_S390_PV_COMMAND            _IOW(KVMIO, 0xc5, struct kvm_p=
v_cmd)
>>  #define KVM_S390_PV_COMMAND_VCPU       _IOW(KVMIO, 0xc6, struct kvm_p=
v_cmd)
>> -#define KVM_S390_SIDA_OP               _IOW(KVMIO, 0xc7, struct kvm_s=
390_mem_op)
>> =20
>>  /* Secure Encrypted Virtualization command */
>>  enum sev_cmd_id {
>>
>=20
>=20
> Janosch, I just checked your qemu tree
> the change would be just the following when we go down that path. (and =
it makes perfect sense)

Well, it's one less new ioctl and I was worried about the amount of new
ioctls anyway...

>=20
>=20
>=20
> diff --git a/target/s390x/kvm.c b/target/s390x/kvm.c
> index 42d6ef5fad..29bcdf839f 100644
> --- a/target/s390x/kvm.c
> +++ b/target/s390x/kvm.c
> @@ -862,7 +862,7 @@ int kvm_s390_mem_op_pv(S390CPU *cpu, uint64_t offse=
t, void *hostbuf,
>          return -ENOSYS;
>      }
> =20
> -    ret =3D kvm_vcpu_ioctl(CPU(cpu), KVM_S390_SIDA_OP, &mem_op);
> +    ret =3D kvm_vcpu_ioctl(CPU(cpu), KVM_S390_MEM_OP, &mem_op);
>      if (ret < 0) {
>          warn_report("KVM_S390_MEM_OP failed: %s", strerror(-ret));
>      }
>=20



--3ngLof24zNLzmdLMWScLmlZDrPJUyWkBu--

--ngGaI9IYW9DuERqaV1FeUyzlVPpuxie4y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl473RoACgkQ41TmuOI4
ufjmvg/9FE3jojXOboebCjEu2Q2/R3OX3OpjrG8aKEuUC1MCbQf8A+trSEwweis0
OYDIyDQ/zl0EPnEVv6IfH3R/iobNiIIMhMzIIJ0P9l0sbwnIXAl+0gX51nK4Y/Ix
NT9qU5r9utL1fm6bp2GvgTYQXKOPpkTIDnRzH3eVk05G2kSRpqG/WNASkKgp0fjy
lWnPWR4ydeHA7SMpogWKCJ4VvjXHtr/ajsBNPbYh0ilN12JDp5lMU76qLn4ewI/f
uZhgJreo6JJnsD5ud+wB9/KpIfiRnVXBQAVe1FztoTIjnV5zaiDmBFFe8ZTIgp5y
xKpjEncN+FC78/LZZepz2PhkyMyfyELB3bItdm+8VXrCwec2hNejUbTpAdeI2G1Y
zkVTkGTqJcmZnezd9Xf247sNc+NDm3FZvpP09HfiGL1e3TbDzgUCnlulsGS+LiGP
jXXGi9prcV6iQlS+KA2UJsOM/G7EFciRYf8UBQrpZvFCfmUJXKKPq+c1h40pWqM1
Ssdz6BRKr7bgvFxgHKBJtLRzu2BcBSjpvUXVxg1PF1joSIWN8glE2Hrryx+X1CP8
I77cG7wAiRdax1hrR2lVaw1j/NTHQmqP9HXzRwhnq7CRLlYSiErQi9EWQkRSO+Sf
xJOWgDveFqmVYuk6q/EpwsKz+hRql2+EWbyUsNWoraphxMIZGo4=
=JwYT
-----END PGP SIGNATURE-----

--ngGaI9IYW9DuERqaV1FeUyzlVPpuxie4y--

