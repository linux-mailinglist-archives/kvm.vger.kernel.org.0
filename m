Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88FC43785F
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 17:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729519AbfFFPnh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 11:43:37 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:38461 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729484AbfFFPng (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 11:43:36 -0400
Received: by mail-ed1-f65.google.com with SMTP id g13so4011554edu.5
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 08:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ixpXgehxdk/xrX3Zfkopy1jBsTZOhciw9P2upjHwTFs=;
        b=bdtu4a9Q4sbt1fmMjOQb9SCERZdCrxtavkwN4UfYuPFAB0th8HHu0u1R3JWXLWY7S0
         nS7TOyJeUZvuSt/jP370kzxSenX98z3Uk0wwhCR7Yj5StaTtuqtd+ZRgVIoOeK9AJ3+h
         yyELBLMkn0QHIlfDfp6ysvUL/IcNiZBpM8s41cyKFkjf5rS9eVwelgsk76bkUwhEOeL3
         6Z2KzKitUDlzZlnJUPVQdIUA2PMJuNt23IpHRKol+jzsSHkfBG6naTwtUCAIxs19oOwV
         LSKbhsC1FtH3l8/Q9SOHvK6uOzlTrWPw5fi/bQciDNgqtZGU5fQZ82dAJiEHN/qgyWAm
         m90g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=ixpXgehxdk/xrX3Zfkopy1jBsTZOhciw9P2upjHwTFs=;
        b=UXxOgQa1bXCxDc012wk+2RGfWO3bOFtZODvbXoYI60+EPnTDcL38D8D+4kyTAAVuoc
         dluutRW7M/kz85rM2YjAoIhwvuH6FyD2InZikRj3SIkm/1jZGSHkTTFkPzm6H03dwr80
         PlZJtLPkqZJc5y8mzXtlIY+tTG7ykdcClTIQxSZ5Yh1RR5azvmcZZ+ogC1MioT63edce
         PrmruEFt1vGVd3GxdL54GIruXNnRDLf8DVwQDSoDmSZV8jEV5CyDWrDEZOvpVu4ILY7n
         UtMb6au1JNfSJfd8zp8WZ6ZTeILmvKr1hptWNurtxZqJ7R+AYsWkWszi45tZn98FF6fM
         McEg==
X-Gm-Message-State: APjAAAWKDpQrGqt2T3w/B4fjTFnVbGzbOdVKk4HF7vAYB2f5tk88Iwj4
        cOY2xXtoNy6WKljLSXfnTivBX4cS
X-Google-Smtp-Source: APXvYqwrmGq+mAV3g+N31FXfoZJFxjsu18sadWkHwVIKk81SgL35mLFVm5+7cwMBkNs0WHe6Ui+Nuw==
X-Received: by 2002:a17:906:5855:: with SMTP id h21mr9660750ejs.15.1559835815272;
        Thu, 06 Jun 2019 08:43:35 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id k21sm386352ejk.86.2019.06.06.08.43.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Jun 2019 08:43:34 -0700 (PDT)
Date:   Thu, 6 Jun 2019 15:43:33 +0000
From:   Wei Yang <richard.weiyang@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wei Yang <richardw.yang@linux.intel.com>, kvm@vger.kernel.org,
        x86@kernel.org, rkrcmar@redhat.com
Subject: Re: [PATCH 2/3] kvm: x86: use same convention to name
 apic_clear_vector()
Message-ID: <20190606154333.id2i5ylqeyewyl3m@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20190401021723.5682-1-richardw.yang@linux.intel.com>
 <20190401021723.5682-2-richardw.yang@linux.intel.com>
 <718538a4-4c46-85c7-1388-deabc9dc2514@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <718538a4-4c46-85c7-1388-deabc9dc2514@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 06, 2019 at 02:07:39PM +0200, Paolo Bonzini wrote:
>On 01/04/19 04:17, Wei Yang wrote:
>> apic_clear_vector() is the counterpart of kvm_lapic_clear_vector(),
>> while they have different naming convention.
>> 
>> Rename it and move together to arch/x86/kvm/lapic.h. Also fix one typo
>> in comment by hand.
>
>You mean "of kvm_lapic_set_vector()".  Queued all three with only this
>change to the commit log, sorry for the delay.
>

Thanks :-)

>Paolo
>
>> Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
>> ---
>>  arch/x86/kvm/lapic.c | 17 +++++++----------
>>  arch/x86/kvm/lapic.h |  5 +++++
>>  2 files changed, 12 insertions(+), 10 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>> index c4533d05c214..d8b3cbba8e29 100644
>> --- a/arch/x86/kvm/lapic.c
>> +++ b/arch/x86/kvm/lapic.c
>> @@ -88,11 +88,6 @@ bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector)
>>  		apic_test_vector(vector, apic->regs + APIC_IRR);
>>  }
>>  
>> -static inline void apic_clear_vector(int vec, void *bitmap)
>> -{
>> -	clear_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
>> -}
>> -
>>  static inline int __apic_test_and_set_vector(int vec, void *bitmap)
>>  {
>>  	return __test_and_set_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
>> @@ -445,12 +440,12 @@ static inline void apic_clear_irr(int vec, struct kvm_lapic *apic)
>>  
>>  	if (unlikely(vcpu->arch.apicv_active)) {
>>  		/* need to update RVI */
>> -		apic_clear_vector(vec, apic->regs + APIC_IRR);
>> +		kvm_lapic_clear_vector(vec, apic->regs + APIC_IRR);
>>  		kvm_x86_ops->hwapic_irr_update(vcpu,
>>  				apic_find_highest_irr(apic));
>>  	} else {
>>  		apic->irr_pending = false;
>> -		apic_clear_vector(vec, apic->regs + APIC_IRR);
>> +		kvm_lapic_clear_vector(vec, apic->regs + APIC_IRR);
>>  		if (apic_search_irr(apic) != -1)
>>  			apic->irr_pending = true;
>>  	}
>> @@ -1053,9 +1048,11 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
>>  
>>  		if (apic_test_vector(vector, apic->regs + APIC_TMR) != !!trig_mode) {
>>  			if (trig_mode)
>> -				kvm_lapic_set_vector(vector, apic->regs + APIC_TMR);
>> +				kvm_lapic_set_vector(vector,
>> +						     apic->regs + APIC_TMR);
>>  			else
>> -				apic_clear_vector(vector, apic->regs + APIC_TMR);
>> +				kvm_lapic_clear_vector(vector,
>> +						       apic->regs + APIC_TMR);
>>  		}
>>  
>>  		if (vcpu->arch.apicv_active)
>> @@ -2278,7 +2275,7 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu)
>>  
>>  	/*
>>  	 * APIC is created enabled. This will prevent kvm_lapic_set_base from
>> -	 * thinking that APIC satet has changed.
>> +	 * thinking that APIC state has changed.
>>  	 */
>>  	vcpu->arch.apic_base = MSR_IA32_APICBASE_ENABLE;
>>  	static_key_slow_inc(&apic_sw_disabled.key); /* sw disabled at reset */
>> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
>> index ff6ef9c3d760..339ee029be6e 100644
>> --- a/arch/x86/kvm/lapic.h
>> +++ b/arch/x86/kvm/lapic.h
>> @@ -127,6 +127,11 @@ void kvm_lapic_exit(void);
>>  #define VEC_POS(v) ((v) & (32 - 1))
>>  #define REG_POS(v) (((v) >> 5) << 4)
>>  
>> +static inline void kvm_lapic_clear_vector(int vec, void *bitmap)
>> +{
>> +	clear_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
>> +}
>> +
>>  static inline void kvm_lapic_set_vector(int vec, void *bitmap)
>>  {
>>  	set_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
>> 

-- 
Wei Yang
Help you, Help me
