Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F26A16F22AF
	for <lists+kvm@lfdr.de>; Sat, 29 Apr 2023 05:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbjD2D2Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 23:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbjD2D2W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 23:28:22 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F75A1FEA
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 20:28:21 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-63b733fd00bso547604b3a.0
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 20:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682738901; x=1685330901;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OWGwac+SXzvlLnjehyPUtCsPkIj23kaKMRkgE6dwy/w=;
        b=DaKNRP3LNYkQKS+9UsE5F/Mx49srp7YQmcZPThP6exlkVjsPTucCTUX/Pt5V74ZJtl
         oNKj/nqrMM7M3qU6U0HFneLpLrq9kiM26kymnYLRvVqSCfDFXK0lR1Yg9QJyWP8hqtgr
         wn22fG+dXzfy0OcADCmvMr9c5d62rQ4XO2LqYz/PXvfz3KqomO2Q9eKRzz+hnyFbs8pG
         AbyeZrBJ3U5gf3HUrspXyj/Ix9l4UZSV8eYGyN2LYk8RWM6qKkLf/vG+SuHHlk5nNnT2
         wJnHpaotpmq53JYLiYvLc+O+QfVBadgFuS97Fd3E7K/JrpPeFeahbksvDJGM30bpzp6W
         OAzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682738901; x=1685330901;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OWGwac+SXzvlLnjehyPUtCsPkIj23kaKMRkgE6dwy/w=;
        b=RmDuNuASJbIzJhbVh4wrZ72nqu40ijNKUoQrSjTOrZfRQGF/SVEimlP4Z9Nlv6AXyf
         bvuYYhKhJrIs819EWY2378jaV1uMWl3Lz9eylPP0xU+cKEPJHhqPgnPI2DMHyqj/a60g
         mDbioVZUeUD9gXnC9+VBEoKjcB1Ai8yfYoTrJa6K1125kmF0PRItvsPMRnSh5vyHsBJx
         uf/Sdj/4LtxIJMTLTqPMpGmPwua9EYyWNVps45fUe1G0Tx+3Y2O37HzRgN1VW8kmPbvX
         vjF4tsFG5X4ke4JMDyFHKw4hgM6RsKsPC9HmpaLSZ6NihK5X0SJlj5bIPiSxwY6ZWe0S
         BJdQ==
X-Gm-Message-State: AC+VfDwuawB5IwiHFqlw887zr/eEIAhXfhrf4H+MeayjTEnIUcd37qht
        Dwyl0aTJnS8nfty4jWiE8ZnLMjnJeeQ00w==
X-Google-Smtp-Source: ACHHUZ696++ydJYsPEEwUSfC7ag7YxXIVG2VLyDrYBb7bveVj1/6rU4pet2+S84utjp5iXbJn6EsqQ==
X-Received: by 2002:a05:6a00:2451:b0:627:f0e1:4fbf with SMTP id d17-20020a056a00245100b00627f0e14fbfmr10205476pfj.33.1682738900554;
        Fri, 28 Apr 2023 20:28:20 -0700 (PDT)
Received: from [172.27.232.27] (ec2-16-163-40-128.ap-east-1.compute.amazonaws.com. [16.163.40.128])
        by smtp.gmail.com with ESMTPSA id h4-20020a056a00170400b00640f01e130fsm7502928pfc.124.2023.04.28.20.28.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Apr 2023 20:28:20 -0700 (PDT)
Message-ID: <a9f97d08-8a2f-668b-201a-87c152b3d6e0@gmail.com>
Date:   Sat, 29 Apr 2023 11:28:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: Latency issues inside KVM.
To:     zhuangel570 <zhuangel570@gmail.com>, kvm@vger.kernel.org
References: <CANZk6aSv5ta3emitOfWKxaB-JvURBVu-sXqFnCz9PKXhqjbV9w@mail.gmail.com>
Content-Language: en-US
From:   Robert Hoo <robert.hoo.linux@gmail.com>
In-Reply-To: <CANZk6aSv5ta3emitOfWKxaB-JvURBVu-sXqFnCz9PKXhqjbV9w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/27/2023 8:38 PM, zhuangel570 wrote:
> Hi
> 
> We found some latency issue in high-density and high-concurrency scenarios, we
> are using cloud hypervisor as vmm for lightweight VM, using VIRTIO net and
> block for VM. In our test, we got about 50ms to 100ms+ latency in creating VM
> and register irqfd, after trace with funclatency (a tool of bcc-tools,
> https://github.com/iovisor/bcc), we found the latency introduced by following
> functions:
> 
> - irq_bypass_register_consumer introduce more than 60ms per VM.
>    This function was called when registering irqfd, the function will register
>    irqfd as consumer to irqbypass, wait for connecting from irqbypass producers,
>    like VFIO or VDPA. In our test, one irqfd register will get about 4ms
>    latency, and 5 devices with total 16 irqfd will introduce more than 60ms
>    latency.
> 
> - kvm_vm_create_worker_thread introduce tail latency more than 100ms.
>    This function was called when create "kvm-nx-lpage-recovery" kthread when
>    create a new VM, this patch was introduced to recovery large page to relief
>    performance loss caused by software mitigation of ITLB_MULTIHIT, see
>    b8e8c8303ff2 ("kvm: mmu: ITLB_MULTIHIT mitigation") and 1aa9b9572b10
>    ("kvm: x86: mmu: Recovery of shattered NX large pages").
> 
Yes, this kthread is for NX-HugePage feature and NX-HugePage in turn is to 
SW mitigate itlb-multihit issue.
However, HW level mitigation has been available for quite a while, you can 
check "/sys/devices/system/cpu/vulnerabilities/itlb_multihit" for your 
system's mitigation status.
I believe most recent Intel CPUs have this HW mitigated (check 
MSR_ARCH_CAPABILITIES::IF_PSCHANGE_MC_NO), let alone non-Intel CPUs.
But, the kvm_vm_create_worker_thread is still created anyway, nonsense I 
think. I previously had a internal patch getting rid of it but didn't get a 
chance to send out.

As more and more old CPUs retires, I think NX-HugePage code will become 
more and more minority code path/situation, and be refactored out 
eventually one day.
