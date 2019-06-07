Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4854338A86
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 14:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbfFGMoo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 08:44:44 -0400
Received: from foss.arm.com ([217.140.110.172]:39482 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727102AbfFGMoo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 08:44:44 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6D51F367;
        Fri,  7 Jun 2019 05:44:43 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EBEA740151;
        Fri,  7 Jun 2019 05:44:41 -0700 (PDT)
Subject: Re: [PATCH 1/8] KVM: arm/arm64: vgic: Add LPI translation cache
 definition
To:     Auger Eric <eric.auger@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Suzuki K Poulose <suzuki.poulose@arm.com>,
        "Raslan, KarimAllah" <karahmed@amazon.de>,
        Julien Thierry <julien.thierry@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        James Morse <james.morse@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
References: <20190606165455.162478-1-marc.zyngier@arm.com>
 <20190606165455.162478-2-marc.zyngier@arm.com>
 <7b4a5bc3-8168-50bb-e2aa-3ff081199d04@redhat.com>
From:   Marc Zyngier <marc.zyngier@arm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=marc.zyngier@arm.com; prefer-encrypt=mutual; keydata=
 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
 Z46HaNmN2hZS/oJ69c1DI5Rcww==
Organization: ARM Ltd
Message-ID: <856ab7bd-3ba1-e10e-1bf5-7a821c753a53@arm.com>
Date:   Fri, 7 Jun 2019 13:44:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <7b4a5bc3-8168-50bb-e2aa-3ff081199d04@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 07/06/2019 13:09, Auger Eric wrote:
> Hi Marc,
> 
> On 6/6/19 6:54 PM, Marc Zyngier wrote:
>> Add the basic data structure that expresses an MSI to LPI
>> translation as well as the allocation/release hooks.
>>
>> THe size of the cache is arbitrarily defined as 4*nr_vcpus.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  include/kvm/arm_vgic.h        | 10 ++++++++++
>>  virt/kvm/arm/vgic/vgic-init.c | 34 ++++++++++++++++++++++++++++++++++
>>  virt/kvm/arm/vgic/vgic-its.c  |  2 ++
>>  virt/kvm/arm/vgic/vgic.h      |  3 +++
>>  4 files changed, 49 insertions(+)
>>
>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>> index c36c86f1ec9a..5a0d6b07c5ef 100644
>> --- a/include/kvm/arm_vgic.h
>> +++ b/include/kvm/arm_vgic.h
>> @@ -173,6 +173,14 @@ struct vgic_io_device {
>>  	struct kvm_io_device dev;
>>  };
>>  
>> +struct vgic_translation_cache_entry {
>> +	struct list_head	entry;
>> +	phys_addr_t		db;
> it is not obvious to me why you do need the db field? Isn't the LPI
> uniquely identfiied by the devid and eventid. If I recall correctly
> theorically the architecture allows to handle LPIs even without ITS.

Only having DID+EID is unfortunately not enough, and the translation has
to be per ITS. Think of a system with two ITSs, and a PCI device in
front of each of the ITSs. There is no reason why the two devices would
have different IDs, as they belong to different PCI hierarchies.

So the cache must take the source ITS into account. The alternative
would be to keep a separate cache per ITS, but that would lead to more
overhead on the fast path, having to lookup the ITS first.

As for LPIs without ITS, that wouldn't need a cache at all.

>> +	u32			devid;
>> +	u32			eventid;
>> +	struct vgic_irq		*irq;
>> +};
>> +
>>  struct vgic_its {
>>  	/* The base address of the ITS control register frame */
>>  	gpa_t			vgic_its_base;
>> @@ -260,6 +268,8 @@ struct vgic_dist {
>>  	struct list_head	lpi_list_head;
>>  	int			lpi_list_count;
>>  
>> +	struct list_head	lpi_translation_cache;
>> +
>>  	/* used by vgic-debug */
>>  	struct vgic_state_iter *iter;
>>  
>> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
>> index 3bdb31eaed64..25ae25694a28 100644
>> --- a/virt/kvm/arm/vgic/vgic-init.c
>> +++ b/virt/kvm/arm/vgic/vgic-init.c
>> @@ -64,6 +64,7 @@ void kvm_vgic_early_init(struct kvm *kvm)
>>  	struct vgic_dist *dist = &kvm->arch.vgic;
>>  
>>  	INIT_LIST_HEAD(&dist->lpi_list_head);
>> +	INIT_LIST_HEAD(&dist->lpi_translation_cache);
>>  	raw_spin_lock_init(&dist->lpi_list_lock);
>>  }
>>  
>> @@ -260,6 +261,27 @@ static void kvm_vgic_vcpu_enable(struct kvm_vcpu *vcpu)
>>  		vgic_v3_enable(vcpu);
>>  }
>>  
>> +void vgic_lpi_translation_cache_init(struct kvm *kvm)
>> +{
>> +	struct vgic_dist *dist = &kvm->arch.vgic;
>> +	int i;
>> +
>> +	if (!list_empty(&dist->lpi_translation_cache))
>> +		return;
>> +
>> +	for (i = 0; i < LPI_CACHE_SIZE(kvm); i++) {
>> +		struct vgic_translation_cache_entry *cte;
>> +
>> +		/* An allocation failure is not fatal */
>> +		cte = kzalloc(sizeof(*cte), GFP_KERNEL);
>> +		if (WARN_ON(!cte))
>> +			break;
>> +
>> +		INIT_LIST_HEAD(&cte->entry);
>> +		list_add(&cte->entry, &dist->lpi_translation_cache);
>> +	}
>> +}
>> +
>>  /*
>>   * vgic_init: allocates and initializes dist and vcpu data structures
>>   * depending on two dimensioning parameters:
>> @@ -305,6 +327,7 @@ int vgic_init(struct kvm *kvm)
>>  	}
>>  
>>  	if (vgic_has_its(kvm)) {
>> +		vgic_lpi_translation_cache_init(kvm);
>>  		ret = vgic_v4_init(kvm);
>>  		if (ret)
>>  			goto out;
>> @@ -346,6 +369,17 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
>>  		INIT_LIST_HEAD(&dist->rd_regions);
>>  	}
>>  
>> +	if (vgic_has_its(kvm)) {
>> +		struct vgic_translation_cache_entry *cte, *tmp;
>> +
>> +		list_for_each_entry_safe(cte, tmp,
>> +					 &dist->lpi_translation_cache, entry) {
>> +			list_del(&cte->entry);
>> +			kfree(cte);
>> +		}
>> +		INIT_LIST_HEAD(&dist->lpi_translation_cache);
>> +	}
>> +
>>  	if (vgic_supports_direct_msis(kvm))
>>  		vgic_v4_teardown(kvm);
>>  }
>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>> index 44ceaccb18cf..5758504fd934 100644
>> --- a/virt/kvm/arm/vgic/vgic-its.c
>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>> @@ -1696,6 +1696,8 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
>>  			kfree(its);
>>  			return ret;
>>  		}
>> +
>> +		vgic_lpi_translation_cache_init(dev->kvm);
>>  	}
>>  
>>  	mutex_init(&its->its_lock);
>> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
>> index abeeffabc456..a58e1b263dca 100644
>> --- a/virt/kvm/arm/vgic/vgic.h
>> +++ b/virt/kvm/arm/vgic/vgic.h
>> @@ -316,6 +316,9 @@ int vgic_copy_lpi_list(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 **intid_ptr);
>>  int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
>>  			 u32 devid, u32 eventid, struct vgic_irq **irq);
>>  struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi);
>> +void vgic_lpi_translation_cache_init(struct kvm *kvm);
>> +
>> +#define LPI_CACHE_SIZE(kvm)	(atomic_read(&(kvm)->online_vcpus) * 4)
> Couldn't the cache be a function of the number of allocated lpis. We
> could realloc the list accordingly. I miss why it is rather dependent on
> the number of vcpus and not on the number of assigned devices/MSIs?

How do you find out about the number of LPIs? That's really for the
guest to decide what it wants to do. Also, KVM itself doesn't have much
of a clue about the number of assigned devices or their MSI capability.
That's why I've suggested that userspace could be involved here.

So far, I've used the number of vcpus as MSIs are usually used to deal
with per-CPU queues. This allows the cache to scale with the number of
queues that the guest is expected to deal with. Ali's reply earlier seem
to indicate that this is a common pattern, but it is the multiplying
factor that is hard to express.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
