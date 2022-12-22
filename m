Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF966653EF3
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 12:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235555AbiLVLUb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 06:20:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235540AbiLVLUK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 06:20:10 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29E928E22;
        Thu, 22 Dec 2022 03:19:41 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id 79so1104586pgf.11;
        Thu, 22 Dec 2022 03:19:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ThY4jwNSz9WNz66c+Gq56mp1Xus1nRpZseDD/IIsQV8=;
        b=W9aekgtzzUojrEQMmQe9w5uoV6JsjF8UmP3nNWOUz2Spq80vENvlt4srFzThAUp9kM
         Aero3X/Uqgo6zPtZb3EUVGG6HNF399N9K7EhL0e8VcWs5XWPN75EaOYV1D6f3/brTi9Z
         ea++HoYMKIUJkRcTLgIGD70aYfd/4TCdc9fgVGmA8lyryXDO+92gwi7RdLBj0+6BVQ8g
         TLaNh9rXaM90V5lgdEzyHnAlCdCmgidq8EOG+MbkeGXAg3JhJODcDI1iBxMmmVfN6Y5m
         1Z5jr0hRdK/2UEMuEMruXtAOrI/PgJj1ADkXDwGzAvIGlt8i2yaqUPasze/5OH0rHBvK
         alJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ThY4jwNSz9WNz66c+Gq56mp1Xus1nRpZseDD/IIsQV8=;
        b=j3V+XM4K0/UATGQABe5bUOK+RDVJjUauVQwrUkgCaApWPRYeITjawUkDTA+r9Os0sS
         nr0RMAUNKmyueRgd5yIoVynASHX4ZEieUvOYTROPkPN2i+luMj0ij263lHFR2BuSQ/0C
         yKV/qJ/8gAjH3Ac8uY8YppVQzOjyjzA4Wi4/ssuHOa7prXLhu4u2c0HZ500K9CAdCT+y
         ou0s2aHsxwIARAZY66Meh+FwrT/jiwo3+HRwX16P+hsOcfr3ZIxf6Exn7Hf7mhbe0C2Z
         rzs0bFu/tiwUdhTuCA8dlXUIJBF/EI+XewEZBJWaUmVtOcQZwiOPyMtmW7KEQ8ThU6FW
         KX5g==
X-Gm-Message-State: AFqh2kpG489Av4+ybShHR0B9/hlSaWrtAl5wndg+FSGie0oqdYjPwCgr
        b7fBtbdEObmwYnXmL9zdSrqvubH52oS1jouP
X-Google-Smtp-Source: AMrXdXsveWQka6a2pqhiWu+zECyiBI1Db0UnrWJn8BNpqpdiQXuNbrNBklIGCxqeC2AhPyLRUkHHZA==
X-Received: by 2002:a62:1c16:0:b0:577:50c4:6dbe with SMTP id c22-20020a621c16000000b0057750c46dbemr5933362pfc.4.1671707980577;
        Thu, 22 Dec 2022 03:19:40 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id i127-20020a625485000000b005769cee6735sm493538pfb.43.2022.12.22.03.19.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Dec 2022 03:19:40 -0800 (PST)
Message-ID: <065de8d2-895e-9ee9-e3e5-16e79969508f@gmail.com>
Date:   Thu, 22 Dec 2022 19:19:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.0
Subject: Re: [PATCH v2 06/15] KVM: vmx/pmu: Emulate MSR_ARCH_LBR_CTL for guest
 Arch LBR
Content-Language: en-US
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kan.liang@linux.intel.com, wei.w.wang@intel.com, seanjc@google.com,
        pbonzini@redhat.com, jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <20221125040604.5051-7-weijiang.yang@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20221125040604.5051-7-weijiang.yang@intel.com>
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

On 25/11/2022 12:05 pm, Yang Weijiang wrote:
> @@ -727,12 +772,16 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
>    */
>   static void intel_pmu_legacy_freezing_lbrs_on_pmi(struct kvm_vcpu *vcpu)
>   {
> -	u64 data = vmcs_read64(GUEST_IA32_DEBUGCTL);
> +	u32 lbr_ctl_field = GUEST_IA32_DEBUGCTL;
>   
> -	if (data & DEBUGCTLMSR_FREEZE_LBRS_ON_PMI) {
> -		data &= ~DEBUGCTLMSR_LBR;
> -		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
> -	}
> +	if (!(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_FREEZE_LBRS_ON_PMI))
> +		return;
> +
> +	if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) &&
> +	    guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
> +		lbr_ctl_field = GUEST_IA32_LBR_CTL;
> +
> +	vmcs_write64(lbr_ctl_field, vmcs_read64(lbr_ctl_field) & ~0x1ULL);
>   }
>   
>   static void intel_pmu_deliver_pmi(struct kvm_vcpu *vcpu)

The legacy lbr test case in KUT does not cover this scenario, but
arch lbr contributor should take the opportunity to fill this gap. Thanks.
