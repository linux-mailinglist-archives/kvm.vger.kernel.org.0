Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4A369DC54
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 09:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233641AbjBUIoX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 03:44:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233560AbjBUIoV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 03:44:21 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62846E5;
        Tue, 21 Feb 2023 00:44:20 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id x34so519027pjj.0;
        Tue, 21 Feb 2023 00:44:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iAdVpmaUtP1sMiKhdmhcYrJ4v5VDK3Of4Da2QjdRn/Q=;
        b=Axa5vyTi9T3TZzw9+JqrNW3qQhqWqtKfNCffJfbjHIyhbcSPOZkXTMWHfVvnWZUC0J
         JOjXFBVgQhLmqT3vRwFsU3odpuVFnR868Mhnw1VPL6cNPk8ZAj80BHy30hrZMK7Ur6A4
         29LM1BWubPuS2nd7ll3oX0FtTqJEW0n9xSe2A4w/SlpRV1A9jJ4ZZtGmmEqCncj/lAa7
         9uAty/F/vQDgIEQwfv6Thpis7Q70NkbYxAVaKl9dqSYVKOsCG3pAV/lwQV+9CZg1sxuW
         OkbQxr5Ht3fE2KRnYLWSbSLHp4z1Heo4Z99+3WTX1txFCG0BMBN2gOUF/h/0nGioazht
         oFKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iAdVpmaUtP1sMiKhdmhcYrJ4v5VDK3Of4Da2QjdRn/Q=;
        b=0cs+oQNBJIoAtdn/o6bK1nKo9JdQk1tm6K55PXxJ/a/HAduRxarZCakSrv4xydfa/e
         JDfCAKWpRScZiue8yzGpOhcynqDeZdIiQQyo/7f32U2068pt63D7d3qCoQpY56z9sMii
         RuU7s9kJemi9mTBxRp1zfKZ9/itRsGZNfZ9xw8BsQlMo9G4UAKW3gXOaLB/eh8zuUpqt
         Mvt9Gvv+jIDtnFFM9vxw4SxWnLmgYmAngCeQ22BNRdeTqxjgGUloH6MXtXMfJmcqIgzl
         OCzTyCptHaAqcU4RXZRov7XcFK2WF8ddmVGTEh8JRyWuePHR2I7ty3C1Bcs5KnrZ3fQk
         Ob7w==
X-Gm-Message-State: AO0yUKVsyt+ePYXuhgkxJ2ULhce5urnA+FaNL0jwW4ayKXN3r+vp1vrj
        mhIP1l3nNDU3L3ETtzeSefo=
X-Google-Smtp-Source: AK7set95lmiuGKXHxsdQZVMTkvrgvbizW4Z6wpHIxl4NR3tCfQ3bzPRMG7GqShrz2JAV4Ib9oUukpg==
X-Received: by 2002:a17:90b:4a03:b0:236:6dea:87b4 with SMTP id kk3-20020a17090b4a0300b002366dea87b4mr4580538pjb.39.1676969059844;
        Tue, 21 Feb 2023 00:44:19 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id t21-20020a17090b019500b002311ae14a01sm2669907pjs.11.2023.02.21.00.44.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 00:44:19 -0800 (PST)
Message-ID: <3e0f74af-772b-547b-18a9-7ac5c325dd35@gmail.com>
Date:   Tue, 21 Feb 2023 16:44:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH v4 02/12] KVM: VMX: Refactor intel_pmu_set_msr() to align
 with other set_msr() helpers
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230214050757.9623-1-likexu@tencent.com>
 <20230214050757.9623-3-likexu@tencent.com> <Y+6cfen/CpO3/dLO@google.com>
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <Y+6cfen/CpO3/dLO@google.com>
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

On 17/2/2023 5:13 am, Sean Christopherson wrote:
> Gah, I forgot to post a patch that gives intel_pmu_get_msr() the same treatment.
> I'll replace this patch with the combined version below when applying, or will
> post it separately if a v5 is needed.

It's fine for me to apply this new patch first and then apply the remaining
patches with only a tiny rebase effort (tests still remains healthy). More, if
you have more comments on any other patches that need changing after
the radio silence, please roar at me on this version.

> 
> From: Sean Christopherson<seanjc@google.com>
> Date: Thu, 26 Jan 2023 17:08:03 -0800
> Subject: [PATCH] KVM: VMX: Refactor intel_pmu_{g,}set_msr() to align with
>   other helpers
