Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 565C367D824
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 23:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232378AbjAZWEo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 17:04:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjAZWEn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 17:04:43 -0500
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E7532684D
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 14:04:41 -0800 (PST)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1pLAMJ-005rCl-4R; Thu, 26 Jan 2023 23:04:39 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=xmg2x4nAPZu99MitcfWFfyprUZrgT0hNA14L6m/6Vp4=; b=MmaXh3j9vCJMJZ2ju9CNteG0mB
        D9PuDrvtzRQhh1s2irpbdQcnFKZFAFdNGVYRy/dqxrV4ZYqHkHSQ4pV2vCPut0s5y3+GcX2vz4uBb
        1MaHrDnDnGdMOl7MNY3nKZ6WpVnlNaCl5jtUR4dAhybbIFwyEXtJwVVLg7L7IIL55NR5vz0lI7ufp
        05C11hfvfjj8W4hwiZLQb5c18B1c4kbs+B/enJd72GGS9x+xEpXvVALOYPzNzligQIMqx96bWhJJd
        xuf1ytoJY1sB8QCgZ7Kgm8Aafy+XfbS9Zfx84xGYtagnmM7mDUSLENB5d8KnCZV8Pm0wCcRFYUM60
        8Yln6yng==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1pLAMI-0003OY-Cs; Thu, 26 Jan 2023 23:04:38 +0100
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1pLAM0-0004eS-Jl; Thu, 26 Jan 2023 23:04:20 +0100
Message-ID: <5284460a-02f1-1ffc-a123-1bf0bc1d0e08@rbox.co>
Date:   Thu, 26 Jan 2023 23:04:19 +0100
MIME-Version: 1.0
User-Agent: Thunderbird
Subject: Re: [PATCH 0/3] KVM: x86/emulator: Segment load fixes
Content-Language: pl-PL, en-GB
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
References: <20230126013405.2967156-1-mhal@rbox.co>
 <Y9K5gahXK4kWdton@google.com>
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <Y9K5gahXK4kWdton@google.com>
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

On 1/26/23 18:33, Sean Christopherson wrote:
> On Thu, Jan 26, 2023, Michal Luczaj wrote:
>> Two small fixes for __load_segment_descriptor(), along with a KUT
>> x86/emulator test.
>>
>> And a question to maintainers: is it ok to send patches for two repos in
>> one series?
> 
> No, in the future please send two separate series (no need to do so for this case).
> Us humans can easily figure out what's going on, but b4[*] gets confused, e.g.
> `b4 am` will fail.
> 
> What I usually do to connect the KVM-unit-test change to the kernel/KVM change is
> to post the kernel patches first, and then update the KVM-unit-test patch(es) to
> provide the lore link to the kernel patches.

All right, thank you for explaining.

Michal

