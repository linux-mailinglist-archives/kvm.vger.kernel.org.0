Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DAA178C7C9
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 16:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236544AbjH2OlV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 10:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237005AbjH2OlC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 10:41:02 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C31E1
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 07:40:58 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-40037db2fe7so41779855e9.0
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 07:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693320057; x=1693924857;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w0CNklfibqXbDKfZVvUCVaujjhjo60UQl5856c99JOs=;
        b=eXeO7MI/C6aW0HX6yLFcekHuY8UDnXBoS4vcAMYj2gUgUmKIohcuDeZHMrOkezLsXP
         d5Rxmhc3Vge56MKBVhOJtdXjlpMqTbp0943K2+rGc1YYeWT/tMJQ3IGDLiqAg8h1DNtl
         ByWJWGtPYj2aoiv/BqPiO9Tgxynhf1BeDNQVcYIbqMSIIM+jMH/DlO7wxMvOUcttfPU/
         T4Lh9QkI4UH7/HxoE2Rtbz7iJ7DSdGyB7fzvo7YuDO23tCqAkolvqLSJ2e1wFYySWqng
         wmLUsH6Av+zGwqzWohUDZv1uk/SCS5Wz5IjPb5WKaShSfd4e2x3iRm7zYVHZJZAltZkO
         VfbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693320057; x=1693924857;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w0CNklfibqXbDKfZVvUCVaujjhjo60UQl5856c99JOs=;
        b=Og82jbIlCqQS0XeyxprcDkXh2Ry4RdOhL3w2RHPeSdqkBNUlpf6Frsp9KDaiqClTdq
         NrvqGcR8hWWeeVIBWFa52Fgmj8IBhBq3ic2g2I0LhU9YPRXfHGterzQ9Yxqhl71O4GWE
         D6gZEGbVIO2qi1v2Pyrl1I2B1rPhnlJQsLVtAKVMDsBWjgOg8ns0RWuANepq8W+DgRHE
         kfzJIxn2r7IGOihXdaAAgiWb7+hOf+F8mG7W1JDycG0z5SUD3r2i5c0iDi7PSv42j6zv
         yWVg/X+kspGQX0lr6ZO3S7RUV4kPLQNvaQ0RAI8sdYlWCiYqVyx3H5nGKxTmEE2KuxZw
         TJxA==
X-Gm-Message-State: AOJu0YwWi3MeUl3XxLT7VA3FId3V5BbzgXKjrBsK1HPtbcG9gYgqxlvz
        shFYPgdIH/armEC2RlJWxzF2bA==
X-Google-Smtp-Source: AGHT+IEKwu0zMOwgggoBJBjwjIgM9e28048wpJanrm3VmQYZq2jz55q/wmH7eaIV8Y5UrLtD6h2hHA==
X-Received: by 2002:a05:600c:d1:b0:401:5443:55a1 with SMTP id u17-20020a05600c00d100b00401544355a1mr11124651wmm.3.1693320057189;
        Tue, 29 Aug 2023 07:40:57 -0700 (PDT)
Received: from [192.168.69.115] (sml13-h01-176-184-15-56.dsl.sta.abo.bbox.fr. [176.184.15.56])
        by smtp.gmail.com with ESMTPSA id o36-20020a05600c512400b00401dc0e5aa0sm43552wms.17.2023.08.29.07.40.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Aug 2023 07:40:56 -0700 (PDT)
Message-ID: <5bfefa59-6e1e-dcfd-a2a6-e49a0b71fded@linaro.org>
Date:   Tue, 29 Aug 2023 16:40:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH v2 13/58] kvm: Introduce kvm_arch_pre_create_vcpu()
Content-Language: en-US
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        erdemaktas@google.com, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
 <20230818095041.1973309-14-xiaoyao.li@intel.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230818095041.1973309-14-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/8/23 11:49, Xiaoyao Li wrote:
> Introduce kvm_arch_pre_create_vcpu(), to perform arch-dependent
> work prior to create any vcpu. This is for i386 TDX because it needs
> call TDX_INIT_VM before creating any vcpu.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>   accel/kvm/kvm-all.c  | 12 ++++++++++++
>   include/sysemu/kvm.h |  1 +
>   2 files changed, 13 insertions(+)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index c9f3aab5e587..5071af917ae0 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -422,6 +422,11 @@ static int kvm_get_vcpu(KVMState *s, unsigned long vcpu_id)
>       return kvm_vm_ioctl(s, KVM_CREATE_VCPU, (void *)vcpu_id);
>   }
>   
> +int __attribute__ ((weak)) kvm_arch_pre_create_vcpu(CPUState *cpu)
> +{
> +    return 0;
> +}

kvm_arch_init_vcpu() is implemented for each arch. Why not use the
same approach here?

>   int kvm_init_vcpu(CPUState *cpu, Error **errp)
>   {
>       KVMState *s = kvm_state;
> @@ -430,6 +435,13 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
>   
>       trace_kvm_init_vcpu(cpu->cpu_index, kvm_arch_vcpu_id(cpu));
>   
> +    ret = kvm_arch_pre_create_vcpu(cpu);
> +    if (ret < 0) {
> +        error_setg_errno(errp, -ret, "%s: kvm_arch_pre_create_vcpu() failed",
> +                        __func__);
> +        goto err;
> +    }
> +
>       ret = kvm_get_vcpu(s, kvm_arch_vcpu_id(cpu));
>       if (ret < 0) {
>           error_setg_errno(errp, -ret, "kvm_init_vcpu: kvm_get_vcpu failed (%lu)",
> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> index 49c896d8a512..d89ec87072d7 100644
> --- a/include/sysemu/kvm.h
> +++ b/include/sysemu/kvm.h
> @@ -371,6 +371,7 @@ int kvm_arch_put_registers(CPUState *cpu, int level);
>   
>   int kvm_arch_init(MachineState *ms, KVMState *s);
>   
> +int kvm_arch_pre_create_vcpu(CPUState *cpu);
>   int kvm_arch_init_vcpu(CPUState *cpu);
>   int kvm_arch_destroy_vcpu(CPUState *cpu);
>   

