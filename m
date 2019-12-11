Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84C7611B51E
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 16:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732413AbfLKPv4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 10:51:56 -0500
Received: from mga18.intel.com ([134.134.136.126]:5282 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730499AbfLKPvy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 10:51:54 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Dec 2019 07:51:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,301,1571727600"; 
   d="scan'208";a="225568792"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 11 Dec 2019 07:51:51 -0800
Date:   Wed, 11 Dec 2019 07:51:51 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 6/6] KVM: Fix some writing mistakes
Message-ID: <20191211155151.GB5044@linux.intel.com>
References: <1576045585-8536-1-git-send-email-linmiaohe@huawei.com>
 <1576045585-8536-7-git-send-email-linmiaohe@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1576045585-8536-7-git-send-email-linmiaohe@huawei.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 11, 2019 at 02:26:25PM +0800, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> Fix some writing mistakes in the comments.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 2 +-
>  arch/x86/kvm/vmx/vmx.c          | 2 +-
>  virt/kvm/kvm_main.c             | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 159a28512e4c..efba864ed42d 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -606,7 +606,7 @@ struct kvm_vcpu_arch {
>  	 * Paging state of an L2 guest (used for nested npt)
>  	 *
>  	 * This context will save all necessary information to walk page tables
> -	 * of the an L2 guest. This context is only initialized for page table
> +	 * of the L2 guest. This context is only initialized for page table

I'd whack "the" instead of "and", i.e. ...walk page tables of an L2 guest,
as KVM isn't limited to just one L2 guest.

>  	 * walking and not for faulting since we never handle l2 page faults on

While you're here, want to change "l2" to "L2"?

>  	 * the host.
>  	 */
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 1be3854f1090..dae712c8785e 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1922,7 +1922,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  }
>  
>  /*
> - * Writes msr value into into the appropriate "register".
> + * Writes msr value into the appropriate "register".
>   * Returns 0 on success, non-0 otherwise.
>   * Assumes vcpu_load() was already called.
>   */
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index f0501272268f..1a6d5ebd5c42 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1519,7 +1519,7 @@ static inline int check_user_page_hwpoison(unsigned long addr)
>  /*
>   * The fast path to get the writable pfn which will be stored in @pfn,
>   * true indicates success, otherwise false is returned.  It's also the
> - * only part that runs if we can are in atomic context.
> + * only part that runs if we can in atomic context.

This should remove "can" instead of "are", i.e. ...part that runs if we are
in atomic context.  The comment is calling out that hva_to_pfn() will return
immediately if hva_to_pfn_fast() and the kernel is atomic context.

>   */
>  static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
>  			    bool *writable, kvm_pfn_t *pfn)
> -- 
> 2.19.1
> 
