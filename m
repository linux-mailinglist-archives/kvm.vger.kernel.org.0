Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7CC38C061
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 09:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235360AbhEUHI7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 03:08:59 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:47104 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235293AbhEUHIv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 03:08:51 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1ljzEh-00057P-AU; Fri, 21 May 2021 09:06:19 +0200
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
References: <cover.1621191549.git.maciej.szmigiero@oracle.com>
 <20035aa6e276615b026ea00ee3ec711a3159a70a.1621191552.git.maciej.szmigiero@oracle.com>
 <YKWa3nsKPgoM5yIJ@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH v3 6/8] KVM: Keep memslots in tree-based structures
 instead of array-based ones
Message-ID: <42818370-a746-1a2d-3e5e-2b29962323c9@maciej.szmigiero.name>
Date:   Fri, 21 May 2021 09:06:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YKWa3nsKPgoM5yIJ@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20.05.2021 01:10, Sean Christopherson wrote:
> On Sun, May 16, 2021, Maciej S. Szmigiero wrote:
>> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> ...
> 
>>   arch/arm64/kvm/mmu.c                |   8 +-
>>   arch/powerpc/kvm/book3s_64_mmu_hv.c |   4 +-
>>   arch/powerpc/kvm/book3s_hv.c        |   3 +-
>>   arch/powerpc/kvm/book3s_hv_nested.c |   4 +-
>>   arch/powerpc/kvm/book3s_hv_uvmem.c  |  14 +-
>>   arch/s390/kvm/kvm-s390.c            |  27 +-
>>   arch/s390/kvm/kvm-s390.h            |   7 +-
>>   arch/x86/kvm/mmu/mmu.c              |   4 +-
>>   include/linux/kvm_host.h            | 100 ++---
>>   virt/kvm/kvm_main.c                 | 580 ++++++++++++++--------------
>>   10 files changed, 379 insertions(+), 372 deletions(-)
> 
> I got through the easy ones, I'll circle back to this one a different day when
> my brain is fresh :-)
> 

Sure, thanks for doing the review.

Maciej
