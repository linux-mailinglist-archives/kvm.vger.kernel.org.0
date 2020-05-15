Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4DF1D5CA6
	for <lists+kvm@lfdr.de>; Sat, 16 May 2020 01:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbgEOXJw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 19:09:52 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59620 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgEOXJw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 19:09:52 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04FN72jo007072;
        Fri, 15 May 2020 23:09:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=tecV6clB8lrYmlHoyet0oiwXbUPJjtWy4RzwOYWDzXM=;
 b=BbZ8QJtFH3+KphS27u4rCHZOn05PVp9mEi5i5zLdJFVguwc+evd3MqaiFC7RZF40kXnZ
 uh4h5dOu5/j5LnvU6ETI8LJ4p282WE3ebZomfI86aConPSy0Db8IEIM8ZokLvmpQjKXj
 MXFwsfNqzeGBveuyX5OXQEhrdeUT+DUiz71ktMaesBWwXvVnYbjrPPLU8qokWmN2tJYQ
 evDJPzNQqxRxIw66uUB4ytkkhJD+UTYltUwWY9hblrlLoYijDWKJOFzmDPFCnLez26jQ
 Fkt+I45OB7ao+xURFy0J/VdN1S8O81Nhb3VlvC3FzSVjqALT9Ce0yIcjHHDFSm4AnNj+ qA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3100yge7s7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 15 May 2020 23:09:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04FN8laX011481;
        Fri, 15 May 2020 23:09:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 310vjxng1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 May 2020 23:09:45 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04FN9iaU003274;
        Fri, 15 May 2020 23:09:44 GMT
Received: from localhost.localdomain (/10.159.240.167)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 15 May 2020 16:09:44 -0700
Subject: Re: [PATCH 2/7] KVM: SVM: extract load_nested_vmcb_control
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Cathy Avery <cavery@redhat.com>,
        Liran Alon <liran.alon@oracle.com>,
        Jim Mattson <jmattson@google.com>
References: <20200515174144.1727-1-pbonzini@redhat.com>
 <20200515174144.1727-3-pbonzini@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <73188a11-8208-cac6-4d30-4cf67a5d89bc@oracle.com>
Date:   Fri, 15 May 2020 16:09:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200515174144.1727-3-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9622 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 spamscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005150195
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9622 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 cotscore=-2147483648 mlxscore=0 suspectscore=0 spamscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 clxscore=1011 phishscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005150195
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/15/20 10:41 AM, Paolo Bonzini wrote:
> When restoring SVM nested state, the control state will be stored already
> in svm->nested by KVM_SET_NESTED_STATE.  We will not need to fish it out of
> L1's VMCB.  Pull everything into a separate function so that it is
> documented which fields are needed.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/svm/nested.c | 45 ++++++++++++++++++++++-----------------
>   1 file changed, 25 insertions(+), 20 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 22f75f66084f..e79acc852000 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -225,6 +225,27 @@ static bool nested_vmcb_checks(struct vmcb *vmcb)
>   	return true;
>   }
>   
> +static void load_nested_vmcb_control(struct vcpu_svm *svm, struct vmcb *nested_vmcb)


This function only separates a subset of the controls. If the purpose of 
the function is to separate only the controls that are related to 
migration, should it be called something like 
load_nested_state_vmcb_control or something like that ?

> +{
> +	if (kvm_get_rflags(&svm->vcpu) & X86_EFLAGS_IF)
> +		svm->vcpu.arch.hflags |= HF_HIF_MASK;
> +	else
> +		svm->vcpu.arch.hflags &= ~HF_HIF_MASK;
> +
> +	svm->nested.nested_cr3 = nested_vmcb->control.nested_cr3;
> +
> +	svm->nested.vmcb_msrpm = nested_vmcb->control.msrpm_base_pa & ~0x0fffULL;
> +	svm->nested.vmcb_iopm  = nested_vmcb->control.iopm_base_pa  & ~0x0fffULL;
> +
> +	/* cache intercepts */
> +	svm->nested.intercept_cr         = nested_vmcb->control.intercept_cr;
> +	svm->nested.intercept_dr         = nested_vmcb->control.intercept_dr;
> +	svm->nested.intercept_exceptions = nested_vmcb->control.intercept_exceptions;
> +	svm->nested.intercept            = nested_vmcb->control.intercept;
> +
> +	svm->vcpu.arch.tsc_offset += nested_vmcb->control.tsc_offset;
> +}
> +
>   void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
>   			  struct vmcb *nested_vmcb)
>   {
> @@ -232,15 +253,11 @@ void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
>   		is_intercept(svm, INTERCEPT_VINTR) ||
>   		is_intercept(svm, INTERCEPT_IRET);
>   
> -	if (kvm_get_rflags(&svm->vcpu) & X86_EFLAGS_IF)
> -		svm->vcpu.arch.hflags |= HF_HIF_MASK;
> -	else
> -		svm->vcpu.arch.hflags &= ~HF_HIF_MASK;
> +	svm->nested.vmcb = vmcb_gpa;
> +	load_nested_vmcb_control(svm, nested_vmcb);
>   
> -	if (nested_vmcb->control.nested_ctl & SVM_NESTED_CTL_NP_ENABLE) {
> -		svm->nested.nested_cr3 = nested_vmcb->control.nested_cr3;
> +	if (nested_vmcb->control.nested_ctl & SVM_NESTED_CTL_NP_ENABLE)
>   		nested_svm_init_mmu_context(&svm->vcpu);
> -	}
>   
>   	/* Load the nested guest state */
>   	svm->vmcb->save.es = nested_vmcb->save.es;
> @@ -275,25 +292,15 @@ void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
>   	svm->vcpu.arch.dr6  = nested_vmcb->save.dr6;
>   	svm->vmcb->save.cpl = nested_vmcb->save.cpl;
>   
> -	svm->nested.vmcb_msrpm = nested_vmcb->control.msrpm_base_pa & ~0x0fffULL;
> -	svm->nested.vmcb_iopm  = nested_vmcb->control.iopm_base_pa  & ~0x0fffULL;
> -
> -	/* cache intercepts */
> -	svm->nested.intercept_cr         = nested_vmcb->control.intercept_cr;
> -	svm->nested.intercept_dr         = nested_vmcb->control.intercept_dr;
> -	svm->nested.intercept_exceptions = nested_vmcb->control.intercept_exceptions;
> -	svm->nested.intercept            = nested_vmcb->control.intercept;
> -
>   	svm_flush_tlb(&svm->vcpu);
> -	svm->vmcb->control.int_ctl = nested_vmcb->control.int_ctl | V_INTR_MASKING_MASK;
>   	if (nested_vmcb->control.int_ctl & V_INTR_MASKING_MASK)
>   		svm->vcpu.arch.hflags |= HF_VINTR_MASK;
>   	else
>   		svm->vcpu.arch.hflags &= ~HF_VINTR_MASK;
>   
> -	svm->vcpu.arch.tsc_offset += nested_vmcb->control.tsc_offset;
>   	svm->vmcb->control.tsc_offset = svm->vcpu.arch.tsc_offset;
>   
> +	svm->vmcb->control.int_ctl = nested_vmcb->control.int_ctl | V_INTR_MASKING_MASK;
>   	svm->vmcb->control.virt_ext = nested_vmcb->control.virt_ext;
>   	svm->vmcb->control.int_vector = nested_vmcb->control.int_vector;
>   	svm->vmcb->control.int_state = nested_vmcb->control.int_state;
> @@ -314,8 +321,6 @@ void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
>   	 */
>   	recalc_intercepts(svm);
>   
> -	svm->nested.vmcb = vmcb_gpa;
> -
>   	/*
>   	 * If L1 had a pending IRQ/NMI before executing VMRUN,
>   	 * which wasn't delivered because it was disallowed (e.g.
