Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B47E435350
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 20:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbhJTTBM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 15:01:12 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:41490 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230076AbhJTTBL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 15:01:11 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1mdGnX-0002lB-LZ; Wed, 20 Oct 2021 20:58:47 +0200
Subject: Re: [PATCH v5 07/13] KVM: Just resync arch fields when
 slots_arch_lock gets reacquired
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
 <311810ebd1111bed50d931d424297384171afc36.1632171479.git.maciej.szmigiero@oracle.com>
 <YW9a2s8wHXzf8Xqw@google.com>
 <b9ffb6cf-d59b-3bb5-a9b0-71e32c81135a@maciej.szmigiero.name>
 <YXBmoP4Lf2o1OiHY@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Message-ID: <7e68e883-7431-72a3-82ef-306472de5ac4@maciej.szmigiero.name>
Date:   Wed, 20 Oct 2021 20:58:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YXBmoP4Lf2o1OiHY@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20.10.2021 20:57, Sean Christopherson wrote:
> On Wed, Oct 20, 2021, Maciej S. Szmigiero wrote:
>> On 20.10.2021 01:55, Sean Christopherson wrote:
>>> On Mon, Sep 20, 2021, Maciej S. Szmigiero wrote:
>>> This should probably be a memcpy(), I don't know what all shenanigans the compiler
>>> can throw at us if it gets to copy a struct by value.
>>
>> Normally, copy-assignment of a struct is a safe operation (this is purely
>> an internal kernel struct, so there are no worries about padding leakage
>> to the userspace), but can replace this with a memcpy().
> 
> I was more worried about the compiler using SIMD instructions.  I assume the kernel
> build process has lots of guards in place to prevent such shenanigans, but on the
> other hand I _know_ mempcy() is safe :-)
> 

So we will play safe and use mempcy() then :)

Thanks,
Maciej
