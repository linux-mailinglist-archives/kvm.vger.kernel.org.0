Return-Path: <kvm+bounces-1237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2C3F7E5C9F
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 18:47:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 21A081C20BFF
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 17:47:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65E4C32C7E;
	Wed,  8 Nov 2023 17:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k3DC0mjM"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34E23067F
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 17:47:22 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA101FF6
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 09:47:22 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a839b31a0dso141518787b3.0
        for <kvm@vger.kernel.org>; Wed, 08 Nov 2023 09:47:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699465641; x=1700070441; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IVkizFy66FAfsWAdK2btogrIaEQgufOY4/UkfRhvJHU=;
        b=k3DC0mjMOl5KCk11y4rQGou+/uyAdLIZPlxVuxeikydiCPSaV2esDk493UaIImic7u
         9M8Wuugw3Ri14B8Bqp/tB/TdzfrSHuc61Rnaopw7RAD23wG6vfQbNqhXXHlMBqLK9lHa
         WTrVnX/S208foT50iP6/jcTAEaT26PodmjD2Wji+csg/8JDQRZ0mIU+T/rySijPXU4CU
         n4u9DjjaM2qDAkG3cx/i1cfbNb10uHTKiIrBi0HeM+71zTXWpenPUcXsLKI1DGcOZf7P
         ZRMY4sm0ChyHr6MGX6rGGWBHR+c19M7scO+IIR8QGQy9wMk27MuPHthn9CVTxjo5uUt6
         V4mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699465641; x=1700070441;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IVkizFy66FAfsWAdK2btogrIaEQgufOY4/UkfRhvJHU=;
        b=R0OuinMQD5I5rThq/TvYL9nK290Ae2D+cFz1I3kmcjFL9R7JyX3gF9hOJxkETJSYk0
         uwo501EQQjJxviwrMz2878dtcdP06Q3mxXvKw5P3fqWa03chvtTuvwp8Fvnze81Ki9di
         R8lIKiiqhuWj7hw1LCgLQZOFrTL7wYK8/Ezohmv/vSq60xtP4gJx92g3wczTZUI8Xl9r
         WZP3P+GAu9qRE3iQQ/G38lURC/UbaBd4Ab0BSF3Tp8vKuXvTqAzmZJi9aaRyVTivqcmJ
         cpQGUEcpXbpiLn6AK8mYKIFfLt0XoTDCY7V4m7n311kQRnbKi6RBovq2L30/2wct7Ihe
         B7fA==
X-Gm-Message-State: AOJu0YzSbkCmnWJZimnQa+L+5a+Uyhv4NelTupOP7tJes/KczxglvmgU
	DnSMuaLLMvnKPgW6rvGN7vmtr7Eny8M=
X-Google-Smtp-Source: AGHT+IFGMgeNBhTlSNbo0zUNxDcIYGyn74/4TSqrZUtb6vtYzdKXiG6xRMbZJyGjPwjddzpKeYYnrVYMxbA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4953:0:b0:5b3:5579:f268 with SMTP id
 w80-20020a814953000000b005b35579f268mr49804ywa.2.1699465641580; Wed, 08 Nov
 2023 09:47:21 -0800 (PST)
Date: Wed, 8 Nov 2023 09:47:19 -0800
In-Reply-To: <20231108111806.92604-3-nsaenz@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231108111806.92604-1-nsaenz@amazon.com> <20231108111806.92604-3-nsaenz@amazon.com>
Message-ID: <ZUvJp0XVVA_JrYDW@google.com>
Subject: Re: [RFC 02/33] KVM: x86: Introduce KVM_CAP_APIC_ID_GROUPS
From: Sean Christopherson <seanjc@google.com>
To: Nicolas Saenz Julienne <nsaenz@amazon.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, pbonzini@redhat.com, vkuznets@redhat.com, 
	anelkz@amazon.com, graf@amazon.com, dwmw@amazon.co.uk, jgowans@amazon.com, 
	corbert@lwn.net, kys@microsoft.com, haiyangz@microsoft.com, 
	decui@microsoft.com, x86@kernel.org, linux-doc@vger.kernel.org, 
	Anel Orazgaliyeva <anelkz@amazon.de>
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 08, 2023, Nicolas Saenz Julienne wrote:
> From: Anel Orazgaliyeva <anelkz@amazon.de>
> 
> Introduce KVM_CAP_APIC_ID_GROUPS, this capability segments the VM's APIC
> ids into two. The lower bits, the physical APIC id, represent the part
> that's exposed to the guest. The higher bits, which are private to KVM,
> groups APICs together. APICs in different groups are isolated from each
> other, and IPIs can only be directed at APICs that share the same group
> as its source. Furthermore, groups are only relevant to IPIs, anything
> incoming from outside the local APIC complex: from the IOAPIC, MSIs, or
> PV-IPIs is targeted at the default APIC group, group 0.
> 
> When routing IPIs with physical destinations, KVM will OR the source's
> vCPU APIC group with the ICR's destination ID and use that to resolve
> the target lAPIC.

Is all of the above arbitrary KVM behavior or defined by the TLFS?

> The APIC physical map is also made group aware in
> order to speed up this process. For the sake of simplicity, the logical
> map is not built while KVM_CAP_APIC_ID_GROUPS is in use and we defer IPI
> routing to the slower per-vCPU scan method.

Why?  I mean, I kinda sorta understand what it does for VSM, but it's not at all
obvious why this information needs to be shoved into the APIC IDs.  E.g. why not
have an explicit group_id and then maintain separate optimization maps for each?

> This capability serves as a building block to implement virtualisation
> based security features like Hyper-V's Virtual Secure Mode (VSM). VSM
> introduces a para-virtualised switch that allows for guest CPUs to jump
> into a different execution context, this switches into a different CPU
> state, lAPIC state, and memory protections. We model this in KVM by

Who is "we"?  As a general rule, avoid pronouns.  "we" and "us" in particular
should never show up in a changelog.  I genuinely don't know if "we" means
userspace or KVM, and the distinction matters because it clarifies whether or
not KVM is actively involved in the modeling versus KVM being little more than a
dumb pipe to provide the plumbing.

> using distinct kvm_vcpus for each context.
>
> Moreover, execution contexts are hierarchical and its APICs are meant to
> remain functional even when the context isn't 'scheduled in'.

Please explain the relationship and rules of execution contexts.  E.g. are
execution contexts the same thing as VTLs?  Do all "real" vCPUs belong to every
execution context?  If so, is that a requirement?

> For example, we have to keep track of
> timers' expirations, and interrupt execution of lesser priority contexts
> when relevant. Hence the need to alias physical APIC ids, while keeping
> the ability to target specific execution contexts.
> 
> Signed-off-by: Anel Orazgaliyeva <anelkz@amazon.de>
> Co-developed-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
> Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
> ---


> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index e1021517cf04..542bd208e52b 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -97,6 +97,8 @@ void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8);
>  void kvm_lapic_set_eoi(struct kvm_vcpu *vcpu);
>  void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value);
>  u64 kvm_lapic_get_base(struct kvm_vcpu *vcpu);
> +int kvm_vm_ioctl_set_apic_id_groups(struct kvm *kvm,
> +				    struct kvm_apic_id_groups *groups);
>  void kvm_recalculate_apic_map(struct kvm *kvm);
>  void kvm_apic_set_version(struct kvm_vcpu *vcpu);
>  void kvm_apic_after_set_mcg_cap(struct kvm_vcpu *vcpu);
> @@ -277,4 +279,35 @@ static inline u8 kvm_xapic_id(struct kvm_lapic *apic)
>  	return kvm_lapic_get_reg(apic, APIC_ID) >> 24;
>  }
>  
> +static inline u32 kvm_apic_id(struct kvm_vcpu *vcpu)
> +{
> +	return vcpu->vcpu_id & ~vcpu->kvm->arch.apic_id_group_mask;

This is *extremely* misleading.  KVM forces the x2APIC ID to match vcpu_id, but
in xAPIC mode the ID is fully writable.

