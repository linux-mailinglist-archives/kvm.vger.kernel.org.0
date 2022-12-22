Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26356653EFE
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 12:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235471AbiLVLYb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 06:24:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbiLVLYa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 06:24:30 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7053E0D;
        Thu, 22 Dec 2022 03:24:29 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id fy4so1645426pjb.0;
        Thu, 22 Dec 2022 03:24:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LWK1UZD15pC86of5uFnIDc94rM103F7ouYNED5rDSeM=;
        b=fUR2kPUmZet+6oP0omTAhR/kmNyrMw9X4qpmj4WvKQKks35uABLMj2IHOgw3aZG1sT
         NaiqOyaK0jctXKNa7y684kEEEqb5b6vHz3i8zTmw2NN6lc8MZQeCaMqzv7oSgAFZ/cig
         dxUk5Acnt6HjP4UN7g9mmN4jwGqet0oQFx9dtoteLU9Y6gf9fTmUlhvGFQg9mFE4f/m3
         1ee8LcAN/+AARasdfIcvVPS2Ce9LqcxzfmIRT3tioNnRxPwddUcp2YJJYFsUplsWP/v5
         feCNoREZaCGC8zKsDm94kbOlDKEOmrzu0yFNFGfmE/KYOIib6Km0ub+fZgS3MNDlsn4O
         PQNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LWK1UZD15pC86of5uFnIDc94rM103F7ouYNED5rDSeM=;
        b=sx3tp72Fa6SnzZUmgKZxCwshf6XXF1itRkhnyopOe6wVtnBJOZAKgGwlnXe8//FQi5
         5qTudLGu+Yuqpq8pJrb9NmrjARgGW+ycpYHyu6otozDf8vZI/Xzs15QZG2tHs0JOkvuR
         ktc37G+LnJjWj2WtZ5FNHq1Rps7u33zMVvkDMU1fF7k+HAJPIcKChfdPNvzzxe+qSHun
         KwvDBtRp7BdrFbhZUXyjmE9iwa2bqVBZpKqwfFPnEKLT5nJn5yQ7bE5fgbbwj+wWeJS+
         c0eVuLa6C41YYIEfJHrw3+eqMM3qUi1KaiLuGRl7+BLqx/3vgSY1ilXbtVXqu2Nw3w5J
         JuIA==
X-Gm-Message-State: AFqh2kqiJhWRY3tXPSuoPkOS4iwRwmBwPP0p5g1u7JU3ZhRq2HDLH4/H
        +o1n7I/Veg13AIo98VR7tWQ=
X-Google-Smtp-Source: AMrXdXspSBvYC0XfvtGNtDvFKRz76MChnIu54o0XWk5BUrvQyI1y3460dN8EjNseAplFZ2S5KWgLSw==
X-Received: by 2002:a17:90a:eb03:b0:225:b9df:c4a3 with SMTP id j3-20020a17090aeb0300b00225b9dfc4a3mr770472pjz.3.1671708269509;
        Thu, 22 Dec 2022 03:24:29 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id om15-20020a17090b3a8f00b00218fba260e2sm2984207pjb.43.2022.12.22.03.24.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Dec 2022 03:24:29 -0800 (PST)
Message-ID: <03fd9d59-16da-9b93-74bb-593937eae941@gmail.com>
Date:   Thu, 22 Dec 2022 19:24:22 +0800
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
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index cea8c07f5229..1ae2efc29546 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2120,6 +2120,13 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   						VM_EXIT_SAVE_DEBUG_CONTROLS)
>   			get_vmcs12(vcpu)->guest_ia32_debugctl = data;
>   
> +		/*
> +		 * For Arch LBR, IA32_DEBUGCTL[bit 0] has no meaning.
> +		 * It can be written to 0 or 1, but reads will always return 0.
> +		 */

The comment looks good, please verify it with a test.

> +		if (guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
> +			data &= ~DEBUGCTLMSR_LBR;
> +
>   		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
>   		if (intel_pmu_lbr_is_enabled(vcpu) && !to_vmx(vcpu)->lbr_desc.event &&
>   		    (data & DEBUGCTLMSR_LBR))
