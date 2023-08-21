Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5DE78248B
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 09:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233726AbjHUHjC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 03:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbjHUHjB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 03:39:01 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71EF3BB
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 00:38:59 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 41be03b00d2f7-5694a117254so2138648a12.0
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 00:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692603539; x=1693208339;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=doHg+Vyx7nwssjszb1XMnrd9iEHH3nZUSSkqqJtWjLE=;
        b=AEJWA+MR7POH4MGVeSR1Rsdj//f2lneDyeVYAviZ/sBOdfKABimRmmJtkdV0MdqS1R
         lZxVI7/CfmjKlFVJirbczj5jhDIAZ7UkktoG3LpEazbNNbY0uG1ba2MLs/sei5HHaOZd
         NLVwyMowKD8ZfqFd2yGD3RJMjbKoqzGQq0tGmiihNrozaCdCGKgNLUAZ8UeQ3LXtlnk5
         G+zW9H1B8W5BMCDK7WPjuCpBYM3yffj1QPWgOgY2LMsSzh4EgOZ0KZVFhJkq8G+aG+T9
         /6ckoW+UjZ++eMxR3zLpyilsa9g9Huae1KKTWsyNDKlO28vtXZzW0csq6r0t+OR2Zjxn
         YalQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692603539; x=1693208339;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=doHg+Vyx7nwssjszb1XMnrd9iEHH3nZUSSkqqJtWjLE=;
        b=TU4VQRyLgmEZ38GKmtRI4Q2n0OPpWgCeAIGMjOjyJ7uiyF1vDl+1yc+8NKBkvaxfAK
         ZPF9fUylCQaAaApYKyCLTc6kvowjr42nmUfTaHOwoxY7j80Xo1jU+4sNLPRWGvflMI+E
         A5xX++cl3Ed7NPHutmMTYHxtdHWey6zVqBmDn6T9mALhpc6dDiY7sycIAhVcLyW9e9H+
         aqaVUHCJWEHcNl4AFFhBRYGM8clEsa3hL+ZCDBiu6Wjq+T7KDAb7eNoEIVdSCadl4noA
         9E5bF0jdumRETAn1wFiG+KdQGMuwYDvG1b/TwnGLUBU+7OV4zIyub/3YyBw62B0N7UhA
         er3w==
X-Gm-Message-State: AOJu0YyVj0yeOesqpLWS5HICEN554If9CRmyqT/3HvOOiQhL+1E4PQBl
        WFbawdrLR5Tp5KPOK50vBpk=
X-Google-Smtp-Source: AGHT+IE7YmAfSxk2NVjwoAYE7hjk9KQI8oFK60kEemwoypVNIefEidrbPxv6WzNsv42x67xnZYXNWA==
X-Received: by 2002:a05:6a20:8f07:b0:138:2fb8:6b42 with SMTP id b7-20020a056a208f0700b001382fb86b42mr9006786pzk.14.1692603538845;
        Mon, 21 Aug 2023 00:38:58 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id q6-20020a170902a3c600b001bf095dfb76sm6432886plb.237.2023.08.21.00.38.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Aug 2023 00:38:58 -0700 (PDT)
Message-ID: <10e9dfa4-8c11-b374-f4ed-34ea53f7bd11@gmail.com>
Date:   Mon, 21 Aug 2023 15:38:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH v3] Documentation: KVM: Add vPMU implementaion and gap
 document
Content-Language: en-US
To:     Xiong Zhang <xiong.y.zhang@intel.com>
Cc:     seanjc@google.com, weijiang.yang@intel.com,
        dapeng1.mi@linux.intel.com, zhiyuan.lv@intel.com,
        zhenyu.z.wang@intel.com, kan.liang@intel.com, kvm@vger.kernel.org
References: <20230810054518.329117-1-xiong.y.zhang@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20230810054518.329117-1-xiong.y.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/8/2023 1:45 pm, Xiong Zhang wrote:
> +4. LBR Virtualization
> +=====================
> +
> +4.1. Overview
> +-------------
> +
> +The guest LBR driver would access the LBR MSR (including IA32_DEBUGCTLMSR
> +and records MSRs) as host does once KVM/QEMU export vcpu's LBR capability
> +into guest,  The first guest access on LBR related MSRs is always
> +interceptable. The KVM trap would create a vLBR perf event which enables

intercepted.

> +the callstack mode and none of the hardware counters are assigned. The

the LBR callstack mode.

> +host perf would enable and schedule this event as usual.

in the absence of contention.

> +
> +When vLBR event is scheduled by host perf scheduler and is active, host
> +LBR MSRs are owned by guest and are pass-through into guest, guest will
> +access them without VM Exit. However, if another host LBR event comes in
> +and takes over the LBR facility, the vLBR event will be in error state,

Doesn't LBR event have a scheduling priority ?

> +and the guest following access to the LBR MSRs will be trapped and
> +meaningless.

One description missing here is whether KVM retries to create LBR events 
frequently ?

> +
> +As kvm perf event, vLBR event will be released when guest doesn't access
> +LBR-related MSRs within a scheduling time slice and guest unset LBR

Not all LBR-related MSRs, but the DEBUGCTLMSR_LBR bit at now.

> +enable bit, then the pass-through state of the LBR MSRs will be canceled.
> +
> +4.2. Host and Guest LBR contention
> +----------------------------------
> +
> +vLBR event is a per-process pinned event, its priority is second. vLBR
> +event together with host other LBR event to contend LBR resource,
> +according to perf scheduler rule, when vLBR event is active, it can be
> +preempted by host per-cpu pinned LBR event, or it can preempt host
> +flexible LBR event. Such preemption can be temporarily prohibited
> +through disabling host IRQ as perf scheduler uses IPI to change LBR owner.

Those same descriptions can be shared with counter contention.

> +
> +The following results are expected when host and guest LBR event coexist:
> +1) If host per cpu pinned LBR event is active when vm starts, the guest
> +vLBR event can not preempt the LBR resource, so the guest can not use
> +LBR.

This is not the same as the current implementation. One could argue that this
is expected, but the current state of the system must be described first.

> +2). If host flexible LBR events are active when vm starts, guest vLBR
> +event can preempt LBR, so the guest can use LBR.
> +3). If host per cpu pinned LBR event becomes enabled when guest vLBR
> +event is active, the guest vLBR event will lose LBR and the guest can
> +not use LBR anymore.
> +4). If host flexible LBR event becomes enabled when guest vLBR event is
> +active, the guest vLBR event keeps LBR, the guest can still use LBR.
> +5). If host per cpu pinned LBR event turns off when guest vLBR event is
> +not active, guest vLBR event can be active and own LBR, the guest can use
> +LBR.
> +
> +4.3. vLBR Arch Gaps
> +-------------------
> +
> +Like vPMU Arch Gap, vLBR event can be preempted by host Per cpu pinned
> +event at any time, or vLBR event is not active at creation, but guest
> +can not notice this, so the guest will get meaningless value when the
> +vLBR event is not active.

Another gap is live-migration support for guest LBR.
