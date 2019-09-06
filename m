Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9B08AC13A
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 22:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394355AbfIFUGG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 16:06:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54458 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394091AbfIFUGF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 16:06:05 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x86K62m9158889;
        Fri, 6 Sep 2019 20:06:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=Ssa3mK10iTTRNMJ3AyCX+BKPGF5RTA1MLVAPFuFJbaY=;
 b=BLmLtaYdVhZgLG97gXk/twnhJ0O2wVhwMhwSdOwIcQx0cguzvYjrhaC33CnLedvfBTSj
 2G5PGT4kSRIpO36lDCKczZ476EdyEGnSIDzMq634fxWt3Ey2UO0ALpqLS6DzJj/aw6vU
 pK5ThUCxRye/n2borTB3fdtLpoOH4mn5BksVU85chbBS4mP72w9gXqWE8KaDNFwUftyQ
 o4SzV/ssUI/w9Hg0hVEdm8hJx+St7Z5boFNTbXVDweZ7vJTbMIsGfjKD5SBuZYywSyDJ
 ZbOpA5xtLeYwc/NWAdtlLvMq0lUcMcJ8DCYk7/CKI579rFUO+00Z+0fgaNZ3o+WY4XYT uQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2uux6c002q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 20:06:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x86K39qg103593;
        Fri, 6 Sep 2019 20:06:01 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2uu1ba38q9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 20:06:01 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x86K60SO029265;
        Fri, 6 Sep 2019 20:06:00 GMT
Received: from [192.168.14.112] (/79.182.237.80)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 06 Sep 2019 13:05:59 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [RFC][PATCH] KVM: nVMX: Don't leak L1 MMIO regions to L2
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20190906185945.230946-1-jmattson@google.com>
Date:   Fri, 6 Sep 2019 23:05:55 +0300
Cc:     kvm@vger.kernel.org, Dan Cross <dcross@google.com>,
        Marc Orr <marcorr@google.com>, Peter Shier <pshier@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <E9EFDCFC-9B30-4CC2-ADD8-ED756ECE37CC@oracle.com>
References: <20190906185945.230946-1-jmattson@google.com>
To:     Jim Mattson <jmattson@google.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9372 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060208
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9372 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060208
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 6 Sep 2019, at 21:59, Jim Mattson <jmattson@google.com> wrote:
>=20
> If the "virtualize APIC accesses" VM-execution control is set in the
> VMCS, the APIC virtualization hardware is triggered when a page walk
> in VMX non-root mode terminates at a PTE wherein the address of the 4k
> page frame matches the APIC-access address specified in the VMCS. On
> hardware, the APIC-access address may be any valid 4k-aligned physical
> address.
>=20
> KVM's nVMX implementation enforces the additional constraint that the
> APIC-access address specified in the vmcs12 must be backed by
> cacheable memory in L1. If not, L0 will simply clear the "virtualize
> APIC accesses" VM-execution control in the vmcs02.
>=20
> The problem with this approach is that the L1 guest has arranged the
> vmcs12 EPT tables--or shadow page tables, if the "enable EPT"
> VM-execution control is clear in the vmcs12--so that the L2 guest
> physical address(es)--or L2 guest linear address(es)--that reference
> the L2 APIC map to the APIC-access address specified in the
> vmcs12. Without the "virtualize APIC accesses" VM-execution control in
> the vmcs02, the APIC accesses in the L2 guest will directly access the
> APIC-access page in L1.
>=20
> When L0 has no mapping whatsoever for the APIC-access address in L1,
> the L2 VM just loses the intended APIC virtualization. However, when
> the L2 APIC-access address is mapped to an MMIO region in L1, the L2
> guest gets direct access to the L1 MMIO device. For example, if the
> APIC-access address specified in the vmcs12 is 0xfee00000, then L2
> gets direct access to L1's APIC.
>=20
> Fixing this correctly is complicated. Since this vmcs12 configuration
> is something that KVM cannot faithfully emulate, the appropriate
> response is to exit to userspace with
> KVM_INTERNAL_ERROR_EMULATION. Sadly, the kvm-unit-tests fail, so I'm
> posting this as an RFC.
>=20
> Note that the 'Code' line emitted by qemu in response to this error
> shows the guest %rip two instructions after the
> vmlaunch/vmresume. Hmmm.
>=20
> Fixes: fe3ef05c7572 ("KVM: nVMX: Prepare vmcs02 from vmcs01 and =
vmcs12")
> Reported-by: Dan Cross <dcross@google.com>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Marc Orr <marcorr@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> Reviewed-by: Dan Cross <dcross@google.com>

The idea of the patch and the functionality of it seems correct to me.
However, I have some small code comments below.

> ---
> arch/x86/include/asm/kvm_host.h |  2 +-
> arch/x86/kvm/vmx/nested.c       | 55 ++++++++++++++++++++++-----------
> arch/x86/kvm/x86.c              |  9 ++++--
> 3 files changed, 45 insertions(+), 21 deletions(-)
>=20
> diff --git a/arch/x86/include/asm/kvm_host.h =
b/arch/x86/include/asm/kvm_host.h
> index 74e88e5edd9cf..e95acf8c82b47 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1191,7 +1191,7 @@ struct kvm_x86_ops {
> 	int (*set_nested_state)(struct kvm_vcpu *vcpu,
> 				struct kvm_nested_state __user =
*user_kvm_nested_state,
> 				struct kvm_nested_state *kvm_state);
> -	void (*get_vmcs12_pages)(struct kvm_vcpu *vcpu);
> +	int (*get_vmcs12_pages)(struct kvm_vcpu *vcpu);
>=20
> 	int (*smi_allowed)(struct kvm_vcpu *vcpu);
> 	int (*pre_enter_smm)(struct kvm_vcpu *vcpu, char *smstate);
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index ced9fba32598d..bdf5a11816fa4 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2871,7 +2871,7 @@ static int nested_vmx_check_vmentry_hw(struct =
kvm_vcpu *vcpu)
> static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu =
*vcpu,
> 						 struct vmcs12 *vmcs12);
>=20
> -static void nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
> +static int nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
> {
> 	struct vmcs12 *vmcs12 =3D get_vmcs12(vcpu);
> 	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
> @@ -2891,19 +2891,31 @@ static void nested_get_vmcs12_pages(struct =
kvm_vcpu *vcpu)
> 			vmx->nested.apic_access_page =3D NULL;
> 		}
> 		page =3D kvm_vcpu_gpa_to_page(vcpu, =
vmcs12->apic_access_addr);
> -		/*
> -		 * If translation failed, no matter: This feature asks
> -		 * to exit when accessing the given address, and if it
> -		 * can never be accessed, this feature won't do
> -		 * anything anyway.
> -		 */
> 		if (!is_error_page(page)) {
> 			vmx->nested.apic_access_page =3D page;
> 			hpa =3D =
page_to_phys(vmx->nested.apic_access_page);
> 			vmcs_write64(APIC_ACCESS_ADDR, hpa);
> 		} else {
> -			secondary_exec_controls_clearbit(vmx,
> -				=
SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES);
> +			/*
> +			 * Since there is no backing page, we can't
> +			 * just rely on the usual L1 GPA -> HPA
> +			 * translation mechanism to do the right
> +			 * thing. We'd have to assign an appropriate
> +			 * HPA for the L1 APIC-access address, and
> +			 * then we'd have to modify the MMU to ensure
> +			 * that the L1 APIC-access address is mapped
> +			 * to the assigned HPA if and only if an L2 VM
> +			 * with that APIC-access address and the
> +			 * "virtualize APIC accesses" VM-execution
> +			 * control set in the vmcs12 is running. For
> +			 * now, just admit defeat.
> +			 */
> +			pr_warn_ratelimited("Unsupported vmcs12 =
APIC-access address\n");
> +			vcpu->run->exit_reason =3D =
KVM_EXIT_INTERNAL_ERROR;
> +			vcpu->run->internal.suberror =3D
> +				KVM_INTERNAL_ERROR_EMULATION;
> +			vcpu->run->internal.ndata =3D 0;

I think it is wise to pass here vmcs12->apic_access_addr value to =
userspace.
In addition, also print it in pr_warn_ratelimited() call.
To aid debugging.

> +			return -ENOTSUPP;
> 		}
> 	}
>=20
> @@ -2948,6 +2960,7 @@ static void nested_get_vmcs12_pages(struct =
kvm_vcpu *vcpu)
> 		exec_controls_setbit(vmx, CPU_BASED_USE_MSR_BITMAPS);
> 	else
> 		exec_controls_clearbit(vmx, CPU_BASED_USE_MSR_BITMAPS);
> +	return 0;
> }
>=20
> /*
> @@ -2986,11 +2999,12 @@ static void load_vmcs12_host_state(struct =
kvm_vcpu *vcpu,
> /*
>  * If from_vmentry is false, this is being called from state restore =
(either RSM
>  * or KVM_SET_NESTED_STATE).  Otherwise it's called from =
vmlaunch/vmresume.
> -+ *
> -+ * Returns:
> -+ *   0 - success, i.e. proceed with actual VMEnter
> -+ *   1 - consistency check VMExit
> -+ *  -1 - consistency check VMFail
> + *
> + * Returns:
> + * < 0 - error
> + *   0 - success, i.e. proceed with actual VMEnter
> + *   1 - consistency check VMExit
> + *   2 - consistency check VMFail

Whenever we start having non-trivial return values, I believe adding an =
enum
is in place. It makes code easier to read and less confusing.

>  */
> int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool =
from_vmentry)
> {
> @@ -2999,6 +3013,7 @@ int nested_vmx_enter_non_root_mode(struct =
kvm_vcpu *vcpu, bool from_vmentry)
> 	bool evaluate_pending_interrupts;
> 	u32 exit_reason =3D EXIT_REASON_INVALID_STATE;
> 	u32 exit_qual;
> +	int r;
>=20
> 	evaluate_pending_interrupts =3D exec_controls_get(vmx) &
> 		(CPU_BASED_VIRTUAL_INTR_PENDING | =
CPU_BASED_VIRTUAL_NMI_PENDING);
> @@ -3035,11 +3050,13 @@ int nested_vmx_enter_non_root_mode(struct =
kvm_vcpu *vcpu, bool from_vmentry)
> 	prepare_vmcs02_early(vmx, vmcs12);
>=20
> 	if (from_vmentry) {
> -		nested_get_vmcs12_pages(vcpu);
> +		r =3D nested_get_vmcs12_pages(vcpu);
> +		if (unlikely(r))

It makes sense to also mark !is_error_page(page) as likely() in =
nested_get_vmcs12_pages().

> +			return r;
>=20
> 		if (nested_vmx_check_vmentry_hw(vcpu)) {
> 			vmx_switch_vmcs(vcpu, &vmx->vmcs01);
> -			return -1;
> +			return 2;
> 		}
>=20
> 		if (nested_vmx_check_guest_state(vcpu, vmcs12, =
&exit_qual))
> @@ -3200,9 +3217,11 @@ static int nested_vmx_run(struct kvm_vcpu =
*vcpu, bool launch)
> 	vmx->nested.nested_run_pending =3D 1;
> 	ret =3D nested_vmx_enter_non_root_mode(vcpu, true);
> 	vmx->nested.nested_run_pending =3D !ret;
> -	if (ret > 0)
> +	if (ret < 0)
> +		return 0;
> +	if (ret =3D=3D 1)
> 		return 1;
> -	else if (ret)
> +	if (ret)

All these checks for of "ret" are not really readable.
They also implicitly define any ret value which is >1 as consistency =
check VMFail instead of just ret=3D=3D2.

I prefer to have something like:

switch (ret) {
    case VMEXIT_ON_INVALID_STATE:
        return 1;
    case VMFAIL_ON_INVALID_STATE:
        return nested_vmx_failValid(vcpu, =
VMXERR_ENTRY_INVALID_CONTROL_FIELD);
    default:
        /* Return to userspace on error */
        if (ret < 0)
            return 0;
}

In addition, can you remind me why we call nested_vmx_failValid() at =
nested_vmx_run()
instead of inside nested_vmx_enter_non_root_mode() when =
nested_vmx_check_vmentry_hw() fails?

Then code could have indeed simply be:
if (ret < 0)
    return 0;
if (ret)
    return 1;
=E2=80=A6.

Which is easy to understand.
i.e. First case return to userspace on error, second report error to =
guest and rest continue as usual
now assuming vCPU is non-root mode.

-Liran

> 		return nested_vmx_failValid(vcpu,
> 			VMXERR_ENTRY_INVALID_CONTROL_FIELD);
>=20
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 290c3c3efb877..5ddbf16c8b108 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7803,8 +7803,13 @@ static int vcpu_enter_guest(struct kvm_vcpu =
*vcpu)
> 	bool req_immediate_exit =3D false;
>=20
> 	if (kvm_request_pending(vcpu)) {
> -		if (kvm_check_request(KVM_REQ_GET_VMCS12_PAGES, vcpu))
> -			kvm_x86_ops->get_vmcs12_pages(vcpu);
> +		if (kvm_check_request(KVM_REQ_GET_VMCS12_PAGES, vcpu)) {
> +			r =3D kvm_x86_ops->get_vmcs12_pages(vcpu);
> +			if (unlikely(r)) {
> +				r =3D 0;
> +				goto out;
> +			}
> +		}
> 		if (kvm_check_request(KVM_REQ_MMU_RELOAD, vcpu))
> 			kvm_mmu_unload(vcpu);
> 		if (kvm_check_request(KVM_REQ_MIGRATE_TIMER, vcpu))
> --=20
> 2.23.0.187.g17f5b7556c-goog
>=20

