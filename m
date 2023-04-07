Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33C8E6DB6BA
	for <lists+kvm@lfdr.de>; Sat,  8 Apr 2023 01:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjDGXBT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 19:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDGXBS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 19:01:18 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C083AF33
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 16:01:17 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id b5-20020a17090a6e0500b0023f32869993so2574434pjk.1
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 16:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680908477;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FM1IoSWydLocj7jgKW9MEFCM/UyoS3Vw58k8MbYXpPI=;
        b=VQRL/jwZ/iwhTjW4uDgB/xQLypDFRo9dz1YtZKQWTGVtHNnhpUq2Kgr4tJlXpVc9Qj
         KBbQLfG2Z5FHXSI2VMMAmE9q1dOQk2iWj8kn9Q3lFDBbsPO0CVUPQMhVWuKl2kkGhFG/
         8Zx43AFsVbKUnCTXY9xLDWzf05mzNP0m7zfiIrbp+mM1baQPyagVzxLIe6pjmdO2GbAF
         FeHj3l+btpKL7NfDJ58MeRoUTWNwI8jp8DY7i9J3B7PBjUoMr2KbS1QbvXFBz9wfhpPH
         DHITQUJiwZ2kYMJ1/oiVdG61WqG2rvBx9o0dwXq2wqhvT0EMxe8M67t1dsAj1odQ8rE9
         zrLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680908477;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FM1IoSWydLocj7jgKW9MEFCM/UyoS3Vw58k8MbYXpPI=;
        b=6MjLZ6UH/sZU55Ki32suj54KmsYACzcm2F8ByigEw2inF8e7sGxzvLiW1O5iRqd4mz
         Ag055XRzfIFT0gBwzo9t/UevtwurihmsUyOdLTLWVy6yV8Y4RH90nicksFsKpWMPVCk9
         0Z9GpDdaAMd9NcksYNxHlDI90Byus+Fb4NQcrNQ8uqjAWnhwFlrpejENIfua+/upIENa
         biWP2Xw176RpnakuodUjGJbjx/vaeLn7+wjxg930fXonWp2G4dzs8ylz0uQguO8W8kVJ
         sMkFMHN3Moes37bx7eRbSJEpnD045RfBItjY+2zW782vPSmJuq4keC5aYj7/zyreZzWA
         2ZzQ==
X-Gm-Message-State: AAQBX9c7hA/WXlrmNWLk1S1WsTlAfnEgkPmTsLfGPoRMgEKiseTcwjXS
        ID6VPnOyPKyu9JonH1hQY591bA==
X-Google-Smtp-Source: AKy350bRqvhbX5rOLuwqRdImyfLdTcBcyn1BquKHrKT2CT3Zjs0A2Q1f98kdBv1POsH49ZV8G3BXyw==
X-Received: by 2002:a17:902:d2c9:b0:1a0:50bd:31a8 with SMTP id n9-20020a170902d2c900b001a050bd31a8mr5700663plc.26.1680908476761;
        Fri, 07 Apr 2023 16:01:16 -0700 (PDT)
Received: from ?IPV6:2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8? ([2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8])
        by smtp.gmail.com with ESMTPSA id n10-20020a170902968a00b0019f3cc463absm3447735plp.0.2023.04.07.16.01.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 16:01:16 -0700 (PDT)
Message-ID: <af0397ba-f714-427f-c050-10b423cc772e@linaro.org>
Date:   Fri, 7 Apr 2023 16:01:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 02/14] accel: Remove unused hThread variable on TCG/WHPX
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Sunil Muthuswamy <sunilmut@microsoft.com>
References: <20230405101811.76663-1-philmd@linaro.org>
 <20230405101811.76663-3-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230405101811.76663-3-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/5/23 03:17, Philippe Mathieu-Daudé wrote:
> On Windows hosts, cpu->hThread is assigned but never accessed:
> remove it.
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   accel/tcg/tcg-accel-ops-mttcg.c   | 4 ----
>   accel/tcg/tcg-accel-ops-rr.c      | 3 ---
>   target/i386/whpx/whpx-accel-ops.c | 3 ---
>   3 files changed, 10 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
