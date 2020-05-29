Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1CE1E865B
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 20:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgE2SMP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 14:12:15 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52826 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbgE2SMP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 14:12:15 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04TI8QI7006208;
        Fri, 29 May 2020 18:12:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=S98gm6cT5SWlh+pmaMxolbZnVPW8GSsrajHvDFaOYpk=;
 b=TyBlkNkEOQwfQ5W+2eHSvfBpoAljR81TLe+7zFjEtEhom6FYg7HbXDXbMj4N6v+9b3A7
 30wuWBrecF8gWZ62mW0KPe0TogZeK1sNnFAg3UfOH15Dn6x+rYdYF3DcUcs86LKNQHFa
 5QtafdMrd440ilkfM/+zuBzFWwg2bqlshorGk6LRsKeNnZJGi4bd1XIfa1dYtn4uIXpb
 sNdmhUc2eK0TEKJVF6BGRtfhsyR1oU2s0CL/ByLOk4q3CjQWOnUQwEGwlmA29pn8kd6r
 2UByzyIZ2QjQ92p+zGPtcRTagK1G8jImGAKeKzsyXGnLLnn4pHxbLjm09QD1LA1mM6QO zw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 318xe1ushn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 29 May 2020 18:12:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04TI9BO1081806;
        Fri, 29 May 2020 18:10:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 317ddurrhf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 May 2020 18:10:11 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04TIABnN019156;
        Fri, 29 May 2020 18:10:11 GMT
Received: from localhost.localdomain (/10.159.246.35)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 29 May 2020 11:10:11 -0700
Subject: Re: [PATCH 08/30] KVM: nSVM: move map argument out of
 enter_svm_guest_mode
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200529153934.11694-1-pbonzini@redhat.com>
 <20200529153934.11694-9-pbonzini@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <f7946509-ff69-03e3-ec43-90a04714afe3@oracle.com>
Date:   Fri, 29 May 2020 11:10:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200529153934.11694-9-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9636 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 phishscore=0 adultscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005290137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9636 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 cotscore=-2147483648 mlxscore=0 bulkscore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 impostorscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005290137
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/29/20 8:39 AM, Paolo Bonzini wrote:
> Unmapping the nested VMCB in enter_svm_guest_mode is a bit of a wart,
> since the map is not used elsewhere in the function.  There are
> just two calls, so move it there.


The last sentence sounds bit incomplete.

Also, does it make sense to mention the reason why unmapping is not 
required before we enter guest mode ?

>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/svm/nested.c | 14 ++++++--------
>   arch/x86/kvm/svm/svm.c    |  3 ++-
>   arch/x86/kvm/svm/svm.h    |  2 +-
>   3 files changed, 9 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 8756c9f463fd..8e98d5e420a5 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -229,7 +229,7 @@ static bool nested_vmcb_checks(struct vmcb *vmcb)
>   }
>   
>   void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
> -			  struct vmcb *nested_vmcb, struct kvm_host_map *map)
> +			  struct vmcb *nested_vmcb)
>   {
>   	bool evaluate_pending_interrupts =
>   		is_intercept(svm, INTERCEPT_VINTR) ||
> @@ -304,8 +304,6 @@ void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
>   	svm->vmcb->control.pause_filter_thresh =
>   		nested_vmcb->control.pause_filter_thresh;
>   
> -	kvm_vcpu_unmap(&svm->vcpu, map, true);
> -
>   	/* Enter Guest-Mode */
>   	enter_guest_mode(&svm->vcpu);
>   
> @@ -368,10 +366,7 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
>   		nested_vmcb->control.exit_code_hi = 0;
>   		nested_vmcb->control.exit_info_1  = 0;
>   		nested_vmcb->control.exit_info_2  = 0;
> -
> -		kvm_vcpu_unmap(&svm->vcpu, &map, true);
> -
> -		return ret;
> +		goto out;
>   	}
>   
>   	trace_kvm_nested_vmrun(svm->vmcb->save.rip, vmcb_gpa,
> @@ -414,7 +409,7 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
>   	copy_vmcb_control_area(hsave, vmcb);
>   
>   	svm->nested.nested_run_pending = 1;
> -	enter_svm_guest_mode(svm, vmcb_gpa, nested_vmcb, &map);
> +	enter_svm_guest_mode(svm, vmcb_gpa, nested_vmcb);
>   
>   	if (!nested_svm_vmrun_msrpm(svm)) {
>   		svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
> @@ -425,6 +420,9 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
>   		nested_svm_vmexit(svm);
>   	}
>   
> +out:
> +	kvm_vcpu_unmap(&svm->vcpu, &map, true);
> +
>   	return ret;
>   }
>   
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index feb96a410f2d..76b3f553815e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3814,7 +3814,8 @@ static int svm_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
>   		if (kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(vmcb), &map) == -EINVAL)
>   			return 1;
>   		nested_vmcb = map.hva;
> -		enter_svm_guest_mode(svm, vmcb, nested_vmcb, &map);
> +		enter_svm_guest_mode(svm, vmcb, nested_vmcb);
> +		kvm_vcpu_unmap(&svm->vcpu, &map, true);
>   	}
>   	return 0;
>   }
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 89fab75dd4f5..33e3f09d7a8e 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -395,7 +395,7 @@ static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
>   }
>   
>   void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
> -			  struct vmcb *nested_vmcb, struct kvm_host_map *map);
> +			  struct vmcb *nested_vmcb);
>   int nested_svm_vmrun(struct vcpu_svm *svm);
>   void nested_svm_vmloadsave(struct vmcb *from_vmcb, struct vmcb *to_vmcb);
>   int nested_svm_vmexit(struct vcpu_svm *svm);
