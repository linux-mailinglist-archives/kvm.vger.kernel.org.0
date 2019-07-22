Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C83B26FE1E
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2019 12:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728616AbfGVKya (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jul 2019 06:54:30 -0400
Received: from foss.arm.com ([217.140.110.172]:35790 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbfGVKya (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jul 2019 06:54:30 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5324928;
        Mon, 22 Jul 2019 03:54:29 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C1D5C3F71A;
        Mon, 22 Jul 2019 03:54:27 -0700 (PDT)
Subject: Re: [PATCH v2 4/9] KVM: arm/arm64: vgic-its: Invalidate MSI-LPI
 translation cache on specific commands
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
 <20190611170336.121706-5-marc.zyngier@arm.com>
 <9ff329a3-44f2-1de3-b6cc-58ed38a63665@redhat.com>
From:   Marc Zyngier <marc.zyngier@arm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=marc.zyngier@arm.com; prefer-encrypt=mutual; keydata=
 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
 Z46HaNmN2hZS/oJ69c1DI5Rcww==
Organization: ARM Ltd
Message-ID: <1a78d52c-7a31-8981-230b-abe85d11b8ec@arm.com>
Date:   Mon, 22 Jul 2019 11:54:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <9ff329a3-44f2-1de3-b6cc-58ed38a63665@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 01/07/2019 13:38, Auger Eric wrote:
> Hi Marc,
> 
> On 6/11/19 7:03 PM, Marc Zyngier wrote:
>> The LPI translation cache needs to be discarded when an ITS command
>> may affect the translation of an LPI (DISCARD and MAPD with V=0) or
>> the routing of an LPI to a redistributor with disabled LPIs (MOVI,
>> MOVALL).
>>
>> We decide to perform a full invalidation of the cache, irrespective
>> of the LPI that is affected. Commands are supposed to be rare enough
>> that it doesn't matter.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  virt/kvm/arm/vgic/vgic-its.c | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>> index 9b6b66204b97..5254bb762e1b 100644
>> --- a/virt/kvm/arm/vgic/vgic-its.c
>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>> @@ -733,6 +733,8 @@ static int vgic_its_cmd_handle_discard(struct kvm *kvm, struct vgic_its *its,
>>  		 * don't bother here since we clear the ITTE anyway and the
>>  		 * pending state is a property of the ITTE struct.
>>  		 */
>> +		vgic_its_invalidate_cache(kvm);
>> +
>>  		its_free_ite(kvm, ite);
>>  		return 0;
>>  	}
>> @@ -768,6 +770,8 @@ static int vgic_its_cmd_handle_movi(struct kvm *kvm, struct vgic_its *its,
>>  	ite->collection = collection;
>>  	vcpu = kvm_get_vcpu(kvm, collection->target_addr);
>>  
>> +	vgic_its_invalidate_cache(kvm);
>> +
>>  	return update_affinity(ite->irq, vcpu);
>>  }
>>  
>> @@ -996,6 +1000,8 @@ static void vgic_its_free_device(struct kvm *kvm, struct its_device *device)
>>  	list_for_each_entry_safe(ite, temp, &device->itt_head, ite_list)
>>  		its_free_ite(kvm, ite);
>>  
>> +	vgic_its_invalidate_cache(kvm);
>> +
>>  	list_del(&device->dev_list);
>>  	kfree(device);
>>  }
>> @@ -1249,6 +1255,8 @@ static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
>>  		vgic_put_irq(kvm, irq);
>>  	}
>>  
>> +	vgic_its_invalidate_cache(kvm);
> All the commands are executed with the its_lock held. Now we don't take
> it anymore on the fast cache injection path. Don't we have a window
> where the move has been applied at table level and the cache is not yet
> invalidated? Same question for vgic_its_free_device().

There is definitely a race, but that race is invisible from the guest's
perspective. The guest can only assume that the command has taken effect
once a SYNC command has been executed, and it cannot observe that the
SYNC command has been executed before we have invalidated the cache.

Does this answer your question?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
