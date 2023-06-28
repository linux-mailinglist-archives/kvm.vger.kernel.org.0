Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E45FD740C1A
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 10:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235856AbjF1I7K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 04:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236304AbjF1IqD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 04:46:03 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17AD23C32;
        Wed, 28 Jun 2023 01:38:03 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id af79cd13be357-76595a7b111so276581885a.2;
        Wed, 28 Jun 2023 01:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687941482; x=1690533482;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rF6Bz7DMTuAZ4V51W8Y1crpt4EI0YJzN0Fe2wfUOMT8=;
        b=oGPFLURTsHeOhOROYv+AiC7F+iMbvg3TYANxlCnBPFXvTmwlsuOM6GBbWTtmfl5j7U
         XyH4AVUG0jcFYREUgBC2wABHm0uCyNogHWl3oX9fO8Ws2FNywcTJF9Llt1VgqEWf3GeV
         C0K7Sfwd9HruI1eP4dyjHMQQaEoTLVcxl/Lh/S+CB+HSYOZmASpyMcSYoAVW9e4KoTo1
         PJdeuQmTAoC4KA9DwwPQ0ZSmKB7TmFM4Ch+0ZzmHKLNL9DZxgKNvKXhDlv896+rsiS7e
         s1DcglwjLWEN9nHUVV4HFUP95iMoRp22dkqxUOTY8yw8V4U/hWtg3SlG2TSuv+JXfnIC
         PAJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687941482; x=1690533482;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rF6Bz7DMTuAZ4V51W8Y1crpt4EI0YJzN0Fe2wfUOMT8=;
        b=Yvn3Ob7WZeLcFRnvMaJVRzyIPvq7/ctdguvDWHe+k2Cgu/qHIqUw87HXIKOegxZTe3
         W32MEIVwt5uk6Q/gX8KgeJ0sZObeXNIM+LSg/X/fd24n2/JYh9G1Qq0c76Qniaef0EpR
         pQ5tnaa4wB3V/vZy673venyKXkvPkiOS0I7fn6li8f/SrfOpLUXwoL4a1+AG9mGpq8aY
         poNdKFVxZeGa0SxhGOs5/QT3y1bfrKOW0xyRTuYqeS7+dYbTk5cbuMaii7WJYDNE/MIQ
         F/26ijhfy6kZ7Oxj8awIM0d02682A5Ab+zhlotAzB5jjh5CALDxHi8BoFArZgvZulA1F
         S0Pw==
X-Gm-Message-State: AC+VfDyskTjhJl+E/EueeBvLfIptzeRU0xsgQUHSKdKxEiw96JXlL9+0
        9Va1vG6VM9dAsESAuvJJ9K/asR5psqRqmMQSFVo=
X-Google-Smtp-Source: ACHHUZ5eZtzChDLLbyPNhwtIrvlbjAOerwQ9f/NDGCNZrLqXv0jLyNqDQjysli3WHVeuoQQt2uQ9EQ==
X-Received: by 2002:a05:6a20:28a0:b0:125:7a4e:ade6 with SMTP id q32-20020a056a2028a000b001257a4eade6mr13098147pzf.17.1687931455253;
        Tue, 27 Jun 2023 22:50:55 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id s6-20020a170902b18600b001ae44e2f425sm6820599plr.223.2023.06.27.22.50.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jun 2023 22:50:55 -0700 (PDT)
Message-ID: <2db5fe53-c316-2017-c0dc-74190d6ad9ba@gmail.com>
Date:   Wed, 28 Jun 2023 13:50:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [PATCH 3/4] KVM: VMX/pmu: Enable inactive vLBR event in guest LBR
 MSR emulation
Content-Language: en-US
To:     Xiong Zhang <xiong.y.zhang@intel.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        kan.liang@linux.intel.com, zhenyuw@linux.intel.com,
        zhiyuan.lv@intel.com, kvm list <kvm@vger.kernel.org>,
        linux-kernel@vger.kernel.org
References: <20230616113353.45202-1-xiong.y.zhang@intel.com>
 <20230616113353.45202-4-xiong.y.zhang@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20230616113353.45202-4-xiong.y.zhang@intel.com>
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
> vLBR event could be inactive in two case:
> a. host per cpu pinned LBR event occupy LBR when vLBR event is created
> b. vLBR event is preempted by host per cpu pinned LBR event during vm
> exit handler.
> When vLBR event is inactive, guest couldn't access LBR msr, and it is
> forced into error state and is excluded from schedule by perf scheduler.
> So vLBR event couldn't be active through perf scheduler even if host per
> cpu pinned LBR event has released LBR, kvm could enable vLBR event
> proactively, then vLBR event may be active and LBR msr could be passthrough
> into guest.
> 
> Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
> ---
>   arch/x86/kvm/vmx/pmu_intel.c | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 741efe2c497b..5a3ab8c8711b 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -314,7 +314,16 @@ static bool intel_pmu_handle_lbr_msrs_access(struct kvm_vcpu *vcpu,
>   	if (!intel_pmu_is_valid_lbr_msr(vcpu, index))
>   		return false;
>   
> -	if (!lbr_desc->event && intel_pmu_create_guest_lbr_event(vcpu) < 0)
> +	/* vLBR event may be inactive, but physical LBR may be free now.
> +	 * but vLBR event is pinned event, once it is inactive state, perf
> +	 * will force it to error state in merge_sched_in() and exclude it from
> +	 * perf schedule, so even if LBR is free now, vLBR event couldn't be active
> +	 * through perf scheduler and vLBR event could be active through
> +	 * perf_event_enable().
> +	 */
> +	if (lbr_desc->event && (lbr_desc->event->state == PERF_EVENT_STATE_ERROR))
> +		perf_event_enable(lbr_desc->event);

After allowing LBR host/guest coexistence, calls perf_event_enable() for events
here do not always succeed, thus this is not a good call point.

As expected here, any erroneous perf_event is released and reprogrammed in the
kvm_pmu_handle_event(), and the perf status for enabled features are checked
near the atomic_switch_perf_msrs().

> +	else if (!lbr_desc->event && intel_pmu_create_guest_lbr_event(vcpu) < 0)
>   		goto dummy;
>   
>   	/*
