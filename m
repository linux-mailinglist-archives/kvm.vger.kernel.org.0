Return-Path: <kvm+bounces-61254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 884FBC127A1
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 02:04:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D3275E21CC
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 00:54:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5CA522A1D5;
	Tue, 28 Oct 2025 00:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mCH8Udx8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6086C225A39;
	Tue, 28 Oct 2025 00:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761612580; cv=none; b=j7WRlk3emRTNMUOhsfplN/SNb9/lZwYpET2bvzFhQVXhyzvMsk0BgPXBLR4H1yrebc93WtRZ5gDyvCApgf8mECP0cbvDMkMHCXDlGRyp7eFTtsW1KISuVYydQn9I7oCwhb3ewu8LYqnrQfi0/fmhzApMXJWIdHoaskikf8whLGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761612580; c=relaxed/simple;
	bh=BsdTtn4xjhKp2egR1TFArAMg+WL8Pdix0hYtCM/6RDY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JRVNWsoINgBAZNpBmwvwSXYbzyGRls7VG63DJT4Q9PN2ZiGsZIXuzcGOupuXW8ToXJxUJQSkfTN84/uranhq7VOOkTrp+mYFd+PrezWlvsvadg5Etm38C2qwV1fvCTaA5TVXLMHBEHzalFixYrQiRPAgbJKyUkMDVlaOAJ+93cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mCH8Udx8; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761612579; x=1793148579;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=BsdTtn4xjhKp2egR1TFArAMg+WL8Pdix0hYtCM/6RDY=;
  b=mCH8Udx8AvoymmgfhY6Wo5RJa4QOsPyVmx8F0vGJYpzk2N5mExCLlnUg
   xMkptUiATbUv0yoICoGXNxDm3XtIiw5k2ZjvtsaU51gFQGu4HTAUQe0rs
   pHVuGJVam0R5CmVQW4h+jZqUi0r7FSjsMdJ1GrGmHAfy+3ajK4xavpjOK
   +tcLKDAisMfE2v1Jyhg9BJM0Eif5EdUYgXN4P4ArP8ZHAa/nzCurLK1ly
   yoRMBDTD/UkvgvJLT3SWSfO9cnrmS2ANNLckvq6AYl3yGk0Pn4HERA1oh
   tbcZgTDqqHn1xPFL+4IpzWcWaGRZg7vGF0Skzhkc264Y5QkOT/zjGUNKb
   A==;
X-CSE-ConnectionGUID: RbiGQM4wRU6/rPJURyGKYg==
X-CSE-MsgGUID: PYdkNiRDQRm/ZA0nVROKxQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="62910004"
X-IronPort-AV: E=Sophos;i="6.19,260,1754982000"; 
   d="scan'208";a="62910004"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 17:49:38 -0700
X-CSE-ConnectionGUID: sS0NtUKwSCuOKaLQrjTsPw==
X-CSE-MsgGUID: EBedaWb/SjaaqHryd9xF1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,260,1754982000"; 
   d="scan'208";a="184826097"
Received: from jjgreens-desk15.amr.corp.intel.com (HELO desk) ([10.124.222.186])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 17:49:37 -0700
Date: Mon, 27 Oct 2025 17:49:28 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/4] KVM: VMX: Flush CPU buffers as needed if L1D
 cache flush is skipped
Message-ID: <20251028004928.muga5w3ix5dryyt2@desk>
References: <20251016200417.97003-1-seanjc@google.com>
 <20251016200417.97003-2-seanjc@google.com>
 <DDO1FFOJKSTK.3LSOUFU5RM6PD@google.com>
 <aPe5XpjqItip9KbP@google.com>
 <20251021233012.2k5scwldd3jzt2vb@desk>
 <20251022012021.sbymuvzzvx4qeztf@desk>
 <CALMp9eRpP0LvMJ=aYf45xxz1fRrx5Sf9ZrqRE8yKRcMX-+f4+A@mail.gmail.com>
 <20251027231721.irprdsyqd2klt4bf@desk>
 <CALMp9eSVt22PW+WyfNvnGcOciDQ8MkX9vDmDZ+-Q2QJUH_EvHw@mail.gmail.com>
 <20251028001950.feubf7qfq5irasjz@desk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251028001950.feubf7qfq5irasjz@desk>

On Mon, Oct 27, 2025 at 05:19:57PM -0700, Pawan Gupta wrote:
> On Mon, Oct 27, 2025 at 04:58:10PM -0700, Jim Mattson wrote:
> > On Mon, Oct 27, 2025 at 4:17 PM Pawan Gupta
> > <pawan.kumar.gupta@linux.intel.com> wrote:
> > >
> > > On Mon, Oct 27, 2025 at 03:03:23PM -0700, Jim Mattson wrote:
> > > > On Tue, Oct 21, 2025 at 6:20 PM Pawan Gupta
> > > > <pawan.kumar.gupta@linux.intel.com> wrote:
> > > > >
> > > > > ...
> > > > > Thinking more on this, the software sequence is only invoked when the
> > > > > system doesn't have the L1D flushing feature added by a microcode update.
> > > > > In such a case system is not expected to have a flushing VERW either, which
> > > > > was introduced after L1TF. Also, the admin needs to have a very good reason
> > > > > for not updating the microcode for 5+ years :-)
> > > >
> > > > KVM started reporting MD_CLEAR to userspace in Linux v5.2, but it
> > > > didn't report L1D_FLUSH to userspace until Linux v6.4, so there are
> > > > plenty of virtual CPUs with a flushing VERW that don't have the L1D
> > > > flushing feature.
> > >
> > > Shouldn't only the L0 hypervisor be doing the L1D_FLUSH?
> > >
> > > kvm_get_arch_capabilities()
> > > {
> > > ...
> > >         /*
> > >          * If we're doing cache flushes (either "always" or "cond")
> > >          * we will do one whenever the guest does a vmlaunch/vmresume.
> > >          * If an outer hypervisor is doing the cache flush for us
> > >          * (ARCH_CAP_SKIP_VMENTRY_L1DFLUSH), we can safely pass that
> > >          * capability to the guest too, and if EPT is disabled we're not
> > >          * vulnerable.  Overall, only VMENTER_L1D_FLUSH_NEVER will
> > >          * require a nested hypervisor to do a flush of its own.
> > >          */
> > >         if (l1tf_vmx_mitigation != VMENTER_L1D_FLUSH_NEVER)
> > >                 data |= ARCH_CAP_SKIP_VMENTRY_L1DFLUSH;
> > >
> > 
> > Unless L0 has chosen L1D_FLUSH_NEVER. :)
> > 
> > On GCE's L1TF-vulnerable hosts, we actually do an L1D flush at ASI
> > entry rather than VM-entry. ASI entries are two orders of magnitude
> > less frequent than VM-entries, so we get comparable protection to
> > L1D_FLUSH_ALWAYS at a fraction of the cost.
> > 
> > At the moment, we still do an L1D flush on emulated VM-entry, but
> > that's just because we have historically advertised
> > IA32_ARCH_CAPABILITIES.SKIP_L1DFL_VMENTRY to L1.
> 
> Thanks for the background.
> 
> I still don't see the problem, CPUs that are vulnerable to L1TF are also
> vulnerable to MDS. So, they don't set mmio_stale_data_clear, instead they

Sorry I meant cpu_buf_vm_clear instead of mmio_stale_data_clear (I was
looking at a slightly older kernel).

> set X86_FEATURE_CLEAR_CPU_BUF and execute VERW in __vmx_vcpu_run()
> regardless of whether L1D_FLUSH was done.
> 
> But, I agree it is best to decouple L1D flush and MMIO Stale Data to be
> avoid any confusion.

