Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF8BD212431
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 15:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbgGBNLJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 09:11:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:23198 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726289AbgGBNLJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 09:11:09 -0400
IronPort-SDR: sDg8L576F7YQEVZNm0Vm8xjBduSmo/sjXxJj+u0ytwBtVN3Tgf45LB1RKCENxZ44Bf9XNoqPAz
 ZgqZ/6H8Qqsg==
X-IronPort-AV: E=McAfee;i="6000,8403,9669"; a="148436179"
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="148436179"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 06:11:08 -0700
IronPort-SDR: IHfdyl2pAFxYqwhYkcXtsE801l3ob4ycN1yS8WjoGAhCVCPycGrsV4bi17aMtCSLemNwsBXKvZ
 SxVGNs7IsFnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="425945302"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga004.jf.intel.com with ESMTP; 02 Jul 2020 06:11:08 -0700
Received: from [10.254.75.126] (kliang2-mobl.ccr.corp.intel.com [10.254.75.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 6E1B258041D;
        Thu,  2 Jul 2020 06:11:07 -0700 (PDT)
Subject: Re: [PATCH v12 00/11] Guest Last Branch Recording Enabling
To:     Peter Zijlstra <peterz@infradead.org>,
        Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, ak@linux.intel.com,
        wei.w.wang@intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, "Liang, Kan" <kan.liang@intel.com>
References: <20200613080958.132489-1-like.xu@linux.intel.com>
 <20200702074059.GX4781@hirez.programming.kicks-ass.net>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
Message-ID: <5d3980e3-1c49-4174-4cdb-f40fc21ee6c1@linux.intel.com>
Date:   Thu, 2 Jul 2020 09:11:06 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200702074059.GX4781@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/2/2020 3:40 AM, Peter Zijlstra wrote:
> On Sat, Jun 13, 2020 at 04:09:45PM +0800, Like Xu wrote:
>> Like Xu (10):
>>    perf/x86/core: Refactor hw->idx checks and cleanup
>>    perf/x86/lbr: Add interface to get LBR information
>>    perf/x86: Add constraint to create guest LBR event without hw counter
>>    perf/x86: Keep LBR records unchanged in host context for guest usage
> 
>> Wei Wang (1):
>>    perf/x86: Fix variable types for LBR registers
> 
>>   arch/x86/events/core.c            |  26 +--
>>   arch/x86/events/intel/core.c      | 109 ++++++++-----
>>   arch/x86/events/intel/lbr.c       |  51 +++++-
>>   arch/x86/events/perf_event.h      |   8 +-
>>   arch/x86/include/asm/perf_event.h |  34 +++-
> 
> These look good to me; but at the same time Kan is sending me
> Architectural LBR patches.
> 
> Kan, if I take these perf patches and stick them in a tip/perf/vlbr
> topic branch, can you rebase the arch lbr stuff on top, or is there
> anything in the arch-lbr series that badly conflicts with this work?
> 

Yes, I can rebase the arch lbr patches on top of them.
Please push the tip/perf/vlbr branch, so I can pull and rebase my patches.

Thanks,
Kan
