Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADE466A9BB
	for <lists+kvm@lfdr.de>; Sat, 14 Jan 2023 07:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjANGt3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Jan 2023 01:49:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjANGt2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Jan 2023 01:49:28 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D37E46AB
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 22:49:27 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id c6so25549074pls.4
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 22:49:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0ChTh83yXmK7gfJH3Jpqy2LKc13XowEbohWOUpbLCCQ=;
        b=hY1XJkKTEi1o9mzaFwrfT8mUe3sC8eXcCaMuggKB/h3iL/Vk1+C8IvsN40fL862l71
         Yl1x4xnlylvMZNKlBenl27z8mITz0dEZL6Uw/Yfag6ascp4hQ2IfaVZChmmyaK8gN+Es
         twYhjwcMzhls2avFq6421us2lSdwnGiBPwJ5WsS5D7cChouJPCg8IaXFiT/wQACbamZ2
         8BkfdKqiBIO+u4q5IAyr/9JbV6tcKP5fjjCLGBgh5r0RiWgPlLpNG5sMGkxMqj+XljKR
         ZH46Ogiv2THPt8I+vSXezduQ3868VOq6nOfQ+CUd/ydB2bRzJjGhXz0ms42/NsmByvtJ
         wyvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0ChTh83yXmK7gfJH3Jpqy2LKc13XowEbohWOUpbLCCQ=;
        b=Ef/jjvUWG7Q+APbZMmMzOJsTvrX77C333tYwILDOubIncfZlnwpqGTug9Ati7+fBas
         bBN1JRPJQpmxzjdoMIPF5/Kg303WKg+ZCy1hP4NAVAwqdESRejikdhY8Uxx0v8Lxdyz7
         8KBUkaUEnis2MPHNsVXl6105bfTRJTdQQtevaUV0jcJ8HMgt1QRTqBe+Lxf/x0GPmyuW
         5jY/m32tlmaoK5FweZUXBGg3iSCrmj5ldXw/YoUsriJ+MOtn/kjYnFFnExFlq/s3AHXt
         NBaX/JUVQ3oqKo1tLD6L3o0LFHikxQ6N/lHQY2YEuGnNWiSSqPs9YK/taOUaTypH3X6O
         Sddw==
X-Gm-Message-State: AFqh2kreOLxA8eF62zThQ9ea4RNUeay2x5AutW6DJ7QWrw0Dy55PAYOb
        NBZJtW4sUsJXMZbWzqCihVY+OA==
X-Google-Smtp-Source: AMrXdXsMKzd6t3mkl6aW9OWz1zpPSPUp2huWC0qHwkRpBBrUrL3hHo9CT8wOIOckkpvTKAH397F7TA==
X-Received: by 2002:a17:902:eb11:b0:194:46e0:1b61 with SMTP id l17-20020a170902eb1100b0019446e01b61mr14811067plb.63.1673678966620;
        Fri, 13 Jan 2023 22:49:26 -0800 (PST)
Received: from ?IPV6:2400:4050:a840:1e00:4457:c267:5e09:481b? ([2400:4050:a840:1e00:4457:c267:5e09:481b])
        by smtp.gmail.com with ESMTPSA id x4-20020a1709029a4400b00192aa53a7d5sm15270475plv.8.2023.01.13.22.49.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jan 2023 22:49:26 -0800 (PST)
Message-ID: <fb435604-1638-c4ee-efca-bdbe2a4be98b@daynix.com>
Date:   Sat, 14 Jan 2023 15:49:23 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] accel/kvm: Specify default IPA size for arm64
Content-Language: en-US
To:     Richard Henderson <richard.henderson@linaro.org>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
References: <20230109062259.79074-1-akihiko.odaki@daynix.com>
 <481867e4-b019-80de-5369-9a503fa049ac@linaro.org>
From:   Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <481867e4-b019-80de-5369-9a503fa049ac@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/01/14 14:23, Richard Henderson wrote:
> On 1/8/23 22:22, Akihiko Odaki wrote:
>> libvirt uses "none" machine type to test KVM availability. Before this
>> change, QEMU used to pass 0 as machine type when calling KVM_CREATE_VM.
>>
>> The kernel documentation says:
>>> On arm64, the physical address size for a VM (IPA Size limit) is
>>> limited to 40bits by default. The limit can be configured if the host
>>> supports the extension KVM_CAP_ARM_VM_IPA_SIZE. When supported, use
>>> KVM_VM_TYPE_ARM_IPA_SIZE(IPA_Bits) to set the size in the machine type
>>> identifier, where IPA_Bits is the maximum width of any physical
>>> address used by the VM. The IPA_Bits is encoded in bits[7-0] of the
>>> machine type identifier.
>>>
>>> e.g, to configure a guest to use 48bit physical address size::
>>>
>>>      vm_fd = ioctl(dev_fd, KVM_CREATE_VM, KVM_VM_TYPE_ARM_IPA_SIZE(48));
>>>
>>> The requested size (IPA_Bits) must be:
>>>
>>>   ==   =========================================================
>>>    0   Implies default size, 40bits (for backward compatibility)
>>>    N   Implies N bits, where N is a positive integer such that,
>>>        32 <= N <= Host_IPA_Limit
>>>   ==   =========================================================
>>
>>> Host_IPA_Limit is the maximum possible value for IPA_Bits on the host
>>> and is dependent on the CPU capability and the kernel configuration.
>>> The limit can be retrieved using KVM_CAP_ARM_VM_IPA_SIZE of the
>>> KVM_CHECK_EXTENSION ioctl() at run-time.
>>>
>>> Creation of the VM will fail if the requested IPA size (whether it is
>>> implicit or explicit) is unsupported on the host.
>> https://docs.kernel.org/virt/kvm/api.html#kvm-create-vm
>>
>> So if Host_IPA_Limit < 40, such KVM_CREATE_VM will fail, and libvirt
>> incorrectly thinks KVM is not available. This actually happened on M2
>> MacBook Air.
>>
>> Fix this by specifying 32 for IPA_Bits as any arm64 system should
>> support the value according to the documentation.
>>
>> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
>> ---
>>   accel/kvm/kvm-all.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>> index e86c33e0e6..776ac7efcc 100644
>> --- a/accel/kvm/kvm-all.c
>> +++ b/accel/kvm/kvm-all.c
>> @@ -2294,7 +2294,11 @@ static int kvm_init(MachineState *ms)
>>       KVMState *s;
>>       const KVMCapabilityInfo *missing_cap;
>>       int ret;
>> +#ifdef TARGET_AARCH64
>> +    int type = 32;
>> +#else
>>       int type = 0;
>> +#endif
> 
> No need for an ifdef.  Down below we have,
> 
>      if (object_property_find(OBJECT(current_machine), "kvm-type")) {
>          g_autofree char *kvm_type = 
> object_property_get_str(OBJECT(current_machine),
>                                                              "kvm-type",
>                                                              &error_abort);
>          type = mc->kvm_type(ms, kvm_type);
>      } else if (mc->kvm_type) {
>          type = mc->kvm_type(ms, NULL);
>      }
> 
> and the aarch64 -M virt machine provides virt_kvm_type as mc->kvm_type.
> 
> How did you hit this?  Are you trying to implement your own board model?
> 
> Looking at this, I'm surprised this is a board hook and not a cpu hook.  
> But I suppose the architecture specific 'type' can hide any number of 
> sins.  Anyway, if you are doing your own board model, I suggest 
> arranging to share the virt board hook -- maybe moving it to 
> target/arm/kvm.c in the process?
> 
> 
> r~

I hit this problem when I used libvirt; libvirt uses "none" machine type 
to probe the availability of KVM and "none" machine type does not 
provide kvm_type hook.

As the implementation of "none" machine type is shared among different 
architectures, we cannot remove ifdef by moving it to the hook.

Although implementing the hook for "none" machine type is still 
possible, I  think the default type should provide the lowest common 
denominator and "none" machine type shouldn't try to work around when 
the type is wrong. Otherwise it doesn't make sense to provide the "default".

The virt board hook depends on the memory map of the board so it is not 
straightforward to share it with "none" machine type.

Regards,
Akihiko Odaki
