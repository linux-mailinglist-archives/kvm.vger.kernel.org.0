Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6856CB56B
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 06:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbjC1EbO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 00:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjC1EbL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 00:31:11 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E9C1BFE
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 21:31:08 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id l7so9703971pjg.5
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 21:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20210112.gappssmtp.com; s=20210112; t=1679977868;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IlAmBP3o3IBDo+zmv5lTsb9tkG3/yK4LL8I9KLZ3MN4=;
        b=cwWsuHPap/srSYgWbRrcYeIhNt8MkXsGo/yA4rl2A9AZ1VeqMLf5kkm0AXxGjbJP9i
         stPFThoZaFdla80lTX9q+yQmzC/0rRMo1yAGGvrIcZINJ/eYrtWVC1r5YOEYfClmzGhs
         /CpEgRO9zODRTos1bSJ+12TMZxDR364TLY1QzNOopoHwdtZizsg2NEwEQyktOFUoiU07
         B5cE2oo19qQuPUwWvbTkvhsgVCXPhSDIyMCygFq5k2YytWVXnCSxxlMibLb1CcdGtgP3
         IZHDHtYNArgQgWNfLD/Ip8x894otE2ehheixwB9KGPPzUwUyxIjTU4Xg+xFAn8i2h9Q/
         NukQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679977868;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IlAmBP3o3IBDo+zmv5lTsb9tkG3/yK4LL8I9KLZ3MN4=;
        b=kwH70sJegayhO/AHDK8nRkVzDsimpMuYVdMgaQ/AM3auWOpsJr1PS4jUq4ar+lKDs7
         aFKmqbIXzPWCT0lPG1wqfqD+e4RgpWEMdNvUAZTDvFYkB0MPoqZoqD+FQV1D7vL36w4B
         c64HY8dalc7zNnXx7adxTXAs2RvQXz/+jI0mEQJCJqec1RRp+yvUgDTDFQmy4i8VTuRK
         0B8/U1UaH5/cD/Mqq0P8qIf6kYPZ6kMGHignG7zzj5+ZJBbIZlIktP7Bm/N+SsPNUxcc
         0qzfBdtaXqy1wxrvFIDCNReoBbYwcS9boK83WzvF5qr4eesj8P6WtbkSsVNLC0i2z7/f
         /q+Q==
X-Gm-Message-State: AAQBX9e9+989nTOlAJyEXD766pyTw8ymyyMlwsKxWHothHNldUqTSPMF
        ok5QKfCQUQKRTPlxehQY4Xwffg==
X-Google-Smtp-Source: AKy350YfSlbkidbsLxSyaZOTsu/hKfDYr24mHSFiR975/0IwpT8nPk2RP7jqhH2NhuRZMCdwI1y9Wg==
X-Received: by 2002:a17:902:f34d:b0:1a1:eda9:6739 with SMTP id q13-20020a170902f34d00b001a1eda96739mr11291255ple.41.1679977867961;
        Mon, 27 Mar 2023 21:31:07 -0700 (PDT)
Received: from [192.168.10.153] (ppp118-208-169-253.cbr-trn-nor-bras39.tpg.internode.on.net. [118.208.169.253])
        by smtp.gmail.com with ESMTPSA id d3-20020a170902aa8300b001a245b49731sm3334778plr.128.2023.03.27.21.31.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 21:31:07 -0700 (PDT)
Message-ID: <67d99abd-19bd-8c01-2cac-80102878fa77@ozlabs.ru>
Date:   Tue, 28 Mar 2023 15:30:59 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:108.0) Gecko/20100101
 Thunderbird/108.0
Subject: Re: [PATCH kernel v4] KVM: PPC: Make KVM_CAP_IRQFD_RESAMPLE support
 platform dependent
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm-riscv@lists.infradead.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Anup Patel <anup@brainfault.org>, kvm-ppc@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
References: <20221003235722.2085145-1-aik@ozlabs.ru>
 <ZBH9fZ3aMnHKtrZj@google.com>
Content-Language: en-US
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <ZBH9fZ3aMnHKtrZj@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 16/03/2023 04:16, Sean Christopherson wrote:
> +Michael and KVM s390 maintainers
> 
> On Tue, Oct 04, 2022, Alexey Kardashevskiy wrote:
>> When introduced, IRQFD resampling worked on POWER8 with XICS. However
>> KVM on POWER9 has never implemented it - the compatibility mode code
>> ("XICS-on-XIVE") misses the kvm_notify_acked_irq() call and the native
>> XIVE mode does not handle INTx in KVM at all.
>>
>> This moved the capability support advertising to platforms and stops
>> advertising it on XIVE, i.e. POWER9 and later.
>>
>> This should cause no behavioural change for other architectures.
>>
>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>> Acked-by: Nicholas Piggin <npiggin@gmail.com>
>> Acked-by: Marc Zyngier <maz@kernel.org>
>> ---
> 
> If no one objects, I'll grab this for 6.4 and route it through kvm-x86/generic.
> >> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
>> index fb1490761c87..908ce8bd91c9 100644
>> --- a/arch/powerpc/kvm/powerpc.c
>> +++ b/arch/powerpc/kvm/powerpc.c
>> @@ -593,6 +593,12 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>                  break;
>>   #endif
>>
>> +#ifdef CONFIG_HAVE_KVM_IRQFD
>> +       case KVM_CAP_IRQFD_RESAMPLE:
>> +               r = !xive_enabled();
>> +               break;
>> +#endif
> 
> @PPC folks, do you want to avoid the #ifdef?  If so, I can tweak to this when
> applying.


I am not PPC folks anymore (this is just my backlog) but I do not see 
why not (get rid of ifdef), it is just that file uses #ifdef lot more 
than IS_ENABLED. Thanks,


> 	case KVM_CAP_IRQFD_RESAMPLE:
> 		r = IS_ENABLED(CONFIG_HAVE_KVM_IRQFD) && !xive_enabled();
> 		break;

-- 
Alexey
