Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0ADB2A3C04
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 06:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgKCFg1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 00:36:27 -0500
Received: from mga02.intel.com ([134.134.136.20]:50015 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725980AbgKCFg1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Nov 2020 00:36:27 -0500
IronPort-SDR: MYp7U9pZXSVy6xlP0yKBXYMKQ1RkknhfFm6lrrxcIY9NsQJt8zlJrvAxlQ5mDCGZX0kqH9NnKA
 MVK7wHHnsILw==
X-IronPort-AV: E=McAfee;i="6000,8403,9793"; a="155989880"
X-IronPort-AV: E=Sophos;i="5.77,447,1596524400"; 
   d="scan'208";a="155989880"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 21:36:25 -0800
IronPort-SDR: X6u1oR2wAu1++657bT/db7CSkzbjkXMGxusSlH9mmpyr4mSLmulnYxsuDL8ICqK3rqNQH0YTEh
 VbI8/qCm3fWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,447,1596524400"; 
   d="scan'208";a="353085351"
Received: from unknown (HELO [0.0.0.0]) ([10.109.19.69])
  by fmsmga004.fm.intel.com with ESMTP; 02 Nov 2020 21:36:22 -0800
Subject: Re: [PATCH] KVM: VMX: Enable Notify VM exit
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>
References: <20201102061445.191638-1-tao3.xu@intel.com>
 <20201102173236.GD21563@linux.intel.com>
From:   Tao Xu <tao3.xu@intel.com>
Message-ID: <31218420-f20c-aa7f-089d-54e9fecf35aa@intel.com>
Date:   Tue, 3 Nov 2020 13:36:22 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201102173236.GD21563@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 11/3/20 1:32 AM, Sean Christopherson wrote:
> On Mon, Nov 02, 2020 at 02:14:45PM +0800, Tao Xu wrote:
>> There are some cases that malicious virtual machines can cause CPU stuck
>> (event windows don't open up), e.g., infinite loop in microcode when
>> nested #AC (CVE-2015-5307). No event window obviously means no events,
>> e.g. NMIs, SMIs, and IRQs will all be blocked, may cause the related
>> hardware CPU can't be used by host or other VM.
>>
>> To resolve those cases, it can enable a notify VM exit if no
>> event window occur in VMX non-root mode for a specified amount of
>> time (notify window).
>>
>> Expose a module param for setting notify window, default setting it to
>> the time as 1/10 of periodic tick, and user can set it to 0 to disable
>> this feature.
>>
>> TODO:
>> 1. The appropriate value of notify window.
>> 2. Another patch to disable interception of #DB and #AC when notify
>> VM-Exiting is enabled.
>>
>> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> Signed-off-by: Tao Xu <tao3.xu@intel.com>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> 
> Incorrect ordering, since you're sending the patch, you "handled" it last,
> therefore your SOB should come last, i.e.:
> 
>    Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
>    Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>    Signed-off-by: Tao Xu <tao3.xu@intel.com>
> 
OK, I will correct this.
