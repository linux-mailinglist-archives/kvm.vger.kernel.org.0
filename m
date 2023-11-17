Return-Path: <kvm+bounces-1910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C352B7EEBF5
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 06:26:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F7621F24596
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 05:26:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7B28D2E2;
	Fri, 17 Nov 2023 05:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QFYOBjul"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D50D4A;
	Thu, 16 Nov 2023 21:26:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700198768; x=1731734768;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RV8fvqjrUV0BSx8JFW/NdoI1Bmp5l5A2r3kiF0HPx54=;
  b=QFYOBjul2qc/QbLeLs7Gv2lZoKw/dJmrzE0YWTV8pvDiEZpCDciTMrDF
   jZOZYBGKJL4h/ZvlFFeZ7EcAuGTBkzvlrOa/fisD4e0gg4T1rnTPeJkSJ
   +b+3gZvlbJ30ygT1xyBX2w4cgnvcjRlP12Xu+otDIxGqo1mrQBO1SkQ8w
   UoL731OM9GUlSttZTgnEgGi8I4jaleocfFfvodjasTNdNyuOXAIUjHetk
   LxOLQTa0GTkDP2r0Pjbh1lwOIAEHbIADnkGyD0cQXb3UlvOANiCFAnJl8
   YzOw0ndi7Y7SqnusE82ok6w2MHSekqZ15Zj89w0CW5xu4dju5Kv870dy4
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10896"; a="395163698"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="395163698"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2023 21:26:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10896"; a="769127386"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="769127386"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.126]) ([10.238.10.126])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2023 21:25:59 -0800
Message-ID: <e3e71256-3673-495e-a4b7-985c4aac4bd2@linux.intel.com>
Date: Fri, 17 Nov 2023 13:25:57 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 059/116] KVM: TDX: Create initial guest memory
To: Isaku Yamahata <isaku.yamahata@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
 Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
 Sean Christopherson <seanjc@google.com>, Sagi Shahar <sagis@google.com>,
 David Matlack <dmatlack@google.com>, Kai Huang <kai.huang@intel.com>,
 Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com, hang.yuan@intel.com,
 tina.zhang@intel.com, gkirkpatrick@google.com
References: <cover.1699368322.git.isaku.yamahata@intel.com>
 <e8fdc92439efeed0ee05f39b1cd2dc1023014c11.1699368322.git.isaku.yamahata@intel.com>
 <c9413cb8-8aae-4233-b55f-fbac91459173@linux.intel.com>
 <20231117000458.GB1277973@ls.amr.corp.intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20231117000458.GB1277973@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/17/2023 8:04 AM, Isaku Yamahata wrote:
> On Thu, Nov 16, 2023 at 02:35:33PM +0800,
> Binbin Wu <binbin.wu@linux.intel.com> wrote:
>
>>
>> On 11/7/2023 10:56 PM, isaku.yamahata@intel.com wrote:
>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>>
>>> Because the guest memory is protected in TDX, the creation of the initial
>>> guest memory requires a dedicated TDX module API, tdh_mem_page_add, instead
>>> of directly copying the memory contents into the guest memory in the case
>>> of the default VM type.  KVM MMU page fault handler callback,
>>> private_page_add, handles it.
>>>
>>> Define new subcommand, KVM_TDX_INIT_MEM_REGION, of VM-scoped
>>> KVM_MEMORY_ENCRYPT_OP.  It assigns the guest page, copies the initial
>>> memory contents into the guest memory, encrypts the guest memory.  At the
>>> same time, optionally it extends memory measurement of the TDX guest.  It
>>> calls the KVM MMU page fault(EPT-violation) handler to trigger the
>>> callbacks for it.
>>>
>>> Reported-by: gkirkpatrick@google.com
>>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>>>
>>> ---
>>> v15 -> v16:
>>> - add check if nr_pages isn't large with
>>>     (nr_page << PAGE_SHIFT) >> PAGE_SHIFT
>>>
>>> v14 -> v15:
>>> - add a check if TD is finalized or not to tdx_init_mem_region()
>>> - return -EAGAIN when partial population
>>> ---
>>>    arch/x86/include/uapi/asm/kvm.h       |   9 ++
>>>    arch/x86/kvm/mmu/mmu.c                |   1 +
>>>    arch/x86/kvm/vmx/tdx.c                | 167 +++++++++++++++++++++++++-
>>>    arch/x86/kvm/vmx/tdx.h                |   2 +
>>>    tools/arch/x86/include/uapi/asm/kvm.h |   9 ++
>>>    5 files changed, 185 insertions(+), 3 deletions(-)
>>>
>> [...]
>>> +static int tdx_sept_page_add(struct kvm *kvm, gfn_t gfn,
>>> +			     enum pg_level level, kvm_pfn_t pfn)
>> For me, the function name is a bit confusing.
>> I would relate it to a SEPT table page instead of a normal private page if
>> only by the function name.
>>
>> Similar to tdx_sept_page_aug(), though it's less confusing due to there is
>> no seam call to aug a sept table page.
> How about tdx_mem_page_{add, aug}()?

It looks good to me.



