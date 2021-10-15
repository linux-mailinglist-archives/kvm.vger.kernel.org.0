Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF5D842E65B
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 04:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234872AbhJOCIQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 22:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234867AbhJOCIP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 22:08:15 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F05C061570;
        Thu, 14 Oct 2021 19:06:09 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id n11so5437840plf.4;
        Thu, 14 Oct 2021 19:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:references:from:organization:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DQqSPjrKwdbRev245xbK+egMBqTVOHtR7p4QVsFq+Oo=;
        b=Es0zndR+K0ck5zcLcQ31wnjrDMBUTmUGkgTJwriyrLdW2/KhowUJzurdMacY7GFAe7
         CUlfkZSMPnM3GFOFM3T/lGO8n/PRRA2lqLP+lLgt4VGVXqXeY7iDZe6CGN3i9gF7D5GF
         YASbtP3K1H/pwGn8nKOI3u2a9a4mouL633Joqi9zXsjR+Hez0tZYlvYCxGsW/Q8geTcQ
         CIEuPc66WC/sE3jZPXZbjFXhMQUOrfkDBWYqnc9D5eSplv2txB6zycs9ilC1HCxM/iIv
         CAV1LSdLqwCxtJpIDUpeqkteAEj46mmU0nJW5aZc32iTlh9pASomEkX+FQrIL25ZHWZO
         BSDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:organization:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=DQqSPjrKwdbRev245xbK+egMBqTVOHtR7p4QVsFq+Oo=;
        b=FAwbyDefC4ec/m5j50OHfvOO6GOJnyYrSKgYQk+8yh4MELJlvE+oE/0/k4HtYIAhE0
         DGdexc0UKPyXoyNJSAVWTrZ7nt19vVre+9KxIcpqEOf0ovaIhWiNht9sRVoK16cOxHIw
         2qmDNHPVHB3RGREyAcfzHzW0XyZWokQ2vz6mDI+KZDqn/OuXzrrf2S16G7Otn8s05mhB
         R0Y0/E7L6HqUAp8/AaXfkAZJyvXl31Lrk2Q8ls6GiAaSOsam4ASPhXr5n2djtCc7lagO
         1rdeG/zNKqo97vofq38D+Gc3070hbomwccY1I2oH33SQlhvW5YOA4kno8WbkCI2detGQ
         uVhA==
X-Gm-Message-State: AOAM531xsCeV5OFBbViEPLKqURLpEsZ0K0rAYgDM0PJ8PsH+/Fq0qgvA
        NFw4uVqOKxVjiWxaPtjhxYymLMEXvIZxyjy9
X-Google-Smtp-Source: ABdhPJwMRZ1qM7bPfc0qYRz5GNcfo36bvrFmsOWET9m6FAAtIgtQoTWe5X38NY6+1Jwxr6wVviTZBg==
X-Received: by 2002:a17:90a:47:: with SMTP id 7mr10312813pjb.46.1634263568730;
        Thu, 14 Oct 2021 19:06:08 -0700 (PDT)
Received: from Likes-MacBook-Pro.local ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id q12sm3638052pgv.26.2021.10.14.19.06.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 19:06:08 -0700 (PDT)
To:     Yang Weijiang <weijiang.yang@intel.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, vkuznets@redhat.com,
        wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1629791777-16430-1-git-send-email-weijiang.yang@intel.com>
 <1629791777-16430-16-git-send-email-weijiang.yang@intel.com>
 <YWjE0iQ6fDdJpDfT@google.com> <20211015012821.GA29942@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [PATCH v8 15/15] KVM: x86/cpuid: Advise Arch LBR feature in CPUID
Message-ID: <dfe0dee9-905a-9296-4a5b-e88eb9e942a1@gmail.com>
Date:   Fri, 15 Oct 2021 10:05:58 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211015012821.GA29942@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/10/2021 9:28 am, Yang Weijiang wrote:
> On Fri, Oct 15, 2021 at 12:01:22AM +0000, Sean Christopherson wrote:
>> s/Advise/Advertise
>>
>> On Tue, Aug 24, 2021, Yang Weijiang wrote:
>>> Add Arch LBR feature bit in CPU cap-mask to expose the feature.
>>> Only max LBR depth is supported for guest, and it's consistent
>>> with host Arch LBR settings.
>>>
>>> Co-developed-by: Like Xu <like.xu@linux.intel.com>
>>> Signed-off-by: Like Xu <like.xu@linux.intel.com>
>>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>>> ---
>>>   arch/x86/kvm/cpuid.c | 33 ++++++++++++++++++++++++++++++++-
>>>   1 file changed, 32 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>>> index 03025eea1524..d98ebefd5d72 100644
>>> --- a/arch/x86/kvm/cpuid.c
>>> +++ b/arch/x86/kvm/cpuid.c
>>> @@ -88,6 +88,16 @@ static int kvm_check_cpuid(struct kvm_cpuid_entry2 *entries, int nent)
>>>   		if (vaddr_bits != 48 && vaddr_bits != 57 && vaddr_bits != 0)
>>>   			return -EINVAL;
>>>   	}
>>> +	best = cpuid_entry2_find(entries, nent, 0x1c, 0);
>>> +	if (best) {
>>> +		unsigned int eax, ebx, ecx, edx;
>>> +
>>> +		/* Reject user-space CPUID if depth is different from host's.*/
>>
>> Why disallow this?  I don't see why it would be illegal for userspace to specify
>> fewer LBRs, 

The emulation of guest LBR *depends* on the host LBR driver to save/restore LBRs 
entries
(which are pass-through to the guest and store the guest branch instructions 
rips actually).

Currently, the host side does not support the use of different lbr depths on the 
same host
to customize this part of the overhead. The host perf LBR driver assumes that 
the lbr depths
of different tasks on different cpu's are the same and are the maximum value.

The KVM LBR implementation may not break it until additional support is applied 
on the host side.

We'd better not let the guest down if the user space specifies fewer or more LBRs,
and explicitly rejecting it in the CPUID settings is an option, or just let the 
error happen.

and KVM should darn well verify that any MSRs it's exposing to the
>> guest actually exist.
> Hi, Sean,
> Thanks for the comments!
> The treatment for LBR depth is a bit special, only the host value can be
> supported now, i.e., 32. If userspace set the value other that 32, would like
> to notify it as early as possible.
> Do you want to remove the check here and correct the invalid setting silently when
> guest is querying CPUID?
> 
>>
>>> +		cpuid_count(0x1c, 0, &eax, &ebx, &ecx, &edx);
>>> +
>>> +		if ((best->eax & 0xff) != BIT(fls(eax & 0xff) - 1))
>>> +			return -EINVAL;
>>> +	}
>>>   
>>>   	return 0;
>>>   }
