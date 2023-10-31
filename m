Return-Path: <kvm+bounces-250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CF4D7DD879
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 23:40:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27F9B28196D
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 22:40:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA46527457;
	Tue, 31 Oct 2023 22:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iyQb2LYG"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A2C4417
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 22:40:01 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A21F5
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 15:39:59 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a8d9dcdd2bso105726207b3.2
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 15:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698791999; x=1699396799; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LkerRqEcfT0+JzgZxhmV6L5Iy5i6TtOybYrAtyVVjb4=;
        b=iyQb2LYGGDjYdOx5NNHqyq8HB0Lfxnxx54fvgYxw8MCA6kbi9/te2PmX5tNc/pr5Wx
         6INZva/XbN94G+LW1Cb0lZI9sQrDmi+6RoBmuLpCVKg62msZzx+8QRwlk/jc2rKEQK01
         nMReJaD6DYIvYuuF7jDtrqVN0sb4xLm+fVRRO+CbIHpG4hMep/Zm509CU/d/Ebp9FN1R
         YCbgM8hDNFr+Wn224D1oMgcJfpmEcRl2DW+P/C4jNiJgMcBVfZa82JvKhQ8jR9fNDOTj
         HYjSx5MXsCcD3/+LSrTFKzpSlHyf64SCQUC/ymIzj0nI6Wo4OkwnuHo54q4HuNM51bQ2
         DJFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698791999; x=1699396799;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LkerRqEcfT0+JzgZxhmV6L5Iy5i6TtOybYrAtyVVjb4=;
        b=YIK5L+sJYH94pP8wNXtwtdl1MnMLbMsQNgnZ5BEhJVKwynRJ0mBXF/SIoyjUQdLoAU
         0cunuqJayoW5TB+o0Djageft8rJXSE9ZMzP8ReuRvmmSLe9vzIPfspGurO3rwm7FPla3
         Kwv2s4EsxqfpU7QzrizTYB6g2GFfTReQTj8hyYn305h8T64FUuqG0ubdjUm+nX7KE2F5
         nhWKacHNVZRMtC4Vn4tLV9058jCv5vE7OUc2FPtqPM8wpVCiS0L0UxhykKEnqYEmxZvh
         ayBpIWA7earQKinu1S212cmwnejSIFg9mPMRHAM4OdiEzRhkewyDWkI2iS42/6cbll2U
         LhcQ==
X-Gm-Message-State: AOJu0YzXHS8UHFogLVx195fTvT8+RSHY1G9LZWwlWx1W6ib6dn8GcsZn
	sq8QTChc8HqMPDVaXGS4lPTwAuIOk4c=
X-Google-Smtp-Source: AGHT+IGe3YVjvz+pWDNBrcyjJ6NX/xAY//x9OsitQ9ZfffLLYmBabs3Mf9yPLVa1FpYz9yJGhTtUGkSQKc8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:a151:0:b0:5a7:b9b0:d23f with SMTP id
 y78-20020a81a151000000b005a7b9b0d23fmr301520ywg.6.1698791998887; Tue, 31 Oct
 2023 15:39:58 -0700 (PDT)
Date: Tue, 31 Oct 2023 15:39:57 -0700
In-Reply-To: <20231031115748.622578-1-paul@xen.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231031115748.622578-1-paul@xen.org>
Message-ID: <ZUGCPQegUeTutsrb@google.com>
Subject: Re: [PATCH v2] KVM x86/xen: add an override for PVCLOCK_TSC_STABLE_BIT
From: Sean Christopherson <seanjc@google.com>
To: Paul Durrant <paul@xen.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 31, 2023, Paul Durrant wrote:
> From: Paul Durrant <pdurrant@amazon.com>
> 
> Unless explicitly told to do so (by passing 'clocksource=tsc' and
> 'tsc=stable:socket', and then jumping through some hoops concerning
> potential CPU hotplug) Xen will never use TSC as its clocksource.
> Hence, by default, a Xen guest will not see PVCLOCK_TSC_STABLE_BIT set
> in either the primary or secondary pvclock memory areas. This has
> led to bugs in some guest kernels which only become evident if
> PVCLOCK_TSC_STABLE_BIT *is* set in the pvclocks. Hence, to support
> such guests, give the VMM a new Xen HVM config flag to tell KVM to
> forcibly clear the bit in the Xen pvclocks.
> 
> Signed-off-by: Paul Durrant <pdurrant@amazon.com>
> ---
>  Documentation/virt/kvm/api.rst |  6 ++++++
>  arch/x86/kvm/x86.c             | 28 +++++++++++++++++++++++-----
>  arch/x86/kvm/xen.c             |  3 ++-
>  include/uapi/linux/kvm.h       |  1 +
>  4 files changed, 32 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 21a7578142a1..9752a01270df 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -8252,6 +8252,7 @@ PVHVM guests. Valid flags are::
>    #define KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL		(1 << 4)
>    #define KVM_XEN_HVM_CONFIG_EVTCHN_SEND		(1 << 5)
>    #define KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG	(1 << 6)
> +  #define KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE	(1 << 7)
>  
>  The KVM_XEN_HVM_CONFIG_HYPERCALL_MSR flag indicates that the KVM_XEN_HVM_CONFIG
>  ioctl is available, for the guest to set its hypercall page.
> @@ -8295,6 +8296,11 @@ behave more correctly, not using the XEN_RUNSTATE_UPDATE flag until/unless
>  specifically enabled (by the guest making the hypercall, causing the VMM
>  to enable the KVM_XEN_ATTR_TYPE_RUNSTATE_UPDATE_FLAG attribute).
>  
> +The KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE flag indicates that KVM supports
> +clearing the PVCLOCK_TSC_STABLE_BIT flag in Xen pvclock sources. This will be
> +done when the KVM_CAP_XEN_HVM ioctl sets the
> +KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE flag.
> +
>  8.31 KVM_CAP_PPC_MULTITCE
>  -------------------------
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 41cce5031126..6abad6dacf07 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3096,7 +3096,8 @@ u64 get_kvmclock_ns(struct kvm *kvm)
>  
>  static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
>  				    struct gfn_to_pfn_cache *gpc,
> -				    unsigned int offset)
> +				    unsigned int offset,
> +				    bool force_tsc_unstable)
>  {
>  	struct kvm_vcpu_arch *vcpu = &v->arch;
>  	struct pvclock_vcpu_time_info *guest_hv_clock;
> @@ -3122,6 +3123,10 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
>  	 */
>  
>  	guest_hv_clock->version = vcpu->hv_clock.version = (guest_hv_clock->version + 1) | 1;
> +
> +	if (force_tsc_unstable)
> +		guest_hv_clock->flags &= ~PVCLOCK_TSC_STABLE_BIT;

I don't see how this works.  This clears the bit in the guest copy, then clobbers
all of guest_hv_clock with a memcpy().

	if (force_tsc_unstable)
		guest_hv_clock->flags &= ~PVCLOCK_TSC_STABLE_BIT;

	smp_wmb();

	/* retain PVCLOCK_GUEST_STOPPED if set in guest copy */
	vcpu->hv_clock.flags |= (guest_hv_clock->flags & PVCLOCK_GUEST_STOPPED);

	if (vcpu->pvclock_set_guest_stopped_request) {
		vcpu->hv_clock.flags |= PVCLOCK_GUEST_STOPPED;
		vcpu->pvclock_set_guest_stopped_request = false;
	}

	memcpy(guest_hv_clock, &vcpu->hv_clock, sizeof(*guest_hv_clock)); <= sets PVCLOCK_TSC_STABLE_BIT again, no?
	smp_wmb();

Any reason not to make this a generic "capability" instead of a Xen specific flag?
E.g. I assume these problematic guests would mishandle PVCLOCK_TSC_STABLE_BIT if
it showed up in kvmclock, but they don't use kvmclock so it's not a problem in
practice.

I doubt there's a real need or use case, but it'd require less churn and IMO is
simpler overall, e.g.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e3eb608b6692..731b201bfd5a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3225,7 +3225,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 
        /* If the host uses TSC clocksource, then it is stable */
        pvclock_flags = 0;
-       if (use_master_clock)
+       if (use_master_clock && !vcpu->kvm.force_tsc_unstable)
                pvclock_flags |= PVCLOCK_TSC_STABLE_BIT;
 
        vcpu->hv_clock.flags = pvclock_flags;

I also assume this is a "set and forget" thing?  I.e. KVM can require the flag
to be set before any vCPUs are created.

