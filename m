Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3BB418C10A
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 21:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgCSULX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 16:11:23 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36560 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgCSULX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 16:11:23 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02JK9AFZ113610;
        Thu, 19 Mar 2020 20:11:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=crgG96nAJeU59nO4ZUu6PGmEfdz+veKrExSouQv8J/o=;
 b=pQN4U8dmY9qDkwm7viNZ/u4sXdeTrxTM/+lka8bINYOsmhcQqHwod0D7vYOjwOOW+1I/
 3xzaEpUmOngCW6KXLyLRaOJKgXl+aHRSZlhMlAGrsLcnlWWUgWsSUreRhuhJd9QCb9IX
 NrRjkjPSzqu8wKceJOi6VoSRm79JCTnCLkOqerYTwBRWAOv3FrkBFpD+phQdVgsEBsye
 ne9+0KTsSm9R4YX+YxOrijlR2zSzBwSZNGilhxN2COAYNuicVF09yrXh74YRUdYPs2qt
 TaqFKd7HC6OD47gm4uxyRwr0ZSOcYRgwWiPxI66BokGgqSR+A8gYkS5wBwa544sRiITz Yw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2yrpprjhbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Mar 2020 20:11:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02JJwZOY094548;
        Thu, 19 Mar 2020 20:11:18 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2ys904vuu1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Mar 2020 20:11:18 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02JKBHu2024184;
        Thu, 19 Mar 2020 20:11:17 GMT
Received: from localhost.localdomain (/10.65.178.104)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Mar 2020 13:11:17 -0700
Subject: Re: [PATCH] KVM: nVMX: remove side effects from
 nested_vmx_exit_reflected
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, sean.j.christopherson@intel.com
References: <1584468059-3585-1-git-send-email-pbonzini@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <4aa41614-51f0-7e4f-57b6-0e15329036a5@oracle.com>
Date:   Thu, 19 Mar 2020 13:11:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1584468059-3585-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9565 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003190083
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9565 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003190083
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/17/20 11:00 AM, Paolo Bonzini wrote:
> The name of nested_vmx_exit_reflected suggests that it's purely
> a test, but it actually marks VMCS12 pages as dirty.  Move this to
> vmx_handle_exit, observing that the initial nested_run_pending check in
> nested_vmx_exit_reflected is pointless---nested_run_pending has just
> been cleared in vmx_vcpu_run and won't be set until handle_vmlaunch
> or handle_vmresume.
>
> Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/vmx/nested.c | 18 ++----------------
>   arch/x86/kvm/vmx/nested.h |  1 +
>   arch/x86/kvm/vmx/vmx.c    | 19 +++++++++++++++++--
>   3 files changed, 20 insertions(+), 18 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 8578513907d7..4ff859c99946 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3527,7 +3527,7 @@ static void vmcs12_save_pending_event(struct kvm_vcpu *vcpu,
>   }
>   
>   
> -static void nested_mark_vmcs12_pages_dirty(struct kvm_vcpu *vcpu)
> +void nested_mark_vmcs12_pages_dirty(struct kvm_vcpu *vcpu)
>   {
>   	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
>   	gfn_t gfn;
> @@ -5543,8 +5543,7 @@ bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
>   	struct vcpu_vmx *vmx = to_vmx(vcpu);
>   	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
>   
> -	if (vmx->nested.nested_run_pending)
> -		return false;
> +	WARN_ON_ONCE(vmx->nested.nested_run_pending);
>   
>   	if (unlikely(vmx->fail)) {
>   		trace_kvm_nested_vmenter_failed(
> @@ -5553,19 +5552,6 @@ bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
>   		return true;
>   	}
>   
> -	/*
> -	 * The host physical addresses of some pages of guest memory
> -	 * are loaded into the vmcs02 (e.g. vmcs12's Virtual APIC
> -	 * Page). The CPU may write to these pages via their host
> -	 * physical address while L2 is running, bypassing any
> -	 * address-translation-based dirty tracking (e.g. EPT write
> -	 * protection).
> -	 *
> -	 * Mark them dirty on every exit from L2 to prevent them from
> -	 * getting out of sync with dirty tracking.
> -	 */
> -	nested_mark_vmcs12_pages_dirty(vcpu);
> -
>   	trace_kvm_nested_vmexit(kvm_rip_read(vcpu), exit_reason,
>   				vmcs_readl(EXIT_QUALIFICATION),
>   				vmx->idt_vectoring_info,
> diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
> index 21d36652f213..f70968b76d33 100644
> --- a/arch/x86/kvm/vmx/nested.h
> +++ b/arch/x86/kvm/vmx/nested.h
> @@ -33,6 +33,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
>   int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
>   			u32 vmx_instruction_info, bool wr, int len, gva_t *ret);
>   void nested_vmx_pmu_entry_exit_ctls_update(struct kvm_vcpu *vcpu);
> +void nested_mark_vmcs12_pages_dirty(struct kvm_vcpu *vcpu);
>   bool nested_vmx_check_io_bitmaps(struct kvm_vcpu *vcpu, unsigned int port,
>   				 int size);
>   
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index b447d66f44e6..07299a957d4a 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5851,8 +5851,23 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu,
>   	if (vmx->emulation_required)
>   		return handle_invalid_guest_state(vcpu);
>   
> -	if (is_guest_mode(vcpu) && nested_vmx_exit_reflected(vcpu, exit_reason))
> -		return nested_vmx_reflect_vmexit(vcpu, exit_reason);
> +	if (is_guest_mode(vcpu)) {
> +		/*
> +		 * The host physical addresses of some pages of guest memory
> +		 * are loaded into the vmcs02 (e.g. vmcs12's Virtual APIC
> +		 * Page). The CPU may write to these pages via their host
> +		 * physical address while L2 is running, bypassing any
> +		 * address-translation-based dirty tracking (e.g. EPT write
> +		 * protection).
> +		 *
> +		 * Mark them dirty on every exit from L2 to prevent them from
> +		 * getting out of sync with dirty tracking.
> +		 */
> +		nested_mark_vmcs12_pages_dirty(vcpu);
> +
> +		if (nested_vmx_exit_reflected(vcpu, exit_reason))
> +			return nested_vmx_reflect_vmexit(vcpu, exit_reason);
> +	}
>   
>   	if (exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY) {
>   		dump_vmcs();
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
