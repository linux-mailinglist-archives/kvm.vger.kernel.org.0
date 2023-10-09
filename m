Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA0307BE7EB
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 19:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377888AbjJIR2i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 13:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377921AbjJIR2g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 13:28:36 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04D1DA
        for <kvm@vger.kernel.org>; Mon,  9 Oct 2023 10:28:32 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id ca18e2360f4ac-7a24c86aae3so60185839f.0
        for <kvm@vger.kernel.org>; Mon, 09 Oct 2023 10:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1696872512; x=1697477312; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7BjVxNp/YRM5k6f5csMN7Rbql0PbCwEA0Qhwm+7n1+k=;
        b=bOrp4xGQwrJaWsN9JAdBG7oklwSij9849M7r9DSH53jcRI89G95hha3jv1+oHgTQTt
         aVyQB3L3tyuO/ZuCtKZBSIPi6tHxaDJQIjI9A7dK8n+wwFtx7d6ZP+MhKFP4rgFhhO7E
         80HIR8M8J2ITd8NNj+wQ0DDDXmk8kgrPBIH6k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696872512; x=1697477312;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7BjVxNp/YRM5k6f5csMN7Rbql0PbCwEA0Qhwm+7n1+k=;
        b=FV9gpEDmVJK2w8vbfa0b+FVgclFC+Kfh4VHSoCDRkzuTlT7Q0u4AvhjMcOYjNNY4Yn
         rhq5gdB0HjN2o0IsE+sFGs80kxQ+bUa6yDmCirqhjTl+p4sxS0ge5SWrtU5YL53B3N+G
         +9fqTLDepHfmXBfzk4F31ZTdhwRsNjYKocE6UMYrgYNhBeWgwswmdQ057gCKjfARHZcL
         gqzHavjENBj48fDn7lhPWG+b3wcyq43ZVF7qtw1qo8F8qtntCB6a0zgORas3cfJrJnuu
         dI/zkVo0yNIMdSxTpR+CiOs9GoZeWmTKUN0lxIsayGuZCPo+I2OT059z+3p1Y/LvlYA8
         lvjA==
X-Gm-Message-State: AOJu0YxlG6/EFjAhBiSYAdwKMaGYjkqa+wSLmQJ6Q7l7f5ext0d26fab
        vytNmOh5Pr1bkt04c7MLhqBMhw==
X-Google-Smtp-Source: AGHT+IG524RLm2iNS7rGqigma7E7MkPPDCMafw1IlVfCC2AnEpocWiOhD+/3WH5nhUw39rAm0J1f0A==
X-Received: by 2002:a6b:5a0a:0:b0:790:958e:a667 with SMTP id o10-20020a6b5a0a000000b00790958ea667mr15344414iob.2.1696872512138;
        Mon, 09 Oct 2023 10:28:32 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id fx23-20020a0566381e1700b0042b47e8869bsm2242289jab.49.2023.10.09.10.28.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Oct 2023 10:28:31 -0700 (PDT)
Message-ID: <cb1dfcc1-e03e-4517-8f77-d08f10aa507c@linuxfoundation.org>
Date:   Mon, 9 Oct 2023 11:28:30 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/8] Add printf attribute to kselftest functions
Content-Language: en-US
To:     Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
        akpm@linux-foundation.org, christian@kellner.me,
        fenghua.yu@intel.com, keescook@chromium.org,
        ndesaulniers@google.com, coltonlewis@google.com,
        dmatlack@google.com, vipinsh@google.com, seanjc@google.com,
        brauner@kernel.org, pbonzini@redhat.com, shuah@kernel.org,
        hannes@cmpxchg.org, nphamcs@gmail.com, reinette.chatre@intel.com
Cc:     ilpo.jarvinen@linux.intel.com, linux-kselftest@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Shuah Khan <skhan@linuxfoundation.org>
References: <cover.1696846568.git.maciej.wieczor-retman@intel.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <cover.1696846568.git.maciej.wieczor-retman@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/9/23 04:28, Maciej Wieczor-Retman wrote:
> Kselftest.h declares many variadic functions that can print some
> formatted message while also executing selftest logic. These
> declarations don't have any compiler mechanism to verify if passed
> arguments are valid in comparison with format specifiers used in
> printf() calls.
> 
> Attribute addition can make debugging easier, the code more consistent
> and prevent mismatched or missing variables.
> 
> Add a __printf() macro that validates types of variables passed to the
> format string. The macro is similarly used in other tools in the kernel.
> 
> Add __printf() attributes to function definitions inside kselftest.h that
> use printing.
> 
> Adding the __printf() macro exposes some mismatches in format strings
> across different selftests.
> 
> Fix the mismatched format specifiers in multiple tests.
> 
> Series is based on kselftests next branch.

How did you find these problems? I don't see any information
how these problems are found in the commit logs.

thanks,
-- Shuah
