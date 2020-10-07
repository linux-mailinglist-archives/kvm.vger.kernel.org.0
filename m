Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E44285A38
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 10:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbgJGIOf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 04:14:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44956 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726361AbgJGIOf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Oct 2020 04:14:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602058473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FO0ylTwxsFibALiQNRYyuOtFrkYnW5pOZMct+3/gDn0=;
        b=A1MM7SZXj1mLAB6lhfmOkf3Et2UnmCZz8H3jeQSXVVzXNNkdDS6Yn6j3KSSiUFlkdp8nZ0
        z43rfVOWY6gq1udjcL4/NzGKeHl7WAzPqqPPCDojKUgdrAd6IGTTjpvRmCOVC8kUGFeoSE
        oWgspij9gTzn29eTxRFVAhIgyjAtoV0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-573-d9KCBC9lOHiO7bEeiUdQ9w-1; Wed, 07 Oct 2020 04:14:32 -0400
X-MC-Unique: d9KCBC9lOHiO7bEeiUdQ9w-1
Received: by mail-wr1-f69.google.com with SMTP id g7so669061wrm.2
        for <kvm@vger.kernel.org>; Wed, 07 Oct 2020 01:14:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FO0ylTwxsFibALiQNRYyuOtFrkYnW5pOZMct+3/gDn0=;
        b=KoIuNWX7qu3WR3axycPbzvXcKQra7OWHncTwltOGPMkzvVV71AIsCUndwPh6wpYU3q
         GRgYzBSqVEeX7VJBFo/6ga9XVYVKMvMonuSpSqBZmSD3gQYd7mep4LXkfDR+IrFJwjMv
         r/2/6qwVBsrawP4s6LRscx4fBDZjnmR5IL983RTlnKkBwRueAf5pFIQTp+b8B3zUHes8
         rfKTGRme9Jd2Z6ld2QntY2si933usGowBWkHNp7PwNioMT9x5kG83vTStksOcFSyWjkT
         205hyR6l9OiLbf8hl/2umLgb+JprJDcc9VC5bALqgBnFxtgf6fqEWgej4EtELvwrPRHY
         hSHw==
X-Gm-Message-State: AOAM5307t92I/gzc77ajqNnFyqwc5HLKLh95lDcfvXzRGylUAkkOJTvg
        lEaKEHfF717I0cX8xSDNOR06JIS5AxMYPRrZLD9kxWItuqVKB99f/k1NwtHtXM7jOtBE+9+daBZ
        R1UJrQJ/4XESD
X-Received: by 2002:adf:ec06:: with SMTP id x6mr2071158wrn.404.1602058470973;
        Wed, 07 Oct 2020 01:14:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyFA/NpUmddmBqpHG4PhSr4PEf9UoUBToNUEttKhZEAEft5UqjvPixuATGiNm9eSRs4VMCUZg==
X-Received: by 2002:adf:ec06:: with SMTP id x6mr2071136wrn.404.1602058470739;
        Wed, 07 Oct 2020 01:14:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d2f4:5943:190c:39ff? ([2001:b07:6468:f312:d2f4:5943:190c:39ff])
        by smtp.gmail.com with ESMTPSA id a127sm1678866wmh.13.2020.10.07.01.14.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2020 01:14:30 -0700 (PDT)
Subject: Re: [PATCH 13/13] x86/kvm: Add KVM_FEATURE_MSI_EXT_DEST_ID
To:     David Woodhouse <dwmw2@infradead.org>, x86@kernel.org
Cc:     iommu <iommu@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>, linux-hyperv@vger.kernel.org
References: <77e64f977f559412f62b467fd062d051ea288f14.camel@infradead.org>
 <20201005152856.974112-1-dwmw2@infradead.org>
 <20201005152856.974112-13-dwmw2@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <472a34e3-2981-0c7b-1fb0-da8debbdc728@redhat.com>
Date:   Wed, 7 Oct 2020 10:14:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20201005152856.974112-13-dwmw2@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/10/20 17:28, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> This allows the host to indicate that IOAPIC and MSI emulation supports
> 15-bit destination IDs, allowing up to 32Ki CPUs without remapping.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>  Documentation/virt/kvm/cpuid.rst     | 4 ++++
>  arch/x86/include/uapi/asm/kvm_para.h | 1 +
>  arch/x86/kernel/kvm.c                | 6 ++++++
>  3 files changed, 11 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
> index a7dff9186bed..1726b5925d2b 100644
> --- a/Documentation/virt/kvm/cpuid.rst
> +++ b/Documentation/virt/kvm/cpuid.rst
> @@ -92,6 +92,10 @@ KVM_FEATURE_ASYNC_PF_INT          14          guest checks this feature bit
>                                                async pf acknowledgment msr
>                                                0x4b564d07.
>  
> +KVM_FEATURE_MSI_EXT_DEST_ID       15          guest checks this feature bit
> +                                              before using extended destination
> +                                              ID bits in MSI address bits 11-5.
> +
>  KVM_FEATURE_CLOCSOURCE_STABLE_BIT 24          host will warn if no guest-side
>                                                per-cpu warps are expeced in
>                                                kvmclock
> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> index 812e9b4c1114..950afebfba88 100644
> --- a/arch/x86/include/uapi/asm/kvm_para.h
> +++ b/arch/x86/include/uapi/asm/kvm_para.h
> @@ -32,6 +32,7 @@
>  #define KVM_FEATURE_POLL_CONTROL	12
>  #define KVM_FEATURE_PV_SCHED_YIELD	13
>  #define KVM_FEATURE_ASYNC_PF_INT	14
> +#define KVM_FEATURE_MSI_EXT_DEST_ID	15
>  
>  #define KVM_HINTS_REALTIME      0
>  
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 1b51b727b140..4986b4399aef 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -743,12 +743,18 @@ static void __init kvm_init_platform(void)
>  	x86_platform.apic_post_init = kvm_apic_init;
>  }
>  
> +static bool __init kvm_msi_ext_dest_id(void)
> +{
> +	return kvm_para_has_feature(KVM_FEATURE_MSI_EXT_DEST_ID);
> +}
> +
>  const __initconst struct hypervisor_x86 x86_hyper_kvm = {
>  	.name			= "KVM",
>  	.detect			= kvm_detect,
>  	.type			= X86_HYPER_KVM,
>  	.init.guest_late_init	= kvm_guest_init,
>  	.init.x2apic_available	= kvm_para_available,
> +	.init.msi_ext_dest_id	= kvm_msi_ext_dest_id,
>  	.init.init_platform	= kvm_init_platform,
>  };
>  
> 

Looks like the rest of the series needs some more work, but anyway:

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

