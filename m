Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 301B469DE25
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 11:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233504AbjBUKrh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 05:47:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbjBUKrg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 05:47:36 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93BF22795
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 02:47:33 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id l2-20020a05600c1d0200b003e1f6dff952so3143396wms.1
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 02:47:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jXmuQG1dfEVhegQET1ciyFk70lK4dL+yJdCWUFAYYoo=;
        b=zWqs3LwmNFHMn0sPIi+SBZ/YwimWwNG+h6h4ZtkRkt7tf6qZKJ7zPHZM1HmSapsMS9
         pBId8l1NBh6mUwaB+d1plb2miRGyGRBTn90I4QL0MYgABXQNC0ghvZps/2O9O0PbmH2W
         tDFOyn6ygdjXyaIP7T7WwSMVU3uhQhNrnELQSoFIIJ4FTmhyhDPNtTVO1i7MX/mr527n
         lPiNEQSVLMJSbv//nOh1kPGzQbV/VSIgUOjcUikQl62/YKC07LrNE8iFnMPqw0cArkN8
         UATNxX6lqTbeoTEiiwpaDkwvtEXOuS6K+UVcr7qJ147OPQgB776AJCxTxvXAKC6O8hqP
         Q65Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jXmuQG1dfEVhegQET1ciyFk70lK4dL+yJdCWUFAYYoo=;
        b=OuSR4VG5h/uonBjEwIcOK4gBRp8DWSD7QkkCT5rl+z6woHS+umICt3aoQGiITxnQdU
         yk19CzGJoj2H3XGeCMo53iPtx+4Dxlu3DKG9KIch0hYbobJnVN4NDHdz11YUbOq1BEki
         UsSZgOwhkwEm+H7nr9TbNZlBFvPsqMLp2t4APpNUsgAYai2KRvzfSqVEB2gQTjhue0c0
         CuaSm0CvFPutDll09uBneHvDxiNHMrkG1rgSdmr40eth4T79w0IywtixupiygJ2EY+uI
         0LBXSl1kkLW4Mn8AUp+gs8VLGW7pDh5/67MOuraS9RQyhYZ4Jii+IDYis7ejAhZFMaHb
         JT1g==
X-Gm-Message-State: AO0yUKWDeUIn4CksmbClnFYbZ/HJ8L27hGudNwUOanJqUhxfVgWDvlD1
        f/yHXKclFCLU4s/WCS3GqFVmkg==
X-Google-Smtp-Source: AK7set+7mvOb5btarvLZ2cXo2greZPvSxLs876lUjAVTVgLdO9MppHKbeNLt044pvoGfSDZFxp1WYw==
X-Received: by 2002:a05:600c:198e:b0:3df:9858:c037 with SMTP id t14-20020a05600c198e00b003df9858c037mr3131536wmq.12.1676976452180;
        Tue, 21 Feb 2023 02:47:32 -0800 (PST)
Received: from ?IPV6:2a02:6b6a:b566:0:8498:f303:14d8:47b5? ([2a02:6b6a:b566:0:8498:f303:14d8:47b5])
        by smtp.gmail.com with ESMTPSA id n3-20020a1c7203000000b003dc522dd25esm4608714wmc.30.2023.02.21.02.47.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 02:47:31 -0800 (PST)
Message-ID: <d91f96eb-86a1-c794-761d-a96e39076b13@bytedance.com>
Date:   Tue, 21 Feb 2023 10:47:31 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [External] Re: [PATCH v9 0/8] Parallel CPU bringup for x86_64
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>
Cc:     Kim Phillips <kim.phillips@amd.com>, tglx@linutronix.de,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>,
        Piotr Gorski <piotrgorski@cachyos.org>
References: <20230215145425.420125-1-usama.arif@bytedance.com>
 <ed8d662351cfe5793f8cc7e7e8c514d05d16c501.camel@infradead.org>
 <2668869.mvXUDI8C0e@natalenko.name>
 <2a67f6cf18dd2c1879fad9fd8a28242918d3e5d2.camel@infradead.org>
 <982e1d6140705414e8fd60b990bd259a@natalenko.name>
 <715CBABF-4017-4784-8F30-5386F1524830@infradead.org>
 <67dbc69f-b712-8971-f1c9-5d07f506a19c@amd.com>
 <42dc683e2846ae8fc1e09715aaf7884660e1a386.camel@infradead.org>
 <37c18c3aeea2e558633b6da6886111d0@natalenko.name>
 <5A3B7074-0C6D-472B-803B-D76541828C1F@infradead.org>
 <3d8ed6e157df10c5175c636de0e21849@natalenko.name>
 <5c557f9b6f55dc2a612ee89142971298e6ae12d8.camel@infradead.org>
 <ee0d0d971a3095d6a1e96ad4f1ba32d2@natalenko.name>
 <5b8f9c89f7015fa80c966c6c7f6fa259db6744f8.camel@infradead.org>
 <ce731b5a4a53680b4840467977b33d9a@natalenko.name>
 <85ceb3f92abf3c013924de2f025517372bed19c0.camel@infradead.org>
 <3e5944de08ef0d23584d19bad7bae66c@natalenko.name>
 <26E5DC9C-0F19-4E4F-9076-04506A197374@infradead.org>
From:   Usama Arif <usama.arif@bytedance.com>
In-Reply-To: <26E5DC9C-0F19-4E4F-9076-04506A197374@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 21/02/2023 10:27, David Woodhouse wrote:
> 
> 
> On 21 February 2023 09:49:51 GMT, Oleksandr Natalenko <oleksandr@natalenko.name> wrote:
>> On 21.02.2023 10:06, David Woodhouse wrote:
>>> Why does arch/x86/kernel/acpi/sleep.c::x86_acpi_suspend_lowlevel() set
>>>
>>>      initial_gs = per_cpu_offset(smp_processor_id()) ?
>>>
>>> Would it not be CPU#0 that comes back up, and should it not get
>>> per_cpu_offset(0) ?
>>
>> Wanna me try `initial_gs = per_cpu_offset(0);` too?
> 

I think it might be smp_processor_id() and not 0 incase CPU0 was offline 
at the point the system was suspended?

> Hm, yes please. There's another one to make zero on the next line up, I think?
> 
>>> Or maybe we should just set up smpboot_control for the CPU to find its
>>> own stuff, *even* on waking. Since the structures are already set up,
>>> it isn't like a clean boot.
>>>
>>> If you let it boot in parallel mode, what if you just *remove* the line
>>> that sets smpboot_control=0 ?
>>
>> If the `smpboot_control = 0;` line in arch/x86/kernel/acpi/sleep.c::x86_acpi_suspend_lowlevel() is commented out, and the system is booted in parallel mode, then suspend/resume works.
> 
> Well that's entertaining. Now, can we come up with any theory which doesn't leave us wondering why it ever worked in the first place...?
