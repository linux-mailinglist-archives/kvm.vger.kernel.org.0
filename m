Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 222726AC6A
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 18:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728390AbfGPQBu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 12:01:50 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55374 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbfGPQBu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 12:01:50 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GFxZO1085045;
        Tue, 16 Jul 2019 16:01:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=uKIkFxlLm8glvljnTJmyvsEL7rCOF3MPqqkXKdZoG8c=;
 b=ec13nEa5rnfeL3HMGnVJgSFV69ut3Z0Ji9iwaJiVaqZ7UohV/95dW1TEBlqXl7rhA5gN
 Bo3Ef9uG4qiXT6e9uyA3ZZDDHgI/BABXZK/Eq6bIx8gC3pfkhO1tvSsDC4CciMIv8DwV
 nQRaZSdORo5UixIVqPNy/y2KhrZaryUH+fZQ7sMz4dpS/myVWU3mc03kKWV1m2tLPzzW
 bvBMBNAZYQhNaY512N4WbBd30yXILeJ/EoeJNWJxsnsRETnwTQhPbcXCnAmu2o7F8QSn
 M1NK/Pe9ZD25vQmroqy+xsBGnvreyHKODAYjLPehrsVWKW4bfyzp2tZSjS270A8xPp1n Mw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2tq78pnes7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 16:01:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GFvcQ6022478;
        Tue, 16 Jul 2019 16:01:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2tq5bcgek6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 16:01:35 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6GG1YfK005819;
        Tue, 16 Jul 2019 16:01:34 GMT
Received: from [10.30.3.6] (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 16 Jul 2019 16:01:34 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH 2/2] KVM: x86: Rename need_emulation_on_page_fault() to
 handle_no_insn_on_page_fault()
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20190716154855.GA1987@linux.intel.com>
Date:   Tue, 16 Jul 2019 19:01:30 +0300
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org,
        brijesh.singh@amd.com, Boris Ostrovsky <boris.ostrovsky@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <ECF661D3-A0F0-4F55-A7E5-CE6E204947D1@oracle.com>
References: <20190715203043.100483-1-liran.alon@oracle.com>
 <20190715203043.100483-3-liran.alon@oracle.com>
 <20190716154855.GA1987@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907160196
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907160197
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 16 Jul 2019, at 18:48, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> On Mon, Jul 15, 2019 at 11:30:43PM +0300, Liran Alon wrote:
>> I think this name is more appropriate to what the x86_ops method =
does.
>> In addition, modify VMX callback to return true as #PF handler can
>> proceed to emulation in this case. This didn't result in a bug
>> only because the callback is called when DecodeAssist is supported
>> which is currently supported only on SVM.
>>=20
>> Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>> Signed-off-by: Liran Alon <liran.alon@oracle.com>
>> ---
>> arch/x86/include/asm/kvm_host.h | 3 ++-
>> arch/x86/kvm/mmu.c              | 2 +-
>> arch/x86/kvm/svm.c              | 4 ++--
>> arch/x86/kvm/vmx/vmx.c          | 6 +++---
>> 4 files changed, 8 insertions(+), 7 deletions(-)
>>=20
>> diff --git a/arch/x86/include/asm/kvm_host.h =
b/arch/x86/include/asm/kvm_host.h
>> index 450d69a1e6fa..536fd56f777d 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1201,7 +1201,8 @@ struct kvm_x86_ops {
>> 				   uint16_t *vmcs_version);
>> 	uint16_t (*nested_get_evmcs_version)(struct kvm_vcpu *vcpu);
>>=20
>> -	bool (*need_emulation_on_page_fault)(struct kvm_vcpu *vcpu);
>> +	/* Returns true if #PF handler can proceed to emulation */
>> +	bool (*handle_no_insn_on_page_fault)(struct kvm_vcpu *vcpu);
>=20
> The problem with this name is that it requires a comment to explain =
the
> boolean return value.  The VMX implementation particular would be
> inscrutuable.

True.

>=20
> "no insn" is also a misnomer, as the AMD quirk has an insn, it's the
> insn_len that's missing.

This could in theory also happen for VMX if it ever implements =
DecodeAssist style feature.
So this name is still kinda makes sense in the generic x86 level.

>=20
> What about something like force_emulation_on_zero_len_insn()?

I have no objection to such name besides the fact that it seems to state =
that the callback have read-only boolean semantic.
Which is not true as the SVM implementation could also for example, =
trigger a triple-fault and change vCPU state.
This is why I renamed to handle_*...

>=20
>> };
>>=20
>> struct kvm_arch_async_pf {
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index 1e9ba81accba..889de3ccf655 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -5423,7 +5423,7 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, =
gva_t cr2, u64 error_code,
>> 	 * guest, with the exception of AMD Erratum 1096 which is =
unrecoverable.
>> 	 */
>> 	if (unlikely(insn && !insn_len)) {
>> -		if (!kvm_x86_ops->need_emulation_on_page_fault(vcpu))
>> +		if (!kvm_x86_ops->handle_no_insn_on_page_fault(vcpu))
>> 			return 1;
>> 	}
>>=20
>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>> index 79023a41f7a7..ab89bb0de8df 100644
>> --- a/arch/x86/kvm/svm.c
>> +++ b/arch/x86/kvm/svm.c
>> @@ -7118,7 +7118,7 @@ static int nested_enable_evmcs(struct kvm_vcpu =
*vcpu,
>> 	return -ENODEV;
>> }
>>=20
>> -static bool svm_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
>> +static bool svm_handle_no_insn_on_page_fault(struct kvm_vcpu *vcpu)
>> {
>> 	bool is_user, smap;
>>=20
>> @@ -7291,7 +7291,7 @@ static struct kvm_x86_ops svm_x86_ops =
__ro_after_init =3D {
>> 	.nested_enable_evmcs =3D nested_enable_evmcs,
>> 	.nested_get_evmcs_version =3D nested_get_evmcs_version,
>>=20
>> -	.need_emulation_on_page_fault =3D =
svm_need_emulation_on_page_fault,
>> +	.handle_no_insn_on_page_fault =3D =
svm_handle_no_insn_on_page_fault,
>> };
>>=20
>> static int __init svm_init(void)
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index f64bcbb03906..088fc6d943e9 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -7419,9 +7419,9 @@ static int enable_smi_window(struct kvm_vcpu =
*vcpu)
>> 	return 0;
>> }
>>=20
>> -static bool vmx_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
>> +static bool vmx_handle_no_insn_on_page_fault(struct kvm_vcpu *vcpu)
>> {
>> -	return 0;
>> +	return true;
>=20
> Any functional change here should be done in a different patch.

I originally done so and don=E2=80=99t regretted as it depends on what =
is the semantic definition of the boolean return value.
That=E2=80=99s why I preferred to do so in same patch. But I don=E2=80=99t=
 have strong objection for separating it out to a different patch.

>=20
> Given that we should never reach this point on VMX, a WARN and triple
> fault request seems in order.
>=20
> 	WARN_ON_ONCE(1);

I agree we should add here such a WARN_ON(). Makes sense.

>=20
> 	kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
> 	return false;

I don=E2=80=99t think we should triple-fault and return =E2=80=9Cfalse=E2=80=
=9D. As from a semantic perspective, we should return true.

But this commit is getting really philosophical :)
Maybe let=E2=80=99s hear Paolo=E2=80=99s preference first before doing =
any change.

-Liran

>=20
>> }
>>=20
>> static __init int hardware_setup(void)
>> @@ -7726,7 +7726,7 @@ static struct kvm_x86_ops vmx_x86_ops =
__ro_after_init =3D {
>> 	.set_nested_state =3D NULL,
>> 	.get_vmcs12_pages =3D NULL,
>> 	.nested_enable_evmcs =3D NULL,
>> -	.need_emulation_on_page_fault =3D =
vmx_need_emulation_on_page_fault,
>> +	.handle_no_insn_on_page_fault =3D =
vmx_handle_no_insn_on_page_fault,
>> };
>>=20
>> static void vmx_cleanup_l1d_flush(void)
>> --=20
>> 2.20.1
>>=20

