Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23A406D1DA5
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 12:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbjCaKKz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 06:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbjCaKJk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 06:09:40 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B7551DFA5
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 03:03:42 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id w9so87514704edc.3
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 03:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1680257020;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pojhFZwTmFkItFSM+KpRORrJXdrpqvUjOYcHl6/9eR8=;
        b=mtDWlfpTVgP6lHqsd+OATkcaqboi4u3Uw2qtqgEOFfBh0BhvsXqTVtd59SD73CGWOH
         EscJ0PbZyPjrRHY0jQ+8MuBTX+ep34d7RNXxKkeolLUk0NZjPCuiWHeNHu7WN2dwbG2c
         GxLl7rR/AZ8uwNee/M936xkaWPFGgVq0uYm6HEJ66WHbF/Wl3AdrXKjmGtADBSbmU+8o
         OgsQB+rGkx+dtk5+OW5dZpDRecQnffFKOcZx8pjvWfibaSTLTm15J7TNXwD0PmiWlfbi
         bySndZgqmXkblBriWNcRPPOHXXcTfmKps7zxgd5VvGYwTIvywbUOTxQuf/v1YM6T7BAq
         +QVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680257020;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pojhFZwTmFkItFSM+KpRORrJXdrpqvUjOYcHl6/9eR8=;
        b=uy56q97l99LLAWJSYY0LlgvYVvaF8ooqe/xJ+v+4uc3AZEwiMG9iD2IzVGm1bSZqYO
         Vi5XkQlN5Bq536G9c5OwAYxWBMJxhVPQ9RA0iosmP+wqO78R3CcoTD/F77L/Agn6sru3
         kB+0Zebouc8wvOTfi/VkGt1ASy239EOTJ30vv59kFGfZ0bCAepFo87YQaTEoyvq2Dqqs
         4KGQBbrG3hVLTkjEg/4vn8j5tMTD7XOPQgLtkvabSi17Gpf6iB5KFUfgRE3J/VailFiR
         dZ+7nbBckfFW3zWLsI1MkpVS+nT6c5B94oBSmaRqlXYMhKNBDWfMaUxqZGHPMxyky/B1
         nIzw==
X-Gm-Message-State: AAQBX9c38qlvYgWpuH0XGGBVML3WAGG5LQWOQKcmo/QaKbMCSId7c2uO
        CtjK8HGJEa/NfTT+InCROMIwLGi/NX7LFfGUFVM8vg==
X-Google-Smtp-Source: AKy350bQMBW+klTh2NMf+UhENspVbMYB8T2hV3zINiEWna3jSx6RX56PiUsAuNdIUtzoZ0HRbp/PAQ==
X-Received: by 2002:a17:907:3e09:b0:93e:82d1:9ae0 with SMTP id hp9-20020a1709073e0900b0093e82d19ae0mr30077916ejc.49.1680257020415;
        Fri, 31 Mar 2023 03:03:40 -0700 (PDT)
Received: from ?IPV6:2003:f6:af1a:5100:d774:c595:6e3b:4e1e? (p200300f6af1a5100d774c5956e3b4e1e.dip0.t-ipconnect.de. [2003:f6:af1a:5100:d774:c595:6e3b:4e1e])
        by smtp.gmail.com with ESMTPSA id d3-20020a170906544300b009476309c1d9sm795151ejp.125.2023.03.31.03.03.39
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Mar 2023 03:03:39 -0700 (PDT)
Message-ID: <3d8f51a2-dd64-0ae0-652e-15cf99954829@grsecurity.net>
Date:   Fri, 31 Mar 2023 12:03:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [kvm-unit-tests PATCH 2/2] x86/access: CR0.WP toggling write
 access test
Content-Language: en-US, de-DE
To:     kvm@vger.kernel.org
References: <20230327181911.51655-1-minipli@grsecurity.net>
 <20230327181911.51655-3-minipli@grsecurity.net>
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <20230327181911.51655-3-minipli@grsecurity.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27.03.23 20:19, Mathias Krause wrote:
> We already have tests that verify a write access to an r/o page is
> successful when CR0.WP=0, but we lack a test that explicitly verifies
> that the same access will fail after we set CR0.WP=1 without flushing
> any associated TLB entries either explicitly (INVLPG) or implicitly
> (write to CR3). Add such a test.

This test is insufficient to test all corner cases, as noted in [1].
Especially the emulator needs to be tested as well.

I'll send a v2 soon!

Mathias
