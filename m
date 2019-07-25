Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBB4A74908
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2019 10:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389504AbfGYIYu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jul 2019 04:24:50 -0400
Received: from foss.arm.com ([217.140.110.172]:53646 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389405AbfGYIYu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jul 2019 04:24:50 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 39008344;
        Thu, 25 Jul 2019 01:24:47 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2AF833F694;
        Thu, 25 Jul 2019 01:24:45 -0700 (PDT)
Subject: Re: [PATCH v2 9/9] KVM: arm/arm64: vgic-irqfd: Implement
 kvm_arch_set_irq_inatomic
To:     Auger Eric <eric.auger@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Julien Thierry <julien.thierry@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        "Raslan, KarimAllah" <karahmed@amazon.de>,
        "Saidi, Ali" <alisaidi@amazon.com>
References: <20190611170336.121706-1-marc.zyngier@arm.com>
 <20190611170336.121706-10-marc.zyngier@arm.com>
 <a63b08b8-9539-09b4-1060-7c0d2f2eacac@redhat.com>
From:   Marc Zyngier <marc.zyngier@arm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=marc.zyngier@arm.com; prefer-encrypt=mutual; keydata=
 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
 Z46HaNmN2hZS/oJ69c1DI5Rcww==
Organization: ARM Ltd
Message-ID: <24382fce-e165-4e79-1703-d019efcdf6e8@arm.com>
Date:   Thu, 25 Jul 2019 09:24:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <a63b08b8-9539-09b4-1060-7c0d2f2eacac@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/07/2019 16:14, Auger Eric wrote:
> Hi Marc,
> 
> On 6/11/19 7:03 PM, Marc Zyngier wrote:
>> Now that we have a cache of MSI->LPI translations, it is pretty
>> easy to implement kvm_arch_set_irq_inatomic (this cache can be
>> parsed without sleeping).
>>
>> Hopefully, this will improve some LPI-heavy workloads.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  virt/kvm/arm/vgic/vgic-irqfd.c | 36 ++++++++++++++++++++++++++++------
>>  1 file changed, 30 insertions(+), 6 deletions(-)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-irqfd.c b/virt/kvm/arm/vgic/vgic-irqfd.c
>> index 99e026d2dade..9f203ed8c8f3 100644
>> --- a/virt/kvm/arm/vgic/vgic-irqfd.c
>> +++ b/virt/kvm/arm/vgic/vgic-irqfd.c
>> @@ -77,6 +77,15 @@ int kvm_set_routing_entry(struct kvm *kvm,
>>  	return r;
>>  }
>>  
>> +static void kvm_populate_msi(struct kvm_kernel_irq_routing_entry *e,
>> +			     struct kvm_msi *msi)
>> +{
>> +	msi->address_lo = e->msi.address_lo;
>> +	msi->address_hi = e->msi.address_hi;
>> +	msi->data = e->msi.data;
>> +	msi->flags = e->msi.flags;
>> +	msi->devid = e->msi.devid;
>> +}
>>  /**
>>   * kvm_set_msi: inject the MSI corresponding to the
> s/:/ -
>>   * MSI routing entry
>> @@ -90,21 +99,36 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
>>  {
>>  	struct kvm_msi msi;
>>  
>> -	msi.address_lo = e->msi.address_lo;
>> -	msi.address_hi = e->msi.address_hi;
>> -	msi.data = e->msi.data;
>> -	msi.flags = e->msi.flags;
>> -	msi.devid = e->msi.devid;
>> -
>>  	if (!vgic_has_its(kvm))
>>  		return -ENODEV;
>>  
>>  	if (!level)
>>  		return -1;
>>  
>> +	kvm_populate_msi(e, &msi);
>>  	return vgic_its_inject_msi(kvm, &msi);
>>  }
>>  
>> +/**
>> + * kvm_arch_set_irq_inatomic: fast-path for irqfd injection
> s/:/ -
>> + *
>> + * Currently only direct MSI injecton is supported.
> injection
>> + */
>> +int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
>> +			      struct kvm *kvm, int irq_source_id, int level,
>> +			      bool line_status)
>> +{
>> +	if (e->type == KVM_IRQ_ROUTING_MSI && vgic_has_its(kvm) && level) {
>> +		struct kvm_msi msi;
>> +
>> +		kvm_populate_msi(e, &msi);
>> +		if (!vgic_its_inject_cached_translation(kvm, &msi))
>> +			return 0;
> if this fails since its->enabled is false we will re-attempt the
> injection though the normal injection path but that's not a big deal.

Yeah, I wouldn't worry about that. If there is a screaming device, so be
it. The guest should know better...

>> +	}
>> +
>> +	return -EWOULDBLOCK;
>> +}
>> +
>>  int kvm_vgic_setup_default_irq_routing(struct kvm *kvm)
>>  {
>>  	struct kvm_irq_routing_entry *entries;
>>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks Eric.

	M.
-- 
Jazz is not dead. It just smells funny...
