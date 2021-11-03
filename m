Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF884444BA
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 16:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbhKCPlC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 11:41:02 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:59576 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229587AbhKCPlB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 11:41:01 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1miIL9-0007Pv-Uy; Wed, 03 Nov 2021 16:38:15 +0100
Subject: Re: [PATCH v5 01/13] KVM: x86: Cache total page count to avoid
 traversing the memslot array
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
 <d07f07cdd545ab1a495a9a0da06e43ad97c069a2.1632171479.git.maciej.szmigiero@oracle.com>
 <YW9Fi128rYxiF1v3@google.com>
 <e618edce-b310-6d9a-3860-d7f4d8c0d98f@maciej.szmigiero.name>
 <YXBnn6ZaXbaqKvOo@google.com> <YYBqMipZT9qcwDMt@google.com>
 <8017cf9d-2b03-0c27-b78a-41b3d03c308b@maciej.szmigiero.name>
 <YYKhFhoSa/8SHxJB@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Message-ID: <27ba659b-137e-863f-7892-b8968fd14e59@maciej.szmigiero.name>
Date:   Wed, 3 Nov 2021 16:38:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YYKhFhoSa/8SHxJB@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03.11.2021 15:47, Sean Christopherson wrote:
> On Wed, Nov 03, 2021, Maciej S. Szmigiero wrote:
>> Capping total n_memslots_pages makes sense to me to avoid the (existing)
>> nr_mmu_pages wraparound issue, will update the next patchset version
>> accordingly.
> 
> No need to do it yourself.  I have a reworked version of the series with a bunch
> of cleanups before and after the meat of your series, as well non-functional changes
> (hopefully) to the "Resolve memslot ID via a hash table" and "Keep memslots in
> tree-based structures" to avoid all the swap() behavior and to provide better
> continuity between the aforementioned patches.  Unless something goes sideways in
> the last few touchups, I'll get it posted today.
> 

Thanks.
