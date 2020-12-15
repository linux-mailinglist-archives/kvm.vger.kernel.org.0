Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD85D2DA5C0
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 02:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730882AbgLOBov (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 20:44:51 -0500
Received: from mga14.intel.com ([192.55.52.115]:28304 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730518AbgLOBoi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 20:44:38 -0500
IronPort-SDR: YzIKhzhrT1rPkx3Pg2t9eE1240/Rl4K6ErVpxDb6XbqyLaDKqHiFaRsOrvMcnaVPxrEjvolrno
 7w+8yi4G9koQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9835"; a="174040107"
X-IronPort-AV: E=Sophos;i="5.78,420,1599548400"; 
   d="scan'208";a="174040107"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2020 17:43:54 -0800
IronPort-SDR: r43YeJ0x+cZDU79EEEMoj44I5pRG8gy/eKeMKfrsmVRxRhHiDm+GJsNF2Jcx3/Kxq0kaqg407+
 r8pNKscCUbtg==
X-IronPort-AV: E=Sophos;i="5.78,420,1599548400"; 
   d="scan'208";a="367838620"
Received: from zhangj4-mobl.ccr.corp.intel.com (HELO [10.238.130.84]) ([10.238.130.84])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2020 17:43:50 -0800
Subject: Re: [PATCH 0/2] Enumerate and expose AVX512_FP16 feature
To:     Paolo Bonzini <pbonzini@redhat.com>,
        sean.j.christopherson@intel.com,
        Kyung Min Park <kyung.min.park@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com
References: <20201208033441.28207-1-kyung.min.park@intel.com>
 <a10c6b11-9e70-23ac-cdb2-141bb913de3d@redhat.com>
From:   "Zhang, Cathy" <cathy.zhang@intel.com>
Message-ID: <6b9fd7d6-cbba-864f-57bd-93e7297532e2@intel.com>
Date:   Tue, 15 Dec 2020 09:43:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <a10c6b11-9e70-23ac-cdb2-141bb913de3d@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks Paolo and Sean! Sorry for the delay response, I'm back from 
vacation and just see Sean's comment, and I see Paolo has made changes, 
thanks a bunch!

On 12/12/2020 7:42 AM, Paolo Bonzini wrote:
> On 08/12/20 04:34, Kyung Min Park wrote:
>> Introduce AVX512_FP16 feature and expose it to KVM CPUID for processors
>> that support it. KVM reports this information and guests can make use
>> of it.
>>
>> Detailed information on the instruction and CPUID feature flag can be 
>> found
>> in the latest "extensions" manual [1].
>>
>> Reference:
>> [1]. 
>> https://software.intel.com/content/www/us/en/develop/download/intel-architecture-instruction-set-extensions-programming-reference.html
>>
>> Cathy Zhang (1):
>>    x86: Expose AVX512_FP16 for supported CPUID
>>
>> Kyung Min Park (1):
>>    Enumerate AVX512 FP16 CPUID feature flag
>>
>>   arch/x86/include/asm/cpufeatures.h | 1 +
>>   arch/x86/kernel/cpu/cpuid-deps.c   | 1 +
>>   arch/x86/kvm/cpuid.c               | 2 +-
>>   3 files changed, 3 insertions(+), 1 deletion(-)
>>
>
> Queued, with adjusted commit message according to Sean's review.
>
> Paolo
>
