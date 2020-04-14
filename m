Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEBA21A7FAB
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 16:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390552AbgDNO0M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 10:26:12 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:42680 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390544AbgDNO0J (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Apr 2020 10:26:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586874367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uSEGx3gNn1oGf/i6GkkhJSWUv9DBqbvzJo4hv43gN+I=;
        b=MiO6kYWpZd39GQL673Mv2f46lY7jJcd6duW2hrO8ONp1egGrckndauvYXd3L3dC7yzOBhd
        iLPLPLwxmMqqb49mCvwMn6TNcXlZgWScFlR/SfMXeMf/5tiwuxWaRbDO2GpMKMlQr6BiUF
        BAhI1o8KO8ELBCYGgdzRdz9947oPB4U=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-Lqh4IpKiOma_mL_JJHsnng-1; Tue, 14 Apr 2020 10:26:05 -0400
X-MC-Unique: Lqh4IpKiOma_mL_JJHsnng-1
Received: by mail-wr1-f72.google.com with SMTP id g6so8755095wru.8
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 07:26:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=uSEGx3gNn1oGf/i6GkkhJSWUv9DBqbvzJo4hv43gN+I=;
        b=r8BnWPfsl67EnpyAbX1U5JJXoqdrpzHY0BYJN44D4gOzhsrJatRwfULUuHdiN0BAn0
         vVk2SNEVajMxd6txC/Tkpco6wnZ6Px+0n8YOI523eYUAp8o06huUXeTFeYzgzFGir7SO
         icwFBddTMqrZmTvCaWUulfVkmYVGZSx1Dr0aQ/lahurbDoVChxkMYZn0ckh9HOHp2G57
         uY5jMUipPAqNVx2NsYgA5Vp18mPzQrTeox/JV7pVJT7t0eUn0wnodszspQoZ3nMJiAjN
         RsYlYRGvTlwBBvrfP0rq/Qs93NCCdRzryQrhroUzZ2mwGWrSF7a3C+bXr++zAL47xzRq
         mt2Q==
X-Gm-Message-State: AGi0PuY3F0kd4THIY6iPzd2En2FShiC7icgabe3D4OUIZ6jlr4ipPbEe
        E0Sjs8OkghfngNnOQZjeBhUPVPrLqhvaSvoL6UqW1qrxRQxMPsNa/crRKFlJD9YYmh7RRdYIX6j
        jC7S+9Yom9fYn
X-Received: by 2002:a1c:4409:: with SMTP id r9mr102726wma.165.1586874363879;
        Tue, 14 Apr 2020 07:26:03 -0700 (PDT)
X-Google-Smtp-Source: APiQypJqgbBq9xhT1LszvRzgjgWUmQyELrXGBlfZ5uFizKdfdTJlTiXTCHR6m1nvQHHbl9Aa0nzYPg==
X-Received: by 2002:a1c:4409:: with SMTP id r9mr102702wma.165.1586874363651;
        Tue, 14 Apr 2020 07:26:03 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id v10sm7145993wrq.45.2020.04.14.07.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 07:26:03 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        tianjia.zhang@linux.alibaba.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        maz@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
        suzuki.poulose@arm.com
Subject: Re: [PATCH] KVM: Optimize kvm_arch_vcpu_ioctl_run function
In-Reply-To: <20200413034523.110548-1-tianjia.zhang@linux.alibaba.com>
References: <20200413034523.110548-1-tianjia.zhang@linux.alibaba.com>
Date:   Tue, 14 Apr 2020 16:26:01 +0200
Message-ID: <875ze2ywhy.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tianjia Zhang <tianjia.zhang@linux.alibaba.com> writes:

> kvm_arch_vcpu_ioctl_run() is only called in the file kvm_main.c,
> where vcpu->run is the kvm_run parameter, so it has been replaced.
>
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> ---
>  arch/x86/kvm/x86.c | 8 ++++----
>  virt/kvm/arm/arm.c | 2 +-
>  2 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3bf2ecafd027..70e3f4abbd4d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8726,18 +8726,18 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>  		r = -EAGAIN;
>  		if (signal_pending(current)) {
>  			r = -EINTR;
> -			vcpu->run->exit_reason = KVM_EXIT_INTR;
> +			kvm_run->exit_reason = KVM_EXIT_INTR;

I have a more generic question: why do we need to pass 'kvm_run' to
kvm_arch_vcpu_ioctl_run() if it can be extracted from 'struct kvm_vcpu'?
The only call site looks like

virt/kvm/kvm_main.c:            r = kvm_arch_vcpu_ioctl_run(vcpu, vcpu->run);

>  			++vcpu->stat.signal_exits;
>  		}
>  		goto out;
>  	}
>  
> -	if (vcpu->run->kvm_valid_regs & ~KVM_SYNC_X86_VALID_FIELDS) {
> +	if (kvm_run->kvm_valid_regs & ~KVM_SYNC_X86_VALID_FIELDS) {
>  		r = -EINVAL;
>  		goto out;
>  	}
>  
> -	if (vcpu->run->kvm_dirty_regs) {
> +	if (kvm_run->kvm_dirty_regs) {
>  		r = sync_regs(vcpu);
>  		if (r != 0)
>  			goto out;
> @@ -8767,7 +8767,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>  
>  out:
>  	kvm_put_guest_fpu(vcpu);
> -	if (vcpu->run->kvm_valid_regs)
> +	if (kvm_run->kvm_valid_regs)
>  		store_regs(vcpu);
>  	post_kvm_run_save(vcpu);
>  	kvm_sigset_deactivate(vcpu);
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 48d0ec44ad77..ab9d7966a4c8 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -659,7 +659,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		return ret;
>  
>  	if (run->exit_reason == KVM_EXIT_MMIO) {
> -		ret = kvm_handle_mmio_return(vcpu, vcpu->run);
> +		ret = kvm_handle_mmio_return(vcpu, run);
>  		if (ret)
>  			return ret;
>  	}

-- 
Vitaly

