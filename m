Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D900C4651FD
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 16:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351145AbhLAPth (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 10:49:37 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:46364 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236266AbhLAPtQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 10:49:16 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1msRnb-0008Gg-11; Wed, 01 Dec 2021 16:45:35 +0100
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
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
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1638304315.git.maciej.szmigiero@oracle.com>
 <a6b62e0bdba2a82bbc31dcad3c8525ccc5ff0bff.1638304316.git.maciej.szmigiero@oracle.com>
 <Yabj3Qr8e85qhSg3@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH v6 21/29] KVM: Resolve memslot ID via a hash table instead
 of via a static array
Message-ID: <c1dca71f-99d7-93b2-b4fe-d02526fefc81@maciej.szmigiero.name>
Date:   Wed, 1 Dec 2021 16:45:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <Yabj3Qr8e85qhSg3@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01.12.2021 03:54, Sean Christopherson wrote:
> On Tue, Nov 30, 2021, Maciej S. Szmigiero wrote:
>> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
>>
>> Memslot ID to the corresponding memslot mappings are currently kept as
>> indices in static id_to_index array.
>> The size of this array depends on the maximum allowed memslot count
>> (regardless of the number of memslots actually in use).
>>
>> This has become especially problematic recently, when memslot count cap was
>> removed, so the maximum count is now full 32k memslots - the maximum
>> allowed by the current KVM API.
>>
>> Keeping these IDs in a hash table (instead of an array) avoids this
>> problem.
>>
>> Resolving a memslot ID to the actual memslot (instead of its index) will
>> also enable transitioning away from an array-based implementation of the
>> whole memslots structure in a later commit.
>>
>> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>> Co-developed-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> Nit, your SoB should come last since you were the last person to handle the patch.
> 

Thought that my SoB should come first as coming from the author of this
patch.

Documentation/process/submitting-patches.rst says that:
> Any further SoBs (Signed-off-by:'s) following the author's SoB are from
> people handling and transporting the patch, but were not involved in its
> development. SoB chains should reflect the **real** route a patch took
> as it was propagated to the maintainers and ultimately to Linus, with
> the first SoB entry signalling primary authorship of a single author.

So "further SoBs follow[] the author's SoB" and "the first SoB entry
signal[s] primary authorship".
But at the same time "SoB chains should reflect the **real** route a
patch took" - these rules contradict each other in our case.

Thanks,
Maciej
