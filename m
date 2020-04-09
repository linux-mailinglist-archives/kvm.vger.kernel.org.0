Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5334D1A36AB
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 17:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbgDIPLo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 11:11:44 -0400
Received: from mga06.intel.com ([134.134.136.31]:24351 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727771AbgDIPLo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 11:11:44 -0400
IronPort-SDR: /qoGiB1+2QpQamRwhfQUIFwsW8f1PXjXZAT6aDSFzMQKrVHaQ7mZZYqB2b3mOBpLMUreCXKygz
 BzROQlQqL9UA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2020 08:11:44 -0700
IronPort-SDR: qG/AYRPADEt8r5ODXW9eM+5VLXLyc6hSD5gzAlNfxXMSv8Ikm5PYjTu7CA9sMoOpnJzSEl5AwV
 BRPQdxFCjrbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,363,1580803200"; 
   d="scan'208";a="275841956"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.249.170.160]) ([10.249.170.160])
  by fmsmga004.fm.intel.com with ESMTP; 09 Apr 2020 08:11:42 -0700
Reply-To: like.xu@intel.com
Subject: Re: [PATCH] KVM: SVM: Fix __svm_vcpu_run declaration.
To:     Uros Bizjak <ubizjak@gmail.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>
References: <20200409114926.1407442-1-ubizjak@gmail.com>
From:   "Xu, Like" <like.xu@intel.com>
Organization: Intel OTC
Message-ID: <0ee54833-bbed-4263-7c7e-4091ab956168@intel.com>
Date:   Thu, 9 Apr 2020 23:11:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200409114926.1407442-1-ubizjak@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Bizjak,

On 2020/4/9 19:49, Uros Bizjak wrote:
> The function returns no value.
>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Fixes: 199cd1d7b534 ("KVM: SVM: Split svm_vcpu_run inline assembly to separate file")
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> ---
>   arch/x86/kvm/svm/svm.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 2be5bbae3a40..061d19e69c73 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3276,7 +3276,7 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
>   	svm_complete_interrupts(svm);
>   }
>   
> -bool __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs);
Just curious if __svm_vcpu_run() will fail to enter SVM guest mode,
and a return value could indicate that nothing went wrong rather than 
blindly keeping silent.

Thanks,
Like Xu
> +void __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs);
>   
>   static void svm_vcpu_run(struct kvm_vcpu *vcpu)
>   {

