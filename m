Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 724A352A182
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 14:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346007AbiEQM2g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 08:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345484AbiEQM23 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 08:28:29 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D684991A;
        Tue, 17 May 2022 05:28:26 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nqwJB-0002Nq-JJ; Tue, 17 May 2022 14:28:13 +0200
Message-ID: <952cdf59-6abd-f67f-46c6-67d394b98380@maciej.szmigiero.name>
Date:   Tue, 17 May 2022 14:28:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v3 00/12] KVM: SVM: Fix soft int/ex re-injection
Content-Language: en-US
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
References: <cover.1651440202.git.maciej.szmigiero@oracle.com>
In-Reply-To: <cover.1651440202.git.maciej.szmigiero@oracle.com>
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

On 2.05.2022 00:07, Maciej S. Szmigiero wrote:
> This series is an updated version of Sean's SVM soft interrupt/exception
> re-injection fixes patch set, which in turn extended and generalized my
> nSVM L1 -> L2 event injection fixes series.

@Paolo:
Can't see this series in kvm/queue, do you plan to merge it for 5.19?

Thanks,
Maciej
