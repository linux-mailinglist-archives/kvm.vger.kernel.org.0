Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46CC4387CFB
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 17:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350514AbhERQAA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 12:00:00 -0400
Received: from mga12.intel.com ([192.55.52.136]:59296 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350480AbhERQAA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 12:00:00 -0400
IronPort-SDR: I4icwcyBGH0WRQL2wJT/hr+E/BqQburqg0kCTm2+SCNop0o0zioiNglfvdbfrAJCPf6e+QDgW1
 5am3FCcibibA==
X-IronPort-AV: E=McAfee;i="6200,9189,9988"; a="180350377"
X-IronPort-AV: E=Sophos;i="5.82,310,1613462400"; 
   d="scan'208";a="180350377"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2021 08:58:42 -0700
IronPort-SDR: gwcrRvapQ5urxi4Wy2gp2NUyzC3i98kMC24kJg9A3btzEjKOHnjQ0KFqSEvL84tmVWOywxCo4V
 LeacXH6R2Pnw==
X-IronPort-AV: E=Sophos;i="5.82,310,1613462400"; 
   d="scan'208";a="439501389"
Received: from msaber-mobl.amr.corp.intel.com (HELO [10.209.65.183]) ([10.209.65.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2021 08:58:41 -0700
Subject: Re: [PATCH v6 07/16] KVM: x86/pmu: Reprogram PEBS event to emulate
 guest PEBS counter
To:     "Xu, Like" <like.xu@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
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
 <20210511024214.280733-8-like.xu@linux.intel.com>
 <YKIrtdbXRcZSiohg@hirez.programming.kicks-ass.net>
 <ff5a419f-188f-d14c-72c8-4b760052734d@linux.intel.com>
 <YKN/DVNt847iEctd@hirez.programming.kicks-ass.net>
 <852ab586-2438-c7fc-c41d-0862e2f1b7ca@intel.com>
From:   Andi Kleen <ak@linux.intel.com>
Message-ID: <052e8584-fbc6-ddc7-c873-f46168aae63b@linux.intel.com>
Date:   Tue, 18 May 2021 08:58:40 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <852ab586-2438-c7fc-c41d-0862e2f1b7ca@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


>
> By "precdist", do you mean the"Precise Distribution of Instructions 
> Retired (PDIR) Facility"?


This was referring to perf's precise_ip field


>
> The SDM says Ice Lake Microarchitecture does support PEBS-PDIR on 
> IA32_FIXED0 only.
> And this patch kit enables it in the patch 0011, please take a look.
>
> Or do I miss something about precdist on ICL ?


On Icelake everything is fine

It just would need changes on other CPUs, but that can be done later.


-Andi


