Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91C6049AE00
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 09:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1450462AbiAYI16 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 03:27:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:40566 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1450217AbiAYIZG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Jan 2022 03:25:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643099105;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+sXhaGm2GGCptEhnHBCl251XBa+1mlFW8WFCew3sruE=;
        b=NHnm4hPgCiYRMQv/772E0IQDbKUd9qTbxqYKJWPYpbjI2f4q4HkTUbj0XsjGWk98GmUQpc
        4r5nux3HeeClvEeCpg4lbEE//VkMXNNDnhxCjxqwdH2KosIShesikZT0JlXfJrP2ahucT+
        cGxxv3hPR8321cELRWWqo503dI7X4c0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-399-g9gQiWwjNnauh_dOa5oAfg-1; Tue, 25 Jan 2022 03:25:03 -0500
X-MC-Unique: g9gQiWwjNnauh_dOa5oAfg-1
Received: by mail-ed1-f72.google.com with SMTP id a18-20020aa7d752000000b00403d18712beso14520920eds.17
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 00:25:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+sXhaGm2GGCptEhnHBCl251XBa+1mlFW8WFCew3sruE=;
        b=T/I2HWb0Hq8JJb5iQ4+FgZ4zWFbYjSpGbwQj3Qfpqt1WzyXsyOMR37EPXC/pqkUVOT
         e7qno9DKim44pLK3hGVUD1HgpnOokXdEZxQKhGZVjxHq97MQ7Fxvkap54ULgULvnH3pE
         hF9ovt8Thtw/xv0kvkHRxXX4AvktqgB2P2wzEjyDo5ofxsF++ZHCuN2yf4p52SxsO/rc
         9+8y++MvR8eca37ybn2ytTeAmNLF+JJ2xPVxGYZVi8QL3KZ4ie+5TpR1/zS7HirnuRVE
         wdPZ8vqSjAHQ4dSJ5atxxQG1+7zGEFVJm0ZyFfX8eLHTOC4TM++F1jI0iXKT69r4lHIh
         +dmA==
X-Gm-Message-State: AOAM533nR3Px8heznELo5y8LS++Vmuq6F6gVoX/vnCVsyWHBb3vT/uCw
        e7rzZplKAcrcAbyW9lYQIcQYECdSJVt6JWrDfbb0hp7OgZ+5zk/DrXWEdyNuHhJZWK0SHNAdCR6
        JrX/omlaKt0Qk
X-Received: by 2002:a05:6402:2552:: with SMTP id l18mr19517792edb.124.1643099102379;
        Tue, 25 Jan 2022 00:25:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzVS6I6667MUJ9YYBHoAKOdA6icOeC8qJX5/qRUvtU4XfgPwDlJJBzZbLLv06z+APM9+u6E7w==
X-Received: by 2002:a05:6402:2552:: with SMTP id l18mr19517785edb.124.1643099102155;
        Tue, 25 Jan 2022 00:25:02 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id oz3sm5863544ejb.206.2022.01.25.00.25.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 00:25:01 -0800 (PST)
Message-ID: <c94fee28-c1b9-c457-20df-8cc77c2eba1f@redhat.com>
Date:   Tue, 25 Jan 2022 09:25:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] KVM: VMX: Remove vmcs_config.order
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
References: <20220125004359.147600-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220125004359.147600-1-jmattson@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/25/22 01:43, Jim Mattson wrote:
> The maximum size of a VMCS (or VMXON region) is 4096. By definition,
> these are order 0 allocations.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>   arch/x86/kvm/vmx/capabilities.h | 1 -
>   arch/x86/kvm/vmx/vmx.c          | 5 ++---
>   2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
> index 959b59d13b5a..3f430e218375 100644
> --- a/arch/x86/kvm/vmx/capabilities.h
> +++ b/arch/x86/kvm/vmx/capabilities.h
> @@ -54,7 +54,6 @@ struct nested_vmx_msrs {
>   
>   struct vmcs_config {
>   	int size;
> -	int order;
>   	u32 basic_cap;
>   	u32 revision_id;
>   	u32 pin_based_exec_ctrl;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 4ac676066d60..185d903a8fe5 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2603,7 +2603,6 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>   		return -EIO;
>   
>   	vmcs_conf->size = vmx_msr_high & 0x1fff;
> -	vmcs_conf->order = get_order(vmcs_conf->size);
>   	vmcs_conf->basic_cap = vmx_msr_high & ~0x1fff;
>   
>   	vmcs_conf->revision_id = vmx_msr_low;
> @@ -2628,7 +2627,7 @@ struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags)
>   	struct page *pages;
>   	struct vmcs *vmcs;
>   
> -	pages = __alloc_pages_node(node, flags, vmcs_config.order);
> +	pages = __alloc_pages_node(node, flags, 0);
>   	if (!pages)
>   		return NULL;
>   	vmcs = page_address(pages);
> @@ -2647,7 +2646,7 @@ struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags)
>   
>   void free_vmcs(struct vmcs *vmcs)
>   {
> -	free_pages((unsigned long)vmcs, vmcs_config.order);
> +	free_page((unsigned long)vmcs);
>   }
>   
>   /*

Queued, thanks.

Paolo

