Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F38CC688581
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 18:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbjBBRfz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 12:35:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbjBBRfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 12:35:53 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448B129409
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 09:35:50 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id n13so2563671plf.11
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 09:35:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z93XaQC9nhfkablGxm5prOumg5C52MtsNJtAVgf+/Xk=;
        b=siM7OcVxjUrp9VA9s6E/+waa5mTsORBQobtwYc3RoLp8uL5Uf3lkjX79K5voCbtz+y
         PbIPrt9b/ljjRw1AVx5NZMFbtlne2N0Jc0uDb/rC9etuO8MckxfloDKlPhBO/iQS83dR
         lVpR3X3TXXzwEk6qdFgcZA8SzcA7S4IGjeIQrYkFYvydDdzaWJ5TMsqrjgwmQePMol9r
         6O0ERV4zoZVNJ7nnVtPTAINndnt1PklTIdm+/+AYTvUX68LO5sYfEX47JGf52qsLiSLV
         /9v0tIfPj+O+AuOv9vLmJMHrPtVsRTCWnWHIgIp149tvJqNZ4C0JtHNlEaL/jCnt6WrB
         Ql6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z93XaQC9nhfkablGxm5prOumg5C52MtsNJtAVgf+/Xk=;
        b=j/sjyxIkQcBnnbDhekQhZZYurUbHIrIk+kx0is3ebJQAKH8oFp8K6c2fs84x4YN+pe
         anHmYAsx6tTZLH5UyDHSQMr5SicpRps7ibOS8iSfkHd2odGI6wdvOT6HUV0hNvMeu/et
         AuW/7opp2N6Lcw5MwTwIl68fJdVdG2C+RTId8pcY8G8KJH3Yj6U7KniW/b1d5G/7kZGu
         9lLWo36Ds+vCTSNYVRK0aoJXalzstAQwzdqkn7FI0muUJ8d4cQzoRJaNnlac/E4+Mjc1
         VYR9J4iIqVyiP00+ynacUk4Z+vBvUq1PNHsd7aEoMrtpLiAiQZsYgstC55pPYME907Q1
         qBIA==
X-Gm-Message-State: AO0yUKV2uuxMq36c9rKYGLho2rp0W7TPbw4UDJZcW2VIa7cGSvo8CUwh
        xPZPaRLeDmIjTyUhFbZHGE++TQ==
X-Google-Smtp-Source: AK7set8hqU5dyRazxJ180X7fxijCMJdWEZ2QWU0K21vL//Jsk+HdgCdiDJf7MzK9005de1HmiBT/5g==
X-Received: by 2002:a17:90b:390a:b0:22e:5ffa:2a34 with SMTP id ob10-20020a17090b390a00b0022e5ffa2a34mr7581580pjb.36.1675359349787;
        Thu, 02 Feb 2023 09:35:49 -0800 (PST)
Received: from [192.168.50.194] (rrcs-173-197-98-118.west.biz.rr.com. [173.197.98.118])
        by smtp.gmail.com with ESMTPSA id j5-20020a17090a694500b0022c2e29cadbsm3419163pjm.45.2023.02.02.09.35.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 09:35:49 -0800 (PST)
Message-ID: <16a6fadf-ca13-d3aa-7e4b-f950db982a21@linaro.org>
Date:   Thu, 2 Feb 2023 07:35:45 -1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 06/39] target/riscv: Add vrol.[vv, vx] and vror.[vv, vx,
 vi] decoding, translation and execution support
Content-Language: en-US
To:     Philipp Tomsich <philipp.tomsich@vrull.eu>,
        Lawrence Hunter <lawrence.hunter@codethink.co.uk>
Cc:     qemu-devel@nongnu.org, dickon.hood@codethink.co.uk,
        nazar.kazakov@codethink.co.uk, kiran.ostrolenk@codethink.co.uk,
        frank.chang@sifive.com, palmer@dabbelt.com,
        alistair.francis@wdc.com, bin.meng@windriver.com,
        pbonzini@redhat.com, kvm@vger.kernel.org
References: <20230202124230.295997-1-lawrence.hunter@codethink.co.uk>
 <20230202124230.295997-7-lawrence.hunter@codethink.co.uk>
 <CAAeLtUA188Tdq4rROAWNqNkMSOXVT0BWQX669L6fyt5oM5knZg@mail.gmail.com>
 <CAAeLtUDcpyWkKgAo2Lk0ZoHcdyEeVARYkh05Ps27wbOzDF0sHA@mail.gmail.com>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <CAAeLtUDcpyWkKgAo2Lk0ZoHcdyEeVARYkh05Ps27wbOzDF0sHA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/2/23 04:30, Philipp Tomsich wrote:
> On the second pass over these patches, here's how we can use gvec
> support for both vror and vrol:
> 
> /* Synthesize a rotate-right from a negate(shift-amount) + rotate-left */
> static void tcg_gen_gvec_rotrs(unsigned vece, uint32_t dofs, uint32_t aofs,
>                         TCGv_i32 shift, uint32_t oprsz, uint32_t maxsz)
> {
>      TCGv_i32 tmp = tcg_temp_new_i32();
>      tcg_gen_neg_i32(tmp, shift);
>      tcg_gen_gvec_rotls(vece, dofs, aofs, tmp, oprsz, maxsz);

We can add rotls generically.
I hadn't done this so far because there were no users.


r~
