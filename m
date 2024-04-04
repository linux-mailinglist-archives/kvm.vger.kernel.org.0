Return-Path: <kvm+bounces-13620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 94B088991C0
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 01:02:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 316771F22BB2
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 23:02:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1957513C3CA;
	Thu,  4 Apr 2024 23:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GRnQvFaT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58406286A6;
	Thu,  4 Apr 2024 23:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712271770; cv=none; b=BPea717iIah5jlgdMeilO/eoET+DpXK7fhJEjsrFYCGld6WfkgZ3RvGoJGliUoJFbQjupoVvbw0TYsWJHn1exUll0mbR4WXAM+wcpNYrqoWIrcIZQZEv5li6HRIwlpPwWqAjjNbSEHvbk/CwkzFBNo6644Mo76plHTiTWK5k7qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712271770; c=relaxed/simple;
	bh=GxxcTwd9Kj+TRtgAeuoV9VK7A5mv7deIX4spdFzPU3w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=INb3haMGfPEYn6LYY7jUSqWbtX6a5rOlv7s56PtjbjgDFDZcINTGWtvdSrj6KeVeLWubW9cTcTqzs0z9DLU924CTvoYXn8QMva2vZ7w7weI1udH980LvtakQTTQeeuwZ4nlDTKYi/4Vl0qciA6nxERuKwzOVSr3Fsq1Wdjpp538=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GRnQvFaT; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712271769; x=1743807769;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GxxcTwd9Kj+TRtgAeuoV9VK7A5mv7deIX4spdFzPU3w=;
  b=GRnQvFaTQfmLrvVzYUgCsDAGQmc05iKPeV5reop7uMurxd+d/qy6ytO9
   XfLA/3nF5AX8OrznRWuGaukwa+5NFdMuYkq+0PX7l/Gc5lXatpjCrrOpW
   9q+6Vl+X4E717p5ORjaBKkNsThWWvigsLtqDrKheeviHLjO9qzp8MNWIi
   DrWC7ULZYZTPPAZrm/Ads8Cqc1yt78Mx33za80k4KzqtxJSPQivtHunSf
   aoMZBIxt4bFRYbvIyonx2FQdHO/hN7jdynwQO8ceJ/0KI8PMhqbuvTEqQ
   SGPlYmlbvL9JyobiqyC0j8lEu5z6vy0zcWx/nwqBQTVtfOahEh46nAiFW
   w==;
X-CSE-ConnectionGUID: 0Uu3qnx+QIiWhivB63PNKw==
X-CSE-MsgGUID: rk3OKrVbQwWypy0A8rJv4A==
X-IronPort-AV: E=McAfee;i="6600,9927,11034"; a="8167614"
X-IronPort-AV: E=Sophos;i="6.07,180,1708416000"; 
   d="scan'208";a="8167614"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2024 16:02:48 -0700
X-CSE-ConnectionGUID: U+bSPPzURaKcsT3Bxrb6IA==
X-CSE-MsgGUID: ANqWJIqFSKuzIf2aG27MmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,180,1708416000"; 
   d="scan'208";a="23605646"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2024 16:02:48 -0700
Date: Thu, 4 Apr 2024 16:02:47 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 106/130] KVM: TDX: Add KVM Exit for TDX TDG.VP.VMCALL
Message-ID: <20240404230247.GU2444378@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <b9fbb0844fc6505f8fb1e9a783615b299a5a5bb3.1708933498.git.isaku.yamahata@intel.com>
 <Zg18ul8Q4PGQMWam@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zg18ul8Q4PGQMWam@google.com>

On Wed, Apr 03, 2024 at 08:58:50AM -0700,
Sean Christopherson <seanjc@google.com> wrote:

> On Mon, Feb 26, 2024, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Some of TDG.VP.VMCALL require device model, for example, qemu, to handle
> > them on behalf of kvm kernel module. TDVMCALL_REPORT_FATAL_ERROR,
> > TDVMCALL_MAP_GPA, TDVMCALL_SETUP_EVENT_NOTIFY_INTERRUPT, and
> > TDVMCALL_GET_QUOTE requires user space VMM handling.
> > 
> > Introduce new kvm exit, KVM_EXIT_TDX, and functions to setup it. Device
> > model should update R10 if necessary as return value.
> 
> Hard NAK.
> 
> KVM needs its own ABI, under no circumstance should KVM inherit ABI directly from
> the GHCI.  Even worse, this doesn't even sanity check the "unknown" VMCALLs, KVM
> just blindly punts *everything* to userspace.  And even worse than that, KVM
> already has at least one user exit that overlaps, TDVMCALL_MAP_GPA => KVM_HC_MAP_GPA_RANGE.
> 
> If the userspace VMM wants to run an end-around on KVM and directly communicate
> with the guest, e.g. via a synthetic device (a la virtio), that's totally fine,
> because *KVM* is not definining any unique ABI, KVM is purely providing the
> transport, e.g. emulated MMIO or PIO (and maybe not even that).  IIRC, this option
> even came up in the context of GET_QUOTE.
> 
> But explicit exiting to userspace with KVM_EXIT_TDX is very different.  KVM is
> creating a contract with userspace that says "for TDX VMCALLs [a-z], KVM will exit
> to userspace with values [a-z]".  *Every* new VMCALL that's added to the GHCI will
> become KVM ABI, e.g. if Intel ships a TDX module that adds a new VMALL, then KVM
> will forward the exit to userspace, and userspace can then start relying on that
> behavior.
> 
> And punting all register state, decoding, etc. to userspace creates a crap ABI.
> KVM effectively did this for SEV and SEV-ES by copying the PSP ABI verbatim into
> KVM ioctls(), and it's a gross, ugly mess.
> 
> Each VMCALL that KVM wants to forward needs a dedicated KVM_EXIT_<reason> and
> associated struct in the exit union.  Yes, it's slightly more work now, but it's
> one time pain.  Whereas copying all registers is endless misery for everyone
> involved, e.g. *every* userspace VMM needs to decipher the registers, do sanity
> checking, etc.  And *every* end user needs to do the same when a debugging
> inevitable failures.
> 
> This also solves Chao's comment about XMM registers.  Except for emualting Hyper-V
> hypercalls, which have very explicit handling, KVM does NOT support using XMM
> registers in hypercalls.

Sure. I will introduce the followings.

KVM_EXIT_TDX_GET_QUOTE
  Request a quote.

KVM_EXIT_TDX_SETUP_EVENT_NOTIFY_INTERRUPT
  Guest tells which interrupt vector the VMM uses to notify the guest.
  The use case if GetQuote. It is async request.  The user-space VMM uses
  this interrupts to notify the guest on the completion. Or guest polls it.

KVM_EXIT_TDX_REPORT_FATAL_ERROR
  Guest panicked. This conveys extra 64 bytes in registers. Probably this should
  be converted to KVM_EXIT_SYSTEM_EVENT and KVM_SYSTEM_EVENT_CRASH.
  
MapGPA is converted to KVM_HC_MAP_GPA_RANGE.

-- 
Isaku Yamahata <isaku.yamahata@intel.com>

