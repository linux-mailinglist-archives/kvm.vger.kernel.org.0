Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52CCF6E8EC3
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 12:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234344AbjDTKAd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 06:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234328AbjDTKAY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 06:00:24 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9472526AC
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 03:00:07 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3f17b967bfbso14691115e9.1
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 03:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681984806; x=1684576806;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yBAhlFTL1lrIG28vRQkGMKES1YJTi+dPx+8I3leXqUc=;
        b=EAj+c/nWVBe+vVG1OFbAUOVuYiruq5FN1IapVG4c7mukQjxpKO00ereqYUDG6Ii6sc
         5nvDdzKEF3cj+JsSmmj4aYJxNLdvfE87Dji8V0f2TG/kcyloDySZlHCa3hFZqtnhBivQ
         jRPwTQDOELJQL3bjeStJrIMT9Pf1FdKu1677eXhTD4A8z04zP84d6WbaCkui75cRMkoL
         80qGZC7sb4PJTfx9FpH4ErytQeCu12hE8p3IpSMr8jt+9Wj22Vh+TPwVbG9HJCKfYKhK
         SW9v+V3O6WQxDSCA90IulZiRYVILz23a6Z9HZRB3KbedYtgTUaHzKVMwrx+wp3xyZ9z4
         LLaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681984806; x=1684576806;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yBAhlFTL1lrIG28vRQkGMKES1YJTi+dPx+8I3leXqUc=;
        b=Ij/qrTvR48OZ3PONrqEqYySLtoMs+tTs61DfO7I5SqdU1B1wSCYqSABoDC04MxRR6M
         5ZD7ISkJ4Q6QmUHqv7OewMPk6OC/bYslW5XAeChWbyw4fVrz7hNLr1dI7N1vW6g+VLba
         6oT177hHtdFFXFyg9iVcBkEzeVQWI2CvmOV0YUKXbhIdUPqIx8QXZtIUrSEMnViOx5/2
         cW4sygmtRSQC4M2oEsSswN6n9suWkB1Ys/snmVJ4Gngl8ATFLP/PieZ9LkLztrwNPMu0
         kUj9nv6sZkJvLOo+GRU2q1bNKZ4ht3b9zB3IhilAuPJ7IwuT4u00tD/hG/TZyhwSDkBN
         MCqA==
X-Gm-Message-State: AAQBX9fjD1UFwp+o2+i/6pYxpzQ6W2NG++zuNG6i4J1u5dgLQZ3BaEmC
        vkPP8tar19CAVS+rpEYrYq1wnQ==
X-Google-Smtp-Source: AKy350bEZYWD6DVX3P6g8MyM/q4UdKvVB8e52UoHDz5C0Fvd8fuhxKuVhfOFXyKP0hpfnZYA2zyM1A==
X-Received: by 2002:adf:f092:0:b0:2fe:c8b5:b5da with SMTP id n18-20020adff092000000b002fec8b5b5damr940920wro.13.1681984805711;
        Thu, 20 Apr 2023 03:00:05 -0700 (PDT)
Received: from [192.168.30.216] ([81.0.6.76])
        by smtp.gmail.com with ESMTPSA id a10-20020adfdd0a000000b002febc543c40sm1501157wrm.82.2023.04.20.03.00.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Apr 2023 03:00:05 -0700 (PDT)
Message-ID: <bbc4bf1b-9855-db6f-05d4-aa3baac96ee2@linaro.org>
Date:   Thu, 20 Apr 2023 12:00:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH RFC v1 07/10] target/loongarch: Implement
 kvm_arch_handle_exit
Content-Language: en-US
To:     Tianrui Zhao <zhaotianrui@loongson.cn>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        gaosong@loongson.cn
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, maobibo@loongson.cn
References: <20230420093606.3366969-1-zhaotianrui@loongson.cn>
 <20230420093606.3366969-8-zhaotianrui@loongson.cn>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230420093606.3366969-8-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/4/23 11:36, Tianrui Zhao wrote:
> Implement kvm_arch_handle_exit for loongarch. In this
> function, the KVM_EXIT_LOONGARCH_IOCSR is handled,
> we read or write the iocsr address space by the addr,
> length and is_write argument in kvm_run.
> 
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>   target/loongarch/kvm.c | 24 +++++++++++++++++++++++-
>   1 file changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/target/loongarch/kvm.c b/target/loongarch/kvm.c
> index f8772bbb27..4ce343d276 100644
> --- a/target/loongarch/kvm.c
> +++ b/target/loongarch/kvm.c
> @@ -499,7 +499,29 @@ bool kvm_arch_cpu_check_are_resettable(void)
>   
>   int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
>   {
> -    return 0;
> +    int ret = 0;
> +    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
> +    CPULoongArchState *env = &cpu->env;
> +    MemTxAttrs attrs = {};
> +
> +    attrs.requester_id = env_cpu(env)->cpu_index;
> +
> +    DPRINTF("%s\n", __func__);

Please use trace events instead of DPRINTF(), as we are trying to remove
these.

> +    switch (run->exit_reason) {
> +    case KVM_EXIT_LOONGARCH_IOCSR:
> +        address_space_rw(&env->address_space_iocsr,
> +                         run->iocsr_io.phys_addr,
> +                         attrs,
> +                         run->iocsr_io.data,
> +                         run->iocsr_io.len,
> +                         run->iocsr_io.is_write);
> +        break;
> +    default:
> +        ret = -1;
> +        fprintf(stderr, "KVM: unknown exit reason %d\n", run->exit_reason);

Would warn_report() be more appropriate here?

> +        break;
> +    }
> +    return ret;
>   }
>   
>   void kvm_arch_accel_class_init(ObjectClass *oc)

