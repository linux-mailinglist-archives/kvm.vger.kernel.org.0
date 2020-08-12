Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9440E242A1F
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 15:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgHLNOX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Aug 2020 09:14:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:34726 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726946AbgHLNOX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Aug 2020 09:14:23 -0400
IronPort-SDR: /44bTRQwz6tdS3e8XUEqktquuczn/OxXymDd1+JUVvIkpn2PTqZoWvyYOoO4v7wHdD5PbkLLoj
 vcOc1j7arwOA==
X-IronPort-AV: E=McAfee;i="6000,8403,9710"; a="141790260"
X-IronPort-AV: E=Sophos;i="5.76,304,1592895600"; 
   d="scan'208";a="141790260"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2020 06:14:22 -0700
IronPort-SDR: t2QBoItcDOpyhDAwHn2dS6eO1YG6/F2yQ38D6pum15YIN0mXB+KkWU/yhou43v7pzetzNPpgdH
 Coe14iNeqOhA==
X-IronPort-AV: E=Sophos;i="5.76,304,1592895600"; 
   d="scan'208";a="469817615"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.255.29.234]) ([10.255.29.234])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2020 06:14:18 -0700
Reply-To: like.xu@intel.com
Subject: Re: [PATCH] KVM: x86/pmu: Add '.exclude_hv = 1' for guest perf_event
To:     Paolo Bonzini <pbonzini@redhat.com>, peterz@infradead.org
Cc:     Like Xu <like.xu@linux.intel.com>, Yao <yao.jin@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
References: <20200812050722.25824-1-like.xu@linux.intel.com>
 <5c41978e-8341-a179-b724-9aa6e7e8a073@redhat.com>
 <20200812111115.GO2674@hirez.programming.kicks-ass.net>
 <65eddd3c-c901-1c5a-681f-f0cb07b5fbb1@redhat.com>
 <b55afd09-77c8-398b-309b-6bd9f9cfc876@intel.com>
 <8bdc60d5-c9ef-4e8f-6b73-b7bd012d9d30@redhat.com>
From:   "Xu, Like" <like.xu@intel.com>
Organization: Intel OTC
Message-ID: <69bac394-f10c-c0ad-a23d-36cbbd479212@intel.com>
Date:   Wed, 12 Aug 2020 21:14:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <8bdc60d5-c9ef-4e8f-6b73-b7bd012d9d30@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/8/12 21:04, Paolo Bonzini wrote:
> On 12/08/20 14:56, Xu, Like wrote:
>> My proposal is to define:
>> the "hypervisor privilege levels" events in the KVM/x86 context as
>> all the host kernel events plus /dev/kvm user space events.
> What are "/dev/kvm user space events"?  In any case, this patch should
> be included only in the series that adds exclude_hv support in arch/x86.
The exclude_kernel events from the QEMU or whoever else has opened /dev/kvm.

Do you see any (patches) gap if we map
the exclude_host events into exclude_hv events naturally ?

Thanks,
Like Xu
> Paolo
>
>> If we add ".exclude_hv = 1" in the pmc_reprogram_counter(),
>> do you see any side effect to cover the above usages?
>>
>> The fact that exclude_hv has never been used in x86 does help
>> the generic perf code to handle permission checks in a more concise way.

