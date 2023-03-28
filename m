Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4C8C6CBBDB
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 12:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232663AbjC1KFS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 06:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232745AbjC1KE6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 06:04:58 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 948FE6180;
        Tue, 28 Mar 2023 03:04:56 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id lr16-20020a17090b4b9000b0023f187954acso11957658pjb.2;
        Tue, 28 Mar 2023 03:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679997896;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tj+JNRYSlmpI8qc8/QJIucmB+4IxZS7FjZc7hG2oNPs=;
        b=fOegfL1/FdAwtPzd5RlErl3s4iL5bstKSKXsJsFpn4CnC4hUSmhZ9Bha5u/NsV5mY4
         j7onHQb3tTJfvlm534eoE0xqQGi4V1sfvYcpIHtcLKKdUl7WCflUDMDZ3oRRIkUU5xpt
         j18SZ3+t7Bova2API9Du695XzAX7pnxdr0O2F2wlZGKLgROmDNxDBt853Oec3+zdFlMX
         vhbtq7G4CIL3tY+Z+csTxEKgOmVuHKvT5oLinfk+S+w5m4ksHJ0uZLOzGTu4Vr65ctex
         J6c6nQ4rJoQO5dFfeayl8E6eygCm1ZQRG8LKGi2pOSucLuRlJU355mZkZfCfnbigzd20
         ftDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679997896;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tj+JNRYSlmpI8qc8/QJIucmB+4IxZS7FjZc7hG2oNPs=;
        b=a/gO/AmhEkbLqiLi8ngMvDip23IaCHaxqeR8pwjdI5OBQ/uMWIs/ZA8d3VjHNugrCQ
         CrJq/Q+SbvrRMWEm3szy56JJzMARFjZBciXLwVjPLcP5OcLgAc8/LOtln4gx1/dd8P9/
         RGnYXTu1RNKv1ioTQ5AMsCo1sgV0kYvFI6ySnqCga+gdpuGjIO98aBPmTsQIC2sYGdiK
         P4WI5xPV7P0A2g9RtPcIUznpCunI7YBSKnRgdNo/DRvKBaFnN+Hf8dElRLY/bB5zdrsS
         BHz8mJ/RvuA2ae6Gcj/+xEFvKHTEnSDhbJXNjThOS93ZbqdzZbRlbhmoxVT5hRMYykXg
         CvbA==
X-Gm-Message-State: AO0yUKUjheTOor7JpMWUUVuQWTDXAJQIYnzf29srZ9g92Dxn2jeWO0Vk
        iqQTFORL61AY83TQB9pR7Ug=
X-Google-Smtp-Source: AK7set/WDWKYpU+87FgYc0gxbbhEXX09YA9uvLztEHtpn+0SbnVY/NVFP2yh0jpDuEYXF49nqxRAXg==
X-Received: by 2002:a05:6a20:47e2:b0:da:adbf:7b96 with SMTP id ey34-20020a056a2047e200b000daadbf7b96mr12428939pzb.21.1679997895936;
        Tue, 28 Mar 2023 03:04:55 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id j11-20020a62e90b000000b005825b8e0540sm3031187pfh.204.2023.03.28.03.04.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Mar 2023 03:04:55 -0700 (PDT)
Message-ID: <7e84bfb4-b052-4c31-a319-1ea2dd52ae54@gmail.com>
Date:   Tue, 28 Mar 2023 18:04:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH v2] KVM: x86/pmu: Fix emulation on Intel counters' bit
 width
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230322093117.48335-1-likexu@tencent.com>
 <CABgObfYfiUDf4zY=izcg_32yGCbUxxVc+JAkHGHwiQ0VmGdOgA@mail.gmail.com>
 <871434fe-ae80-bec6-9920-a6411f5842c0@gmail.com>
 <fce5c1ad-24a3-febf-127e-e97238492143@redhat.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <fce5c1ad-24a3-febf-127e-e97238492143@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/3/2023 5:20 pm, Paolo Bonzini wrote:
> On 3/28/23 11:16, Like Xu wrote:
>>
>>
>> If IA32_PERF_CAPABILITIES.FW_WRITE[bit 13] =1, each IA32_PMCi is accompanied by a
>> corresponding alias address starting at 4C1H for IA32_A_PMC0.
>>
>> The bit width of the performance monitoring counters is specified in 
>> CPUID.0AH:EAX[23:16].
>> If IA32_A_PMCi is present, the 64-bit input value (EDX:EAX) of WRMSR to 
>> IA32_A_PMCi will cause
>> IA32_PMCi to be updated by:
>>
>>      COUNTERWIDTH =
>>          CPUID.0AH:EAX[23:16] bit width of the performance monitoring counter
>>      IA32_PMCi[COUNTERWIDTH-1:32] := EDX[COUNTERWIDTH-33:0]);
>>      IA32_PMCi[31:0] := EAX[31:0];
>>      EDX[63:COUNTERWIDTH] are reserved
>>
>> ---
>>
>> Some might argue that this is all talking about GP counters, not
>> fixed counters. In fact, the full-width write hw behaviour is
>> presumed to do the same thing for all counters.
> But the above behavior, and the #GP, is only true for IA32_A_PMCi (the 
> full-witdh MSR).  Did I understand correctly that the behavior for fixed 
> counters is changed without introducing an alias MSR?
> 
> Paolo
> 

If true, why introducing those alias MSRs ? My archaeological findings are:

a platform w/o full-witdh like Westmere (has 3-fixed counters already) is 
declared to
have a counter width (R:48, W:32) and its successor Sandy Bridge has (R:48 , W: 
32/48).

Thus I think the behaviour of the fixed counter has changed from there, and the 
alias GP MSRs
were introduced to keep the support on 32-bit writes on #GP counters (via 
original address).

[*] Intel® 64 and IA-32 Architectures Software Developer’s Manual Documentation 
Changes
(252046-030, January 2011) Table 30-18 Core PMU Comparison.
