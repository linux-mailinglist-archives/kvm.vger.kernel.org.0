Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC05D3833C5
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 17:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242258AbhEQPCB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 11:02:01 -0400
Received: from mga12.intel.com ([192.55.52.136]:52859 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242559AbhEQO7z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 10:59:55 -0400
IronPort-SDR: OqUwtqWNYDfdDO3uFAqmgaq9Xdf5evGw+DmvOrl/3Nhhf2GL1ufZIFiyFCbKMKt+9DBaAIRiWd
 omE2D+2yHPjw==
X-IronPort-AV: E=McAfee;i="6200,9189,9987"; a="180080141"
X-IronPort-AV: E=Sophos;i="5.82,307,1613462400"; 
   d="scan'208";a="180080141"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2021 07:50:26 -0700
IronPort-SDR: iIgpmFCjC+ba4PHw13ILGS1IQbgwQUXRhKvrLaJrySRFIcicr/hLb428X1DYTCkt3PCUMCgoEw
 kxVuVGQPc3IA==
X-IronPort-AV: E=Sophos;i="5.82,307,1613462400"; 
   d="scan'208";a="410852673"
Received: from akleen-mobl1.amr.corp.intel.com (HELO [10.212.163.36]) ([10.212.163.36])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2021 07:50:13 -0700
Subject: Re: [PATCH v6 08/16] KVM: x86/pmu: Add IA32_DS_AREA MSR emulation to
 support guest DS
To:     Peter Zijlstra <peterz@infradead.org>,
        Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        Kan Liang <kan.liang@linux.intel.com>, wei.w.wang@intel.com,
        eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
References: <20210511024214.280733-1-like.xu@linux.intel.com>
 <20210511024214.280733-9-like.xu@linux.intel.com>
 <YKJvC5T5UOoCFwhL@hirez.programming.kicks-ass.net>
From:   Andi Kleen <ak@linux.intel.com>
Message-ID: <3b13359c-5b7a-f103-74ff-1f57389db181@linux.intel.com>
Date:   Mon, 17 May 2021 07:50:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YKJvC5T5UOoCFwhL@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/17/2021 6:26 AM, Peter Zijlstra wrote:
> On Tue, May 11, 2021 at 10:42:06AM +0800, Like Xu wrote:
>> @@ -3897,6 +3898,8 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
>>   {
>>   	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
>>   	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
>> +	struct debug_store *ds = __this_cpu_read(cpu_hw_events.ds);
>> +	struct kvm_pmu *pmu = (struct kvm_pmu *)data;
> You can do without the cast, this is C, 'void *' silently casts to any
> other pointer type.

FWIW doing the C++ like casts for void * is fairly standard C coding 
style. I generally prefer it too for better documentation. K&R is 
written this way.

-Andi (my last email on this topic to avoid any bike shedding)


