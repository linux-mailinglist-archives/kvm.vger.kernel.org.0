Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E962F58A147
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 21:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239098AbiHDTb7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 15:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233660AbiHDTb5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 15:31:57 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87E6175BD
        for <kvm@vger.kernel.org>; Thu,  4 Aug 2022 12:31:55 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id q7so856587ljp.13
        for <kvm@vger.kernel.org>; Thu, 04 Aug 2022 12:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=chkiXuTSMte5/THSO1tKei1y+9khIVgeexFrnoY+bEQ=;
        b=eRQtWhnDrpUQxTRxk74hhVpjgWMp66pOQsJ5r2WONBpJj4FuwPSv4IZeuBwPkYATDM
         CsON1/KkYaNL8vB/+uLkaJImNlniLAroOrxN589qcDVEwBXoAQL0dCR9ZW6QvgC4/A16
         3/pmQOoBcuIhdHsIFh0Vr50UF2T6C/HXkgirCLP+eGQvO1HPC7KVT2qhjrSqsI1SbafK
         4Fn1AdyAxbbB/qJkHgofF4AXnKfItvAccMh72hSznZWlwFztGeF0xb7niju22v6cJyih
         LehffY7OiQglwW3QsUUARwKXl0QxeKib7P7ZeN+Le6WXIcl19XzgOn+rXX7d2zlvEFdy
         coKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=chkiXuTSMte5/THSO1tKei1y+9khIVgeexFrnoY+bEQ=;
        b=7FGWd7MsCknsQ56q6x1y/zhcJTq3IvaGMTbB/gFTOxPKFfT9hz7gnQMyyVO/PSIeK3
         obXG95+JOamKGsaLnkGfMzjk5PVUhsGjmwW9AMfRHiC+/id8dkL96kFBs/5y5O4AMmFg
         fPxdTTFIb5ow/KVhu4p6PluQcKmpaUwdUL4jrAn86Mp579LardOYQwoyLCWkEfudv8JR
         LUlVfSqvKDraUphrUPnwj1MmtWV2KLKXleQ4+iZ11rSc+vqGhU96zQ/iWlA+VnpKJXCX
         SwqS/JZRP6lFkZpgTrT0POz6xhg764yLDKTeznrogJpwI8Mcd0MxzKnchQ5XN+wxd5ue
         HNCg==
X-Gm-Message-State: ACgBeo3XH+YR1wDB+vpibUwj0axj5pux5vRXUivn3NxD8X7LNlfB0Cyc
        kJNQOXbZ0gaeKSekNZgZ+FhyTw==
X-Google-Smtp-Source: AA6agR5FBNHMWUF39W4eHNXQwadDmXYbh6xjHi7hmIYySZLly6YhNzTJWxBc2WinoFioVm2jq4OlPg==
X-Received: by 2002:a2e:a7cf:0:b0:25d:9fe6:7065 with SMTP id x15-20020a2ea7cf000000b0025d9fe67065mr1076334ljp.138.1659641513943;
        Thu, 04 Aug 2022 12:31:53 -0700 (PDT)
Received: from [10.43.1.253] ([83.142.187.84])
        by smtp.gmail.com with ESMTPSA id z5-20020a05651c11c500b0025e505fef30sm209203ljo.63.2022.08.04.12.31.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Aug 2022 12:31:53 -0700 (PDT)
Message-ID: <47623b4c-5067-b882-01aa-41455f1c3c3f@semihalf.com>
Date:   Thu, 4 Aug 2022 21:31:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 2/3] KVM: x86: Add kvm_irq_is_masked()
Content-Language: en-US
To:     eric.auger@redhat.com, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Rong L Liu <rong.l.liu@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Dmitry Torokhov <dtor@google.com>
References: <20220715155928.26362-1-dmy@semihalf.com>
 <20220715155928.26362-3-dmy@semihalf.com>
 <06cdd944-a00c-9dea-192f-7d6156e487fb@redhat.com>
From:   Dmytro Maluka <dmy@semihalf.com>
In-Reply-To: <06cdd944-a00c-9dea-192f-7d6156e487fb@redhat.com>
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

Hi Eric,

On 8/4/22 19:14, Eric Auger wrote:
> Hi Dmytro
> 
> On 7/15/22 17:59, Dmytro Maluka wrote:
>> In order to implement postponing resamplefd event until an interrupt is
>> unmasked, we need not only to track changes of the interrupt mask state
>> (which is made possible by the previous patch "KVM: x86: Move
>> kvm_(un)register_irq_mask_notifier() to generic KVM") but also to know
>> its initial mask state at the time of registering a resamplefd
> it is not obvious to me why the vIRQ is supposed to be masked at
> resamplefd registration time. I would have expected the check to be done
> in the resamplefd notifier instead (when the vEOI actually happens)?

Great point, thanks. Indeed, it's not crucial to know the vIRQ mask
state at the registration time. It might be ok to check it later, at the
first vEOI after registration. So the wording should be changed to
"...but also to know its initial mask state before any mask notifier has
fired".

As I wrote in [1], the initialization of the mask state in this patchset
is actually racy (we may miss mask state change at initialization), and
I was about to send v2 which fixes this race by implementing
kvm_register_and_fire_irq_mask_notifier() as suggested in [1]. Now your
suggestion has made me think wouldn't it be possible to avoid this race
in a simpler way, by checking the vIRQ state directly in the ack (vEOI)
notifier.

It seems it still would be racy, e.g.:

1. ack notifier checks the vIRQ state, it is masked
2. the vIRQ gets unmasked
3. mask notifier fires, but the vIRQ is not flagged as postponed yet, so
   mask notifier doesn't notify resamplefd
4. ack notifier flags the vIRQ as postponed and doesn't notify
   resamplefd either

=> unmask event lost => the physical IRQ is not unmasked by vfio.

This race could be avoided if the ack notifier checked the vIRQ state
under resampler->lock, i.e. synchronized with the mask notifier. But
that would deadlock, for the same reason as mentioned in [1]: checking
the vIRQ state requires locking KVM irqchip lock (e.g. ioapic->lock on
x86) whereas the mask notifier is called under this lock.

[1] https://lore.kernel.org/lkml/c7b7860e-ae3a-7b98-e97e-28a62470c470@semihalf.com/

Thanks,
Dmytro

> 
> Eric
>> listener. So implement kvm_irq_is_masked() for that.
>>
>> Actually, for now it's implemented for x86 only (see below).
>>
>> The implementation is trickier than I'd like it to be, for 2 reasons:
>>
>> 1. Interrupt (GSI) to irqchip pin mapping is not a 1:1 mapping: an IRQ
>>    may map to multiple pins on different irqchips. I guess the only
>>    reason for that is to support x86 interrupts 0-15 for which we don't
>>    know if the guest uses PIC or IOAPIC. For this reason kvm_set_irq()
>>    delivers interrupt to both, assuming the guest will ignore the
>>    unused one. For the same reason, in kvm_irq_is_masked() we should
>>    also take into account the mask state of both irqchips. We consider
>>    an interrupt unmasked if and only if it is unmasked in at least one
>>    of PIC or IOAPIC, assuming that in the unused one all the interrupts
>>    should be masked.
>>
>> 2. For now ->is_masked() implemented for x86 only, so need to handle
>>    the case when ->is_masked() is not provided by the irqchip. In such
>>    case kvm_irq_is_masked() returns failure, and its caller may fall
>>    back to an assumption that an interrupt is always unmasked.
>>
>> Link: https://lore.kernel.org/kvm/31420943-8c5f-125c-a5ee-d2fde2700083@semihalf.com/
>> Signed-off-by: Dmytro Maluka <dmy@semihalf.com>
>> ---
>>  arch/x86/include/asm/kvm_host.h |  1 +
>>  arch/x86/kvm/i8259.c            | 11 +++++++++++
>>  arch/x86/kvm/ioapic.c           | 11 +++++++++++
>>  arch/x86/kvm/ioapic.h           |  1 +
>>  arch/x86/kvm/irq_comm.c         | 16 ++++++++++++++++
>>  include/linux/kvm_host.h        |  3 +++
>>  virt/kvm/irqchip.c              | 34 +++++++++++++++++++++++++++++++++
>>  7 files changed, 77 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 39a867d68721..64618b890700 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1840,6 +1840,7 @@ static inline int __kvm_irq_line_state(unsigned long *irq_state,
>>  
>>  int kvm_pic_set_irq(struct kvm_pic *pic, int irq, int irq_source_id, int level);
>>  void kvm_pic_clear_all(struct kvm_pic *pic, int irq_source_id);
>> +bool kvm_pic_irq_is_masked(struct kvm_pic *pic, int irq);
>>  
>>  void kvm_inject_nmi(struct kvm_vcpu *vcpu);
>>  
>> diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
>> index e1bb6218bb96..2d1ed3bc7cc5 100644
>> --- a/arch/x86/kvm/i8259.c
>> +++ b/arch/x86/kvm/i8259.c
>> @@ -211,6 +211,17 @@ void kvm_pic_clear_all(struct kvm_pic *s, int irq_source_id)
>>  	pic_unlock(s);
>>  }
>>  
>> +bool kvm_pic_irq_is_masked(struct kvm_pic *s, int irq)
>> +{
>> +	bool ret;
>> +
>> +	pic_lock(s);
>> +	ret = !!(s->pics[irq >> 3].imr & (1 << irq));
>> +	pic_unlock(s);
>> +
>> +	return ret;
>> +}
>> +
>>  /*
>>   * acknowledge interrupt 'irq'
>>   */
>> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
>> index 765943d7cfa5..874f68a65c87 100644
>> --- a/arch/x86/kvm/ioapic.c
>> +++ b/arch/x86/kvm/ioapic.c
>> @@ -478,6 +478,17 @@ void kvm_ioapic_clear_all(struct kvm_ioapic *ioapic, int irq_source_id)
>>  	spin_unlock(&ioapic->lock);
>>  }
>>  
>> +bool kvm_ioapic_irq_is_masked(struct kvm_ioapic *ioapic, int irq)
>> +{
>> +	bool ret;
>> +
>> +	spin_lock(&ioapic->lock);
>> +	ret = !!ioapic->redirtbl[irq].fields.mask;
>> +	spin_unlock(&ioapic->lock);
>> +
>> +	return ret;
>> +}
>> +
>>  static void kvm_ioapic_eoi_inject_work(struct work_struct *work)
>>  {
>>  	int i;
>> diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
>> index 539333ac4b38..fe1f51319992 100644
>> --- a/arch/x86/kvm/ioapic.h
>> +++ b/arch/x86/kvm/ioapic.h
>> @@ -114,6 +114,7 @@ void kvm_ioapic_destroy(struct kvm *kvm);
>>  int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int irq_source_id,
>>  		       int level, bool line_status);
>>  void kvm_ioapic_clear_all(struct kvm_ioapic *ioapic, int irq_source_id);
>> +bool kvm_ioapic_irq_is_masked(struct kvm_ioapic *ioapic, int irq);
>>  void kvm_get_ioapic(struct kvm *kvm, struct kvm_ioapic_state *state);
>>  void kvm_set_ioapic(struct kvm *kvm, struct kvm_ioapic_state *state);
>>  void kvm_ioapic_scan_entry(struct kvm_vcpu *vcpu,
>> diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
>> index 43e13892ed34..5bff6d6ac54f 100644
>> --- a/arch/x86/kvm/irq_comm.c
>> +++ b/arch/x86/kvm/irq_comm.c
>> @@ -34,6 +34,13 @@ static int kvm_set_pic_irq(struct kvm_kernel_irq_routing_entry *e,
>>  	return kvm_pic_set_irq(pic, e->irqchip.pin, irq_source_id, level);
>>  }
>>  
>> +static bool kvm_is_masked_pic_irq(struct kvm_kernel_irq_routing_entry *e,
>> +				     struct kvm *kvm)
>> +{
>> +	struct kvm_pic *pic = kvm->arch.vpic;
>> +	return kvm_pic_irq_is_masked(pic, e->irqchip.pin);
>> +}
>> +
>>  static int kvm_set_ioapic_irq(struct kvm_kernel_irq_routing_entry *e,
>>  			      struct kvm *kvm, int irq_source_id, int level,
>>  			      bool line_status)
>> @@ -43,6 +50,13 @@ static int kvm_set_ioapic_irq(struct kvm_kernel_irq_routing_entry *e,
>>  				line_status);
>>  }
>>  
>> +static bool kvm_is_masked_ioapic_irq(struct kvm_kernel_irq_routing_entry *e,
>> +				     struct kvm *kvm)
>> +{
>> +	struct kvm_ioapic *ioapic = kvm->arch.vioapic;
>> +	return kvm_ioapic_irq_is_masked(ioapic, e->irqchip.pin);
>> +}
>> +
>>  int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
>>  		struct kvm_lapic_irq *irq, struct dest_map *dest_map)
>>  {
>> @@ -275,11 +289,13 @@ int kvm_set_routing_entry(struct kvm *kvm,
>>  			if (ue->u.irqchip.pin >= PIC_NUM_PINS / 2)
>>  				return -EINVAL;
>>  			e->set = kvm_set_pic_irq;
>> +			e->is_masked = kvm_is_masked_pic_irq;
>>  			break;
>>  		case KVM_IRQCHIP_IOAPIC:
>>  			if (ue->u.irqchip.pin >= KVM_IOAPIC_NUM_PINS)
>>  				return -EINVAL;
>>  			e->set = kvm_set_ioapic_irq;
>> +			e->is_masked = kvm_is_masked_ioapic_irq;
>>  			break;
>>  		default:
>>  			return -EINVAL;
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index 9e12ef503157..e8bfb3b0d4d1 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -625,6 +625,8 @@ struct kvm_kernel_irq_routing_entry {
>>  	int (*set)(struct kvm_kernel_irq_routing_entry *e,
>>  		   struct kvm *kvm, int irq_source_id, int level,
>>  		   bool line_status);
>> +	bool (*is_masked)(struct kvm_kernel_irq_routing_entry *e,
>> +			  struct kvm *kvm);
>>  	union {
>>  		struct {
>>  			unsigned irqchip;
>> @@ -1598,6 +1600,7 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *irq_entry, struct kvm *kvm,
>>  int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
>>  			       struct kvm *kvm, int irq_source_id,
>>  			       int level, bool line_status);
>> +int kvm_irq_is_masked(struct kvm *kvm, int irq, bool *masked);
>>  bool kvm_irq_has_notifier(struct kvm *kvm, unsigned irqchip, unsigned pin);
>>  void kvm_notify_acked_gsi(struct kvm *kvm, int gsi);
>>  void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin);
>> diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
>> index 58e4f88b2b9f..9252ebedba55 100644
>> --- a/virt/kvm/irqchip.c
>> +++ b/virt/kvm/irqchip.c
>> @@ -97,6 +97,40 @@ int kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level,
>>  	return ret;
>>  }
>>  
>> +/*
>> + * Return value:
>> + *  = 0   Interrupt mask state successfully written to `masked`
>> + *  < 0   Failed to read interrupt mask state
>> + */
>> +int kvm_irq_is_masked(struct kvm *kvm, int irq, bool *masked)
>> +{
>> +	struct kvm_kernel_irq_routing_entry irq_set[KVM_NR_IRQCHIPS];
>> +	int ret = -1, i, idx;
>> +
>> +	/* Not possible to detect if the guest uses the PIC or the
>> +	 * IOAPIC. So assume the interrupt to be unmasked iff it is
>> +	 * unmasked in at least one of both.
>> +	 */
>> +	idx = srcu_read_lock(&kvm->irq_srcu);
>> +	i = kvm_irq_map_gsi(kvm, irq_set, irq);
>> +	srcu_read_unlock(&kvm->irq_srcu, idx);
>> +
>> +	while (i--) {
>> +		if (!irq_set[i].is_masked)
>> +			continue;
>> +
>> +		if (!irq_set[i].is_masked(&irq_set[i], kvm)) {
>> +			*masked = false;
>> +			return 0;
>> +		}
>> +		ret = 0;
>> +	}
>> +	if (!ret)
>> +		*masked = true;
>> +
>> +	return ret;
>> +}
>> +
>>  static void free_irq_routing_table(struct kvm_irq_routing_table *rt)
>>  {
>>  	int i;
> 
