Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C627D61EB4E
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 08:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbiKGHCd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 02:02:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbiKGHCc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 02:02:32 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E51657D
        for <kvm@vger.kernel.org>; Sun,  6 Nov 2022 23:02:31 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id 78so9633903pgb.13
        for <kvm@vger.kernel.org>; Sun, 06 Nov 2022 23:02:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c3NDlrtxTnzf63blWHyYlylWW6DzT10BqPHwuWLgBT0=;
        b=HpjleDZ6wi3LiXTtpMVDr/zZ2AzrnwaiyCj03mVDk+fryn9o4DhBlKnWcXMx8ECoJD
         0Px5aFiPB2EzFDUSA9BKh6XP7xajx/fzuS+OZ8TO9TaCI04yWJyKSiPKVWQHZyXCmTy+
         N36BHrvXPmHGEtcssNAlFwpL8zv6kNFavKm0F5GFG5YlD7C4wjhx72prwD7vQBmGfkRb
         gNMiisQLb1LR7vlCRq/r7d64OwG2HpUnxF6pmXEEjaEJPxcRABxNafxKd6IkYRqGbJ7A
         fMFht25c71uF0VA0YYDBiwIR87zPTS0Fnlr6vqQREO4XUiAF4fzZshdoAZbl5ajZcgnY
         OKow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c3NDlrtxTnzf63blWHyYlylWW6DzT10BqPHwuWLgBT0=;
        b=CgRPykVYojqdjRKkXSqL/ZNVQlmKzqcHDF7hfMjkV2iKxt9nYqaqzIBhxYXbXtptM8
         FG4gC8Kk7taKO6Go06OxU0rg/c51Ivaftlry6Q4n9EZuj4SP6EoNWZrIW4WvZSYytXze
         AKBQstOYRZw6EaUpff7INwybX1AQJqzjfOGKr7a9E6PBnOzlRZDtbyKCgJqrL6bgUvkB
         TPS2ArBuHz8OuoYYw6NiF/I1Zfvwv4HVzJRyfVRuwkaKanfrLOK1DLinIxQyVYsLW8ro
         mqjVi4NGUwILSfOF5dHF50pQE+N2JY/J2vpoJT9yqbU4iguBcb9E73+XLpGJ4BCHJSzk
         xN+g==
X-Gm-Message-State: ACrzQf0+0MJRskdtMJ34+HuewHAVkJa0IV0LwfbqpXxo2/wruplQai7k
        fYe1kImQ6+EQG5HOgMrDnUY=
X-Google-Smtp-Source: AMsMyM4F71JsOV/+4HVQIeZ176E53vNJPdTNE7jw+EB/W4KvRHMQ4j2KznI+iHZ3bXNaF/dU8uNkcg==
X-Received: by 2002:a63:2d46:0:b0:43b:ddc9:1d13 with SMTP id t67-20020a632d46000000b0043bddc91d13mr762550pgt.284.1667804550865;
        Sun, 06 Nov 2022 23:02:30 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id i10-20020a17090332ca00b00186cd4a8aedsm4200303plr.252.2022.11.06.23.02.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Nov 2022 23:02:30 -0800 (PST)
Message-ID: <d33d72b6-eb32-6100-7fe7-a5843f42ed71@gmail.com>
Date:   Mon, 7 Nov 2022 15:02:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [kvm-unit-tests PATCH v5 00/27] x86/pmu: Test case optimization,
 fixes and additions
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20221102225110.3023543-1-seanjc@google.com>
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20221102225110.3023543-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/11/2022 6:50 am, Sean Christopherson wrote:
> There are no major changes in the test logic. The big cleanups are to add
> lib/x86/pmu.[c,h] and a global PMU capabilities struct to improve
> readability of the code and to hide some AMD vs. Intel details.

The extra patch helps. Thank you.

> 
> Like's v4 was tested on AMD Zen3/4 and Intel ICX/SPR machines, but this
> version has only been tested on AMD Zen3 (Milan) and Intel ICX and HSW,
> i.e. I haven't tested AMD PMU v2 or anything new in SPR (if there is
> anything in SPR?).

V5 tests passed on AMD Zen 4 (AMD PMU v2) and Intel SPR (for PEBS).
Please move forward.
