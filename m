Return-Path: <kvm+bounces-42861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B1A19A7E70C
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 18:45:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4494342634F
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 16:36:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C368220E71F;
	Mon,  7 Apr 2025 16:34:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC85B20E007;
	Mon,  7 Apr 2025 16:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744043699; cv=none; b=KLfNPe4rwNFg4W10HiY0/1XDjMoi0gm5JXpAkhsE015DeCs0lNEF9zt1W1iYMVKeuQFDLPyWTcL053JEKL4w2Te2hlkLGLic4NwSvWGhJ4sR54cgQ9ik9Zj3iUIVsDKNQcirx+N1kXWl84JnKBxlhXziFjqC8qKMTveGYI0VNoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744043699; c=relaxed/simple;
	bh=WMuZXN9uPQg0EOQ/19w79o3wWm0fyR5P5/0uwECFBzM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=syxbCHqSv8yKVKEseNzVUpyVMGyuhrDMXiIEgkVOtrOZGd90KyzAXQlZ+76HH8a0MtmjteZznCcGK5NFuHryRIb7N7EGBXAHVybrJaufvYuuqLR3XQDvQRi7s+T+2Wy/lEKel5uB2SH0vPprkylZixIVVuOT7NRuyX8w6faVUQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 616AC12FC;
	Mon,  7 Apr 2025 09:34:58 -0700 (PDT)
Received: from [10.57.17.31] (unknown [10.57.17.31])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 224E73F694;
	Mon,  7 Apr 2025 09:34:52 -0700 (PDT)
Message-ID: <d254a8ea-0f02-4826-9af3-4a288efcc90c@arm.com>
Date: Mon, 7 Apr 2025 17:34:52 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 34/45] kvm: rme: Hide KVM_CAP_READONLY_MEM for realm
 guests
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-35-steven.price@arm.com>
 <32a09a27-f131-44dd-8959-abb63b2089a8@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <32a09a27-f131-44dd-8959-abb63b2089a8@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 04/03/2025 11:51, Gavin Shan wrote:
> On 2/14/25 2:14 AM, Steven Price wrote:
>> For protected memory read only isn't supported. While it may be possible
>> to support read only for unprotected memory, this isn't supported at the
>> present time.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>   arch/arm64/kvm/arm.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
> 
> It's worthy to explain why KVM_CAP_READONLY_MEM isn't supported and its
> negative impact. It's something to be done in the future if I'm correct.

I'll add to the commit message:

    Note that this does mean that e.g. ROM (or flash) data cannot be
    emulated correctly by the VMM.

> From QEMU's perspective, all ROM data, which is populated by it, can
> be written. It conflicts to the natural limit: all ROM data should be
> read-only.

Yes this is my understanding of the main impact. I'm not sure how useful
(shared) ROM/flash emulation is. It can certainly be added in the future
if needed. Protected read-only memory I don't believe is useful - the
only sane response I can see from a write fault in that case is killing
the guest.

Thanks,
Steve

> QEMU
> ====
> rom_add_blob
>   rom_set_mr
>     memory_region_set_readonly
>       memory_region_transaction_commit
>         kvm_region_commit
>           kvm_set_phys_mem
>             kvm_mem_flags                                    // flag
> KVM_MEM_READONLY is missed
>             kvm_set_user_memory_region
>               kvm_vm_ioctl(KVM_SET_USER_MEMORY_REGION2)
> 
> non-secure host
> ===============
> rec_exit_sync_dabt
>   kvm_handle_guest_abort
>     user_mem_abort
>       __kvm_faultin_pfn                       // writable == true
>         realm_map_ipa
>           WARN_ON(!(prot & KVM_PGTABLE_PROT_W)
> 
> non-secure host
> ===============
> kvm_realm_enable_cap(KVM_CAP_ARM_RME_POPULATE_REALM)
>   kvm_populate_realm
>     __kvm_faultin_pfn                      // writable == true
>       realm_create_protected_data_page
> 
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 1f3674e95f03..0f1d65f87e2b 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -348,7 +348,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm,
>> long ext)
>>       case KVM_CAP_ONE_REG:
>>       case KVM_CAP_ARM_PSCI:
>>       case KVM_CAP_ARM_PSCI_0_2:
>> -    case KVM_CAP_READONLY_MEM:
>>       case KVM_CAP_MP_STATE:
>>       case KVM_CAP_IMMEDIATE_EXIT:
>>       case KVM_CAP_VCPU_EVENTS:
>> @@ -362,6 +361,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm,
>> long ext)
>>       case KVM_CAP_COUNTER_OFFSET:
>>           r = 1;
>>           break;
>> +    case KVM_CAP_READONLY_MEM:
>>       case KVM_CAP_SET_GUEST_DEBUG:
>>           r = !kvm_is_realm(kvm);
>>           break;
> 
> Thanks,
> Gavin
> 


