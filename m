Return-Path: <kvm+bounces-17966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EBD5D8CC3F1
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 17:16:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2989D1C20A4C
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 15:16:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AC405FBB3;
	Wed, 22 May 2024 15:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MR8HfGt/"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D207F29422
	for <kvm@vger.kernel.org>; Wed, 22 May 2024 15:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716390982; cv=none; b=uKNnBWec9xHE8DuN1U2T2j4luaH7XET/eA9bRjd2vTkiTz7llPQ6ef+Hb+Rb6JwGGutZ3jIROu6GgimEItk7KYG9DsDnMlnrf4R/s6JVwSw/8rLT+pVNpl2OH6aoz9YNAgKq8RTJFNG2ue8qrat3y+fg+/f5ACGkcuE1lySP+tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716390982; c=relaxed/simple;
	bh=LBsuxRIt25iSTct1CaOFF4pb8q9+nLplzWcPNkULdk8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p5YhSkKWqejiee7ekEq0w6WzHFDzfu3lzmJKx11i1PMD9gzUzIslBqv2onzQ7A7gB/842jXc0Jrib0LSDUMWv1ABPeZLJLENWGpikZtIWQ4n/QB05S6Gie5oO66LG1qYEREiTU93ei6MGy9usbrgdt9/zP2b2cMmXgTVc/eZ+Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MR8HfGt/; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: seanjc@google.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1716390977;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qPx5VBeAtVusPub5h8jjoS2Zp/k7LiSDo3T23EUz3Cc=;
	b=MR8HfGt/7NWj1OeZKFuwxnVF9+ndS7xCoaOY+r1JI2bWBzf2MynLiEMDjC1DrcozAH8hei
	TUnFiYL5Pyj+E10/+shwWi4h/9LVvu0Mc6mkr1yRH6n++3msAFiuDQVzo86zkrGkaVb0hH
	6NbyKC1AGLafKPP8z0hv7d6a9IuqBaQ=
X-Envelope-To: maz@kernel.org
X-Envelope-To: zhaotianrui@loongson.cn
X-Envelope-To: maobibo@loongson.cn
X-Envelope-To: chenhuacai@kernel.org
X-Envelope-To: mpe@ellerman.id.au
X-Envelope-To: anup@brainfault.org
X-Envelope-To: paul.walmsley@sifive.com
X-Envelope-To: palmer@dabbelt.com
X-Envelope-To: aou@eecs.berkeley.edu
X-Envelope-To: borntraeger@linux.ibm.com
X-Envelope-To: frankja@linux.ibm.com
X-Envelope-To: imbrenda@linux.ibm.com
X-Envelope-To: pbonzini@redhat.com
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: loongarch@lists.linux.dev
X-Envelope-To: linux-mips@vger.kernel.org
X-Envelope-To: linuxppc-dev@lists.ozlabs.org
X-Envelope-To: kvm-riscv@lists.infradead.org
X-Envelope-To: linux-riscv@lists.infradead.org
X-Envelope-To: linux-kernel@vger.kernel.org
Date: Wed, 22 May 2024 08:16:07 -0700
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/6] KVM: Add a flag to track if a loaded vCPU is
 scheduled out
Message-ID: <Zk4MN49212SaW1_z@linux.dev>
References: <20240522014013.1672962-1-seanjc@google.com>
 <20240522014013.1672962-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240522014013.1672962-2-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, May 21, 2024 at 06:40:08PM -0700, Sean Christopherson wrote:
> Add a kvm_vcpu.scheduled_out flag to track if a vCPU is in the process of
> being scheduled out (vCPU put path), or if the vCPU is being reloaded
> after being scheduled out (vCPU load path).  In the short term, this will
> allow dropping kvm_arch_sched_in(), as arch code can query scheduled_out
> during kvm_arch_vcpu_load().
> 
> Longer term, scheduled_out opens up other potential optimizations, without
> creating subtle/brittle dependencies.  E.g. it allows KVM to keep guest
> state (that is managed via kvm_arch_vcpu_{load,put}()) loaded across
> kvm_sched_{out,in}(), if KVM knows the state isn't accessed by the host
> kernel.  Forcing arch code to coordinate between kvm_arch_sched_{in,out}()
> and kvm_arch_vcpu_{load,put}() is awkward, not reusable, and relies on the
> exact ordering of calls into arch code.
> 
> Adding scheduled_out also obviates the need for a kvm_arch_sched_out()
> hook, e.g. if arch code needs to do something novel when putting vCPU
> state.
> 
> And even if KVM never uses scheduled_out for anything beyond dropping
> kvm_arch_sched_in(), just being able to remove all of the arch stubs makes
> it worth adding the flag.
> 
> Link: https://lore.kernel.org/all/20240430224431.490139-1-seanjc@google.com
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver

