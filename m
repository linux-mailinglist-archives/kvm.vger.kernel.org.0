Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46254688A96
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 00:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232341AbjBBXOz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 18:14:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233103AbjBBXOv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 18:14:51 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1976082436
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 15:14:50 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id r8so3524963pls.2
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 15:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UlyNtlsB3bfCYWQrrJ1ahrkRa01+uMJWOU2Vv4bur3M=;
        b=bVwJ4pHN4XLoTFOSg5WKTRuqT88p00HeMkkM6To5SxeI2T2yf5pVgtJqLkaECXz/Sd
         2W75R84iMYti7jxEdLjBI6OxNxYbH2g6W53IR5RiRSpKEn26/W5C3017a3vjkOKK643a
         BewL+sfct74b4nMkY6T+ZykSambpB8lKZrYxTWM8oECnDTVLF7ZKF6/Jmr+zufqkfU18
         x4y06o3ls/uvduelyf4QdKpcc9DS2ek8zkCeJaMnwoUbHvYlyAjd1DsDgNehTygiFGf1
         hCj6DhCXt0+0QI1bfq7a1IJGaicqJA4nDyTibATH1XKMMXUM1qmYrA4aB5F15rKswfN+
         wt5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UlyNtlsB3bfCYWQrrJ1ahrkRa01+uMJWOU2Vv4bur3M=;
        b=pHllF4WzgYuBJe9EF6qnKs2Dgn2vp8//YJdYvW7pZFp2BUAOlxxD11gokWNhtrQ0cu
         QbmE233qmKIHn0LuR99EdhaUTj/wQm0SAVasdIaRtxinvxgbxqpFznMlqJy2L7c9Ruai
         EZBRoKQwwJ4+ZbR7ffgtGJG/jZc7JptvD/oWWX0QxzfJ/17zWKBaFNY57lHzUtViGUJF
         YShSl/dlKny8LVeO5TzmfzwFH0h9LaXp3JnJ7gaTEfyDgJOT9mB/0T4VNOsIozjn46qP
         +sha9p0r5Ktk8wWKKzj0w7HhBoTVHd5mvtglf7KFHNcD+iZSS6qgXReSfmZkfBZ0JxPL
         I8IA==
X-Gm-Message-State: AO0yUKVHYelKOFHk3/b/k9i/aXggp7lqUgrC05E3tLtgR48FrXrv5VEq
        MMx8gSZN1QtB2MWvy28WL+DCiw==
X-Google-Smtp-Source: AK7set8uFzbs2/4vCc6W8TaI9Nze1+7/OInAB5fW+Of2XGDoHs/hf3buVtLEXcf4mZc5VHusQLJIng==
X-Received: by 2002:a17:902:c70a:b0:194:586a:77ba with SMTP id p10-20020a170902c70a00b00194586a77bamr6764333plp.52.1675379689484;
        Thu, 02 Feb 2023 15:14:49 -0800 (PST)
Received: from [192.168.50.194] (rrcs-173-197-98-118.west.biz.rr.com. [173.197.98.118])
        by smtp.gmail.com with ESMTPSA id x23-20020a1709027c1700b001946a3f4d9csm214758pll.38.2023.02.02.15.14.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 15:14:48 -0800 (PST)
Message-ID: <31fc0aab-404d-919c-8ff8-cee75bb29ea2@linaro.org>
Date:   Thu, 2 Feb 2023 13:14:44 -1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 06/39] target/riscv: Add vrol.[vv, vx] and vror.[vv, vx,
 vi] decoding, translation and execution support
Content-Language: en-US
To:     Philipp Tomsich <philipp.tomsich@vrull.eu>
Cc:     Lawrence Hunter <lawrence.hunter@codethink.co.uk>,
        qemu-devel@nongnu.org, dickon.hood@codethink.co.uk,
        nazar.kazakov@codethink.co.uk, kiran.ostrolenk@codethink.co.uk,
        frank.chang@sifive.com, palmer@dabbelt.com,
        alistair.francis@wdc.com, bin.meng@windriver.com,
        pbonzini@redhat.com, kvm@vger.kernel.org
References: <20230202124230.295997-1-lawrence.hunter@codethink.co.uk>
 <20230202124230.295997-7-lawrence.hunter@codethink.co.uk>
 <CAAeLtUA188Tdq4rROAWNqNkMSOXVT0BWQX669L6fyt5oM5knZg@mail.gmail.com>
 <CAAeLtUDcpyWkKgAo2Lk0ZoHcdyEeVARYkh05Ps27wbOzDF0sHA@mail.gmail.com>
 <16a6fadf-ca13-d3aa-7e4b-f950db982a21@linaro.org>
 <CAAeLtUCTBASoGMMgzp_LxOiFkJq0wJFQUC4kDzCWA47iLR_N5Q@mail.gmail.com>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <CAAeLtUCTBASoGMMgzp_LxOiFkJq0wJFQUC4kDzCWA47iLR_N5Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/2/23 08:07, Philipp Tomsich wrote:
>>>       tcg_gen_gvec_rotls(vece, dofs, aofs, tmp, oprsz, maxsz);
>>
>> We can add rotls generically.
>> I hadn't done this so far because there were no users.
> 
> I read this such that your preference is to have a generic gvec rotrs?
> If this is correct, I can drop a patch to that effect…

Yes, please.


r~
