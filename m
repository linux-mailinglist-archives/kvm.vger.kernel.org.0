Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB35450EC61
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 01:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236680AbiDYXDw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 19:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236170AbiDYXDv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 19:03:51 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F193DDFA;
        Mon, 25 Apr 2022 16:00:44 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nj7h8-0002Ck-4y; Tue, 26 Apr 2022 01:00:38 +0200
Message-ID: <5f6fd312-afba-8d9f-bfca-3a64c99d99c9@maciej.szmigiero.name>
Date:   Tue, 26 Apr 2022 01:00:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20220423021411.784383-1-seanjc@google.com>
 <20220423021411.784383-11-seanjc@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH v2 10/11] KVM: selftests: nSVM: Add
 svm_nested_soft_inject_test
In-Reply-To: <20220423021411.784383-11-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23.04.2022 04:14, Sean Christopherson wrote:
> From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> 
> Add a KVM self-test that checks whether a nSVM L1 is able to successfully
> inject a software interrupt and a soft exception into its L2 guest.
> 
> In practice, this tests both the next_rip field consistency and
> L1-injected event with intervening L0 VMEXIT during its delivery:
> the first nested VMRUN (that's also trying to inject a software interrupt)
> will immediately trigger a L0 NPF.
> This L0 NPF will have zero in its CPU-returned next_rip field, which if
> incorrectly reused by KVM will trigger a #PF when trying to return to
> such address 0 from the interrupt handler.
> 
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> [sean: check exact L2 RIP on first soft interrupt]
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Looks like this version doesn't integrate the changes that Maxim has suggested [1].
Will provide an updated version after I test the patch set.

Thanks,
Maciej

[1]: https://lore.kernel.org/kvm/2401bf729beab6d9348fda18f55e90ed9c1f7583.camel@redhat.com/
