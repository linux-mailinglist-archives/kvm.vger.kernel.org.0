Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59A7A77C375
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 00:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbjHNW3a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 18:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233288AbjHNW3E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 18:29:04 -0400
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A431715
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 15:29:02 -0700 (PDT)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1qVg3W-00FWlu-8A; Tue, 15 Aug 2023 00:28:58 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=v0tD9wxu6iDoGFHED7XXCaf8BN3fY5f8hYUXQmJzXX0=; b=RsXo4umEJRUxi/fOaveIDshLTw
        dm++0SKmKVZFOZLGhfFKjbk5aOciwyna9RdIr7rFFSllHWEbNUUWPlR2hKbqrdEK7gxUY3Vcq006R
        jxKdFB9aP/GjiojnH2TMWOhrXjSF2pojY0hle/iUu/IxDp7FAwEcjDIcYbLZALcGoTCvsXO8qzvZ5
        WkHVsFnk48AkRt4d1cLylCLY/HP/tpxNqFdA+NUQ/knVy4CBeMdXjkEpryanGsPlt/2ByGm60zQ89
        ixuT/RnphTRTTVYyc/md1zO+5XxVDrX4sa0ej6eelkjpY5ZW57nitp3pprVrRlW2ATOFORK1Q42M3
        1YzThfdw==;
Received: from [10.9.9.74] (helo=submission03.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1qVg3V-0004Gp-9u; Tue, 15 Aug 2023 00:28:57 +0200
Received: by submission03.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1qVg3H-0006u8-Qg; Tue, 15 Aug 2023 00:28:43 +0200
Message-ID: <13480bef-2646-4c01-ba81-3020a2ef2ce1@rbox.co>
Date:   Tue, 15 Aug 2023 00:28:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] KVM: Correct kvm_vcpu_event(s) typo in KVM API
 documentation
Content-Language: pl-PL, en-GB
To:     pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net
Cc:     kvm@vger.kernel.org
References: <20230814222358.707877-1-mhal@rbox.co>
 <20230814222358.707877-4-mhal@rbox.co>
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <20230814222358.707877-4-mhal@rbox.co>
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

On 8/15/23 00:08, Michal Luczaj wrote:
> I understand that typo fixes are not always welcomed, but this
> kvm_vcpu_event(s) did actually bit me, causing minor irritation.
                                 ^^^

Oh, I do feel silly for sending typo fixes with typos...

