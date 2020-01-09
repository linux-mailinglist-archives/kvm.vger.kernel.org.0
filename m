Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01CD3135FB5
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 18:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388353AbgAIRv1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 12:51:27 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20946 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731911AbgAIRv0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jan 2020 12:51:26 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 009HlrhS144336
        for <kvm@vger.kernel.org>; Thu, 9 Jan 2020 12:51:25 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xe7quju3f-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 12:51:25 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 9 Jan 2020 17:51:23 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 9 Jan 2020 17:51:20 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 009HpJ5a16384054
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Jan 2020 17:51:19 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7EB6BA4065;
        Thu,  9 Jan 2020 17:51:19 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 01D58A4057;
        Thu,  9 Jan 2020 17:51:19 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.166.75])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Jan 2020 17:51:18 +0000 (GMT)
Subject: Re: [PATCH v4] KVM: s390: Add new reset vcpu API
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, david@redhat.com
References: <20200109155602.18985-1-frankja@linux.ibm.com>
 <20200109180841.6843cb92.cohuck@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Thu, 9 Jan 2020 18:51:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200109180841.6843cb92.cohuck@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8jBGlaw2qxmqwKHASssfIF6BKVulnU4Mk"
X-TM-AS-GCONF: 00
x-cbid: 20010917-0028-0000-0000-000003CFBAC2
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20010917-0029-0000-0000-00002493D130
Message-Id: <f79b523e-f3e8-95b8-c242-1e7ca0083012@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-09_03:2020-01-09,2020-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 mlxlogscore=999 phishscore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001090146
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8jBGlaw2qxmqwKHASssfIF6BKVulnU4Mk
Content-Type: multipart/mixed; boundary="XWVmLUsfnl9x0LO90BCakHrQ85T3IBgwg"

--XWVmLUsfnl9x0LO90BCakHrQ85T3IBgwg
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 1/9/20 6:08 PM, Cornelia Huck wrote:
> On Thu,  9 Jan 2020 10:56:01 -0500
> Janosch Frank <frankja@linux.ibm.com> wrote:
>=20
>> The architecture states that we need to reset local IRQs for all CPU
>> resets. Because the old reset interface did not support the normal CPU=

>> reset we never did that on a normal reset.
>>
>> Let's implement an interface for the missing normal and clear resets
>> and reset all local IRQs, registers and control structures as stated
>> in the architecture.
>>
>> Userspace might already reset the registers via the vcpu run struct,
>> but as we need the interface for the interrupt clearing part anyway,
>> we implement the resets fully and don't rely on userspace to reset the=

>> rest.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>
>> I dropped the reviews, as I changed quite a lot. =20
>>
>> Keep in mind, that now we'll need a new parameter in normal and
>> initial reset for protected virtualization to indicate that we need to=

>> do the reset via the UV call. The Ultravisor does only accept the
>> needed reset, not any subset resets.
>=20
> In the interface, or externally?

?

>=20
> [Apologies, but the details of the protected virt stuff are no longer
> in my cache.
Reworded explanation:
I can't use a fallthrough, because the UV will reject the normal reset
if we do an initial reset (same goes for the clear reset). To address
this issue, I added a boolean to the normal and initial reset functions
which tells the function if it was called directly or was called because
of the fallthrough.

Only if called directly a UV call for the reset is done, that way we can
keep the fallthrough.

>>  static int kvm_arch_vcpu_ioctl_initial_reset(struct kvm_vcpu *vcpu)
>>  {
>> -	kvm_s390_vcpu_initial_reset(vcpu);
>> +	/* this equals initial cpu reset in pop, but we don't switch to ESA =
*/
>=20
> Maybe also mention that in the documentation?

Sure

>=20
>> +	vcpu->arch.sie_block->gpsw.mask =3D 0UL;
>> +	vcpu->arch.sie_block->gpsw.addr =3D 0UL;
>> +	kvm_s390_set_prefix(vcpu, 0);
>> +	kvm_s390_set_cpu_timer(vcpu, 0);
>> +	vcpu->arch.sie_block->ckc       =3D 0UL;
>> +	vcpu->arch.sie_block->todpr     =3D 0;
>> +	memset(vcpu->arch.sie_block->gcr, 0, 16 * sizeof(__u64));
>> +	vcpu->arch.sie_block->gcr[0]  =3D CR0_UNUSED_56 |
>> +					CR0_INTERRUPT_KEY_SUBMASK |
>> +					CR0_MEASUREMENT_ALERT_SUBMASK;
>> +	vcpu->arch.sie_block->gcr[14] =3D CR14_UNUSED_32 |
>> +					CR14_UNUSED_33 |
>> +					CR14_EXTERNAL_DAMAGE_SUBMASK;
>> +	/* make sure the new fpc will be lazily loaded */
>> +	save_fpu_regs();
>> +	current->thread.fpu.fpc =3D 0;
>> +	vcpu->arch.sie_block->gbea =3D 1;
>> +	vcpu->arch.sie_block->pp =3D 0;
>> +	vcpu->arch.sie_block->fpf &=3D ~FPF_BPBC;
>> +
>=20
> Add a comment that the remaining work will be done in normal_reset?

Will do

>=20
>> +	return 0;
>> +}
>> +
>> +static int kvm_arch_vcpu_ioctl_clear_reset(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm_sync_regs *regs =3D &vcpu->run->s.regs;
>> +
>> +	memset(&regs->gprs, 0, sizeof(regs->gprs));
>> +	/*
>> +	 * Will be picked up via save_fpu_regs() in the initial reset
>> +	 * fallthrough.
>> +	 */
>=20
> This comment is a bit confusing... what does 'picked up' mean?
>=20
> (Maybe I'm just too tired, sorry...)

fpus are loaded lazily, maybe I should just remove the comment.

>=20
>> +	memset(&regs->vrs, 0, sizeof(regs->vrs));
>> +	memset(&regs->acrs, 0, sizeof(regs->acrs));
>> +
>> +	regs->etoken =3D 0;
>> +	regs->etoken_extension =3D 0;
>> +
>> +	memset(&regs->gscb, 0, sizeof(regs->gscb));
>> +	if (MACHINE_HAS_GS) {
>> +		preempt_disable();
>> +		__ctl_set_bit(2, 4);
>> +		if (current->thread.gs_cb) {
>> +			vcpu->arch.host_gscb =3D current->thread.gs_cb;
>> +			save_gs_cb(vcpu->arch.host_gscb);
>> +		}
>> +		if (vcpu->arch.gs_enabled) {
>> +			current->thread.gs_cb =3D (struct gs_cb *)
>> +				&vcpu->run->s.regs.gscb;
>> +			restore_gs_cb(current->thread.gs_cb);
>> +		}
>> +		preempt_enable();
>> +	}
>=20
> And here that the remaining work will be done in initial_reset and
> normal_reset?
>=20
>>  	return 0;
>>  }
>> =20
>> @@ -4363,8 +4402,15 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>>  		r =3D kvm_arch_vcpu_ioctl_set_initial_psw(vcpu, psw);
>>  		break;
>>  	}
>> +
>> +	case KVM_S390_CLEAR_RESET:
>> +		r =3D kvm_arch_vcpu_ioctl_clear_reset(vcpu);
>> +		/* fallthrough */
>>  	case KVM_S390_INITIAL_RESET:
>>  		r =3D kvm_arch_vcpu_ioctl_initial_reset(vcpu);
>> +		/* fallthrough */
>> +	case KVM_S390_NORMAL_RESET:
>> +		r =3D kvm_arch_vcpu_ioctl_normal_reset(vcpu);
>=20
> Can any of these functions return !0 when the protected virt stuff is
> done on top? If not, can we make them void and just set r=3D0; here?

They do return > 0 if the UV call fails, so I need those r values.

>=20
>>  		break;
>>  	case KVM_SET_ONE_REG:
>>  	case KVM_GET_ONE_REG: {
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index f0a16b4adbbd..4b95f9a31a2f 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1009,6 +1009,7 @@ struct kvm_ppc_resize_hpt {
>>  #define KVM_CAP_PPC_GUEST_DEBUG_SSTEP 176
>>  #define KVM_CAP_ARM_NISV_TO_USER 177
>>  #define KVM_CAP_ARM_INJECT_EXT_DABT 178
>> +#define KVM_CAP_S390_VCPU_RESETS 179
>> =20
>>  #ifdef KVM_CAP_IRQ_ROUTING
>> =20
>> @@ -1473,6 +1474,10 @@ struct kvm_enc_region {
>>  /* Available with KVM_CAP_ARM_SVE */
>>  #define KVM_ARM_VCPU_FINALIZE	  _IOW(KVMIO,  0xc2, int)
>> =20
>> +/* Available with  KVM_CAP_S390_VCPU_RESETS */
>> +#define KVM_S390_NORMAL_RESET	_IO(KVMIO,   0xc3)
>> +#define KVM_S390_CLEAR_RESET	_IO(KVMIO,   0xc4)
>> +
>>  /* Secure Encrypted Virtualization command */
>>  enum sev_cmd_id {
>>  	/* Guest initialization commands */
>=20



--XWVmLUsfnl9x0LO90BCakHrQ85T3IBgwg--

--8jBGlaw2qxmqwKHASssfIF6BKVulnU4Mk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl4XaBYACgkQ41TmuOI4
ufhyRhAAwwVRSPsmNKeccMjeZ+1nivugQ9toHea9XHpURuscVFokCxdDaWgqQrjE
UPPQsaly7xd7u3jLLW60zK2jKx415JkfDgWpMNS4uTRyUCV6f7tkmqgslSw1tOlF
eX3leOJ1VaXGuhjvrFim0mcLTZ3cAlZ/jFMHFMS6iEAYx/OI6Yb6hPqBVsxiXmvO
BHd6QEfgo4dCBoTzl/+DVglEX/nSifHBHE4FjM/IOXQnRgKhER07A3oM5EidKb79
b49M23d7/6bRoCnqwIXjJo1XSBC7eMr3AJkfUKehyiSE0pTovYoiJ/8slihfnnd2
dlw3x2vOQQE5BGIjXIGoXfjz9AwUouap7J21YAh5P19Xp4nlL3nfIhPJJ+naA59D
T3jqWCELUKcjo6hfGOjrxmu/7mmbQrHNncfPqwe+s26pEy2AgetrclBsFSJXS1c3
bG7VRYWBHLiueI1RPQgraxw5iF8Y35DnLyAK4jLEhRwAZRCxGtaKiKrqKjHOA/bR
5xcCXuRTbR0liRTbLpFZEyd0ZA95/bYxNRJ8obIAKFIbmqDr41IFrQRBgXsbl8u3
tXuNnFLoSpA3SlydWnvFnZy5ONR+D+yK7nBQ6By4pc0f/brC7EZGPGMsrEhPreFZ
NI3hsOflfcVjS766wYaj8pMyNBc2BNknIDm7rEWjz2gBtbM/tZo=
=/JuM
-----END PGP SIGNATURE-----

--8jBGlaw2qxmqwKHASssfIF6BKVulnU4Mk--

