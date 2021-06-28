Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFFC43B5A1B
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 09:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbhF1H4P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 03:56:15 -0400
Received: from mga07.intel.com ([134.134.136.100]:4149 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229911AbhF1H4O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Jun 2021 03:56:14 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10028"; a="271763942"
X-IronPort-AV: E=Sophos;i="5.83,305,1616482800"; 
   d="scan'208";a="271763942"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2021 00:53:47 -0700
X-IronPort-AV: E=Sophos;i="5.83,305,1616482800"; 
   d="scan'208";a="446461048"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.249.171.151]) ([10.249.171.151])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2021 00:53:42 -0700
Subject: Re: [PATCH V7 00/18] KVM: x86/pmu: Add *basic* support to enable
 guest PEBS via DS
To:     "Wang, Wei W" <wei.w.wang@intel.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Cc:     "bp@alien8.de" <bp@alien8.de>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Yang, Weijiang" <weijiang.yang@intel.com>,
        "kan.liang@linux.intel.com" <kan.liang@linux.intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "eranian@google.com" <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "like.xu.linux@gmail.com" <like.xu.linux@gmail.com>,
        "Fangyi (Eric)" <eric.fangyi@huawei.com>,
        Xiexiangyou <xiexiangyou@huawei.com>
References: <20210622094306.8336-1-lingshan.zhu@intel.com>
 <60D5A487.8020507@huawei.com>
 <37832cc0-788d-91b9-dc95-147eca133842@intel.com>
 <81530ac3ebe74ada9b5d1dc8092c1a31@intel.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <1bfecd6b-e05a-c470-ef09-e398de8db521@intel.com>
Date:   Mon, 28 Jun 2021 15:53:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <81530ac3ebe74ada9b5d1dc8092c1a31@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/28/2021 3:49 PM, Wang, Wei W wrote:
> On Friday, June 25, 2021 5:46 PM, Zhu, Lingshan wrote:
>>> Only on the host?
>>> I cannot use pebs unless try with "echo 0 > /proc/sys/kernel/watchdog"
>>> both on the host and guest on ICX.
>> Hi Xiangdong
>>
>> I guess you may run into the "cross-map" case(slow path below), so I think you
>> can disable them both in host and guest to make PEBS work.
>>
> Hi Lingshan, could we also reproduce this issue?
>
> If the guest's watchdog takes away the virtual fixed counter, this will schedule the guest PEBS to use virtual PMC0. With the fast path (1:1 mapping), I think physical PMC0 is likely to be available for the guest PEBS emulation if no other host perf events are running.
I think it is possible, even a virtual counter need a perf event 
scheduled on the host. This depends on the guest / host workloads.

Thanks,
Zhu Lingshan
> Best,
> Wei

