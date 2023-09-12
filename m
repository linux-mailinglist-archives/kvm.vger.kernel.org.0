Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7BDD79CFB3
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 13:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234444AbjILLT2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 07:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233867AbjILLTX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 07:19:23 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B6D7B3
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 04:19:19 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id 46e09a7af769-6bf01bcb1aeso3892478a34.3
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 04:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694517558; x=1695122358; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7Y3V9U3MiwZNBieDOndWGj7Opd222WISjT8X2wjlyTs=;
        b=PFCaW7tpfU2roDc49GT09OvKraEzyXl2b3IpFr2hutkhpKC1X+/0gP0I6xS4wSp5OK
         BUlwSW6T2/SyTcOmfo6LlyGRmcsvskmnx0onJbuRZevrL/ZU8GoQGLhmeW9FwR0j0Bnl
         ZNivKheUAZ/9kZbHs9Os9vCDvTzJ9tYoTmE5Uhun1E/JYqQM8o3BRRov08bD/ExYDChp
         sxMHSYD1RVSD/GvJdfRwK0nrZfhKWuSBuUvfzVBf5CU5oXxjgccd5JoCUzMffmTsDNI/
         X48GNMJVUKzLk3UTszpqEUhg9R7a3I4dPqR5bktgwkFE/gri0KMT2L8QB87enwsDZJQp
         rfyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694517558; x=1695122358;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7Y3V9U3MiwZNBieDOndWGj7Opd222WISjT8X2wjlyTs=;
        b=IH8kMNrRBRfZRPB35bOJvr+R00fQu8PQQa8knZ/Xs6qZcH0ep+cYXJxNpuhhtXrcdN
         F1aYcCNi6liWa4pcsFmnftQ2wRqPZdLAl0OYlvDKsdWb/JDPKpp/48vl4KEocYiclLs8
         gdgLpeataZhF3v2ANS1KI9MHtw/pcbzovb8lZFnknudazrt+l0qtxWY5pr0+m8VQ6e+q
         Dqdk2YmtqWX6qlCZ5kPlHbVTHIndClr5ozSmhDDCAGx1C65Myp/zSahlmgaBdFx37KIe
         lREeb/sSD7MgEiouwY5j7RCfhr/4+OqXzoK34fx/Et1/Ntrm+DbznBZwZxEmrxwVmV6H
         D7GA==
X-Gm-Message-State: AOJu0Yx14nCmWa5zhjLz4SIkwOgT/y2aE6jX6rRsMIEFOe2RwzRDjtP+
        CGatJDE1rusXSSBsfy9FjAc=
X-Google-Smtp-Source: AGHT+IEltiddWzg+7ZcDOYwtOlCn2GVUrJ4r8pn0UMIR3d24/je7mFP/zTvfdlHty7VCC/LwkQEJNw==
X-Received: by 2002:a9d:6f15:0:b0:6b8:6785:ed0b with SMTP id n21-20020a9d6f15000000b006b86785ed0bmr14110292otq.30.1694517558282;
        Tue, 12 Sep 2023 04:19:18 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id v11-20020aa7808b000000b006884549adc8sm7118935pff.29.2023.09.12.04.19.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Sep 2023 04:19:17 -0700 (PDT)
Message-ID: <e0dea9df-501e-acd2-a81b-b5126ddc7be0@gmail.com>
Date:   Tue, 12 Sep 2023 19:19:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH 8/9] KVM: x86/pmu: Upgrade pmu version to 5 on intel
 processor
Content-Language: en-US
To:     Xiong Zhang <xiong.y.zhang@intel.com>
Cc:     seanjc@google.com, zhiyuan.lv@intel.com, zhenyu.z.wang@intel.com,
        kan.liang@intel.com, dapeng1.mi@linux.intel.com,
        kvm@vger.kernel.org
References: <20230901072809.640175-1-xiong.y.zhang@intel.com>
 <20230901072809.640175-9-xiong.y.zhang@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20230901072809.640175-9-xiong.y.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/9/2023 3:28 pm, Xiong Zhang wrote:
> Modern intel processors have supported Architectural Performance
> Monitoring Version 5, this commit upgrade Intel vcpu's vPMU
> version from 2 to 5.
> 
> Go through PMU features from version 3 to 5, the following
> features are not supported:
> 1. AnyThread counting: it is added in v3, and deprecated in v5.
> 2. Streamed Freeze_PerfMon_On_PMI in v4, since legacy Freeze_PerMon_ON_PMI
> isn't supported, the new one won't be supported neither.
> 3. IA32_PERF_GLOBAL_STATUS.ASCI[bit 60]: Related to SGX, and will be
> emulated by SGX developer later.
> 4. Domain Separation in v5. When INV flag in IA32_PERFEVTSELx is used, a
> counter stops counting when logical processor exits the C0 ACPI C-state.
> First guest INV flag isn't supported, second guest ACPI C-state is vague.
> 
> When a guest enable unsupported features through WRMSR, KVM will inject
> a #GP into the guest.
> 
> Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
> ---
>   arch/x86/kvm/pmu.h | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index 4bab4819ea6c..8e6bc9b1a747 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -215,7 +215,10 @@ static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
>   		return;
>   	}
>   
> -	kvm_pmu_cap.version = min(kvm_pmu_cap.version, 2);

For AMD as of now, the kvm_pmu_cap.version will not exceed 2.
Thus there's no need to differentiate between Intel and AMD.

> +	if (is_intel)
> +		kvm_pmu_cap.version = min(kvm_pmu_cap.version, 5);
> +	else
> +		kvm_pmu_cap.version = min(kvm_pmu_cap.version, 2);
>   	kvm_pmu_cap.num_counters_gp = min(kvm_pmu_cap.num_counters_gp,
>   					  pmu_ops->MAX_NR_GP_COUNTERS);
>   	kvm_pmu_cap.num_counters_fixed = min(kvm_pmu_cap.num_counters_fixed,
