Return-Path: <kvm+bounces-6201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F06C382D478
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 08:17:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9738D1F21446
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 07:17:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63E093D8E;
	Mon, 15 Jan 2024 07:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UuUvGpGw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E346928E3
	for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 07:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705303013; x=1736839013;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=frylx2i+xOJ2HS9ZVf2GocaKMEjHY2pnDO+LcA2z5qA=;
  b=UuUvGpGwh1KSPyTNXn5TVuVOBwP6jsryPEGLlTBRVj7iptTpr3/z2KhH
   cS6LbEhEw3QHB0MIdpN0HYSDlhhoDpsrRaF0HVPQ4rnXNYTNgKB+55tC0
   OTIhK/ZR0y1Q6mZ/DWzdWGvPa1XImqUxyDPlpIGK8ah2ykiRRTnI6ClUO
   WBgytod4B26e4wqPoFaEfHPVT+A3MM5asvI6jWa3udrW2HaUok2idEvHh
   IRG7/0XWz6dtv7iRdm2bWRdJnSrEJ8rn5hbxe6GSDfuabQiG9oWOWddl2
   Yw//m1+NQXGRgGuVEfR7B1TTWAK7ybaQ091K4MRbajkD3Trz8bHk0DjLW
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="21028331"
X-IronPort-AV: E=Sophos;i="6.04,196,1695711600"; 
   d="scan'208";a="21028331"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2024 23:16:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="783721538"
X-IronPort-AV: E=Sophos;i="6.04,196,1695711600"; 
   d="scan'208";a="783721538"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.22.149]) ([10.93.22.149])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2024 23:16:47 -0800
Message-ID: <00873298-06b5-4286-9c92-54376ed2d09d@intel.com>
Date: Mon, 15 Jan 2024 15:16:43 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 08/16] i386: Expose module level in CPUID[0x1F]
Content-Language: en-US
To: Zhao Liu <zhao1.liu@linux.intel.com>
Cc: Yuan Yao <yuan.yao@linux.intel.com>, Eduardo Habkost
 <eduardo@habkost.net>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 "Michael S . Tsirkin" <mst@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Zhenyu Wang <zhenyu.z.wang@intel.com>,
 Zhuocheng Ding <zhuocheng.ding@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Babu Moger <babu.moger@amd.com>, Yongwei Ma <yongwei.ma@intel.com>
References: <20240108082727.420817-1-zhao1.liu@linux.intel.com>
 <20240108082727.420817-9-zhao1.liu@linux.intel.com>
 <20240115032524.44q5ygb25ieut44c@yy-desk-7060> <ZaSv51/5Eokkv5Rr@intel.com>
 <336a4816-966d-42b0-b34b-47be3e41446d@intel.com> <ZaTM5njcfIgfsjqt@intel.com>
 <78168ef8-2354-483a-aa3b-9e184de65a72@intel.com> <ZaTSM8IAzQ1onX05@intel.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZaTSM8IAzQ1onX05@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/15/2024 2:35 PM, Zhao Liu wrote:
> On Mon, Jan 15, 2024 at 02:11:17PM +0800, Xiaoyao Li wrote:
>> Date: Mon, 15 Jan 2024 14:11:17 +0800
>> From: Xiaoyao Li <xiaoyao.li@intel.com>
>> Subject: Re: [PATCH v7 08/16] i386: Expose module level in CPUID[0x1F]
>>
>> On 1/15/2024 2:12 PM, Zhao Liu wrote:
>>> Hi Xiaoyao,
>>>
>>> On Mon, Jan 15, 2024 at 12:34:12PM +0800, Xiaoyao Li wrote:
>>>> Date: Mon, 15 Jan 2024 12:34:12 +0800
>>>> From: Xiaoyao Li <xiaoyao.li@intel.com>
>>>> Subject: Re: [PATCH v7 08/16] i386: Expose module level in CPUID[0x1F]
>>>>
>>>>> Yes, I think it's time to move to default 0x1f.
>>>>
>>>> we don't need to do so until it's necessary.
>>>
>>> Recent and future machines all support 0x1f, and at least SDM has
>>> emphasized the preferred use of 0x1f.
>>
>> The preference is the guideline for software e.g., OS. QEMU doesn't need to
>> emulate cpuid leaf 0x1f to guest if there is only smt and core level.
> 
> Please, QEMU is emulating hardware not writing software.

what I want to conveyed was that, SDM is teaching software how to probe 
the cpu topology, not suggesting VMM how to advertise cpu topology to 
guest.


> Is there any
> reason why we shouldn't emulate new and generic hardware behaviors and
> stick with the old ones?

I didn't say we shouldn't, but we don't need to do it if it's unnecessary.

if cpuid 0x1f is advertised to guest by default, it will also introduce 
the inconsistence. Old product doesn't have cpuid 0x1f, but using QEMU 
to emualte an old product, it has.

sure we can have code to fix it, that only expose 0x1f to new enough cpu 
model. But it just make thing complicated.

>> because in this case, they are exactly the same in leaf 0xb and 0x1f. we don't
>> need to bother advertising the duplicate data.
> 
> You can't "define" the same 0x0b and 0x1f as duplicates. SDM doesn't
> have such the definition.

for QEMU, they are duplicate data that need to be maintained and need to 
be passed to KVM by KVM_SET_CPUID. For guest, it's also unnecessary, 
because it doesn't provide any additional information with cpuid leaf 1f.

SDM keeps cpuid 0xb is for backwards compatibility.

> Regards,
> Zhao
> 


