Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B03CA37F768
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 14:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbhEMMHb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 May 2021 08:07:31 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:60594 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233663AbhEMMHF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 May 2021 08:07:05 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1lhA62-0000lu-Gt; Thu, 13 May 2021 14:05:42 +0200
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
References: <cover.1618322001.git.maciej.szmigiero@oracle.com>
 <YJxrsI89kdiM5Dk2@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH v2 0/8] KVM: Scalable memslots implementation
Message-ID: <9fe46899-2162-e9e2-d15c-86db38ac820f@maciej.szmigiero.name>
Date:   Thu, 13 May 2021 14:05:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YJxrsI89kdiM5Dk2@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13.05.2021 01:58, Sean Christopherson wrote:
> On Tue, Apr 13, 2021, Maciej S. Szmigiero wrote:
>> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> Grr, this entire series got autobinned into my spam folder, which I obviously
> don't check very often.  I won't be able to take a look until next week at the
> earliest, any chance you'd want to rebase to the latest kvm/queue and spin v3?
> The rebase will probably be a bit painful, but on the plus side the majority of
> the arch specific changes will disappear now that walking the memslots for the
> MMU notifiers is done in common code.

A respin (and a re-test) of this series is needed anyway since these
patches have conflicts with the now-merged MMU notifiers rewrite (that you
mention above).

Will try to post it by the next week.

Thanks,
Maciej
