Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99703A2E26
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 16:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbhFJO34 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 10:29:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57955 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230329AbhFJO34 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 10:29:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623335279;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/G0qXrP4RnDj70J9kLXpSXEOYxX6BcO6749yhP5A3EY=;
        b=N/IKj6VdHaaao+3Vgk5TkGtZwD5GMdjwTdm4kmAWizkkXQ51z1mYc8swQeF2xdNxLNNU7H
        gmvLiaxHmPXx3Ed7QFh8Zg+gbsd1fEauJH0IUM74QZ0BUO+JoCPnZPlsOkYe471f00KO+t
        p4bfIVz/57ONAJqpTIG8VrLtFkie9nw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564-fs5baXQfNzGOJDRflGgbKg-1; Thu, 10 Jun 2021 10:27:57 -0400
X-MC-Unique: fs5baXQfNzGOJDRflGgbKg-1
Received: by mail-wr1-f71.google.com with SMTP id t14-20020adfe44e0000b029011851efa802so965672wrm.11
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 07:27:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/G0qXrP4RnDj70J9kLXpSXEOYxX6BcO6749yhP5A3EY=;
        b=oAsuXq5LOMmH07Mf6FQVFNZIx24kcQWZaXpn+cAYqL1ARbJrrOqHs7ffv6FEEx0EtN
         FcvvTelouSzeUz6lPP9cPIjqlnxgRObOOkKt+rotJrXfTsHp0U6mWL8xsyx+KohGBTWk
         XYlSJIp1GbuObhcnZNH5iR+TeLf/ly99ssQ7z1gH9N8JgO+ZPN9xw5HPp36bCo4voAOs
         2NOZKOLcSn3Os26dcXOfRPBeltz4Y2QwbLFX6BzoUJkdqhbnixZFcToMHaetQ47VShh6
         iXylZWHxcqXbHJZEe3sWyPbjND8tky0JMS4qgNWl1d+7SE0l78QzLztLpv8k2XKLnlfb
         iDEg==
X-Gm-Message-State: AOAM532OqMtj3hco0tdSCnzl0c6cnsDf/InyOpa3gdRuMkoHfQC4FtSH
        kDIdvkqKtAN1Y+iKO+r5ClFa4AMLVkn7/JU3UouE4vw632T5BqQtwGCvfqonT893a6dkbYbLHlZ
        6OuUN+st6e7Et
X-Received: by 2002:a7b:cbd1:: with SMTP id n17mr5577280wmi.2.1623335275924;
        Thu, 10 Jun 2021 07:27:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzpYIb20ba/1HtFYnsidO78BZZe5aaty3PCcRo1RmxKkQWulloDASmruK24zyhCl1B8GB3SXw==
X-Received: by 2002:a7b:cbd1:: with SMTP id n17mr5577269wmi.2.1623335275758;
        Thu, 10 Jun 2021 07:27:55 -0700 (PDT)
Received: from ?IPv6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.gmail.com with ESMTPSA id h11sm3069256wmq.34.2021.06.10.07.27.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 07:27:55 -0700 (PDT)
Subject: Re: [PATCH 2/3 v4] KVM: nVMX: nSVM: Add a new VCPU statistic to show
 if VCPU is in guest mode
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, joro@8bytes.org
References: <20210609180340.104248-1-krish.sadhukhan@oracle.com>
 <20210609180340.104248-3-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2196c319-cf6d-d859-505e-8a95dfccd993@redhat.com>
Date:   Thu, 10 Jun 2021 16:27:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210609180340.104248-3-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/06/21 20:03, Krish Sadhukhan wrote:
> Add the following per-VCPU statistic to KVM debugfs to show if a given
> VCPU is in guest mode:
> 
> 	guest_mode
> 
> Also add this as a per-VM statistic to KVM debugfs to show the total number
> of VCPUs that are in guest mode in a given VM.
> 
> Signed-off-by: Krish Sadhukhan <Krish.Sadhukhan@oracle.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  1 +
>   arch/x86/kvm/debugfs.c          | 11 +++++++++++
>   arch/x86/kvm/kvm_cache_regs.h   |  3 +++
>   arch/x86/kvm/x86.c              |  1 +
>   4 files changed, 16 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index cf8557b2b90f..f6d5387bb88f 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1173,6 +1173,7 @@ struct kvm_vcpu_stat {
>   	u64 nested_runs;
>   	u64 directed_yield_attempted;
>   	u64 directed_yield_successful;
> +	u64 guest_mode;
>   };
>   
>   struct x86_instruction_info;
> diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
> index 7e818d64bb4d..95a98413dc32 100644
> --- a/arch/x86/kvm/debugfs.c
> +++ b/arch/x86/kvm/debugfs.c
> @@ -17,6 +17,15 @@ static int vcpu_get_timer_advance_ns(void *data, u64 *val)
>   
>   DEFINE_SIMPLE_ATTRIBUTE(vcpu_timer_advance_ns_fops, vcpu_get_timer_advance_ns, NULL, "%llu\n");
>   
> +static int vcpu_get_guest_mode(void *data, u64 *val)
> +{
> +	struct kvm_vcpu *vcpu = (struct kvm_vcpu *) data;
> +	*val = vcpu->stat.guest_mode;
> +	return 0;
> +}
> +
> +DEFINE_SIMPLE_ATTRIBUTE(vcpu_guest_mode_fops, vcpu_get_guest_mode, NULL, "%lld\n");
> +
>   static int vcpu_get_tsc_offset(void *data, u64 *val)
>   {
>   	struct kvm_vcpu *vcpu = (struct kvm_vcpu *) data;
> @@ -45,6 +54,8 @@ DEFINE_SIMPLE_ATTRIBUTE(vcpu_tsc_scaling_frac_fops, vcpu_get_tsc_scaling_frac_bi
>   
>   void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu, struct dentry *debugfs_dentry)
>   {
> +	debugfs_create_file("guest_mode", 0444, debugfs_dentry, vcpu,
> +			    &vcpu_guest_mode_fops);
>   	debugfs_create_file("tsc-offset", 0444, debugfs_dentry, vcpu,
>   			    &vcpu_tsc_offset_fops);
>   
> diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
> index 3db5c42c9ecd..ebddbd37a0bf 100644
> --- a/arch/x86/kvm/kvm_cache_regs.h
> +++ b/arch/x86/kvm/kvm_cache_regs.h
> @@ -162,6 +162,7 @@ static inline u64 kvm_read_edx_eax(struct kvm_vcpu *vcpu)
>   static inline void enter_guest_mode(struct kvm_vcpu *vcpu)
>   {
>   	vcpu->arch.hflags |= HF_GUEST_MASK;
> +	vcpu->stat.guest_mode = 1;
>   }
>   
>   static inline void leave_guest_mode(struct kvm_vcpu *vcpu)
> @@ -172,6 +173,8 @@ static inline void leave_guest_mode(struct kvm_vcpu *vcpu)
>   		vcpu->arch.load_eoi_exitmap_pending = false;
>   		kvm_make_request(KVM_REQ_LOAD_EOI_EXITMAP, vcpu);
>   	}
> +
> +	vcpu->stat.guest_mode = 0;
>   }
>   
>   static inline bool is_guest_mode(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 6d1f51f6c344..baa953757911 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -246,6 +246,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
>   	VCPU_STAT("nested_runs", nested_runs),
>   	VCPU_STAT("directed_yield_attempted", directed_yield_attempted),
>   	VCPU_STAT("directed_yield_successful", directed_yield_successful),
> +	VCPU_STAT("guest_mode", guest_mode),
>   	VM_STAT("mmu_shadow_zapped", mmu_shadow_zapped),
>   	VM_STAT("mmu_pte_write", mmu_pte_write),
>   	VM_STAT("mmu_pde_zapped", mmu_pde_zapped),
> 

Applied, thanks.

Paolo

