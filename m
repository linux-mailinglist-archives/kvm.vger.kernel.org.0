Return-Path: <kvm+bounces-17157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BD8E8C2068
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 11:12:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CCC331F21179
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 09:12:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 444D0168AF0;
	Fri, 10 May 2024 09:11:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D4A165FCA;
	Fri, 10 May 2024 09:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715332279; cv=none; b=Uou5GsIlNOr8gm2UQtGh27Uhnug1qCyxYngcusQYwhR6cfqcU34+nfZZFaTFv9wKFRJ2ncy66wP4RsMAedIQpxFxW+mmUY2xa+bbdtbaUwq6v2Tv69/5R9oLpY9p9g2ADJkPo5mKODwF5Sm2G0Dk2iv9FfvVBCUB5ZykeJKCoi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715332279; c=relaxed/simple;
	bh=oy8zZZH1tqYq6Cm1un3+J+lAe8+qsVk75JbBU5aux74=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XOkekPyA75ASsreLMwu++GV8dPB/5IX2TrfGUmp1LPFI0O7KXpc0/0TEnHQISl5GzopMmwByqu15Cmt+wKqc7f2O5LPSdNgJZEaJAgTw/er02G1VbLWB5vaKdVmU/8+hkg86B9WCdd6igH+zeOuSsj3PJLI7P02K6ghMNnl5/8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a59b58fe083so416279766b.0;
        Fri, 10 May 2024 02:11:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715332276; x=1715937076;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XR6Ovo4ZWCEwmB95aywDLbYo5COB1k5E4akUH/B0OJI=;
        b=Z5w9nbK5tbOb0ovsARhbVPzI8WEh9YadVpkBDgfuB+G505KNu6Nqb6dXOMQHRkI6hO
         4zOGA8G5TpG8VOj2e6Yzxh6eOHootpFnzt5kFCS09y9Q7pDwPdk6LeggZJXVXQ+qfOZm
         dRf3eTcMXxW0MUrabVfDyEhPNdeZ/0dvJuuWVRcaWmpeLJy/gKGBEoifg7Haig8YRwys
         cVqaVCsIn2fg2zaI4whhD78BpASHmLbtsTCVvtqFdIEpiTGpop8xAmEUB2HhqnogP4Fi
         dsMh/AzX7g+aSJocAd08D14zi8zYwCPY7WhsSZQqc5NR9khU5+qa+KYMUK1pt6+YhkJK
         DCsQ==
X-Forwarded-Encrypted: i=1; AJvYcCV5SrHLYe84n8jidTYp/qe9XYpIjC96kFVzx7InpW9tH79MbSPC8/FkVHISs9ZOzWELrNK5PV6JCAiqFg6G7eaKfHGYHJX+awTU9afw3FaOPbXZraJPMic7529FsX3AGM0g
X-Gm-Message-State: AOJu0YwvoI/k7Gn874GJxgwVE57Rg3qgpf5gELR9Vw4czSAtAvI+Yn5v
	n2f5m9WnasagxACS7wr76R4r/EAibKXT1j+OCpgX7krg4yoTPuD0
X-Google-Smtp-Source: AGHT+IEhPpf96zsgLjGLmAyDPP2WLUvjDRWdg00w6+mXfNk/ADqh5j745DUPW+2cmzFbBlZc54VBKg==
X-Received: by 2002:a17:906:7853:b0:a59:cdc9:6fd9 with SMTP id a640c23a62f3a-a5a2d5750acmr117965166b.21.1715332275933;
        Fri, 10 May 2024 02:11:15 -0700 (PDT)
Received: from gmail.com (fwdproxy-lla-006.fbsv.net. [2a03:2880:30ff:6::face:b00c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a5a179c7deasm160048566b.103.2024.05.10.02.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 May 2024 02:11:15 -0700 (PDT)
Date: Fri, 10 May 2024 02:11:13 -0700
From: Breno Leitao <leitao@debian.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, rbc@meta.com, paulmck@kernel.org,
	"open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: Addressing a possible race in kvm_vcpu_on_spin:
Message-ID: <Zj3ksShWaFSWstii@gmail.com>
References: <20240509090146.146153-1-leitao@debian.org>
 <Zjz9CLAIxRXlWe0F@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zjz9CLAIxRXlWe0F@google.com>

Hello Sean,

On Thu, May 09, 2024 at 09:42:48AM -0700, Sean Christopherson wrote:
> On Thu, May 09, 2024, Breno Leitao wrote:
> >  	kvm_vcpu_set_in_spin_loop(me, true);
> >  	/*
> >  	 * We boost the priority of a VCPU that is runnable but not
> > @@ -4109,7 +4110,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
> >  
> >  			yielded = kvm_vcpu_yield_to(vcpu);
> >  			if (yielded > 0) {
> > -				kvm->last_boosted_vcpu = i;
> > +				WRITE_ONCE(kvm->last_boosted_vcpu, i);
> >  				break;
> >  			} else if (yielded < 0) {
> >  				try--;
> 
> Side topic #1: am I the only one that finds these loops unnecessarily hard to
> read?

No. :-)

In fact, when I skimmed over the code, I though that maybe the code was
not covering the vCPUs before last_boosted_vcpu in the array.

Now that I am looking at it carefully, the code is using `pass` to track
if the vCPU passed last_boosted_vcpu in the index.

> Unless I'm misreading the code, it's really just an indirect way of looping
> over all vCPUs, starting at last_boosted_vcpu+1 and the wrapping.
> 
> IMO, reworking it to be like this is more straightforward:
> 
> 	int nr_vcpus, start, i, idx, yielded;
> 	struct kvm *kvm = me->kvm;
> 	struct kvm_vcpu *vcpu;
> 	int try = 3;
> 
> 	nr_vcpus = atomic_read(&kvm->online_vcpus);
> 	if (nr_vcpus < 2)
> 		return;
> 
> 	/* Pairs with the smp_wmb() in kvm_vm_ioctl_create_vcpu(). */
> 	smp_rmb();

Why do you need this now? Isn't the RCU read lock in xa_load() enough?

> 	kvm_vcpu_set_in_spin_loop(me, true);
> 
> 	start = READ_ONCE(kvm->last_boosted_vcpu) + 1;
> 	for (i = 0; i < nr_vcpus; i++) {

Why do you need to started at the last boosted vcpu? I.e, why not
starting at 0 and skipping me->vcpu_idx and kvm->last_boosted_vcpu?

> 		idx = (start + i) % nr_vcpus;
> 		if (idx == me->vcpu_idx)
> 			continue;
> 
> 		vcpu = xa_load(&kvm->vcpu_array, idx);
> 		if (!READ_ONCE(vcpu->ready))
> 			continue;
> 		if (kvm_vcpu_is_blocking(vcpu) && !vcpu_dy_runnable(vcpu))
> 			continue;
> 
> 		/*
> 		 * Treat the target vCPU as being in-kernel if it has a pending
> 		 * interrupt, as the vCPU trying to yield may be spinning
> 		 * waiting on IPI delivery, i.e. the target vCPU is in-kernel
> 		 * for the purposes of directed yield.
> 		 */
> 		if (READ_ONCE(vcpu->preempted) && yield_to_kernel_mode &&
> 		    !kvm_arch_dy_has_pending_interrupt(vcpu) &&
> 		    !kvm_arch_vcpu_preempted_in_kernel(vcpu))
> 			continue;
> 
> 		if (!kvm_vcpu_eligible_for_directed_yield(vcpu))
> 			continue;
> 
> 		yielded = kvm_vcpu_yield_to(vcpu);
> 		if (yielded > 0) {
> 			WRITE_ONCE(kvm->last_boosted_vcpu, i);
> 			break;
> 		} else if (yielded < 0 && !--try) {
> 			break;
> 		}
> 	}
> 
> 	kvm_vcpu_set_in_spin_loop(me, false);
> 
> 	/* Ensure vcpu is not eligible during next spinloop */
> 	kvm_vcpu_set_dy_eligible(me, false);

I didn't tested it, but I reviewed it, and it seems sane and way easier
to read. I agree this code is easier to read, from someone that has
little KVM background.

