Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B45D7B1C6B
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 14:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbjI1MaD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 08:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbjI1MaB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 08:30:01 -0400
X-Greylist: delayed 1856 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 28 Sep 2023 05:29:58 PDT
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F5AF19B
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 05:29:57 -0700 (PDT)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1qlpfW-001yJQ-DM; Thu, 28 Sep 2023 13:58:58 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=XD6PCu521YcJo/ohm4TvG+cohWp0I3JbbJCeuwvMtSo=; b=SwBGKIwUqlEQsgIxsfb/lL22Ew
        96MFik7gKjeSGGYatCUL5dYXlIF/gz3IVBLacZnQY217u+h7UHLmKiwdsFz2A/+q/d39AeVK+5B15
        jAbeK0N4Wlb7oQUJLeN2MJkUYGst0M3cTePhQRCn3yp+AKTyx4PW2rg1l3VaZSNknaOsDPWqZFSvf
        6YrvZ7NgY6wws4o+den8eCk+uEZHqzipQeM1jAr22OThj/BI48I/X9669FcdQAyPVSOOoGLdDeY1Y
        e9Hqm26CZkaIqLTo4B5eqoeur1R3kRicpqRUw0zZBnupdbPV0P+XBW6BIvaphjwcRFz6hKNSx78iI
        pjahhgKQ==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1qlpfV-00014q-Tw; Thu, 28 Sep 2023 13:58:58 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1qlpfE-0007Cm-2K; Thu, 28 Sep 2023 13:58:40 +0200
Message-ID: <e2a0d2cb-bc93-4d36-bf42-6963095b207f@rbox.co>
Date:   Thu, 28 Sep 2023 13:58:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] KVM: Correct kvm_vcpu_event(s) typo in KVM API
 documentation
Content-Language: pl-PL, en-GB
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, corbet@lwn.net, kvm@vger.kernel.org
References: <20230814222358.707877-1-mhal@rbox.co>
 <20230814222358.707877-4-mhal@rbox.co>
 <13480bef-2646-4c01-ba81-3020a2ef2ce1@rbox.co> <ZRSMGdxk2X-cXr6z@google.com>
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <ZRSMGdxk2X-cXr6z@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/27/23 22:10, Sean Christopherson wrote:
> On Tue, Aug 15, 2023, Michal Luczaj wrote:
>> On 8/15/23 00:08, Michal Luczaj wrote:
>>> I understand that typo fixes are not always welcomed, but this
>>> kvm_vcpu_event(s) did actually bit me, causing minor irritation.
>>                                  ^^^
> 
> FWIW, my bar for fixing typos is if the typo causes any amount of confusion or
> wasted time.  If it causes one person pain, odds are good it'll cause others pain
> in the future.

OK, do you want me to resend just the kvm_vcpu_event(s) fix?
(and, empathetically, introduce a typo in the changelog proper :P)

>> Oh, I do feel silly for sending typo fixes with typos...
> 
> LOL, I'm just disappointed your typo isn't in the changelog proper, because I was
> absolutely planning on leaving it in there for my own amusement :-)

