Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBB5502B6A
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 16:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354237AbiDOOFF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 10:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354233AbiDOOFE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 10:05:04 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B039DBA306;
        Fri, 15 Apr 2022 07:02:35 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id v15so9990069edb.12;
        Fri, 15 Apr 2022 07:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=B4NLxiEMn45fm7ZP4Wwd+hPT7xASfT/B5aQNlTl+H7A=;
        b=ZiW/IZTB1xy4IkU2FwMIBsjW5AF48i2mw5+IHYG/77iBzkTE5vqG5zni7CYEqfzG9g
         UMrQSFDdOoFhPt/MUXqcvlT6H1B1HFk3rGNRgmlNZmXl3ovUjAXebcZjBB8BRvyWJ5Sj
         K53U/szymK7RpOmSw65Hav9uieSfYOs+P+63y+3OLIlQry7tXbploGVcOAiPHChc28SZ
         U92wwEGAr4OmB7GhXAnBtrkTav1XnAaGyhLWlNZuVeXhjq/49ruabgW/gzUcGpfZawVm
         kRo9Ck90YF2T+ZGBtLNIjRNAP+GQTe/MiOlwzw5Dn5x4iCZZpnctzYAZsDJ4qENm+p+5
         lhKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=B4NLxiEMn45fm7ZP4Wwd+hPT7xASfT/B5aQNlTl+H7A=;
        b=DC9MNHdWhbRCUTwvpLw/EWaeys2iE/DO1fafFoc0KnIVyPWT5cNJNc+Jnso2z77BK1
         Fn/OYevvPHeUvmNI7JXKmB3l0Ng3f7eopK6rGglk2U4oOZ8MLzDmX2lQQvjm/GrEckvw
         Ta13e9OgconyhOxfzYSRPq0mPmxmiMf5I5Zu1V8xpECQ5vEXvQ7th8dFdRKGbRojn/cu
         sCD8ba1jwszRmp5r735viuI0QXMwQ+69CUDDijlnU2YB2GcmvbRMYC/kv6TCqoCLK3JC
         PjDB0zfytW+wzj1CQ1IQfFBfTUxJx7wQEB6QteNnuT+oTQSR91kKe78FSlawgj+0/VGp
         5QyA==
X-Gm-Message-State: AOAM533Z/HhRAjDQhdJ7VQe08/JDeHHMIlV/nVkAuk/sTDqqpnOVTPZW
        1mzHBCD6mM7Xq7mY0bBSgtw=
X-Google-Smtp-Source: ABdhPJyfOJPcLez5/oODtByHWW20dnzZY19n9GVD3PszbXFfK9sYlpav3gVzNtkzqezlSG+tQd/TIw==
X-Received: by 2002:a05:6402:50d0:b0:419:7df9:55c8 with SMTP id h16-20020a05640250d000b004197df955c8mr8245720edb.79.1650031354111;
        Fri, 15 Apr 2022 07:02:34 -0700 (PDT)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id dn7-20020a17090794c700b006e8b176143bsm1715171ejc.155.2022.04.15.07.02.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Apr 2022 07:02:33 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <42931581-24f3-d995-4971-5cdf3041d53f@redhat.com>
Date:   Fri, 15 Apr 2022 16:02:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 067/104] KVM: x86: Allow to update cached values in
 kvm_user_return_msrs w/o wrmsr
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <07b46b34aa86658fe8409926c3b8474dd6ff0d8c.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <07b46b34aa86658fe8409926c3b8474dd6ff0d8c.1646422845.git.isaku.yamahata@intel.com>
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
> From: Chao Gao <chao.gao@intel.com>
> 
> Several MSRs are constant and only used in userspace(ring 3).  But VMs may
> have different values.  KVM uses kvm_set_user_return_msr() to switch to
> guest's values and leverages user return notifier to restore them when the
> kernel is to return to userspace.  To eliminate unnecessary wrmsr, KVM also
> caches the value it wrote to an MSR last time.
> 
> TDX module unconditionally resets some of these MSRs to architectural INIT
> state on TD exit.  It makes the cached values in kvm_user_return_msrs are
> inconsistent with values in hardware.  This inconsistency needs to be
> fixed.  Otherwise, it may mislead kvm_on_user_return() to skip restoring
> some MSRs to the host's values.  kvm_set_user_return_msr() can help correct
> this case, but it is not optimal as it always does a wrmsr.  So, introduce
> a variation of kvm_set_user_return_msr() to update cached values and skip
> that wrmsr.
> 
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  1 +
>   arch/x86/kvm/x86.c              | 25 ++++++++++++++++++++-----
>   2 files changed, 21 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 8406f8b5ab74..b6396d11139e 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1894,6 +1894,7 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
>   int kvm_add_user_return_msr(u32 msr);
>   int kvm_find_user_return_msr(u32 msr);
>   int kvm_set_user_return_msr(unsigned index, u64 val, u64 mask);
> +void kvm_user_return_update_cache(unsigned int index, u64 val);
>   
>   static inline bool kvm_is_supported_user_return_msr(u32 msr)
>   {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 66400810d54f..45e8a02e99bf 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -427,6 +427,15 @@ static void kvm_user_return_msr_cpu_online(void)
>   	}
>   }
>   
> +static void kvm_user_return_register_notifier(struct kvm_user_return_msrs *msrs)
> +{
> +	if (!msrs->registered) {
> +		msrs->urn.on_user_return = kvm_on_user_return;
> +		user_return_notifier_register(&msrs->urn);
> +		msrs->registered = true;
> +	}
> +}
> +
>   int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
>   {
>   	unsigned int cpu = smp_processor_id();
> @@ -441,15 +450,21 @@ int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
>   		return 1;
>   
>   	msrs->values[slot].curr = value;
> -	if (!msrs->registered) {
> -		msrs->urn.on_user_return = kvm_on_user_return;
> -		user_return_notifier_register(&msrs->urn);
> -		msrs->registered = true;
> -	}
> +	kvm_user_return_register_notifier(msrs);
>   	return 0;
>   }
>   EXPORT_SYMBOL_GPL(kvm_set_user_return_msr);
>   
> +/* Update the cache, "curr", and register the notifier */
> +void kvm_user_return_update_cache(unsigned int slot, u64 value)
> +{
> +	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
> +
> +	msrs->values[slot].curr = value;
> +	kvm_user_return_register_notifier(msrs);
> +}
> +EXPORT_SYMBOL_GPL(kvm_user_return_update_cache);
> +
>   static void drop_user_return_notifiers(void)
>   {
>   	unsigned int cpu = smp_processor_id();

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
