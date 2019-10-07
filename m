Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E23FFCE0FC
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2019 13:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727580AbfJGL55 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Oct 2019 07:57:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40152 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727554AbfJGL55 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Oct 2019 07:57:57 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DB8FAC0495A1
        for <kvm@vger.kernel.org>; Mon,  7 Oct 2019 11:57:55 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id o128so409985wmo.1
        for <kvm@vger.kernel.org>; Mon, 07 Oct 2019 04:57:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YrxF1/4HajPgR+xeq6q6rAZJgqX9N62r+CkH+L1AyJc=;
        b=Fzqc2Ct/4iWAgr/xQ+fiIltaz2nnPOTyjOOydk7BAtEB/kceIhxSuBIvVqNDsVduRy
         HVwIqMtJ4WvPvSZw4AplYP59NOnf71J4nrahk73crtyqkunf0nioNoqX7K4cg2ibc4ea
         Jb3i+mxT99ZN3VelTlz0e11c+JOHJEqkd5Hy+49XhQSmppd3M8C/1WP6xt+qj4iY6kVL
         tA927sC4s/EgZeGpF6N4YOjXSh7qw+eTIyrJYzKAZGcrgcsJhZvI7TwHsimm5UrvODx5
         ULnnctAQlX7lqfA9wuePxLW/Ec1F06oB5YYVu6rtxq3RBGdf7gy0/sRX2HttnhqD0n/r
         0KaQ==
X-Gm-Message-State: APjAAAWBcp7na6/0wv078gUXsF5lyV/6N0dW2iROhOc0HwlWAsg0y/fS
        Otqb4vSvHg4JP7H3zDzhmkcLhMpkKXDGxGiI4m2zog0wWxIOR2lYb83dLRdx6PRsUvbXFjq0KAH
        WE+LymTcSPf8h
X-Received: by 2002:a1c:5fd6:: with SMTP id t205mr19990748wmb.124.1570449474492;
        Mon, 07 Oct 2019 04:57:54 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz5Fqt3SdQFDKAvmwLezrPzgfekV57+TAB8Po1qVS2eG/v58soOnt//sbyMAOb6mrdQYDXvng==
X-Received: by 2002:a1c:5fd6:: with SMTP id t205mr19990733wmb.124.1570449474146;
        Mon, 07 Oct 2019 04:57:54 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9dd9:ce92:89b5:d1f2? ([2001:b07:6468:f312:9dd9:ce92:89b5:d1f2])
        by smtp.gmail.com with ESMTPSA id a4sm13317431wmm.10.2019.10.07.04.57.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2019 04:57:53 -0700 (PDT)
Subject: Re: [PATCH] KVM: VMX: Refactor to not compare set PI control bits
 directly to 1
To:     Liran Alon <liran.alon@oracle.com>, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Krish Sadhukhan <krish.sadhukhan@oracle.com>
References: <20191001005408.129099-1-liran.alon@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <41e58834-9951-344c-0312-372ef6a62ae7@redhat.com>
Date:   Mon, 7 Oct 2019 13:57:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191001005408.129099-1-liran.alon@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/10/19 02:54, Liran Alon wrote:
> This is a pure code refactoring.
> No semantic change is expected.
> 
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)

I'm not sure this is an improvement, for two reasons:

1) the "dy" in vmx_dy_apicv_has_pending_interrupt callback is meant for
directed yield, so it's a bit ugly to call it from wakeup_handler.

2) the wakeup_handler is an interrupt handler specific to posted
interrupts, so it makes sense to check the posted interrupts descriptor.

I wouldn't say ON is a control bit in fact (unlike for example SN or
NV), since it is written by the processor or IOMMU rather than the
hypervisor.

Paolo

> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index e31317fc8c95..92eb4910fe9f 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5302,6 +5302,11 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
>  	}
>  }
>  
> +static bool vmx_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu)
> +{
> +	return pi_test_on(vcpu_to_pi_desc(vcpu));
> +}
> +
>  /*
>   * Handler for POSTED_INTERRUPT_WAKEUP_VECTOR.
>   */
> @@ -5313,9 +5318,7 @@ static void wakeup_handler(void)
>  	spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
>  	list_for_each_entry(vcpu, &per_cpu(blocked_vcpu_on_cpu, cpu),
>  			blocked_vcpu_list) {
> -		struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
> -
> -		if (pi_test_on(pi_desc) == 1)
> +		if (vmx_dy_apicv_has_pending_interrupt(vcpu))
>  			kvm_vcpu_kick(vcpu);
>  	}
>  	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
> @@ -6168,11 +6171,6 @@ static int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
>  	return max_irr;
>  }
>  
> -static bool vmx_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu)
> -{
> -	return pi_test_on(vcpu_to_pi_desc(vcpu));
> -}
> -
>  static void vmx_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
>  {
>  	if (!kvm_vcpu_apicv_active(vcpu))
> @@ -7336,7 +7334,7 @@ static int pi_pre_block(struct kvm_vcpu *vcpu)
>  	do {
>  		old.control = new.control = pi_desc->control;
>  
> -		WARN((pi_desc->sn == 1),
> +		WARN(pi_desc->sn,
>  		     "Warning: SN field of posted-interrupts "
>  		     "is set before blocking\n");
>  
> @@ -7361,7 +7359,7 @@ static int pi_pre_block(struct kvm_vcpu *vcpu)
>  			   new.control) != old.control);
>  
>  	/* We should not block the vCPU if an interrupt is posted for it.  */
> -	if (pi_test_on(pi_desc) == 1)
> +	if (pi_test_on(pi_desc))
>  		__pi_post_block(vcpu);
>  
>  	local_irq_enable();
> 

