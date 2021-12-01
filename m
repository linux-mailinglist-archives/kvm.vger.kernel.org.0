Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8065A4651F7
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 16:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351111AbhLAPtP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 10:49:15 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:46336 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348015AbhLAPtC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 10:49:02 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1msRnE-0008GC-VT; Wed, 01 Dec 2021 16:45:12 +0100
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
 <a47c93c2fe40e7ed27eb0ff6ac2b173254058b6c.1638304315.git.maciej.szmigiero@oracle.com>
 <YabK7IOM74ag2CcS@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH v6 03/29] KVM: Resync only arch fields when
 slots_arch_lock gets reacquired
Message-ID: <2154a0ce-7ec7-d9e6-d0e1-5806fba9123a@maciej.szmigiero.name>
Date:   Wed, 1 Dec 2021 16:45:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YabK7IOM74ag2CcS@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01.12.2021 02:07, Sean Christopherson wrote:
> On Tue, Nov 30, 2021, Maciej S. Szmigiero wrote:
>> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
>>
>> There is no need to copy the whole memslot data after releasing
>> slots_arch_lock for a moment to install temporary memslots copy in
>> kvm_set_memslot() since this lock only protects the arch field of each
>> memslot.
>>
>> Just resync this particular field after reacquiring slots_arch_lock.
>>
>> Note, this also eliminates the need to manually clear the INVALID flag
>> when restoring memslots; the "setting" of the INVALID flag was an
>> unwanted side effect of copying the entire memslots.
>>
>> Since kvm_copy_memslots() has just one caller remaining now
>> open-code it instead.
>>
>> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>> [sean: tweak shortlog, note INVALID flag in changelog, revert comment]
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> Heh, I think you can drop my SoB?  This is new territory for me, I don't know the
> rules for this particular situation.
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> 

Will replace your SoB with your R-b on this patch then.

Thanks,
Maciej
