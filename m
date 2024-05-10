Return-Path: <kvm+bounces-17193-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 23A798C283F
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 17:53:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B80971F2131C
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 15:53:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 293B3171E7C;
	Fri, 10 May 2024 15:53:03 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2022171E45;
	Fri, 10 May 2024 15:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715356382; cv=none; b=mtteT2HOOzCGo//OlFeVu6EMjYchI73CEheOTUsCqAr0kmDZereOj83YIb92jhN3uT31d91CUGGbmJHRVMYKmNAjx0irRCsVqXt7rR7/vtc/OIEEhqLNO7pyvjWF5rIBWS2N3MAT5aRK4iXm4+r+L6KGb7ICD0QS4v32OhDqH5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715356382; c=relaxed/simple;
	bh=+4sZXvm3Gqi4I8ILFKfuPYd/ZE/h973QVzTsoLlBtS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=faI9os51+AWgO7N0ZogRKy86OMErqApC2SkmR7Nm3iLINZ+tgKxsU8zyX1QXhIug6IQwpn7Nmecz6ORjZxnW6UebozlZ5ewpph3CL3sDrOue4MmdUf4MQWFG9taoawAyDc6njanTZyV/n02gS9pGP1zzZDpGMoxDjWaScGPUGUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a59b097b202so523783766b.0;
        Fri, 10 May 2024 08:53:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715356379; x=1715961179;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M6CSLBPD1JVMRDYt44OaDJisYcYfySjJVMAGDPBFUPo=;
        b=Jkpc22ZIEavjR7+x75kzURYd0eefPe4jKXc0PccY/l0oUaer6K5n6SpyKBqApmc9Ia
         96pZ7DJCL3XN2JK9jLgv1iqZlaXxJ6geBycrbN4/6AbykqT+NpBTifuYAD6Wd7cce5C5
         zQWWAC8qYqDnkHy+xBEUx3UzqWFteDAA8nHNGegkMDCMCo+MMBfFLRXELfUZjcW4Llc+
         rRH1jutDtX7TRrYhUm1+SMAYSwXJOB3XxQDSdHw6nd5AhIYj8vb6YcRlsxDLn9F5lxoi
         U9Qdmqi3VioYwJ8Wnrqc3Hya0dqwVHFiO6W6M20FXVpWk+yoqv1d7XrIozbX+OSboege
         +Lrg==
X-Forwarded-Encrypted: i=1; AJvYcCW/DavawiZTzoA8qPteD2BCsCnrmmldjDJkL7KsUChsYUqgfBVvYzsXNV4Nt/RzIP3ggenfKsqw0Qtj3Gqz6aQNc0E/ESv3ULP3vVFwZbz3TRUEUzmLdgtP0dzieTItV013
X-Gm-Message-State: AOJu0YwRN6XpFKFxVHplO2682AbK4L1Mx1vczBKxzxuiffVRvDIxXKfK
	nyr76QKhO0h2YuMheYgbR/477zjdiT2UC6a86i6yMsgNFvUL6A1F
X-Google-Smtp-Source: AGHT+IGGUnNynG/k0GDVF79CArCVvLyER6wOL8kRk1i8NIAeVdxtYGo1FbEbz3miTo1c4Q/lus1HuQ==
X-Received: by 2002:a17:906:852:b0:a59:aa0d:6d with SMTP id a640c23a62f3a-a5a2d6287b5mr189905166b.62.1715356379024;
        Fri, 10 May 2024 08:52:59 -0700 (PDT)
Received: from gmail.com (fwdproxy-lla-008.fbsv.net. [2a03:2880:30ff:8::face:b00c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a5a17b01797sm198406466b.176.2024.05.10.08.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 May 2024 08:52:58 -0700 (PDT)
Date: Fri, 10 May 2024 08:52:56 -0700
From: Breno Leitao <leitao@debian.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, rbc@meta.com, paulmck@kernel.org,
	"open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: Addressing a possible race in kvm_vcpu_on_spin:
Message-ID: <Zj5C2Psbm8EY+Q4F@gmail.com>
References: <20240509090146.146153-1-leitao@debian.org>
 <Zjz9CLAIxRXlWe0F@google.com>
 <Zj3ksShWaFSWstii@gmail.com>
 <Zj4xkoMZh8zJdKyq@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zj4xkoMZh8zJdKyq@google.com>

On Fri, May 10, 2024 at 07:39:14AM -0700, Sean Christopherson wrote:
> On Fri, May 10, 2024, Breno Leitao wrote:
> > > IMO, reworking it to be like this is more straightforward:
> > > 
> > > 	int nr_vcpus, start, i, idx, yielded;
> > > 	struct kvm *kvm = me->kvm;
> > > 	struct kvm_vcpu *vcpu;
> > > 	int try = 3;
> > > 
> > > 	nr_vcpus = atomic_read(&kvm->online_vcpus);
> > > 	if (nr_vcpus < 2)
> > > 		return;
> > > 
> > > 	/* Pairs with the smp_wmb() in kvm_vm_ioctl_create_vcpu(). */
> > > 	smp_rmb();
> > 
> > Why do you need this now? Isn't the RCU read lock in xa_load() enough?
> 
> No.  RCU read lock doesn't suffice, because on kernels without PREEMPT_COUNT
> rcu_read_lock() may be a literal nop.  There may be a _compiler_ barrier, but
> smp_rmb() requires more than a compiler barrier on many architectures.

Makes sense. In fact, it makes sense to have an explicit barrier in-between
the xarray modify operations and reading/storing online_vcpus.

> > > 	kvm_vcpu_set_in_spin_loop(me, true);
> > > 
> > > 	start = READ_ONCE(kvm->last_boosted_vcpu) + 1;
> > > 	for (i = 0; i < nr_vcpus; i++) {
> > 
> > Why do you need to started at the last boosted vcpu? I.e, why not
> > starting at 0 and skipping me->vcpu_idx and kvm->last_boosted_vcpu?
> 
> To provide round-robin style yielding in order to (hopefully) yield to the vCPU
> that is holding a spinlock (or some other asset that is causing a vCPU to spin
> in kernel mode).
> 
> E.g. if there are 4 vCPUs all running on a single CPU, vCPU3 gets preempted while
> holding a spinlock, and all vCPUs are contented for said spinlock then starting
> at vCPU0 every time would result in vCPU1 yielding to vCPU0, and vCPU0 yielding
> back to vCPU1, indefinitely.

Makes sense, this would always privilege vCPU 0 in favor of the last
vCPU. 100% clear. Thanks!

