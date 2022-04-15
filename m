Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2CFE502B75
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 16:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354250AbiDOOIj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 10:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239553AbiDOOIh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 10:08:37 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C29A8167CE;
        Fri, 15 Apr 2022 07:06:08 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id l3-20020a05600c1d0300b0038ff89c938bso1562399wms.0;
        Fri, 15 Apr 2022 07:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=EzLDOe3HtxFMzXcfhfNSXtlOQrT0bfGxcqzSe9ECixQ=;
        b=GAcjlr6zA0G75G4NNXlH4fSIT3Idsieq5lqpMkUkAv0bKbY53A8uH846+fTRx48xkj
         9Go+wfLzEzwLV3NEZC85tAdaIpW6ioel9Ow9oKIDZjNVXFlndNPIgpZOxJ2Qr5fAeK5+
         PF/N6Q0lYVDkutISYrECTIUqMXHdh/Ti2OZfg+PDPImb6xPGBnl6QFwrdsxNBlfz5gAb
         DTbhJriEEpIRAnWqxoQaPyLuFeOTe+NIYWwUCymXuN0qNF00yNcOGm83s8X8ZW23gLIe
         z3qiEu61HELI9hP2Pz+M9JZSldqXNuwtc023a3RpjHT27I5ITWSrBsW8IDMGgKYzEhSy
         Xw6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=EzLDOe3HtxFMzXcfhfNSXtlOQrT0bfGxcqzSe9ECixQ=;
        b=ZQx0SPxfMtsewA7rHP+4hnEoyUkeLzR8hTd6yQJ1S4XFHc2XCtvdzhcvfpLHTDpSML
         l1drjCXgVEcFZGV6WnkCCPEjHdOTPoBh+EddDyDdlY+J5W78FhhYQqpr5FtgyXxFdN8f
         E1kzySMAhTKCCQWrNV439pmwJSIjn6nAepgbbzbRUfXQUu3Leme9STHU7e+zFwz0qBgf
         0JvJHH5QRC2mkCaapfu/cKYFEhYbir1pD8ayzZ6+CdKWGA8GKDwWR6y1VKUvyWpvkUee
         zQqqHUUJIDvU+wdwkB9tL2xJT50K244mX+3g41GPkgav0bfRtLuMt3CDHpzK3xiQ67v9
         3ATw==
X-Gm-Message-State: AOAM532tRGC4tedToDFppAWLwxbCrKRy0wkaMspZg6IpLMcYFa//Ygom
        ySkJJquGFTLcY0bEDUU7alM=
X-Google-Smtp-Source: ABdhPJyFYAfK6ihDKsSzKrWU1ZLqTGm5knNObVl/6HEFAVCW+WVRUn8vDUEhAAs/2anJpuF0MXNFPQ==
X-Received: by 2002:a05:600c:3b28:b0:38e:bb86:d68d with SMTP id m40-20020a05600c3b2800b0038ebb86d68dmr3436638wms.135.1650031567338;
        Fri, 15 Apr 2022 07:06:07 -0700 (PDT)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id y15-20020a05600015cf00b00203e324347bsm4772786wry.102.2022.04.15.07.06.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Apr 2022 07:06:06 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <f8203e72-4821-2d28-122b-0721423b3eb5@redhat.com>
Date:   Fri, 15 Apr 2022 16:06:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 068/104] KVM: TDX: restore user ret MSRs
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <7c421339d5b2bd5d2e29f79ac1cdf5d269c5cf96.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <7c421339d5b2bd5d2e29f79ac1cdf5d269c5cf96.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:49, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Several user ret MSRs are clobbered on TD exit.  Restore those values on
> TD exit and before returning to ring 3.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/tdx.c | 33 +++++++++++++++++++++++++++++++++
>   1 file changed, 33 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 54be5be1a06c..c1366aac7d96 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -550,6 +550,28 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>   	vcpu->kvm->vm_bugged = true;
>   }
>   
> +struct tdx_uret_msr {
> +	u32 msr;
> +	unsigned int slot;
> +	u64 defval;
> +};
> +
> +static struct tdx_uret_msr tdx_uret_msrs[] = {
> +	{.msr = MSR_SYSCALL_MASK,},
> +	{.msr = MSR_STAR,},
> +	{.msr = MSR_LSTAR,},
> +	{.msr = MSR_TSC_AUX,},
> +};
> +
> +static void tdx_user_return_update_cache(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++)
> +		kvm_user_return_update_cache(tdx_uret_msrs[i].slot,
> +					     tdx_uret_msrs[i].defval);
> +}
> +
>   static void tdx_restore_host_xsave_state(struct kvm_vcpu *vcpu)
>   {
>   	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> @@ -589,6 +611,7 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
>   
>   	tdx_vcpu_enter_exit(vcpu, tdx);
>   
> +	tdx_user_return_update_cache();
>   	tdx_restore_host_xsave_state(vcpu);
>   	tdx->host_state_need_restore = true;
>   
> @@ -1371,6 +1394,16 @@ static int __init __tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
>   	if (WARN_ON_ONCE(x86_ops->tlb_remote_flush))
>   		return -EIO;
>   
> +	for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++) {
> +		tdx_uret_msrs[i].slot = kvm_find_user_return_msr(tdx_uret_msrs[i].msr);
> +		if (tdx_uret_msrs[i].slot == -1) {
> +			/* If any MSR isn't supported, it is a KVM bug */
> +			pr_err("MSR %x isn't included by kvm_find_user_return_msr\n",
> +				tdx_uret_msrs[i].msr);
> +			return -EIO;
> +		}
> +	}
> +
>   	max_pkgs = topology_max_packages();
>   	tdx_mng_key_config_lock = kcalloc(max_pkgs, sizeof(*tdx_mng_key_config_lock),
>   				   GFP_KERNEL);

I wonder if you only need to do this if 
!this_cpu_ptr(user_return_msrs)->registered, but not a big deal.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
