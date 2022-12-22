Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 206A2653EF8
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 12:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235410AbiLVLWw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 06:22:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235133AbiLVLWv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 06:22:51 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938E612600;
        Thu, 22 Dec 2022 03:22:49 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id u4-20020a17090a518400b00223f7eba2c4so1539634pjh.5;
        Thu, 22 Dec 2022 03:22:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hLgs1lnetEyknU/J00Q9dg+rep4hDdlUeMLNhubrH7k=;
        b=jFpjvGje8T+CENNBBCN2AMF/9FIhSTWjz1wfo+HYkF/V9M9n8c1Zep6WmWwXmteyBu
         WLRLkAczJGuk9jipcgZtyx4DqKOs4Hf0bM2LFGWaZoUPeXxksmXJJDI9DCp6c2Mg3bBr
         2n8wX1Uv/7RMMNGpgIOGGZUji0uLPCgGQHsfzwDNpgZfTGiH9nUVCodrrC8pvLtbatv9
         oH76U9GZ/CA6pAdv4at+CgP8blvC5DFxA+leWHvdscSouvJ2+Dz+CwtB47vU9Bi/EH0/
         RgnzgU4qN2rMlQ7k3BzeBaucrjP/5lDYigb/AsDR5LaAIvaZmlQHcAajwdINCX2vC5hs
         jMWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hLgs1lnetEyknU/J00Q9dg+rep4hDdlUeMLNhubrH7k=;
        b=qL1mtRQDYbpoLQei9TXhv+DKc2wSha0mxe5dNkdx2baA6RTkRQuQqCgt/DGd4ddb+R
         DuVj2Hn2XA9Ubxd/GbjwzB0xsGUQv/l9l+InOcWwNGHK9DjfwVhH+aWSniVrMLeg0xt3
         9GDi6B0suwDAeBuyZ3fP49dIcLILzsxXlS/JyV6lssOvkdHmlS+OEsSFOnG8ZwTOoQHH
         LehMhcmV3h/Pxt5wgwP7p39HZK1EnmTi0APGge1uxJvidsf3xqQp+mtCieW3Jxu+9OAn
         bRrwyMBOV7GgUQvidUgcFczSiIWmRn/tt1CTOKip/I4fFzZNCVL6OAT5mFriMfVi2Vw0
         kiTg==
X-Gm-Message-State: AFqh2koDiO78RH3NkMw1pOrUJg9IjgEJlSWHpUd00kCjCTAgBJsp3JWp
        EGdEjMc5H7atq3nHooSNzIA=
X-Google-Smtp-Source: AMrXdXtDw4S2svhTHvYarWfBuWqpYWueLLxgbOGNu07nleRYG642JRNpHHVYWYza6grZUflq7Qd+Uw==
X-Received: by 2002:a17:90b:3711:b0:223:f7a6:1c1e with SMTP id mg17-20020a17090b371100b00223f7a61c1emr5783069pjb.31.1671708169146;
        Thu, 22 Dec 2022 03:22:49 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id n8-20020a17090a73c800b0021e1c8ef788sm2966940pjk.51.2022.12.22.03.22.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Dec 2022 03:22:48 -0800 (PST)
Message-ID: <195c26b7-783f-fc27-1a60-b0dcd1de01ac@gmail.com>
Date:   Thu, 22 Dec 2022 19:22:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.0
Subject: Re: [PATCH v2 12/15] KVM: x86/vmx: Disable Arch LBREn bit in #DB and
 warm reset
Content-Language: en-US
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kan.liang@linux.intel.com, wei.w.wang@intel.com, seanjc@google.com,
        pbonzini@redhat.com, jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <20221125040604.5051-13-weijiang.yang@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20221125040604.5051-13-weijiang.yang@intel.com>
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

On 25/11/2022 12:06 pm, Yang Weijiang wrote:
> +static void disable_arch_lbr_ctl(struct kvm_vcpu *vcpu)
> +{
> +	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +
> +	if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) &&
> +	    test_bit(INTEL_PMC_IDX_FIXED_VLBR, pmu->pmc_in_use) &&
> +	    lbr_desc->event) {
> +		u64 ctl = vmcs_read64(GUEST_IA32_LBR_CTL);
> +
> +		vmcs_write64(GUEST_IA32_LBR_CTL, ctl & ~ARCH_LBR_CTL_LBREN);
> +	}
> +}
> +
>   static void vmx_inject_exception(struct kvm_vcpu *vcpu)
>   {
>   	struct kvm_queued_exception *ex = &vcpu->arch.exception;
> @@ -1738,6 +1752,9 @@ static void vmx_inject_exception(struct kvm_vcpu *vcpu)
>   	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, intr_info);
>   
>   	vmx_clear_hlt(vcpu);
> +
> +	if (ex->vector == DB_VECTOR)
> +		disable_arch_lbr_ctl(vcpu);

Please verify this with KUT testcase, once I failed and did not confirm
if it is a hardware issue. Good Luck.

>   }
