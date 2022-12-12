Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1F364A06C
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 14:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232701AbiLLNYo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 08:24:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232658AbiLLNYm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 08:24:42 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC9E2DF8
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 05:24:41 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id 124so8566059pfy.0
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 05:24:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G5DXVZD1BHVYKjGoHyLP38bEfWsIX6KGFM+BIDaEVCQ=;
        b=bT5hXhsj3uP+ft36ok0Zjq89MmTWNwllzdVLD8y+istucBhYq2SzDGkJAGFvlltuYD
         I5WtT/s8q9rWJ7s/t6Cf9rPQ08CjqdMSR/HJnCTzT1+4k9BUn7z0DmlmgoaUSxHkfnDg
         +YB0fxMufj8MkLJGaD2oAqcUGU7yn+JzDZ9H55nqaqo1xE2g4jlypY0Tq74U7wIXrJNK
         UHGbMOWZJBZBByKZMrK72nOlouJQgv89E0hrhy1hCgWHuxCoSxC76cliOhL0iSKE/4od
         X3ozbZmPSejQ5T+iOWGz+DzQ+HLKUTXjGkpZAnTH2aaBEvL+ggSz1EAkIvqTWrCIzf+g
         ErXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G5DXVZD1BHVYKjGoHyLP38bEfWsIX6KGFM+BIDaEVCQ=;
        b=mCbDeX/3prxyDfg5MAjYnuhbK3QyObIoOAxto18gVJ3HAg0WBX1e5TbKGrlEXre+0U
         ndbjj2DTH+2oQ3CQHo6f3tVUKQPAdcTrDeg9VRDQoBNeXfzIhoZHn7q3q9nH94IikvW3
         Hkwr01IWjqvFxAwiz2vbJewYUumjFXB+iQCL2ne6KVAC4EoC714txixNEyHyPD+M3Bkn
         0zLuO60UXKJcpd20/rsVJC7AdwGu6se6DLqbHNmvnGDGJpNCuKr5wyhDTkdEP7jKU3si
         5VTW1XXpyECcurV2zPCnVyVu0TG4/ZHWsmuCROKJmwLghMlCmsZLN1MIVdiJ8zn/f0ln
         zd7A==
X-Gm-Message-State: ANoB5plOw6NsW1tnVcMqTMFwlHxA96DlhIwEyvUWyTPvlypYxR1uRq8f
        H+zO4ASE/JSzSmb9u5teg/bhXsTHstCdmd/n
X-Google-Smtp-Source: AA0mqf41S/hyIcYJTsI3oVhe/G2yMPGmvzXJyNJSdpqtoRgSEUU4AFRjX/ziyyw/6l4pFbOSgIWHtw==
X-Received: by 2002:a62:602:0:b0:572:9681:101e with SMTP id 2-20020a620602000000b005729681101emr14414293pfg.25.1670851481431;
        Mon, 12 Dec 2022 05:24:41 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id v11-20020aa799cb000000b00576259507c0sm5788088pfi.100.2022.12.12.05.24.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 05:24:41 -0800 (PST)
Message-ID: <69e2a68f-32d2-0f96-9564-4382f3f74d2c@gmail.com>
Date:   Mon, 12 Dec 2022 21:24:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH 0/2] Fix "Instructions Retired" from incorrectly counting
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     pbonzini@redhat.com, jmattson@google.com,
        kvm list <kvm@vger.kernel.org>
References: <20221209194957.2774423-1-aaronlewis@google.com>
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20221209194957.2774423-1-aaronlewis@google.com>
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

On 10/12/2022 3:49 am, Aaron Lewis wrote:
> Aaron Lewis (2):
>    KVM: x86/pmu: Prevent the PMU from counting disallowed events

Nice and it blames to me, thanks.

Would you share a detailed list of allowed and denied events (e.g. on ICX)
so we can do more real world testing ?

Ref: #define KVM_PMU_EVENT_FILTER_MAX_EVENTS 300

>    KVM: selftests: Test the PMU event "Instructions retired"

And, do you have further plans to cover more pmu testcases via selftests  ?
