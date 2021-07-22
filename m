Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6F003D2454
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 15:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbhGVM1p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 08:27:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:2347 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230418AbhGVM1m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jul 2021 08:27:42 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10052"; a="211641954"
X-IronPort-AV: E=Sophos;i="5.84,261,1620716400"; 
   d="scan'208";a="211641954"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2021 06:08:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,261,1620716400"; 
   d="scan'208";a="577228422"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga001.fm.intel.com with ESMTP; 22 Jul 2021 06:08:15 -0700
Received: from [10.212.167.204] (kliang2-MOBL.ccr.corp.intel.com [10.212.167.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 4183D5807B4;
        Thu, 22 Jul 2021 06:08:13 -0700 (PDT)
Subject: Re: [PATCH V8 00/18] KVM: x86/pmu: Add *basic* support to enable
 guest PEBS via DS
To:     Liuxiangdong <liuxiangdong5@huawei.com>, lingshan.zhu@intel.com,
        like.xu.linux@gmail.com
Cc:     ak@linux.intel.com, boris.ostrvsky@oracle.com, bp@alien8.de,
        eranian@google.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, peterz@infradead.org, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, wei.w.wang@intel.com,
        x86@kernel.org, Xiexiangyou <xiexiangyou@huawei.com>,
        "Fangyi (Eric)" <eric.fangyi@huawei.com>
References: <20210716085325.10300-1-lingshan.zhu@intel.com>
 <60F96A3F.3030703@huawei.com>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
Message-ID: <4e990190-069e-4769-b0be-7db7d721f8a6@linux.intel.com>
Date:   Thu, 22 Jul 2021 09:08:12 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <60F96A3F.3030703@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/22/2021 8:53 AM, Liuxiangdong wrote:
> Hi，like and lingshan.
> 
> We can use pebs on the Icelake by using "perf record -e $event:pp", but 
> how can we get all the supported $event for the Icelake?
> Because it seems like that all the hardware event/software event/kernel 
> pmu event listed by "perf list" can use ":pp" without error.
> 
> 
> By quering events list for Icelake("https://perfmon-events.intel.com/), 
> we can use "perf record -e cpu/event=0xXX,unask=0xXX/pp"
> to enable sampling. There are some events with "PEBS： 
> [PreciseEventingIP]" in "Additional Info" column. Are they the only 
> supported
> precise events? Do those events which have "PEBS:[NonPreciseEventingIP]" 
> in last column support PEBS?
>

Starts from Ice Lake, the extended PEBS feature is supported, which 
extend the PEBS for all counters and all performance monitoring events 
(both precise event and non-precise). You can sample any events with PEBS.
For details, please refer to the 18.9.1 extended PEBS in the latest SDM 
vol3.

Thanks,
Kan
