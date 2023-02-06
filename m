Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC96468C5B8
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 19:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjBFS1U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 13:27:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjBFS1T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 13:27:19 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A356028D2D
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 10:27:18 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id n20-20020a17090aab9400b00229ca6a4636so16074716pjq.0
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 10:27:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pf3wpo98ocpZojzJUra9uZGXeOuH5mXdt8yWg6RtZZY=;
        b=TJa6TnxHhKEivNxKOKlklAu07cnRPG9dR4+Vw049IqSz+IB19WXwQ28/Yu9cIhxXmQ
         ONaj2y6stdJFY0CSIclSQIaecIyQuc715Xo+hGpFA8QnC3M3ADFiBsA5K4Pb/8cF0qxr
         mbur5/9ZpMurib/WRaylfqSDFo/ceJsL3J4C+NTGRbeLUAR4Ep5MC07ddrEw3Cu7byQo
         +PNlFliuR2ETEoWN2NZJcI6ihtmxjLS3itkX24UeuTbNEqQC0jitw7wlulG3fkSx/jUE
         JQM8Si6whQ1qEg07McP2zXmyI5iVS+f90F+5KV36gyG7qenqPSS4X9e4LROtQa2v5hCf
         XaNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pf3wpo98ocpZojzJUra9uZGXeOuH5mXdt8yWg6RtZZY=;
        b=bzt3OnW80i4rwpJCIErIsAc9QTjyARd2zCSPf2FK4hFxN6fExHsJxRsfR6ucbmJQ0P
         TX8+gANZL7RBFtGzxHz1CWFQT3XOF3HwuIvYg+reuVp6oGEJJ/qhtDLo+1R4gOG044+L
         Fgbc+n6F+E4HRq6AkHc/l0Y5Z5YD7N/oIt04QPuUCkpO+lXYzKidP2Ha9/SJJqcCSpa1
         t9sdFjqWZMadFsPAZj7J0c2R5IoGXuRAg3Wzv5InEtt4LwtddZRNu8SwrvsRicdqq3bg
         XWKMEqq9s26dvYPQR/+0TEXbywSWunA4DIph7U0howrHjnNA6lS5q9vCXzlL+AN4b0Xq
         op0A==
X-Gm-Message-State: AO0yUKVU/uNhnPfGJ+Rzptivu7kCU+RLKwDQ5Avfxz4OB7GddU4dZl5Z
        bWMbincppIZMwg/y5k1cQBYBmQ==
X-Google-Smtp-Source: AK7set/N6u1sagtvJP1JT+ZXBR9x5zwXRHdQg5WiucTmuzZ7wcw8vc8YeuqN2UB41pHb6ghRqL4MEA==
X-Received: by 2002:a17:90b:3b4e:b0:230:acb2:e3e8 with SMTP id ot14-20020a17090b3b4e00b00230acb2e3e8mr417696pjb.23.1675708038115;
        Mon, 06 Feb 2023 10:27:18 -0800 (PST)
Received: from [192.168.101.227] (rrcs-74-87-59-234.west.biz.rr.com. [74.87.59.234])
        by smtp.gmail.com with ESMTPSA id j12-20020a17090a31cc00b0022c35f1c576sm2865846pjf.57.2023.02.06.10.27.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 10:27:17 -0800 (PST)
Message-ID: <14188fd3-6e97-3e00-7d54-7f76e53eeb22@linaro.org>
Date:   Mon, 6 Feb 2023 08:27:13 -1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v5 2/3] arm/kvm: add support for MTE
Content-Language: en-US
To:     Eric Auger <eauger@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>
Cc:     qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
References: <20230203134433.31513-1-cohuck@redhat.com>
 <20230203134433.31513-3-cohuck@redhat.com>
 <ecddd3a1-f4e4-4cc8-3294-8c94aca28ed0@redhat.com>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <ecddd3a1-f4e4-4cc8-3294-8c94aca28ed0@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/6/23 03:32, Eric Auger wrote:
>> +void kvm_arm_enable_mte(Error **errp)
>> +{
>> +    static bool tried_to_enable = false;
>> +    Error *mte_migration_blocker = NULL;
> can't you make the mte_migration_blocker static instead?
> 
>> +    int ret;
>> +
>> +    if (tried_to_enable) {
>> +        /*
>> +         * MTE on KVM is enabled on a per-VM basis (and retrying doesn't make
>> +         * sense), and we only want a single migration blocker as well.
>> +         */
>> +        return;
>> +    }
>> +    tried_to_enable = true;
>> +
>> +    if ((ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_ARM_MTE, 0))) {
>> +        error_setg_errno(errp, -ret, "Failed to enable KVM_CAP_ARM_MTE");
>> +        return;
>> +    }
>> +
>> +    /* TODO: add proper migration support with MTE enabled */
>> +    error_setg(&mte_migration_blocker,
>> +               "Live migration disabled due to MTE enabled");

Making the blocker static wouldn't stop multiple errors from kvm_vm_enable_cap.


r~
