Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 556CC50EEF
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2019 16:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727957AbfFXOq1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jun 2019 10:46:27 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57122 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbfFXOq1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jun 2019 10:46:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5OEiVPE045787;
        Mon, 24 Jun 2019 14:46:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=iB5cj4fpTcntIV4pZwjDCBLm8ALadUuqm4GFDpVE4x4=;
 b=IXdzHnBqXpK5+fDxqAgGcRjipq1ESU8y4RjCwVCxcwik4QZb9C+JJUAqv7EZqamp3CBY
 iAriJYBW6miibNDbvlnptfra6tVbFxqSNxdB0barlz53Aunw3FTXKJXD+Mq3GLI78s49
 L8y5V3J4iFXrV+xuyvxqt8oOOqGLOZBFdTo0BmRtZmNbhiC+vOML5B6m7VQJYaWMFoF5
 MUQRNGQo5PDaEFuS1i9A+aPQF5fz0LFVWtBMHx4H2Ch3wGC5s34jK+SBjb9iH0K5oAr+
 PXwh42TJKVVYKD7AM/QzWXY2aa8l4GO9bg6ozctfNnxAQCQSxr0BxHRKSBgaAzzk9f3E jA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2t9cyq6tjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jun 2019 14:46:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5OEjM2f072712;
        Mon, 24 Jun 2019 14:46:04 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2tat7bp6d6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jun 2019 14:46:03 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5OEk3tF002641;
        Mon, 24 Jun 2019 14:46:03 GMT
Received: from [10.30.3.10] (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Jun 2019 07:46:02 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] x86/kvm/nVMCS: fix VMCLEAR when Enlightened VMCS is in
 use
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <87r27jdq68.fsf@vitty.brq.redhat.com>
Date:   Mon, 24 Jun 2019 17:45:59 +0300
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <69274969-E2BE-442C-B2D2-0AF94338C31B@oracle.com>
References: <20190624133028.3710-1-vkuznets@redhat.com>
 <CEFF2A14-611A-417C-BC0A-8814862F26C6@oracle.com>
 <87r27jdq68.fsf@vitty.brq.redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906240120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906240120
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 24 Jun 2019, at 17:16, Vitaly Kuznetsov <vkuznets@redhat.com> =
wrote:
>=20
> Liran Alon <liran.alon@oracle.com> writes:
>=20
>>> On 24 Jun 2019, at 16:30, Vitaly Kuznetsov <vkuznets@redhat.com> =
wrote:
>>>=20
>>> When Enlightened VMCS is in use, it is valid to do VMCLEAR and,
>>> according to TLFS, this should "transition an enlightened VMCS from =
the
>>> active to the non-active state". It is, however, wrong to assume =
that
>>> it is only valid to do VMCLEAR for the eVMCS which is currently =
active
>>> on the vCPU performing VMCLEAR.
>>>=20
>>> Currently, the logic in handle_vmclear() is broken: in case, there =
is no
>>> active eVMCS on the vCPU doing VMCLEAR we treat the argument as a =
'normal'
>>> VMCS and kvm_vcpu_write_guest() to the 'launch_state' field =
irreversibly
>>> corrupts the memory area.
>>>=20
>>> So, in case the VMCLEAR argument is not the current active eVMCS on =
the
>>> vCPU, how can we know if the area it is pointing to is a normal or =
an
>>> enlightened VMCS?
>>> Thanks to the bug in Hyper-V (see commit 72aeb60c52bf7 ("KVM: nVMX: =
Verify
>>> eVMCS revision id match supported eVMCS version on eVMCS VMPTRLD")) =
we can
>>> not, the revision can't be used to distinguish between them. So =
let's
>>> assume it is always enlightened in case enlightened vmentry is =
enabled in
>>> the assist page. Also, check if vmx->nested.enlightened_vmcs_enabled =
to
>>> minimize the impact for 'unenlightened' workloads.
>>>=20
>>> Fixes: b8bbab928fb1 ("KVM: nVMX: implement enlightened VMPTRLD and =
VMCLEAR")
>>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>>> ---
>>> arch/x86/kvm/vmx/evmcs.c  | 18 ++++++++++++++++++
>>> arch/x86/kvm/vmx/evmcs.h  |  1 +
>>> arch/x86/kvm/vmx/nested.c | 19 ++++++++-----------
>>> 3 files changed, 27 insertions(+), 11 deletions(-)
>>>=20
>>> diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
>>> index 1a6b3e1581aa..eae636ec0cc8 100644
>>> --- a/arch/x86/kvm/vmx/evmcs.c
>>> +++ b/arch/x86/kvm/vmx/evmcs.c
>>> @@ -3,6 +3,7 @@
>>> #include <linux/errno.h>
>>> #include <linux/smp.h>
>>>=20
>>> +#include "../hyperv.h"
>>> #include "evmcs.h"
>>> #include "vmcs.h"
>>> #include "vmx.h"
>>> @@ -309,6 +310,23 @@ void evmcs_sanitize_exec_ctrls(struct =
vmcs_config *vmcs_conf)
>>> }
>>> #endif
>>>=20
>>> +bool nested_enlightened_vmentry(struct kvm_vcpu *vcpu, u64 *evmptr)
>>=20
>> I prefer to rename evmptr to evmcs_ptr. I think it=E2=80=99s more =
readable and sufficiently short.
>> In addition, I think you should return either -1ull or =
assist_page.current_nested_vmcs.
>> i.e. Don=E2=80=99t return evmcs_ptr by pointer but instead as a =
return-value
>> and get rid of the bool.
>=20
> Sure, can do in v2.
>=20
>>=20
>>> +{
>>> +	struct hv_vp_assist_page assist_page;
>>> +
>>> +	*evmptr =3D -1ull;
>>> +
>>> +	if (unlikely(!kvm_hv_get_assist_page(vcpu, &assist_page)))
>>> +		return false;
>>> +
>>> +	if (unlikely(!assist_page.enlighten_vmentry))
>>> +		return false;
>>> +
>>> +	*evmptr =3D assist_page.current_nested_vmcs;
>>> +
>>> +	return true;
>>> +}
>>> +
>>> uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu)
>>> {
>>>       struct vcpu_vmx *vmx =3D to_vmx(vcpu);
>>> diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
>>> index e0fcef85b332..c449e79a9c4a 100644
>>> --- a/arch/x86/kvm/vmx/evmcs.h
>>> +++ b/arch/x86/kvm/vmx/evmcs.h
>>> @@ -195,6 +195,7 @@ static inline void =
evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf) {}
>>> static inline void evmcs_touch_msr_bitmap(void) {}
>>> #endif /* IS_ENABLED(CONFIG_HYPERV) */
>>>=20
>>> +bool nested_enlightened_vmentry(struct kvm_vcpu *vcpu, u64 =
*evmptr);
>>> uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu);
>>> int nested_enable_evmcs(struct kvm_vcpu *vcpu,
>>> 			uint16_t *vmcs_version);
>>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>>> index 9214b3aea1f9..ee8dda7d8a03 100644
>>> --- a/arch/x86/kvm/vmx/nested.c
>>> +++ b/arch/x86/kvm/vmx/nested.c
>>> @@ -1765,26 +1765,21 @@ static int =
nested_vmx_handle_enlightened_vmptrld(struct kvm_vcpu *vcpu,
>>> 						 bool from_launch)
>>> {
>>> 	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
>>> -	struct hv_vp_assist_page assist_page;
>>> +	u64 evmptr;
>>=20
>> I prefer to rename evmptr to evmcs_ptr. I think it=E2=80=99s more =
readable and sufficiently short.
>>=20
>=20
> Sure.

Sorry I meant evmcs_vmptr to be consistent with =
vmx->nested.hv_evmcs_vmptr.

>=20
>>>=20
>>> 	if (likely(!vmx->nested.enlightened_vmcs_enabled))
>>> 		return 1;
>>>=20
>>> -	if (unlikely(!kvm_hv_get_assist_page(vcpu, &assist_page)))
>>> +	if (!nested_enlightened_vmentry(vcpu, &evmptr))
>>> 		return 1;
>>>=20
>>> -	if (unlikely(!assist_page.enlighten_vmentry))
>>> -		return 1;
>>> -
>>> -	if (unlikely(assist_page.current_nested_vmcs !=3D
>>> -		     vmx->nested.hv_evmcs_vmptr)) {
>>> -
>>> +	if (unlikely(evmptr !=3D vmx->nested.hv_evmcs_vmptr)) {
>>> 		if (!vmx->nested.hv_evmcs)
>>> 			vmx->nested.current_vmptr =3D -1ull;
>>>=20
>>> 		nested_release_evmcs(vcpu);
>>>=20
>>> -		if (kvm_vcpu_map(vcpu, =
gpa_to_gfn(assist_page.current_nested_vmcs),
>>> +		if (kvm_vcpu_map(vcpu, gpa_to_gfn(evmptr),
>>> 				 &vmx->nested.hv_evmcs_map))
>>> 			return 0;
>>>=20
>>> @@ -1826,7 +1821,7 @@ static int =
nested_vmx_handle_enlightened_vmptrld(struct kvm_vcpu *vcpu,
>>> 		 */
>>> 		vmx->nested.hv_evmcs->hv_clean_fields &=3D
>>> 			~HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
>>> -		vmx->nested.hv_evmcs_vmptr =3D =
assist_page.current_nested_vmcs;
>>> +		vmx->nested.hv_evmcs_vmptr =3D evmptr;
>>>=20
>>> 		/*
>>> 		 * Unlike normal vmcs12, enlightened vmcs12 is not fully
>>> @@ -4331,6 +4326,7 @@ static int handle_vmclear(struct kvm_vcpu =
*vcpu)
>>> 	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
>>> 	u32 zero =3D 0;
>>> 	gpa_t vmptr;
>>> +	u64 evmptr;
>>=20
>> I prefer to rename evmptr to evmcs_ptr. I think it=E2=80=99s more =
readable and sufficiently short.
>>=20
>=20
> Sure.
>=20
>>>=20
>>> 	if (!nested_vmx_check_permission(vcpu))
>>> 		return 1;
>>> @@ -4346,7 +4342,8 @@ static int handle_vmclear(struct kvm_vcpu =
*vcpu)
>>> 		return nested_vmx_failValid(vcpu,
>>> 			VMXERR_VMCLEAR_VMXON_POINTER);
>>>=20
>>> -	if (vmx->nested.hv_evmcs_map.hva) {
>>> +	if (unlikely(vmx->nested.enlightened_vmcs_enabled) &&
>>> +	    nested_enlightened_vmentry(vcpu, &evmptr)) {
>>> 		if (vmptr =3D=3D vmx->nested.hv_evmcs_vmptr)
>>=20
>> Shouldn=E2=80=99t you also remove the (vmptr =3D=3D =
vmx->nested.hv_evmcs_vmptr) condition?
>> To my understanding, vmx->nested.hv_evmcs_vmptr represents the =
address of the loaded eVMCS on current vCPU.
>> But according to commit message, it is valid for vCPU to perform
>> VMCLEAR on eVMCS that differ from loaded eVMCS on vCPU.
>> E.g. The current vCPU may even have vmx->nested.hv_evmcs_vmptr set to
>> -1ull.
>=20
> nested_release_evmcs() unmaps current eVMCS on the vCPU, we can't =
easily
> unmap eVMCS on other vCPUs without somehow synchronizing with
> them. Actually, if we remove nested_release_evmcs() from here nothing =
is
> going to change: the fact that eVMCS is mapped doesn't hurt much. If =
the
> next enlightened vmentry is going to happen with the same evmptr we'll
> have to map it back, in case a different one will be used - we'll =
unmap
> the old.

Right.

>=20
> In KVM, there's nothing we *have* to do to transition an eVMCS from
> active to non-activer state. We, for example, don't enforce the
> requirement that it can only be active on one vCPU at a time. =
Enforcing
> it is expensive (some synchronization is required) and if L1 =
hypervisor
> is misbehaving than, well, things are not going to work anyway.

Right.

>=20
> That said I'm ok with dropping nested_release_evmcs() for consistency
> but we can't just drop 'if (vmptr =3D=3D =
vmx->nested.hv_evmcs_vmptr)=E2=80=99.

Right. I meant that we can just change code to:

/* Add relevant comment here as this is not trivial why we do this */
If (likely(!vmx->nested.enlightened_vmcs_enabled) ||
    nested_enlightened_vmentry(vcpu, &evmptr)) {

    if (vmptr =3D=3D vmx->nested.current_vmptr)
        nested_release_vmcs12(vcpu);

    kvm_vcpu_write_guest(=E2=80=A6);
}

-Liran

>=20
> Thanks for your review!
>=20
> --=20
> Vitaly


