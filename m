Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00000421FF4
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 09:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232793AbhJEH7N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 03:59:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30522 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233478AbhJEH6W (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 03:58:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633420591;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uxcsc9+/ALGMdXirECAEtPRw+buxJ+mONYYMojv18BA=;
        b=NXLVQZNq23eOfCp7fK01wVIuzFymyrKX3IcnNuFTDN6U9+Gh3OrSX3KL3KeHWNRr3P2awC
        6+dE8wo1/bzsO4uN8sEDHIyU+xIco1Qhc6I3XdULNBYMifRCo2ikBsU48yTbJZECGegH7w
        Lu4+5rnakqPc6IbV6zBda0yN1Md/2xM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-pZWPgSIeNv6DcclaHYsaLQ-1; Tue, 05 Oct 2021 03:56:28 -0400
X-MC-Unique: pZWPgSIeNv6DcclaHYsaLQ-1
Received: by mail-wm1-f70.google.com with SMTP id z194-20020a1c7ecb000000b0030b7ccea080so939845wmc.8
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 00:56:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=uxcsc9+/ALGMdXirECAEtPRw+buxJ+mONYYMojv18BA=;
        b=s1ckJDXkSVK/NeOgd5XvGF1VfU1VT2cbh4a2LuDuSazRsJDHfynUAOJVTzaTdkcnHZ
         +Ou28ra9Ym3JJG8SaUwvtyxXPDJHTRZ1gjHB3RosGtXyCsplYwBrV37ckFanH9jU8gFK
         bGqTABIkwOELGwhz89R/TU5/BB9LmRJMkAYeYImVJF5y0+3yEbGRauDCUwcv9q1+39cA
         8dElHOdOqFkC70UOjohRtzdlNY8kWQOo0orXoUl3Izjd4T58yhMzXDqZNqmkswXuUmfR
         CSrQdiimaEy2NeTKCz7FmyZCACnYn6nADOTWMhuQlusASMEjodkQa9tqhBi8pm0Yp6QU
         1KlQ==
X-Gm-Message-State: AOAM532fNwKANJoPEeBs9X4oQ4gScqV+12/D95A+KcJkc+RkLWC1PvvY
        7eloafRwsgIhRMyxNWvYsfnYdH/cNx58r/Uw9AQM53Eb5fxQv1uX7uttRL+GtKH3jVb9pQVcoUi
        YfuOfMxg2UnRp
X-Received: by 2002:a05:600c:1553:: with SMTP id f19mr1867647wmg.66.1633420587306;
        Tue, 05 Oct 2021 00:56:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwq2lzHQkf14bsNcBYPLOhdihVC1Vma+u2W+yn9GkssSn4fsp8+uC08Zbe0RKlILdRfGdfvBA==
X-Received: by 2002:a05:600c:1553:: with SMTP id f19mr1867634wmg.66.1633420587115;
        Tue, 05 Oct 2021 00:56:27 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id l17sm16929611wrx.24.2021.10.05.00.56.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 00:56:26 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v4 05/11] KVM: arm64: vgic: Drop vgic_check_ioaddr()
To:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        maz@kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com,
        alexandru.elisei@arm.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
References: <20211005011921.437353-1-ricarkol@google.com>
 <20211005011921.437353-6-ricarkol@google.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <a6a69648-0fc3-3d94-0e65-dc82693ce4c7@redhat.com>
Date:   Tue, 5 Oct 2021 09:56:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211005011921.437353-6-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On 10/5/21 3:19 AM, Ricardo Koller wrote:
> There are no more users of vgic_check_ioaddr(). Move its checks to
> vgic_check_iorange() and then remove it.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  arch/arm64/kvm/vgic/vgic-kvm-device.c | 26 ++++----------------------
>  arch/arm64/kvm/vgic/vgic.h            |  3 ---
>  2 files changed, 4 insertions(+), 25 deletions(-)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> index 08ae34b1a986..0d000d2fe8d2 100644
> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> @@ -14,38 +14,20 @@
>  
>  /* common helpers */
>  
> -int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
> -		      phys_addr_t addr, phys_addr_t alignment)
> -{
> -	if (addr & ~kvm_phys_mask(kvm))
> -		return -E2BIG;
> -
> -	if (!IS_ALIGNED(addr, alignment))
> -		return -EINVAL;
> -
> -	if (!IS_VGIC_ADDR_UNDEF(*ioaddr))
> -		return -EEXIST;
> -
> -	return 0;
> -}
> -
>  int vgic_check_iorange(struct kvm *kvm, phys_addr_t ioaddr,
>  		       phys_addr_t addr, phys_addr_t alignment,
>  		       phys_addr_t size)
>  {
> -	int ret;
> -
> -	ret = vgic_check_ioaddr(kvm, &ioaddr, addr, alignment);
> -	if (ret)
> -		return ret;
> +	if (!IS_VGIC_ADDR_UNDEF(ioaddr))
> +		return -EEXIST;
>  
> -	if (!IS_ALIGNED(size, alignment))
> +	if (!IS_ALIGNED(addr, alignment) || !IS_ALIGNED(size, alignment))
>  		return -EINVAL;
>  
>  	if (addr + size < addr)
>  		return -EINVAL;
>  
> -	if (addr + size > kvm_phys_size(kvm))
> +	if (addr & ~kvm_phys_mask(kvm) || addr + size > kvm_phys_size(kvm))
>  		return -E2BIG;
>  
>  	return 0;
> diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
> index 4be01c38e8f1..3fd6c86a7ef3 100644
> --- a/arch/arm64/kvm/vgic/vgic.h
> +++ b/arch/arm64/kvm/vgic/vgic.h
> @@ -172,9 +172,6 @@ void vgic_kick_vcpus(struct kvm *kvm);
>  void vgic_irq_handle_resampling(struct vgic_irq *irq,
>  				bool lr_deactivated, bool lr_pending);
>  
> -int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
> -		      phys_addr_t addr, phys_addr_t alignment);
> -
>  int vgic_check_iorange(struct kvm *kvm, phys_addr_t ioaddr,
>  		       phys_addr_t addr, phys_addr_t alignment,
>  		       phys_addr_t size);

