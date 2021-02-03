Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC30130E3E2
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 21:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbhBCUKm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 15:10:42 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:56634 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231920AbhBCUKi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 15:10:38 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps (TLS1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.93.0.4)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1l7OTG-0005c9-S7; Wed, 03 Feb 2021 21:09:50 +0100
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <ceb96527b6f7bb662eec813f05b897a551ebd0b2.1612140117.git.maciej.szmigiero@oracle.com>
 <c3f775de-9cb5-5f30-3fbc-a5e80c1654de@redhat.com>
 <771da54d-0601-ccd2-8edf-814086739e53@maciej.szmigiero.name>
 <7b15ae06-4b56-0259-6950-6781622020ab@redhat.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Make HVA handler retpoline-friendly
Message-ID: <e6333c52-52e8-5ace-2c13-ba07e6c403dc@maciej.szmigiero.name>
Date:   Wed, 3 Feb 2021 21:09:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <7b15ae06-4b56-0259-6950-6781622020ab@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03.02.2021 15:43, Paolo Bonzini wrote:
> On 01/02/21 16:19, Maciej S. Szmigiero wrote:
>> On 01.02.2021 09:21, Paolo Bonzini wrote:
>>> On 01/02/21 09:13, Maciej S. Szmigiero wrote:
>>>>   static int kvm_handle_hva_range(struct kvm *kvm,
>>>>                   unsigned long start,
>>>>                   unsigned long end,
>>>> @@ -1495,8 +1534,9 @@ static int kvm_handle_hva_range(struct kvm *kvm,
>>>
>>>
>>>> -static int kvm_tdp_mmu_handle_hva_range(struct kvm *kvm, unsigned long start,
>>>> -        unsigned long end, unsigned long data,
>>>> -        int (*handler)(struct kvm *kvm, struct kvm_memory_slot *slot,
>>>> -                   struct kvm_mmu_page *root, gfn_t start,
>>>> -                   gfn_t end, unsigned long data))
>>>> -{
>>>
>>> Can you look into just marking these functions __always_inline?  This should help the compiler change (*handler)(...) into a regular function call.
>>
>> That looks even better - I see the compiler then turns the indirect call
>> into a direct one.
>>
>> Will change to __always_inline instead of static dispatch in the next
>> version.
>> Thanks for the pointer.
> 
> Feel free to send this separately as it's a self-contained change.

Will do!

> Thanks,
> 
> Paolo
> 

Thanks,
Maciej
