Return-Path: <kvm+bounces-53824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F381DB17B39
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 04:33:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D8B61C26E05
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 02:34:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED15114B96E;
	Fri,  1 Aug 2025 02:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nLzilkKC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929B32B9A5
	for <kvm@vger.kernel.org>; Fri,  1 Aug 2025 02:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754015617; cv=none; b=iklcFYb63gG40Xta6ixlj7a0a0lnX5YnJtz8OrcplXZVnE2BAHTOtOPitj6uJxoz9SnzMYK8YPPxJWOiUYxCzvLWRcjhlLjI3Za4O/S2y8Rfo5MOgZopiipopMlihTLT2PDi02R8j3w0iW5fTnByQgXHR+E2f80MMjhyew8mHnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754015617; c=relaxed/simple;
	bh=s+b9jgv+ngCHAPKv9RfLdn9VS8JG6ah2Nh8KSNqdcXs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xxoxdx1QZU1M3qA7tNwVyDyvi+esQ2785jiffTAB0iQkO7orXl5TOe5iTnfY+YVZ/llPYHQ6PVqvyxVwj8IrBTnSHSlehqR7qK0PV91Wsb4zbhH9r54O8SRCDfwv0ln1xuinYqxJbYHg5RREQvXbYetVeuyB7oi2DPkSDKqu5aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nLzilkKC; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754015615; x=1785551615;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=s+b9jgv+ngCHAPKv9RfLdn9VS8JG6ah2Nh8KSNqdcXs=;
  b=nLzilkKCCAdplwS/YDm/H0Fyh21NWr8FqYxW116OVA3xwrzwluTavnYS
   GcaKa9Ay3ZQTgzVgsifpKAQTUeANOL3pgbJxiS2ZhLZgmQGjCOT6AHEaj
   nMwzQb7qzkCbJJ2SKjuarnE7vUjCbLlc0mgnE4e3hDeodbVTsYGIvzmFk
   LfsXUJlwKrnXGLVeXf1jKSRdg5ucvtaDyxXsuiThX4C/qlSV1SXigP07O
   +uT+UdjxhaeTAIfWDFlfLd7/MM5+0S9W7cye5Rpe9O+o5Efd8J5MZhgDE
   vazGdwAl6qw6fL3PgycwRoWCzMRVFAXYMExXX/uvlfEVXhGgik/Wqe44R
   w==;
X-CSE-ConnectionGUID: 4+IZcHmeQK2Dw5xHFVppxw==
X-CSE-MsgGUID: 9BdaO/e/TOScvMn20rEDjg==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="66925677"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="66925677"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 19:33:35 -0700
X-CSE-ConnectionGUID: X2EQj6lZQk2e3cEvudfdMw==
X-CSE-MsgGUID: 6K9SvX7TTsGEP9jfB6sBOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="163796949"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 19:33:30 -0700
Message-ID: <b87c937e-4bcc-4c76-a968-c66332fa611d@intel.com>
Date: Fri, 1 Aug 2025 10:33:27 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [POC PATCH 3/5] memory/guest_memfd: Enable in-place conversion
 when available
To: Chenyi Qiang <chenyi.qiang@intel.com>, Paolo Bonzini
 <pbonzini@redhat.com>, David Hildenbrand <david@redhat.com>,
 ackerleytng@google.com, seanjc@google.com
Cc: Fuad Tabba <tabba@google.com>, Vishal Annapurve <vannapurve@google.com>,
 rick.p.edgecombe@intel.com, Kai Huang <kai.huang@intel.com>,
 binbin.wu@linux.intel.com, yan.y.zhao@intel.com, ira.weiny@intel.com,
 michael.roth@amd.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>
References: <cover.1747264138.git.ackerleytng@google.com>
 <20250715033141.517457-1-xiaoyao.li@intel.com>
 <20250715033141.517457-4-xiaoyao.li@intel.com>
 <18f64464-2ead-42d4-aeaa-f781020dca05@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <18f64464-2ead-42d4-aeaa-f781020dca05@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/17/2025 10:02 AM, Chenyi Qiang wrote:
> 
> 
> On 7/15/2025 11:31 AM, Xiaoyao Li wrote:
>> From: Yan Zhao <yan.y.zhao@intel.com>
>>
>> (This is just the POC code to use in-place conversion gmem.)
>>
>> Try to use in-place conversion gmem when it is supported.
>>
>> When in-place conversion is enabled, there is no need to discard memory
>> since it still needs to be used as the memory of opposite attribute
>> after conversion.
>>
>> For a upstreamable solution, we can introduce memory-backend-guestmemfd
>> for in-place conversion. With the non in-place conversion, it needs
>> seperate non-gmem memory to back the shared memory and gmem is created
>> implicitly and internally based on vm type. While with in-place
>> conversion, there is no need for seperate non-gmem memory because gmem
>> itself can be served as shared memory. So that we can introduce
>> memory-backend-guestmemfd as the specific backend for in-place
>> conversion gmem.
>>
>> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
>> Co-developed-by Xiaoyao Li <xiaoyao.li@intel.com>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   accel/kvm/kvm-all.c       | 79 ++++++++++++++++++++++++++++-----------
>>   accel/stubs/kvm-stub.c    |  1 +
>>   include/system/kvm.h      |  1 +
>>   include/system/memory.h   |  2 +
>>   include/system/ramblock.h |  1 +
>>   system/memory.c           |  7 ++++
>>   system/physmem.c          | 21 ++++++++++-
>>   7 files changed, 90 insertions(+), 22 deletions(-)
>>
>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>> index a106d1ba0f0b..609537738d38 100644
>> --- a/accel/kvm/kvm-all.c
>> +++ b/accel/kvm/kvm-all.c
>> @@ -105,6 +105,7 @@ static int kvm_sstep_flags;
>>   static bool kvm_immediate_exit;
>>   static uint64_t kvm_supported_memory_attributes;
>>   static bool kvm_guest_memfd_supported;
>> +bool kvm_guest_memfd_inplace_supported;
>>   static hwaddr kvm_max_slot_size = ~0;
>>   
>>   static const KVMCapabilityInfo kvm_required_capabilites[] = {
>> @@ -1487,6 +1488,30 @@ static int kvm_set_memory_attributes(hwaddr start, uint64_t size, uint64_t attr)
>>       return r;
>>   }
>>   
>> +static int kvm_set_guest_memfd_shareability(MemoryRegion *mr, ram_addr_t offset,
>> +                                            uint64_t size, bool shared)
>> +{
>> +    int guest_memfd = mr->ram_block->guest_memfd;
>> +    struct kvm_gmem_convert param = {
>> +                .offset = offset,
>> +                .size = size,
>> +                .error_offset = 0,
>> +    };
>> +    unsigned long op;
>> +    int r;
>> +
>> +    op = shared ? KVM_GMEM_CONVERT_SHARED : KVM_GMEM_CONVERT_PRIVATE;
>> +
>> +    r = ioctl(guest_memfd, op, &param);
>> +    if (r) {
>> +        error_report("failed to set guest_memfd offset 0x%lx size 0x%lx to %s  "
>> +                     "error '%s' error offset 0x%llx",
>> +                     offset, size, shared ? "shared" : "private",
>> +                     strerror(errno), param.error_offset);
>> +    }
>> +    return r;
>> +}
>> +
>>   int kvm_set_memory_attributes_private(hwaddr start, uint64_t size)
>>   {
>>       return kvm_set_memory_attributes(start, size, KVM_MEMORY_ATTRIBUTE_PRIVATE);
>> @@ -1604,7 +1629,8 @@ static void kvm_set_phys_mem(KVMMemoryListener *kml,
>>               abort();
>>           }
>>   
>> -        if (memory_region_has_guest_memfd(mr)) {
>> +        if (memory_region_has_guest_memfd(mr) &&
>> +            !memory_region_guest_memfd_in_place_conversion(mr)) {
>>               err = kvm_set_memory_attributes_private(start_addr, slot_size);
>>               if (err) {
>>                   error_report("%s: failed to set memory attribute private: %s",
>> @@ -2779,6 +2805,9 @@ static int kvm_init(AccelState *as, MachineState *ms)
>>           kvm_check_extension(s, KVM_CAP_GUEST_MEMFD) &&
>>           kvm_check_extension(s, KVM_CAP_USER_MEMORY2) &&
>>           (kvm_supported_memory_attributes & KVM_MEMORY_ATTRIBUTE_PRIVATE);
>> +    kvm_guest_memfd_inplace_supported =
>> +        kvm_check_extension(s, KVM_CAP_GMEM_SHARED_MEM) &&
>> +        kvm_check_extension(s, KVM_CAP_GMEM_CONVERSION);
>>       kvm_pre_fault_memory_supported = kvm_vm_check_extension(s, KVM_CAP_PRE_FAULT_MEMORY);
>>   
>>       if (s->kernel_irqchip_split == ON_OFF_AUTO_AUTO) {
>> @@ -3056,6 +3085,7 @@ static void kvm_eat_signals(CPUState *cpu)
>>   
>>   int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
>>   {
>> +    bool in_place_conversion = false;
>>       MemoryRegionSection section;
>>       ram_addr_t offset;
>>       MemoryRegion *mr;
>> @@ -3112,18 +3142,23 @@ int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
>>           goto out_unref;
>>       }
>>   
>> -    if (to_private) {
>> -        ret = kvm_set_memory_attributes_private(start, size);
>> -    } else {
>> -        ret = kvm_set_memory_attributes_shared(start, size);
>> -    }
>> -    if (ret) {
>> -        goto out_unref;
>> -    }
>> -
>>       addr = memory_region_get_ram_ptr(mr) + section.offset_within_region;
>>       rb = qemu_ram_block_from_host(addr, false, &offset);
>>   
>> +    in_place_conversion = memory_region_guest_memfd_in_place_conversion(mr);
>> +    if (in_place_conversion) {
>> +        ret = kvm_set_guest_memfd_shareability(mr, offset, size, !to_private);
>> +    } else {
>> +        if (to_private) {
>> +            ret = kvm_set_memory_attributes_private(start, size);
>> +        } else {
>> +            ret = kvm_set_memory_attributes_shared(start, size);
>> +        }
>> +    }
>> +    if (ret) {
>> +        goto out_unref;
>> +    }
>> +
>>       ret = ram_block_attributes_state_change(RAM_BLOCK_ATTRIBUTES(mr->rdm),
>>                                               offset, size, to_private);
>>       if (ret) {
> 
> There's one thing required for shared device assignment with in-place conversion, we need to follow the
> sequence of unmap-before-conversion-to-private and map-after-conversion-to-shared. Maybe change it like:
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index a54e68e769..e9e62ae8f2 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -3146,6 +3146,17 @@ int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
>       addr = memory_region_get_ram_ptr(mr) + section.offset_within_region;
>       rb = qemu_ram_block_from_host(addr, false, &offset);
>   
> +    if (to_private) {
> +        ret = ram_block_attributes_state_change(RAM_BLOCK_ATTRIBUTES(mr->rdm),
> +                                                offset, size, to_private);
> +        if (ret) {
> +            error_report("Failed to notify the listener the state change of "
> +                         "(0x%"HWADDR_PRIx" + 0x%"HWADDR_PRIx") to %s",
> +                         start, size, to_private ? "private" : "shared");
> +            goto out_unref;
> +        }
> +    }
> +
>       in_place_conversion = memory_region_guest_memfd_in_place_conversion(mr);
>       if (in_place_conversion) {
>           ret = kvm_set_guest_memfd_shareability(mr, offset, size, !to_private);
> @@ -3160,13 +3171,15 @@ int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
>           goto out_unref;
>       }
>   
> -    ret = ram_block_attributes_state_change(RAM_BLOCK_ATTRIBUTES(mr->rdm),
> -                                            offset, size, to_private);
> -    if (ret) {
> -        error_report("Failed to notify the listener the state change of "
> -                     "(0x%"HWADDR_PRIx" + 0x%"HWADDR_PRIx") to %s",
> -                     start, size, to_private ? "private" : "shared");
> -        goto out_unref;
> +    if (!to_private) {
> +        ret = ram_block_attributes_state_change(RAM_BLOCK_ATTRIBUTES(mr->rdm),
> +                                                offset, size, to_private);
> +        if (ret) {
> +            error_report("Failed to notify the listener the state change of "
> +                         "(0x%"HWADDR_PRIx" + 0x%"HWADDR_PRIx") to %s",
> +                         start, size, to_private ? "private" : "shared");
> +            goto out_unref;
> +        }
>       }

(Sorry for forgetting to reply in the community)

Thanks for catching and reporting it. I have incorporated it to the 
internal branch.

