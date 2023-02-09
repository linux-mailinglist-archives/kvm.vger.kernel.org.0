Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61281691228
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 21:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbjBIUib (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 15:38:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbjBIUi2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 15:38:28 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D34366EF0
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 12:38:01 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id az16so2257126wrb.1
        for <kvm@vger.kernel.org>; Thu, 09 Feb 2023 12:38:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QJr+4EpYTTFs+E9ANXNPhW823UAlULlMXH5uzAvSjck=;
        b=KBUryG+0wgeLUa1/gB37sANKxijfAuSu1wqXnHepZlhPkL4pl0weRa5Lf09izQWERj
         xj8Fj0h6SzxsLg6EywcfeYM113oJ2E26Kn3B+pAlkHf5fI4pAG/cRlIqFyWDgIf3Igjk
         mBVSbRxXqrhK3UkmhyO+MXC619kbmVwNq5I2pvCYAe7hHZgTtq2HoiarubosHdcNLqWx
         UYvHPwlqmtcc13sp+jh8fY5+UIM7RaAyQ3zzrhbHvEhgW6XoOIyTGZ7ydlkF7C2OxxAp
         ZEdVaaxwimIm40MBIkhcVevV6ypBHhrUsUBwLKcCPj+ZARrilBY9pRNNObo4quPwdI4Y
         63aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QJr+4EpYTTFs+E9ANXNPhW823UAlULlMXH5uzAvSjck=;
        b=Ib5uWXxVnkfey/gGP9GunGJwi9KiNZscySol4TEibetNj69EDxwc3Qb3DHTimdjIJP
         rCRHhczqt4wStaS1a8zOkNrge7Je07VPll03VfIyq1TJ8UzV8NQiCBcJIPFxPbxIjpiu
         IeOrhRrTBU+/YYG1ghhcRT201NmfB3wI/mRW5d5ik1dOCu6EtC1S4fUh0mP+SbpEkGvg
         HWxvXNAWEt/IpkTmh0HO1VbR1B5CH9lUr/4xch91CCL+qrQu1/3QZ2OMXVvNI165B4bM
         Dox0yGe7qmeZZqlIf1d5g+E6YBQvQxhQCcdsNuDmeyKf6UtGefnM9AIYtu95MRnGyHR5
         2m8g==
X-Gm-Message-State: AO0yUKUEPeBHxwksAhQ1J55zILnBmkN8V+VVxygM7Wm8Bh09PYH5GVJT
        /d3+z+3dd2WXJWLoI4Z3/eANjg==
X-Google-Smtp-Source: AK7set/qiE/GEm5Mr2h9yLcJ2r9EgpDKeRcKrXxVBIUNr7+EUaTcjTxVxJS9A8KlfY0cYJG+FRgVDw==
X-Received: by 2002:a5d:61cb:0:b0:2bc:67d:c018 with SMTP id q11-20020a5d61cb000000b002bc067dc018mr11751494wrv.48.1675975079724;
        Thu, 09 Feb 2023 12:37:59 -0800 (PST)
Received: from ?IPV6:2a02:6b6a:b566:0:8009:2525:9580:8db2? ([2a02:6b6a:b566:0:8009:2525:9580:8db2])
        by smtp.gmail.com with ESMTPSA id a4-20020adfeec4000000b002bfc0558ecdsm1925004wrp.113.2023.02.09.12.37.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Feb 2023 12:37:59 -0800 (PST)
Message-ID: <b7643e5b-520d-0c4c-75ea-0cb65a2dbd42@bytedance.com>
Date:   Thu, 9 Feb 2023 20:37:58 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [External] Re: [PATCH v8 6/9] x86/smpboot: Support parallel
 startup of secondary CPUs
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>, dwmw2@infradead.org,
        kim.phillips@amd.com
Cc:     arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        David Woodhouse <dwmw@amazon.co.uk>
References: <20230209154156.266385-1-usama.arif@bytedance.com>
 <20230209154156.266385-7-usama.arif@bytedance.com> <87r0uy1ysm.ffs@tglx>
From:   Usama Arif <usama.arif@bytedance.com>
In-Reply-To: <87r0uy1ysm.ffs@tglx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 09/02/2023 18:25, Thomas Gleixner wrote:
> On Thu, Feb 09 2023 at 15:41, Usama Arif wrote:
>>   
>> +static bool do_parallel_bringup = true;
> 
> Wants to be __ro_after_init
> 
>> +static int __init no_parallel_bringup(char *str)
>> +{
>> +	do_parallel_bringup = false;
>> +
>> +	return 0;
>> +}
>> +early_param("no_parallel_bringup", no_parallel_bringup);
> 
> Lacks an entry in Documentation/admin/kernel-parameters.txt
> 
> Thanks,
> 
>          tglx


Thanks, I will add the below to next revision. Its quite minor so will 
wait for more comments and MTRR question to be resolved, unless told to 
send next revision with this diff only.

diff --git a/Documentation/admin-guide/kernel-parameters.txt 
b/Documentation/admin-guide/kernel-parameters.txt
index 6cfa6e3996cf..d3696c9316f1 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3830,6 +3830,9 @@
         noreplace-smp   [X86-32,SMP] Don't replace SMP instructions
                         with UP alternatives

+       no_parallel_bringup
+                       [X86,SMP] Disables parallel brinugp of secondary 
cores.
+
         noresume        [SWSUSP] Disables resume and restores original swap
                         space.

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 3ec5182d9698..fecd934e72fb 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -813,7 +813,7 @@ static int __init cpu_init_udelay(char *str)
  }
  early_param("cpu_init_udelay", cpu_init_udelay);

-static bool do_parallel_bringup = true;
+static bool do_parallel_bringup __ro_after_init = true;

  static int __init no_parallel_bringup(char *str)
  {
