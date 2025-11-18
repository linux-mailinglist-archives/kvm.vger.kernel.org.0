Return-Path: <kvm+bounces-63614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 77852C6BF99
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 00:22:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A1BFC4E7233
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 23:22:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 587232F9DB1;
	Tue, 18 Nov 2025 23:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="trjelSWc"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758E7277011
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 23:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763508131; cv=none; b=I0R57gmSjRMspeVE90HnHY8IsypLRNMOn2J3HsVGJfsO+/9mmI4xcJLp2FI1p4JtIn7oM6AAtPLPULxvf5GuaPnJn7iLIDvAUcc0w+7WwAVZjXY2Nnsx3DYq9lUBCvL20GSirBsq26qmbIKDLWJ48i3X+wIVhlxlq5KrL6OGFdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763508131; c=relaxed/simple;
	bh=DiAgxDFtjlbuMqb2zqoBERfAzyYwelqZOvBSG7dO4rI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L7bjf+pQGMJuO3VB0Jd44gPdaVW6p/EGNtD1lqRCf6V7yXyX1hCFhyGqYtIg5uMzapy543vT7PSrWmbivN5nWUqWr9k6Crl4UNV/twHaAzTLEfeMSwLNlXa6+xvpHYfPf5vcjNr03fd1kCwrxzq5npGSwxXduj5CT6jMKFPD4Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=trjelSWc; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 18 Nov 2025 23:22:00 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763508125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tYDUdw/GKuvu5FdksvdRnNpbZ8B5Scc+7yt8EoVRbjc=;
	b=trjelSWc5lwstnd5KJid6VkjmXib/j9tC/U4M4g3XltXnY3gQ7c56C3hZu3BDNxCbI0NZx
	YL3/cUztxTzensB96WcDE7kK0aD65EH/HQ1QlEva7vnoL7R7c5yYmay+2of6a6ZObIC7gW
	IDMkHwMOdsvQaVL5E2pKneaHUO/O4NE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/23] Extend test coverage for nested SVM
Message-ID: <gcyh7dlszzaj3wnp3fu3x6loedfhzds55kxvubxm53deb4yodm@3xk4mt32nf3j>
References: <20251021074736.1324328-1-yosry.ahmed@linux.dev>
 <n5cjwr3klovu7tqcchptvmr6yieyhvnv5muv7zyvcbo5itskew@6rzo4ohctdhv>
 <CALMp9eQuWx--Ef7Sxasq=MZMGPTg2ZUL0CXHH+Hvj7YEL_ipVg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALMp9eQuWx--Ef7Sxasq=MZMGPTg2ZUL0CXHH+Hvj7YEL_ipVg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Nov 18, 2025 at 03:00:26PM -0800, Jim Mattson wrote:
> On Tue, Nov 18, 2025 at 2:26 PM Yosry Ahmed <yosry.ahmed@linux.dev> wrote:
> >
> > On Tue, Oct 21, 2025 at 07:47:13AM +0000, Yosry Ahmed wrote:
> > > There are multiple selftests exercising nested VMX that are not specific
> > > to VMX (at least not anymore). Extend their coverage to nested SVM.
> > >
> > > This version is significantly different (and longer) than v1 [1], mainly
> > > due to the change of direction to reuse __virt_pg_map() for nested EPT/NPT
> > > mappings instead of extending the existing nested EPT infrastructure. It
> > > also has a lot more fixups and cleanups.
> > >
> > > This series depends on two other series:
> > > - "KVM: SVM: GIF and EFER.SVME are independent" [2]
> > > - "KVM: selftests: Add test of SET_NESTED_STATE with 48-bit L2 on 57-bit L1" [3]
> >
> > v2 of Jim's series switches all tests to use 57-bit by default when
> > available:
> > https://lore.kernel.org/kvm/20251028225827.2269128-4-jmattson@google.com/
> >
> > This breaks moving nested EPT mappings to use __virt_pg_map() because
> > nested EPTs are hardcoded to use 4-level paging, while __virt_pg_map()
> > will assume we're using 5-level paging.
> >
> > Patch #16 ("KVM: selftests: Use __virt_pg_map() for nested EPTs") will
> > need the following diff to make nested EPTs use the same paging level as
> > the guest:
> >
> > diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
> > index 358143bf8dd0d..8bacb74c00053 100644
> > --- a/tools/testing/selftests/kvm/lib/x86/vmx.c
> > +++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
> > @@ -203,7 +203,7 @@ static inline void init_vmcs_control_fields(struct vmx_pages *vmx)
> >                 uint64_t ept_paddr;
> >                 struct eptPageTablePointer eptp = {
> >                         .memory_type = X86_MEMTYPE_WB,
> > -                       .page_walk_length = 3, /* + 1 */
> > +                       .page_walk_length = get_cr4() & X86_CR4_LA57 ? 4 : 3, /* + 1 */
> 
> LA57 does not imply support for 5-level EPT. (SRF, IIRC)

Huh, that's annoying. We can keep the EPTs hardcoded to 4 levels and
pass in the max level to __virt_pg_map() instead of hardcoding
vm->pgtable_levels.

Sean, let me know how you want to handle this. I can fix this and rebase
the series (or part of it?), or you can fix it up if you prefer to do
so.

