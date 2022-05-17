Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 644B952AD6A
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 23:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343695AbiEQVSN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 17:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231875AbiEQVSJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 17:18:09 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62FA153730;
        Tue, 17 May 2022 14:18:07 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nr4Zj-0003Xu-Tz; Tue, 17 May 2022 23:17:51 +0200
Message-ID: <b7195bf8-566c-8b6f-2f94-5ff9b89b83a7@maciej.szmigiero.name>
Date:   Tue, 17 May 2022 23:17:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
References: <cover.1651440202.git.maciej.szmigiero@oracle.com>
 <952cdf59-6abd-f67f-46c6-67d394b98380@maciej.szmigiero.name>
 <4a7ff020-fe50-be46-0077-3ff3168a303b@redhat.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH v3 00/12] KVM: SVM: Fix soft int/ex re-injection
In-Reply-To: <4a7ff020-fe50-be46-0077-3ff3168a303b@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17.05.2022 18:46, Paolo Bonzini wrote:
> On 5/17/22 14:28, Maciej S. Szmigiero wrote:
>> On 2.05.2022 00:07, Maciej S. Szmigiero wrote:
>>> This series is an updated version of Sean's SVM soft interrupt/exception
>>> re-injection fixes patch set, which in turn extended and generalized my
>>> nSVM L1 -> L2 event injection fixes series.
>>
>> @Paolo:
>> Can't see this series in kvm/queue, do you plan to merge it for 5.19?
> 
> Yes, FWIW my list right now is (from most likely to less likely but still doable):
> 
> * deadlock (5.18)
> 
> * PMU filter patches from alewis (5.18?)
> 
> * architectural LBR
> 
> * Like's perf HW_EVENT series
> 
> * cache refresh
> 
> * this one
> 
> * nested dirty-log selftest
> 
> * x2AVIC
> 
> * dirty quota
> 
> * CMCI
> 
> * pfn functions
> 
> * Vitaly's Hyper-V TLB
> 

Ugh, that's a long TODO list...

Thanks for the update - waiting patiently then.

Thanks,
Maciej
