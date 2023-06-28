Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4EB740C19
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 10:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235802AbjF1I6x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 04:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236419AbjF1IrD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 04:47:03 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A1E035A1;
        Wed, 28 Jun 2023 01:39:22 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id af79cd13be357-76547539718so399726985a.2;
        Wed, 28 Jun 2023 01:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687941561; x=1690533561;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ScB+ZZist0LJhvo4aFrlQCLs/vxCp+MpbUQwDLajxRw=;
        b=Sc7YXP1JbPv0mFwQfYm4HOjIkcuGaoYrspov0HZUKETfxRnhgij7IHOEJ7ZTntjbWw
         sSr9sTImr/TpA+q824k92W5AviwhWW8+j6ZLZ2DdTB/kcZ5VlKK3w/lWGDAFuq+zDZBt
         C87XQTvC6OzXmgDF80R7ztwPknaCOhv0crl+e5w0IloO+acNL8v1raxkWtGKJOtayxau
         tT/ZIJ2jSWi7bN8sG2Luq+RvhwVUVU1bnhM5q9DE3VZws8e0EaCULqaA+iq4mVkGsC5K
         n/jjMqN0ZQh3kU7lxsCS2iFjKoh2UksEWxiukfgjl81oPJI5di7GVpuT2heRq3V536kD
         Vj0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687941561; x=1690533561;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ScB+ZZist0LJhvo4aFrlQCLs/vxCp+MpbUQwDLajxRw=;
        b=gqtT5jGaLiCse2zAZ/o+SGYBmQ3A6Y9ImKo3s3qEwoeeP0TvqHrnVCNzE6n9ZZYCJ1
         KMYouJbk19lYjTo+vlEp9QBWbuGICqBRrVUsNCZ8DeV7SjGGmieGoWRAAvW5WuIqFx24
         n9hM3QSC8AVS6/0UmzBT4uK77wItoG+AyyQ2nwQ0M5rrpTv8dzVdKleSVR/mWtS5cIk3
         C8bMLdUmTWecIiVUcHv3mo/W7nWJmffvrLCzwiUazFczZhiLdo74WG0wvnArGLO1Yn3f
         xUEP2lV3hKKA8kQaj4xUwbD1Xf+h3N12gfTFeAkWNGot9oxPhovAV0T8odoUhCmyP5p0
         XoGg==
X-Gm-Message-State: AC+VfDzNC834a2codn/1HnVU2cyVJjX5gTkHWM0cIJr5mJqbbGyYea1j
        i3TefXMGChwmJuYgQruWfoF7Iaz/9JJ/iIUr/eU=
X-Google-Smtp-Source: ACHHUZ4lVPX+j5H7tZJ6oXHoKfmzWDLYFEUeYz33ThHTbUCa2xbvIJmb2a0J/CVmsCUQZSEw4UUV6Q==
X-Received: by 2002:a17:902:e746:b0:1b7:f3a4:a6dc with SMTP id p6-20020a170902e74600b001b7f3a4a6dcmr11012625plf.21.1687926325524;
        Tue, 27 Jun 2023 21:25:25 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id iw19-20020a170903045300b001b0603829a0sm862107plb.199.2023.06.27.21.25.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jun 2023 21:25:24 -0700 (PDT)
Message-ID: <ca71fc1f-280e-19ff-ce0f-8befa29f45cd@gmail.com>
Date:   Wed, 28 Jun 2023 12:25:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [PATCH 1/4] perf/x86/intel: Get shared reg constraints first for
 vLBR
Content-Language: en-US
To:     Xiong Zhang <xiong.y.zhang@intel.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, peterz@infradead.org,
        kan.liang@linux.intel.com, zhenyuw@linux.intel.com,
        zhiyuan.lv@intel.com, kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20230616113353.45202-1-xiong.y.zhang@intel.com>
 <20230616113353.45202-2-xiong.y.zhang@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20230616113353.45202-2-xiong.y.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/6/2023 7:33 pm, Xiong Zhang wrote:
> When host has per cpu pinned LBR event and guest use LBR also, host
> couldn't get correct LBR data, as the physical LBR is preempted by
> guest.
> 
> The rule for multi events sharing LBR is defined in
> __intel_shared_reg_get_constraints(), but guest vLBR event skips this
> function, so even if host has per cpu pinned LBR event, guest vLBR event
> could get constraints successfully and make vlbr_exclude_host returns true,
> finally host couldn't enable LBR in intel_pmu_lbr_enable_all().

Although it goes against the "per cpu pinned LBR event" priority expectation,
the order is intentionally specified. For two reasons:

- vlbr uses the fake event mechanism in its implementation, a presence similar to
   BTS event, thus the question here is whether we can get the per cpu pinned BTS
   event to work as expected;

- this change should not be applied first before KVM has done a good job
   of making guest lbr and other lbr events coexist correctly;

In treating vlbr event as an ordinary perf_event behind a guest counter that
is expected to comply equally with the scheduling rules of host perf, the first
thing we need to address is how a guest counter should continue to function
during the time when the backend event is preempted by a higher priority one.

> 
> This commit move intel_vlbr_constraints() behind
> intel_shared_regs_constraints(), guest vLBR event will use LBR also and it
> should get LBR resource through intel_shared_regs_constraints().
> 
> Fixes: 097e4311cda9 ("perf/x86: Add constraint to create guest LBR event without hw counter")
> Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
> ---
>   arch/x86/events/intel/core.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
> index 6fd3cd97a6ac..2e27a69e9725 100644
> --- a/arch/x86/events/intel/core.c
> +++ b/arch/x86/events/intel/core.c
> @@ -3347,15 +3347,15 @@ __intel_get_event_constraints(struct cpu_hw_events *cpuc, int idx,
>   {
>   	struct event_constraint *c;
>   
> -	c = intel_vlbr_constraints(event);
> +	c = intel_bts_constraints(event);
>   	if (c)
>   		return c;
>   
> -	c = intel_bts_constraints(event);
> +	c = intel_shared_regs_constraints(cpuc, event);
>   	if (c)
>   		return c;
>   
> -	c = intel_shared_regs_constraints(cpuc, event);
> +	c = intel_vlbr_constraints(event);
>   	if (c)
>   		return c;
>   
