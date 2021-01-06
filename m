Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6518F2EBC22
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 11:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726018AbhAFKK6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 05:10:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32250 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725815AbhAFKK5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Jan 2021 05:10:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609927770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wSjdbFg4NJLQwoCyw1lWkPOfCwj1ksW1BVmATmrSGjM=;
        b=GguBLZB764eSml01tsyoaadRQulYHEbKNWSOU5wQjeCGc6GQszHa4INWEo0PMx+/PYmdkL
        rFrYNzmjQTQKuLg7CmtKyqAH75kqPImzYyS8gaT2OuOXrsW3RqLhnnmnGlCbpiHQxlwju4
        XQvSgk4SMwGuiovgMbIpOuIUzPg7Ch0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-B3gTPGmYObq8zWwcaShP6A-1; Wed, 06 Jan 2021 05:09:29 -0500
X-MC-Unique: B3gTPGmYObq8zWwcaShP6A-1
Received: by mail-ej1-f70.google.com with SMTP id g24so1074598ejh.22
        for <kvm@vger.kernel.org>; Wed, 06 Jan 2021 02:09:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=wSjdbFg4NJLQwoCyw1lWkPOfCwj1ksW1BVmATmrSGjM=;
        b=gdEulEqTfjBy6OFT98BkWmEPAd4TOetXrBoaw0p+IVyImyTP9lkJzOeOT/VK+DvBkT
         UDnx9Uz5RRVF+lXAHfRzGky4OXFB38ZkWAY5FZkpMQbAZfEQE6gd1DXpwcfl1m6iP0su
         v7r4x0ah2UyT7PM6YblpDs4xtCjphiIQqOtDBuGpo7dzT2ceoWjhIUXfW+rpExba0dOs
         xuRspfPWSn5fXWvopv35QXNB1mFV2upIMIMHCX49Pu57+DL2jbxGx/tqNe8Q+QL4ksTp
         SZvypjTOA5eleYizpgECzhzxlzu7oIY1ziGIF42+mG41Go0waOU6/Myc85i7IpWRBZSx
         p7yQ==
X-Gm-Message-State: AOAM533y2fqB5CTuUjwrkGmP9rTVIoMxsCLAyYiLyG9Dv5neeOEvlE0Q
        YT2HuoCN6LCnZ3q8AAHgY/x85IuCgEoN5K4e6UF6LSqzZxyTaUmHBdCIhyHxjZGPLxDAjzgVIdx
        AX8IxsnVPGxp6
X-Received: by 2002:a17:906:22c7:: with SMTP id q7mr2360275eja.486.1609927767716;
        Wed, 06 Jan 2021 02:09:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwzy3Z7B7XX+dB40OsAjYmF54OLrU/JFo24uFOV7tgw3OFSl9LhPVHOMP2BM9GYjJKCitjwCg==
X-Received: by 2002:a17:906:22c7:: with SMTP id q7mr2360264eja.486.1609927767520;
        Wed, 06 Jan 2021 02:09:27 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id u24sm1039419eje.71.2021.01.06.02.09.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 02:09:26 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, w90p710@gmail.com, pbonzini@redhat.com,
        nitesh@redhat.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Revert "KVM: x86: Unconditionally enable irqs in guest
 context"
In-Reply-To: <20210105192844.296277-1-nitesh@redhat.com>
References: <20210105192844.296277-1-nitesh@redhat.com>
Date:   Wed, 06 Jan 2021 11:09:26 +0100
Message-ID: <874kjuidgp.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nitesh Narayan Lal <nitesh@redhat.com> writes:

> This reverts commit d7a08882a0a4b4e176691331ee3f492996579534.
>
> After the introduction of the patch:
>
> 	87fa7f3e9: x86/kvm: Move context tracking where it belongs
>
> since we have moved guest_exit_irqoff closer to the VM-Exit, explicit
> enabling of irqs to process pending interrupts should not be required
> within vcpu_enter_guest anymore.
>
> Conflicts:
> 	arch/x86/kvm/svm.c
>
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> ---
>  arch/x86/kvm/svm/svm.c |  9 +++++++++
>  arch/x86/kvm/x86.c     | 11 -----------
>  2 files changed, 9 insertions(+), 11 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index cce0143a6f80..c9b2fbb32484 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4187,6 +4187,15 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
>  
>  static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
>  {
> +	kvm_before_interrupt(vcpu);
> +	local_irq_enable();
> +	/*
> +	 * We must have an instruction with interrupts enabled, so
> +	 * the timer interrupt isn't delayed by the interrupt shadow.
> +	 */
> +	asm("nop");
> +	local_irq_disable();
> +	kvm_after_interrupt(vcpu);
>  }
>  
>  static void svm_sched_in(struct kvm_vcpu *vcpu, int cpu)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3f7c1fc7a3ce..3e17c9ffcad8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9023,18 +9023,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  
>  	kvm_x86_ops.handle_exit_irqoff(vcpu);
>  
> -	/*
> -	 * Consume any pending interrupts, including the possible source of
> -	 * VM-Exit on SVM 

I kind of liked this part of the comment, the new (old) one in
svm_handle_exit_irqoff() doesn't actually explain what's going on.

> and any ticks that occur between VM-Exit and now.

Looking back, I don't quite understand why we wanted to account ticks
between vmexit and exiting guest context as 'guest' in the first place;
to my understanging 'guest time' is time spent within VMX non-root
operation, the rest is KVM overhead (system). It seems to match how the
accounting is done nowadays after Tglx's 87fa7f3e98a1 ("x86/kvm: Move
context tracking where it belongs").

> -	 * An instruction is required after local_irq_enable() to fully unblock
> -	 * interrupts on processors that implement an interrupt shadow, the
> -	 * stat.exits increment will do nicely.
> -	 */
> -	kvm_before_interrupt(vcpu);
> -	local_irq_enable();
>  	++vcpu->stat.exits;
> -	local_irq_disable();
> -	kvm_after_interrupt(vcpu);
>  
>  	if (lapic_in_kernel(vcpu)) {
>  		s64 delta = vcpu->arch.apic->lapic_timer.advance_expire_delta;

FWIW,

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

