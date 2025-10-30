Return-Path: <kvm+bounces-61442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id AAA6BC1DDCB
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 01:09:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 38C224E44C8
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 00:09:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFD197D07D;
	Thu, 30 Oct 2025 00:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Dr93NecO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06DFE3D544;
	Thu, 30 Oct 2025 00:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761782949; cv=none; b=ICfnQWRAxSStdKxuxLxvd4fYAeS+wDhlaILJF+9ilKF3/QGg4nClrk+nQTcvNU4k4nAEeIPWiz/504ALd0onN4ZHb5W6TFvUSouCkFqUl6W2FJ9F0jkvmDZUeKkOuiKYbgvcBVxeoAfOzRTjKX44fypa53qgsL4nZgQDb6EA68M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761782949; c=relaxed/simple;
	bh=9T3qGIWLqPgTfWSC6HYyKLfuop6Z7yPxOThtSja9JWc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lwsqgz6+6/nsm47w6GFrJ1GgTRbbFSByCscrYLWMBl5md+HlpqdXU1cQAfnKq8mkqnCqLhuw1fF24BOmuRugNhC2ky8RqBQSQTyLL1EoUVfSUU12Z6SeZSa6tGrf9TmlwxldmdK12oarGrPpHiQpbiOnxm+Xi4m0I4Z1n0OYlIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Dr93NecO; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761782948; x=1793318948;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9T3qGIWLqPgTfWSC6HYyKLfuop6Z7yPxOThtSja9JWc=;
  b=Dr93NecOroHdd+im00NOtlWpPL/hbln54AFGxcDyE1avXyolm1ddm5LM
   4DiW+7dSysHuru+LrhvynX8vu/1EYg0YoZERTqsAg+gB91FpY0gy7skOi
   e2P8H1mX/PvldNKsEKo6ojuzRGO2Ma93lAmxJhaXFnvys61LjwMzjmog5
   GM+PuTvqTVnQOKH1BEP2lKxIBJoZEGIQZTEvtkJ7tbRPOfRhL5MIbmwKj
   LZkQHpu668FklmORoQfkUCQlFhA1HUaH4OKjjz7Ys7kaCkLeM7VzozfuV
   KeMt7hzQmtTRtY+eNrOGLswOX0rY45DK5NzJHxQqpcJDpToYlhhyANiZs
   A==;
X-CSE-ConnectionGUID: 0YTVX4llQgakmqj7LMhggg==
X-CSE-MsgGUID: 9YEl4qqARICIW9B8o3Wn6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11597"; a="62941541"
X-IronPort-AV: E=Sophos;i="6.19,265,1754982000"; 
   d="scan'208";a="62941541"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 17:09:07 -0700
X-CSE-ConnectionGUID: p0oyC4B0TC6zgDV+fX2N5A==
X-CSE-MsgGUID: /CwW2YkrQrKtby4WMSOmyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,265,1754982000"; 
   d="scan'208";a="185462529"
Received: from vverma7-desk1.amr.corp.intel.com (HELO desk) ([10.124.223.151])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 17:09:07 -0700
Date: Wed, 29 Oct 2025 17:08:59 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: Re: [PATCH v3 2/3] x86/vmscape: Replace IBPB with branch history
 clear on exit to userspace
Message-ID: <20251030000859.ufyrqzyhvro44mol@desk>
References: <20251027-vmscape-bhb-v3-0-5793c2534e93@linux.intel.com>
 <20251027-vmscape-bhb-v3-2-5793c2534e93@linux.intel.com>
 <aQKZmoabW0M9STCa@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQKZmoabW0M9STCa@google.com>

On Wed, Oct 29, 2025 at 03:47:54PM -0700, Sean Christopherson wrote:
> On Mon, Oct 27, 2025, Pawan Gupta wrote:
> > IBPB mitigation for VMSCAPE is an overkill for CPUs that are only affected
> > by the BHI variant of VMSCAPE. On such CPUs, eIBRS already provides
> > indirect branch isolation between guest and host userspace. But, a guest
> > could still poison the branch history.
> > 
> > To mitigate that, use the recently added clear_bhb_long_loop() to isolate
> > the branch history between guest and userspace. Add cmdline option
> > 'vmscape=on' that automatically selects the appropriate mitigation based
> > on the CPU.
> > 
> > Acked-by: David Kaplan <david.kaplan@amd.com>
> > Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> > ---
> >  Documentation/admin-guide/hw-vuln/vmscape.rst   |  8 ++++
> >  Documentation/admin-guide/kernel-parameters.txt |  4 +-
> >  arch/x86/include/asm/cpufeatures.h              |  1 +
> >  arch/x86/include/asm/entry-common.h             | 12 +++---
> >  arch/x86/include/asm/nospec-branch.h            |  2 +-
> >  arch/x86/kernel/cpu/bugs.c                      | 53 ++++++++++++++++++-------
> >  arch/x86/kvm/x86.c                              |  5 ++-
> >  7 files changed, 61 insertions(+), 24 deletions(-)
> 
> For the KVM changes,
> 
> Acked-by: Sean Christopherson <seanjc@google.com>

Thank you.

