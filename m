Return-Path: <kvm+bounces-6151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF0B382C394
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 17:31:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC1451C218A5
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 16:31:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E28085917B;
	Fri, 12 Jan 2024 16:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pjODapA9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD4C15AF6
	for <kvm@vger.kernel.org>; Fri, 12 Jan 2024 16:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbce2a8d700so8321233276.1
        for <kvm@vger.kernel.org>; Fri, 12 Jan 2024 08:31:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1705077110; x=1705681910; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bLTJ+wysBuqnwQSsCZnj62r1zQVMEhODC8W/mhh0SgY=;
        b=pjODapA98ShcyayfivGfEND9IVouZI3Jq0ER+sgg8EQDpmn9yy1bWIlLSGoS03Q7mx
         rT+1bqsjBWbYZBKmxiWMnfB/dhKB+GfLfag3/LkMsEBD5KDWL336s6RlTdLk6o0JIUBT
         k5MZVmjhEEWZCfLISsDRla4ZPyrbiKTXbWJxh94iq1NnYKiBtoqnaKBEPrWjyeQZP5o1
         jwI4AJoXKbAgTNINOsn3MoumwGREY1M+8eRfICgBJB2xFEAAHLO1NKjooWR/+VuLqk63
         t96blPWe/DK1tFlDEvEyZ6kJjTC4LypghABYXBFP8OC0QYYD3F8+T74R4o08qm/wXvKN
         sS7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705077110; x=1705681910;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bLTJ+wysBuqnwQSsCZnj62r1zQVMEhODC8W/mhh0SgY=;
        b=FzPd15/kGA5Lp9LXw9GPkjf3J6AdiNqnbX5n4lEjSHTqIr4nx0Fa/LScPpQiZYHYmv
         hK/tvuGz18HS5hI5a5Qxv/kGofv+h9Kc8/pYIomZ/I02lYLakAJ5DBtMy5VcEotq6746
         u6YLKPJoIYdqp7JfQgnIN2M+xb6W4eGRqc5v3SMdDw5kqWIJEn9ZHm1++IjKDusQZFZ8
         YE5trBGBQ/hwGKdbJAhN9yCNcCYYNw9YAkhKEo3CpXZ/eX7/vc6NGa1HUPLZHVPNDhQ1
         lvO4z2556Ta6ILnrIvtq+KOSY6bRGaCU4I+Oz2sMsTQIP0mlcxj/7WFeoKnZdzaK5nkV
         XqBg==
X-Gm-Message-State: AOJu0YzPFg8A4HuxV3va7cVeRZ/9fewP0qdN2qyMujcYLdBIuK2wEkRr
	oT8FCyhh2fzyFZv0v5PvPLo3Lz52LMN17JpgNg==
X-Google-Smtp-Source: AGHT+IE8A3RA1NRf8nD/RlJLInsKiJBR/QMvKKARb108Wy5OBnLTxaEx2o/0VzZIlpeWWDDg1xdyzMS2AwY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1364:b0:dbd:7149:a389 with SMTP id
 bt4-20020a056902136400b00dbd7149a389mr47116ybb.11.1705077109868; Fri, 12 Jan
 2024 08:31:49 -0800 (PST)
Date: Fri, 12 Jan 2024 08:31:48 -0800
In-Reply-To: <20240112074839.waglpqqgs772m4a3@yy-desk-7060>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240110012045.505046-1-seanjc@google.com> <20240112074839.waglpqqgs772m4a3@yy-desk-7060>
Message-ID: <ZaFpdMNrTeo1uDJP@google.com>
Subject: Re: [PATCH v2] KVM: x86/mmu: Retry fault before acquiring mmu_lock if
 mapping is changing
From: Sean Christopherson <seanjc@google.com>
To: Yuan Yao <yuan.yao@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 12, 2024, Yuan Yao wrote:
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 3c844e428684..92f51540c4a7 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4415,6 +4415,22 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
> >  	if (unlikely(!fault->slot))
> >  		return kvm_handle_noslot_fault(vcpu, fault, access);
> >
> > +	/*
> > +	 * Pre-check for a relevant mmu_notifier invalidation event prior to
> > +	 * acquiring mmu_lock.  If there is an in-progress invalidation and the
> > +	 * kernel allows preemption, the invalidation task may drop mmu_lock
> > +	 * and yield in response to mmu_lock being contended, which is *very*
> > +	 * counter-productive as this vCPU can't actually make forward progress
> > +	 * until the invalidation completes.  This "unsafe" check can get false
> > +	 * negatives, i.e. KVM needs to re-check after acquiring mmu_lock.  Do
> > +	 * the pre-check even for non-preemtible kernels, i.e. even if KVM will
> > +	 * never yield mmu_lock in response to contention, as this vCPU ob
> > +	 * *guaranteed* to need to retry, i.e. waiting until mmu_lock is held
> > +	 * to detect retry guarantees the worst case latency for the vCPU.
> > +	 */
> > +	if (mmu_invalidate_retry_gfn_unsafe(vcpu->kvm, fault->mmu_seq, fault->gfn))
> > +		return RET_PF_RETRY;
> 
> This breaks the contract of kvm_faultin_pfn(), i.e. the pfn's refcount
> increased after resolved from gfn, but its caller won't decrease it.

Oof, good catch.

> How about call kvm_release_pfn_clean() just before return RET_PF_RETRY here,
> so we don't need to duplicate it in 3 different places.

Hrm, yeah, that does seem to be the best option.  Thanks!

> > +
> >  	return RET_PF_CONTINUE;
> >  }
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 7e7fd25b09b3..179df96b20f8 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -2031,6 +2031,32 @@ static inline int mmu_invalidate_retry_gfn(struct kvm *kvm,
> >  		return 1;
> >  	return 0;
> >  }
> > +
> > +/*
> > + * This lockless version of the range-based retry check *must* be paired with a
> 
> s/lockess/lockless

Heh, unless mine eyes deceive me, that's what I wrote :-)

