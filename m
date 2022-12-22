Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D36CD653E97
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 11:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235345AbiLVK6D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 05:58:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiLVK6B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 05:58:01 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A06C127B26;
        Thu, 22 Dec 2022 02:58:00 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id m4so1688285pls.4;
        Thu, 22 Dec 2022 02:58:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BQ65Wuy2Ffah6muHIzqbWK2EKC4tPg+naEqJO+ia0yM=;
        b=HBez5EbWSJ1ooy4OMX115jGthCcFKSayh6XiGRKbLnlxelwp+EOL28Fn1xnoBqkw5Q
         TPe00qsyl5epv4RbdeCyvKA60MDvZEKzqMY8M3uSEcumnkxaZtyeiEow3v9pNHwukBZI
         AfLDwcupkAfFk2dxXWRz7bQsbdbm948d8dS6RhHWwP28qvK9JG07ZVF1Zb0dzJ+d5TvF
         IKPbKstl63L0M4DLVLwLeTfi7JjU3t3h3zN61cHQoDo86UtlJGaeNdMpXG38FPPkG99L
         UtCr10PGxGGHg1VR10uKzVUNuHTMGflrHLmKvY/Hd5Ao1nQESruPI7ZtOTFscHiKDeSr
         GCXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BQ65Wuy2Ffah6muHIzqbWK2EKC4tPg+naEqJO+ia0yM=;
        b=ZiIX17repHh4e9i9NEsJdjIoSgu7H+XYPfoC6HxTfl3BiAUEy/NTidpHo2FQCvcDW1
         huiocM5UfLwSoRRtiq6F0VGKszQM1+yGwaJLzyZQ6OereGhSri96z0nSIfLmtq+O07yz
         QNNVVXB9Quot4Fz1nWjDWvFjT9bd6vj72ywuotV9n32NSxyFdp2Lqpu3IuanMKehgVAT
         0XnJ+eGIPiK9wlmfIReSU8irePLBJQJ6jSFHl45SH8S79mo4fuO76qgPtpjFHt3k/i8L
         HsIDigGZEyplyWh6MTLG/ksY0PBaF99gDGFIDqEHxbtewY3X5NpJCuuta7HhPmgT4o9S
         0VHg==
X-Gm-Message-State: AFqh2kpwlrngxXA9DHJM9I9b5N3PaZKck6X/mFwYSidjt+uZt0eK27+e
        MCunUZL2mP24r2EpHNA+XVbZeH9CcAW0sIU9
X-Google-Smtp-Source: AMrXdXvKbG1FWTUF9V0DD/9x0jLUqmM4Lny8tBUQLnCUObpezjno3bDcbhuDwqhOPB6kxdZkAiy71Q==
X-Received: by 2002:a17:90a:4f43:b0:223:fd4d:8b23 with SMTP id w3-20020a17090a4f4300b00223fd4d8b23mr5963544pjl.0.1671706680139;
        Thu, 22 Dec 2022 02:58:00 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id v3-20020a17090ac90300b00218a7808ec9sm417974pjt.8.2022.12.22.02.57.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Dec 2022 02:57:59 -0800 (PST)
Message-ID: <449b561a-7053-8994-bcfe-581c0abb8d85@gmail.com>
Date:   Thu, 22 Dec 2022 18:57:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.0
Subject: Re: [PATCH v2 01/15] perf/x86/lbr: Simplify the exposure check for
 the LBR_INFO registers
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     kan.liang@linux.intel.com, wei.w.wang@intel.com,
        Like Xu <like.xu@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        "Paolo Bonzini - Distinguished Engineer (kernel-recipes.org) (KVM HoF)" 
        <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yang Weijiang <weijiang.yang@intel.com>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <20221125040604.5051-2-weijiang.yang@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20221125040604.5051-2-weijiang.yang@intel.com>
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

Hi Peter, would you help apply this one in your tip/perf tree,
as it doesn't seem to be closely tied to the KVM changes. Thanks.

On 25/11/2022 12:05 pm, Yang Weijiang wrote:
> From: Like Xu <like.xu@linux.intel.com>
> 
> The x86_pmu.lbr_info is 0 unless explicitly initialized, so there's
> no point checking x86_pmu.intel_cap.lbr_format.
> 
> Cc: Peter Zijlstra <peterz@infradead.org>
> Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
> Reviewed-by: Andi Kleen <ak@linux.intel.com>
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>   arch/x86/events/intel/lbr.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
> index 4dbde69c423b..e7caabfa1377 100644
> --- a/arch/x86/events/intel/lbr.c
> +++ b/arch/x86/events/intel/lbr.c
> @@ -1606,12 +1606,10 @@ void __init intel_pmu_arch_lbr_init(void)
>    */
>   void x86_perf_get_lbr(struct x86_pmu_lbr *lbr)
>   {
> -	int lbr_fmt = x86_pmu.intel_cap.lbr_format;
> -
>   	lbr->nr = x86_pmu.lbr_nr;
>   	lbr->from = x86_pmu.lbr_from;
>   	lbr->to = x86_pmu.lbr_to;
> -	lbr->info = (lbr_fmt == LBR_FORMAT_INFO) ? x86_pmu.lbr_info : 0;
> +	lbr->info = x86_pmu.lbr_info;
>   }
>   EXPORT_SYMBOL_GPL(x86_perf_get_lbr);
>   
