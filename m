Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E19266A95E
	for <lists+kvm@lfdr.de>; Sat, 14 Jan 2023 06:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjANFXa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Jan 2023 00:23:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjANFX3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Jan 2023 00:23:29 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB6235B8
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 21:23:28 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id dw9so22939198pjb.5
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 21:23:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HJS9xVv4/J7tNPXn+GQ+26s6z9YeJxqfTgmPHKGAKoc=;
        b=HfXs/+GLH93iFYMGOaHO50H1DJTnlLpxu7kdWGMqiAYJ5YAu5pjGhBmmZT3gSGTIyH
         X0A6jY7BecSkgJ2lSI3Ry0MRgrnHuxV5bbvVs/K482DZGXrAt/yXgLlEO5kvzBvbXCUz
         GbEP7/FWE2VIVn0NMsKfD1jpkMk5voKpBrvv+14E5soU1L2U5XqQjI/GnWG8mhasnm9l
         guxEKp8dbicXZ+RYWJ4EZsbjmiJfDdx+1gK4Drcw18ufxaNUlKDYEoi+e4AVkiwf1jIy
         BHGmLA9AkgX1qMb37d/xfXZH3mirHZ4WD3oiHlM+er/EymNoZGcOejcOOpLNoIVj5Pmz
         dTJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HJS9xVv4/J7tNPXn+GQ+26s6z9YeJxqfTgmPHKGAKoc=;
        b=DWRdbIzJ7iCKj7sKwFX1uEV+7Fg5TSwf9mOg98/vbbAxSEdvmDvmUYyniJmw/znv01
         Y2JgeVRkhthH7y/09cwrcySRUTjkc+sRzsFWyHnfzFxgt7KXXbjeqGFJvo1amfjwb8zG
         lgtLr+2hE9jZp4cD62jJqBYPrBOoyYvunYlPCzkHutGDCw7DjLl46Qgm+d7k0cLfvZ91
         SiCVgUxYaifekzi4nR1UqGO/rpBuZVC4k54YiCTsGlg5trYZP5DCGQ2qhrqJoBQsawCL
         1b0zgQPvu4okoIeTbCFRURIU2YPNc9wuRu5PZOBql4u5S9nXSBmtB2sjHWqI3eGSiEXP
         W2cA==
X-Gm-Message-State: AFqh2ko+n6vMGschk7+iZKZHQRoR3S+TslJP2O+Yk3tnYr3gcoi8SGNO
        sEAkjO0NFJwlamRFwAXMApy3mcK/d64JsZZm
X-Google-Smtp-Source: AMrXdXtbNQgiejIBmiQYNb4nA5VMHFLepnKgBKWYth/nfELvvekv5wiKS+PnJPFNMOYFITIn/spEZw==
X-Received: by 2002:a17:902:b493:b0:191:3a8f:809 with SMTP id y19-20020a170902b49300b001913a8f0809mr78207941plr.7.1673673807810;
        Fri, 13 Jan 2023 21:23:27 -0800 (PST)
Received: from [192.168.5.146] (rrcs-173-198-77-218.west.biz.rr.com. [173.198.77.218])
        by smtp.gmail.com with ESMTPSA id o9-20020a170903210900b0017fe9b038fdsm15154029ple.14.2023.01.13.21.23.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jan 2023 21:23:27 -0800 (PST)
Message-ID: <481867e4-b019-80de-5369-9a503fa049ac@linaro.org>
Date:   Fri, 13 Jan 2023 19:23:22 -1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] accel/kvm: Specify default IPA size for arm64
Content-Language: en-US
To:     Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
References: <20230109062259.79074-1-akihiko.odaki@daynix.com>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230109062259.79074-1-akihiko.odaki@daynix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/8/23 22:22, Akihiko Odaki wrote:
> libvirt uses "none" machine type to test KVM availability. Before this
> change, QEMU used to pass 0 as machine type when calling KVM_CREATE_VM.
> 
> The kernel documentation says:
>> On arm64, the physical address size for a VM (IPA Size limit) is
>> limited to 40bits by default. The limit can be configured if the host
>> supports the extension KVM_CAP_ARM_VM_IPA_SIZE. When supported, use
>> KVM_VM_TYPE_ARM_IPA_SIZE(IPA_Bits) to set the size in the machine type
>> identifier, where IPA_Bits is the maximum width of any physical
>> address used by the VM. The IPA_Bits is encoded in bits[7-0] of the
>> machine type identifier.
>>
>> e.g, to configure a guest to use 48bit physical address size::
>>
>>      vm_fd = ioctl(dev_fd, KVM_CREATE_VM, KVM_VM_TYPE_ARM_IPA_SIZE(48));
>>
>> The requested size (IPA_Bits) must be:
>>
>>   ==   =========================================================
>>    0   Implies default size, 40bits (for backward compatibility)
>>    N   Implies N bits, where N is a positive integer such that,
>>        32 <= N <= Host_IPA_Limit
>>   ==   =========================================================
> 
>> Host_IPA_Limit is the maximum possible value for IPA_Bits on the host
>> and is dependent on the CPU capability and the kernel configuration.
>> The limit can be retrieved using KVM_CAP_ARM_VM_IPA_SIZE of the
>> KVM_CHECK_EXTENSION ioctl() at run-time.
>>
>> Creation of the VM will fail if the requested IPA size (whether it is
>> implicit or explicit) is unsupported on the host.
> https://docs.kernel.org/virt/kvm/api.html#kvm-create-vm
> 
> So if Host_IPA_Limit < 40, such KVM_CREATE_VM will fail, and libvirt
> incorrectly thinks KVM is not available. This actually happened on M2
> MacBook Air.
> 
> Fix this by specifying 32 for IPA_Bits as any arm64 system should
> support the value according to the documentation.
> 
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> ---
>   accel/kvm/kvm-all.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index e86c33e0e6..776ac7efcc 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -2294,7 +2294,11 @@ static int kvm_init(MachineState *ms)
>       KVMState *s;
>       const KVMCapabilityInfo *missing_cap;
>       int ret;
> +#ifdef TARGET_AARCH64
> +    int type = 32;
> +#else
>       int type = 0;
> +#endif

No need for an ifdef.  Down below we have,

     if (object_property_find(OBJECT(current_machine), "kvm-type")) {
         g_autofree char *kvm_type = object_property_get_str(OBJECT(current_machine),
                                                             "kvm-type",
                                                             &error_abort);
         type = mc->kvm_type(ms, kvm_type);
     } else if (mc->kvm_type) {
         type = mc->kvm_type(ms, NULL);
     }

and the aarch64 -M virt machine provides virt_kvm_type as mc->kvm_type.

How did you hit this?  Are you trying to implement your own board model?

Looking at this, I'm surprised this is a board hook and not a cpu hook.  But I suppose the 
architecture specific 'type' can hide any number of sins.  Anyway, if you are doing your 
own board model, I suggest arranging to share the virt board hook -- maybe moving it to 
target/arm/kvm.c in the process?


r~
