Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE062191E1D
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 01:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbgCYAb3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 20:31:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:50410 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727099AbgCYAb3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 20:31:29 -0400
IronPort-SDR: cJLDkC3wCpyVIDqxd/RlQc1sxSrdn77yTQ0+nsEmn/cpy7pRLStIGZj/0247dIXo0kDdCiZ6Tq
 FhDhlGj7vm5A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2020 17:31:28 -0700
IronPort-SDR: IjDW8Fh1RUSOFjUVHr7o4ibU5xKTGeVUQee9K8tvntMfUqnWaInjyv5w2zhX6vi475LzLbiXuF
 rufpamoCH23A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,302,1580803200"; 
   d="scan'208";a="446451454"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.170.28]) ([10.249.170.28])
  by fmsmga005.fm.intel.com with ESMTP; 24 Mar 2020 17:31:25 -0700
Subject: Re: [PATCH v6 4/8] kvm: x86: Emulate split-lock access as a write in
 emulator
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>
References: <20200324151859.31068-1-xiaoyao.li@intel.com>
 <20200324151859.31068-5-xiaoyao.li@intel.com>
 <87lfnpz4k2.fsf@nanos.tec.linutronix.de>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <afd05186-dd2d-5610-d03e-98f4ed93d15f@intel.com>
Date:   Wed, 25 Mar 2020 08:31:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <87lfnpz4k2.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/25/2020 8:00 AM, Thomas Gleixner wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>   
>> +bool split_lock_detect_on(void)
>> +{
>> +	return sld_state != sld_off;
>> +}
>> +EXPORT_SYMBOL_GPL(split_lock_detect_on);
> 
> 1) You export this function here
> 
> 2) You change that in one of the next patches to something else
> 
> 3) According to patch 1/8 X86_FEATURE_SPLIT_LOCK_DETECT is not set when
>     sld_state == sld_off. FYI, I did that on purpose.
> 
> AFAICT #1 and #2 are just historical leftovers of your previous patch
> series and the extra step was just adding more changed lines per patch
> for no value.
> 
> #3 changed the detection mechanism and at the same time the semantics of
> the feature flag.
> 
> So what's the point of this exercise?

Right. In this series, setting X86_FEATURE_SPLIT_LOCK_DETECT flag means 
SLD is turned on. Need to remove split_lock_detect_on(). Thanks for 
pointing out this.

> Thanks,
> 
>          tglx
> 

