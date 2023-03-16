Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6D096BDAA6
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 22:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjCPVNh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 17:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjCPVNf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 17:13:35 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69139C48A4
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 14:13:32 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id br6so4039472lfb.11
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 14:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google; t=1679001210;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EZht2X58FgZjJc2UYyPMsew0vdOtQyEdYhQD5ePFyeY=;
        b=IuhuF8emKVnSAPRznRMDaFZODFCKL53aYJpjmZ7NFHz5J5zA29z4a8s8rUPjcZGcQh
         C9NF9EPE44m0W/Ft3tAvtusJykH+abcbpxMNvVFItLWa4kDgGU5GdQdceuyzXM5e3GJQ
         0zZbG/9gWQk0uB955rHAZRJdEf7Q8xRpbqCAqPu/KQWZBCd7FvY5cMPRHVv111QIHc9D
         EnSNA1RkO0Lf/mmUwqvHQhdw9jlvDhHls84CIt1oJ7A8I4o8d5hX5+QRfRUiE1ccFA0Y
         4JXNaXJ8rrrpnfO2O64nMdaKMdn/jOGs9B4IXLx4SMprRx6nYVJipFkX3m93mZn9DUhZ
         yT9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679001210;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EZht2X58FgZjJc2UYyPMsew0vdOtQyEdYhQD5ePFyeY=;
        b=xeJuhu6kw/X+HxWLL4I2XxVO2E+zDUArBVwVVbxp7r8SoKdm0u8yEf0PztfqEUVJZo
         n4cUL9eZNJLfd+HNobrNaLygv3zHhuvtyJ5+iTDojD8RgcauuRLCevfv2B4kcVqf64OO
         AVdel7frnkk9iXbKANg9qfTVl7KrGHYgBSnE5J2RorqQnSZLkT1zBkuTIezRdBKQ3JEJ
         2tCOZ6V3/hU7hbS7/JHLM8eraHK8/lVKcD0chvHVTGLIf52a6pFq7dLGP7oiyQyfwUsZ
         k8ps/EAwbQPrDorMupzQ5+25dWrRvSUJ4md3j+WaCU74GiDtHKERkwMndy7Tz2g/hT7Y
         3yfg==
X-Gm-Message-State: AO0yUKVJWQd+Xb3CtyyLEWrV2q2jwwq3ha99AhmnOihmvbsTugYizmfh
        lYutsg+buTh9LM5LxN0ALaRcDQ==
X-Google-Smtp-Source: AK7set9fMZrUVLJxQXI2GiQnpXFYqdAVAbHHMzkXfn2vcuZHQEhw9Nf409kV6vWz3A0lPxM1zNr7BA==
X-Received: by 2002:ac2:5988:0:b0:4e0:54a3:4b3b with SMTP id w8-20020ac25988000000b004e054a34b3bmr3725955lfn.69.1679001210600;
        Thu, 16 Mar 2023 14:13:30 -0700 (PDT)
Received: from [10.43.1.252] ([83.142.187.84])
        by smtp.gmail.com with ESMTPSA id g5-20020a19ee05000000b004d783b0d310sm41042lfb.307.2023.03.16.14.13.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 14:13:30 -0700 (PDT)
Message-ID: <9ee7d5e3-2273-4aa7-6859-a5f82c82c34c@semihalf.com>
Date:   Thu, 16 Mar 2023 22:13:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v3 2/2] KVM: x86/ioapic: Resample the pending state of an
 IRQ when unmasking
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Rong L Liu <rong.l.liu@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>, upstream@semihalf.com,
        Dmitry Torokhov <dtor@google.com>,
        Eddie Dong <eddie.dong@intel.com>
References: <20220818202701.3314045-1-dmy@semihalf.com>
 <20220818202701.3314045-3-dmy@semihalf.com> <ZBJfuOOioFb0pVB6@google.com>
Content-Language: en-US
From:   Dmytro Maluka <dmy@semihalf.com>
In-Reply-To: <ZBJfuOOioFb0pVB6@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On 3/16/23 01:16, Sean Christopherson wrote:
> Looks sane to me, just a bunch of cosmetic comments.  But this really needs input/review
> from others.  I/O APIC and level triggered interrupts are not exactly in my wheelhouse.

Ok, sure. All of your cosmetic suggestions below sound good to me.

> 
> On Thu, Aug 18, 2022, Dmytro Maluka wrote:
>> ---
>>  arch/x86/kvm/ioapic.c    | 36 ++++++++++++++++++++++++++++++++++--
>>  include/linux/kvm_host.h |  8 ++++++++
>>  virt/kvm/eventfd.c       | 39 +++++++++++++++++++++++++++++++++------
>>  3 files changed, 75 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
>> index 765943d7cfa5..da7074d9b04e 100644
>> --- a/arch/x86/kvm/ioapic.c
>> +++ b/arch/x86/kvm/ioapic.c
>> @@ -368,8 +368,40 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
>>  		if (mask_before != mask_after)
>>  			kvm_fire_mask_notifiers(ioapic->kvm, KVM_IRQCHIP_IOAPIC, index, mask_after);
>>  		if (e->fields.trig_mode == IOAPIC_LEVEL_TRIG
>> -		    && ioapic->irr & (1 << index))
>> -			ioapic_service(ioapic, index, false);
>> +		    && ioapic->irr & (1 << index)
>> +		    && !e->fields.mask
>> +		    && !e->fields.remote_irr) {
> 
> Can you opportunistically change these to fit the preferred style of putting the &&
> on the previous line?  Ignore the file's existing "style", this crud is ancient and
> ugly (this goes for all of my comments).
> 
>> @@ -1987,6 +1988,13 @@ static inline int kvm_irqfd(struct kvm *kvm, struct kvm_irqfd *args)
>>  }
>>  
>>  static inline void kvm_irqfd_release(struct kvm *kvm) {}
>> +
>> +static inline bool kvm_notify_irqfd_resampler(struct kvm *kvm,
>> +					      unsigned irqchip,
>> +					      unsigned pin)
> 
> "unsigned int" instead of bare "unsigned"
> 
>> +{
>> +	return false;
>> +}
>>  #endif
>>  
>>  #else
>> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
>> index 61aea70dd888..71f327019f1e 100644
>> --- a/virt/kvm/eventfd.c
>> +++ b/virt/kvm/eventfd.c
>> @@ -55,6 +55,16 @@ irqfd_inject(struct work_struct *work)
>>  			    irqfd->gsi, 1, false);
>>  }
>>  
>> +/* Called within kvm->irq_srcu read side. */
> 
> Ne need for the comment, let lockdep do the heavy lifting.
> 
>> +static void __irqfd_resampler_notify(struct kvm_kernel_irqfd_resampler *resampler)
> 
> I don't see a need for the double underscores.  I assume the idea is to convey
> that this is called under kvm->irq_srcu, but I just ended up looking for a version
> without the underscores.
> 
>> +{
>> +	struct kvm_kernel_irqfd *irqfd;
>> +
>> +	list_for_each_entry_srcu(irqfd, &resampler->list, resampler_link,
>> +	    srcu_read_lock_held(&resampler->kvm->irq_srcu))
> 
> Align the indentation, i.e.
> 
> 	struct kvm_kernel_irqfd *irqfd;
> 
> 	list_for_each_entry_srcu(irqfd, &resampler->list, resampler_link,
> 				 srcu_read_lock_held(&resampler->kvm->irq_srcu))
> 		eventfd_signal(irqfd->resamplefd, 1);
> 
>> @@ -648,6 +653,28 @@ void kvm_irq_routing_update(struct kvm *kvm)
>>  	spin_unlock_irq(&kvm->irqfds.lock);
>>  }
>>  
>> +bool kvm_notify_irqfd_resampler(struct kvm *kvm, unsigned irqchip, unsigned pin)
>> +{
>> +	struct kvm_kernel_irqfd_resampler *resampler;
>> +	int gsi, idx;
>> +
>> +	idx = srcu_read_lock(&kvm->irq_srcu);
>> +	gsi = kvm_irq_map_chip_pin(kvm, irqchip, pin);
>> +	if (gsi != -1)
> 
> This if-statement needs curly braces, the exemption doesn't apply if there are
> multiple blocks? (can't think of the right name at the moment) in the guts of
> the if-statement.
> 
>> +		list_for_each_entry_srcu(resampler,
>> +					 &kvm->irqfds.resampler_list, link,
>> +					 srcu_read_lock_held(&kvm->irq_srcu)) {
>> +			if (resampler->notifier.gsi == gsi) {
>> +				__irqfd_resampler_notify(resampler);
>> +				srcu_read_unlock(&kvm->irq_srcu, idx);
>> +				return true;
>> +			}
>> +		}
>> +	srcu_read_unlock(&kvm->irq_srcu, idx);
>> +
>> +	return false;
>> +}
>> +
>>  /*
>>   * create a host-wide workqueue for issuing deferred shutdown requests
>>   * aggregated from all vm* instances. We need our own isolated
>> -- 
>> 2.37.1.595.g718a3a8f04-goog
>>
