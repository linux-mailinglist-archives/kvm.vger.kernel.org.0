Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05520F8862
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 07:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725865AbfKLGIl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 01:08:41 -0500
Received: from mga03.intel.com ([134.134.136.65]:18506 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725298AbfKLGIl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 01:08:41 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Nov 2019 22:08:39 -0800
X-IronPort-AV: E=Sophos;i="5.68,295,1569308400"; 
   d="scan'208";a="197972475"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.239.196.122]) ([10.239.196.122])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 11 Nov 2019 22:08:38 -0800
Subject: Re: [PATCH v4 0/6] KVM: x86/vPMU: Efficiency optimization by reusing
 last created perf_event
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20191027105243.34339-1-like.xu@linux.intel.com>
 <20191028164324.GJ4097@hirez.programming.kicks-ass.net>
From:   Like Xu <like.xu@linux.intel.com>
Organization: Intel OTC
Message-ID: <dcbc78f5-c267-d5be-f4e8-deaebf91fe1f@linux.intel.com>
Date:   Tue, 12 Nov 2019 14:08:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191028164324.GJ4097@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On 2019/10/29 0:43, Peter Zijlstra wrote:
> On Sun, Oct 27, 2019 at 06:52:37PM +0800, Like Xu wrote:
>> For perf subsystem, please help review first two patches.
> 
>> Like Xu (6):
>>    perf/core: Provide a kernel-internal interface to recalibrate event
>>      period
>>    perf/core: Provide a kernel-internal interface to pause perf_event
> 
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> 

Would you mind to revisit the following patches for upstream ?

 >    KVM: x86/vPMU: Rename pmu_ops callbacks from msr_idx to rdpmc_ecx
 >    KVM: x86/vPMU: Introduce a new kvm_pmu_ops->msr_idx_to_pmc callback
 >    KVM: x86/vPMU: Reuse perf_event to avoid unnecessary
 >      pmc_reprogram_counter
 >    KVM: x86/vPMU: Add lazy mechanism to release perf_event per vPMC

For vPMU, please review two more patches as well:
+ 
https://lore.kernel.org/kvm/20191030164418.2957-1-like.xu@linux.intel.com/ 
(kvm)
+ 
https://lore.kernel.org/lkml/20191105140955.22504-1-like.xu@linux.intel.com/ 
(perf)

Thanks,
Like Xu
