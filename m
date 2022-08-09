Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCD458E153
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 22:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343793AbiHIUrF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 16:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238239AbiHIUrD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 16:47:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CF33560C4
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 13:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660078022;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eThzIo4r7cS8CRLu3srPmTyft7Cfglr0JGqBuCZ1C5o=;
        b=TEa2AmQiyp6IJ2z4o90Od+usYRBq2R9EVikWUo6nwui9UTfTVretG5IvFpWTSl975UE0Ab
        7ipz/aoln+q80EYDllj12/m0xQ8A+knb9K42NCLwhd7lD1w6BSciHT752ZyzqTighDWIGm
        ioM81I+c64AZouzjIaOl0bNCetYG7Ck=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-p9f_l5DTNJyBPp-EidT44Q-1; Tue, 09 Aug 2022 16:47:01 -0400
X-MC-Unique: p9f_l5DTNJyBPp-EidT44Q-1
Received: by mail-qt1-f199.google.com with SMTP id hj2-20020a05622a620200b0034286e2a191so9467904qtb.2
        for <kvm@vger.kernel.org>; Tue, 09 Aug 2022 13:47:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=eThzIo4r7cS8CRLu3srPmTyft7Cfglr0JGqBuCZ1C5o=;
        b=6pTTlvBUX5COX+vSDlwTLYrCy2I4sR/ma8v8DY99VBvsDb2onGDCxAlk0IetDkzAZh
         +WvMhrxmoq7waxWAG6xnUSkP/96l77fZClUaTfx1wrVqNNGOZZED+MplxvAA1V0MD8Ct
         JyzuxfAjYvD1hdsfwp06HbHaJlOgOsVyzHeYp4949T8pwFdfVmQtMsqjiBCJMpU48nMB
         AwAGsun6n49D/T8My/hv2NfgQkv3PdB/ISm1T7njGaskJ7o1OMAHiPEVob/jiAtFkBh/
         Oi8kopsivoa5MyYMpBLMRE2csS0iEVHfa6dnzM2B8Xm4yk3QFYf40DfAMLSBjPHSmVOF
         UV5A==
X-Gm-Message-State: ACgBeo2P+IiKuAcOnpaiv4+HXP4di7iitjot3qfBpY1DQ9XJoaycAHqA
        n4+C5gMNywsijrHHWNtiRBKNKsUOx+hTQyHOyWDl+mx6S1USoTFZsiRmtn71/pzSmn18v/Dwb01
        lxKJtXDeqi+hV
X-Received: by 2002:a05:622a:1389:b0:31e:e7c1:e81a with SMTP id o9-20020a05622a138900b0031ee7c1e81amr22035102qtk.463.1660078020581;
        Tue, 09 Aug 2022 13:47:00 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7u98ZGT6GdlBvdVGVPh8IaL+Q+3KdrGphF59O/k26UF9RkV3rGxJz2PA5xvtnD/H1tO2/Y7A==
X-Received: by 2002:a05:622a:1389:b0:31e:e7c1:e81a with SMTP id o9-20020a05622a138900b0031ee7c1e81amr22035074qtk.463.1660078020357;
        Tue, 09 Aug 2022 13:47:00 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id o11-20020a05620a2a0b00b006b648d016f3sm12548608qkp.126.2022.08.09.13.46.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 13:46:59 -0700 (PDT)
Message-ID: <d39ba2b8-94d0-3191-06dc-3a34aa28f8ae@redhat.com>
Date:   Tue, 9 Aug 2022 22:46:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 4/5] KVM: irqfd: Rename resampler->notifier
Content-Language: en-US
To:     Dmytro Maluka <dmy@semihalf.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Rong L Liu <rong.l.liu@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>, upstream@semihalf.com,
        Dmitry Torokhov <dtor@google.com>
References: <20220805193919.1470653-1-dmy@semihalf.com>
 <20220805193919.1470653-5-dmy@semihalf.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20220805193919.1470653-5-dmy@semihalf.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/5/22 21:39, Dmytro Maluka wrote:
> Since resampler irqfd is now using a mask notifier along with an ack
> notifier, rename resampler->notifier to resampler->ack_notifier for
> clarity.
>
> Signed-off-by: Dmytro Maluka <dmy@semihalf.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  include/linux/kvm_irqfd.h |  2 +-
>  virt/kvm/eventfd.c        | 16 ++++++++--------
>  2 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/kvm_irqfd.h b/include/linux/kvm_irqfd.h
> index 01754a1abb9e..4df9e6bbd7db 100644
> --- a/include/linux/kvm_irqfd.h
> +++ b/include/linux/kvm_irqfd.h
> @@ -37,7 +37,7 @@ struct kvm_kernel_irqfd_resampler {
>  	 * RCU list modified under kvm->irqfds.resampler_lock
>  	 */
>  	struct list_head list;
> -	struct kvm_irq_ack_notifier notifier;
> +	struct kvm_irq_ack_notifier ack_notifier;
>  	struct kvm_irq_mask_notifier mask_notifier;
>  	bool masked;
>  	bool pending;
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index f98dcce3959c..72de942dbb9c 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -70,11 +70,11 @@ irqfd_resampler_ack(struct kvm_irq_ack_notifier *kian)
>  	bool notify = true;
>  
>  	resampler = container_of(kian,
> -			struct kvm_kernel_irqfd_resampler, notifier);
> +			struct kvm_kernel_irqfd_resampler, ack_notifier);
>  	kvm = resampler->kvm;
>  
>  	kvm_set_irq(kvm, KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID,
> -		    resampler->notifier.gsi, 0, false);
> +		    resampler->ack_notifier.gsi, 0, false);
>  
>  	spin_lock(&resampler->lock);
>  	if (resampler->masked) {
> @@ -137,11 +137,11 @@ irqfd_resampler_shutdown(struct kvm_kernel_irqfd *irqfd)
>  
>  	if (list_empty(&resampler->list)) {
>  		list_del(&resampler->link);
> -		kvm_unregister_irq_ack_notifier(kvm, &resampler->notifier);
> +		kvm_unregister_irq_ack_notifier(kvm, &resampler->ack_notifier);
>  		kvm_unregister_irq_mask_notifier(kvm, resampler->mask_notifier.irq,
>  						 &resampler->mask_notifier);
>  		kvm_set_irq(kvm, KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID,
> -			    resampler->notifier.gsi, 0, false);
> +			    resampler->ack_notifier.gsi, 0, false);
>  		kfree(resampler);
>  	}
>  
> @@ -390,7 +390,7 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
>  
>  		list_for_each_entry(resampler,
>  				    &kvm->irqfds.resampler_list, link) {
> -			if (resampler->notifier.gsi == irqfd->gsi) {
> +			if (resampler->ack_notifier.gsi == irqfd->gsi) {
>  				irqfd->resampler = resampler;
>  				break;
>  			}
> @@ -407,8 +407,8 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
>  
>  			resampler->kvm = kvm;
>  			INIT_LIST_HEAD(&resampler->list);
> -			resampler->notifier.gsi = irqfd->gsi;
> -			resampler->notifier.irq_acked = irqfd_resampler_ack;
> +			resampler->ack_notifier.gsi = irqfd->gsi;
> +			resampler->ack_notifier.irq_acked = irqfd_resampler_ack;
>  			resampler->mask_notifier.func = irqfd_resampler_mask_notify;
>  			spin_lock_init(&resampler->lock);
>  			INIT_LIST_HEAD(&resampler->link);
> @@ -417,7 +417,7 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
>  			kvm_register_and_fire_irq_mask_notifier(kvm, irqfd->gsi,
>  								&resampler->mask_notifier);
>  			kvm_register_irq_ack_notifier(kvm,
> -						      &resampler->notifier);
> +						      &resampler->ack_notifier);
>  			irqfd->resampler = resampler;
>  		}
>  

