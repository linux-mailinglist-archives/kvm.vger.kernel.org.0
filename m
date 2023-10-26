Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFBC27D7C88
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 07:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233233AbjJZFwz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 01:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjJZFwy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 01:52:54 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB560115
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 22:52:49 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id 38308e7fff4ca-2c59a4dd14cso6922491fa.2
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 22:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1698299568; x=1698904368; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Blus2E8MXTIU3zWcw+upkP+KG6Xw5pB0t5mXlT/gwLU=;
        b=Qei/ZZ7t0ftOqQDswhNFoAp/o7k2J5DZKnpUjkzKef2SFvuuH94DaTv93QCdBdezP+
         E4yW6h6yEwq2rnCwX2vdlfaC7epPJ9DBH1YKHzzQRZs7ttm95LfRijSWTvPBi3PI+bXy
         p7o66gFBpYNSVT7Sk7kPHnggSg4xXsTHoyU/j4pqnoKNQk//nVS2YyFgOzMmjC8QgtDH
         bHihNiGTeZ0D8d+aL83IoyvyOcBaOcBwxsooCdUdcUAu2N1SUifjkrz8t0v13ZGnEdCi
         OpyIAnfnFQOdrFHGpEhpPfcJEe2itZ+s/Q05fM0py1ePtzs+ldF0ka1Th2BQbTAK6OAA
         auJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698299568; x=1698904368;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Blus2E8MXTIU3zWcw+upkP+KG6Xw5pB0t5mXlT/gwLU=;
        b=uN7jVZM6sutwZAQsMhEmos4LRiUICx99QdanlLw6h+Y94+oURxtvgIIRc7TvMYvA+4
         xNR0ahmtaSPPqM5rYiQPfgG2AjScwYhhGORNDyOiLYGsb7QbLWNx1T4xftGZCDNe+1pN
         MIyyBgnmIJCE5x5SjgYU2CAEWzNSPTixHxY2v+uAqHkghmAcPto9y+gbyHTZGXg3n97Y
         lVBtbWnd+/NpDpGEF0uD9EDfdyGA9z5EUPz2NcX7FcLAphNm3mDOTH5oGPPs1akfZw8T
         Xj3T/+2djO+n8e0KDiLODkdUbGoP7UU2G76bw1UAZ7mPVmNqOFpBwG013ObN3R0lS9Ou
         bd1Q==
X-Gm-Message-State: AOJu0YxN4lzm7ZuMJtOU85C2FlIHQotTk6XcFUSrH9krYbHnviOP7vcg
        UqlIMK+LqHPMIPaBI6o5D02ieg==
X-Google-Smtp-Source: AGHT+IGF8aTwjtsUMEqjRxbYFSfypaf74fyCg1NLwA+TH4Xd7SyLRTwSAW3uGtRI2Hotypp1x3c/Ww==
X-Received: by 2002:a2e:9812:0:b0:2bd:102c:4161 with SMTP id a18-20020a2e9812000000b002bd102c4161mr13652384ljj.43.1698299567693;
        Wed, 25 Oct 2023 22:52:47 -0700 (PDT)
Received: from [192.168.69.115] (aif79-h01-176-172-114-150.dsl.sta.abo.bbox.fr. [176.172.114.150])
        by smtp.gmail.com with ESMTPSA id m17-20020a056000009100b0032d829e10c0sm13514117wrx.28.2023.10.25.22.52.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Oct 2023 22:52:47 -0700 (PDT)
Message-ID: <78ddc3c3-6cfa-b48c-5d73-903adec6ac4a@linaro.org>
Date:   Thu, 26 Oct 2023 07:52:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH] target/i386/kvm: call kvm_put_vcpu_events() before
 kvm_put_nested_state()
Content-Language: en-US
To:     Eiichi Tsukata <eiichi.tsukata@nutanix.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20231026054201.87845-1-eiichi.tsukata@nutanix.com>
 <D761458A-9296-492B-85B9-F196C7D11CDA@nutanix.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <D761458A-9296-492B-85B9-F196C7D11CDA@nutanix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cc'ing Vitaly.

On 26/10/23 07:49, Eiichi Tsukata wrote:
> Hi all,
> 
> Here is additional details on the issue.
> 
> We've found this issue when testing Windows Virtual Secure Mode (VSM) VMs.
> We sometimes saw live migration failures of VSM-enabled VMs. It turned
> out that the issue happens during live migration when VMs change boot related
> EFI variables (ex: BootOrder, Boot0001).
> After some debugging, I've found the race I mentioned in the commit message.
> 
> Symptom
> =======
> 
> When it happnes with the latest Qemu which has commit https://github.com/qemu/qemu/commit/7191f24c7fcfbc1216d09
> Qemu shows the following error message on destination.
> 
>    qemu-system-x86_64: Failed to put registers after init: Invalid argument
> 
> If it happens with older Qemu which doesn't have the commit, then we see  CPU dump something like this:
> 
>    KVM internal error. Suberror: 3
>    extra data[0]: 0x0000000080000b0e
>    extra data[1]: 0x0000000000000031
>    extra data[2]: 0x0000000000000683
>    extra data[3]: 0x000000007f809000
>    extra data[4]: 0x0000000000000026
>    RAX=0000000000000000 RBX=0000000000000000 RCX=0000000000000000 RDX=0000000000000f61
>    RSI=0000000000000000 RDI=0000000000000000 RBP=0000000000000000 RSP=0000000000000000
>    R8 =0000000000000000 R9 =0000000000000000 R10=0000000000000000 R11=0000000000000000
>    R12=0000000000000000 R13=0000000000000000 R14=0000000000000000 R15=0000000000000000
>    RIP=000000000000fff0 RFL=00010002 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=0
>    ES =0020 0000000000000000 ffffffff 00c09300 DPL=0 DS   [-WA]
>    CS =0038 0000000000000000 ffffffff 00a09b00 DPL=0 CS64 [-RA]
>    SS =0020 0000000000000000 ffffffff 00c09300 DPL=0 DS   [-WA]
>    DS =0020 0000000000000000 ffffffff 00c09300 DPL=0 DS   [-WA]
>    FS =0020 0000000000000000 ffffffff 00c09300 DPL=0 DS   [-WA]
>    GS =0020 0000000000000000 ffffffff 00c09300 DPL=0 DS   [-WA]
>    LDT=0000 0000000000000000 ffffffff 00c00000
>    TR =0040 000000007f7df050 00068fff 00808b00 DPL=0 TSS64-busy
>    GDT=     000000007f7df000 0000004f
>    IDT=     000000007f836000 000001ff
>    CR0=80010033 CR2=000000000000fff0 CR3=000000007f809000 CR4=00000668
>    DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000    DR6=00000000ffff0ff0 DR7=0000000000000400
>    EFER=0000000000000d00
>    Code=?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? <??> ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ??
> 
> In the above dump, CR3 is pointing to SMRAM region though SMM=0.
> 
> Repro
> =====
> 
> Repro step is pretty simple.
> 
> * Run SMM enabled Linux guest with secure boot enabled OVMF.
> * Run the following script in the guest.
> 
>    /usr/libexec/qemu-kvm &
>    while true
>    do
>      efibootmgr -n 1
>    done
> 
> * Do live migration
> 
> On my environment, live migration fails in 20%.
> 
> VMX specific
> ============
> 
> This issue is VMX sepcific and SVM is not affected as the validation
> in svm_set_nested_state() is a bit different from VMX one.
> 
> VMX:
> 
>    static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>                                    struct kvm_nested_state __user *user_kvm_nested_state,
>                                    struct kvm_nested_state *kvm_state)
>    {
>    ..           /*             * SMM temporarily disables VMX, so we cannot be in guest mode,
>           * nor can VMLAUNCH/VMRESUME be pending.  Outside SMM, SMM flags
>           * must be zero.
>           */           if (is_smm(vcpu) ?
>                  (kvm_state->flags &
>                   (KVM_STATE_NESTED_GUEST_MODE | KVM_STATE_NESTED_RUN_PENDING))
>                  : kvm_state->hdr.vmx.smm.flags)
>                  return -EINVAL;
>    ..
> 
> SVM:
> 
>    static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>                                    struct kvm_nested_state __user *user_kvm_nested_state,
>                                    struct kvm_nested_state *kvm_state)
>    {
>    ..           /* SMM temporarily disables SVM, so we cannot be in guest mode.  */           if (is_smm(vcpu) && (kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE))
>                  return -EINVAL;
>    ..
> 
> Thanks,
> 
> Eiichi
> 
>> On Oct 26, 2023, at 14:42, Eiichi Tsukata <eiichi.tsukata@nutanix.com> wrote:
>>
>> kvm_put_vcpu_events() needs to be called before kvm_put_nested_state()
>> because vCPU's hflag is referred in KVM vmx_get_nested_state()
>> validation. Otherwise kvm_put_nested_state() can fail with -EINVAL when
>> a vCPU is in VMX operation and enters SMM mode. This leads to live
>> migration failure.
>>
>> Signed-off-by: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
>> ---
>> target/i386/kvm/kvm.c | 13 +++++++++----
>> 1 file changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
>> index e7c054cc16..cd635c9142 100644
>> --- a/target/i386/kvm/kvm.c
>> +++ b/target/i386/kvm/kvm.c
>> @@ -4741,6 +4741,15 @@ int kvm_arch_put_registers(CPUState *cpu, int level)
>>          return ret;
>>      }
>>
>> +    /*
>> +     * must be before kvm_put_nested_state so that HF_SMM_MASK is set during
>> +     * SMM.
>> +     */
>> +    ret = kvm_put_vcpu_events(x86_cpu, level);
>> +    if (ret < 0) {
>> +        return ret;
>> +    }
>> +
>>      if (level >= KVM_PUT_RESET_STATE) {
>>          ret = kvm_put_nested_state(x86_cpu);
>>          if (ret < 0) {
>> @@ -4787,10 +4796,6 @@ int kvm_arch_put_registers(CPUState *cpu, int level)
>>      if (ret < 0) {
>>          return ret;
>>      }
>> -    ret = kvm_put_vcpu_events(x86_cpu, level);
>> -    if (ret < 0) {
>> -        return ret;
>> -    }
>>      if (level >= KVM_PUT_RESET_STATE) {
>>          ret = kvm_put_mp_state(x86_cpu);
>>          if (ret < 0) {
>> -- 
>> 2.41.0
>>
> 
> 

