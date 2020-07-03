Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB692135AD
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 10:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbgGCIEL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 04:04:11 -0400
Received: from mga04.intel.com ([192.55.52.120]:52311 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725648AbgGCIEL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jul 2020 04:04:11 -0400
IronPort-SDR: Dn229BWwKJqBlu1KVYhxAXyM8jmjxxWZBRTLv8NfopFnXZ/a+3GzGslbBBboSLQfirCDqFUQCC
 psYF8x8IkT4w==
X-IronPort-AV: E=McAfee;i="6000,8403,9670"; a="144635504"
X-IronPort-AV: E=Sophos;i="5.75,307,1589266800"; 
   d="scan'208";a="144635504"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2020 01:04:10 -0700
IronPort-SDR: GRIZLHlnhU/QaE2cFWz1y1zrS2QBl46fG2xKdUbPD2Bxojs26x5cUhZW3UKpQnWZPq4inLc1jB
 mi4DqQ/63sMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,307,1589266800"; 
   d="scan'208";a="481955282"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.128]) ([10.238.4.128])
  by fmsmga006.fm.intel.com with ESMTP; 03 Jul 2020 01:04:07 -0700
Reply-To: like.xu@intel.com
Subject: Re: [PATCH v12 00/11] Guest Last Branch Recording Enabling
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     "Liang, Kan" <kan.liang@linux.intel.com>,
        Like Xu <like.xu@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, ak@linux.intel.com,
        wei.w.wang@intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, "Liang, Kan" <kan.liang@intel.com>
References: <20200613080958.132489-1-like.xu@linux.intel.com>
 <20200702074059.GX4781@hirez.programming.kicks-ass.net>
 <5d3980e3-1c49-4174-4cdb-f40fc21ee6c1@linux.intel.com>
 <20200702135842.GR4800@hirez.programming.kicks-ass.net>
 <20200703075646.GJ117543@hirez.programming.kicks-ass.net>
From:   "Xu, Like" <like.xu@intel.com>
Organization: Intel OTC
Message-ID: <84a75c42-8a97-6771-9aab-3f9d3285486e@intel.com>
Date:   Fri, 3 Jul 2020 16:04:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200703075646.GJ117543@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/7/3 15:56, Peter Zijlstra wrote:
> On Thu, Jul 02, 2020 at 03:58:42PM +0200, Peter Zijlstra wrote:
>> On Thu, Jul 02, 2020 at 09:11:06AM -0400, Liang, Kan wrote:
>>> On 7/2/2020 3:40 AM, Peter Zijlstra wrote:
>>>> On Sat, Jun 13, 2020 at 04:09:45PM +0800, Like Xu wrote:
>>>>> Like Xu (10):
>>>>>     perf/x86/core: Refactor hw->idx checks and cleanup
>>>>>     perf/x86/lbr: Add interface to get LBR information
>>>>>     perf/x86: Add constraint to create guest LBR event without hw counter
>>>>>     perf/x86: Keep LBR records unchanged in host context for guest usage
>>>>> Wei Wang (1):
>>>>>     perf/x86: Fix variable types for LBR registers
>>>>>    arch/x86/events/core.c            |  26 +--
>>>>>    arch/x86/events/intel/core.c      | 109 ++++++++-----
>>>>>    arch/x86/events/intel/lbr.c       |  51 +++++-
>>>>>    arch/x86/events/perf_event.h      |   8 +-
>>>>>    arch/x86/include/asm/perf_event.h |  34 +++-
>>>> These look good to me; but at the same time Kan is sending me
>>>> Architectural LBR patches.
>>>>
>>>> Kan, if I take these perf patches and stick them in a tip/perf/vlbr
>>>> topic branch, can you rebase the arch lbr stuff on top, or is there
>>>> anything in the arch-lbr series that badly conflicts with this work?
>>>>
>>> Yes, I can rebase the arch lbr patches on top of them.
>>> Please push the tip/perf/vlbr branch, so I can pull and rebase my patches.
>> For now I have:
>>
>>    git://git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git perf/vlbr
>>
>> Once the 0day robot comes back all-green, I'll push it out to
>> tip/perf/vlbr and merge it into tip/perf/core.
> tip/perf/vlbr now exists, thanks!
Hi Peter,

Thanks for your patience and professional support on this feature!

Thanks,
Like Xu

