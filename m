Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F69578BAFD
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 00:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233900AbjH1W0z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Aug 2023 18:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233845AbjH1W0c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Aug 2023 18:26:32 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D164A13D
        for <kvm@vger.kernel.org>; Mon, 28 Aug 2023 15:26:29 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id ffacd0b85a97d-31c5c06e8bbso3074386f8f.1
        for <kvm@vger.kernel.org>; Mon, 28 Aug 2023 15:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693261588; x=1693866388;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Vm3H7pOzxT2KI8I1yN1qSPG4IC7rpw+x2qqgA34opZs=;
        b=G+mZ51a2OfT+8KzAhZhaLQMM8BmY4DgvEv0jFJ0OsQ9wHOFfV4OqVd2EvM3+7MRXiD
         q39UzNF00uRveaJ1JYw8pzTGrPclyRMaMSuVGaMpZohfW2v5T6zOQu45Grs8iIyJc1KL
         xEn9w+8832iL8pSfYwRaoZvsIo1GMSHeua5BBfgnjlXSQ7FNHemhX00V70CMT4dPAgf7
         QTK1rHTPGr+OmD0MpGhdAHYNQ2Uzfjh0RW0WNOUTMB0wyC/GVAw7eEXWZLvaoTXRgmMN
         Gcv9+ewGrmGA9dpGsQHblwvnrOSDtx/MUu4k/UXb4D/lthRY9YXRO6W0kJWstQ5iavHq
         zvLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693261588; x=1693866388;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vm3H7pOzxT2KI8I1yN1qSPG4IC7rpw+x2qqgA34opZs=;
        b=BNPruzucH4nyDhALPhm3ThFrtuYO4PD0zmMxTiLt7U5OclzJvD9hX+fze62Zk8WRWZ
         cpXGcI7nBI+ekR2fhs7Xg5C9BEiuqIsRaCk3mckkckKhMpQfIrdAezELtf8M6UKhY14S
         PAnKA0xUUow3+Pf8R+ZrIH1/l++/POr6f3m6KFTIubMyfmj0/5gOmPqq7GIJRH9Kea2F
         PPbUFkSVXZYIzz713ecEKibfLN4x5kOBVs0aBxgUYizAzmmE/6MxcBmD/xCHFmxVqh8W
         +cZpfeGxoO2bYAL87EegWUFZUAFoYEn5hiuL/E3zGme/uBr+rFIMhInaINj62CZ6FXQG
         kxSQ==
X-Gm-Message-State: AOJu0YwlJUvWntB3L9mbdNIMjzECfjTSIvq4GQH8f8G86cl6jrln9cdn
        APN4bJQnjlO/Qv+ku8BYJ1OzCg==
X-Google-Smtp-Source: AGHT+IGW96sElphoRlaUhLax7rumoMSOAyhXHhDvuV+/Bwm/TC9lSuts3C2izGbKnjYLSfHST4MftQ==
X-Received: by 2002:a5d:45c4:0:b0:31a:d90d:8d9f with SMTP id b4-20020a5d45c4000000b0031ad90d8d9fmr16903636wrs.25.1693261588338;
        Mon, 28 Aug 2023 15:26:28 -0700 (PDT)
Received: from [192.168.69.115] ([176.164.201.64])
        by smtp.gmail.com with ESMTPSA id y3-20020adfe6c3000000b0031c5ce91ad6sm11749584wrm.97.2023.08.28.15.26.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Aug 2023 15:26:27 -0700 (PDT)
Message-ID: <1d68ca74-ce92-ca5f-2c8b-e4567265e2fc@linaro.org>
Date:   Tue, 29 Aug 2023 00:26:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH v2 04/16] kvm: Return number of free memslots
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>, qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Michal Privoznik <mprivozn@redhat.com>,
        =?UTF-8?Q?Daniel_P_=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        kvm@vger.kernel.org
References: <20230825132149.366064-1-david@redhat.com>
 <20230825132149.366064-5-david@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230825132149.366064-5-david@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/8/23 15:21, David Hildenbrand wrote:
> Let's return the number of free slots instead of only checking if there
> is a free slot. While at it, check all address spaces, which will also
> consider SMM under x86 correctly.
> 
> Make the stub return UINT_MAX, such that we can call the function
> unconditionally.
> 
> This is a preparation for memory devices that consume multiple memslots.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>   accel/kvm/kvm-all.c      | 33 ++++++++++++++++++++-------------
>   accel/stubs/kvm-stub.c   |  4 ++--
>   hw/mem/memory-device.c   |  2 +-
>   include/sysemu/kvm.h     |  2 +-
>   include/sysemu/kvm_int.h |  1 +
>   5 files changed, 25 insertions(+), 17 deletions(-)


> diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
> index 235dc661bc..f39997d86e 100644
> --- a/accel/stubs/kvm-stub.c
> +++ b/accel/stubs/kvm-stub.c
> @@ -109,9 +109,9 @@ int kvm_irqchip_remove_irqfd_notifier_gsi(KVMState *s, EventNotifier *n,
>       return -ENOSYS;
>   }
>   
> -bool kvm_has_free_slot(MachineState *ms)
> +unsigned int kvm_get_free_memslots(void)
>   {
> -    return false;
> +    return UINT_MAX;

Isn't it clearer returning 0 here and keeping kvm_enabled() below?

>   }
>   
>   void kvm_init_cpu_signals(CPUState *cpu)
> diff --git a/hw/mem/memory-device.c b/hw/mem/memory-device.c
> index 667d56bd29..7c24685796 100644
> --- a/hw/mem/memory-device.c
> +++ b/hw/mem/memory-device.c
> @@ -59,7 +59,7 @@ static void memory_device_check_addable(MachineState *ms, MemoryRegion *mr,
>       const uint64_t size = memory_region_size(mr);
>   
>       /* we will need a new memory slot for kvm and vhost */
> -    if (kvm_enabled() && !kvm_has_free_slot(ms)) {
> +    if (!kvm_get_free_memslots()) {

(here)

>           error_setg(errp, "hypervisor has no free memory slots left");
>           return;
>       }


> diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
> index 511b42bde5..8b09e78b12 100644
> --- a/include/sysemu/kvm_int.h
> +++ b/include/sysemu/kvm_int.h
> @@ -40,6 +40,7 @@ typedef struct KVMMemoryUpdate {
>   typedef struct KVMMemoryListener {
>       MemoryListener listener;
>       KVMSlot *slots;
> +    int nr_used_slots;

Preferably using 'unsigned' here:

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


