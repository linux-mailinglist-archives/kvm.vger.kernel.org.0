Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29BF14651FA
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 16:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351125AbhLAPt1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 10:49:27 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:46354 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351093AbhLAPtM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 10:49:12 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1msRnQ-0008GM-47; Wed, 01 Dec 2021 16:45:24 +0100
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
 <74663af27fd6e25b7846da343f7013b1e9885a4b.1638304316.git.maciej.szmigiero@oracle.com>
 <YabcNaCb88s/CTop@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH v6 18/29] KVM: x86: Use nr_memslot_pages to avoid
 traversing the memslots array
Message-ID: <54e434b1-2bbd-d6ad-7b35-5b9b9aeea2f3@maciej.szmigiero.name>
Date:   Wed, 1 Dec 2021 16:45:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YabcNaCb88s/CTop@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01.12.2021 03:21, Sean Christopherson wrote:
> On Tue, Nov 30, 2021, Maciej S. Szmigiero wrote:
>> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
>>
>> There is no point in recalculating from scratch the total number of pages
>> in all memslots each time a memslot is created or deleted.  Use KVM's
>> cached nr_memslot_pages to compute the default max number of MMU pages.
>>
>> Note that even with nr_memslot_pages capped at ULONG_MAX we can't safely
>> multiply it by KVM_PERMILLE_MMU_PAGES (20) since this operation can
>> possibly overflow an unsigned long variable.
>>
>> Write this "* 20 / 1000" operation as "/ 50" instead to avoid such
>> overflow.
>>
>> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>> [sean: use common KVM field and rework changelog accordingly]
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> My SoB can definitely be dropped for this one, just consider it review feedback
> that happened to have an SoB attached.
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> 

...and on this one, too.

Thanks,
Maciej
