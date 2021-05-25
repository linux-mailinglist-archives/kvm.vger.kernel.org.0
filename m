Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943DC390A0C
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 21:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbhEYT4r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 15:56:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38484 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231612AbhEYT4p (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 May 2021 15:56:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621972514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s19WiYHjOhcmpjd/pV4cGbioq5uqOTpKJd+KDmTMV3M=;
        b=BsZKWM2waRJ2XCglOgckNtSgCO6lpETJ/OW10eutKkfXlxI7/7h2Toa/T8jIek4H4gJyUz
        OccJ5Y4QKOf7rQCNnP9E/QMDt8/wzrQ3AuijGDM33Wjp7XmhmiJz53WFmGaq3Fdt+uGiCD
        WGyWy0WpmMaURk3CQPHK80Iy/OWIueM=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-Q5YvdzP4M6qjtgXjVixXbA-1; Tue, 25 May 2021 15:55:11 -0400
X-MC-Unique: Q5YvdzP4M6qjtgXjVixXbA-1
Received: by mail-qk1-f199.google.com with SMTP id s68-20020a372c470000b0290305f75a7cecso30782073qkh.8
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 12:55:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=s19WiYHjOhcmpjd/pV4cGbioq5uqOTpKJd+KDmTMV3M=;
        b=Pu1jLr2hKfcrLawe90kuZ0LsPgs1M4qQystTcTnyAeZAZf91qtEr0FFR0zfui6SxLv
         nITNDfPhZ9Cj0olnVlTyUUhFbbh2ZW7TuwWvi4/GCP5uj2u9HaQy8o80B83qKMfQRT39
         o4DE0Mrbm+X8cBjw9NAauzk4BiGH4Rj9mZvLEsgtvc2JVIVomGMg1ev5R2bLxH5GhCs3
         onZGjrRHwYuejHrb9co0iTlQQJkyDOd/uF06siSQjth6+2hf8biMyuowZFEA0ZFoY+rF
         FaauFZ9EqfWuMw9Tc2Kdg1zAxw4Z6nAyHyQmeqqMtXr8tZW/qbP7kzpyVgvoMg839k+X
         yong==
X-Gm-Message-State: AOAM53223uf9tXBQkT8cYXzh9vdq7wkmq1EvLW42GiftXBAN5yp//UOT
        ckY0RA5GqzfpGgUpXRFh8lcZMZf2hT6//n9eeA/dB2jBgV9AdeJkNSlGX40zzjg5ehzVXSu7Bu1
        HXdQROE0c/aNn
X-Received: by 2002:ad4:53cc:: with SMTP id k12mr39052351qvv.49.1621972510935;
        Tue, 25 May 2021 12:55:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyvAppNRgtEzNpuqbKdZzteGGOXlxDUOaHvIa8w8sOcdw7CWHOG8T69jtqQHWDsHVQZKHZawQ==
X-Received: by 2002:ad4:53cc:: with SMTP id k12mr39052329qvv.49.1621972510647;
        Tue, 25 May 2021 12:55:10 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-72-184-145-4-219.dsl.bell.ca. [184.145.4.219])
        by smtp.gmail.com with ESMTPSA id r5sm101129qtp.75.2021.05.25.12.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 12:55:10 -0700 (PDT)
Date:   Tue, 25 May 2021 15:55:09 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Pei Zhang <pezhang@redhat.com>
Subject: Re: [patch 3/3] KVM: VMX: update vcpu posted-interrupt descriptor
 when assigning device
Message-ID: <YK1WHWsA7XuwTQR3@t490s>
References: <20210525134115.135966361@redhat.com>
 <20210525134321.345140341@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210525134321.345140341@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 25, 2021 at 10:41:18AM -0300, Marcelo Tosatti wrote:
> For VMX, when a vcpu enters HLT emulation, pi_post_block will:
> 
> 1) Add vcpu to per-cpu list of blocked vcpus.
> 
> 2) Program the posted-interrupt descriptor "notification vector" 
> to POSTED_INTR_WAKEUP_VECTOR
> 
> With interrupt remapping, an interrupt will set the PIR bit for the 
> vector programmed for the device on the CPU, test-and-set the 
> ON bit on the posted interrupt descriptor, and if the ON bit is clear
> generate an interrupt for the notification vector.
> 
> This way, the target CPU wakes upon a device interrupt and wakes up
> the target vcpu.
> 
> Problem is that pi_post_block only programs the notification vector
> if kvm_arch_has_assigned_device() is true. Its possible for the
> following to happen:
> 
> 1) vcpu V HLTs on pcpu P, kvm_arch_has_assigned_device is false,
> notification vector is not programmed
> 2) device is assigned to VM
> 3) device interrupts vcpu V, sets ON bit
> (notification vector not programmed, so pcpu P remains in idle)
> 4) vcpu 0 IPIs vcpu V (in guest), but since pi descriptor ON bit is set,
> kvm_vcpu_kick is skipped
> 5) vcpu 0 busy spins on vcpu V's response for several seconds, until
> RCU watchdog NMIs all vCPUs.
> 
> To fix this, use the start_assignment kvm_x86_ops callback to kick
> vcpus out of the halt loop, so the notification vector is 
> properly reprogrammed to the wakeup vector.
> 
> Reported-by: Pei Zhang <pezhang@redhat.com>
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> 
> 
> Index: kvm/arch/x86/kvm/vmx/posted_intr.c
> ===================================================================
> --- kvm.orig/arch/x86/kvm/vmx/posted_intr.c
> +++ kvm/arch/x86/kvm/vmx/posted_intr.c
> @@ -236,6 +236,13 @@ bool pi_has_pending_interrupt(struct kvm
>  		(pi_test_sn(pi_desc) && !pi_is_pir_empty(pi_desc));
>  }
>  
> +void vmx_pi_start_assignment(struct kvm *kvm)
> +{
> +	if (!irq_remapping_cap(IRQ_POSTING_CAP))
> +		return;
> +
> +	kvm_make_all_cpus_request(kvm, KVM_REQ_UNBLOCK);

Shall we add a simple comment block explaining why we need this?

> +}

The patch itself looks right to me.

Reviewed-by: Peter Xu <peterx@redhat.com>

Thanks,

-- 
Peter Xu

