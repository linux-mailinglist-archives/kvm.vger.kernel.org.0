Return-Path: <kvm+bounces-274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BBA927DDB67
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 04:16:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 76CE81C20D1A
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 03:16:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 505A11100;
	Wed,  1 Nov 2023 03:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Dn9SXK4Y"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E51A32
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 03:16:07 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8B6A4;
	Tue, 31 Oct 2023 20:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698808563; x=1730344563;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=saaKNKCsevz6fHFrJEAzjrPd1r0TCI63AXuP13gD10A=;
  b=Dn9SXK4YaefO9J8EbzY+d7yeMClQfwJiOLVPVJavefG5U6dptGDtw0FL
   K+SCq/lV1U29iYAcqc1hCjmBNkMJIOBRZO413blscLuj3WsIxWlrtwk+B
   2PnzTVvRVv7U8T7HjUzIhwXixd1fEYRLO4vPfUflXxmZep9XeOF1WQwlj
   piUxeK6fg3F2DF8/VYDPzRn+FN8bC+/QGU8Cm/LVJoUCHmelTOa6K7r68
   76AGE/ZW0nKi4GHCKmNIQKXac82n8OVDRbN8FKQ+ihmuGopNgXV596Wqf
   CQpgCA0KZmOPWee10OpyPRBge553V2UiQxuSR8/DLEIUoDsOL/9oqeo/Q
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10880"; a="373474001"
X-IronPort-AV: E=Sophos;i="6.03,267,1694761200"; 
   d="scan'208";a="373474001"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2023 20:16:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,267,1694761200"; 
   d="scan'208";a="1964523"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.93.12.33]) ([10.93.12.33])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2023 20:16:00 -0700
Message-ID: <fbad1983-5cde-4c7b-aaed-412110fe737f@linux.intel.com>
Date: Wed, 1 Nov 2023 11:15:57 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests Patch v2 4/5] x86: pmu: Support validation for
 Intel PMU fixed counter 3
Content-Language: en-US
To: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>,
 Zhang Xiong <xiong.y.zhang@intel.com>, Mingwei Zhang <mizhang@google.com>,
 Like Xu <like.xu.linux@gmail.com>, Dapeng Mi <dapeng1.mi@intel.com>
References: <20231031092921.2885109-1-dapeng1.mi@linux.intel.com>
 <20231031092921.2885109-5-dapeng1.mi@linux.intel.com>
 <CALMp9eQ4Xj5D-kgqVMKUNmdF37rLcMRXyDYdQU339sRCKZ7d9A@mail.gmail.com>
 <28796dd3-ac4e-4a38-b9e1-f79533b2a798@linux.intel.com>
 <CALMp9eRH5pttOA5BApdVeSbbkOU-kWcOWAoGMfK-9f=cy2Jf0g@mail.gmail.com>
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <CALMp9eRH5pttOA5BApdVeSbbkOU-kWcOWAoGMfK-9f=cy2Jf0g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 11/1/2023 10:47 AM, Jim Mattson wrote:
> On Tue, Oct 31, 2023 at 7:33 PM Mi, Dapeng <dapeng1.mi@linux.intel.com> wrote:
>>
>> On 11/1/2023 2:47 AM, Jim Mattson wrote:
>>> On Tue, Oct 31, 2023 at 2:22 AM Dapeng Mi <dapeng1.mi@linux.intel.com> wrote:
>>>> Intel CPUs, like Sapphire Rapids, introduces a new fixed counter
>>>> (fixed counter 3) to counter/sample topdown.slots event, but current
>>>> code still doesn't cover this new fixed counter.
>>>>
>>>> So this patch adds code to validate this new fixed counter can count
>>>> slots event correctly.
>>> I'm not convinced that this actually validates anything.
>>>
>>> Suppose, for example, that KVM used fixed counter 1 when the guest
>>> asked for fixed counter 3. Wouldn't this test still pass?
>>
>> Per my understanding, as long as the KVM returns a valid count in the
>> reasonable count range, we can think KVM works correctly. We don't need
>> to entangle on how KVM really uses the HW, it could be impossible and
>> unnecessary.
> Now, I see how the Pentium FDIV bug escaped notice. Hey, the numbers
> are in a reasonable range. What's everyone upset about?
>
>> Yeah, currently the predefined valid count range may be some kind of
>> loose since I want to cover as much as hardwares and avoid to cause
>> regression. Especially after introducing the random jump and clflush
>> instructions, the cycles and slots become much more hard to predict.
>> Maybe we can have a comparable restricted count range in the initial
>> change, and we can loosen the restriction then if we encounter a failure
>> on some specific hardware. do you think it's better? Thanks.
> I think the test is essentially useless, and should probably just be
> deleted, so that it doesn't give a false sense of confidence.

IMO, I can't say the tests are totally useless. Yes,  passing the tests 
doesn't mean the KVM vPMU must work correctly, but we can say there is 
something probably wrong if it fails to pass these tests. Considering 
the hardware differences, it's impossible to set an exact value for 
these events in advance and it seems there is no better method to verify 
the PMC count as well. I still prefer to keep these tests until we have 
a better method to verify the accuracy of the PMC count.



