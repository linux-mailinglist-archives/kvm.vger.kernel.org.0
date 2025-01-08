Return-Path: <kvm+bounces-34750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BC7AA054D4
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 08:54:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E0F8164355
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 07:54:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5C9D1B0F17;
	Wed,  8 Jan 2025 07:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EolBnFiH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2412D1537C8;
	Wed,  8 Jan 2025 07:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736322834; cv=none; b=kHSd1AseAsOClZoDhGUEwKPdcu8R2Ea/vB3VSuvmemHmA5ag6mG9PMibRCv6Tee3fQFjKcC8bgNf93MxQHTP/wom5/g27BnGrU7O2gUpRPq/8Et7p474FHVifoWKyIy+BzbC1Mh4BMSqaSO7Dnzdlu4XKLHgT3/9aF6Qwo/dmy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736322834; c=relaxed/simple;
	bh=Ei3m8oP7XFX3BZo7TacDzfQeRXwKWFVTWHDhjbtL+zU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WPmL4ImeCJIK04UKqgCxGQoGG5zSEQEN7XRm9i1Z2uOhiP//6IWdqvnNgAh3DcBgEOlcYmrvSNSTl2kOVkFOXOrqAz+6tsrDyMrj03tVjk+ZLxLNu/rGvfQWyHvxRoaiTPb9NFKN3g9tAsIWXKsuZ8h0axgNJA0qitaaBzkxNzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EolBnFiH; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736322833; x=1767858833;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Ei3m8oP7XFX3BZo7TacDzfQeRXwKWFVTWHDhjbtL+zU=;
  b=EolBnFiHGQ7tdem55B+CgjF/3eexDCljUYwMb9vtcv85VMUqrcYuMsBi
   P/ag1RgWwd6Oa39mk6SbnNydTjpvPyH3KwvNgLZoNoGzsfcF5oFuHWTmH
   6wC2aT56XhDkQz0fhTAc6eKg8DHWBoFCi34Y4/pyNOJf9OuBaX2yu6KvA
   wW4if/GqAeT9wbtzjs/ROQYPKpdd1VAbfKWgQB4NZh63WCXP3tFQteNhs
   KiyF29EKuJTo7NKcPF2nKZlqEDGL2pLGVKaAdbDnvN8bFYQ6OWtwaqgVc
   I+jYAdLbU9OT79j9n3Cv4INT6pnjY52a2dF7D3Ncy/Hi+AIGg/ljRIGIR
   g==;
X-CSE-ConnectionGUID: kImRRl1ORFGbQkjofYKVyQ==
X-CSE-MsgGUID: zKYgRNnNQDCcNgBD+PxQBA==
X-IronPort-AV: E=McAfee;i="6700,10204,11308"; a="47111183"
X-IronPort-AV: E=Sophos;i="6.12,297,1728975600"; 
   d="scan'208";a="47111183"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2025 23:53:52 -0800
X-CSE-ConnectionGUID: qqvNHMgfQ1yufb7+/bG/OA==
X-CSE-MsgGUID: VNUE8N26SWqAysvxZDW9xA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="108072607"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.241.228]) ([10.124.241.228])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2025 23:53:48 -0800
Message-ID: <904c0aa7-8aa6-4ac2-b2d3-9bac89355af1@linux.intel.com>
Date: Wed, 8 Jan 2025 15:53:45 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/16] KVM: TDX: Always block INIT/SIPI
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, tony.lindgren@linux.intel.com,
 isaku.yamahata@intel.com, yan.y.zhao@intel.com, chao.gao@intel.com,
 linux-kernel@vger.kernel.org
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
 <20241209010734.3543481-12-binbin.wu@linux.intel.com>
 <473c1a20-11c8-4e4e-8ff1-e2e5c5d68332@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <473c1a20-11c8-4e4e-8ff1-e2e5c5d68332@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit




On 1/8/2025 3:21 PM, Xiaoyao Li wrote:
> On 12/9/2024 9:07 AM, Binbin Wu wrote:
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>
>> Always block INIT and SIPI events for the TDX guest because the TDX module
>> doesn't provide API for VMM to inject INIT IPI or SIPI.
>>
>> TDX defines its own vCPU creation and initialization sequence including
>> multiple seamcalls.  Also, it's only allowed during TD build time.
>>
>> Given that TDX guest is para-virtualized to boot BSP/APs, normally there
>> shouldn't be any INIT/SIPI event for TDX guest.  If any, three options to
>> handle them:
>> 1. Always block INIT/SIPI request.
>> 2. (Silently) ignore INIT/SIPI request during delivery.
>> 3. Return error to guest TDs somehow.
>>
>> Choose option 1 for simplicity. Since INIT and SIPI are always blocked,
>> INIT handling and the OP vcpu_deliver_sipi_vector() won't be called, no
>> need to add new interface or helper function for INIT/SIPI delivery.
>>
>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>> ---
>> TDX interrupts breakout:
>> - Renamed from "KVM: TDX: Silently ignore INIT/SIPI" to
>>    "KVM: TDX: Always block INIT/SIPI".
>> - Remove KVM_BUG_ON() in tdx_vcpu_reset(). (Rick)
>> - Drop tdx_vcpu_reset() and move the comment to vt_vcpu_reset().
>> - Remove unnecessary interface and helpers to delivery INIT/SIPI
>>    because INIT/SIPI events are always blocked for TDX. (Binbin)
>> - Update changelog.
>> ---
>>   arch/x86/kvm/lapic.c    |  2 +-
>>   arch/x86/kvm/vmx/main.c | 19 ++++++++++++++++++-
>>   2 files changed, 19 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>> index 474e0a7c1069..f93c382344ee 100644
>> --- a/arch/x86/kvm/lapic.c
>> +++ b/arch/x86/kvm/lapic.c
>> @@ -3365,7 +3365,7 @@ int kvm_apic_accept_events(struct kvm_vcpu *vcpu)
>>         if (test_and_clear_bit(KVM_APIC_INIT, &apic->pending_events)) {
>>           kvm_vcpu_reset(vcpu, true);
>> -        if (kvm_vcpu_is_bsp(apic->vcpu))
>> +        if (kvm_vcpu_is_bsp(vcpu))
>>               vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
>>           else
>>               vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
>> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
>> index 8ec96646faec..7f933f821188 100644
>> --- a/arch/x86/kvm/vmx/main.c
>> +++ b/arch/x86/kvm/vmx/main.c
>> @@ -115,6 +115,11 @@ static void vt_vcpu_free(struct kvm_vcpu *vcpu)
>>     static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>>   {
>> +    /*
>> +     * TDX has its own sequence to do init during TD build time (by
>> +     * KVM_TDX_INIT_VCPU) and it doesn't support INIT event during TD
>> +     * runtime.
>> +     */
>
> The first half is confusing. It seems to mix up init(ialization) with INIT event.
>
> And this callback is about *reset*, which can be due to INIT event or not. That's why it has a second parameter of init_event. The comment needs to clarify why reset is not needed for both cases.
>
> I think we can just say TDX doesn't support vcpu reset no matter due to INIT event or not.
>
>
Will update it.
Thanks!



