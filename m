Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D36EB585E
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 01:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbfIQXFr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 19:05:47 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33894 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfIQXFr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 19:05:47 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8HN31Wt150645;
        Tue, 17 Sep 2019 23:05:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=pN+3VoxlmlzDUU08KLv0Low6pKH8lIWHgycr8NU4pGE=;
 b=BjsWKLqOpG9FDqqapZZt0BlzsvyXzS5B9VEqBgNsdGZ/cLuCDuvkVJgH+VSYD5HIrdZT
 4G2qzUbAaOHFH21kOB8+H82V0X3t5bMv5B/RlnU/x8qbTx6bFky/hagCXJrVKBIOj9ht
 zEg5P1r/CDGq9p919wBhlvwB0nxfgN1lre62D4MC7dC7ETXZQBIyn+6eeBE7dZNGN1w3
 iNrdqkwfbPcYztn5jC7PW/B3KU9yD/xWaP9/Pr0Coy/TyrXSP3/CyWlCo1HM5Srrpdy4
 GDTZj68amTNaI5/3uywrTiFCuwvt97TwoxLdAuY4H2BiSLukL2vw3FnYVpmg5FlsP8Tc KA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2v385dr4m0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Sep 2019 23:05:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8HN3ZUo022462;
        Tue, 17 Sep 2019 23:05:41 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2v37m92qwa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Sep 2019 23:05:41 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8HN5esj017034;
        Tue, 17 Sep 2019 23:05:40 GMT
Received: from dhcp-10-132-91-76.usdhcp.oraclecorp.com (/10.132.91.76)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 17 Sep 2019 16:05:40 -0700
Subject: Re: [PATCH v3] kvm: nvmx: limit atomic switch MSRs
To:     Marc Orr <marcorr@google.com>, kvm@vger.kernel.org,
        jmattson@google.com, pshier@google.com,
        sean.j.christopherson@intel.com
References: <20190917185057.224221-1-marcorr@google.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <2dce168f-edab-8c56-6d29-dc73aace8b63@oracle.com>
Date:   Tue, 17 Sep 2019 16:05:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190917185057.224221-1-marcorr@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9383 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909170215
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9383 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909170215
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 09/17/2019 11:50 AM, Marc Orr wrote:
> Allowing an unlimited number of MSRs to be specified via the VMX
> load/store MSR lists (e.g., vm-entry MSR load list) is bad for two
> reasons. First, a guest can specify an unreasonable number of MSRs,
> forcing KVM to process all of them in software. Second, the SDM bounds
> the number of MSRs allowed to be packed into the atomic switch MSR lists.
> Quoting the "Miscellaneous Data" section in the "VMX Capability
> Reporting Facility" appendix:
>
> "Bits 27:25 is used to compute the recommended maximum number of MSRs
> that should appear in the VM-exit MSR-store list, the VM-exit MSR-load
> list, or the VM-entry MSR-load list. Specifically, if the value bits
> 27:25 of IA32_VMX_MISC is N, then 512 * (N + 1) is the recommended
> maximum number of MSRs to be included in each list. If the limit is
> exceeded, undefined processor behavior may result (including a machine
> check during the VMX transition)."
>
> Because KVM needs to protect itself and can't model "undefined processor
> behavior", arbitrarily force a VM-entry to fail due to MSR loading when
> the MSR load list is too large. Similarly, trigger an abort during a VM
> exit that encounters an MSR load list or MSR store list that is too large.
>
> The MSR list size is intentionally not pre-checked so as to maintain
> compatibility with hardware inasmuch as possible.
>
> Test these new checks with the kvm-unit-test "x86: nvmx: test max atomic
> switch MSRs".
>
> Suggested-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> Signed-off-by: Marc Orr <marcorr@google.com>
> ---
> v2 -> v3
> * Updated commit message.
> * Removed superflous function declaration.
> * Expanded in-line comment.
>
>   arch/x86/include/asm/vmx.h |  1 +
>   arch/x86/kvm/vmx/nested.c  | 44 ++++++++++++++++++++++++++++----------
>   2 files changed, 34 insertions(+), 11 deletions(-)
>
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index a39136b0d509..a1f6ed187ccd 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -110,6 +110,7 @@
>   #define VMX_MISC_SAVE_EFER_LMA			0x00000020
>   #define VMX_MISC_ACTIVITY_HLT			0x00000040
>   #define VMX_MISC_ZERO_LEN_INS			0x40000000
> +#define VMX_MISC_MSR_LIST_MULTIPLIER		512
>   
>   /* VMFUNC functions */
>   #define VMX_VMFUNC_EPTP_SWITCHING               0x00000001
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index ced9fba32598..0e29882bb45f 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -190,6 +190,16 @@ static void nested_vmx_abort(struct kvm_vcpu *vcpu, u32 indicator)
>   	pr_debug_ratelimited("kvm: nested vmx abort, indicator %d\n", indicator);
>   }
>   
> +static inline bool vmx_control_verify(u32 control, u32 low, u32 high)
> +{
> +	return fixed_bits_valid(control, low, high);
> +}
> +
> +static inline u64 vmx_control_msr(u32 low, u32 high)
> +{
> +	return low | ((u64)high << 32);
> +}
> +
>   static void vmx_disable_shadow_vmcs(struct vcpu_vmx *vmx)
>   {
>   	secondary_exec_controls_clearbit(vmx, SECONDARY_EXEC_SHADOW_VMCS);
> @@ -856,18 +866,36 @@ static int nested_vmx_store_msr_check(struct kvm_vcpu *vcpu,
>   	return 0;
>   }
>   
> +static u32 nested_vmx_max_atomic_switch_msrs(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	u64 vmx_misc = vmx_control_msr(vmx->nested.msrs.misc_low,
> +				       vmx->nested.msrs.misc_high);
> +
> +	return (vmx_misc_max_msr(vmx_misc) + 1) * VMX_MISC_MSR_LIST_MULTIPLIER;
> +}
> +
>   /*
>    * Load guest's/host's msr at nested entry/exit.
>    * return 0 for success, entry index for failure.
> + *
> + * One of the failure modes for MSR load/store is when a list exceeds the
> + * virtual hardware's capacity. To maintain compatibility with hardware inasmuch
> + * as possible, process all valid entries before failing rather than precheck
> + * for a capacity violation.
>    */
>   static u32 nested_vmx_load_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
>   {
>   	u32 i;
>   	struct vmx_msr_entry e;
>   	struct msr_data msr;
> +	u32 max_msr_list_size = nested_vmx_max_atomic_switch_msrs(vcpu);
>   
>   	msr.host_initiated = false;
>   	for (i = 0; i < count; i++) {
> +		if (unlikely(i >= max_msr_list_size))
> +			goto fail;
> +
>   		if (kvm_vcpu_read_guest(vcpu, gpa + i * sizeof(e),
>   					&e, sizeof(e))) {
>   			pr_debug_ratelimited(
> @@ -899,9 +927,14 @@ static int nested_vmx_store_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
>   {
>   	u32 i;
>   	struct vmx_msr_entry e;
> +	u32 max_msr_list_size = nested_vmx_max_atomic_switch_msrs(vcpu);
>   
>   	for (i = 0; i < count; i++) {
>   		struct msr_data msr_info;
> +
> +		if (unlikely(i >= max_msr_list_size))
> +			return -EINVAL;
> +
>   		if (kvm_vcpu_read_guest(vcpu,
>   					gpa + i * sizeof(e),
>   					&e, 2 * sizeof(u32))) {
> @@ -1009,17 +1042,6 @@ static u16 nested_get_vpid02(struct kvm_vcpu *vcpu)
>   	return vmx->nested.vpid02 ? vmx->nested.vpid02 : vmx->vpid;
>   }
>   
> -
> -static inline bool vmx_control_verify(u32 control, u32 low, u32 high)
> -{
> -	return fixed_bits_valid(control, low, high);
> -}
> -
> -static inline u64 vmx_control_msr(u32 low, u32 high)
> -{
> -	return low | ((u64)high << 32);
> -}
> -
>   static bool is_bitwise_subset(u64 superset, u64 subset, u64 mask)
>   {
>   	superset &= mask;
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
