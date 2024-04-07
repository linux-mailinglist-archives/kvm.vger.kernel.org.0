Return-Path: <kvm+bounces-13813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A11B89ADE1
	for <lists+kvm@lfdr.de>; Sun,  7 Apr 2024 03:32:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27C4728218A
	for <lists+kvm@lfdr.de>; Sun,  7 Apr 2024 01:32:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30FA517F0;
	Sun,  7 Apr 2024 01:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L73wtXMO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB7FA3D;
	Sun,  7 Apr 2024 01:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712453560; cv=none; b=ITuYf2/2IVkqSmr+ztf9o7QNPyZ2B5SqT9P3eVsnNhP3Ff2nhcj9JzR0JLB9V6eQVKV8vF3N6CGfHrAx6BlKwx8kO/bcXrf/6RnBW/5ey2qy6I/SIbf0LT0zRPgq4j4J4q8rh6GzixLEYucVK7pRETgbTZgSHWbjRj87cxsVkl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712453560; c=relaxed/simple;
	bh=JRfDMX8Tu+yleIHsAzduyaguiwBV+zaq01M0kNCxjwg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MFGFHWJ3D++wwT3B+kuP+ZvgpP6N8remIz14WuQKqi0IuiSSRMRt9hPjtUYYQG8ia0vWe8twXapjAjjXt/FbAsrj6u2bBsr9MXQwcIG9Oj7P2zAA1b6sF28nc7QmX9SK3QmxXZLC3auNAXxRh5yVWgOdEqU+eyT1IcirACcCKZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L73wtXMO; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712453558; x=1743989558;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JRfDMX8Tu+yleIHsAzduyaguiwBV+zaq01M0kNCxjwg=;
  b=L73wtXMO2EHGq5IzTliLCoeT5rnTF+lRTvhnb4QTfa35NfR4WpjJGc/u
   xkKyz0KGdk78zBgu+VAAt5Md5/izBIhMmazQ0vwbyuC//WInFvb5uYd/k
   Y0lqN4GtsQskZ9oRk+NUNiHRi1ruu8K4+y0Czl8NzxgK3CIWe+ppDb5qV
   yFEt/RdjUMADpGd7k5oWB6PZinBNkKEiE0Gcji8Tpkg5ZUu/wOOmGcx5y
   i6zGrwyDC8kMk7aegxjJugJkTovFvzaK5Ip562FBPNjC/SKofqEoa5FdJ
   wlyJgiOiS5fHEeW5x4D5bEQp+/DLtgBE7MjeCL61Iie3bno61ULVH1gkM
   g==;
X-CSE-ConnectionGUID: 7C5+oqTlSPGQGE3Imv3IRA==
X-CSE-MsgGUID: B3VEar68SNaDU7jGEyCT8A==
X-IronPort-AV: E=McAfee;i="6600,9927,11036"; a="7657982"
X-IronPort-AV: E=Sophos;i="6.07,184,1708416000"; 
   d="scan'208";a="7657982"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2024 18:32:37 -0700
X-CSE-ConnectionGUID: t7oUDwNrQIe2xzzlngJNmg==
X-CSE-MsgGUID: 6IJ1wYasQIe9GvshwdXTGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,184,1708416000"; 
   d="scan'208";a="19961609"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.236.140]) ([10.124.236.140])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2024 18:32:34 -0700
Message-ID: <3b2c4f57-c58b-4ccb-82fe-4e89e6d21a7a@linux.intel.com>
Date: Sun, 7 Apr 2024 09:32:31 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 067/130] KVM: TDX: Add load_mmu_pgd method for TDX
To: "Huang, Kai" <kai.huang@intel.com>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>
Cc: "Zhang, Tina" <tina.zhang@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "seanjc@google.com" <seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>, "Chen, Bo2"
 <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
 "isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
 "Aktas, Erdem" <erdemaktas@google.com>,
 "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <bef7033b687e75c5436c0aee07691327d36734ea.1708933498.git.isaku.yamahata@intel.com>
 <331fbd0d-f560-4bde-858f-e05678b42ff0@linux.intel.com>
 <20240403173344.GF2444378@ls.amr.corp.intel.com>
 <a2386cbfc8a4e091f86840df491fb4d999478f44.camel@intel.com>
 <f61bb57eba91c68e7cf50c4e806de94c2341ad16.camel@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <f61bb57eba91c68e7cf50c4e806de94c2341ad16.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 4/6/2024 8:58 AM, Huang, Kai wrote:
> On Sat, 2024-04-06 at 00:09 +0000, Edgecombe, Rick P wrote:
>> On Wed, 2024-04-03 at 10:33 -0700, Isaku Yamahata wrote:
>>> On Mon, Apr 01, 2024 at 11:49:43PM +0800,
>>> Binbin Wu <binbin.wu@linux.intel.com> wrote:
>>>
>>>>
>>>> On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
>>>>> From: Sean Christopherson <sean.j.christopherson@intel.com>
>>>>>
>>>>> For virtual IO, the guest TD shares guest pages with VMM without
>>>>> encryption.
>>>> Virtual IO is a use case of shared memory, it's better to use it
>>>> as a example instead of putting it at the beginning of the sentence.
>>>>
>>>>
>>>>>     Shared EPT is used to map guest pages in unprotected way.
>>>>>
>>>>> Add the VMCS field encoding for the shared EPTP, which will be used by
>>>>> TDX to have separate EPT walks for private GPAs (existing EPTP) versus
>>>>> shared GPAs (new shared EPTP).
>>>>>
>>>>> Set shared EPT pointer value for the TDX guest to initialize TDX MMU.
>>>> May have a mention that the EPTP for priavet GPAs is set by TDX module.
>>> Sure, let me update the commit message.
>> How about this?
> Looks good.  Some nits though:
>
>> KVM: TDX: Add load_mmu_pgd method for TDX
>>
>> TDX has uses two EPT pointers, one for the private half of the GPA
> "TDX uses"
>
>> space and one for the shared half. The private half used the normal
> "used" -> "uses"
>
>> EPT_POINTER vmcs field and is managed in a special way by the TDX module.
> Perhaps add:
>
> KVM is not allowed to operate on the EPT_POINTER directly.
>
>> The shared half uses a new SHARED_EPT_POINTER field and will be managed by
>> the conventional MMU management operations that operate directly on the
>> EPT tables.
>>
> I would like to explicitly call out KVM can update SHARED_EPT_POINTER directly:
>
> The shared half uses a new SHARED_EPT_POINTER field.  KVM is allowed to set it
> directly by the interface provided by the TDX module, and KVM is expected to
> manage the shared half just like it manages the existing EPT page table today.
>
>
>> This means for TDX the .load_mmu_pgd() operation will need to
>> know to use the SHARED_EPT_POINTER field instead of the normal one. Add a
>> new wrapper in x86 ops for load_mmu_pgd() that either directs the write to
>> the existing vmx implementation or a TDX one.
>>
>> For the TDX operation, EPT will always be used, so it can simpy write to


Maybe remove "so"?  IMO, there is no causal relationship between the 
first and second half of the sentence.

Typo, "simpy" -> "simply"

>> the SHARED_EPT_POINTER field.
>


