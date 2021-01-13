Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D833C2F40B1
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 01:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436759AbhAMAnD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 19:43:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392205AbhAMAGw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 19:06:52 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D4CC061794
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 16:06:11 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id p18so263571pgm.11
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 16:06:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Y2kGns4xF1pdZj5RFaOW+nUX0XbU5fb3TCmG0vbv2qE=;
        b=beK2eEWcVF132j4Ly6FQuPSVtX61wQCbZw+HdzwPMHKTIsvZwSQcRH6xkvRX4j1uN7
         TYEchjvGrvl89EfuS3m8hm1g0+bB6xya7NSeSp6tH/k8KD5d2D2O1Dr1cQF5iOIOylnT
         9Vqb3rk2KmC8zxtEy6SzL3QoJPq3NushBvN7uNMQ0xajamQk4JsFRaoO4o09jvbSACAp
         oPkZ4VBOKmSc7FZyXbE08jfVSmdXS9IG1d40AbqRpNiktbDhdzr+wq8rSa3XWGrwypMF
         +yirW+8MgzMTeR2+FFCbAeWJ25JGIKkwgp5x4gNAsrYkp68l8DWmhTgXKRARRWh9JTXX
         /K/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y2kGns4xF1pdZj5RFaOW+nUX0XbU5fb3TCmG0vbv2qE=;
        b=p6t9YAKwwm9ILNJvNScd+n65rfAwS9WZ0sX0Lpt/hsdqUrJR7Qf6cqstNhYTzV5/u1
         1ctzzkQ/cT8JRzu5bPfPxsEqiey2vro6pQiEuF2QxYOjZmLOQowHXeHDdDuSD3O2DhOe
         ulqvVjJx43Gf1WPe4vnKSGIfE2KLxBaRCb6zitOlB2ZpiW/q9vrZ7nakwydWaWdNGm+A
         HC3inJibywztue9ASnpkmBSsetzRvyXgzYqLCeu0jW7Tj2XBQjGiB6Th3WNOFIZPHWuX
         SNKvDcXj8vS9x24Nx3MJ4u1JvbIoXDcT2tmrBEJf5tY7Oh9pukTwxyn8kMIuqQshZ7nA
         mlnw==
X-Gm-Message-State: AOAM533Yrj+3Fml4ZSNP1PAoilSmjgV8gbyCPWcMxoJNmxd3YJgs0NJ4
        3X6iNOVQcNNAgq3S9fLToxpBAw==
X-Google-Smtp-Source: ABdhPJyIttXMshDVY7FFxvSCrWWMpTDLWYWlRXclc1e8tyxRLosFTYlX9VzvSMBmCAWnjZwOPhfLBQ==
X-Received: by 2002:a62:7b84:0:b029:19c:7146:4bbb with SMTP id w126-20020a627b840000b029019c71464bbbmr1460345pfc.52.1610496371207;
        Tue, 12 Jan 2021 16:06:11 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id n15sm104711pgl.31.2021.01.12.16.06.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 16:06:10 -0800 (PST)
Date:   Tue, 12 Jan 2021 16:06:03 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Souptick Joarder <jrdr.linux@gmail.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: x86: Mark __kvm_vcpu_halt() as static
Message-ID: <X/45a2VXX7N5f/rJ@google.com>
References: <1610161772-5144-1-git-send-email-jrdr.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1610161772-5144-1-git-send-email-jrdr.linux@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jan 09, 2021, Souptick Joarder wrote:
> Kernel test robot throws below warning ->
> 
> >> arch/x86/kvm/x86.c:7979:5: warning: no previous prototype for
> >> '__kvm_vcpu_halt' [-Wmissing-prototypes]
>     7979 | int __kvm_vcpu_halt(struct kvm_vcpu *vcpu, int state, int
> reason)
>          |     ^~~~~~~~~~~~~~~
> 
> Marking __kvm_vcpu_halt() as static as it is used inside this file.

Paolo beat you to the punch, commit 872f36eb0b0f ("KVM: x86: __kvm_vcpu_halt
can be static").

> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> ---
>  arch/x86/kvm/x86.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 61499e1..c2fdf14 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -109,6 +109,7 @@
>  static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
>  static void store_regs(struct kvm_vcpu *vcpu);
>  static int sync_regs(struct kvm_vcpu *vcpu);
> +static int __kvm_vcpu_halt(struct kvm_vcpu *vcpu, int state, int reason);

FWIW, this forward declaration is unnecessary.

>  struct kvm_x86_ops kvm_x86_ops __read_mostly;
>  EXPORT_SYMBOL_GPL(kvm_x86_ops);
> @@ -7976,7 +7977,7 @@ void kvm_arch_exit(void)
>  	kmem_cache_destroy(x86_fpu_cache);
>  }
>  
> -int __kvm_vcpu_halt(struct kvm_vcpu *vcpu, int state, int reason)
> +static int __kvm_vcpu_halt(struct kvm_vcpu *vcpu, int state, int reason)
>  {
>  	++vcpu->stat.halt_exits;
>  	if (lapic_in_kernel(vcpu)) {
> -- 
> 1.9.1
> 
