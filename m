Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9F8473A794
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 19:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbjFVRqw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 13:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjFVRqv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 13:46:51 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34DCA1988
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 10:46:49 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id 2adb3069b0e04-4f954d78bf8so4897426e87.3
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 10:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687456007; x=1690048007;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y9a7YoYe3T0MbLBO0L7+zRiLRSaGbDua3R68SVuQkUE=;
        b=S3aJfe8OPD1b3iOHso9gShg+orahkCpBFmblOyHZjOMtfsC9rAS4LohByD3rLonWoE
         evq7uhrMz4t/6OGegMF1W2itotOgLRl27ovwraKfI7Ysiyht7S5BcZLMoBYnV/Jw16XA
         RHWoykN+6S8jp3lN6clSZc2jOJeleeQJMv3bbDs/LwzKaddO9YOneCTMKO/FPxwioUlb
         UCTyeKcuQuR9Fn98+Z4JJvz/OGRnUXY32TnqjJNcu8bmZyLxuQxi0IUPExbQx/HsQwkh
         b9CDB45a87awo/swZ8Gz2lkB+qFhv0XGbCPFnTcMsnmzlJD5yWcejihYecJKQ3KSmaRA
         VMVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687456007; x=1690048007;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y9a7YoYe3T0MbLBO0L7+zRiLRSaGbDua3R68SVuQkUE=;
        b=BC5Fak6Mo1wmB0ZAKtYilB103In6s/YFI2Y0OKhp/tEBfBjYrxAkWwdgQd1TBCZoLc
         NTzE7HDTxHNhXxwtID4B7B2NSCqDo7XNj0q00t5tzdtlk1YTCi9KMErroQkPretsrZPY
         1vZFEf70ip8C0VgT1Z75BwpnWYu043TMMG95BLqUldo9n7WFj5LYThQnXYV3Xq14Vr79
         0blp8nSoet6+sZPa/WdXH+IxBJYx4V7TKX/qCxeBGgn9gd87OIIBygZ1FjWM8dPzBtsn
         ZLbqKcmelqNqm3lodgjM2mdJoBcO4guR2ul8+NovPTAPPsXY5RcZnZJv1H+LU/mYYeqt
         yCqw==
X-Gm-Message-State: AC+VfDyZIOlUsdJLdpnDyaCnuiGG2MiTdmPu4zmTcFTH/ZkL3MqvhO02
        BI7Q94SfkN4K9HjT6VDaExKE7A==
X-Google-Smtp-Source: ACHHUZ5haGO8m6yiOqgmROBAyNlMVacxQPLIXMYcwaQC+7P/x0bXWpeMMk4iIZ27Jh55lZjOPBtZAQ==
X-Received: by 2002:a05:6512:3b12:b0:4f9:5d2a:e0ee with SMTP id f18-20020a0565123b1200b004f95d2ae0eemr4589292lfv.16.1687456007327;
        Thu, 22 Jun 2023 10:46:47 -0700 (PDT)
Received: from [192.168.157.227] ([91.223.100.47])
        by smtp.gmail.com with ESMTPSA id h23-20020ac25977000000b004f874e12e72sm1198114lfp.224.2023.06.22.10.46.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jun 2023 10:46:46 -0700 (PDT)
Message-ID: <2c0a97af-be7e-6d83-5176-ef9980c2faf0@linaro.org>
Date:   Thu, 22 Jun 2023 19:46:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2 07/16] accel: Rename HAX 'struct hax_vcpu_state' ->
 AccelCPUState
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Reinoud Zandijk <reinoud@netbsd.org>, qemu-arm@nongnu.org,
        kvm@vger.kernel.org, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Roman Bolshakov <rbolshakov@ddn.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Durrant <paul@xen.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Alexander Graf <agraf@csgraf.de>,
        xen-devel@lists.xenproject.org,
        Eduardo Habkost <eduardo@habkost.net>,
        Cameron Esfahani <dirty@apple.com>
References: <20230622160823.71851-1-philmd@linaro.org>
 <20230622160823.71851-8-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230622160823.71851-8-philmd@linaro.org>
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

On 6/22/23 18:08, Philippe Mathieu-Daudé wrote:
> |+ struct AccelvCPUState *accel;|
...
> +typedef struct AccelCPUState {
>      hax_fd fd;
>      int vcpu_id;
>      struct hax_tunnel *tunnel;
>      unsigned char *iobuf;
> -};
> +} hax_vcpu_state;


Discussed face to face, but for the record:

Put the typedef in qemu/typedefs.h, so that we can use it immediately in core/cpu.h and 
not need to re-declare it in each accelerator.

Drop hax_vcpu_state typedef and just use AccelCPUState (since you have to change all of 
those lines anyway.  Which will eventually allow

> +++ b/target/i386/whpx/whpx-all.c
> @@ -2258,7 +2258,7 @@ int whpx_init_vcpu(CPUState *cpu)
>  
>      vcpu->interruptable = true;
>      cpu->vcpu_dirty = true;
> -    cpu->accel = (struct hax_vcpu_state *)vcpu;
> +    cpu->accel = (struct AccelCPUState *)vcpu;

this cast to go away.


r~
