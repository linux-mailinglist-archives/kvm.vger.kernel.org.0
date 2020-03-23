Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A99718F288
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 11:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgCWKQq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 06:16:46 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:29597 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727829AbgCWKQp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Mar 2020 06:16:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584958604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DHX3G/HAJrIPBm/kQCkLNNm+40k06i4E5QNgUcCEDS4=;
        b=Zg3kAun1N+fQ3WOfmSSf/HmOURPYqrU3RBeEwnpiKhU0quggaIMr/zoE21xt3QlguUCNJT
        GGEc9NY50AK/8j/8Njmiv+S9IUcEhgn7zD3zj3a+RTWPMF3E1V++R8EzS90GNN6P6zQ8Bt
        eeNK0GVV/RmnBFRWZtZ8IPuPQzjrN78=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-3dQbYpnHO1KPMh5MwiS-bg-1; Mon, 23 Mar 2020 06:16:43 -0400
X-MC-Unique: 3dQbYpnHO1KPMh5MwiS-bg-1
Received: by mail-wm1-f72.google.com with SMTP id w9so753967wmi.2
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 03:16:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=DHX3G/HAJrIPBm/kQCkLNNm+40k06i4E5QNgUcCEDS4=;
        b=Df1phFUC9iKYNKJ5HuEADzvca6pChpitzcy77o3w8zf2cHUUxbaGt/pyNjijnHPfaP
         CU1E9aNitSxzDWc9yQAOJIC+M0Rrerl/AooWITCZbTWi0X0dnhVSZTSakjFfCuVQZlQi
         b6dv/xdFN8ctHWsjRMixTUf65e3LOkPH9nD6msgSbEJae3i4edEQ+5NfcOuEdG16rIho
         oa2qyNfQk/ysqkp+aSnaThxmf44Vov3nnx9zI+Xj9udiHIq7KhHCFSP/KBYIlmW43nlI
         V5buH4Eg4+6aUYwyq92Q2Pmao/BLBoBiwEVoJ4U3BUoep6FnKLZr5+aXCr6rdjK6Lc/V
         WYSg==
X-Gm-Message-State: ANhLgQ1GD50GTkrAQSAj+hmBkjoL6FPfK8IXmj6WkMoglpsUPYJVN/rw
        BwREe7zmaTWWW+zbWHtWDcIwxaJFjRRLFG3J8Z/ngB2Zmse1vuQ7qup3+s19TZ4kpwDEvwJ4MQA
        kGb/Tzt86iJCW
X-Received: by 2002:a1c:4486:: with SMTP id r128mr24718268wma.32.1584958601605;
        Mon, 23 Mar 2020 03:16:41 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuJITYZqrWvgDgsRVuualAmEYTKCOGhQ9kmRfo0Nn5X36UgOsGqcqcIf9m9XhMHrf4L5zgKcg==
X-Received: by 2002:a1c:4486:: with SMTP id r128mr24718208wma.32.1584958600836;
        Mon, 23 Mar 2020 03:16:40 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id k204sm7418938wma.17.2020.03.23.03.16.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 03:16:40 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jon Doron <arilou@gmail.com>
Cc:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v9 2/6] x86/kvm/hyper-v: Simplify addition for custom cpuid leafs
In-Reply-To: <20200320172839.1144395-3-arilou@gmail.com>
References: <20200320172839.1144395-1-arilou@gmail.com> <20200320172839.1144395-3-arilou@gmail.com>
Date:   Mon, 23 Mar 2020 11:16:39 +0100
Message-ID: <87wo7b9y0o.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jon Doron <arilou@gmail.com> writes:

> Simlify the code to define a new cpuid leaf group by enabled feature.
>
> This also fixes a bug in which the max cpuid leaf was always set to
> HYPERV_CPUID_NESTED_FEATURES regardless if nesting is supported or not.
>
> Any new CPUID group needs to consider the max leaf and be added in the
> correct order, in this method there are two rules:
> 1. Each cpuid leaf group must be order in an ascending order
> 2. The appending for the cpuid leafs by features also needs to happen by
>    ascending order.
>
> Signed-off-by: Jon Doron <arilou@gmail.com>
> ---
>  arch/x86/kvm/hyperv.c | 46 ++++++++++++++++++++++++++++++-------------
>  1 file changed, 32 insertions(+), 14 deletions(-)
>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index a86fda7a1d03..7383c7e7d4af 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1785,27 +1785,45 @@ int kvm_vm_ioctl_hv_eventfd(struct kvm *kvm, struct kvm_hyperv_eventfd *args)
>  	return kvm_hv_eventfd_assign(kvm, args->conn_id, args->fd);
>  }
>  
> +// Must be sorted in ascending order by function

scripts/checkpatch.pl should've complained here, kernel coding style
always requires /* */ 

> +static struct kvm_cpuid_entry2 core_cpuid_entries[] = {
> +	{ .function = HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS },
> +	{ .function = HYPERV_CPUID_INTERFACE },
> +	{ .function = HYPERV_CPUID_VERSION },
> +	{ .function = HYPERV_CPUID_FEATURES },
> +	{ .function = HYPERV_CPUID_ENLIGHTMENT_INFO },
> +	{ .function = HYPERV_CPUID_IMPLEMENT_LIMITS },
> +};
> +
> +static struct kvm_cpuid_entry2 evmcs_cpuid_entries[] = {
> +	{ .function = HYPERV_CPUID_NESTED_FEATURES },
> +};
> +
> +#define HV_MAX_CPUID_ENTRIES \
> +	ARRAY_SIZE(core_cpuid_entries) +\
> +	ARRAY_SIZE(evmcs_cpuid_entries)
> +
>  int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>  				struct kvm_cpuid_entry2 __user *entries)
>  {
>  	uint16_t evmcs_ver = 0;
> -	struct kvm_cpuid_entry2 cpuid_entries[] = {
> -		{ .function = HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS },
> -		{ .function = HYPERV_CPUID_INTERFACE },
> -		{ .function = HYPERV_CPUID_VERSION },
> -		{ .function = HYPERV_CPUID_FEATURES },
> -		{ .function = HYPERV_CPUID_ENLIGHTMENT_INFO },
> -		{ .function = HYPERV_CPUID_IMPLEMENT_LIMITS },
> -		{ .function = HYPERV_CPUID_NESTED_FEATURES },
> -	};
> -	int i, nent = ARRAY_SIZE(cpuid_entries);
> +	struct kvm_cpuid_entry2 cpuid_entries[HV_MAX_CPUID_ENTRIES];
> +	int i, nent = 0;
> +
> +	/* Set the core cpuid entries required for Hyper-V */
> +	memcpy(&cpuid_entries[nent], &core_cpuid_entries,
> +	       sizeof(core_cpuid_entries));
> +	nent += ARRAY_SIZE(core_cpuid_entries);

Strictly speaking "+=" is not needed here as nent is zero.

>  
>  	if (kvm_x86_ops->nested_get_evmcs_version)
>  		evmcs_ver = kvm_x86_ops->nested_get_evmcs_version(vcpu);
>  
> -	/* Skip NESTED_FEATURES if eVMCS is not supported */
> -	if (!evmcs_ver)
> -		--nent;
> +	if (evmcs_ver) {
> +		/* EVMCS is enabled, add the required EVMCS CPUID leafs */
> +		memcpy(&cpuid_entries[nent], &evmcs_cpuid_entries,
> +		       sizeof(evmcs_cpuid_entries));
> +		nent += ARRAY_SIZE(evmcs_cpuid_entries);
> +	}
>  
>  	if (cpuid->nent < nent)
>  		return -E2BIG;
> @@ -1821,7 +1839,7 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>  		case HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS:
>  			memcpy(signature, "Linux KVM Hv", 12);
>  
> -			ent->eax = HYPERV_CPUID_NESTED_FEATURES;
> +			ent->eax = cpuid_entries[nent - 1].function;
>  			ent->ebx = signature[0];
>  			ent->ecx = signature[1];
>  			ent->edx = signature[2];

With the nitpicks mentioned above:

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

