Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D891D964C
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 14:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728837AbgESM2u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 08:28:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:4226 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbgESM2t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 08:28:49 -0400
IronPort-SDR: H3ppRK/QbAbfQ7L+897+IIXlODkM9cQt8CYmVQMMZT7fAyTmEwZehKM6LXVToOV5zAiy2UV7e3
 I4235JfSvCVw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 05:28:49 -0700
IronPort-SDR: 0qz1fTbCA8AzCc+0s2WPO7+ywOJTObWO9Tyx5lUSKxVb8iLa2/PJ1T5lOvRSFLLFZG319eQpSe
 L/EWM6fGstqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,410,1583222400"; 
   d="scan'208";a="288941413"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.249.171.98]) ([10.249.171.98])
  by fmsmga004.fm.intel.com with ESMTP; 19 May 2020 05:28:46 -0700
Reply-To: like.xu@intel.com
Subject: Re: [PATCH v11 08/11] KVM: x86/pmu: Emulate LBR feature via guest LBR
 event
To:     Peter Zijlstra <peterz@infradead.org>,
        Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>, ak@linux.intel.com,
        wei.w.wang@intel.com
References: <20200514083054.62538-1-like.xu@linux.intel.com>
 <20200514083054.62538-9-like.xu@linux.intel.com>
 <20200519110104.GH279861@hirez.programming.kicks-ass.net>
From:   "Xu, Like" <like.xu@intel.com>
Organization: Intel OTC
Message-ID: <6ef6e9d0-d344-b482-4430-0d720b52ea7b@intel.com>
Date:   Tue, 19 May 2020 20:28:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200519110104.GH279861@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/5/19 19:01, Peter Zijlstra wrote:
> On Thu, May 14, 2020 at 04:30:51PM +0800, Like Xu wrote:
>
>> +	struct perf_event_attr attr = {
>> +		.type = PERF_TYPE_RAW,
>> +		.size = sizeof(attr),
>> +		.pinned = true,
>> +		.exclude_host = true,
>> +		.config = INTEL_FIXED_VLBR_EVENT,
>> +		.sample_type = PERF_SAMPLE_BRANCH_STACK,
>> +		.branch_sample_type = PERF_SAMPLE_BRANCH_CALL_STACK |
>> +					PERF_SAMPLE_BRANCH_USER,
> Maybe order the fields according to how they're declared in the
> structure?
Sure,  I'll sort the fields in the order of declaration. Thanks.
>> +	};

