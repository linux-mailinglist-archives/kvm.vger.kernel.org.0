Return-Path: <kvm+bounces-61246-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D622C12276
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 01:20:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2FAB246784A
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 00:20:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64EEB1D61A3;
	Tue, 28 Oct 2025 00:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LKlfDzGy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997BAA92E;
	Tue, 28 Oct 2025 00:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761610800; cv=none; b=eXVB/JcrfK+ibVaxoesV2ZM2L6FIhOTM5uCY2dA3tHH2SsgwbQb2zErbjQkBDa0q29yqX6vay1mDx2VhXnYTvlH/uV1ztYk/KaawD/JnYqO9yDJo7cKnW7RX9H0Y1AT+xJVxtw4iAEBeUO5srk5oyT64HtKaEHx5YGD3HbMHEwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761610800; c=relaxed/simple;
	bh=fMKpEKZyTG/cWFXRARo36nj6DVugavMF7X3PEBILtt4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TbyQ5kNHaMlm92vpFLHJLHgk5W3omWEyoXiv8P3oMUgrSToXo4JtVPSiGn4ZLY+7SPGM8uEcWfHwrU8+2hOj3JE6o15tX9XKr867LI8vnYEvWjr5Jelsq+kZR/DXNu6rcLjRS9jbqq3ne+kmD4UlP/h79dXfDqmm2b8GTUCJUsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LKlfDzGy; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761610799; x=1793146799;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=fMKpEKZyTG/cWFXRARo36nj6DVugavMF7X3PEBILtt4=;
  b=LKlfDzGyP06558Wv/2HnhOwiBLHPsqdm5si/WW1sICh9qQY2W+vyJmwU
   S5Fm2trL2pC9/mrkQbLE2NPnsCgJn8FweAjhp89sB+HhYwE+7+r6DwEzq
   0oEPPVWbz/fddmM1Y6byW36PDxPPvYSaBviQ5AB2vVqqw5xtIjh5xumPO
   3qOD1s604TdJ+RtcIHD5Fj5ScgzWBXP5SgXs7i+de+x/5LklEc5jQupxW
   rivehj66+ofq25KgqwvkjJoerbGm0mroUYsaaFGBfiJ2O90SCjtV6+Bu7
   AQ1P3OaXWoaLDPGBDjHcm1dMB6xiFm8eVNBEO2PYr0EOneXThUVEBFMnG
   w==;
X-CSE-ConnectionGUID: bQxU9gWtRWu617Y3P+qbwg==
X-CSE-MsgGUID: r1u//98KQeiypLwYihcJIw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="63601305"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="63601305"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 17:19:58 -0700
X-CSE-ConnectionGUID: gc5Eqv+kRBGHIR+oxhNF5A==
X-CSE-MsgGUID: DQOmNcgvRtGtbsliWTTx5w==
X-ExtLoop1: 1
Received: from jjgreens-desk15.amr.corp.intel.com (HELO desk) ([10.124.222.186])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 17:19:57 -0700
Date: Mon, 27 Oct 2025 17:19:50 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/4] KVM: VMX: Flush CPU buffers as needed if L1D
 cache flush is skipped
Message-ID: <20251028001950.feubf7qfq5irasjz@desk>
References: <20251016200417.97003-1-seanjc@google.com>
 <20251016200417.97003-2-seanjc@google.com>
 <DDO1FFOJKSTK.3LSOUFU5RM6PD@google.com>
 <aPe5XpjqItip9KbP@google.com>
 <20251021233012.2k5scwldd3jzt2vb@desk>
 <20251022012021.sbymuvzzvx4qeztf@desk>
 <CALMp9eRpP0LvMJ=aYf45xxz1fRrx5Sf9ZrqRE8yKRcMX-+f4+A@mail.gmail.com>
 <20251027231721.irprdsyqd2klt4bf@desk>
 <CALMp9eSVt22PW+WyfNvnGcOciDQ8MkX9vDmDZ+-Q2QJUH_EvHw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALMp9eSVt22PW+WyfNvnGcOciDQ8MkX9vDmDZ+-Q2QJUH_EvHw@mail.gmail.com>

On Mon, Oct 27, 2025 at 04:58:10PM -0700, Jim Mattson wrote:
> On Mon, Oct 27, 2025 at 4:17 PM Pawan Gupta
> <pawan.kumar.gupta@linux.intel.com> wrote:
> >
> > On Mon, Oct 27, 2025 at 03:03:23PM -0700, Jim Mattson wrote:
> > > On Tue, Oct 21, 2025 at 6:20 PM Pawan Gupta
> > > <pawan.kumar.gupta@linux.intel.com> wrote:
> > > >
> > > > ...
> > > > Thinking more on this, the software sequence is only invoked when the
> > > > system doesn't have the L1D flushing feature added by a microcode update.
> > > > In such a case system is not expected to have a flushing VERW either, which
> > > > was introduced after L1TF. Also, the admin needs to have a very good reason
> > > > for not updating the microcode for 5+ years :-)
> > >
> > > KVM started reporting MD_CLEAR to userspace in Linux v5.2, but it
> > > didn't report L1D_FLUSH to userspace until Linux v6.4, so there are
> > > plenty of virtual CPUs with a flushing VERW that don't have the L1D
> > > flushing feature.
> >
> > Shouldn't only the L0 hypervisor be doing the L1D_FLUSH?
> >
> > kvm_get_arch_capabilities()
> > {
> > ...
> >         /*
> >          * If we're doing cache flushes (either "always" or "cond")
> >          * we will do one whenever the guest does a vmlaunch/vmresume.
> >          * If an outer hypervisor is doing the cache flush for us
> >          * (ARCH_CAP_SKIP_VMENTRY_L1DFLUSH), we can safely pass that
> >          * capability to the guest too, and if EPT is disabled we're not
> >          * vulnerable.  Overall, only VMENTER_L1D_FLUSH_NEVER will
> >          * require a nested hypervisor to do a flush of its own.
> >          */
> >         if (l1tf_vmx_mitigation != VMENTER_L1D_FLUSH_NEVER)
> >                 data |= ARCH_CAP_SKIP_VMENTRY_L1DFLUSH;
> >
> 
> Unless L0 has chosen L1D_FLUSH_NEVER. :)
> 
> On GCE's L1TF-vulnerable hosts, we actually do an L1D flush at ASI
> entry rather than VM-entry. ASI entries are two orders of magnitude
> less frequent than VM-entries, so we get comparable protection to
> L1D_FLUSH_ALWAYS at a fraction of the cost.
> 
> At the moment, we still do an L1D flush on emulated VM-entry, but
> that's just because we have historically advertised
> IA32_ARCH_CAPABILITIES.SKIP_L1DFL_VMENTRY to L1.

Thanks for the background.

I still don't see the problem, CPUs that are vulnerable to L1TF are also
vulnerable to MDS. So, they don't set mmio_stale_data_clear, instead they
set X86_FEATURE_CLEAR_CPU_BUF and execute VERW in __vmx_vcpu_run()
regardless of whether L1D_FLUSH was done.

But, I agree it is best to decouple L1D flush and MMIO Stale Data to be
avoid any confusion.

