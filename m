Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C24586A90A3
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 06:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbjCCF4K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 00:56:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjCCFzp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 00:55:45 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F4071A4A7
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 21:55:16 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id qa18-20020a17090b4fd200b0023750b675f5so5083343pjb.3
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 21:55:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677822916;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KOQ/ltPn2Eddhp5+iQzCGkaQi63xYnRWecNb8+evpJo=;
        b=mDd5CzfSDc8QxiSxdmJEO3Ibq04D18Lkb0dw0aH5sinwsnUrDuvuCs8NiHvJkqbP7l
         1chd9Av1QE/dd2gH14/HUEIYrRMSS8WikfcCYqd000iW8Iu2dFsUP+YgaFK9+xj71gjj
         1o2NCtMU7jEc4dCp8RS13NP+W42TTeko3ylWb/WDxdLWttAKBGYFlPTVjQTIQ3Aq9kEm
         r/pyAOpWbUMuH7oSIVHKSJKz0QiuJUkz9bMPuExcJPYXslYnViFe4vVdzOmRXkibz06o
         PBL3hJU0op5eE2qobWbfzDIS93y0gm0Lx29qCND7WLgC1z9Pgr6nkFGE2ppSWUM+t4Uf
         +Shw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677822916;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KOQ/ltPn2Eddhp5+iQzCGkaQi63xYnRWecNb8+evpJo=;
        b=6IzX5SiZJniph2JuLqz3RKgg06kJeiBIjn7mUfoRRh6hk+Qwb3Vrx/8wbk9Y0cQ0D6
         9QEkAxWdDMFMbDFOAS4HQEqpCT77vhh1lRZONdOrW5KM0Yw6AN+gk9Sqri99pEn44zr7
         d5NHweg/U2JBF1YzbBc/ZbiU5KBVVlstz+/ZUD9GdbYjc73HJzCc8o1k0A4wzmdgzYlg
         jf30zxGT4EwuFEUB1tmYbiOajzM3YAsOk2BsQqDVGHNXqC8wz4zN61lRIo4St6hBt6ck
         tIiZsVOcTILZQJ+AAfoZmfvTPNh3i7AcrMQo9wmFTmjQ4Qt26VVOVQ06m8LNdqClBeeW
         jvIg==
X-Gm-Message-State: AO0yUKVpq/5YdSxM61ZdipDhItL1xv+F27HZbRlseNU6tFARWcfUvFlu
        keep+RmXOJtL88kDrm9IL74=
X-Google-Smtp-Source: AK7set+MGFo33SQ219pcTvRgqasOpYznnaoydtjwexCSFlRldGRRAkdSuAVTNOrb0pn3lVfCS1zPTw==
X-Received: by 2002:a05:6a20:7283:b0:bc:80bd:462d with SMTP id o3-20020a056a20728300b000bc80bd462dmr1187810pzk.46.1677822915782;
        Thu, 02 Mar 2023 21:55:15 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id v19-20020a62a513000000b0058bacd6c4e8sm629562pfm.207.2023.03.02.21.55.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Mar 2023 21:55:15 -0800 (PST)
Message-ID: <e2969c02-418c-1c62-29e6-0d817d153dbd@gmail.com>
Date:   Fri, 3 Mar 2023 13:55:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH v2 1/5] KVM: x86/pmu: Prevent the PMU from counting
 disallowed events
Content-Language: en-US
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        kvm list <kvm@vger.kernel.org>
References: <20230228000644.3204402-1-aaronlewis@google.com>
 <20230228000644.3204402-2-aaronlewis@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20230228000644.3204402-2-aaronlewis@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/2/2023 8:06 am, Aaron Lewis wrote:
> +static bool pmc_is_allowed(struct kvm_pmc *pmc)

This function name is a little less self-expressive since a programmable PMC
is likely available if the counter is accessible.

How about rename it to event_is_allowed(..) or pmc_cur_event_is_allowed(..) ?

> +{
> +	return pmc_is_enabled(pmc) && pmc_speculative_in_use(pmc) &&
> +	       check_pmu_event_filter(pmc);
> +}
