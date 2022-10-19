Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90DE960439D
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 13:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbiJSLpB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 07:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbiJSLoi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 07:44:38 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8315E12744
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 04:24:22 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id bk15so28547075wrb.13
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 04:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qdeaJX55sH31dG5hyU1Da1POz39+LgsgnxASJcUuNZc=;
        b=Yi4ARY+mHRWrHOYRqIUS8DQySqkvWtqiwtwhh7E9WKQCkDoii/ldkCt1pxBSQ90iet
         AGrzztLNZUM+l4PmxNx08+uGgRiRBIGE2JSvGX758UDAETXPNck9U35m4grY91KUN9UP
         k45QoTE2XNWSU4gLLAX87sZBzlpuoRGxwBRnofm9ODUGsB640BThktfeC+gwCn+CtxpP
         suAODdD7XMXVecaUnl61dfrSdqdsk8UxPSNtoxUzqpf0N15ZFSVqDYd+C41R0RYJR4yF
         NwZWQUx/Z84J62y5qXu3poZkNvFBoD1bsqMqkE/BRqDDEqjN7KRwKFoAVhjwizCTeWny
         yfcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qdeaJX55sH31dG5hyU1Da1POz39+LgsgnxASJcUuNZc=;
        b=4eD1WfmWMRoBcm4KvvlFjO0fgOyiaAEtWjgLniJ40ul2i0p63ck5s/rNuIWWonApqm
         G8EyzqEHwnfdJQQTUr8oUO5ix6SrgPVVFGrJS1hcoUWXbhqES/2AAbsiB+eZBg886GNY
         YTDC8DO0R2VqVKy7nm/MV/2qD27fPDgBIroWrhJo7JrFMFF0/tSOfbcope1s0Yv8bszD
         oiGi6g3FZ1AHE0JtWYAGLrPYRoxtbn/PE4G3wGlgO8O5mW4iz0nq/l0Zd9MxRXN47DEd
         2rPkaq5mL6slNVolDxParxi53djIUndpFW/OmEEAb5j/My1nTGIxaE7mcaIYYIcsYunI
         N7vw==
X-Gm-Message-State: ACrzQf0Egey9K5fUOqgWEZBUCK7w89rIkxUZ+C69k7GGGmYVWBmZJ8tu
        4y72pRk1vmGogt6OEwYX1z8n/0Z+6yi7NFdf
X-Google-Smtp-Source: AMsMyM59jhX1vFGcRAtMphxABbSR7dOtpbpeVT53Gy1hZCktN70biH0Ho/oV4Ep+O6Q9RkpLJ44gSg==
X-Received: by 2002:a5d:414c:0:b0:22c:de8a:d233 with SMTP id c12-20020a5d414c000000b0022cde8ad233mr4806983wrq.194.1666176258215;
        Wed, 19 Oct 2022 03:44:18 -0700 (PDT)
Received: from [192.168.1.115] ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id c16-20020a5d4cd0000000b002302dc43d77sm13708102wrt.115.2022.10.19.03.44.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Oct 2022 03:44:17 -0700 (PDT)
Message-ID: <dbcf971a-54c9-7778-06af-16837e8cb1fc@linaro.org>
Date:   Wed, 19 Oct 2022 12:44:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.2
Subject: Re: [PATCH v3 04/15] target/arm: ensure KVM traps set appropriate
 MemTxAttrs
Content-Language: en-US
To:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-devel@nongnu.org
Cc:     qemu-arm@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>
References: <20220927141504.3886314-1-alex.bennee@linaro.org>
 <20220927141504.3886314-5-alex.bennee@linaro.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20220927141504.3886314-5-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/9/22 16:14, Alex Bennée wrote:
> Although most KVM users will use the in-kernel GIC emulation it is
> perfectly possible not to. In this case we need to ensure the
> MemTxAttrs are correctly populated so the GIC can divine the source
> CPU of the operation.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> 
> ---
> v3
>    - new for v3
> ---
>   target/arm/kvm.c | 12 ++++++++----
>   1 file changed, 8 insertions(+), 4 deletions(-)

>   void kvm_arm_vm_state_change(void *opaque, bool running, RunState state)
> @@ -1003,6 +1004,10 @@ int kvm_arch_fixup_msi_route(struct kvm_irq_routing_entry *route,
>       hwaddr xlat, len, doorbell_gpa;
>       MemoryRegionSection mrs;
>       MemoryRegion *mr;
> +    MemTxAttrs attrs = {
> +        .requester_type = MTRT_PCI,
> +        .requester_id = pci_requester_id(dev)
> +    };

Can we add a MEMTXATTRS_PCI() macro similar to MEMTXATTRS_CPU()?

   #define MEMTXATTRS_PCI(pci_dev) ((MemTxAttrs) \
                             {.requester_type = MTRT_PCI, \
                              .requester_id = pci_requester_id(pci_dev)})

So here we can use:

   MemTxAttrs attrs = MEMTXATTRS_PCI(dev);

> @@ -1012,8 +1017,7 @@ int kvm_arch_fixup_msi_route(struct kvm_irq_routing_entry *route,
>   
>       RCU_READ_LOCK_GUARD();
>   
> -    mr = address_space_translate(as, address, &xlat, &len, true,
> -                                 MEMTXATTRS_UNSPECIFIED);
> +    mr = address_space_translate(as, address, &xlat, &len, true, attrs);
>   
>       if (!mr) {
>           return 1;

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

