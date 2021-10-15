Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0953042EE22
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 11:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbhJOJvM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 05:51:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50419 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230080AbhJOJvL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Oct 2021 05:51:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634291345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TSbEB3BwDLmVM1HNWqG2yqBKy93uV1whZ1iCqAbBG74=;
        b=OioLzsLrcgrvP2xvbyPotSpHDR5+WAjBIMwOpaLekDfN6NGtYXYSF6cCGIiFGZnT7KoO2D
        1mD+hRmbNKf5bU6jdgKVrYyxPSRF8N216cJjqcssX+OZ0+dX3/vyIOQ1gb+SKB17Iq6NSb
        8DmaFxS1lafCAfmzyqUHs9yI5gMznyg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-ep2Us_0XPxa824MJQAmHdg-1; Fri, 15 Oct 2021 05:49:03 -0400
X-MC-Unique: ep2Us_0XPxa824MJQAmHdg-1
Received: by mail-wr1-f72.google.com with SMTP id d13-20020adf9b8d000000b00160a94c235aso5762608wrc.2
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 02:49:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TSbEB3BwDLmVM1HNWqG2yqBKy93uV1whZ1iCqAbBG74=;
        b=BOlhbCDyHaN0DzF6ULrV4m8wOFtnj5FzTyK91IBweG44xkvB5M0fffkuXyx2tNQ9n/
         aCCDN5p1dBlZrbh54pywOpefMnGVT1Cv+P7/LdoAxbh0d7AMLAFCH3GxY0M5JzFepM9k
         jTDzwDn7diVqIVzxVgoYzug9a9QhVU+UCXWWWMa6NBmeizZRpXxFvdYmBx2cydcqIUAC
         EyhBIFBKihYeVRkARMt2AkVRQmPOTY6IT/g4JLUpKUJkTm7JVfSOphNAT1NNg/nrImZ8
         A5E7E+GeybicjZ/xb/HfonAl41wqlY0JHDZS2AMm9KPblVMbXvND7r288o/HTmgm71jG
         eACg==
X-Gm-Message-State: AOAM533Msqad6L/x/ON3HRL5xcVABNGjd4PLlosQSTO8Vxji0CTQ689w
        YRYy3Daph70/cpwPvo1o2KP5bHracuxrdC6B2GbYHrK9LugFY90hdW134rixo+ZbQ61+q8QEA0l
        EHucwWD/jey5M
X-Received: by 2002:a05:600c:19cd:: with SMTP id u13mr24821932wmq.148.1634291342646;
        Fri, 15 Oct 2021 02:49:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz/ogUflpwRDRS8wet8Xt6zPTdVYv1xkvcDCuaGAdghDK+81/p8M1BGu38LZ6JUi9aJYEj8Iw==
X-Received: by 2002:a05:600c:19cd:: with SMTP id u13mr24821913wmq.148.1634291342470;
        Fri, 15 Oct 2021 02:49:02 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id a127sm9710231wme.40.2021.10.15.02.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 02:49:02 -0700 (PDT)
Date:   Fri, 15 Oct 2021 11:49:00 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Will Deacon <will@kernel.org>, kernel-team@android.com
Subject: Re: [PATCH 0/5] KVM: arm64: Reorganise vcpu first run
Message-ID: <20211015094900.pl2gyysitpnszojy@gator>
References: <20211015090822.2994920-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211015090822.2994920-1-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 15, 2021 at 10:08:17AM +0100, Marc Zyngier wrote:
> KVM/arm64 relies heavily on a bunch of things to be done on the first
> run of the vcpu. We also do a bunch of things on PID change. It turns
> out that these two things are pretty similar (the first PID change is
> also the first run).
> 
> This small series aims at simplifying all that, and to get rid of the
> vcpu->arch.has_run_once state.
> 
> Marc Zyngier (5):
>   KVM: arm64: Move SVE state mapping at HYP to finalize-time
>   KVM: arm64: Move kvm_arch_vcpu_run_pid_change() out of line
>   KVM: arm64: Merge kvm_arch_vcpu_run_pid_change() and
>     kvm_vcpu_first_run_init()
>   KVM: arm64: Restructure the point where has_run_once is advertised

Maybe do the restructuring before the merging in order to avoid the
potential for bizarre states?

>   KVM: arm64: Drop vcpu->arch.has_run_once for vcpu->pid
> 
>  arch/arm64/include/asm/kvm_host.h | 12 +++------
>  arch/arm64/kvm/arm.c              | 43 ++++++++++++++++++-------------
>  arch/arm64/kvm/fpsimd.c           | 11 --------
>  arch/arm64/kvm/reset.c            | 11 +++++++-
>  arch/arm64/kvm/vgic/vgic-init.c   |  2 +-
>  5 files changed, 39 insertions(+), 40 deletions(-)
> 
> -- 
> 2.30.2
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
>

For the series

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

