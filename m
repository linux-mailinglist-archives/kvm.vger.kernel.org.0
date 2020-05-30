Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFE41E8D08
	for <lists+kvm@lfdr.de>; Sat, 30 May 2020 04:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728713AbgE3CGQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 22:06:16 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55054 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728675AbgE3CGP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 22:06:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04U21v9G126685;
        Sat, 30 May 2020 02:06:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 references : message-id : date : mime-version : in-reply-to : content-type
 : content-transfer-encoding; s=corp-2020-01-29;
 bh=nXhrAs3diRrE7aeLNXynakoZoDvNIlA9UYWiqjDfFvE=;
 b=QtQOj8i87Sp7qNqCOJgPmQaO+/7ZZAbTuvijjTqKpCEc1kDnpwAYiRcQZupYUrh8balP
 y1NiKK1sOFC6GJELyOW5x+NIWm3sUCxzFJO/2sYJV3FCT03XxCcswlCZvGMeiXxIwwsb
 X/BhMtFMs71n9BPcZ/+O2ly6Z6XE8Bf06girVufI84rz/w4q9gkm6SkuFfcKfKYmHIDS
 bfH4/gKU0oKHZdZwtWg+DAJiHS7Fg8FzMybH6gEYvUR/Jb9802eecTJD1wbPkNo6S5Ap
 q8yU0Oaif0NdIhME746EeD1qLDPzLpTQ0aonMdF4h2rc6IEqkPYEvEvEPJYWPTZjGihx 9g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 318xbkd839-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 30 May 2020 02:06:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04U23nZk142472;
        Sat, 30 May 2020 02:06:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 31a9kv3wqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 30 May 2020 02:06:11 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04U26A3V021022;
        Sat, 30 May 2020 02:06:10 GMT
Received: from localhost.localdomain (/73.15.199.204)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 29 May 2020 19:06:10 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [PATCH 17/30] KVM: nSVM: synchronize VMCB controls updated by the
 processor on every vmexit
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200529153934.11694-1-pbonzini@redhat.com>
 <20200529153934.11694-18-pbonzini@redhat.com>
Message-ID: <128fe186-219f-75d0-7ce2-9bb6317e1e7d@oracle.com>
Date:   Fri, 29 May 2020 19:06:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200529153934.11694-18-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9636 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005300013
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9636 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 cotscore=-2147483648
 suspectscore=0 bulkscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005300013
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/29/20 8:39 AM, Paolo Bonzini wrote:
> The control state changes on every L2->L0 vmexit, and we will have to
> serialize it in the nested state.  So keep it up to date in svm->nested.ctl
> and just copy them back to the nested VMCB in nested_svm_vmexit.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/svm/nested.c | 57 ++++++++++++++++++++++-----------------
>   arch/x86/kvm/svm/svm.c    |  5 +++-
>   arch/x86/kvm/svm/svm.h    |  1 +
>   3 files changed, 38 insertions(+), 25 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 1e5f460b5540..921466eba556 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -234,6 +234,34 @@ static void load_nested_vmcb_control(struct vcpu_svm *svm,
>   	svm->nested.ctl.iopm_base_pa  &= ~0x0fffULL;
>   }
>   
> +/*
> + * Synchronize fields that are written by the processor, so that
> + * they can be copied back into the nested_vmcb.
> + */
> +void sync_nested_vmcb_control(struct vcpu_svm *svm)
> +{
> +	u32 mask;
> +	svm->nested.ctl.event_inj      = svm->vmcb->control.event_inj;
> +	svm->nested.ctl.event_inj_err  = svm->vmcb->control.event_inj_err;
> +
> +	/* Only a few fields of int_ctl are written by the processor.  */
> +	mask = V_IRQ_MASK | V_TPR_MASK;
> +	if (!(svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK) &&
> +	    is_intercept(svm, SVM_EXIT_VINTR)) {
> +		/*
> +		 * In order to request an interrupt window, L0 is usurping
> +		 * svm->vmcb->control.int_ctl and possibly setting V_IRQ
> +		 * even if it was clear in L1's VMCB.  Restoring it would be
> +		 * wrong.  However, in this case V_IRQ will remain true until
> +		 * interrupt_window_interception calls svm_clear_vintr and
> +		 * restores int_ctl.  We can just leave it aside.
> +		 */
> +		mask &= ~V_IRQ_MASK;
> +	}
> +	svm->nested.ctl.int_ctl        &= ~mask;
> +	svm->nested.ctl.int_ctl        |= svm->vmcb->control.int_ctl & mask;
> +}
> +
>   static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_vmcb)
>   {
>   	/* Load the nested guest state */
> @@ -471,6 +499,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>   	/* Exit Guest-Mode */
>   	leave_guest_mode(&svm->vcpu);
>   	svm->nested.vmcb = 0;
> +	WARN_ON_ONCE(svm->nested.nested_run_pending);
>   
>   	/* in case we halted in L2 */
>   	svm->vcpu.arch.mp_state = KVM_MP_STATE_RUNNABLE;
> @@ -497,8 +526,6 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>   	nested_vmcb->save.dr6    = svm->vcpu.arch.dr6;
>   	nested_vmcb->save.cpl    = vmcb->save.cpl;
>   
> -	nested_vmcb->control.int_ctl           = vmcb->control.int_ctl;
> -	nested_vmcb->control.int_vector        = vmcb->control.int_vector;


While it's not related to this patch, I am wondering if we need the 
following line in enter_svm_guest_mode():

     svm->vmcb->control.int_vector = nested_vmcb->control.int_vector;


If int_vector is used only to trigger a #VMEXIT after we have decided to 
inject a virtual interrupt, we probably don't the vector value from the 
nested vmcb.

>   	nested_vmcb->control.int_state         = vmcb->control.int_state;
>   	nested_vmcb->control.exit_code         = vmcb->control.exit_code;
>   	nested_vmcb->control.exit_code_hi      = vmcb->control.exit_code_hi;
> @@ -510,34 +537,16 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>   	if (svm->nrips_enabled)
>   		nested_vmcb->control.next_rip  = vmcb->control.next_rip;
>   
> -	/*
> -	 * If we emulate a VMRUN/#VMEXIT in the same host #vmexit cycle we have
> -	 * to make sure that we do not lose injected events. So check event_inj
> -	 * here and copy it to exit_int_info if it is valid.
> -	 * Exit_int_info and event_inj can't be both valid because the case
> -	 * below only happens on a VMRUN instruction intercept which has
> -	 * no valid exit_int_info set.
> -	 */
> -	if (vmcb->control.event_inj & SVM_EVTINJ_VALID) {
> -		struct vmcb_control_area *nc = &nested_vmcb->control;
> -
> -		nc->exit_int_info     = vmcb->control.event_inj;
> -		nc->exit_int_info_err = vmcb->control.event_inj_err;
> -	}
> -
> -	nested_vmcb->control.tlb_ctl           = 0;
> -	nested_vmcb->control.event_inj         = 0;
> -	nested_vmcb->control.event_inj_err     = 0;
> +	nested_vmcb->control.int_ctl           = svm->nested.ctl.int_ctl;
> +	nested_vmcb->control.tlb_ctl           = svm->nested.ctl.tlb_ctl;
> +	nested_vmcb->control.event_inj         = svm->nested.ctl.event_inj;
> +	nested_vmcb->control.event_inj_err     = svm->nested.ctl.event_inj_err;
>   
>   	nested_vmcb->control.pause_filter_count =
>   		svm->vmcb->control.pause_filter_count;
>   	nested_vmcb->control.pause_filter_thresh =
>   		svm->vmcb->control.pause_filter_thresh;
>   
> -	/* We always set V_INTR_MASKING and remember the old value in hflags */
> -	if (!(svm->vcpu.arch.hflags & HF_VINTR_MASK))
> -		nested_vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
> -
>   	/* Restore the original control entries */
>   	copy_vmcb_control_area(&vmcb->control, &hsave->control);
>   
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 4122ba86bac2..b710e62ace16 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3427,7 +3427,10 @@ static fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>   	sync_cr8_to_lapic(vcpu);
>   
>   	svm->next_rip = 0;
> -	svm->nested.nested_run_pending = 0;
> +	if (is_guest_mode(&svm->vcpu)) {
> +		sync_nested_vmcb_control(svm);
> +		svm->nested.nested_run_pending = 0;


I don't see any existence of nested_run_pending for nSVM either in Linus 
tree or KVM tree. Is there a  patch that has this added but not pushed yet ?

> +	}
>   
>   	svm->vmcb->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
>   
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index dd5418f20256..7e79f0af1204 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -394,6 +394,7 @@ int nested_svm_check_permissions(struct vcpu_svm *svm);
>   int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
>   			       bool has_error_code, u32 error_code);
>   int nested_svm_exit_special(struct vcpu_svm *svm);
> +void sync_nested_vmcb_control(struct vcpu_svm *svm);
>   
>   extern struct kvm_x86_nested_ops svm_nested_ops;
>   
