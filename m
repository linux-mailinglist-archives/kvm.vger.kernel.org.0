Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B94D02DECA0
	for <lists+kvm@lfdr.de>; Sat, 19 Dec 2020 02:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbgLSBWH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Dec 2020 20:22:07 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58202 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725879AbgLSBWG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Dec 2020 20:22:06 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BJ1LL4i001525;
        Sat, 19 Dec 2020 01:21:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=hQSO5MFu84N3VcFSgjhzMr8qzFutIrqWQP36+NliQiE=;
 b=vc1Xz9hWJZUCDpU2JLXohRyIJMMmC/D3iTKszPjw1zdDER1ZEnyIeQcS/ibsNg8Nk1YK
 56Mca4BlcTtdWcxmPNoa6y/302E7QAnbs/6snorBze5fNigACL/txyAgyfl4FVfJl9Jl
 O2U3+uGYyJGz1D5yZpd5qFbiBwTwVK8GWL3KaYziuWewlW0qfGpvN0xezu34VedmOlIb
 Vv7lSPHTY3LwzZKUiot/PgHhWZ+r2lEZQSM+C10wfstqq2ae/2pgRMPrauxW6v+KsDxD
 Q8BI35eguPCfGBRZyZm1EOVKqCTf5cnrmNMJGbbX01+MGhFPleKUoOPp6npF1tkh5SZZ zA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 35cntmmrew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 19 Dec 2020 01:21:21 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BJ1BZIK088210;
        Sat, 19 Dec 2020 01:19:20 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 35h7j905tg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Dec 2020 01:19:20 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BJ1JJ5A003382;
        Sat, 19 Dec 2020 01:19:19 GMT
Received: from localhost.localdomain (/10.159.251.245)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Dec 2020 17:19:19 -0800
Subject: Re: [PATCH] KVM/x86: Move definition of __ex to x86.h
To:     Uros Bizjak <ubizjak@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <20201218121146.432286-1-ubizjak@gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <030d8d0a-5315-8e4b-6a15-0149ca527d6b@oracle.com>
Date:   Fri, 18 Dec 2020 17:19:18 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201218121146.432286-1-ubizjak@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9839 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012190002
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9839 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 priorityscore=1501 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012190003
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/18/20 4:11 AM, Uros Bizjak wrote:
> Merge __kvm_handle_fault_on_reboot with its sole user
> and move the definition of __ex to a common include to be
> shared between VMX and SVM.
>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 25 -------------------------
>   arch/x86/kvm/svm/svm.c          |  2 --
>   arch/x86/kvm/vmx/vmx_ops.h      |  4 +---
>   arch/x86/kvm/x86.h              | 23 +++++++++++++++++++++++
>   4 files changed, 24 insertions(+), 30 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 7e5f33a0d0e2..ff152ee1d63f 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1623,31 +1623,6 @@ enum {
>   #define kvm_arch_vcpu_memslots_id(vcpu) ((vcpu)->arch.hflags & HF_SMM_MASK ? 1 : 0)
>   #define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, (role).smm)
>   
> -asmlinkage void kvm_spurious_fault(void);
> -
> -/*
> - * Hardware virtualization extension instructions may fault if a
> - * reboot turns off virtualization while processes are running.
> - * Usually after catching the fault we just panic; during reboot
> - * instead the instruction is ignored.
> - */
> -#define __kvm_handle_fault_on_reboot(insn)				\
> -	"666: \n\t"							\
> -	insn "\n\t"							\
> -	"jmp	668f \n\t"						\
> -	"667: \n\t"							\
> -	"1: \n\t"							\
> -	".pushsection .discard.instr_begin \n\t"			\
> -	".long 1b - . \n\t"						\
> -	".popsection \n\t"						\
> -	"call	kvm_spurious_fault \n\t"				\
> -	"1: \n\t"							\
> -	".pushsection .discard.instr_end \n\t"				\
> -	".long 1b - . \n\t"						\
> -	".popsection \n\t"						\
> -	"668: \n\t"							\
> -	_ASM_EXTABLE(666b, 667b)
> -
>   #define KVM_ARCH_WANT_MMU_NOTIFIER
>   int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end,
>   			unsigned flags);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index da7eb4aaf44f..0a72ab9fd568 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -42,8 +42,6 @@
>   
>   #include "svm.h"
>   
> -#define __ex(x) __kvm_handle_fault_on_reboot(x)
> -
>   MODULE_AUTHOR("Qumranet");
>   MODULE_LICENSE("GPL");
>   
> diff --git a/arch/x86/kvm/vmx/vmx_ops.h b/arch/x86/kvm/vmx/vmx_ops.h
> index 692b0c31c9c8..7e3cb53c413f 100644
> --- a/arch/x86/kvm/vmx/vmx_ops.h
> +++ b/arch/x86/kvm/vmx/vmx_ops.h
> @@ -4,13 +4,11 @@
>   
>   #include <linux/nospec.h>
>   
> -#include <asm/kvm_host.h>
>   #include <asm/vmx.h>
>   
>   #include "evmcs.h"
>   #include "vmcs.h"
> -
> -#define __ex(x) __kvm_handle_fault_on_reboot(x)
> +#include "x86.h"
>   
>   asmlinkage void vmread_error(unsigned long field, bool fault);
>   __attribute__((regparm(0))) void vmread_error_trampoline(unsigned long field,
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index e7ca622a468f..608548d05e84 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -7,6 +7,29 @@
>   #include "kvm_cache_regs.h"
>   #include "kvm_emulate.h"
>   
> +asmlinkage void kvm_spurious_fault(void);
> +
> +/*
> + * Hardware virtualization extension instructions may fault if a
> + * reboot turns off virtualization while processes are running.
> + * Usually after catching the fault we just panic; during reboot
> + * instead the instruction is ignored.
> + */
> +#define __ex(insn)							\
> +	"666:	" insn "\n"						\
> +	"	jmp 669f\n"						\
> +	"667:\n"							\
> +	".pushsection .discard.instr_begin\n"				\
> +	".long 667b - .\n"						\
> +	".popsection\n"							\
> +	"	call kvm_spurious_fault\n"				\
> +	"668:\n"							\
> +	".pushsection .discard.instr_end\n"				\
> +	".long 668b - .\n"						\
> +	".popsection\n"							\
> +	"669:\n"							\
> +	_ASM_EXTABLE(666b, 667b)
> +
>   #define KVM_DEFAULT_PLE_GAP		128
>   #define KVM_VMX_DEFAULT_PLE_WINDOW	4096
>   #define KVM_DEFAULT_PLE_WINDOW_GROW	2
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
