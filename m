Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94A284352CC
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 20:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbhJTSmp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 14:42:45 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:40774 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231377AbhJTSmi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 14:42:38 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1mdGVY-0002dY-BB; Wed, 20 Oct 2021 20:40:12 +0200
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1632171478.git.maciej.szmigiero@oracle.com>
 <YW9Bq1FzlZHCzIS2@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH v5 00/13] KVM: Scalable memslots implementation
Message-ID: <23a68186-8154-0e9e-b27a-5df5ab1c6546@maciej.szmigiero.name>
Date:   Wed, 20 Oct 2021 20:40:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YW9Bq1FzlZHCzIS2@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20.10.2021 00:07, Sean Christopherson wrote:
> On Mon, Sep 20, 2021, Maciej S. Szmigiero wrote:
> 
> For future revisions, feel free to omit the lengthy intro and just provide links
> to previous versions.

Will do.

>> On x86-64 the code was well tested, passed KVM unit tests and KVM
>> selftests with KASAN on.
>> And, of course, booted various guests successfully (including nested
>> ones with TDP MMU enabled).
>> On other KVM platforms the code was compile-tested only.
>>
>> Changes since v1:
> 
> ...
> 
>> Changes since v2:
> 
> ...
> 
>> Changes since v3:
> 
> ...
> 
>> Changes since v4:
>> * Rebase onto v5.15-rc2 (torvalds/master),
>>
>> * Fix 64-bit division of n_memslots_pages for 32-bit KVM,
>>
>> * Collect Claudio's Reviewed-by tags for some of the patches.
> 
> Heh, this threw me for a loop.  The standard pattern is to start with the most
> recent version and work backwards, that way reviewers can quickly see the delta
> for _this_ version.  I.e.
> 
>   Changes since v4:
>   ...
> 
>   Changes since v3:
>   ...
> 

I have always used the chronological order but your argument about
reviewers being able to quickly see the delta makes sense - will switch
to having the latest changes on the top in the next version.

By the way, looking at the current https://lore.kernel.org/lkml/ at the
time I am writing this, while most of v3+ submissions are indeed
using the "latest on the top" order, some aren't:
https://lore.kernel.org/lkml/20210813145302.3933-1-kevin3.tang@gmail.com/T/
https://lore.kernel.org/lkml/20211015024658.1353987-1-xianting.tian@linux.alibaba.com/T/
https://lore.kernel.org/lkml/YW%2Fq70dLyF+YudyF@T590/T/ (this one uses a
hybrid approach - current version changes on the top, remaining changeset
in chronological order).

Thanks,
Maciej
