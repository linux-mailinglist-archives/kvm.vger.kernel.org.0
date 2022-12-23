Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92514654B0B
	for <lists+kvm@lfdr.de>; Fri, 23 Dec 2022 03:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235997AbiLWCPr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 21:15:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235957AbiLWCP1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 21:15:27 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CDDC2657E;
        Thu, 22 Dec 2022 18:13:11 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id 78so2472765pgb.8;
        Thu, 22 Dec 2022 18:13:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Fv83sILRpdPDju6R9bwpPHliUEsFsFUyc/dbMvww/eY=;
        b=L9N/WyPIseuqFdRkaF/UjdKRVnKl/YPV+cw9Zzr/bVwG7U+pnmawxLFt6oC4GYfZl5
         5OTDOGp5Sv6kBdUxd4zxlFyP0arPQ1gP1iQU5C3tWa3iC/oFbAWDR8THSvihtlXzxR9w
         LPQU/52bv8JGe0H6X2Moysv/YJbnTsvmT2xphrTAerxfXuserbALUfdIZ08y3wEsFwYZ
         yD5hJUFCnZfk4w7OvL65caDFsKACCRa80ochQKr+zTLvHwu/ULv3pA+2kJ0dfLa88UDW
         SbVrWG6UAI5PBoy54k4PQ01awA3bLU1mfFLVinQKwFNe0/FwCSzjd05cBHVXyRwaLGoy
         reBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fv83sILRpdPDju6R9bwpPHliUEsFsFUyc/dbMvww/eY=;
        b=AVWzl2qoUmQjZax4qiTkwc/a9MzjlfUmHlSFKwCJ+ZQfl7l7MIVMLK/PmrCDHQfb+r
         UKrdre3I4eWx810d0JNh4bCBwKE6H6Ez8Lp8INPqYdS4hezqRSJO+JZjN3CljoNNj5VN
         OtOhQpeZ/PcJIQ96nuQGOHnQlRZB6BCIAG2IkaEse9riFLAG5xOFU9eUmMBJqVLZXt9t
         o6/TyQsEjkNO8IKfF3hYpfK09WUNVziv1Gm1yBAmjsiy9la+fMi+bZt0fFHU1mXlXR0x
         WdgMLsjnzWIBbep4jZ3Et0IyNOMY9B8rLBSm4M87QfLSgtHIyV9N5WbfsagdrAJgNtIU
         fr9Q==
X-Gm-Message-State: AFqh2kqxPv3OqwQm6AUgadtEbPhpVyEMfksBy/LlOPW5Nq4a1/m0JlJm
        i/cbFMOSjIkTYYUrjlagaXQ=
X-Google-Smtp-Source: AMrXdXuHlQaLGVeaQ6tC4E3lw5u7txRz+nS3SToycQ+iwH6FlwJZoMDxhM2TmgcpkbwagmAjZ9/MzQ==
X-Received: by 2002:aa7:9794:0:b0:577:f836:6bcb with SMTP id o20-20020aa79794000000b00577f8366bcbmr9694825pfp.29.1671761581818;
        Thu, 22 Dec 2022 18:13:01 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id p66-20020a622945000000b00561dcfa700asm1326991pfp.107.2022.12.22.18.12.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Dec 2022 18:13:01 -0800 (PST)
Message-ID: <f5196090-ce8b-43a7-bfb6-e060881b2ea2@gmail.com>
Date:   Fri, 23 Dec 2022 10:12:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.0
Subject: Re: [PATCH v2 01/15] perf/x86/lbr: Simplify the exposure check for
 the LBR_INFO registers
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     kan.liang@linux.intel.com, wei.w.wang@intel.com,
        Andi Kleen <ak@linux.intel.com>,
        "Paolo Bonzini - Distinguished Engineer (kernel-recipes.org) (KVM HoF)" 
        <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yang Weijiang <weijiang.yang@intel.com>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <20221125040604.5051-2-weijiang.yang@intel.com>
 <449b561a-7053-8994-bcfe-581c0abb8d85@gmail.com>
 <Y6SWxEZrIqDPD69l@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <Y6SWxEZrIqDPD69l@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/12/2022 1:41 am, Sean Christopherson wrote:
> On Thu, Dec 22, 2022, Like Xu wrote:
>> Hi Peter, would you help apply this one in your tip/perf tree,
>> as it doesn't seem to be closely tied to the KVM changes. Thanks.
>>
>> On 25/11/2022 12:05 pm, Yang Weijiang wrote:
>>> From: Like Xu <like.xu@linux.intel.com>
>>>
>>> The x86_pmu.lbr_info is 0 unless explicitly initialized, so there's
>>> no point checking x86_pmu.intel_cap.lbr_format.
>>>
>>> Cc: Peter Zijlstra <peterz@infradead.org>
>>> Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
>>> Reviewed-by: Andi Kleen <ak@linux.intel.com>
>>> Signed-off-by: Like Xu <like.xu@linux.intel.com>
>>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>>> ---
>>>    arch/x86/events/intel/lbr.c | 4 +---
>>>    1 file changed, 1 insertion(+), 3 deletions(-)
>>>
>>> diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
>>> index 4dbde69c423b..e7caabfa1377 100644
>>> --- a/arch/x86/events/intel/lbr.c
>>> +++ b/arch/x86/events/intel/lbr.c
>>> @@ -1606,12 +1606,10 @@ void __init intel_pmu_arch_lbr_init(void)
>>>     */
>>>    void x86_perf_get_lbr(struct x86_pmu_lbr *lbr)
>>>    {
>>> -	int lbr_fmt = x86_pmu.intel_cap.lbr_format;
>>> -
>>>    	lbr->nr = x86_pmu.lbr_nr;
>>>    	lbr->from = x86_pmu.lbr_from;
>>>    	lbr->to = x86_pmu.lbr_to;
>>> -	lbr->info = (lbr_fmt == LBR_FORMAT_INFO) ? x86_pmu.lbr_info : 0;
>>> +	lbr->info = x86_pmu.lbr_info;
> 
> This stable-worthy a bug fix, no?  E.g. won't the existing code misreport lbr->info
> if the format is LBR_FORMAT_INFO2?

Sure, we need "Cc: stable@vger.kernel.org" in order not to lose misprediction 
and cycles
information on the LBR_FORMAT_INFO2 platforms like Goldmont plus.

> 
>>>    }
>>>    EXPORT_SYMBOL_GPL(x86_perf_get_lbr);
