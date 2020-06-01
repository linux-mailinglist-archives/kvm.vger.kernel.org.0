Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7474F1E9BB3
	for <lists+kvm@lfdr.de>; Mon,  1 Jun 2020 04:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgFAC0l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 May 2020 22:26:41 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48500 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725953AbgFAC0l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 May 2020 22:26:41 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0512KAIW157651;
        Mon, 1 Jun 2020 02:26:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=3op1Z5m27SJuiJ7sCOR05G2Br09w4TM7ZfeVl/DbPQc=;
 b=GI7UU2H2n6IDKas9tpBfEdmL4RvRdHCdIuUM2frPUQW1VjQ7SEdillEJTll1MlLYX1MG
 Bn3cm9KrcrskhYiSfMSUC7eu8wNdh4CQ8RiMGfL3lCZGdoN2gC9TKkaQ650KnAGKI8pW
 kz8PhNoI1JCZU5cQN5a4soUDcSf5T6IkJsU1oJ7D8gMko4prpLXrdQirxVdVlmSJxb6P
 YQ/9MYf3zcLnuClPZrI3DisDeSJS2Xn5e+Gf+ht+otdR90pgONgacYSgVbnquW+81cFp
 fE2Pdj0iqdLF0If21G4oGe2hbStANuw+PGkLs803ucVyrSBHxeh3YkBvC3cBC0rLQflP gA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 31bewqmf4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 01 Jun 2020 02:26:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0512Hs8L001453;
        Mon, 1 Jun 2020 02:26:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 31c18qr6sa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jun 2020 02:26:37 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0512QaBB029436;
        Mon, 1 Jun 2020 02:26:36 GMT
Received: from localhost.localdomain (/10.159.229.17)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 31 May 2020 19:26:35 -0700
Subject: Re: [PATCH 25/30] KVM: nSVM: leave guest mode when clearing EFER.SVME
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200529153934.11694-1-pbonzini@redhat.com>
 <20200529153934.11694-26-pbonzini@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <da854e9e-b305-b938-68f6-995bcc80ffd1@oracle.com>
Date:   Sun, 31 May 2020 19:26:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200529153934.11694-26-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9638 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006010017
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9638 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 bulkscore=0
 phishscore=0 suspectscore=0 impostorscore=0 cotscore=-2147483648
 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006010017
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/29/20 8:39 AM, Paolo Bonzini wrote:
> According to the AMD manual, the effect of turning off EFER.SVME while a
> guest is running is undefined.  We make it leave guest mode immediately,
> similar to the effect of clearing the VMX bit in MSR_IA32_FEAT_CTL.


I see that svm_set_efer() is called in enter_svm_guest_mode() and 
nested_svm_vmexit(). In the VMRUN path, we have already checked 
EFER.SVME in nested_vmcb_checks(). So if it was not set, we wouldn't 
come to enter_svm_guest_mode(). Your fix is only for the #VMEXIT path then ?

>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/svm/nested.c | 16 ++++++++++++++++
>   arch/x86/kvm/svm/svm.c    | 10 ++++++++--
>   arch/x86/kvm/svm/svm.h    |  1 +
>   3 files changed, 25 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index bd3a89cd4070..369eca73fe3e 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -618,6 +618,22 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>   	return 0;
>   }
>   
> +/*
> + * Forcibly leave nested mode in order to be able to reset the VCPU later on.
> + */
> +void svm_leave_nested(struct vcpu_svm *svm)
> +{
> +	if (is_guest_mode(&svm->vcpu)) {
> +		struct vmcb *hsave = svm->nested.hsave;
> +		struct vmcb *vmcb = svm->vmcb;
> +
> +		svm->nested.nested_run_pending = 0;
> +		leave_guest_mode(&svm->vcpu);
> +		copy_vmcb_control_area(&vmcb->control, &hsave->control);
> +		nested_svm_uninit_mmu_context(&svm->vcpu);
> +	}
> +}
> +
>   static int nested_svm_exit_handled_msr(struct vcpu_svm *svm)
>   {
>   	u32 offset, msr, value;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index bc08221f6743..b4db9a980469 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -265,6 +265,7 @@ static int get_npt_level(struct kvm_vcpu *vcpu)
>   
>   void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
>   {
> +	struct vcpu_svm *svm = to_svm(vcpu);
>   	vcpu->arch.efer = efer;
>   
>   	if (!npt_enabled) {
> @@ -275,8 +276,13 @@ void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
>   			efer &= ~EFER_LME;
>   	}
>   
> -	to_svm(vcpu)->vmcb->save.efer = efer | EFER_SVME;
> -	mark_dirty(to_svm(vcpu)->vmcb, VMCB_CR);
> +	if (!(efer & EFER_SVME)) {
> +		svm_leave_nested(svm);
> +		svm_set_gif(svm, true);
> +	}
> +
> +	svm->vmcb->save.efer = efer | EFER_SVME;
> +	mark_dirty(svm->vmcb, VMCB_CR);
>   }
>   
>   static int is_external_interrupt(u32 info)
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index be8e830f83fa..6ac4c00a5d82 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -389,6 +389,7 @@ static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
>   
>   void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
>   			  struct vmcb *nested_vmcb);
> +void svm_leave_nested(struct vcpu_svm *svm);
>   int nested_svm_vmrun(struct vcpu_svm *svm);
>   void nested_svm_vmloadsave(struct vmcb *from_vmcb, struct vmcb *to_vmcb);
>   int nested_svm_vmexit(struct vcpu_svm *svm);
