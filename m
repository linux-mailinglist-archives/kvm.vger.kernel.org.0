Return-Path: <kvm+bounces-6150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4742582C38F
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 17:28:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A1DF1C214D1
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 16:28:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3606B745E4;
	Fri, 12 Jan 2024 16:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xPSFjvJR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174A3745E1
	for <kvm@vger.kernel.org>; Fri, 12 Jan 2024 16:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6d9c7de04d0so5386057b3a.1
        for <kvm@vger.kernel.org>; Fri, 12 Jan 2024 08:28:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1705076913; x=1705681713; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=N1LDGThbTCa8jpCR+m8/s9AcuWvCYLNXRN2os5z9iYI=;
        b=xPSFjvJR/ZpuMZE0CnIUQnxqJjxuPqG8Quh6OQEcxVGjxtaWGiWFgi+rAV59Biiiu1
         cMgiYVpmbFvoq3NeA3P9Kp6tDuD2YaySp/3k2AbislZuIP873dsD1P6nEAUy9O4vtpuW
         A65K0ZrnJ/o+ybRPzXlxta9Td4q9yaWqytzb9kDZBv+GM9h50NTxlUEmnIBHn2S96z4z
         9lEqW8u2CM4t5IR0s6G+LluIkv0yec5jCm5wfhjQ6iKmmwIWAdZsUB4IM7FcvE/MkAKC
         L2C/xeJvV5BRHKiqarxWPWm3UcMcdchg9teSIMbiYfGLroGOCHIrSnpkp5Wem4QROH+M
         A39A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705076913; x=1705681713;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N1LDGThbTCa8jpCR+m8/s9AcuWvCYLNXRN2os5z9iYI=;
        b=ELRjBnOcsL/0mAEqhIo+Ui+3ETEQlOe3Qy2ElsF1TOA3go8mMFlVMpjmXQFBE7i321
         J2QJNd4MfjD09WeHTqhZY8DlqG3iI1eQwOonghIm0AkKxU+Nx2AgZJvhRPJ4LfEooKl2
         VhEsOvDAtqk2UbqWuOU//B+zipVoG4YMdk9X/T4lQKLDhHv53bwegUMY1UIDqdmEG58U
         O8bhHzVaJhUCR3MDmcTup3jwLJCLkp4UZl1qr8z0nbU7KqxYnzvyIHZDwOOr5ev7zJ5q
         5gEgsVYwVxnsk0ytXWtJ44HHm0dgDTsN9mrtSZLsF4BbaEvgD/BF9PwzdrSBMOYKB6UD
         eazw==
X-Gm-Message-State: AOJu0YyA8xjITpBDCDz5zM+bJSahHCdf/CU1hiVupK9OQCtZzdiaN9XQ
	0+/Fi0nN5PByRnjcQwmBdMhaj9UdKE2W/f5m4g==
X-Google-Smtp-Source: AGHT+IGiqEQhfdINdVBfrluywiqsIZ1wZpnmwS5MKuiqlMrlPBzAOrB0Tj+SBJZf2lAuDYUUgJVJ783kfh4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1483:b0:6d9:f3b6:c6a9 with SMTP id
 v3-20020a056a00148300b006d9f3b6c6a9mr100097pfu.4.1705076913252; Fri, 12 Jan
 2024 08:28:33 -0800 (PST)
Date: Fri, 12 Jan 2024 08:28:31 -0800
In-Reply-To: <20240112091128.3868059-1-foxywang@tencent.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240112091128.3868059-1-foxywang@tencent.com>
Message-ID: <ZaFor2Lvdm4O2NWa@google.com>
Subject: Re: [PATCH] KVM: irqchip: synchronize srcu only if needed
From: Sean Christopherson <seanjc@google.com>
To: Yi Wang <up2wing@gmail.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, wanpengli@tencent.com, 
	Yi Wang <foxywang@tencent.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Marc Zyngier <maz@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Content-Type: text/plain; charset="us-ascii"

+other KVM maintainers

On Fri, Jan 12, 2024, Yi Wang wrote:
> From: Yi Wang <foxywang@tencent.com>
> 
> We found that it may cost more than 20 milliseconds very accidentally
> to enable cap of KVM_CAP_SPLIT_IRQCHIP on a host which has many vms
> already.
> 
> The reason is that when vmm(qemu/CloudHypervisor) invokes
> KVM_CAP_SPLIT_IRQCHIP kvm will call synchronize_srcu_expedited() and
> might_sleep and kworker of srcu may cost some delay during this period.

might_sleep() yielding is not justification for changing KVM.  That's more or
less saying "my task got preempted and took longer to run".  Well, yeah.

> Since this happens during creating vm, it's no need to synchronize srcu
> now 'cause everything is not ready(vcpu/irqfd) and none uses irq_srcu now.
> 
> Signed-off-by: Yi Wang <foxywang@tencent.com>
> ---
>  arch/x86/kvm/irq_comm.c  | 2 +-
>  include/linux/kvm_host.h | 2 ++
>  virt/kvm/irqchip.c       | 3 ++-
>  3 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
> index 16d076a1b91a..37c92b7486c7 100644
> --- a/arch/x86/kvm/irq_comm.c
> +++ b/arch/x86/kvm/irq_comm.c
> @@ -394,7 +394,7 @@ static const struct kvm_irq_routing_entry empty_routing[] = {};
>  
>  int kvm_setup_empty_irq_routing(struct kvm *kvm)
>  {
> -	return kvm_set_irq_routing(kvm, empty_routing, 0, 0);
> +	return kvm_set_irq_routing(kvm, empty_routing, 0, NONEED_SYNC_SRCU);
>  }
>  
>  void kvm_arch_post_irq_routing_update(struct kvm *kvm)
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 4944136efaa2..a46370cca355 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1995,6 +1995,8 @@ static inline int mmu_invalidate_retry_hva(struct kvm *kvm,
>  
>  #define KVM_MAX_IRQ_ROUTES 4096 /* might need extension/rework in the future */
>  
> +#define NONEED_SYNC_SRCU	(1U << 0)
> +
>  bool kvm_arch_can_set_irq_routing(struct kvm *kvm);
>  int kvm_set_irq_routing(struct kvm *kvm,
>  			const struct kvm_irq_routing_entry *entries,
> diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
> index 1e567d1f6d3d..cea5c43c1a49 100644
> --- a/virt/kvm/irqchip.c
> +++ b/virt/kvm/irqchip.c
> @@ -224,7 +224,8 @@ int kvm_set_irq_routing(struct kvm *kvm,
>  
>  	kvm_arch_post_irq_routing_update(kvm);
>  
> -	synchronize_srcu_expedited(&kvm->irq_srcu);
> +	if (!(flags & NONEED_SYNC_SRCU))
> +		synchronize_srcu_expedited(&kvm->irq_srcu);

I'm not a fan of x86 passing in a magic flag.  It's not immediately clear why
skipping synchronization is safe.  Piecing things together, _on x86_, I believe
the answer is that vCPU can't have yet been created, kvm->lock is held, _and_
kvm_arch_irqfd_allowed() will subtly reject attempts to assign irqfds if the local
APIC isn't in-kernel.

But AFAICT, s390's implementation of KVM_CREATE_IRQCHIP, which sets up identical
dummy/empty routing, doesn't provide the same guarantees.

	case KVM_CREATE_IRQCHIP: {
		struct kvm_irq_routing_entry routing;

		r = -EINVAL;
		if (kvm->arch.use_irqchip) {
			/* Set up dummy routing. */
			memset(&routing, 0, sizeof(routing));
			r = kvm_set_irq_routing(kvm, &routing, 0, 0);
		}
		break;
	}

It's entirely possible that someday, kvm_setup_empty_irq_routing() is moved to
common KVM and used for s390, at which point we have a mess on our hands because
it's not at all obvious whether or not it's safe for s390 to also skip
synchronization.

Rather than hack in a workaround for x86, I would rather we try and clean up this
mess.

Except for kvm_irq_map_gsi(), it looks like all flows assume irq_routing is
non-NULL.  But I'm not remotely confident that that holds true on all architectures,
e.g. the only reason kvm_irq_map_gsi() checks for a NULL irq_routing is because
syzkaller generated a splat (commit c622a3c21ede ("KVM: irqfd: fix NULL pointer
dereference in kvm_irq_map_gsi")).

And on x86, I'm pretty sure as of commit 654f1f13ea56 ("kvm: Check irqchip mode
before assign irqfd"), which added kvm_arch_irqfd_allowed(), it's impossible for
kvm_irq_map_gsi() to encounter a NULL irq_routing _on x86_.

But I strongly suspect other architectures can reach kvm_irq_map_gsi() with a
NULL irq_routing, e.g. RISC-V dynamically configures its interrupt controller,
yet doesn't implement kvm_arch_intc_initialized().

So instead of special casing x86, what if we instead have KVM setup an empty
IRQ routing table during kvm_create_vm(), and then avoid this mess entirely?
That way x86 and s390 no longer need to set empty/dummy routing when creating
an IRQCHIP, and the worst case scenario of userspace misusing an ioctl() is no
longer a NULL pointer deref.

