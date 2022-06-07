Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80FD9542448
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 08:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391988AbiFHBAO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 21:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1841817AbiFHAIR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 20:08:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 63E461A0753
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 12:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654630142;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4ER/E+pAoWlGQSd+i/bJPappYOlr33p/scmrpdGboic=;
        b=DsjYttD67twDTcG3Dp3iBQbiCFP2/J6pmTfkPeatfaVKmz4i4v8ZTer9hSIJS2hnyQeSed
        5mfWgRxNB0Dacs3lvAhf44rCTyu8xoHd3x9IkP3j3Xx24yZAeP0bSVSCOgDYkVbp1BGd/W
        z43bz8n7C276GNQxuDoS8e8B5o3V2pM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-164-8RHdS2ZINJuR1Ov0ofi7DQ-1; Tue, 07 Jun 2022 15:29:01 -0400
X-MC-Unique: 8RHdS2ZINJuR1Ov0ofi7DQ-1
Received: by mail-wm1-f72.google.com with SMTP id o2-20020a05600c510200b0039747b0216fso13198781wms.0
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 12:29:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4ER/E+pAoWlGQSd+i/bJPappYOlr33p/scmrpdGboic=;
        b=vWxOB0mOJNBws7sZhZ1MsMVoxIecEfWpKyw72aF0yvHWO80lnoxyOg6MOe8MaXhrQq
         3vD/2yqaxB36mYEUThyw4LNAImvehaMLSdZvWIlrZq6ob98tXrl0WvXsm+ejB64rTVOq
         4ubTPnidZjPK1ya027puA+cwQbziGszVYHX0E4jbzqx+xCr5+REtaRMdphSWZhKMkBvQ
         Z1jBW3ZPeC8E0E04ldBvG1jpgdcncSwhAJ1qzGm9S6rbrFSWvSPgF10sZtfObpQbuuWV
         cfPIKfJZY4sE84ZxaKvVZmq3iBhtQFXCBsrojwNy2j4G+clzML4appxLxYgsavUM2dfW
         UuwA==
X-Gm-Message-State: AOAM531IAI8VZtjeYHD851YGi8vJ8UtDtL1/7QdD5n3cyUaY8zvQmlBi
        wbfbq1mQJWrQzQUTxXf235QFIup4SbCuLKhfBoa4qIe76ObfUZMfBGmU46eZ4RqnjRx4Y2Ny0vG
        FPKJXSFnYT367
X-Received: by 2002:a7b:cbda:0:b0:397:48d6:6c9f with SMTP id n26-20020a7bcbda000000b0039748d66c9fmr31141539wmi.10.1654630139488;
        Tue, 07 Jun 2022 12:28:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxywDhM4TJW889qZ6fx5SI3Z/EOzRQo2GCVZ6ZqoEvbpydZwXHJlLu7cLscTQQs/BhpiyqoCA==
X-Received: by 2002:a7b:cbda:0:b0:397:48d6:6c9f with SMTP id n26-20020a7bcbda000000b0039748d66c9fmr31141520wmi.10.1654630139208;
        Tue, 07 Jun 2022 12:28:59 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id h7-20020a05600c350700b0039c3b05540fsm18715587wmq.27.2022.06.07.12.28.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jun 2022 12:28:58 -0700 (PDT)
Message-ID: <e41af157-0de4-559f-9154-e259ee19166c@redhat.com>
Date:   Tue, 7 Jun 2022 21:28:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 2/3] KVM: arm64: Replace vgic_v3_uaccess_read_pending
 with vgic_uaccess_read_pending
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc:     Ricardo Koller <ricarkol@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oupton@google.com>, kernel-team@android.com
References: <20220607131427.1164881-1-maz@kernel.org>
 <20220607131427.1164881-3-maz@kernel.org>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20220607131427.1164881-3-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 6/7/22 15:14, Marc Zyngier wrote:
> Now that GICv2 has a proper userspace accessor for the pending state,
> switch GICv3 over to it, dropping the local version, moving over the
> specific behaviours that CGIv3 requires (such as the distinction
> between pending latch and line level which were never enforced
> with GICv2).
>
> We also gain extra locking that isn't really necessary for userspace,
> but that's a small price to pay for getting rid of superfluous code.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/vgic/vgic-mmio-v3.c | 40 ++----------------------------
>  arch/arm64/kvm/vgic/vgic-mmio.c    | 21 +++++++++++++++-
>  2 files changed, 22 insertions(+), 39 deletions(-)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> index f7aa7bcd6fb8..f15e29cc63ce 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> @@ -353,42 +353,6 @@ static unsigned long vgic_mmio_read_v3_idregs(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> -static unsigned long vgic_v3_uaccess_read_pending(struct kvm_vcpu *vcpu,
> -						  gpa_t addr, unsigned int len)
> -{
> -	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
> -	u32 value = 0;
> -	int i;
> -
> -	/*
> -	 * pending state of interrupt is latched in pending_latch variable.
> -	 * Userspace will save and restore pending state and line_level
> -	 * separately.
> -	 * Refer to Documentation/virt/kvm/devices/arm-vgic-v3.rst
> -	 * for handling of ISPENDR and ICPENDR.
> -	 */
> -	for (i = 0; i < len * 8; i++) {
> -		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> -		bool state = irq->pending_latch;
> -
> -		if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
> -			int err;
> -
> -			err = irq_get_irqchip_state(irq->host_irq,
> -						    IRQCHIP_STATE_PENDING,
> -						    &state);
> -			WARN_ON(err);
> -		}
> -
> -		if (state)
> -			value |= (1U << i);
> -
> -		vgic_put_irq(vcpu->kvm, irq);
> -	}
> -
> -	return value;
> -}
> -
>  static int vgic_v3_uaccess_write_pending(struct kvm_vcpu *vcpu,
>  					 gpa_t addr, unsigned int len,
>  					 unsigned long val)
> @@ -666,7 +630,7 @@ static const struct vgic_register_region vgic_v3_dist_registers[] = {
>  		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISPENDR,
>  		vgic_mmio_read_pending, vgic_mmio_write_spending,
> -		vgic_v3_uaccess_read_pending, vgic_v3_uaccess_write_pending, 1,
> +		vgic_uaccess_read_pending, vgic_v3_uaccess_write_pending, 1,
>  		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICPENDR,
>  		vgic_mmio_read_pending, vgic_mmio_write_cpending,
> @@ -750,7 +714,7 @@ static const struct vgic_register_region vgic_v3_rd_registers[] = {
>  		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_LENGTH_UACCESS(SZ_64K + GICR_ISPENDR0,
>  		vgic_mmio_read_pending, vgic_mmio_write_spending,
> -		vgic_v3_uaccess_read_pending, vgic_v3_uaccess_write_pending, 4,
> +		vgic_uaccess_read_pending, vgic_v3_uaccess_write_pending, 4,
>  		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_LENGTH_UACCESS(SZ_64K + GICR_ICPENDR0,
>  		vgic_mmio_read_pending, vgic_mmio_write_cpending,
> diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
> index dc8c52487e47..997d0fce2088 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio.c
> @@ -240,6 +240,15 @@ static unsigned long __read_pending(struct kvm_vcpu *vcpu,
>  		unsigned long flags;
>  		bool val;
>  
> +		/*
> +		 * When used from userspace with a GICv3 model:
> +		 *
> +		 * Pending state of interrupt is latched in pending_latch
> +		 * variable.  Userspace will save and restore pending state
> +		 * and line_level separately.
> +		 * Refer to Documentation/virt/kvm/devices/arm-vgic-v3.rst
> +		 * for handling of ISPENDR and ICPENDR.
> +		 */
>  		raw_spin_lock_irqsave(&irq->irq_lock, flags);
>  		if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
>  			int err;
> @@ -252,7 +261,17 @@ static unsigned long __read_pending(struct kvm_vcpu *vcpu,
>  		} else if (!is_user && vgic_irq_is_mapped_level(irq)) {
>  			val = vgic_get_phys_line_level(irq);
>  		} else {
> -			val = irq_is_pending(irq);
> +			switch (vcpu->kvm->arch.vgic.vgic_model) {
> +			case KVM_DEV_TYPE_ARM_VGIC_V3:
> +				if (is_user) {
> +					val = irq->pending_latch;
> +					break;
> +				}
> +				fallthrough;
> +			default:
> +				val = irq_is_pending(irq);
> +				break;
> +			}
>  		}
>  
>  		value |= ((u32)val << i);
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks!

Eric

