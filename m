Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF7E456DB8
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 11:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234805AbhKSKpf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 05:45:35 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:33905 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229521AbhKSKpf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Nov 2021 05:45:35 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R281e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0UxHU4z0_1637318547;
Received: from 30.22.113.170(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0UxHU4z0_1637318547)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 19 Nov 2021 18:42:29 +0800
Message-ID: <95ceaa12-81a0-09bf-dde3-b89179eee4cc@linux.alibaba.com>
Date:   Fri, 19 Nov 2021 18:42:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH 15/15] KVM: X86: Always set gpte_is_8_bytes when direct
 map
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org
References: <20211118110814.2568-1-jiangshanlai@gmail.com>
 <20211118110814.2568-16-jiangshanlai@gmail.com>
 <16b701db-e277-c4ef-e198-65a2dc6e3fdf@redhat.com>
 <bcfa0e4d-f6ab-037a-9ce1-d0cd612422a5@linux.alibaba.com>
 <65e1f2ca-5d89-d67f-2e0e-542094f89f05@redhat.com>
 <1c3d50f5-8f42-f337-cecc-3115e73703e5@linux.alibaba.com>
 <82b0cbf0-0afb-29c8-ae8c-3d302f966014@redhat.com>
From:   Lai Jiangshan <laijs@linux.alibaba.com>
In-Reply-To: <82b0cbf0-0afb-29c8-ae8c-3d302f966014@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/11/19 18:34, Paolo Bonzini wrote:
> On 11/19/21 11:30, Lai Jiangshan wrote:
>>>
>>
>> Hello
>>
>> Since 13, and 14 is queued, could you also queue this one and I will
>> do the rename separately in the next patchset.  I found that the
>> intent of this patch is hidden in the lengthened squashed patch (of
>> this patch and the renaming patch).
> 
> Then you can do the renaming first?
> 

Then I would prefer to make the code match the name for the first time
when the name is introduced, which means it would be a squashed patch.

I will not fuss about it and will send the squashed patch.
