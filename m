Return-Path: <kvm+bounces-6011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 348F4829EE9
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 18:13:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AEE74B264FA
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 17:13:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61F7E4CE0E;
	Wed, 10 Jan 2024 17:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w6HM7/QC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D56495D1
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 17:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1d54269701cso29516015ad.1
        for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 09:13:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704906809; x=1705511609; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sDIYq/drjxgUSsCXqg8QTQAig3O9zOVnN2pT2/7h62s=;
        b=w6HM7/QCVi94UZxQQK5Rlhr4+O8XstUKHxHu7V9Oy0bEBa0oJt98VmvXrvmd3InCFz
         K5qzcaSrgH5Z1WC3nzjDxX2SPoX1nHdUnS2gc2hZH3UgHgaQBTMki3heym6VsKhWU2RS
         XG5Rbk9/EGsBkoXEqeZaPlTCCSEbBOjx5VG3M00U9WII+XBImWWc6ycEZz0V3QQ8l7c0
         J+Q8MDhFceXAwsAJBYg1vnbELRfXTBkiy593Id8WOl1LZIf/d/SlkPLtWScYSsjgNBUb
         bEPL9ot8bYza+cNtSous6A3B+iOBUGTL3s3NORGrXP79dXOR28+lzyW6MWz1PtfLqDxC
         P7TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704906809; x=1705511609;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sDIYq/drjxgUSsCXqg8QTQAig3O9zOVnN2pT2/7h62s=;
        b=SKND7bVZoNk7nMibR1EK0cxWNMPR/jFs9Ku8FvVGc2ZBviPyMJlRQX0w15gz/vvpY4
         tN/BNdG1B6ADddryByyOG6J5pdwuPJIMjbXc7X6VmiviQlyiajVkGZljZMh4imgJ+ZiP
         vf79Xdeq+mK6jnCtWEAPeeY/aSCZ2k6zOYZBVPKkAvnD3oJyYyfWGSZdbNfWDlnlCdPq
         5Ve6RRUNdEvYxjGMjXULnNHpSzj4FckjlHI97oySoqX+irlifaRwPrN6FvB/diu6LJgU
         Fo+mkSn8Iz40tL+rwkVrIukTb0ynGT8TYVu4rRToZ6TexS+aRWQYkYDYNZwARWaI+ujg
         vDLg==
X-Gm-Message-State: AOJu0Yxdw3FQLo/Xn258RlX/o7KIv93/NDFVGibI75b3OjjJlneZYQez
	nEEAQQ0++pngnhnPb/Pr1cvox5OxZ99VDlVvPA==
X-Google-Smtp-Source: AGHT+IG2MaIocHwm4izr1LAYY5jr9BoCXr03Dsk1+eA0kNykQpVbWCoPDSCUN7sjcfbBjoKjDfXMsBUs980=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c403:b0:1d0:559e:4125 with SMTP id
 k3-20020a170902c40300b001d0559e4125mr56820plk.3.1704906809616; Wed, 10 Jan
 2024 09:13:29 -0800 (PST)
Date: Wed, 10 Jan 2024 09:13:28 -0800
In-Reply-To: <20240110075520.psahkt47hoqodqqf@yy-desk-7060>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240110003938.490206-1-seanjc@google.com> <20240110003938.490206-3-seanjc@google.com>
 <20240110075520.psahkt47hoqodqqf@yy-desk-7060>
Message-ID: <ZZ7QOMxBwHZW8oij@google.com>
Subject: Re: [PATCH 2/4] KVM: x86: Rely solely on preempted_in_kernel flag for
 directed yield
From: Sean Christopherson <seanjc@google.com>
To: Yuan Yao <yuan.yao@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Jan 10, 2024, Yuan Yao wrote:
> On Tue, Jan 09, 2024 at 04:39:36PM -0800, Sean Christopherson wrote:
> > @@ -13093,7 +13092,7 @@ bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu)
> >
> >  bool kvm_arch_vcpu_preempted_in_kernel(struct kvm_vcpu *vcpu)
> >  {
> > -	return kvm_arch_vcpu_in_kernel(vcpu);
> > +	return vcpu->arch.preempted_in_kernel;
> >  }
> >
> >  bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu)
> > @@ -13116,9 +13115,6 @@ bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
> >  	if (vcpu->arch.guest_state_protected)
> >  		return true;
> >
> > -	if (vcpu != kvm_get_running_vcpu())
> > -		return vcpu->arch.preempted_in_kernel;
> > -
> 
> Now this function accepts vcpu parameter but can only get information from
> "current" vcpu loaded on hardware for VMX.  I'm not sure whether need
> "WARN_ON(vcpu != kvm_get_running_vcpu())" here to guard it. i.e.
> kvm_guest_state() still uses this function (although it did chekcing before).

Eh, I don't think it's worth adding a one-off kvm_get_running_vcpu() sanity check.
In the vast majority of cases, if VMREAD or VMWRITE is used improperly, the
instruction will fail at some point due to the pCPU not having any VMCS loaded.
It's really just cross-vCPU checks that could silently do the wrong thing, and
those flows are so few and far between that I'm comfortable taking a "just get
it right stance".

If we want to add sanity checks, I think my vote would be to plumb @vcpu down
into vmcs_read{16,32,64,l} and add sanity checks there, probably with some sort
of guard so that the sanity checks can be enabled only for debug kernels.

