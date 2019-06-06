Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3D06373CA
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 14:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbfFFMHm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 08:07:42 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42894 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbfFFMHm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 08:07:42 -0400
Received: by mail-wr1-f65.google.com with SMTP id x17so2139150wrl.9
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 05:07:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zDvAESwq5FtIcWNFWlFLMYfgJLZwPLcdhWPzpCJue9A=;
        b=CFq0uUh/wejXwv+Z1x4l/sOybmHZL8Akg8swdjRXJzTlluHRFQKeGvHfd3yfFoh7kW
         pNptxeBpE6cTg6Amxoua6KYHDQkdTKA8jyjq1LcqEHkvkoY3z2uLM9ppyFADMCKC2EiX
         wHetDzzaoUhCPFc1mTdWBHBC44n4GgXKyj7aw2aXDsMfmqldNgstvXcKYlwutx7j2ZBj
         4+i6I5ZgWdU30UjOcth1RUxME8Lvz1ROYVAVBzf90ov2lv3l6i76G/tMONH3F3tN3xyg
         2P57cZS8A25zi9iqWKDJRtDOPcR8Fn0mvbB+kHRViQoMwT76en1GsMSsIAQqjHj6FXm7
         UIGQ==
X-Gm-Message-State: APjAAAVmoeRzyw/ZkS87k0WMoCUlGKYNseCJDLJBLu30kqu+j6ZvfSN+
        uC2sNofFhCymFmYIyadk5kBOUcsI0Jw=
X-Google-Smtp-Source: APXvYqwZWDCeTjUpYBjP+MMFOds2hpEv9ry2lZbU3azHSG7iYjvZiz+8Rn/8xBs8uzcxZFmaT2oJ8w==
X-Received: by 2002:a5d:554b:: with SMTP id g11mr15003877wrw.10.1559822860572;
        Thu, 06 Jun 2019 05:07:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id p2sm2030904wrx.90.2019.06.06.05.07.39
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 05:07:40 -0700 (PDT)
Subject: Re: [PATCH 2/3] kvm: x86: use same convention to name
 apic_clear_vector()
To:     Wei Yang <richardw.yang@linux.intel.com>, kvm@vger.kernel.org,
        x86@kernel.org
Cc:     rkrcmar@redhat.com
References: <20190401021723.5682-1-richardw.yang@linux.intel.com>
 <20190401021723.5682-2-richardw.yang@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <718538a4-4c46-85c7-1388-deabc9dc2514@redhat.com>
Date:   Thu, 6 Jun 2019 14:07:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190401021723.5682-2-richardw.yang@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/04/19 04:17, Wei Yang wrote:
> apic_clear_vector() is the counterpart of kvm_lapic_clear_vector(),
> while they have different naming convention.
> 
> Rename it and move together to arch/x86/kvm/lapic.h. Also fix one typo
> in comment by hand.

You mean "of kvm_lapic_set_vector()".  Queued all three with only this
change to the commit log, sorry for the delay.

Paolo

> Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
> ---
>  arch/x86/kvm/lapic.c | 17 +++++++----------
>  arch/x86/kvm/lapic.h |  5 +++++
>  2 files changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index c4533d05c214..d8b3cbba8e29 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -88,11 +88,6 @@ bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector)
>  		apic_test_vector(vector, apic->regs + APIC_IRR);
>  }
>  
> -static inline void apic_clear_vector(int vec, void *bitmap)
> -{
> -	clear_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
> -}
> -
>  static inline int __apic_test_and_set_vector(int vec, void *bitmap)
>  {
>  	return __test_and_set_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
> @@ -445,12 +440,12 @@ static inline void apic_clear_irr(int vec, struct kvm_lapic *apic)
>  
>  	if (unlikely(vcpu->arch.apicv_active)) {
>  		/* need to update RVI */
> -		apic_clear_vector(vec, apic->regs + APIC_IRR);
> +		kvm_lapic_clear_vector(vec, apic->regs + APIC_IRR);
>  		kvm_x86_ops->hwapic_irr_update(vcpu,
>  				apic_find_highest_irr(apic));
>  	} else {
>  		apic->irr_pending = false;
> -		apic_clear_vector(vec, apic->regs + APIC_IRR);
> +		kvm_lapic_clear_vector(vec, apic->regs + APIC_IRR);
>  		if (apic_search_irr(apic) != -1)
>  			apic->irr_pending = true;
>  	}
> @@ -1053,9 +1048,11 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
>  
>  		if (apic_test_vector(vector, apic->regs + APIC_TMR) != !!trig_mode) {
>  			if (trig_mode)
> -				kvm_lapic_set_vector(vector, apic->regs + APIC_TMR);
> +				kvm_lapic_set_vector(vector,
> +						     apic->regs + APIC_TMR);
>  			else
> -				apic_clear_vector(vector, apic->regs + APIC_TMR);
> +				kvm_lapic_clear_vector(vector,
> +						       apic->regs + APIC_TMR);
>  		}
>  
>  		if (vcpu->arch.apicv_active)
> @@ -2278,7 +2275,7 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu)
>  
>  	/*
>  	 * APIC is created enabled. This will prevent kvm_lapic_set_base from
> -	 * thinking that APIC satet has changed.
> +	 * thinking that APIC state has changed.
>  	 */
>  	vcpu->arch.apic_base = MSR_IA32_APICBASE_ENABLE;
>  	static_key_slow_inc(&apic_sw_disabled.key); /* sw disabled at reset */
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index ff6ef9c3d760..339ee029be6e 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -127,6 +127,11 @@ void kvm_lapic_exit(void);
>  #define VEC_POS(v) ((v) & (32 - 1))
>  #define REG_POS(v) (((v) >> 5) << 4)
>  
> +static inline void kvm_lapic_clear_vector(int vec, void *bitmap)
> +{
> +	clear_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
> +}
> +
>  static inline void kvm_lapic_set_vector(int vec, void *bitmap)
>  {
>  	set_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
> 

