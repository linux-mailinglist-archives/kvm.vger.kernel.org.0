Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F08F1128D8
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 11:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbfLDKG1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 05:06:27 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:63922 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727331AbfLDKG1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Dec 2019 05:06:27 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB4A38Ao189530
        for <kvm@vger.kernel.org>; Wed, 4 Dec 2019 05:06:26 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2wnp8spg4h-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2019 05:06:25 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Wed, 4 Dec 2019 10:06:24 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 4 Dec 2019 10:06:22 -0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xB4A6Ka143975018
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 Dec 2019 10:06:20 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 810B242047;
        Wed,  4 Dec 2019 10:06:20 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4301042045;
        Wed,  4 Dec 2019 10:06:20 +0000 (GMT)
Received: from dyn-9-152-224-146.boeblingen.de.ibm.com (unknown [9.152.224.146])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  4 Dec 2019 10:06:20 +0000 (GMT)
Subject: Re: [PATCH v2] KVM: s390: Add new reset vcpu API
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, borntraeger@de.ibm.com, mihajlov@linux.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20191203162055.3519-1-frankja@linux.ibm.com>
 <c22eefd7-2c99-ec8e-3b5c-fabb343230a9@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 mQINBFubpD4BEADX0uhkRhkj2AVn7kI4IuPY3A8xKat0ihuPDXbynUC77mNox7yvK3X5QBO6
 qLqYr+qrG3buymJJRD9xkp4mqgasHdB5WR9MhXWKH08EvtvAMkEJLnqxgbqf8td3pCQ2cEpv
 15mH49iKSmlTcJ+PvJpGZcq/jE42u9/0YFHhozm8GfQdb9SOI/wBSsOqcXcLTUeAvbdqSBZe
 zuMRBivJQQI1esD9HuADmxdE7c4AeMlap9MvxvUtWk4ZJ/1Z3swMVCGzZb2Xg/9jZpLsyQzb
 lDbbTlEeyBACeED7DYLZI3d0SFKeJZ1SUyMmSOcr9zeSh4S4h4w8xgDDGmeDVygBQZa1HaoL
 Esb8Y4avOYIgYDhgkCh0nol7XQ5i/yKLtnNThubAcxNyryw1xSstnKlxPRoxtqTsxMAiSekk
 0m3WJwvwd1s878HrQNK0orWd8BzzlSswzjNfQYLF466JOjHPWFOok9pzRs+ucrs6MUwDJj0S
 cITWU9Rxb04XyigY4XmZ8dywaxwi2ZVTEg+MD+sPmRrTw+5F+sU83cUstuymF3w1GmyofgsU
 Z+/ldjToHnq21MNa1wx0lCEipCCyE/8K9B9bg9pUwy5lfx7yORP3JuAUfCYb8DVSHWBPHKNj
 HTOLb2g2UT65AjZEQE95U2AY9iYm5usMqaWD39pAHfhC09/7NQARAQABtCVKYW5vc2NoIEZy
 YW5rIDxmcmFua2phQGxpbnV4LmlibS5jb20+iQI3BBMBCAAhBQJbm6Q+AhsjBQsJCAcCBhUI
 CQoLAgQWAgMBAh4BAheAAAoJEONU5rjiOLn4p9gQALjkdj5euJVI2nNT3/IAxAhQSmRhPEt0
 AmnCYnuTcHRWPujNr5kqgtyER9+EMQ0ZkX44JU2q7OWxTdSNSAN/5Z7qmOR9JySvDOf4d3mS
 bMB5zxL9d8SbnSs1uW96H9ZBTlTQnmLfsiM9TetAjSrR8nUmjGhe2YUhJLR1v1LguME+YseT
 eXnLzIzqqpu311/eYiiIGcmaOjPCE+vFjcXL5oLnGUE73qSYiujwhfPCCUK0850o1fUAYq5p
 CNBCoKT4OddZR+0itKc/cT6NwEDwdokeg0+rAhxb4Rv5oFO70lziBplEjOxu3dqgIKbHbjza
 EXTb+mr7VI9O4tTdqrwJo2q9zLqqOfDBi7NDvZFLzaCewhbdEpDYVu6/WxprAY94hY3F4trT
 rQMHJKQENtF6ZTQc9fcT5I3gAmP+OEvDE5hcTALpWm6Z6SzxO7gEYCnF+qGXqp8sJVrweMub
 UscyLqHoqdZC2UG4LQ1OJ97nzDpIRe0g6oJ9ZIYHKmfw5jjwH6rASTld5MFWajWdNsqK15k/
 RZnHAGICKVIBOBsq26m4EsBlfCdt3b/6emuBjUXR1pyjHMz2awWzCq6/6OWs5eANZ0sdosNq
 dq2v0ULYTazJz2rlCXV89qRa7ukkNwdBSZNEwsD4eEMicj1LSrqWDZMAALw50L4jxaMD7lPL
 jJbauQINBFubpD4BEADAcUTRqXF/aY53OSH7IwIK9lFKxIm0IoFkOEh7LMfp7FGzaP7ANrZd
 cIzhZi38xyOkcaFY+npGEWvko7rlIAn0JpBO4x3hfhmhBD/WSY8LQIFQNNjEm3vzrMo7b9Jb
 JAqQxfbURY3Dql3GUzeWTG9uaJ00u+EEPlY8zcVShDltIl5PLih20e8xgTnNzx5c110lQSu0
 iZv2lAE6DM+2bJQTsMSYiwKlwTuv9LI9Chnoo6+tsN55NqyMxYqJgElk3VzlTXSr3+rtSCwf
 tq2cinETbzxc1XuhIX6pu/aCGnNfuEkM34b7G1D6CPzDMqokNFbyoO6DQ1+fW6c5gctXg/lZ
 602iEl4C4rgcr3+EpfoPUWzKeM8JXv5Kpq4YDxhvbitr8Dm8gr38+UKFZKlWLlwhQ56r/zAU
 v6LIsm11GmFs2/cmgD1bqBTNHHcTWwWtRTLgmnqJbVisMJuYJt4KNPqphTWsPY8SEtbufIlY
 HXOJ2lqUzOReTrie2u0qcSvGAbSfec9apTFl2Xko/ddqPcZMpKhBiXmY8tJzSPk3+G4tqur4
 6TYAm5ouitJsgAR61Cu7s+PNuq/pTLDhK+6/Njmc94NGBcRA4qTuysEGE79vYWP2oIAU4Fv6
 gqaWHZ4MEI2XTqH8wiwzPdCQPYsSE0fXWiYu7ObeErT6iLSTZGx4rQARAQABiQIfBBgBCAAJ
 BQJbm6Q+AhsMAAoJEONU5rjiOLn4DDEP/RuyckW65SZcPG4cMfNgWxZF8rVjeVl/9PBfy01K
 8R0hajU40bWtXSMiby7j0/dMjz99jN6L+AJHJvrLz4qYRzn2Ys843W+RfXj62Zde4YNBE5SL
 jJweRCbMWKaJLj6499fctxTyeb9+AMLQS4yRSwHuAZLmAb5AyCW1gBcTWZb8ON5BmWnRqeGm
 IgC1EvCnHy++aBnHTn0m+zV89BhTLTUal35tcjUFwluBY39R2ux/HNlBO1GY3Z+WYXhBvq7q
 katThLjaQSmnOrMhzqYmdShP1leFTVbzXUUIYv/GbynO/YrL2gaQpaP1bEUEi8lUAfXJbEWG
 dnHFkciryi092E8/9j89DJg4mmZqOau7TtUxjRMlBcIliXkzSLUk+QvD4LK1kWievJse4mte
 FBdkWHfP4BH/+8DxapRcG1UAheSnSRQ5LiO50annOB7oXF+vgKIaie2TBfZxQNGAs3RQ+bga
 DchCqFm5adiSP5+OT4NjkKUeGpBe/aRyQSle/RropTgCi85pje/juYEn2P9UAgkfBJrOHvQ9
 Z+2Sva8FRd61NJLkCJ4LFumRn9wQlX2icFbi8UDV3do0hXJRRYTWCxrHscMhkrFWLhYiPF4i
 phX7UNdOWBQ90qpHyAxHmDazdo27gEjfvsgYMdveKknEOTEb5phwxWgg7BcIDoJf9UMC
Date:   Wed, 4 Dec 2019 11:06:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <c22eefd7-2c99-ec8e-3b5c-fabb343230a9@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ExzxFqnbt3eXJ62bVySFXO6EKLyH0uwqt"
X-TM-AS-GCONF: 00
x-cbid: 19120410-0008-0000-0000-0000033CE216
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19120410-0009-0000-0000-00004A5C00C4
Message-Id: <26845508-9a35-7ec6-fc01-49ab4b7e3473@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-04_03:2019-12-04,2019-12-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=3 clxscore=1015 impostorscore=0 bulkscore=0 adultscore=0
 spamscore=0 phishscore=0 mlxscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912040078
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ExzxFqnbt3eXJ62bVySFXO6EKLyH0uwqt
Content-Type: multipart/mixed; boundary="GPdkDX2PbElgakyMyjFk2AgB9GNHvM5TW"

--GPdkDX2PbElgakyMyjFk2AgB9GNHvM5TW
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 12/4/19 10:32 AM, Thomas Huth wrote:
> On 03/12/2019 17.20, Janosch Frank wrote:
>> The architecture states that we need to reset local IRQs for all CPU
>> resets. Because the old reset interface did not support the normal CPU=

>> reset we never did that.
>>
>> Now that we have a new interface, let's properly clear out local IRQs
>> and let this commit be a reminder.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  arch/s390/kvm/kvm-s390.c | 13 +++++++++++++
>>  include/uapi/linux/kvm.h |  4 ++++
>>  2 files changed, 17 insertions(+)
>>
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index d9e6bf3d54f0..602214c5616c 100644
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
>> @@ -3287,6 +3288,13 @@ static int kvm_arch_vcpu_ioctl_set_one_reg(stru=
ct kvm_vcpu *vcpu,
>>  	return r;
>>  }
>> =20
>> +static int kvm_arch_vcpu_ioctl_normal_reset(struct kvm_vcpu *vcpu)
>> +{
>> +	kvm_clear_async_pf_completion_queue(vcpu);
>> +	kvm_s390_clear_local_irqs(vcpu);
>> +	return 0;
>> +}
>> +
>>  static int kvm_arch_vcpu_ioctl_initial_reset(struct kvm_vcpu *vcpu)
>>  {
>>  	kvm_s390_vcpu_initial_reset(vcpu);
>> @@ -4363,7 +4371,12 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>>  		r =3D kvm_arch_vcpu_ioctl_set_initial_psw(vcpu, psw);
>>  		break;
>>  	}
>> +	case KVM_S390_NORMAL_RESET:
>> +		r =3D kvm_arch_vcpu_ioctl_normal_reset(vcpu);
>> +		break;
>>  	case KVM_S390_INITIAL_RESET:
>> +		/* fallthrough */
>> +	case KVM_S390_CLEAR_RESET:
>>  		r =3D kvm_arch_vcpu_ioctl_initial_reset(vcpu);
>>  		break;
>=20
> Isn't clear reset supposed to do more than the initial reset? If so, I'=
d
> rather expect it the other way round:

In the PV patch I remove the fallthrough and add a function for the
clear reset. I add the UV reset calls into the
kvm_arch_vcpu_ioctl_*_reset() functions, therefore I can't fallthrough
because the Ultravisor does currently not allow staged resets (i.e.
first initial then clear if a clear reset is needed)

>=20
> 	case KVM_S390_CLEAR_RESET:
> 		/* fallthrough */
> 	case KVM_S390_INITIAL_RESET:
> 		r =3D kvm_arch_vcpu_ioctl_initial_reset(vcpu);
> 		break;
>=20
> ... so you can later add the additional stuff before the "/* fallthroug=
h
> */"?
>=20
>  Thomas
>=20



--GPdkDX2PbElgakyMyjFk2AgB9GNHvM5TW--

--ExzxFqnbt3eXJ62bVySFXO6EKLyH0uwqt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl3nhRsACgkQ41TmuOI4
ufgFkRAAwNIEGdeEBZGd8XPkNrABROS1n6A8Al2gsi/gXIU94pLgh+VX0JhTByuL
m3uKbABDr9i2L8rfcKVW2EwXcMGBHtCnGS/fHyvjgNnTvbGFyBNOcYNi5QrQv9iy
2zxPgPFdUr9QO0EdjAf5j6M4LQwZm3SLz5dVD6zvaACGSYg4zFuDDEg9HLtq2D6Z
e5hbAijwfCkdBjiZNLtMC6hMtJn1srO0w/IbGTjCBt1ItkrYXNrR64ZmP0Bsfj6w
N42ohiBD1VCJ9KV42/P7I0b+uO38Db+7fUAp8wqJiMGUrEK9eZdYbXbLiRoYEteK
HbsDAmmoKgZaP7y2RhxQYKHdN0XyBHy/afUhANsDEWBaHJ6IOG64EosCdmiShw6J
qPzMAA0F4W2tEwEmpQj/hVR5ruXhGVZxRMSvvoUGn+PZBzHnoJjRDsAuZwO7Qro0
ss0FEHb9RCuth55nlMPIoUvoNRwhXO38QUjZrjmJ3Z+Yy6JWJO06Tz3JqAln8G25
tY3aV9p98uN+9kXTyFZd4BOSQpdWQMmRsytAGfucIkU0yI+iaqvY2yMwQchsawmq
9pj5j3+rOp1iUJKJq5CpQubPwDdadMiPJek/nvvvSM6Ai4VftYlFM1osRzk6ApgQ
D/xavQBZRFf9P3Taiiqrd5Izcqjrx5jWHoYc15ARl9XEkN8VZko=
=uT3n
-----END PGP SIGNATURE-----

--ExzxFqnbt3eXJ62bVySFXO6EKLyH0uwqt--

