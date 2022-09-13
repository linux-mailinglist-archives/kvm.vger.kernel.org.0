Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6887A5B6DA7
	for <lists+kvm@lfdr.de>; Tue, 13 Sep 2022 14:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbiIMMvM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Sep 2022 08:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232160AbiIMMvC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Sep 2022 08:51:02 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14AF052FF0
        for <kvm@vger.kernel.org>; Tue, 13 Sep 2022 05:50:59 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id m3so11221200pjo.1
        for <kvm@vger.kernel.org>; Tue, 13 Sep 2022 05:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=m+eZZoFLZFj4EhrhLyyE+g7R7dkUsiwp1ctUGIB8Xyc=;
        b=jGIh/hBBHB9qngcxAiPKVlNnWoA+4zhrJlHf/7cC6XoKAdqrYm5GcLRzVI69z0CV39
         /w+Q5i/tkVixk74+Fp4Lhjc8bBaLEBt9cSXeJzBNcWGk1bbmt29VXx+sb3d/UPOKmUs8
         jtRkKfovsQvEtIMaRisgVTCoGaJAv2JiZu7sapDlXUUZejKRyep20zGPtVQAb1dAtjVO
         WKha2N36Mc9SKwfEVzRvas+JtOgsGBDvIwik+fsnWhTupgkW+Pqr195kPR6g7BM4ZnZd
         Bct9AUdOeRH9TAsfLZeB06sIYcOcAirND6uDCVUvlUoMTIWP43dr1J+vIaudr10e4A6O
         G5Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=m+eZZoFLZFj4EhrhLyyE+g7R7dkUsiwp1ctUGIB8Xyc=;
        b=LGFZTV0nkXuVbFWcfr64Y/aLqB0ItKrFxYbbEZv8er3wft2ttZ9J4DwpgeP678OIgL
         GWRFuDWQUoaS/d4qefLrS03QU2slKCcjsJkVPAkbIox74F+zk9We1c8sbGYzFfFVJuLF
         O+wtSPVwQ/00E9ojs1u5z++WRWVmU2bagEFrX27RxP4MKPzAi3Fyz0KI76STXuWT3jFK
         AHfcaEMIfQ3E/g9vTDdLF6hhkRbQ/PhdIdNmUb1lhperSet+GGnivbPECqSF3k4sLOcj
         ZUZi3JaOxF44ax96U7CnIfNUiN6nCFrijsxaCRaCOZ3W53J1xstcfd+mzNSlYu6CyBqt
         XNYg==
X-Gm-Message-State: ACgBeo1CdK2rjFdtdntKcGK58iLLNGHGjO8AMSqgV0D20s4yLSuNwT9o
        HLwr4X78g2HMyUUeGKP+i8Stpg==
X-Google-Smtp-Source: AA6agR6b0dbrm/dWvV5TmvZeUsJCtL2b/PeHdCl4glygOlKhuTzGMSEz5loOjhBvm1OoAAz40VEAKw==
X-Received: by 2002:a17:902:c245:b0:178:3912:f1f7 with SMTP id 5-20020a170902c24500b001783912f1f7mr7946684plg.75.1663073458500;
        Tue, 13 Sep 2022 05:50:58 -0700 (PDT)
Received: from [192.168.10.153] (ppp121-45-204-168.cbr-trn-nor-bras38.tpg.internode.on.net. [121.45.204.168])
        by smtp.gmail.com with ESMTPSA id i12-20020a170902c94c00b00176da1aae5asm8419873pla.70.2022.09.13.05.50.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Sep 2022 05:50:57 -0700 (PDT)
Message-ID: <59dfb450-5a91-f27b-6edf-0adfa89729b7@ozlabs.ru>
Date:   Tue, 13 Sep 2022 22:50:49 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:104.0) Gecko/20100101
 Thunderbird/104.0
Subject: Re: [PATCH kernel] KVM: PPC: Make KVM_CAP_IRQFD_RESAMPLE platform
 dependent
Content-Language: en-US
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     kvm-ppc@vger.kernel.org
Cc:     x86@kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fabiano Rosas <farosas@linux.ibm.com>
References: <20220504074807.3616813-1-aik@ozlabs.ru>
 <0d4bb0fa-10c6-3f5a-34c8-293144b3fdbb@ozlabs.ru>
In-Reply-To: <0d4bb0fa-10c6-3f5a-34c8-293144b3fdbb@ozlabs.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping? It's been a while and probably got lost :-/

On 18/05/2022 16:27, Alexey Kardashevskiy wrote:
> 
> 
> On 5/4/22 17:48, Alexey Kardashevskiy wrote:
>> When introduced, IRQFD resampling worked on POWER8 with XICS. However
>> KVM on POWER9 has never implemented it - the compatibility mode code
>> ("XICS-on-XIVE") misses the kvm_notify_acked_irq() call and the native
>> XIVE mode does not handle INTx in KVM at all.
>>
>> This moved the capability support advertising to platforms and stops
>> advertising it on XIVE, i.e. POWER9 and later.
>>
>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>> ---
>>
>>
>> Or I could move this one together with KVM_CAP_IRQFD. Thoughts?
> 
> 
> Ping?
> 
>>
>> ---
>>   arch/arm64/kvm/arm.c       | 3 +++
>>   arch/mips/kvm/mips.c       | 3 +++
>>   arch/powerpc/kvm/powerpc.c | 6 ++++++
>>   arch/riscv/kvm/vm.c        | 3 +++
>>   arch/s390/kvm/kvm-s390.c   | 3 +++
>>   arch/x86/kvm/x86.c         | 3 +++
>>   virt/kvm/kvm_main.c        | 1 -
>>   7 files changed, 21 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 523bc934fe2f..092f0614bae3 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -210,6 +210,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, 
>> long ext)
>>       case KVM_CAP_SET_GUEST_DEBUG:
>>       case KVM_CAP_VCPU_ATTRIBUTES:
>>       case KVM_CAP_PTP_KVM:
>> +#ifdef CONFIG_HAVE_KVM_IRQFD
>> +    case KVM_CAP_IRQFD_RESAMPLE:
>> +#endif
>>           r = 1;
>>           break;
>>       case KVM_CAP_SET_GUEST_DEBUG2:
>> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
>> index a25e0b73ee70..0f3de470a73e 100644
>> --- a/arch/mips/kvm/mips.c
>> +++ b/arch/mips/kvm/mips.c
>> @@ -1071,6 +1071,9 @@ int kvm_vm_ioctl_check_extension(struct kvm 
>> *kvm, long ext)
>>       case KVM_CAP_READONLY_MEM:
>>       case KVM_CAP_SYNC_MMU:
>>       case KVM_CAP_IMMEDIATE_EXIT:
>> +#ifdef CONFIG_HAVE_KVM_IRQFD
>> +    case KVM_CAP_IRQFD_RESAMPLE:
>> +#endif
>>           r = 1;
>>           break;
>>       case KVM_CAP_NR_VCPUS:
>> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
>> index 875c30c12db0..87698ffef3be 100644
>> --- a/arch/powerpc/kvm/powerpc.c
>> +++ b/arch/powerpc/kvm/powerpc.c
>> @@ -591,6 +591,12 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, 
>> long ext)
>>           break;
>>   #endif
>> +#ifdef CONFIG_HAVE_KVM_IRQFD
>> +    case KVM_CAP_IRQFD_RESAMPLE:
>> +        r = !xive_enabled();
>> +        break;
>> +#endif
>> +
>>       case KVM_CAP_PPC_ALLOC_HTAB:
>>           r = hv_enabled;
>>           break;
>> diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
>> index c768f75279ef..b58579b386bb 100644
>> --- a/arch/riscv/kvm/vm.c
>> +++ b/arch/riscv/kvm/vm.c
>> @@ -63,6 +63,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, 
>> long ext)
>>       case KVM_CAP_READONLY_MEM:
>>       case KVM_CAP_MP_STATE:
>>       case KVM_CAP_IMMEDIATE_EXIT:
>> +#ifdef CONFIG_HAVE_KVM_IRQFD
>> +    case KVM_CAP_IRQFD_RESAMPLE:
>> +#endif
>>           r = 1;
>>           break;
>>       case KVM_CAP_NR_VCPUS:
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index 156d1c25a3c1..85e093fc8d13 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -564,6 +564,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, 
>> long ext)
>>       case KVM_CAP_SET_GUEST_DEBUG:
>>       case KVM_CAP_S390_DIAG318:
>>       case KVM_CAP_S390_MEM_OP_EXTENSION:
>> +#ifdef CONFIG_HAVE_KVM_IRQFD
>> +    case KVM_CAP_IRQFD_RESAMPLE:
>> +#endif
>>           r = 1;
>>           break;
>>       case KVM_CAP_SET_GUEST_DEBUG2:
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 0c0ca599a353..a0a7b769483d 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -4273,6 +4273,9 @@ int kvm_vm_ioctl_check_extension(struct kvm 
>> *kvm, long ext)
>>       case KVM_CAP_SYS_ATTRIBUTES:
>>       case KVM_CAP_VAPIC:
>>       case KVM_CAP_ENABLE_CAP:
>> +#ifdef CONFIG_HAVE_KVM_IRQFD
>> +    case KVM_CAP_IRQFD_RESAMPLE:
>> +#endif
>>           r = 1;
>>           break;
>>       case KVM_CAP_EXIT_HYPERCALL:
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 70e05af5ebea..885e72e668a5 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -4293,7 +4293,6 @@ static long 
>> kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>>   #endif
>>   #ifdef CONFIG_HAVE_KVM_IRQFD
>>       case KVM_CAP_IRQFD:
>> -    case KVM_CAP_IRQFD_RESAMPLE:
>>   #endif
>>       case KVM_CAP_IOEVENTFD_ANY_LENGTH:
>>       case KVM_CAP_CHECK_EXTENSION_VM:
> 

-- 
Alexey
