Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3112C352798
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 10:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234161AbhDBIxz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 04:53:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:25624 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229599AbhDBIxz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Apr 2021 04:53:55 -0400
IronPort-SDR: jXuPEzP7zfuYveaBQpbs3Ao1UGt5ojiZdJKr1Dg/hpCQQ5LiB3J7xLUU3YJBsvyyK+nHuwTqFa
 3nFM413yNEXg==
X-IronPort-AV: E=McAfee;i="6000,8403,9941"; a="212700297"
X-IronPort-AV: E=Sophos;i="5.81,299,1610438400"; 
   d="scan'208";a="212700297"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2021 01:53:54 -0700
IronPort-SDR: I2hhndY8aDp862URqE4nqmbdWusRQrd5TJ/1EyBo9aXLWAXK/91XfFNcLUK9pD8+3heZuTBliB
 7GdIwv8hAfCQ==
X-IronPort-AV: E=Sophos;i="5.81,299,1610438400"; 
   d="scan'208";a="419579090"
Received: from unknown (HELO [10.239.13.106]) ([10.239.13.106])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2021 01:53:50 -0700
Subject: Re: [PATCH v2 1/3] KVM: X86: Rename DR6_INIT to DR6_ACTIVE_LOW
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210202090433.13441-1-chenyi.qiang@intel.com>
 <20210202090433.13441-2-chenyi.qiang@intel.com>
 <3db069ba-b4e0-1288-ec79-66ac44938682@redhat.com>
 <6678520f-e69e-6116-88c9-e9d6cd450934@intel.com>
 <ea9eaa84-999b-82cb-ef40-66fde361704d@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <dc22f0a2-97c5-d54d-a521-c02f802c2229@intel.com>
Date:   Fri, 2 Apr 2021 16:53:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <ea9eaa84-999b-82cb-ef40-66fde361704d@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/3/2021 12:05 AM, Paolo Bonzini wrote:
> On 02/02/21 16:02, Xiaoyao Li wrote:
>> On 2/2/2021 10:49 PM, Paolo Bonzini wrote:
>>> On 02/02/21 10:04, Chenyi Qiang wrote:
>>>>
>>>>  #define DR6_FIXED_1    0xfffe0ff0
>>>> -#define DR6_INIT    0xffff0ff0
>>>> +/*
>>>> + * DR6_ACTIVE_LOW is actual the result of DR6_FIXED_1 | 
>>>> ACTIVE_LOW_BITS.
>>>> + * We can regard all the current FIXED_1 bits as active_low bits even
>>>> + * though in no case they will be turned into 0. But if they are 
>>>> defined
>>>> + * in the future, it will require no code change.
>>>> + * At the same time, it can be served as the init/reset value for DR6.
>>>> + */
>>>> +#define DR6_ACTIVE_LOW    0xffff0ff0
>>>>  #define DR6_VOLATILE    0x0001e00f
>>>>
>>>
>>> Committed with some changes in the wording of the comment.
>>>
>>> Also, DR6_FIXED_1 is (DR6_ACTIVE_LOW & ~DR6_VOLATILE).
>>
>> Maybe we can add BUILD_BUG_ON() to make sure the correctness?
> 
> We can even
> 
> #define DR_FIXED_1  (DR6_ACTIVE_LOW & ~DR6_VOLATILE)
> 
> directly.  I have pushed this patch to kvm/queue, but the other two will 
> have to wait for Fenghua's bare metal support.
> 

Hi Paolo,

Fenghua's bare metal support is in tip tree now.
https://lore.kernel.org/lkml/20210322135325.682257-1-fenghua.yu@intel.com/

Will the rest KVM patches get into 5.13 together?



