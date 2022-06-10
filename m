Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9022B5458E9
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 02:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238178AbiFJACq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 20:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiFJACm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 20:02:42 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E9882E93D7
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 17:02:41 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id e66so23256123pgc.8
        for <kvm@vger.kernel.org>; Thu, 09 Jun 2022 17:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=INzKqaaBrJ8AYQtvP/Jzrg+Rx35iwfNpk/7/0cwZPX4=;
        b=YiUfD0R8Q3OPrqtx42Yqn7PalrQ4/h8U8ihZBn5QfY5obIH3YSCPrSW4RYQD1JCNsC
         17hg5EcPmlem+OgMPvqyKyYspNdEqdfLjPOXRxUwDUtdzG4O1yHorrpaqX4Gh9xfwUBg
         El70w5yqZbkxab5jAXDciFD2XSQgH1pCxUPa9PRo4YnY9Hh6G/VWH/leMZbdrsMkP6bJ
         orxmvkHetvuKzfXS3UqdR9V/eslxeXFGIag9V03ceeXUwTgW1AJh7uo5nDcB2Lp/hddk
         uP0Acl6t+/syJQ2xJpMK2YaMdouvJW4HF4v97nTdpU/XHg9w4jIiAbkaxIFiDuyPkMn+
         33MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=INzKqaaBrJ8AYQtvP/Jzrg+Rx35iwfNpk/7/0cwZPX4=;
        b=qfLG7mFC6QwXWsm94UjEdSzyULSqmwTwRVf38O/IEcrk8P+RMoTwOm3N+C6JjFDnd8
         95QnoZoKEP8Vl94rZlhMFaEkuKoSdp9WRYZTNr4hxZGiv7e2NG6X4e/eIMLzPnj/HwiA
         9A+9Yl07tmhliXkZ49kslPlYicPnp2EQaEG6FMgYgJ313U8D7LXiqz+507MmCPIb/RYa
         tAomaPjRB8o6yeB5AYZyTyGhXZKU1y60qMUfGTplG68ur58sziUPOHaY1O7ShbqGMHqS
         cx//W6OW8VtNO/3Acdlk6dnPUpdAtrKSLQpAbeh1wz8qXq2gSDwo4WwFqn8qux0b3Ukh
         tlnA==
X-Gm-Message-State: AOAM532mzRy3ECawtErz4bhlmMuY6bX0uRRnATwvZJXsu96g4qQuG9vU
        3Y5cJlnsV8tuCh6mtZRNHzM=
X-Google-Smtp-Source: ABdhPJzX7RPU6GG2o/qQxrtJ43VS8F3IRCrpQ0mNTZgVwmt9gUk8LdYeCwLD4IMDoDz77QEwkCEkxg==
X-Received: by 2002:a05:6a00:2485:b0:51c:4ee0:b899 with SMTP id c5-20020a056a00248500b0051c4ee0b899mr13032083pfv.46.1654819361014;
        Thu, 09 Jun 2022 17:02:41 -0700 (PDT)
Received: from [192.168.255.10] ([203.205.141.26])
        by smtp.gmail.com with ESMTPSA id z14-20020a170903018e00b0016368840c41sm17661821plg.14.2022.06.09.17.02.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jun 2022 17:02:40 -0700 (PDT)
Message-ID: <7423da17-1c36-8d37-3e1d-5b51b4d7c370@gmail.com>
Date:   Fri, 10 Jun 2022 08:02:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [kvm-unit-tests PATCH 0/3] Fix up test failures induced by
 !enable_pmu
Content-Language: en-US
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org,
        "Paolo Bonzini - Distinguished Engineer (kernel-recipes.org) (KVM HoF)" 
        <pbonzini@redhat.com>
References: <20220609083916.36658-1-weijiang.yang@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20220609083916.36658-1-weijiang.yang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/6/2022 4:39 pm, Yang Weijiang wrote:
> When pmu is disabled via enable_pmu=0, some perf related MSRs or instructions
> are not available to VM, this results into some test failures, fix them in
> this series.

How about applying it in the x86/unittests.cfg:

	check = /sys/module/kvm/parameters/enable_pmu=N

and add another pmu_disable.flat to cover all those unavailable expectations ?
