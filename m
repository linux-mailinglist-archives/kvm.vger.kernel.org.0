Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B29634E7E17
	for <lists+kvm@lfdr.de>; Sat, 26 Mar 2022 01:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbiCZAYC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 20:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbiCZAX7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 20:23:59 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D504718023D;
        Fri, 25 Mar 2022 17:22:17 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nXuBv-00025A-UB; Sat, 26 Mar 2022 01:22:03 +0100
Message-ID: <2bcaa193-5454-f0a1-8fb9-5f61c95d87f6@maciej.szmigiero.name>
Date:   Sat, 26 Mar 2022 01:21:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
References: <20220311032801.3467418-1-seanjc@google.com>
 <08548cb00c4b20426e5ee9ae2432744d6fa44fe8.camel@redhat.com>
 <YjzjIhyw6aqsSI7Q@google.com>
 <e64d9972-339c-c661-afbd-38f1f2ea476a@maciej.szmigiero.name>
 <Yj5KCqtu7KZiGtgN@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH 00/21] KVM: x86: Event/exception fixes and cleanups
In-Reply-To: <Yj5KCqtu7KZiGtgN@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26.03.2022 00:02, Sean Christopherson wrote:
> On Fri, Mar 25, 2022, Maciej S. Szmigiero wrote:
>> So, what's the plan here: is your patch set Sean considered to supersede
>> Maxim's earlier proposed changes or will you post an updated patch set
>> incorporating at least some of them?
> 
> Next step is to reach a consensus on how we want to solve the problem (or if we
> can't reach consensus, until Paolo uses his special powers).  I definitely won't
> post anything new until there's more conversation.

Ack.

>> I am asking because I have a series that touches the same general area
>> of KVM [1] and would preferably have it based on the final form of the
>> event injection code to avoid unforeseen negative interactions between
>> these changes.
> 
> I don't think you need to do anything, at a glance your changes are orthogonal
> even though they have similar themes.  Any conflicts should be minor.

All right - I will try to keep an eye on the developments related to the
event injection code just to be sure there are no obvious conflicts here.

Thanks,
Maciej
