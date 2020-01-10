Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0850136917
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 09:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbgAJInm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 03:43:42 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4308 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727091AbgAJInm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Jan 2020 03:43:42 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00A8gFdG074854
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2020 03:43:40 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xee13cama-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2020 03:43:40 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Fri, 10 Jan 2020 08:43:38 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 10 Jan 2020 08:43:35 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00A8hYVc22216876
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jan 2020 08:43:34 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5CE1B52051;
        Fri, 10 Jan 2020 08:43:34 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.153.163])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 00E865204F;
        Fri, 10 Jan 2020 08:43:33 +0000 (GMT)
Subject: Re: [PATCH v4] KVM: s390: Add new reset vcpu API
From:   Janosch Frank <frankja@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>, Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, david@redhat.com
References: <20200109155602.18985-1-frankja@linux.ibm.com>
 <20200109180841.6843cb92.cohuck@redhat.com>
 <f79b523e-f3e8-95b8-c242-1e7ca0083012@linux.ibm.com>
 <f18955c0-4002-c494-b14e-1b9733aad20e@redhat.com>
 <c0049bfb-9516-a382-c69c-0693cb0fbfda@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Fri, 10 Jan 2020 09:43:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <c0049bfb-9516-a382-c69c-0693cb0fbfda@linux.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="D97QCypl9jX0GQ2sIsVURVgaFC620wFjf"
X-TM-AS-GCONF: 00
x-cbid: 20011008-0020-0000-0000-0000039F7F6B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20011008-0021-0000-0000-000021F6E6A0
Message-Id: <90f65536-c2bb-9234-aef4-7941d477369e@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-10_01:2020-01-10,2020-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 malwarescore=0 mlxlogscore=999 impostorscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-2001100073
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--D97QCypl9jX0GQ2sIsVURVgaFC620wFjf
Content-Type: multipart/mixed; boundary="EHOb0zA2ovju0swjOBPjhydfEIu9lPBJ5"

--EHOb0zA2ovju0swjOBPjhydfEIu9lPBJ5
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 1/10/20 8:14 AM, Janosch Frank wrote:
> On 1/10/20 8:03 AM, Thomas Huth wrote:
>> On 09/01/2020 18.51, Janosch Frank wrote:
>>> On 1/9/20 6:08 PM, Cornelia Huck wrote:
>>>> On Thu,  9 Jan 2020 10:56:01 -0500
>>>> Janosch Frank <frankja@linux.ibm.com> wrote:
>>>>
>>>>> The architecture states that we need to reset local IRQs for all CP=
U
>>>>> resets. Because the old reset interface did not support the normal =
CPU
>>>>> reset we never did that on a normal reset.
>>>>>
>>>>> Let's implement an interface for the missing normal and clear reset=
s
>>>>> and reset all local IRQs, registers and control structures as state=
d
>>>>> in the architecture.
>>>>>
>>>>> Userspace might already reset the registers via the vcpu run struct=
,
>>>>> but as we need the interface for the interrupt clearing part anyway=
,
>>>>> we implement the resets fully and don't rely on userspace to reset =
the
>>>>> rest.
>>>>>
>>>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>>>> ---
>>>>>
>>>>> I dropped the reviews, as I changed quite a lot. =20
>>>>>
>>>>> Keep in mind, that now we'll need a new parameter in normal and
>>>>> initial reset for protected virtualization to indicate that we need=
 to
>>>>> do the reset via the UV call. The Ultravisor does only accept the
>>>>> needed reset, not any subset resets.
>>>>
>>>> In the interface, or externally?
>>>
>>> ?
>>>
>>>>
>>>> [Apologies, but the details of the protected virt stuff are no longe=
r
>>>> in my cache.
>>> Reworded explanation:
>>> I can't use a fallthrough, because the UV will reject the normal rese=
t
>>> if we do an initial reset (same goes for the clear reset). To address=

>>> this issue, I added a boolean to the normal and initial reset functio=
ns
>>> which tells the function if it was called directly or was called beca=
use
>>> of the fallthrough.
>>>
>>> Only if called directly a UV call for the reset is done, that way we =
can
>>> keep the fallthrough.
>>
>> Sounds complicated. And do we need the fallthrough stuff here at all?
>> What about doing something like:
>=20
> That would work and I thought about it, it just comes down to taste :-)=

> I don't have any strong feelings for a specific implementation.

To be more specific:


Commit c72db49c098bceb8b73c2e9d305caf37a41fb3bf
Author: Janosch Frank <frankja@linux.ibm.com>
Date:   Thu Jan 9 04:37:50 2020 -0500

    KVM: s390: protvirt: Add UV cpu reset calls

    For protected VMs, the VCPU resets are done by the Ultravisor, as KVM=

    has no access to the VCPU registers.

    As the Ultravisor will only accept a call for the reset that is
    needed, we need to fence the UV calls when chaining resets.

    Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 63dc2bd97582..d5876527e464 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3476,8 +3476,11 @@ static int kvm_arch_vcpu_ioctl_set_one_reg(struct
kvm_vcpu *vcpu,
 	return r;
 }

-static int kvm_arch_vcpu_ioctl_normal_reset(struct kvm_vcpu *vcpu)
+static int kvm_arch_vcpu_ioctl_normal_reset(struct kvm_vcpu *vcpu, bool
chain)
 {
+	int rc =3D 0;
+	u32 ret;
+
 	vcpu->arch.sie_block->gpsw.mask =3D ~PSW_MASK_RI;
 	vcpu->arch.pfault_token =3D KVM_S390_PFAULT_TOKEN_INVALID;
 	memset(vcpu->run->s.regs.riccb, 0, sizeof(vcpu->run->s.regs.riccb));
@@ -3487,11 +3490,21 @@ static int
kvm_arch_vcpu_ioctl_normal_reset(struct kvm_vcpu *vcpu)
 		kvm_s390_vcpu_stop(vcpu);
 	kvm_s390_clear_local_irqs(vcpu);

-	return 0;
+	if (kvm_s390_pv_handle_cpu(vcpu) && !chain) {
+		rc =3D uv_cmd_nodata(kvm_s390_pv_handle_cpu(vcpu),
+				   UVC_CMD_CPU_RESET, &ret);
+		VCPU_EVENT(vcpu, 3, "PROTVIRT RESET NORMAL VCPU: cpu %d rc %x rrc %x",=

+			   vcpu->vcpu_id, ret >> 16, ret & 0x0000ffff);
+	}
+
+	return rc;
 }

-static int kvm_arch_vcpu_ioctl_initial_reset(struct kvm_vcpu *vcpu)
+static int kvm_arch_vcpu_ioctl_initial_reset(struct kvm_vcpu *vcpu,
bool chain)
 {
+	int rc =3D 0;
+	u32 ret;
+
 	/* this equals initial cpu reset in pop, but we don't switch to ESA */
 	vcpu->arch.sie_block->gpsw.mask =3D 0UL;
 	vcpu->arch.sie_block->gpsw.addr =3D 0UL;
@@ -3509,16 +3522,26 @@ static int
kvm_arch_vcpu_ioctl_initial_reset(struct kvm_vcpu *vcpu)
 	/* make sure the new fpc will be lazily loaded */
 	save_fpu_regs();
 	current->thread.fpu.fpc =3D 0;
-	if (!kvm_s390_pv_is_protected(vcpu->kvm))
+	if (!kvm_s390_pv_handle_cpu(vcpu))
 		vcpu->arch.sie_block->gbea =3D 1;
 	vcpu->arch.sie_block->pp =3D 0;
 	vcpu->arch.sie_block->fpf &=3D ~FPF_BPBC;

-	return 0;
+	if (kvm_s390_pv_handle_cpu(vcpu) && !chain) {
+		rc =3D uv_cmd_nodata(kvm_s390_pv_handle_cpu(vcpu),
+				   UVC_CMD_CPU_RESET_INITIAL,
+				   &ret);
+		VCPU_EVENT(vcpu, 3, "PROTVIRT RESET INITIAL VCPU: cpu %d rc %x rrc %x"=
,
+			   vcpu->vcpu_id, ret >> 16, ret & 0x0000ffff);
+	}
+
+	return rc;
 }

 static int kvm_arch_vcpu_ioctl_clear_reset(struct kvm_vcpu *vcpu)
 {
+	int rc =3D 0;
+	u32 ret;
 	struct kvm_sync_regs *regs =3D &vcpu->run->s.regs;

 	memset(&regs->gprs, 0, sizeof(regs->gprs));
@@ -3547,7 +3570,13 @@ static int kvm_arch_vcpu_ioctl_clear_reset(struct
kvm_vcpu *vcpu)
 		}
 		preempt_enable();
 	}
-	return 0;
+	if (kvm_s390_pv_handle_cpu(vcpu)) {
+		rc =3D uv_cmd_nodata(kvm_s390_pv_handle_cpu(vcpu),
+				   UVC_CMD_CPU_RESET_CLEAR, &ret);
+		VCPU_EVENT(vcpu, 3, "PROTVIRT RESET CLEAR VCPU: cpu %d rc %x rrc %x",
+			   vcpu->vcpu_id, ret >> 16, ret & 0x0000ffff);
+	}
+	return rc;
 }

 int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs
*regs)
@@ -4738,12 +4767,16 @@ long kvm_arch_vcpu_ioctl(struct file *filp,

 	case KVM_S390_CLEAR_RESET:
 		r =3D kvm_arch_vcpu_ioctl_clear_reset(vcpu);
+		if (r)
+			break;
 		/* fallthrough */
 	case KVM_S390_INITIAL_RESET:
-		r =3D kvm_arch_vcpu_ioctl_initial_reset(vcpu);
+		r =3D kvm_arch_vcpu_ioctl_initial_reset(vcpu, ioctl !=3D
KVM_S390_INITIAL_RESET);
+		if (r)
+			break;
 		/* fallthrough */
 	case KVM_S390_NORMAL_RESET:
-		r =3D kvm_arch_vcpu_ioctl_normal_reset(vcpu);
+		r =3D kvm_arch_vcpu_ioctl_normal_reset(vcpu, ioctl !=3D
KVM_S390_NORMAL_RESET);
 		break;
 	case KVM_SET_ONE_REG:
 	case KVM_GET_ONE_REG: {


--EHOb0zA2ovju0swjOBPjhydfEIu9lPBJ5--

--D97QCypl9jX0GQ2sIsVURVgaFC620wFjf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl4YOTUACgkQ41TmuOI4
ufheQw/9FCAVgY0bCvJDnCl8gAYxC57+x2KPylEv9ad9yQMosSD+Lcg462rifabO
5MrJQmIHJG5/tq/OksI8RC7LKiMI61FljzPNJ04nQ/H2EMUnsPnnKhmg4bS7Rhn9
xOeXsvR6TDa7LFCWRa9BgFJWPPbNLadhgrssRTUSEIG/ld1030dAcRSWpx5hq1to
gpb0FfJDVKcaebT6ODDGbmF9QeN5T8yrT7viheMq3GmKtg17SLH8erZM2Se5bh/R
BQuuVFwyDXhIsNiXGxhbWJYIcvTpQkjM/WxW+0Xaz5yq0dGp7RuSUAZ8kzyfaYZQ
ix6fEgXcRkIWSjFvwLHY9bZVv/QBXLGc1W8i8rqukMhS4KqvuO4EljIMYA7M+UFd
ZGVQTscDySBBpBc2UBSKOO8sgdp20jYR1Uw24ZRprOFecsJV29E0Hc+LdTbDzaZg
7sPF9WwvnyNdDOMCSjx2BOsSgNPbOvTA6N9ZFELL8CRHNBldcCTq9EQGXDmmRr8G
fLEDWiAWMJBBXAESnSZxkdfuKaOdUY0tBvqhOtiHr7qJ5cIaimpq7NQtUIp4fDAE
/QZgfFVzHMhO8KQ55dSepFZ78dzc4XuCo03lZ7mpsDhoGzAPa0fsnopXZrtO12Sk
rAwf8NCZIpQLPbetp6v3yhQSVTh5O5Z8T8nPK2y6QxKIwx0n8NM=
=4tjx
-----END PGP SIGNATURE-----

--D97QCypl9jX0GQ2sIsVURVgaFC620wFjf--

