Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75077653CA2
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 08:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234779AbiLVHlA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 02:41:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbiLVHk4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 02:40:56 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F22961AA33
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 23:40:55 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id 4so1267803plj.3
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 23:40:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p0A2zlRheW5VV+SLEDgjTgu3tkreNMcXz11UJu/SFTk=;
        b=cUwCTVhNIOTTtYrLTZXI3pc2lJvKNj3B4SdVt5RL8utgynE5o4Hp2cBTh8gEiXADOw
         2Cu3lYR5aKZmbcnUfH6EfjhL5FYOWyrgxxlwoxKkamKALnJgHlgucjb4eooJLw76aztg
         YuUWXAHTYlhEg8i1xx8dgu6ecz0Uezhk4/uRxgqncksOK8twbRRdtmVwx+dh56uWYpkQ
         63wHesaQ4eRdcm5pHz49HGe0jpLCa0yIfk1lKapXc9MlHNEesE4UwjPLL5BTKZ4NVjSl
         pY2JvYPIKIi0c7XipgiMukaBXsuue9fprmDCZBz8szu8COlSoWvH0yGLLZn8DYpR9GT+
         ThEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p0A2zlRheW5VV+SLEDgjTgu3tkreNMcXz11UJu/SFTk=;
        b=eodwWTRbfHm51Og08ahvXB1tvfVxSavn9Q+e/2fKzhfRaOIDMnhSlS+jY4jXj5GY93
         AOgLWIFCxqD0EiNh/TchZKcw+/Z4NxpA7t1O/mP8dWBPln5LYsj9AamELqvMunDy5HN+
         lUBma/ififkBG5aeH9cbppr/bX/fq2xQnNT5pC8couuUVx8/BWnp+xacaEZ2euvlzGvU
         7wwcWz19hCHl7wG9oNnY0Dy982tbAkjFkchPO+bp/sF9EE4SoPE5PHSe2SNi1jBxU/87
         UkLuRk1eKzXIIO4yqHYcGEyCov4PcubKJJgnF4C6WVRhtD0r+l6KP6hXPLb8gPTF0sKR
         hyeQ==
X-Gm-Message-State: AFqh2kq6RDWGTVHBvw2X9vThCe0Z8hG6Lzo0kKigNpuHlUJqFcUlZ+zR
        wLyTDBobHcaua9yYnji+kKPwi9HW9SamX5VG
X-Google-Smtp-Source: AMrXdXuwThIbx7Fe6AujaPclN6tjQOQT6UT1ho4DSI7k2qjDFawfGb7Ho9f4c/wW8HbPeFIq+zr4/A==
X-Received: by 2002:a17:902:d887:b0:189:c57c:9a18 with SMTP id b7-20020a170902d88700b00189c57c9a18mr4573255plz.66.1671694855406;
        Wed, 21 Dec 2022 23:40:55 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id m9-20020a170902db0900b00189d4c666c8sm12704354plx.153.2022.12.21.23.40.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Dec 2022 23:40:54 -0800 (PST)
Message-ID: <cd594bd5-8f71-7d49-779a-2a19a99a1e5d@gmail.com>
Date:   Thu, 22 Dec 2022 15:40:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.0
Subject: Re: [PATCH v8 4/7] kvm: x86/pmu: Introduce masked events to the pmu
 event filter
Content-Language: en-US
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        kvm list <kvm@vger.kernel.org>
References: <20221220161236.555143-1-aaronlewis@google.com>
 <20221220161236.555143-5-aaronlewis@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20221220161236.555143-5-aaronlewis@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/12/2022 12:12 am, Aaron Lewis wrote:
> When building a list of filter events, it can sometimes be a challenge
> to fit all the events needed to adequately restrict the guest into the
> limited space available in the pmu event filter.  This stems from the
> fact that the pmu event filter requires each event (i.e. event select +
> unit mask) be listed, when the intention might be to restrict the
> event select all together, regardless of it's unit mask.  Instead of

This memory/cpu saving requirement is quite reasonable. To clarify,

PMU events with different unit masks for the same event select doesn't
point to the same or pipeline-associated microarchitectural component.

In practice, there will be a lot of cases where the "exclusion bit" is required.
That's one of the reasons I was asking about real use cases in another thread.

> increasing the number of filter events in the pmu event filter, add a
> new encoding that is able to do a more generalized match on the unit mask.
> 
> Introduce masked events as another encoding the pmu event filter
> understands.  Masked events has the fields: mask, match, and exclude.
> When filtering based on these events, the mask is applied to the guest's
> unit mask to see if it matches the match value (i.e. umask & mask ==
> match).  The exclude bit can then be used to exclude events from that
> match.  E.g. for a given event select, if it's easier to say which unit
> mask values shouldn't be filtered, a masked event can be set up to match
> all possible unit mask values, then another masked event can be set up to
> match the unit mask values that shouldn't be filtered.
> 
> Userspace can query to see if this feature exists by looking for the
> capability, KVM_CAP_PMU_EVENT_MASKED_EVENTS.
> 
> This feature is enabled by setting the flags field in the pmu event
> filter to KVM_PMU_EVENT_FLAG_MASKED_EVENTS.
> 
> Events can be encoded by using KVM_PMU_ENCODE_MASKED_ENTRY().
> 
> It is an error to have a bit set outside the valid bits for a masked
> event, and calls to KVM_SET_PMU_EVENT_FILTER will return -EINVAL in
> such cases, including the high bits of the event select (35:32) if
> called on Intel.

Some users want to count Intel TSX events and their VM instances needs:

#define HSW_IN_TX					(1ULL << 32)
#define HSW_IN_TX_CHECKPOINTED				(1ULL << 33)

> 
> With these updates the filter matching code has been updated to match on
> a common event.  Masked events were flexible enough to handle both event
> types, so they were used as the common event.  This changes how guest
> events get filtered because regardless of the type of event used in the
> uAPI, they will be converted to masked events.  Because of this there
> could be a slight performance hit because instead of matching the filter

Bonus, if this performance loss is quantified, we could make a side-by-side
comparison of alternative solutions, considering wasting memory seems to
be a habit of many kernel developers.

> event with a lookup on event select + unit mask, it does a lookup on event
> select then walks the unit masks to find the match.  This shouldn't be a
> big problem because I would expect the set of common event selects to be

A quick rough statistic about Intel PMU based on 
https://github.com/intel/perfmon.git:
our filtering mechanism needs to consider 388 different EventCode and 183 different
UMask, prioritizing filtering event_select will instead bring more entries.

> small, and if they aren't the set can likely be reduced by using masked
> events to generalize the unit mask.  Using one type of event when
> filtering guest events allows for a common code path to be used.
> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>   Documentation/virt/kvm/api.rst  |  77 +++++++++++--
>   arch/x86/include/asm/kvm_host.h |  14 ++-
>   arch/x86/include/uapi/asm/kvm.h |  29 +++++
>   arch/x86/kvm/pmu.c              | 197 +++++++++++++++++++++++++++-----
>   arch/x86/kvm/x86.c              |   1 +
>   include/uapi/linux/kvm.h        |   1 +
>   6 files changed, 281 insertions(+), 38 deletions(-)
> 

...

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 312aea1854ae..d2023076f363 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4401,6 +4401,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>    	case KVM_CAP_SPLIT_IRQCHIP:
>   	case KVM_CAP_IMMEDIATE_EXIT:
>   	case KVM_CAP_PMU_EVENT_FILTER:
> +	case KVM_CAP_PMU_EVENT_MASKED_EVENTS:

How about reusing KVM_CAP_PMU_CAPABILITY to advertise this new cap ?

>   	case KVM_CAP_GET_MSR_FEATURES:
>   	case KVM_CAP_MSR_PLATFORM_INFO:
>   	case KVM_CAP_EXCEPTION_PAYLOAD:
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 20522d4ba1e0..0b16b9ed3b23 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1175,6 +1175,7 @@ struct kvm_ppc_resize_hpt {
>   #define KVM_CAP_DIRTY_LOG_RING_ACQ_REL 223
>   #define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 224
>   #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
> +#define KVM_CAP_PMU_EVENT_MASKED_EVENTS 226
>   
>   #ifdef KVM_CAP_IRQ_ROUTING
>   
