Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD82752A8E3
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 19:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351328AbiEQRHm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 13:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234852AbiEQRHk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 13:07:40 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413FF2D1F6
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 10:07:38 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id g6so35962341ejw.1
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 10:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7yBvEiWolXOYz605CKb+au7LCxmgtojgmI+zQ1JdS3s=;
        b=Asxj1he34HyEy91pPXXDjBat+ostamfI5AmE0Q4E8pXyYgJ9JMUp+hO0Q2VI0su27P
         EOa0k3AKVUGOjk8dC+DmxNOmxw4YNhFZtvzI4URLWXs2yV3M4c0DCrHBaGEkMkrocEZg
         0UnFw3cG0YCXp499+wmJxXRNI50vr+swXmo8k1uKvmQcIJF/lGptgifVQ0VnbB7eLuWI
         1iSCylNeNnziOSvBwaBMBg7zzUtUNrIZHmOXKzQeJnY/Zz5kLh4f5GPyki7aDt0QPz4u
         KV1AiH2O9RzdHkks+wxFY+gALxMRRd6jS0acQbhKdEVDGMmvqSnJ3dzlyU1qHYQpdeOh
         KREQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7yBvEiWolXOYz605CKb+au7LCxmgtojgmI+zQ1JdS3s=;
        b=B8CWW7t14y1xgcjos+NGZZ+Plk8de/sV+7/XXsqiACyyrf1QT/IWv9NK41HFn1SwY1
         jGVJXt1eSNMe6LoHjAOFyf3I80Yjnp4ylhsQYZKEVFGiMK/GYeB+Dw3Gvd9zpLw+mknj
         soufVvJ5yJY8pQQzvobonO8dG/XDt2KRfA/5Smmnnfgc9TO8xx6p0O4g0KlsGLCwWe88
         15EYnxctCpeZzjcsJiZTpf346M61dLrwxnfPYFYwe96EU0EvMMbEX5oqBGs1/Uryhmkk
         aXtHtp35vwMgq9S5wg2g6XrGT3SVbCkkziOsfr2bOt5NjukoPkw7h2Tr2JtXmhAHrn2h
         xr+w==
X-Gm-Message-State: AOAM530UR0ASFAtqxXiJkAvl0BPRF/lvS1jmoqaYfvwtaXARvhp1Ph0s
        QjmWEqeBWPaj68RW+iU3GlQ=
X-Google-Smtp-Source: ABdhPJzc2JYeZjVqpQmq6X/D1vCwbT/+4IS6aQOqUYlvJJirsx4X6zYyWlGIdUmjHjBPKTnQHZb/3Q==
X-Received: by 2002:a17:906:5d05:b0:6f6:6353:c325 with SMTP id g5-20020a1709065d0500b006f66353c325mr20685907ejt.749.1652807256713;
        Tue, 17 May 2022 10:07:36 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id el8-20020a170907284800b006f3ef214e73sm1242420ejc.217.2022.05.17.10.07.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 May 2022 10:07:36 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <9c1f1218-136c-6a73-4c3a-813f2597fb3c@redhat.com>
Date:   Tue, 17 May 2022 19:07:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] target/i386: Remove LBREn bit check when access Arch LBR
 MSRs
Content-Language: en-US
To:     Yang Weijiang <weijiang.yang@intel.com>,
        richard.henderson@linaro.org, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
References: <20220517155024.33270-1-weijiang.yang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220517155024.33270-1-weijiang.yang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/17/22 17:50, Yang Weijiang wrote:
> Live migration can happen when Arch LBR LBREn bit is cleared,
> e.g., when migration happens after guest entered SMM mode.
> In this case, we still need to migrate Arch LBR MSRs.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>   target/i386/kvm/kvm.c | 21 +++++++++------------
>   1 file changed, 9 insertions(+), 12 deletions(-)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index a9ee8eebd7..e2d675115b 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -3373,15 +3373,14 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>               int i, ret;
>   
>               /*
> -             * Only migrate Arch LBR states when: 1) Arch LBR is enabled
> -             * for migrated vcpu. 2) the host Arch LBR depth equals that
> -             * of source guest's, this is to avoid mismatch of guest/host
> -             * config for the msr hence avoid unexpected misbehavior.
> +             * Only migrate Arch LBR states when the host Arch LBR depth
> +             * equals that of source guest's, this is to avoid mismatch
> +             * of guest/host config for the msr hence avoid unexpected
> +             * misbehavior.
>                */
>               ret = kvm_get_one_msr(cpu, MSR_ARCH_LBR_DEPTH, &depth);
>   
> -            if (ret == 1 && (env->msr_lbr_ctl & 0x1) && !!depth &&
> -                depth == env->msr_lbr_depth) {
> +            if (ret == 1 && !!depth && depth == env->msr_lbr_depth) {
>                   kvm_msr_entry_add(cpu, MSR_ARCH_LBR_CTL, env->msr_lbr_ctl);
>                   kvm_msr_entry_add(cpu, MSR_ARCH_LBR_DEPTH, env->msr_lbr_depth);
>   
> @@ -3801,13 +3800,11 @@ static int kvm_get_msrs(X86CPU *cpu)
>   
>       if (kvm_enabled() && cpu->enable_pmu &&
>           (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR)) {
> -        uint64_t ctl, depth;
> -        int i, ret2;
> +        uint64_t depth;
> +        int i, ret;
>   
> -        ret = kvm_get_one_msr(cpu, MSR_ARCH_LBR_CTL, &ctl);
> -        ret2 = kvm_get_one_msr(cpu, MSR_ARCH_LBR_DEPTH, &depth);
> -        if (ret == 1 && ret2 == 1 && (ctl & 0x1) &&
> -            depth == ARCH_LBR_NR_ENTRIES) {
> +        ret = kvm_get_one_msr(cpu, MSR_ARCH_LBR_DEPTH, &depth);
> +        if (ret == 1 && depth == ARCH_LBR_NR_ENTRIES) {
>               kvm_msr_entry_add(cpu, MSR_ARCH_LBR_CTL, 0);
>               kvm_msr_entry_add(cpu, MSR_ARCH_LBR_DEPTH, 0);
>   
> 
> base-commit: 8eccdb9eb84615291faef1257d5779ebfef7a0d0

Queued, thanks.

Paolo
