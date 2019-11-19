Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE8C101B82
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 09:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfKSINU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 03:13:20 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:14224 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726701AbfKSINU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Nov 2019 03:13:20 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAJ87b9I086058
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2019 03:13:19 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wayj0jwh3-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2019 03:13:18 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Tue, 19 Nov 2019 08:13:16 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 19 Nov 2019 08:13:13 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAJ8CYu334931114
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 08:12:34 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 169045204F;
        Tue, 19 Nov 2019 08:13:12 +0000 (GMT)
Received: from dyn-9-152-224-153.boeblingen.de.ibm.com (unknown [9.152.224.153])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id BA9CB52065;
        Tue, 19 Nov 2019 08:13:11 +0000 (GMT)
Subject: Re: [RFC 36/37] KVM: s390: protvirt: Support cmd 5 operation state
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-37-frankja@linux.ibm.com>
 <20191118183842.36688a81.cohuck@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Tue, 19 Nov 2019 09:13:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191118183842.36688a81.cohuck@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="gXRvC5ZMi5gtu4I8P6lKGeAW1ut7Ub9Ic"
X-TM-AS-GCONF: 00
x-cbid: 19111908-0020-0000-0000-0000038A53FF
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111908-0021-0000-0000-000021E07E89
Message-Id: <44b320d8-604d-8497-59a3-defc41472ba5@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-19_01:2019-11-15,2019-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=3 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 impostorscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911190076
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gXRvC5ZMi5gtu4I8P6lKGeAW1ut7Ub9Ic
Content-Type: multipart/mixed; boundary="1MSDSL0H1jtdlGEEfZLivWwpLGkPF5Zcq"

--1MSDSL0H1jtdlGEEfZLivWwpLGkPF5Zcq
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/18/19 6:38 PM, Cornelia Huck wrote:
> On Thu, 24 Oct 2019 07:40:58 -0400
> Janosch Frank <frankja@linux.ibm.com> wrote:
>=20
>> Code 5 for the set cpu state UV call tells the UV to load a PSW from
>> the SE header (first IPL) or from guest location 0x0 (diag 308 subcode=

>> 0/1). Also it sets the cpu into operating state afterwards, so we can
>> start it.
>=20
> I'm a bit confused by the patch description: Does this mean that the UV=

> does the transition to operating state? Does the hypervisor get a
> notification for that?

CMD 5 is defined as "load psw and set to operating".
Currently QEMU will still go out and do a "set to operating" after the
cmd 5 because our current infrastructure does it and it's basically a
nop, so I didn't want to put in the effort to remove it.

>=20
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  arch/s390/include/asm/uv.h | 1 +
>>  arch/s390/kvm/kvm-s390.c   | 4 ++++
>>  include/uapi/linux/kvm.h   | 1 +
>>  3 files changed, 6 insertions(+)
>>
>> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
>> index 33b52ba306af..8d10ae731458 100644
>> --- a/arch/s390/include/asm/uv.h
>> +++ b/arch/s390/include/asm/uv.h
>> @@ -163,6 +163,7 @@ struct uv_cb_unp {
>>  #define PV_CPU_STATE_OPR	1
>>  #define PV_CPU_STATE_STP	2
>>  #define PV_CPU_STATE_CHKSTP	3
>> +#define PV_CPU_STATE_OPR_LOAD	5
>> =20
>>  struct uv_cb_cpu_set_state {
>>  	struct uv_cb_header header;
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index cc5feb67f145..5cc9108c94e4 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -4652,6 +4652,10 @@ static int kvm_s390_handle_pv_vcpu(struct kvm_v=
cpu *vcpu,
>>  		r =3D kvm_s390_pv_destroy_cpu(vcpu);
>>  		break;
>>  	}
>> +	case KVM_PV_VCPU_SET_IPL_PSW: {
>> +		r =3D kvm_s390_pv_set_cpu_state(vcpu, PV_CPU_STATE_OPR_LOAD);
>> +		break;
>> +	}
>>  	default:
>>  		r =3D -ENOTTY;
>>  	}
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 2846ed5e5dd9..973007d27d55 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1483,6 +1483,7 @@ enum pv_cmd_id {
>>  	KVM_PV_VM_UNSHARE,
>>  	KVM_PV_VCPU_CREATE,
>>  	KVM_PV_VCPU_DESTROY,
>> +	KVM_PV_VCPU_SET_IPL_PSW,
>>  };
>> =20
>>  struct kvm_pv_cmd {
>=20



--1MSDSL0H1jtdlGEEfZLivWwpLGkPF5Zcq--

--gXRvC5ZMi5gtu4I8P6lKGeAW1ut7Ub9Ic
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl3TpBcACgkQ41TmuOI4
ufisphAAlkQNPbD8yxn4GCTR+EeFWa76Mjem9uPOySYbda5Xucp61izC9MFJx9+z
UFvaZ6KVXEjoOK9LHkKXBCF2E1VJ6nHnos2A5eKhbtx75d0P6r43wjDX8vvBVa6u
fqvZy8fFsqZix6SZGL4FA3pm3sfHcGk3h35HdsYox8f1jvthT8Yv67y9xP4ca/ur
TYCoUae31JFuGZmdBXKGAS8ihV8QYqgsU4x4kvBfHBDJVG4QHLvMdq5eMzxD9K2t
gF952x9adjm25nxeSbZjT9IIPG/jQlE016nGEtTXJna6sFmW0Q3AhVjfL9tWQdUe
CLGOIqj6IednSDxU8Ud6TAacgoQ4Q+W3mWpGpqx8UaclIe1sSPIL9mtOkNYIC190
AmUQrMZZMTOObU7dLw6Cov1avrXULaN3cBqnkngWbKk+yBzpb7ng+JiAtib4JOuc
H87g9NsNMNBMaShicXHQWTbCLRr9v6Tvt7ahuVlfA8VcVhQ42Bj7n3+4md+jl7HG
9gGfovHn7CBLyj3eOMJgMa3oe/BUOcONm9WHGNTy+DahMppmrL56of3M0WmRL8sO
xk0kNAT8eEj6iH0QXkME2ut+VUL7yzaKI3IlOYysM37YgHqWv0aNugtEz5r+APZk
AvloZMkNAVe9wDQRypSmWGS3hnlZagfl2047iWtUqbyi8B2TBiY=
=RTd0
-----END PGP SIGNATURE-----

--gXRvC5ZMi5gtu4I8P6lKGeAW1ut7Ub9Ic--

