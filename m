Return-Path: <kvm+bounces-33903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4081C9F41BE
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 05:27:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 89B1B16D723
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 04:27:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 504EB14659D;
	Tue, 17 Dec 2024 04:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YNE2E9r3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE2F13D25E
	for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 04:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734409661; cv=none; b=RHe6H69W1wIAghyKRL+HfWPW1IH4UlYNcA9nkbK96DfFg56ufgPEhV+Z0VDCQZPeu3dnrB3zTy/1UjzmxCykSFvOz+bKqo66kgaxK5pK1hzZUp0G60LT2u8/npEE4pmxHCUBAan7J8jqcTSbdJ6kZE3no9VK9cfrS8wYx0+YmoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734409661; c=relaxed/simple;
	bh=a7SOYsckgzbJ2IhBtbx6TFv6Y0JwRMRvfwJSihNSIiM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bKOqfQM0U9QnCe9onzbTVrGSjTNqIjJrp7iCKCjcqNn+86x6c9ZazGNyfG1nfyyUiCfegO25IEu0xgoF7T8vQ0LK1057tD/3tFo+LLuwAYvXmQKHIXQQkUOzuvGCYbI4l/2l65UpsSaqipGXULCM24Rn/UiXGMW2OrTCS24elSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YNE2E9r3; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734409660; x=1765945660;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=a7SOYsckgzbJ2IhBtbx6TFv6Y0JwRMRvfwJSihNSIiM=;
  b=YNE2E9r3N9s4lb379KMZ3xYVz7OBCzfHp8QF9sX5LNJtIU2t96MENySc
   MxVfCX3bbr5f+wCJt/mD/WSD6cCkl55hkIin04dOMCmjk4MAIOuYZGTGn
   1ZyKzBipI2Ezw9mzSv0wu8tReWVdxcnirKsGbsrzngiKLzpN0Otn2oN9J
   PRB7aDS3zAh0miSxXxwxnn2Y6LnDcRghY3r4yjmQ01EdYe7qSF+0Y77IC
   inMxjx05cjdIIeyOfTyN73SzgGB7tcB8hWoyRy/VZGYW0T/tI9AsMM4Wg
   CICQwd9V0/e8ESj4PFHYZPSwOMjSVP2ri7OvRc24W6t8NWNR+GSCCXJqG
   Q==;
X-CSE-ConnectionGUID: v5Nb3uq0QQygOs8qZq0sag==
X-CSE-MsgGUID: d5xpI/DXQkCrkd6qUoVyjQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11288"; a="52231194"
X-IronPort-AV: E=Sophos;i="6.12,240,1728975600"; 
   d="scan'208";a="52231194"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2024 20:27:39 -0800
X-CSE-ConnectionGUID: Yx7LxBZvRUW6GNRiShxAzw==
X-CSE-MsgGUID: 1wfG0Y1bSKmoORcFDq76Tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,240,1728975600"; 
   d="scan'208";a="97985121"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2024 20:27:35 -0800
Message-ID: <eedbef51-ab8f-4d28-af8b-ba405d060015@intel.com>
Date: Tue, 17 Dec 2024 12:27:33 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (Proposal) New TDX Global Metadata To Report FIXED0 and FIXED1
 CPUID Bits
To: Sean Christopherson <seanjc@google.com>,
 Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>,
 Kai Huang <kai.huang@intel.com>,
 "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Yan Y Zhao <yan.y.zhao@intel.com>,
 "tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 Adrian Hunter <adrian.hunter@intel.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
References: <43b26df1-4c27-41ff-a482-e258f872cc31@intel.com>
 <d63e1f3f0ad8ead9d221cff5b1746dc7a7fa065c.camel@intel.com>
 <e7ca010e-fe97-46d0-aaae-316eef0cc2fd@intel.com>
 <269199260a42ff716f588fbac9c5c2c2038339c4.camel@intel.com>
 <Z2DZpJz5K9W92NAE@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <Z2DZpJz5K9W92NAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/17/2024 9:53 AM, Sean Christopherson wrote:
> On Tue, Dec 10, 2024, Rick P Edgecombe wrote:
>> On Tue, 2024-12-10 at 11:22 +0800, Xiaoyao Li wrote:
>>>> The solution in this proposal decreases the work the VMM has to do, but
>>>> in the long term won't remove hand coding completely. As long as we are
>>>> designing something, what kind of bar should we target?
>>>
>>> For this specific #VE reduction case, I think userspace doesn't need to
>>> do any hand coding. Userspace just treats the bits related to #VE
>>> reduction as configurable as reported by TDX module/KVM. And userspace
>>> doesn't care if the value seen by TD guest is matched with what gets
>>> configured by it because they are out of control of userspace.
>>
>> Besides a specific problem, here reduced #VE is also an example of increasing
>> complexity for TD CPUID. If we have more things like it, it could make this
>> interface too rigid.
> 
> I agree with Rick in that having QEMU treat them as configurable is going to be
> a disaster.  But I don't think it's actually problematic in practice.

Correct the proposal. It should be QEMU treats them as what KVM reports.

TDX module reports these #VE reduction related CPUIDs as configurable 
because it allows VMM to paravirt them. If KVM doesn't support the 
paravirt of them, KVM can clear them from configurable bits and add them 
to fixed0 bits when KVM reports to userspace.

> If QEMU (or KVM) has no visibility into the state of the guest's view of the
> affected features, then it doesn't matter whether they are fixed or configurable.
> They're effectively Schrödinger's bits: until QEMU/KVM actually looks at them,
> they're neither dead nor alive, and since QEMU/KVM *can't* look at them, who cares?

To some degree, I think it matters. As I explained above, if KVM reports 
it as configurable to userspace, it mean TDX module allows it to be 
configured and KVM allows it to be paravirtualized as well. So userspace 
can configure it as 1 when users wants it. This is how VMM is going to 
present the feature to TD guest.

However, how TD guest is going to use it depends on itself.
1) when TD guest doesn't enable #VE reduction: the configuration from 
VMM doesn't matter. The CPUIDs are fixed1 and related operation leads to 
#VE.

2) When TD guest enables #VE reduction and doesn't enable 
TDCS.FEATURE_PARAVIRT_CTRL of the related bit: the configuration from 
VMM doesn't matter. The CPUIDs are fixed0 and related operation leads to 
#GP.

3) When TD guest enables #VE reduction and enable 
TDCS.FEATURE_PARAVIRT_CTRL of the related bit: the configuration from 
VMM matters.
   - When VMM configures the bits to 1, the related operation leads to 
#VE (for paravirtualization).
   - When VMM configures the bits to 0, the related operation leads to #GP.

So for case 3), it does matters.

> So, if the TDX Module *requires* them to be set/cleared when the TD is created,
> then they should be reported as fixed.  If the TDX module doesn't care, then they
> should be reported as configurable.  The fact that the guest can muck with things
> under the hood doesn't factor into that logic.

yes, I agree on it.

> If TDX pulls something like this for features that KVM cares about, then we have
> problems, but that's already true today.  If a feature requires KVM support, it
> doesn't really matter if the feature is fixed or configurable.  What matters is
> that KVM has a chance to enforce that the feature can be used by the guest if
> and only if KVM has the proper support in place.  Because if KVM is completely
> unaware of a feature, it's impossible for KVM to know that the feature needs to
> be rejected.

I agree.

With the proposed fixed/fixed1 information, and in addition to the 
configurable bits, KVM can fully validate the TDX module against its 
capabilities. When violation occurs (e.g., some KVM unsupported bit 
being reported as fixed1 by TDX module), KVM can just refuse to enable TDX.

> This isn't unique to TDX, CoCo, or firmware.  Every new feature that lands in
> hardware needs to either be "benign" or have the appropriate virtualization
> controls.  KVM already has to deal with cases where features can effectively be
> used without KVM's knowledge.  E.g. there are plenty of instruction-level
> virtualization holes, and SEV-ES doubled down by essentially forcing KVM to let
> the guest write XCR0 and XSS directly.
> 
> It all works, so long as the hardware vendor doesn't screw up and let the guest
> use a feature that impacts host safety and/or functionality, without the hypervisor's
> knowledge.
> 
> So, just don't screw up :-)


