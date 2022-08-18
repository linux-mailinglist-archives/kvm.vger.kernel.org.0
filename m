Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EEB0598133
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 12:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243932AbiHRJ7K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 05:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242603AbiHRJ7I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 05:59:08 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B49427146
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 02:59:05 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id z20so1230770ljq.3
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 02:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=C3ba4yHheW5zprHK4xaSfKb4nNr+PJySvSlyPUInypY=;
        b=kKZwm2Y1bNsACwoLDGfj3xeWLK7EuwFNINfyozQ1DrHMRpH1GeM4VlbaxXJhHHzNlm
         99SvZmwdmkcRa/abxR9xs3bTumXoffxjWPAWwWxWt5ucgJEdvSLguQjTvcQELn7JjSSz
         lOyHuHZuW2RZAvURc5d/ZLxJJ5ug3xxGhwetoyOO6RTf/LID5OpyJUHufp2bMiC+pK7J
         AKBZaYpbI4Fi1+o2IUUFKk26wiK8n2l4EHt1OWX6f+20xOrjEr0g9tGd+RQvFOL2GSXK
         mHNzTtgCBy7u8bRUw5eloF4Xw6488NrwdAC6J1/xOP4Pl4gnNAze5V1DdhteA0cnj2Lz
         kwsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=C3ba4yHheW5zprHK4xaSfKb4nNr+PJySvSlyPUInypY=;
        b=uyZuZwlBkyfa/2dGrUu4qhmkGsLCkNfTBy8CNo9pEVBNqx0VqzWbuTQXBbBxbFh9kR
         m/3Wx0NaVw4aN0Re+hpufeKmIEiPdGrxN0G0wKPkJnN/OYu4dgUYRghKShBvj1cdD9bR
         cdalb8veRunl2XWM42TtvI2B3oKy1mj+LllpaOivRy2YRSt67NJ7GSZBsL0VM4Stqfdj
         uCUwetc52IE2zZ5qjUeRSy90Szwh20Xgcv4wDU2dbqStOEUyku18OSzsPKeNMraN0XWg
         3EEHl8uoKsUIR2d0ecAF34+1feiinYEUjP/w2Q6pK1kbyBzYuHuSz2gEtIUbca1y7EZB
         8C8w==
X-Gm-Message-State: ACgBeo32fUTNkQjcfx16DqYgScRDtLI9QUZAAaX4HjTEnI6m7ojIdft3
        tQoWH2zVsctDfRWFma6mpNkcvw==
X-Google-Smtp-Source: AA6agR54B8Wq5kprhSzFLvDsiJX1bUEd1bBo1eYAKq+/zJE3QVnHWvcS0sgkw3289Rm0f8B/Wfr2Ig==
X-Received: by 2002:a2e:be9e:0:b0:261:b228:ed8b with SMTP id a30-20020a2ebe9e000000b00261b228ed8bmr601633ljr.226.1660816743805;
        Thu, 18 Aug 2022 02:59:03 -0700 (PDT)
Received: from ?IPV6:2001:14bb:ae:539c:53ab:2635:d4f2:d6d5? (d15l54z9nf469l8226z-4.rev.dnainternet.fi. [2001:14bb:ae:539c:53ab:2635:d4f2:d6d5])
        by smtp.gmail.com with ESMTPSA id be32-20020a056512252000b0048a83ab2d32sm168965lfb.0.2022.08.18.02.59.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Aug 2022 02:59:03 -0700 (PDT)
Message-ID: <74156faf-492d-2e87-f32f-61d99131f17c@linaro.org>
Date:   Thu, 18 Aug 2022 12:59:00 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [RFC PATCH v2 1/6] Documentation: DT: Add entry for CDX
 controller
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Nipun Gupta <nipun.gupta@amd.com>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, gregkh@linuxfoundation.org,
        rafael@kernel.org, eric.auger@redhat.com,
        alex.williamson@redhat.com, cohuck@redhat.com,
        puneet.gupta@amd.com, song.bao.hua@hisilicon.com,
        mchehab+huawei@kernel.org, maz@kernel.org, f.fainelli@gmail.com,
        jeffrey.l.hugo@gmail.com, saravanak@google.com,
        Michael.Srba@seznam.cz, mani@kernel.org, yishaih@nvidia.com,
        jgg@ziepe.ca, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, kvm@vger.kernel.org
Cc:     okaya@kernel.org, harpreet.anand@amd.com, nikhil.agarwal@amd.com,
        michal.simek@amd.com, git@amd.com
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220817150542.483291-1-nipun.gupta@amd.com>
 <20220817150542.483291-2-nipun.gupta@amd.com>
 <93f080cd-e586-112f-bac8-fa2a7f69efb3@linaro.org>
In-Reply-To: <93f080cd-e586-112f-bac8-fa2a7f69efb3@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/08/2022 12:54, Krzysztof Kozlowski wrote:
>> +    gic@e2000000 {
>> +        compatible = "arm,gic-v3";
>> +        interrupt-controller;
>> +        ...
>> +        its: gic-its@e2040000 {
>> +            compatible = "arm,gic-v3-its";
>> +            msi-controller;
>> +            ...
>> +        }
>> +    };
>> +
>> +    cdxbus: cdxbus@@4000000 {
> 
> Node names should be generic, so "cdx"

Eh, too fast typing, obviously the other part of the name... node names
should be generic, so just "bus".

> 
> https://devicetree-specification.readthedocs.io/en/latest/chapter2-devicetree-basics.html#generic-names-recommendation
> 
> Drop the label.


Best regards,
Krzysztof
