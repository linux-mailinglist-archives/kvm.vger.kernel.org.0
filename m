Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3885F5017F0
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 18:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245384AbiDNPw1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 11:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244187AbiDNPi1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 11:38:27 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C48102A27F;
        Thu, 14 Apr 2022 08:15:58 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id c190-20020a1c35c7000000b0038e37907b5bso6212283wma.0;
        Thu, 14 Apr 2022 08:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=XsqTqLkugnBvqYjkKxNnUI1wcLv9BGValT596llmCYU=;
        b=jNxJb4hv+jK+H7pc0ZcQ/w2lMqB/5HYjF44vYxPhVvrxcsoLUy9gjgiKp/5ChWh20f
         TCoLRdR3mjQM9sxZbmLBjozoJFIM6276z2+oxpgiCmZqc1ucjFz+7fArDg0YkM1pVMwf
         IosDdC5sGL3kxBaHAosuofLXAZjvEp8KMyXvqPkmDYO+hno21LZnPF2s/fbI1D+Fu53g
         b+Z2nuyrfFRAYLwqaGM/Kkn0/OMXE8kqokiGIxmyk7KUcRA1oAH1scBYi9Se42PYzuNv
         6yOZBZYVzrXvRM0gt3Cz26HwOOCDdPNb9JN8GDtZe4P21xNhns+rmH9NTYfnyhmM6vpM
         i3FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XsqTqLkugnBvqYjkKxNnUI1wcLv9BGValT596llmCYU=;
        b=wRxHZfl55Wh6V65RDOkV0or4IsbomqeEK1L0MDtOQ2zs2YCrry/zNsOj1FULNkwH/T
         HOKZzEUtJ2xguW40On0DLzeE9e/3iQlz2ZgFI3aPXdOJ7wac4vjXYYyzHjSgCx75FEVQ
         GONN42rI7mqZkXvhCJllW0Mesob6jPQPLEwngbfCWvKuqMPJGKpktq5WMPKVgtVuherA
         zztNRIxaURoVQTeEVL4qzMFdtSdBLdxRWfAGvlj8lNCC2zNKJonFiOC1CtSZ0XKgnOgx
         2czcvH2/mEtNOJ99ocxsHTCuMpNhCc3g3YiCgszZvbYZOU05sAq0aqHng6ZxKBVRmfnk
         WTcw==
X-Gm-Message-State: AOAM532LgJpwTNW6TMVfwTpdJaZQWXHNsFRF0TCq053VB9dSp8cQyzCM
        2rmLDIHe5D+Ks4YrwRsBLGs=
X-Google-Smtp-Source: ABdhPJycB+Y5sEJjd8AoMIjUoXTPawNZMIKOdRkwxy5iZGTZ8YrwC4qby0DPf8MDpd1fbqMX+afNww==
X-Received: by 2002:a05:600c:3585:b0:38e:be0e:8471 with SMTP id p5-20020a05600c358500b0038ebe0e8471mr3736537wmq.30.1649949357188;
        Thu, 14 Apr 2022 08:15:57 -0700 (PDT)
Received: from [192.168.0.210] (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.googlemail.com with ESMTPSA id q16-20020a1ce910000000b0038eabd31749sm2747109wmc.32.2022.04.14.08.15.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Apr 2022 08:15:56 -0700 (PDT)
Message-ID: <e32f16a0-f963-be9e-906a-e8995ea60ca2@gmail.com>
Date:   Thu, 14 Apr 2022 16:15:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] KVM: VMX: make read-only const array vmx_uret_msrs_list
 static
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220414100720.295502-1-colin.i.king@gmail.com>
 <YlgyJPRVNCe4w8q3@google.com>
From:   "Colin King (gmail)" <colin.i.king@gmail.com>
In-Reply-To: <YlgyJPRVNCe4w8q3@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/04/2022 15:39, Sean Christopherson wrote:
> On Thu, Apr 14, 2022, Colin Ian King wrote:
>> Don't populate the read-only array vmx_uret_msrs_list on the stack
>> but instead make it static. Also makes the object code a little smaller.
> 
> Why not put it on the stack?  It's an __init function, i.e. called once in the
> lifetime of kvm-intel.ko, isn't all that big, and is certainly not performance
> critical.  And making it static begs the question of whether or not the data gets
> thrown away after init, i.e. this might consume _more_ memory once KVM has reached
> steady state.

Doh, my bad, I forgot to check that it was an __init function. Please 
discard this patch.

Colin

> 
>> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
>> ---
>>   arch/x86/kvm/vmx/vmx.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index c654c9d76e09..36429e2bb918 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -7871,7 +7871,7 @@ static __init void vmx_setup_user_return_msrs(void)
>>   	 * but is never loaded into hardware.  MSR_CSTAR is also never loaded
>>   	 * into hardware and is here purely for emulation purposes.
>>   	 */
>> -	const u32 vmx_uret_msrs_list[] = {
>> +	static const u32 vmx_uret_msrs_list[] = {
>>   	#ifdef CONFIG_X86_64
>>   		MSR_SYSCALL_MASK, MSR_LSTAR, MSR_CSTAR,
>>   	#endif
>> -- 
>> 2.35.1
>>

