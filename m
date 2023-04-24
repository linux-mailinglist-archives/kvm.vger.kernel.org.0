Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 327AA6ECACA
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 12:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbjDXK6t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 06:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjDXK6r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 06:58:47 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD2A211F
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 03:58:46 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-63b4a64c72bso3486546b3a.0
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 03:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20221208.gappssmtp.com; s=20221208; t=1682333926; x=1684925926;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rOjGvSWGj09wgZSTkQ2r2PpEFh6Mq524vF457zFZuN4=;
        b=3nKXRoR+exIEJRB8dVhAvpwrOInr8uA+VikV6ycBzo2I6j6hPBlYoy/TZ25az3WCFa
         Rj48szYVKP/7SJrkOAFkTcJc7G1ngVuW5u5ao00nHyElOOrH8GMoNmLBvghkR4jDERCL
         aIarTQKjcPh0U6Nd0pqt4gguRRgxo/vcJ+xOC1tGIWABF4B0Uzhc+0lRWcT72XuXGZ6F
         Gonrp7LewDI3DDgCd0G0cH4FA4i1lF9/fKfzAlNbMrXrcMWCf6TxRDhX2AFrt4m9XFQy
         28HyoDAAfOXdmf8YKXl5X7W6Es4+XAvtUZBJTlONWOYQWJKxtfA92wSirdX3RDviy0/k
         6dUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682333926; x=1684925926;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rOjGvSWGj09wgZSTkQ2r2PpEFh6Mq524vF457zFZuN4=;
        b=CNrgF/94yvmM02brjV16aR+aDMf0tq4O5KD7bUeuPqTVYxfvIw1dfJUwhvfkVn5okS
         cQo6RbR1p+XRtq0L31KijtcEaMLnvHx+x3l+pKQG0lhqpFsy/XhdaMr+lCxFAP5qt2s0
         6WCiLa0ZlA1yRbjmhBLP00CBE68/4pNJQAXQifWqOHaSdP+AZ7iw9t4KgElMQWyie1VJ
         OK2dn+oaqb0kKSU4ia8B9Tinb1khoR6IHJcJSVVAxAhrYXSFObKVMiYW3xGWLprULj9j
         S4G095Y1mdVU1hMfutvH6wPeBbz6Yo+FuWOL04DYTqIMdMnB3KKiMlnlQxRsCacW3VZf
         hwaQ==
X-Gm-Message-State: AAQBX9e0Pmg5KfnZNcOaWhdk6v18WIumuTG4pWIoApA0Y/TTKfxRmCaC
        8yD7mDIAzze7XIwbuZwfE3Ha1YetMfT5gZs+6Ks=
X-Google-Smtp-Source: AKy350YmcM4dLLZgIOM/acgLgjT5nSkzVfCXBu0dtkklxR8GQMuGJ4AuF8kRNzsINwGDMWRL49vzrw==
X-Received: by 2002:a05:6a00:810:b0:63d:2990:deb with SMTP id m16-20020a056a00081000b0063d29900debmr16019192pfk.30.1682333926092;
        Mon, 24 Apr 2023 03:58:46 -0700 (PDT)
Received: from ?IPV6:2400:4050:a840:1e00:4457:c267:5e09:481b? ([2400:4050:a840:1e00:4457:c267:5e09:481b])
        by smtp.gmail.com with ESMTPSA id p14-20020a62ab0e000000b0063a5837d9e8sm7138521pff.156.2023.04.24.03.58.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Apr 2023 03:58:45 -0700 (PDT)
Message-ID: <1453e91d-c630-0d95-156d-cdf97774db1b@daynix.com>
Date:   Mon, 24 Apr 2023 19:58:43 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] accel/kvm: Specify default IPA size for arm64
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        Peter Maydell <peter.maydell@linaro.org>
References: <20230109062259.79074-1-akihiko.odaki@daynix.com>
 <481867e4-b019-80de-5369-9a503fa049ac@linaro.org>
 <fb435604-1638-c4ee-efca-bdbe2a4be98b@daynix.com>
 <CAFEAcA8dT+uvhCspUU9P-ev57UR9r5MDxkinPzwf+TieW_mUYg@mail.gmail.com>
From:   Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <CAFEAcA8dT+uvhCspUU9P-ev57UR9r5MDxkinPzwf+TieW_mUYg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/01/16 20:18, Peter Maydell wrote:
> On Sat, 14 Jan 2023 at 06:49, Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>>
>> On 2023/01/14 14:23, Richard Henderson wrote:
>>> On 1/8/23 22:22, Akihiko Odaki wrote:
>>>> libvirt uses "none" machine type to test KVM availability. Before this
>>>> change, QEMU used to pass 0 as machine type when calling KVM_CREATE_VM.
>>>>
>>>> The kernel documentation says:
>>>>> On arm64, the physical address size for a VM (IPA Size limit) is
>>>>> limited to 40bits by default. The limit can be configured if the host
>>>>> supports the extension KVM_CAP_ARM_VM_IPA_SIZE. When supported, use
>>>>> KVM_VM_TYPE_ARM_IPA_SIZE(IPA_Bits) to set the size in the machine type
>>>>> identifier, where IPA_Bits is the maximum width of any physical
>>>>> address used by the VM. The IPA_Bits is encoded in bits[7-0] of the
>>>>> machine type identifier.
>>>>>
>>>>> e.g, to configure a guest to use 48bit physical address size::
>>>>>
>>>>>       vm_fd = ioctl(dev_fd, KVM_CREATE_VM, KVM_VM_TYPE_ARM_IPA_SIZE(48));
>>>>>
>>>>> The requested size (IPA_Bits) must be:
>>>>>
>>>>>    ==   =========================================================
>>>>>     0   Implies default size, 40bits (for backward compatibility)
>>>>>     N   Implies N bits, where N is a positive integer such that,
>>>>>         32 <= N <= Host_IPA_Limit
>>>>>    ==   =========================================================
>>>>
>>>>> Host_IPA_Limit is the maximum possible value for IPA_Bits on the host
>>>>> and is dependent on the CPU capability and the kernel configuration.
>>>>> The limit can be retrieved using KVM_CAP_ARM_VM_IPA_SIZE of the
>>>>> KVM_CHECK_EXTENSION ioctl() at run-time.
>>>>>
>>>>> Creation of the VM will fail if the requested IPA size (whether it is
>>>>> implicit or explicit) is unsupported on the host.
>>>> https://docs.kernel.org/virt/kvm/api.html#kvm-create-vm
>>>>
>>>> So if Host_IPA_Limit < 40, such KVM_CREATE_VM will fail, and libvirt
>>>> incorrectly thinks KVM is not available. This actually happened on M2
>>>> MacBook Air.
>>>>
>>>> Fix this by specifying 32 for IPA_Bits as any arm64 system should
>>>> support the value according to the documentation.
>>>>
>>>> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
>>>> ---
>>>>    accel/kvm/kvm-all.c | 4 ++++
>>>>    1 file changed, 4 insertions(+)
>>>>
>>>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>>>> index e86c33e0e6..776ac7efcc 100644
>>>> --- a/accel/kvm/kvm-all.c
>>>> +++ b/accel/kvm/kvm-all.c
>>>> @@ -2294,7 +2294,11 @@ static int kvm_init(MachineState *ms)
>>>>        KVMState *s;
>>>>        const KVMCapabilityInfo *missing_cap;
>>>>        int ret;
>>>> +#ifdef TARGET_AARCH64
>>>> +    int type = 32;
>>>> +#else
>>>>        int type = 0;
>>>> +#endif
>>>
>>> No need for an ifdef.  Down below we have,
>>>
>>>       if (object_property_find(OBJECT(current_machine), "kvm-type")) {
>>>           g_autofree char *kvm_type =
>>> object_property_get_str(OBJECT(current_machine),
>>>                                                               "kvm-type",
>>>                                                               &error_abort);
>>>           type = mc->kvm_type(ms, kvm_type);
>>>       } else if (mc->kvm_type) {
>>>           type = mc->kvm_type(ms, NULL);
>>>       }
>>>
>>> and the aarch64 -M virt machine provides virt_kvm_type as mc->kvm_type.
>>>
>>> How did you hit this?  Are you trying to implement your own board model?
>>>
>>> Looking at this, I'm surprised this is a board hook and not a cpu hook.
>>> But I suppose the architecture specific 'type' can hide any number of
>>> sins.  Anyway, if you are doing your own board model, I suggest
>>> arranging to share the virt board hook -- maybe moving it to
>>> target/arm/kvm.c in the process?
> 
>> I hit this problem when I used libvirt; libvirt uses "none" machine type
>> to probe the availability of KVM and "none" machine type does not
>> provide kvm_type hook.
>>
>> As the implementation of "none" machine type is shared among different
>> architectures, we cannot remove ifdef by moving it to the hook.
>>
>> Although implementing the hook for "none" machine type is still
>> possible, I  think the default type should provide the lowest common
>> denominator and "none" machine type shouldn't try to work around when
>> the type is wrong. Otherwise it doesn't make sense to provide the "default".
> 
> Yes, the problem is that the 'none' board type is all
> architecture-independent code, and so is this kvm_init() code, so
> there's no obvious arm-specific place to say "pick the best IPA size
> that will work for this host".
> 
> Perhaps we should create somewhere in here a target-arch specific
> hook: we already have ifdefs in this function for S390X and PPC
> (printing some special case error strings if the ioctl fails), so
> maybe a hook that does "take the type provided by the machine hook,
> if any, sanitize or reject it, do the ioctl call, print arch-specific
> help/error messages if relevant" ? Paolo, do you have an opinion?
> 
> thanks
> -- PMM

Hi Paolo,

I have sent this patch a while ago but it's kind of missed so I'm about 
to push this forward again. Can you have a look at this?

Regards,
Akihiko Odaki
