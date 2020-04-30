Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCF41BF97E
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 15:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgD3N2y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 09:28:54 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:40658 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726893AbgD3N2y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Apr 2020 09:28:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588253333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VVwLcanbkWVkF6qlI7rC+oUg9XLivUoMR67GxaygdkY=;
        b=Hz+TAxp16ptoGELvbWD2aWiDGadPSBFyUl8zx7ZMN72SL/6N2ZS83R29+iBSOhRDUPghxw
        rgRtPQ5UKgwUNaFVeYw9u+zPk7yCsaysitbnqeTx6nhU4OqFozOA4trqp9T37Lv/1XibKV
        0QNTAV5waP68hnCtJCN5otYoeZuol4Y=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301--Ht1VSCVMXCgQdXhHb5vBQ-1; Thu, 30 Apr 2020 09:28:49 -0400
X-MC-Unique: -Ht1VSCVMXCgQdXhHb5vBQ-1
Received: by mail-wr1-f71.google.com with SMTP id q10so3854692wrv.10
        for <kvm@vger.kernel.org>; Thu, 30 Apr 2020 06:28:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=VVwLcanbkWVkF6qlI7rC+oUg9XLivUoMR67GxaygdkY=;
        b=U04JITZTaUQlJRNzORsBDDRyQhGTAaTYS6bZQNRIsVV6BUwxj/Mi5befNRlhNPcKzQ
         9zEs7R0QLGERKfw2BwszDRbUQ67BPLYvT3e2ItDh7IVSvqOtGb5zfSGdPPrCoW2KC6Wc
         AyAKTS0HT23AOh//JqgYOPlPZu+4WJ5QJEZZBW5h9KEhc1/xyvNSS4SkAJ2q+Qlrw5PU
         vK8I6qxPQY9pWpTarMR8c8vHKFOdf+KOZZb3YQYsIbWWnWnrnhYBRJJBxcNDCIKnM78u
         K+CBtnaW9JssC+1AdrQ+hwByvG62yoZHpAaUVM6fWPHzhH9aPRwIh6ON0WRp7ndinvGi
         tXYg==
X-Gm-Message-State: AGi0PuYYuNYcaUHqNyPzU3zkTmASCTg+gTvfYhSf6RPu6xqoECNmRxBg
        xJx689+KNhXdVUp0bhQ/A4QWz0BEvACGU/Sf38XME+tLHVY6LEWV3VFrM0UuMVU2hB5NILovmm8
        ZUwjZj7O1PfgU
X-Received: by 2002:a1c:4d17:: with SMTP id o23mr2897976wmh.47.1588253328325;
        Thu, 30 Apr 2020 06:28:48 -0700 (PDT)
X-Google-Smtp-Source: APiQypLHXE43WEEUcWxoJTXG/Jv5eHHkkREsDic3prcg6FMi61efPU1/eDH+n3AzPm5hqVof0AbtCg==
X-Received: by 2002:a1c:4d17:: with SMTP id o23mr2897954wmh.47.1588253328047;
        Thu, 30 Apr 2020 06:28:48 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id n6sm11982145wmc.28.2020.04.30.06.28.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 06:28:47 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Subject: Re: [PATCH v4 1/7] KVM: VMX: Introduce generic fastpath handler
In-Reply-To: <1588055009-12677-2-git-send-email-wanpengli@tencent.com>
References: <1588055009-12677-1-git-send-email-wanpengli@tencent.com> <1588055009-12677-2-git-send-email-wanpengli@tencent.com>
Date:   Thu, 30 Apr 2020 15:28:46 +0200
Message-ID: <87ees5f6gh.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wanpeng Li <kernellwp@gmail.com> writes:

> From: Wanpeng Li <wanpengli@tencent.com>
>
> Introduce generic fastpath handler to handle MSR fastpath, VMX-preemption
> timer fastpath etc, move it after vmx_complete_interrupts() in order that
> later patch can catch the case vmexit occurred while another event was
> being delivered to guest. There is no obversed performance difference for
> IPI fastpath testing after this move.
>
> Tested-by: Haiwei Li <lihaiwei@tencent.com>
> Cc: Haiwei Li <lihaiwei@tencent.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 3ab6ca6..9b5adb4 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6583,6 +6583,20 @@ void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
>  	}
>  }
>  
> +static enum exit_fastpath_completion vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
> +{
> +	if (!is_guest_mode(vcpu)) {

Nitpick: do we actually expect to have any fastpath handlers anytime
soon? If not, we could've written this as

	if (is_guest_mode(vcpu))
		return EXIT_FASTPATH_NONE;

and save on identation)

> +		switch (to_vmx(vcpu)->exit_reason) {
> +		case EXIT_REASON_MSR_WRITE:
> +			return handle_fastpath_set_msr_irqoff(vcpu);
> +		default:
> +			return EXIT_FASTPATH_NONE;
> +		}
> +	}
> +
> +	return EXIT_FASTPATH_NONE;
> +}
> +
>  bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
>  
>  static enum exit_fastpath_completion vmx_vcpu_run(struct kvm_vcpu *vcpu)
> @@ -6757,17 +6771,14 @@ static enum exit_fastpath_completion vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  	if (unlikely(vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
>  		return EXIT_FASTPATH_NONE;
>  
> -	if (!is_guest_mode(vcpu) && vmx->exit_reason == EXIT_REASON_MSR_WRITE)
> -		exit_fastpath = handle_fastpath_set_msr_irqoff(vcpu);
> -	else
> -		exit_fastpath = EXIT_FASTPATH_NONE;
> -
>  	vmx->loaded_vmcs->launched = 1;
>  	vmx->idt_vectoring_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
>  
>  	vmx_recover_nmi_blocking(vmx);
>  	vmx_complete_interrupts(vmx);
>  
> +	exit_fastpath = vmx_exit_handlers_fastpath(vcpu);
> +
>  	return exit_fastpath;
>  }

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

