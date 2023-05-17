Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B06E706080
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 08:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbjEQG47 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 02:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjEQG46 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 02:56:58 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A0A10DB
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 23:56:55 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1ae3f6e5d70so5082005ad.1
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 23:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684306615; x=1686898615;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SSdqBD1fw8AVbrIyzoHZVJ5yPRyXwDl+l2FnMq86oJ8=;
        b=noRgmiSgy3XFMzpyHKoGXlFv8a21BCJHNm7x7rf9nQFQA1CrxM078Rf1Oz1yOgHP0P
         7GU7ZiHwqXb58nxwEnnQjOeHUIWzrMnWv8j7sHqjrQ8OLrqX13kxSNhcfFqPVBjl48c9
         viIhYssgaN2jPKJ+JNGWq4P4n9BQBtHKCPHuzaD6y5apkxdgdJtpHappqzFFYeVcIzbE
         iiRbjZlaO2XRmoCNy7sCc8ZrFfsUzBUDuUKRAz5oyrpjkR4XCKxDzF5E44H0YmuIJxfM
         xdQ1K2SMzZto8EtuW1iCdIGXYsGeyrg8Vnx0pZgyPekNmGecfCHiB9GxyTWe5ozeP5Bp
         bXxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684306615; x=1686898615;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SSdqBD1fw8AVbrIyzoHZVJ5yPRyXwDl+l2FnMq86oJ8=;
        b=AYkly/wfEz8OhRRsupGwdHQ3M+GbScfBTLbSGTeh0GQnyIESRsLAiGmUugUFxGCN1G
         J7xpxNnklPPtsD/YB2EqIKRVrsIVQx8qNkxzT3Qo5ye1p+WIsH5HkA1gkTXIuZZHqpWY
         4BxQ1TXt1NyFeRbytoW9xhPmyxR3Fk2K5laZaypke6j1lT0tGRulMD7wKSV0iL2n25VP
         qs/9O6ROC6Lmw05iRPUGPdRs3FVzQffGEr9VkpR60B1ksn19vYH7hSWLwzw4kjM52QBA
         s6JuPOHFtFUjVH5/apIc/vdgLv4lRm7scKVFeDnT/T8SUfEMmanXkBVWI+XmP1o3GTM+
         dcag==
X-Gm-Message-State: AC+VfDyzKx+8QOAuw0oRNm1S20SAhr35BWSBhKOVOooaMmPYtrUZT7xh
        I2hafN1EQYUuDT4VqJ3mW6Z+PSGx8Oo16A==
X-Google-Smtp-Source: ACHHUZ79IefVyWIF/YGkVddBBKeSFeFNJFl/anbw+rNS8B8pT/gJMmUOTStj61uuO7FKteXR32NeRQ==
X-Received: by 2002:a17:903:234e:b0:1ac:a9c1:b61d with SMTP id c14-20020a170903234e00b001aca9c1b61dmr33580479plh.11.1684306615249;
        Tue, 16 May 2023 23:56:55 -0700 (PDT)
Received: from [172.27.232.61] (ec2-16-163-40-128.ap-east-1.compute.amazonaws.com. [16.163.40.128])
        by smtp.gmail.com with ESMTPSA id ij25-20020a170902ab5900b001a67759f9f8sm1344430plb.106.2023.05.16.23.56.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 May 2023 23:56:54 -0700 (PDT)
Message-ID: <99ecf014-4741-57c3-8e0e-3928f43bba25@gmail.com>
Date:   Wed, 17 May 2023 14:56:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [Bug 217423] New: TSC synchronization issue in VM restore
To:     bugzilla-daemon@kernel.org, kvm@vger.kernel.org
References: <bug-217423-28872@https.bugzilla.kernel.org/>
Content-Language: en-US
From:   Robert Hoo <robert.hoo.linux@gmail.com>
In-Reply-To: <bug-217423-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/9/2023 10:01 PM, bugzilla-daemon@kernel.org wrote:
> Hi
> 
> We are using lightweight VM with snapshot feature, the VM will be saved with
> 100ms+, and we found restore such VM will not get correct TSC, which will make
> the VM world stop about 100ms+ after restore (the stop time is same as time
> when VM saved).
> 
> After Investigation, we found the issue caused by TSC synchronization in
> setting MSR_IA32_TSC. In VM save, VMM (cloud-hypervisor) will record TSC of
> each
> VCPU, then restore the TSC of VCPU in VM restore (about 100ms+ in guest time).
> But in KVM, setting a TSC within 1 second is identified as TSC synchronization,
> and the TSC offset will not be updated in stable TSC environment, this will
> cause the lapic set up a hrtimer expires after 100ms+, 

Can elaborate more on this hrtimer issue/code path?

> the restored VM now will
> in stop state about 100ms+, if no other event to wake guest kernel in NO_HZ
> mode.
> 
> More investigation show, the MSR_IA32_TSC set from guest side has disabled TSC
> synchronization in commit 0c899c25d754 (KVM: x86: do not attempt TSC
> synchronization on guest writes), now host side will do TSC synchronization
> when
> setting MSR_IA32_TSC.
> 
> I think setting MSR_IA32_TSC within 1 second from host side should not be
> identified as TSC synchronization, like above case, VMM set TSC from host side
> always should be updated as user want.

This is heuristics, I think; at the very beginning, it was 5 seconds.
Perhaps nowadays, can we have some deterministic approach to identify a 
synchronization? e.g. add a new VM ioctl?
> 
> The MSR_IA32_TSC set code is complicated and with a long history, so I come
> here
> to try to get help about whether my thought is correct. Here is my fix to solve
> the issue, any comments are welcomed:
> 
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ceb7c5e9cf9e..9380a88b9c1f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2722,17 +2722,6 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu,
> u64 data)
>                           * kvm_clock stable after CPU hotplug
>                           */
>                          synchronizing = true;
> -               } else {
> -                       u64 tsc_exp = kvm->arch.last_tsc_write +
> -                                               nsec_to_cycles(vcpu, elapsed);
> -                       u64 tsc_hz = vcpu->arch.virtual_tsc_khz * 1000LL;
> -                       /*
> -                        * Special case: TSC write with a small delta (1
> second)
> -                        * of virtual cycle time against real time is
> -                        * interpreted as an attempt to synchronize the CPU.
> -                        */
> -                       synchronizing = data < tsc_exp + tsc_hz &&
> -                                       data + tsc_hz > tsc_exp;
>                  }
>          }
> 
This hunk of code is indeed historic and heuristic. But simply removing it 
isn't the way.
Is the interval between your "save VM" and "restore VM" less than 1s?

An alternative, I think, is to bypass this directly write IA32_MSR_TSC way 
to set/sync TSC offsets, but follow new approach introduced in your VMM by

commit 828ca89628bfcb1b8f27535025f69dd00eb55207
Author: Oliver Upton <oliver.upton@linux.dev>
Date:   Thu Sep 16 18:15:38 2021 +0000

     KVM: x86: Expose TSC offset controls to userspace

...

Documentation/virt/kvm/devices/vcpu.rst:

4.1 ATTRIBUTE: KVM_VCPU_TSC_OFFSET

:Parameters: 64-bit unsigned TSC offset

...

Specifies the guest's TSC offset relative to the host's TSC. The guest's
TSC is then derived by the following equation:

   guest_tsc = host_tsc + KVM_VCPU_TSC_OFFSET

The following describes a possible algorithm to use for this purpose
...


