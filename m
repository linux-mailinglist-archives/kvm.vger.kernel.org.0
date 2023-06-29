Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7736B7426A0
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 14:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbjF2Miq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 08:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbjF2Mio (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 08:38:44 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62005297B
        for <kvm@vger.kernel.org>; Thu, 29 Jun 2023 05:38:43 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id 2adb3069b0e04-4f76a0a19d4so940524e87.2
        for <kvm@vger.kernel.org>; Thu, 29 Jun 2023 05:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1688042321; x=1690634321;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hxfhJxOdFDvYU3qX7hvs8tBo8Gmcl1dQu4NFgo5HPEU=;
        b=rGRM8DCpGxMdjMclSO/y9NELDVEbR56kDAMryk/iLX8KknlyUbwkX18E0exGVUkNV1
         x89tvo2xhDeB0GpklKnNGgUPQBLaW69FmFcc65ezE8DFo27sg0nD1scbtcZ561XwkD14
         h7C7dO6i5QQPJq2NbhposzInyEgZpi6Bdz7F1n9BeubNhzTSgtblrNSml7Dg+pwJlmv7
         V+HVb+IxQl1ZyTBTiPp0m9S86Mw/RKlhni7OF0zMt8/Qsfl1GqN+HP8i0Q8DncQ88r36
         iwNUYyCp/G9tpQEMuX6TE70AJ4+stZZU9oh/Fxvsdg+vHMwkaVnRTnnIRzFSrZalcN+W
         lueQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688042321; x=1690634321;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hxfhJxOdFDvYU3qX7hvs8tBo8Gmcl1dQu4NFgo5HPEU=;
        b=CbEvqCsATZVkcSGro3iF1s1/8Bw+/SQe9zlsG4+Z6j5WKpyMWm1TBQg+vTBqe3as/Q
         leEM75H0uiwKWDLLDucBT3JHCQ0SFKX7lc4mGp53zX+AgzF8cvI+jJ72Xa0+AcexoCNh
         30H3kP7xMVnwkwMMm00Wj5/m6kItBC5+KFPab+kSx8ozjkPJjcTpG5jrdjb0oQeSdadu
         a2c++tJS2poYIcMYTHYY5bk8eqzobcZrnkJbSjyamnazdxr+Dt+iQzUFlbNOG6KWhKK6
         1f/8FfQ8Cx+7rXw1Y7qch6QwlDNMYBbpFiyhJO2Frt/4qbkJaw7C0fRJiRGtiVMHV4ca
         6xKQ==
X-Gm-Message-State: AC+VfDzE6TRXsisQSo5/f2NFTEJ/iDAn8cAvnoZDLdSfkf27nl1KKWQ4
        L24HInlp5nBzjs8xYi2TX8gMHQ==
X-Google-Smtp-Source: ACHHUZ5bzGhLt/f+37MH8rCgEFkzwps6PmngkTB9lvXvXjml/ZkEIl0JLLRgYODeXTlVkcU7aBhcJg==
X-Received: by 2002:a05:6512:1319:b0:4f8:6625:f2ca with SMTP id x25-20020a056512131900b004f86625f2camr14962047lfu.61.1688042321634;
        Thu, 29 Jun 2023 05:38:41 -0700 (PDT)
Received: from [192.168.69.115] ([176.176.166.242])
        by smtp.gmail.com with ESMTPSA id s11-20020a5d69cb000000b00313f07ccca4sm11605117wrw.117.2023.06.29.05.38.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jun 2023 05:38:41 -0700 (PDT)
Message-ID: <0d527f32-4e69-55a8-20b8-e357292f64a3@linaro.org>
Date:   Thu, 29 Jun 2023 14:38:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [RFC PATCH 0/2] accel/kvm: Extract 'sysemu/kvm_irq.h' from
 'sysemu/kvm.h'
Content-Language: en-US
To:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     qemu-arm@nongnu.org, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        qemu-ppc@nongnu.org
References: <20230405163001.98573-1-philmd@linaro.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230405163001.98573-1-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping?

On 5/4/23 18:29, Philippe Mathieu-Daudé wrote:
> Posted individually because it is modifying a lot of files.
> 
> RFC: this might not be the best API cut, but "sysemu/kvm.h"
>       is a mixed bag hard to sort...
> 
> Based-on: <20230405160454.97436-1-philmd@linaro.org>

(not based-on actually)

> Philippe Mathieu-Daudé (2):
>    accel/kvm: Extract 'sysemu/kvm_irq.h' from 'sysemu/kvm.h'
>    accel/kvm: Declare kvm_arch_irqchip_create() in 'sysemu/kvm_int.h'
> 
>   include/sysemu/kvm.h           |  88 -----------------------------
>   include/sysemu/kvm_int.h       |  13 +++++
>   include/sysemu/kvm_irq.h       | 100 +++++++++++++++++++++++++++++++++
>   target/i386/kvm/kvm_i386.h     |   1 +
>   accel/kvm/kvm-all.c            |   2 +
>   accel/stubs/kvm-stub.c         |   1 +
>   hw/arm/virt.c                  |   1 +
>   hw/cpu/a15mpcore.c             |   1 +
>   hw/hyperv/hyperv.c             |   1 +
>   hw/i386/intel_iommu.c          |   1 +
>   hw/i386/kvm/apic.c             |   1 +
>   hw/i386/kvm/i8259.c            |   1 +
>   hw/i386/kvm/ioapic.c           |   1 +
>   hw/i386/kvmvapic.c             |   1 +
>   hw/i386/pc.c                   |   1 +
>   hw/i386/x86-iommu.c            |   1 +
>   hw/intc/arm_gic.c              |   1 +
>   hw/intc/arm_gic_common.c       |   1 +
>   hw/intc/arm_gic_kvm.c          |   1 +
>   hw/intc/arm_gicv3_common.c     |   1 +
>   hw/intc/arm_gicv3_its_common.c |   1 +
>   hw/intc/arm_gicv3_kvm.c        |   1 +
>   hw/intc/ioapic.c               |   1 +
>   hw/intc/openpic_kvm.c          |   1 +
>   hw/intc/s390_flic_kvm.c        |   1 +
>   hw/intc/spapr_xive_kvm.c       |   1 +
>   hw/intc/xics.c                 |   1 +
>   hw/intc/xics_kvm.c             |   1 +
>   hw/misc/ivshmem.c              |   1 +
>   hw/ppc/e500.c                  |   1 +
>   hw/ppc/spapr_irq.c             |   1 +
>   hw/remote/proxy.c              |   1 +
>   hw/s390x/virtio-ccw.c          |   1 +
>   hw/vfio/pci.c                  |   1 +
>   hw/vfio/platform.c             |   1 +
>   hw/virtio/virtio-pci.c         |   1 +
>   target/arm/kvm.c               |   1 +
>   target/i386/kvm/kvm.c          |   2 +
>   target/i386/kvm/xen-emu.c      |   2 +
>   target/i386/sev.c              |   1 +
>   target/s390x/kvm/kvm.c         |   2 +
>   41 files changed, 155 insertions(+), 88 deletions(-)
>   create mode 100644 include/sysemu/kvm_irq.h
> 

