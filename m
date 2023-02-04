Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D82B368A9C6
	for <lists+kvm@lfdr.de>; Sat,  4 Feb 2023 13:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbjBDMo3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Feb 2023 07:44:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjBDMo2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Feb 2023 07:44:28 -0500
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 994BC1F5E2
        for <kvm@vger.kernel.org>; Sat,  4 Feb 2023 04:44:26 -0800 (PST)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1pOHu2-005YjN-G8; Sat, 04 Feb 2023 13:44:22 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=rGkLyuxoh1ZYlpUUeWbl1b7/cR1iNEcxog31b6qiEIw=; b=Cm91SIVIiAFIG7ocKc9VFHbS0Q
        1kRZGJKuYn0v+vQXvbGBaI/tg5ELrVLR+qVZtylsnRdffszBQ+Au+P34un731k55tf1Js5koqD2kN
        ADRhepexpVJU8aEjwxN2ekiRehV5n7GIq5gtCz7qWUYlcisPc9AoI7V9xh1p81JqhUVIur+owoUns
        X06mH9Gaw1JbQIqRtHoPltXoebIiedKFtISmHFNxbMD/11peBaxbwfePpjSj071JnvuGLdQkRXp52
        W7GmEZYKrqj7fxUPhMm5N8OYlNikWD6apzaOTL0tq7MZoq/QfKFNifTTbXj9QoM91cb0gcI2rxvBn
        crUMLS6g==;
Received: from [10.9.9.74] (helo=submission03.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1pOHu1-0004Jv-LO; Sat, 04 Feb 2023 13:44:21 +0100
Received: by submission03.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1pOHty-0000TR-5k; Sat, 04 Feb 2023 13:44:18 +0100
Message-ID: <c50fbce5-4708-5c21-ac67-92d569f627e3@rbox.co>
Date:   Sat, 4 Feb 2023 13:44:17 +0100
MIME-Version: 1.0
User-Agent: Thunderbird
Subject: Re: [PATCH v2 0/6] kvm->lock vs. SRCU sync optimizations
Content-Language: pl-PL
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc:     dwmw2@infradead.org, paul@xen.org, pbonzini@redhat.com
References: <20230107001256.2365304-1-mhal@rbox.co>
 <167546859235.189151.11265081003538435603.b4-ty@google.com>
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <167546859235.189151.11265081003538435603.b4-ty@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/4/23 01:31, Sean Christopherson wrote:
> On Sat, 07 Jan 2023 01:12:50 +0100, Michal Luczaj wrote:
>> This series is mostly about unlocking kvm->lock before synchronizing SRCU.
>> Discussed at https://lore.kernel.org/kvm/Y7dN0Negds7XUbvI@google.com/ .
>>
>> I'm mentioning the fact it's an optimization (not a bugfix; at least under
>> the assumption that Xen does not break the lock order anymore) meant to
>> reduce the time spent under the mutex. Sean, would that suffice?
>>
>> [...]
> 
> Applied to kvm-x86 misc, thanks!
> 
> Note, I massaged a few changelogs to provide more context and justification,
> but didn't see a need to respond to individual patches.

Sure, thanks.

Michal

