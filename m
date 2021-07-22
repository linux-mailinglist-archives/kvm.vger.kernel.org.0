Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631793D1C2D
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 05:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbhGVCXU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 22:23:20 -0400
Received: from mga07.intel.com ([134.134.136.100]:16804 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230093AbhGVCXT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 22:23:19 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10052"; a="275374957"
X-IronPort-AV: E=Sophos;i="5.84,259,1620716400"; 
   d="scan'208";a="275374957"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2021 20:03:54 -0700
X-IronPort-AV: E=Sophos;i="5.84,259,1620716400"; 
   d="scan'208";a="512019825"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.255.29.38]) ([10.255.29.38])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2021 20:03:46 -0700
Subject: Re: [PATCH V8 01/18] perf/core: Use static_call to optimize
 perf_guest_info_callbacks
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     bp@alien8.de, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kan.liang@linux.intel.com, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        boris.ostrvsky@oracle.com, Like Xu <like.xu@linux.intel.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Guo Ren <guoren@kernel.org>, Nick Hu <nickhu@andestech.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-csky@vger.kernel.org, linux-riscv@lists.infradead.org,
        xen-devel@lists.xenproject.org,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20210716085325.10300-1-lingshan.zhu@intel.com>
 <20210716085325.10300-2-lingshan.zhu@intel.com>
 <fd117e37-8063-63a4-43cd-7cb555e5bab5@gmail.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <e8a7de91-fe48-c570-3cea-a296278a7c8a@intel.com>
Date:   Thu, 22 Jul 2021 11:03:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <fd117e37-8063-63a4-43cd-7cb555e5bab5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/21/2021 7:57 PM, Like Xu wrote:
> On 16/7/2021 4:53 pm, Zhu Lingshan wrote:
>> +    } else if (xenpmu_data->pmu.r.regs.cpl & 3)
>
> Lingshan, serious for this version ?
>
> arch/x86/xen/pmu.c:438:9: error: expected identifier or ‘(’ before 
> ‘return’
>   438 |         return state;
>       |         ^~~~~~
> arch/x86/xen/pmu.c:439:1: error: expected identifier or ‘(’ before ‘}’ 
> token
>   439 | }
>       | ^
> arch/x86/xen/pmu.c: In function ‘xen_guest_state’:
> arch/x86/xen/pmu.c:436:9: error: control reaches end of non-void 
> function [-Werror=return-type]
>   436 |         }
>       |         ^
> cc1: some warnings being treated as errors
>
>> +            state |= PERF_GUEST_USER;
>>       }
forgot to enable XEN build in .config, V9 fixes this will come soon
