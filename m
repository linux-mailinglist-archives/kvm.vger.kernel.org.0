Return-Path: <kvm+bounces-19351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E6A7904411
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 20:54:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2BA67B25365
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 18:54:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0718079949;
	Tue, 11 Jun 2024 18:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rNZ1jR4r"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386E029429;
	Tue, 11 Jun 2024 18:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718132077; cv=none; b=MfO5TEMlS2eD2Z8MghDNOR6EkE5EpKA+fhB8iZ6kBKYtox1UuJp5hjuOwAyP+4gJJO5mhvWv7kpKcrYozSYvJ4qdQJgbb/v7DwUXWIaMW/qqjiWXoGuJBWwoiCi4TYcWhCbRYRpL3xl81xEtfg85Pmg1H1BANGFDgkmsx8KvVlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718132077; c=relaxed/simple;
	bh=yoB1eqzR1MZYP5S19pNLWNOBI6SEjHXehxDZVfJTNjA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bm/zbXnOK5YlhEbUWyy+iRzOcUPQlxZxst6OcWTxgaflH+FAQcNGI2ewsLMQSncFvtadfGk7Up/UOSk6F8EUj29I2U/1T4d7wmQdquNsal/BlFL2LuKVeiuqwP1JJxhd2upv833h8pPmoHwAnQYvOP5j+rRRP6tH8UWG7HZ2AfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rNZ1jR4r; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: jthoughton@google.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718132072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sc7vGujBfoeLmarVWsaWP93Z9rp98KxdQV4sFkCcor0=;
	b=rNZ1jR4rEN0E4jI4vUUQxETpZp9Uig3k3A0PkgW+xpMdphexak2jtxpcEOcHLVrwBir0ic
	DpUXt07tN4gIAPyrbhW2yzMNtQehGfYALren39gaCn+hy0zE6pjQfjx0BaWFZMNnlI3o1Q
	rJzk8GAmhxYpasEqj08hdUI9sVzFf/k=
X-Envelope-To: yuzhao@google.com
X-Envelope-To: akpm@linux-foundation.org
X-Envelope-To: pbonzini@redhat.com
X-Envelope-To: ankita@nvidia.com
X-Envelope-To: axelrasmussen@google.com
X-Envelope-To: catalin.marinas@arm.com
X-Envelope-To: dmatlack@google.com
X-Envelope-To: rientjes@google.com
X-Envelope-To: james.morse@arm.com
X-Envelope-To: corbet@lwn.net
X-Envelope-To: maz@kernel.org
X-Envelope-To: rananta@google.com
X-Envelope-To: ryan.roberts@arm.com
X-Envelope-To: seanjc@google.com
X-Envelope-To: shahuang@redhat.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: weixugc@google.com
X-Envelope-To: will@kernel.org
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: linux-doc@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: linux-mm@kvack.org
Date: Tue, 11 Jun 2024 11:54:24 -0700
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: James Houghton <jthoughton@google.com>
Cc: Yu Zhao <yuzhao@google.com>, Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	James Morse <james.morse@arm.com>, Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sean Christopherson <seanjc@google.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v5 4/9] mm: Add test_clear_young_fast_only MMU notifier
Message-ID: <ZmidYAWKU1HANKU6@linux.dev>
References: <20240611002145.2078921-1-jthoughton@google.com>
 <20240611002145.2078921-5-jthoughton@google.com>
 <CAOUHufYGqbd45shZkGCpqeTV9wcBDUoo3iw1SKiDeFLmrP0+=w@mail.gmail.com>
 <CADrL8HVHcKSW3hiHzKTit07gzo36jtCZCnM9ZpueyifgNdGggw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADrL8HVHcKSW3hiHzKTit07gzo36jtCZCnM9ZpueyifgNdGggw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jun 11, 2024 at 09:49:59AM -0700, James Houghton wrote:
> On Mon, Jun 10, 2024 at 10:34 PM Yu Zhao <yuzhao@google.com> wrote:
> >
> > On Mon, Jun 10, 2024 at 6:22 PM James Houghton <jthoughton@google.com> wrote:
> > >
> > > This new notifier is for multi-gen LRU specifically
> >
> > Let me call it out before others do: we can't be this self-serving.

Establishing motivation for a change is always a good idea. The wording
could be a bit crisper, but the connection between the new MMU notifier
and MGLRU is valuable. I do not view the wording of the changeset as
excluding other users of the 'fast' notifier.

> I think consolidating the callbacks is cleanest, like you had it in
> v2. I really wasn't sure about this change honestly, but it was my
> attempt to incorporate feedback like this[3] from v4. I'll consolidate
> the callbacks like you had in v2.

My strong preference is to have the callers expectations of the
secondary MMU be explicit. Having ->${BLAH}_fast_only() makes this
abundantly clear both at the callsite and in the implementation.

> Instead of the bitmap like you had, I imagine we'll have some kind of
> flags argument that has bits like MMU_NOTIFIER_YOUNG_CLEAR,
> MMU_NOTIFIER_YOUNG_FAST_ONLY, and other ones as they come up. Does
> that sound ok?
> 
> Do idle page tracking and DAMON need this new "fast-only" notifier? Or
> do they benefit from a generic API in other ways? Sorry if I missed
> this from some other mail.

Let's also keep in mind we aren't establishing an ABI here. If we have
direct line of sight (i.e. patches) on how to leverage the new MMU
notifier for DAMON and idle page tracking then great, let's try and
build something that satisfies all users. Otherwise, it isn't
that big of a deal if the interface needs to change slightly when
someone decides to leverage the MMU notifier for something else.

> I've got feedback saying that tying the definition of "fast" to MGLRU
> specifically is helpful. So instead of MMU_NOTIFIER_YOUNG_FAST_ONLY,
> maybe MMU_NOTIFIER_YOUNG_LRU_GEN_FAST to mean "do fast-for-MGLRU
> notifier". It sounds like you'd prefer the more generic one.
> 
> Thanks for the feedback -- I don't want to keep this series lingering
> on the list, so I'll try and get newer versions out sooner rather than
> later.

Let's make sure we get alignment on this before you proceed, I don't get
the sense that we're getting to a common understanding of where to go
with this.

-- 
Thanks,
Oliver

