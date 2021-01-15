Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598682F749B
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 09:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730201AbhAOIv6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 03:51:58 -0500
Received: from mga05.intel.com ([192.55.52.43]:25574 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726817AbhAOIv4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 03:51:56 -0500
IronPort-SDR: c8+qbs1J7C5cUU6b+f2lmzXQl9ZIrYV8yIb6Ha+92DE6lxuvt45SP/MWG3i2wSiYKh5pOjPv07
 QnYJcYodB2LQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9864"; a="263313699"
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="263313699"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 00:51:13 -0800
IronPort-SDR: 2DWi2BuGZEuH8CvySrdMz0szSkdssIE/dCzkPYdMnYOeTdh2TLG3jRQ/JqTQrNBuGYwxPcJG7o
 bDFMkQxWbh0g==
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="382591418"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 00:51:03 -0800
Subject: Re: [RESEND v13 00/10] KVM: x86/pmu: Guest Last Branch Recording
 Enabling
To:     Alex Shi <alex.shi@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, ak@linux.intel.com,
        wei.w.wang@intel.com, kan.liang@intel.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Like Xu <like.xu@linux.intel.com>
References: <20210108013704.134985-1-like.xu@linux.intel.com>
 <3deac361-05fa-60a5-0d88-4f6b968f10bf@linux.alibaba.com>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <307385ae-cd3e-8d06-ffa9-dcd297ec9a8a@intel.com>
Date:   Fri, 15 Jan 2021 16:51:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <3deac361-05fa-60a5-0d88-4f6b968f10bf@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

Thank you for trying this guest feature on multiple Intel platforms!
If you have more specific comments or any concerns, just let me know.

---
thx, likexu

On 2021/1/15 16:19, Alex Shi wrote:
>
> 在 2021/1/8 上午9:36, Like Xu 写道:
>> Because saving/restoring tens of LBR MSRs (e.g. 32 LBR stack entries) in
>> VMX transition brings too excessive overhead to frequent vmx transition
>> itself, the guest LBR event would help save/restore the LBR stack msrs
>> during the context switching with the help of native LBR event callstack
>> mechanism, including LBR_SELECT msr.
>>
> Sounds the feature is much helpful for VMM guest performance tunning.
> Good job!
>
> Thanks
> Alex

