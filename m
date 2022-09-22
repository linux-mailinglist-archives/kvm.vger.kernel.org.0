Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC6D5E5D0C
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 10:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbiIVIIB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 04:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbiIVIH7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 04:07:59 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0518BB40D9;
        Thu, 22 Sep 2022 01:07:59 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id a29so8535954pfk.5;
        Thu, 22 Sep 2022 01:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=w6ltT1uP5vP/CBS8d2EROS3KCkX2BMDsjshfNpVyQag=;
        b=pxZeD6HvRIQy8BwCK3k7EJX9w9Djy0iY80wmFoDn+r+0Wy4bUEsEubPYqM86VtHULP
         vQsVbXhy92+KbBJpykLUQZwRlKvrhKzFQSOTA/q4JQhs9QsSvG3DF6QuQih5QE2YzSGz
         MiCqkEIkqTNnoMPaTMPNPx8o+14epjGcm1UsnyCw9kzFUuAXcz7sm1XROGQxM2mWnbIT
         Xt6B4JgxOL4OV3I352fjLZHRRxo5WksoEVYD+0Q6I+Ak7eONSewOGuR8eF3X3LdkbcEE
         tcrnbobESb3oxdXciYQXx80CJA4xBgf21RLrZKtYPwTnp96XTBOi8vCYmWAeqCENnB4j
         lT0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=w6ltT1uP5vP/CBS8d2EROS3KCkX2BMDsjshfNpVyQag=;
        b=svtyeLWB40pBfdFJA2eFFUSJmwGyEdvjO5oWYBidMkk9Rfgrg95nX5VhjeQ5l8Q3JA
         R6iEdfeBV70qLjbFogMV33dGD1WrSuAhWBU+WObrmaXANNZiNng5LqkfJMoc8mEYbWHr
         cfvDo0jxrBYMfp/yQV+Ci9CNL40KOEaeMkFUOEooZjzKe324MjYJuwYsyQMsiHIWC9Rp
         yHdykK+KGJQ0WSkKdtIAXjJPRdQCCvuLU6DAjq7PmExyMjk8E8li6zSbg/JJfPXmwFDF
         cXTVCgcqWeOMsPKXGY+y/mL5RoSSy+l00wxSQSCHIN4fDhEuAl7UJh0bSYVJ0ZSuJyAg
         exLA==
X-Gm-Message-State: ACrzQf1nZSyBzNQdKjqm2lN9M5xSy5jXpFVFcsh6UwnL+f+RzC7GcQj9
        db00T9+xxXBVOxcTTyTmWK8=
X-Google-Smtp-Source: AMsMyM7aHLhs9Uh7J/KHuj0dhOcvsXQKmn5lU/B9KcNRqyBGRcqB5wF7tVrBZ2ioxqhzN2BZbatyaA==
X-Received: by 2002:a63:fd0c:0:b0:42b:93a2:af0b with SMTP id d12-20020a63fd0c000000b0042b93a2af0bmr1988098pgh.315.1663834078445;
        Thu, 22 Sep 2022 01:07:58 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id v16-20020a63f210000000b0042a713dd68csm3154256pgh.53.2022.09.22.01.07.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Sep 2022 01:07:57 -0700 (PDT)
Message-ID: <ad2572d0-06b5-7250-31f2-a5efa1048cc0@gmail.com>
Date:   Thu, 22 Sep 2022 16:07:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH RFC 1/1] perf stat: do not fatal if the leader is errored
Content-Language: en-US
To:     Dongli Zhang <dongli.zhang@oracle.com>
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        mingo@redhat.com, acme@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        namhyung@kernel.org, joe.jin@oracle.com,
        linux-perf-users@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>
References: <20220922071017.17398-1-dongli.zhang@oracle.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20220922071017.17398-1-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/9/2022 3:10 pm, Dongli Zhang wrote:
> There are three options to fix the issue.
> 
> 1. Do not expose /sys/bus/event_source/devices/cpu/events/slots to
> userspace so that pmu_have_event(pmu->name, "slots") returns false.

IMO, the guest PMU driver should be fixed
since it misrepresents emulated hardware capabilities in terms of slots.

> 
> 2. Run cpuid at perf userspace and avoid using 'slots' if it is not
> supported in cpuid.
> 
> 3. Do not fatal perf if the leader is failed. Do not create events for an
> evsel if its leader is already failed.

We may also need this since it's easier and more agile to update the perf tool
than the kernel code or KVM emulated capabilities.

> 
> This RFC patch is with the 3rd option. Would you mind suggesting which
> option is better?
