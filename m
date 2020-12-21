Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE8792E0246
	for <lists+kvm@lfdr.de>; Mon, 21 Dec 2020 23:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725857AbgLUWBu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Dec 2020 17:01:50 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45576 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgLUWBu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Dec 2020 17:01:50 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BLM0aZf006003;
        Mon, 21 Dec 2020 22:01:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=IUDum7Iftk3vCWLh9vZ+ATGTWj3sEfpON7UvtTKL1i8=;
 b=BgAd/k8A0quJzuKj3+ahQOtX99bpAeUfW70OjVJMxqPA8Jqu/a/REGR75CZ7r7+XgF03
 8DbxK6/5nXs3wAmqvKSsR4g6StcYE4Mm3yHpnPIWGfjnjmHOum1yYnw1unlbK8jrfNcI
 8m48rgdfPmi6/p+BCl8pe1W9Kj2S9Kgb9oKzXKJw9vedlpFeGReKzFZ9WgA9t5sHy/fG
 SR2w03jBArL4Kw1V42U0+yG7rdzbzSNLsNSCJPxULvrxEZdhsBthE7rfca2oqQ8DgO4+
 UPgAuHVR7mXvBA0ozNyDNh4hTDDIcmcKYGSrV+qtHlMnVKltO/L5WTvX0Oqp28iyiDtL hw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 35k0d88wgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 21 Dec 2020 22:01:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BLLpWvG155381;
        Mon, 21 Dec 2020 22:01:02 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 35k0e09mfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Dec 2020 22:01:02 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BLM11qV031167;
        Mon, 21 Dec 2020 22:01:01 GMT
Received: from localhost.localdomain (/10.159.138.233)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Dec 2020 14:01:01 -0800
Subject: Re: [PATCH v3] KVM/x86: Move definition of __ex to x86.h
To:     Uros Bizjak <ubizjak@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <20201221194800.46962-1-ubizjak@gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <a773afca-7f28-2392-74ad-0895da3f75ca@oracle.com>
Date:   Mon, 21 Dec 2020 14:00:52 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201221194800.46962-1-ubizjak@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9842 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 phishscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012210146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9842 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 priorityscore=1501
 impostorscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012210147
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/21/20 11:48 AM, Uros Bizjak wrote:
> Merge __kvm_handle_fault_on_reboot with its sole user
> and move the definition of __ex to a common include to be
> shared between VMX and SVM.
>
> v2: Rebase to the latest kvm/queue.
>
> v3: Incorporate changes from review comments.
>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 25 -------------------------
>   arch/x86/kvm/svm/sev.c          |  2 --
>   arch/x86/kvm/svm/svm.c          |  2 --
>   arch/x86/kvm/vmx/vmx.c          |  4 +---
>   arch/x86/kvm/vmx/vmx_ops.h      |  4 +---
>   arch/x86/kvm/x86.h              | 24 ++++++++++++++++++++++++
>   6 files changed, 26 insertions(+), 35 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 39707e72b062..a78e4b1a5d77 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1634,31 +1634,6 @@ enum {
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
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index e57847ff8bd2..ba492b6d37a0 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -25,8 +25,6 @@
>   #include "cpuid.h"
>   #include "trace.h"
>   
> -#define __ex(x) __kvm_handle_fault_on_reboot(x)
> -
>   static u8 sev_enc_bit;
>   static int sev_flush_asids(void);
>   static DECLARE_RWSEM(sev_deactivate_lock);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 941e5251e13f..733d9f98a121 100644
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
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 75c9c6a0a3a4..b82f2689f2d7 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2320,9 +2320,7 @@ static void vmclear_local_loaded_vmcss(void)
>   }
>   
>   
> -/* Just like cpu_vmxoff(), but with the __kvm_handle_fault_on_reboot()
> - * tricks.
> - */
> +/* Just like cpu_vmxoff(), but with the fault handling. */
>   static void kvm_cpu_vmxoff(void)
>   {
>   	asm volatile (__ex("vmxoff"));
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
> index c5ee0f5ce0f1..5b16d2b5c3bc 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -8,6 +8,30 @@
>   #include "kvm_cache_regs.h"
>   #include "kvm_emulate.h"
>   
> +asmlinkage void kvm_spurious_fault(void);
> +
> +/*
> + * Handle a fault on a hardware virtualization (VMX or SVM) instruction.
> + *
> + * Hardware virtualization extension instructions may fault if a reboot turns
> + * off virtualization while processes are running.  Usually after catching the
> + * fault we just panic; during reboot instead the instruction is ignored.
> + */
> +#define __ex(insn)							\


While the previous name was too elaborate, this new name is very 
cryptic.  Unless we are saving for space, it's better to give a somewhat 
descriptive name.

> +	"666:	" insn "\n"						\
> +	"	jmp 669f\n"						\
> +	"667:\n"							\
> +	"	.pushsection .discard.instr_begin\n"			\
> +	"	.long 667b - .\n"					\
> +	"	.popsection\n"						\
> +	"	call kvm_spurious_fault\n"				\
> +	"668:\n"							\
> +	"	.pushsection .discard.instr_end\n"			\
> +	"	.long 668b - .\n"					\
> +	"	.popsection\n"						\
> +	"669:\n"							\
> +	_ASM_EXTABLE(666b, 667b)
> +
>   #define KVM_DEFAULT_PLE_GAP		128
>   #define KVM_VMX_DEFAULT_PLE_WINDOW	4096
>   #define KVM_DEFAULT_PLE_WINDOW_GROW	2
