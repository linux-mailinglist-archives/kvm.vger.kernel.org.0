Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF0F41CA18
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 18:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344609AbhI2QbJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 12:31:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48971 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344370AbhI2QbI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Sep 2021 12:31:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632932966;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NQx2xj6HF67LAuBQdKdhBIXW5cGRVi2ucKp6xvBgZPA=;
        b=esuHkilKVoE1XNfa6/GXBIjq5ZnIU+zChP7oKlaHLQVRPe48g6e3c1mlzmbzxk0K42eyuB
        1X96WjBPsctFnh93OyHC8jakM7JR5k4zrirlcH42klrCcEASZPfHGcfnaCExcehTP0SDdM
        YoDU/W/9LR4fj9k4I7jnZFwXQRkObOU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-EYSeCO33OVeN3z-Zznu0Wg-1; Wed, 29 Sep 2021 12:29:25 -0400
X-MC-Unique: EYSeCO33OVeN3z-Zznu0Wg-1
Received: by mail-wm1-f70.google.com with SMTP id y23-20020a05600c365700b003015b277f98so1033160wmq.2
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 09:29:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=NQx2xj6HF67LAuBQdKdhBIXW5cGRVi2ucKp6xvBgZPA=;
        b=dl/AJB8nhxE2WMGjGQGathqaRwkCNRM+Ir5+VUuhOJmYwTuL+ogaq3pb8amRZgrGCt
         87ODlHX3F8SvudspO4ESPdimIAvwyjYYkbiYmenEuiuPBBB9FFv+AQOa6fl0PxaSPqT3
         /NnUKImhEfzuYLlK2CBGMu6yWhAv2u88PfLfBed+cvBrPTLi1tknzxO4CzBreB+0PGmi
         8Vb7Pr0OaqcQoSEQC3wNIZhZtjwu0wqKEz9Kk66L7vCcLHaM9jJ2erAMv0OgM4atIwPO
         r4cJ7iAaksl1TL+Hdt2kEnJGGZQGK3KBNKCb9XHs1q/AVp9LtcBOecRWjz7qbEH+04Cl
         DHMw==
X-Gm-Message-State: AOAM5304rTwI4ZQtKX6JhMFlenwO1vopcC9eScp7AptG9BgeAcjsBIQX
        KhafvJX6uHxcaXgcRzJkIC9T696oCU4B2682TP97ZAYGuAIz0f3Z4I6+vWM6HAId60RCwDUwugM
        38bBOT45y7/mu
X-Received: by 2002:a1c:2c3:: with SMTP id 186mr10532338wmc.114.1632932964307;
        Wed, 29 Sep 2021 09:29:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzjPYG2GldBAGUDiZVvrsb69nxkr4sn6oQ/M0aRFiAmWdoOXqQa1HfuXqlT+QG3rv5j6MMwAA==
X-Received: by 2002:a1c:2c3:: with SMTP id 186mr10532307wmc.114.1632932964083;
        Wed, 29 Sep 2021 09:29:24 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id c185sm346633wma.8.2021.09.29.09.29.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 09:29:23 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 01/10] kvm: arm64: vgic: Introduce vgic_check_iorange
To:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        maz@kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com,
        alexandru.elisei@arm.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210928184803.2496885-2-ricarkol@google.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <4ab60884-e006-723a-c026-b3e8c0ccb349@redhat.com>
Date:   Wed, 29 Sep 2021 18:29:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210928184803.2496885-2-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On 9/28/21 8:47 PM, Ricardo Koller wrote:
> Add the new vgic_check_iorange helper that checks that an iorange is
> sane: the start address and size have valid alignments, the range is
> within the addressable PA range, start+size doesn't overflow, and the
> start wasn't already defined.
>
> No functional change.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arch/arm64/kvm/vgic/vgic-kvm-device.c | 22 ++++++++++++++++++++++
>  arch/arm64/kvm/vgic/vgic.h            |  4 ++++
>  2 files changed, 26 insertions(+)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> index 7740995de982..f714aded67b2 100644
> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> @@ -29,6 +29,28 @@ int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
>  	return 0;
>  }
>  
> +int vgic_check_iorange(struct kvm *kvm, phys_addr_t *ioaddr,
> +		       phys_addr_t addr, phys_addr_t alignment,
> +		       phys_addr_t size)
> +{
> +	int ret;
> +
> +	ret = vgic_check_ioaddr(kvm, ioaddr, addr, alignment);
nit: not related to this patch but I am just wondering why we are
passing phys_addr_t *ioaddr downto vgic_check_ioaddr and thus to

vgic_check_iorange()? This must be a leftover of some old code?

> +	if (ret)
> +		return ret;
> +
> +	if (!IS_ALIGNED(size, alignment))
> +		return -EINVAL;
> +
> +	if (addr + size < addr)
> +		return -EINVAL;
> +
> +	if (addr + size > kvm_phys_size(kvm))
> +		return -E2BIG;
> +
> +	return 0;
> +}
> +
>  static int vgic_check_type(struct kvm *kvm, int type_needed)
>  {
>  	if (kvm->arch.vgic.vgic_model != type_needed)
> diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
> index 14a9218641f5..c4df4dcef31f 100644
> --- a/arch/arm64/kvm/vgic/vgic.h
> +++ b/arch/arm64/kvm/vgic/vgic.h
> @@ -175,6 +175,10 @@ void vgic_irq_handle_resampling(struct vgic_irq *irq,
>  int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
>  		      phys_addr_t addr, phys_addr_t alignment);
>  
> +int vgic_check_iorange(struct kvm *kvm, phys_addr_t *ioaddr,
> +		       phys_addr_t addr, phys_addr_t alignment,
> +		       phys_addr_t size);
> +
>  void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu);
>  void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
>  void vgic_v2_clear_lr(struct kvm_vcpu *vcpu, int lr);
Besides
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Eric

