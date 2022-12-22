Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF903653ED4
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 12:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235289AbiLVLPq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 06:15:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231892AbiLVLPn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 06:15:43 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B1F4B32;
        Thu, 22 Dec 2022 03:15:41 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id t2so1736623ply.2;
        Thu, 22 Dec 2022 03:15:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gpwsKuBdIKVc+8dUt36fJ7t12PQ33aLBPSMZVuaKlLc=;
        b=Cy5qUj8cfZFCcheO+YNLSBSRxvrMZgFJsfh7uL7F4TL3Ac+gHEDfUhzUH8NOnZynaF
         /snsGPxIG+4QzzocLydXEY2akp7SmF5AOTnAFnpRfDfDbdSbwUBi+lANr0R6WvH5b5qM
         ffDNuVz+270aTZDoWjII3naPjbbu7VecYH7FaN6jVB3mh5WjYpUUEMnZ8VjrVLrKqvyj
         T4mYKv0DCTsWq1B5Zc24qTOq8wG4PqoQpe4Utbo6+uKnUZV9WXjiZeNb+UvCVleMMkK+
         fBWeA/vIaHfHjYlrrPS35YgHSzDGdbKYkppl75DH+5cbZaZQ+Pw+pezCw9OOknQAUWsO
         JJ1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gpwsKuBdIKVc+8dUt36fJ7t12PQ33aLBPSMZVuaKlLc=;
        b=W4LbWYf1C8h+W7e1GQXorBvUn/jwyiWngR7pMnGcxwA4R7oTUhOo4KUp6SDzbXeXk6
         yS/fmXCRBHMCjxT3DIiEZMPBPRITd7J5oJrj+6tugnJ2LP1swYKQTRo2qYOUvUmAFYBq
         lEdonbhPQKyeRi13LT9YJQI2BhGOQJREBXjg2DJxacpEzsF28Q5kdJHSZk7y5M8nvp0V
         sS28ZoMrIWPW4botHbj/0eIO/guUcwMLkSjbAFEtb2owOX+t8czw5mKYW+jqFDXFb9Vv
         vKuOz63dKT+l1Opic5VwXHUppR3JojrfXwAn2UM4xPCNz4TmKorcLe6o64xou52JSErs
         fkCg==
X-Gm-Message-State: AFqh2kqUbTLDmcus9bGU2yqpWCFR274qD6GuSqIOuhCtaJkyLGUW5LMF
        9I3rOcqKrYPH4JxJ/juCCiM=
X-Google-Smtp-Source: AMrXdXu9XyChZ/kSUgcOcAeD6hIrXWzNMZCTgNRsqQ2lBG/IEoZFpJwH7ainSAs8ZlvRzEYFrVG7YA==
X-Received: by 2002:a17:903:264d:b0:189:2276:30c5 with SMTP id je13-20020a170903264d00b00189227630c5mr5394637plb.0.1671707741175;
        Thu, 22 Dec 2022 03:15:41 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id y16-20020a17090322d000b00188f8badbcdsm278419plg.137.2022.12.22.03.15.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Dec 2022 03:15:40 -0800 (PST)
Message-ID: <a7c09bc6-8d80-3028-1cea-ee355b41109d@gmail.com>
Date:   Thu, 22 Dec 2022 19:15:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.0
Subject: Re: [PATCH v2 05/15] KVM: vmx/pmu: Emulate MSR_ARCH_LBR_DEPTH for
 guest Arch LBR
Content-Language: en-US
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kan.liang@linux.intel.com, wei.w.wang@intel.com, seanjc@google.com,
        pbonzini@redhat.com, jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <20221125040604.5051-6-weijiang.yang@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20221125040604.5051-6-weijiang.yang@intel.com>
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
> +static bool cpuid_enable_lbr(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +	struct kvm_cpuid_entry2 *entry;
> +	int depth_bit;
> +
> +	if (!kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
> +		return !static_cpu_has(X86_FEATURE_ARCH_LBR) &&
> +			cpuid_model_is_consistent(vcpu);

Please add selftests to cover this incompatibility.

And running the SPR vcpu model on a GNR host, the guest arch lbr
should be fully supported as long as both hosts have the same lbr_depth.
