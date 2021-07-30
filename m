Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF0003DB1F2
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 05:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235636AbhG3D20 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 23:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbhG3D20 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 23:28:26 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9EAC061765;
        Thu, 29 Jul 2021 20:28:21 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id g23-20020a17090a5797b02901765d605e14so12420652pji.5;
        Thu, 29 Jul 2021 20:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6fxIPUGmc8aYTwq2elCyCCUjCWH2ALc+Jb41KDZB5HE=;
        b=MT3/JNsmC25CT8hclGIMESqs0sLMSFfYife8cU29N+XQLPjet5SzzVYYqETdTbupJx
         5tgOibTCfYY2hqfLIARVFcuAEgpb0Hp0EPhC6e4e06PpSScXR1iIbz19hts2PFp8TUCd
         tL3UI4DiehsUWb+kS9r+qWCNnca9l8tf5uum+hXgOM/x9Fn4RyzRIyl4jQAthXqnawJD
         vQ8qc+O3tAxUSejZaOQs56HO5uCZ/JMPeGVdyvKpMmTUye0JuiQC/gMSTdYCAqSGMn7t
         TccTcIYWv5KtnXJRwKNwGSJjlg1d7qE0iF5aNgTWmahHopSI1z1n2CNVEtr/LEZFgFNM
         Kwrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6fxIPUGmc8aYTwq2elCyCCUjCWH2ALc+Jb41KDZB5HE=;
        b=E2vOv94JRNf35E+Vz5smXmKg2fG1u5GHJ03pYt2UUIjYw/3qLRHboTOu+Fuhp68RYf
         1rAyNFFXZfOhh8jG5WhxYUhk9pCsat5vCWZ1xqHlcGUhJSqUOUlONzFki4X7mlsWRPOR
         FB9WExZVNwayYQuQ3zUACjlknH/tzwdIlx6g6r4aZftlq0gOTCG4f18AjYpkY93JvZZ8
         3kKru4m5Fw43E9wDACDRy0/qAxHaHlmtRoO7m0qLAL3S8JQCxfr31Q2eWnIpH1LU4468
         MzVQ5/61xBERMNNGl34w9GOqCw2b5/u1x4zhbpHUKq3Kz60XruD044UGjiFF6rDBLZ+G
         GKDQ==
X-Gm-Message-State: AOAM531u0l88I8loLIckzy6fV5XYCV7Aor1SZc3u94YGCE8A3awm2h8q
        TXC6r25vEzUfj9x+EnLeRm0=
X-Google-Smtp-Source: ABdhPJzfOOCNHyXw6fzJo1WYPnFE93vosDJLa/UxSZ1bjIg9CT8/4snfe5sTCv7KLp7m/FeIVVR/Zw==
X-Received: by 2002:a62:ce44:0:b029:3aa:37f6:6fd6 with SMTP id y65-20020a62ce440000b02903aa37f66fd6mr425069pfg.59.1627615700627;
        Thu, 29 Jul 2021 20:28:20 -0700 (PDT)
Received: from Likes-MacBook-Pro.local ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id o9sm293845pfh.217.2021.07.29.20.28.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 20:28:20 -0700 (PDT)
To:     Liuxiangdong <liuxiangdong5@huawei.com>,
        Yang Weijiang <weijiang.yang@intel.com>
Cc:     ak@linux.intel.com, jmattson@google.com, joro@8bytes.org,
        kan.liang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        wei.w.wang@intel.com, x86@kernel.org,
        "Fangyi (Eric)" <eric.fangyi@huawei.com>,
        Xiexiangyou <xiexiangyou@huawei.com>, alex.shi@linux.alibaba.com
References: <20210201051039.255478-1-like.xu@linux.intel.com>
 <6102A1A5.90901@huawei.com> <61036EEC.4020006@huawei.com>
From:   Like Xu <like.xu.linux@gmail.com>
Subject: Re: [PATCH v14 00/11] KVM: x86/pmu: Guest Last Branch Recording
 Enabling
Message-ID: <c75f63f8-0274-967b-4431-6ee3c2a40a2f@gmail.com>
Date:   Fri, 30 Jul 2021 11:28:10 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <61036EEC.4020006@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/7/2021 11:15 am, Liuxiangdong wrote:
> Hi, like.
> 
> Does it have requirement on CPU if we want to use LBR in Guest?

As long as you find valid output from the "dmesg| grep -i LBR" like 
"XX-deep LBR",
you can use LBR on the host and theoretically on the most Intel guest.

But I don't have various Intel machine types for testing.

As far as I know, the guest LBR doesn't work on the platforms that
the MSR_LBR_SELECT is defined per physical core not logical core.

I will fix this issue by making KVM aware of the recent core scheduling 
policy.

> 
> I have tried linux-5.14-rc3 on different CPUs. And I can use lbr on 
> Haswell, Broadwell, skylake and icelake, but I cannot use lbr on IvyBridge.

I suppose INTEL_FAM6_IVYBRIDGE and INTEL_FAM6_IVYBRIDGE_X do support LBR.

You may check the return values from x86_perf_get_lbr() or
cpuid_model_is_consistent() in the KVM for more details.

> 
> Thanks!
> 
> 
> On 2021/7/29 20:40, Liuxiangdong wrote:
>> Hi, like.
>>
>> This patch set has been merged in 5.12 kernel tree so we can use LBR 
>> in Guest.
>> Does it have requirement on CPU?
>> I can use lbr in guest on skylake and icelake, but cannot on IvyBridge.
>>
>> I can see lbr formats(000011b) in perf_capabilities msr(0x345), but 
>> there is still
>> error when I try.
>>
>> $ perf record -b
>> Error:
>> cycles: PMU Hardware doesn't support sampling/overflow-interrupts. Try 
>> 'perf stat'
>>
>> Host CPU:
>> Architecture:                    x86_64
>> CPU op-mode(s):                  32-bit, 64-bit
>> Byte Order:                      Little Endian
>> Address sizes:                   46 bits physical, 48 bits virtual
>> CPU(s):                          24
>> On-line CPU(s) list:             0-23
>> Thread(s) per core:              2
>> Core(s) per socket:              6
>> Socket(s):                       2
>> NUMA node(s):                    2
>> Vendor ID:                       GenuineIntel
>> CPU family:                      6
>> Model:                           62
>> Model name:                      Intel(R) Xeon(R) CPU E5-2620 v2 @ 
>> 2.10GHz
>> Stepping:                        4
>>
>>
>> Thanks!
>> Xiangdong Liu
> 
