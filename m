Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16F6D539AA9
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 03:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348928AbiFABMp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 21:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240650AbiFABMn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 21:12:43 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11E663EF2D;
        Tue, 31 May 2022 18:12:42 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id l20-20020a17090a409400b001dd2a9d555bso580909pjg.0;
        Tue, 31 May 2022 18:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=xIc8vKaLouPdrAGwycSV3iqi6uAw0jqRjpdZCe8jdQg=;
        b=KayP+NHs68NgsnxUicSOzNeWi2rMsI2wtWd4yhq33x3aepkDohE9rvkva9Gt0XXrtK
         O9cjq/7kM300WT3PFxPKW9heT0cj8m3swZ5S3hdNzitKUcA0Dsf4kfINoynKEV2RO43F
         Zhizy/zTsImROeHVlVRRjqjRq3MHi7W+m2db1JFjP9na4Ynp+DvNgsDkXl7rQMA+3xUT
         Umn0AkdjEj/FCIVlm7Zarn3zcrt2Ry53KBclQ1DBgKO5EhETUsJHMlki+fyar0ZX5uE+
         03CXcgf0KnZvWjYCTVSeEKixYWjf1cEp5WN5iSRpHDQgC2gjP6ewbs8zAWmhjd8KWAqR
         rxQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xIc8vKaLouPdrAGwycSV3iqi6uAw0jqRjpdZCe8jdQg=;
        b=wjBP1fkWkOBko393QvKMtej37vRFre/dXW8L0cPwRlHNXXkvv0Pb66bFYerg/8wl6t
         4jIVbTaLmeaL8NKaWhLWJ7TZorK0oBE+RMQXcAQJsu24WFD4G7GCSfGNJnaBBL7Okv4+
         bkEIkEJKL4XsLFLSE9kSm5hP4eNyroWLDauOQfk7UjA2iqNYQhevIUG3KiHrE7uZTJBl
         N9TftP2raJ/0FTMPqv4vbLwH46fgPPIr4MSmYcz3XW+Js9CV46AghOjpSRSWts6FCqVe
         /u+SsuIO1fP3aaQPnV7W3Kpwj/mzqdd8ZNcyHp9SyjGwyw6qS7K9lRomvq0d1jFJx1BK
         hb9g==
X-Gm-Message-State: AOAM530CNniRLAyIE5VZ/ZRWLjw4hy3ULBKU+V6Ko5OPh1+XI9krct2M
        bh5PYQ+cHjUI4XOaoOPvSzbYeURTbGAC+A==
X-Google-Smtp-Source: ABdhPJzBTm4jFwx1uFy6txMaheAyzpdXKcH/GVIw5nFjJ++9zCM9cTMObQ97iryt8E828tJkrXeLbg==
X-Received: by 2002:a17:90b:4c8c:b0:1df:c760:e4af with SMTP id my12-20020a17090b4c8c00b001dfc760e4afmr31820843pjb.78.1654045961262;
        Tue, 31 May 2022 18:12:41 -0700 (PDT)
Received: from [192.168.255.10] ([203.205.141.24])
        by smtp.gmail.com with ESMTPSA id cj5-20020a056a00298500b0050dc7628180sm79891pfb.90.2022.05.31.18.12.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 May 2022 18:12:40 -0700 (PDT)
Message-ID: <32d83b5d-fda2-ee98-abcb-514459b1af03@gmail.com>
Date:   Wed, 1 Jun 2022 09:12:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH 2/2] KVM: x86: always allow host-initiated writes to PMU
 MSRs
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
References: <20220531175450.295552-1-pbonzini@redhat.com>
 <20220531175450.295552-3-pbonzini@redhat.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20220531175450.295552-3-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/6/2022 1:54 am, Paolo Bonzini wrote:
>   	switch (msr) {
>   	case MSR_CORE_PERF_FIXED_CTR_CTRL:
>   	case MSR_CORE_PERF_GLOBAL_STATUS:
>   	case MSR_CORE_PERF_GLOBAL_CTRL:
>   	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
> -		ret = pmu->version > 1;
> +		if (host_initiated)
> +			return true;
> +		return pmu->version > 1;

I was shocked not to see this style of code:

	return host_initiated || other-else;

>   		break;
>   	case MSR_IA32_PEBS_ENABLE:
> -		ret = perf_capabilities & PERF_CAP_PEBS_FORMAT;
> +		if (host_initiated)
> +			return true;
> +		return perf_capabilities & PERF_CAP_PEBS_FORMAT;
>   		break;
>   	case MSR_IA32_DS_AREA:
> -		ret = guest_cpuid_has(vcpu, X86_FEATURE_DS);
> +		if (host_initiated)
> +			return true;
> +		return guest_cpuid_has(vcpu, X86_FEATURE_DS);
>   		break;
>   	case MSR_PEBS_DATA_CFG:
> -		ret = (perf_capabilities & PERF_CAP_PEBS_BASELINE) &&
> +		if (host_initiated)
> +			return true;
> +		return (perf_capabilities & PERF_CAP_PEBS_BASELINE) &&
>   			((perf_capabilities & PERF_CAP_PEBS_FORMAT) > 3);
>   		break;
>   	default:
> -		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
> +		if (host_initiated)
> +			return true;

All default checks will fall in here.

Considering the MSR addresses of different groups are contiguous,
how about separating this part of the mixed statement may look even clearer:

+       case MSR_IA32_PERFCTR0 ... (MSR_IA32_PERFCTR0 + INTEL_PMC_MAX_GENERIC - 1):
+               return host_initiated || get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0);
+       case MSR_IA32_PMC0 ... (MSR_IA32_PMC0 + INTEL_PMC_MAX_GENERIC -1 ):
+               return host_initiated || get_fw_gp_pmc(pmu, msr);
+       case MSR_P6_EVNTSEL0 ... (MSR_P6_EVNTSEL0 + INTEL_PMC_MAX_GENERIC - 1):
+                       return host_initiated || get_gp_pmc(pmu, msr, 
MSR_P6_EVNTSEL0);
+       case MSR_CORE_PERF_FIXED_CTR0 ... (MSR_CORE_PERF_FIXED_CTR0 + 
KVM_PMC_MAX_FIXED - 1):
+               return host_initiated || get_fixed_pmc(pmu, msr);

> +		return get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
>   			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
>   			get_fixed_pmc(pmu, msr) || get_fw_gp_pmc(pmu, msr) ||
>   			intel_pmu_is_valid_lbr_msr(vcpu, msr);
>   		break;
>   	}
