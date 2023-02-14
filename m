Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3F9C695968
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 07:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbjBNGrX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 01:47:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231699AbjBNGrV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 01:47:21 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED163C33
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 22:47:18 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id m2so16068111plg.4
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 22:47:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BI6Cf8UpvZjP6jplrWT8lnHQTrEvrPak/IxCZ3TqnxA=;
        b=JBXtmP0oKWhKbXVy9SFG5QnLv5p156Nl5d9tM4socGM8bCeNPWjivlRdjGxPPH/90M
         jZshXbibrDLszEZ6uPyh9DgntgQlNNnc1PRuSE2ISl8DqYfn0neJwjb96MrGUhk6iTEr
         /wvqQyVWi9gn64brLINnJkPYqgcV4BqEsNnLf10EFKmwaHhDDASk4kXwqBe3YzbPGk8a
         7t61tBXFYQ7oTeAb8uHmrrskKIwLepgTD0S7p9i1X2+f4krYCvJkUahoHPEOvS/7Rtc5
         LnKcJsmqkuelUGP4MoxT/wBhkTm+Kb7jrxqE5kPF5NZ2Dc0Gz0nMAXIhlH/VmULJYKpE
         NTow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BI6Cf8UpvZjP6jplrWT8lnHQTrEvrPak/IxCZ3TqnxA=;
        b=g+rxdq5Ek9KbF/HrjPdGHfT0mfeEQwbNQBLL3f8RBwRBsNa0BmfLmKjSrTneTZ31Mv
         Uj6UCKHqQEQRnkcgQE4zkXYUV8JcrZ3MCbZd2Mvfx102vR2GZeQQHJEC+TqKGGJTrwE3
         Jtr/ynmC7gr0qwyF2C2Tu3U9MTrGkPCFhOq80nQ5zKBIjbPIHTccemJyiiTo6b14C+wF
         I6A7QKQycGV9Z3vBpsVTeNIlW8i9YiYMOWd5U+atJhVjEeNcybxogQ2jig6Wb7Os/nWh
         8eelKqSRNODLNEUfFPZ7mfoM2lrT9GBXgmwZL+Y0vBTBQDR4lZbPkULPhziTHHFgOeVp
         sFZw==
X-Gm-Message-State: AO0yUKUMVoIKwEMxOqNfabpta53bMoG1g6ZXSFG8vWGGY0FjDBE2jRGq
        cwYX7B+LVaILvNVP9TsiIU0=
X-Google-Smtp-Source: AK7set+QOcf1iskQqBVQ9vpwo4Tjb1XLAo85wuATxLCZ7v3GpKW4S+Lww3IHdjXjGBrRYzp3Y3ZSTQ==
X-Received: by 2002:a17:903:249:b0:198:a715:d26d with SMTP id j9-20020a170903024900b00198a715d26dmr1780681plh.8.1676357238357;
        Mon, 13 Feb 2023 22:47:18 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id w6-20020a1709029a8600b0019324fbec59sm6624552plp.41.2023.02.13.22.47.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Feb 2023 22:47:18 -0800 (PST)
Message-ID: <c5da9a9c-b411-5a44-4255-eb49399cf4c0@gmail.com>
Date:   Tue, 14 Feb 2023 14:47:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [kvm-unit-tests PATCH 0/2] x86/pmu: Add TSX testcase and fix
 force_emulation_prefix
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
References: <20221226075412.61167-1-likexu@tencent.com>
In-Reply-To: <20221226075412.61167-1-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CC more KUT maintainers, could anyone pick up these two minor x86 tests ?

On 26/12/2022 3:54 pm, Like Xu wrote:
> We have adopted a test-driven development approach for vPMU's features,
> and these two fixes below cover the paths for at least two corner use cases.
> 
> Like Xu (2):
>    x86/pmu: Add Intel Guest Transactional (commited) cycles testcase
>    x86/pmu: Wrap the written counter value with gp_counter_width
> 
>   x86/pmu.c | 47 ++++++++++++++++++++++++++++++++++++++++++++---
>   1 file changed, 44 insertions(+), 3 deletions(-)
> 
