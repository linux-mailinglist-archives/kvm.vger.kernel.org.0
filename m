Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D1F45EEFE
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 14:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241366AbhKZNXr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 08:23:47 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:56456 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343881AbhKZNVr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Nov 2021 08:21:47 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1mqb7U-0008Ud-Qd; Fri, 26 Nov 2021 14:18:28 +0100
Subject: Re: [PATCH 0/3] KVM: Scalable memslots implementation additional
 patches
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Igor Mammedov <imammedo@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1637884349.git.maciej.szmigiero@oracle.com>
 <743fffd6-e0fb-6531-bfa6-c30103357ce2@redhat.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Message-ID: <4062e0ca-88cf-3521-3cf1-b420fc6ca2f6@maciej.szmigiero.name>
Date:   Fri, 26 Nov 2021 14:18:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <743fffd6-e0fb-6531-bfa6-c30103357ce2@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26.11.2021 11:35, Paolo Bonzini wrote:
> On 11/26/21 01:31, Maciej S. Szmigiero wrote:
>> From: "Maciej S. Szmigiero"<maciej.szmigiero@oracle.com>
>>
>> While the last "5.5" version of KVM scalable memslots implementation was
>> merged to kvm/queue some changes from its review round are still pending.
> 
> You can go ahead and post v6, I'll replace.

Which tree should I target then?
kvm/queue already has these commits so git refuses to rebase on top of it.

By the way, v6 will have more changes than this series since there will be
patches for intermediate forms of code, too.

> However, note that I would prefer the current form instead of patch 2's atomic_long_cmpxchg.

Understood.

> Paolo

Thanks,
Maciej
