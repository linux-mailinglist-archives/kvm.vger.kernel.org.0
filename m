Return-Path: <kvm+bounces-63670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 34850C6CE08
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 07:13:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9AE264EF4A0
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 06:11:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49EAA3148C9;
	Wed, 19 Nov 2025 06:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UEWzIuV5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E2B2EC569;
	Wed, 19 Nov 2025 06:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763532709; cv=none; b=QsioJFT81pZKAGpiIlCtHCH+Gh6NjhLMPw8Qqnr5HCC5W6++dl4vSQIECl8ZGjzPxRDOd87aG2VJ5LZzPkuUDl3HjrnfFZ7RcnIQFR3AZE4y3yn7UBC6vNF9h8itJbl1lH7nH1vvVcDyP/k+qzjiIPg3t7h1Lgl92eGkjQTROo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763532709; c=relaxed/simple;
	bh=lfGYhAnMEHMFWeej/7JxwxNjGa4RiT3X4tpYLvuB74U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D+7hg5+DzRu+AmwsY2AUKVW3cYJERFDwKEMTTEhnVJqUOjIh7yUEYMJ2iz7E8fcuu8JH2uAZLg/S+XhzGALranusgygQEJB23x49XGfikz+thU7R2mVstqLRATdt0YYFMpH2n3eteMxL+/jmLDLwlMVhuSQNPTeYmixSXnErcMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UEWzIuV5; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763532706; x=1795068706;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lfGYhAnMEHMFWeej/7JxwxNjGa4RiT3X4tpYLvuB74U=;
  b=UEWzIuV5qbEC7aVMnLXpk36/QvkVr42Nm/4W/B354n8oicjHfSh5TAWM
   /egqLiLWQ+qYs2LBrGB7S5cl84/VSfaWQlhmCvLXE9HnRPQlPozcgi98n
   NcJ1ThdCrdfozbo969mBoePirqtv6AyK0Sfpy/tB7n5bcFG4Yto1d/h2O
   MWfrIxjNWB2mRKonnKfHe9oS3QgVWDkagMwjkP5pnAdJyJdNKJB9eUx60
   ICI+l7JDzdNHAisHRIrdUtC1qE3Jkczcaow963kDeNSKgtMLAl52e/8lm
   VmZlyIxf6uXZqiDKDd6FQNlD+Bn+r2hWg4rbdCQH/cKMbtqkTOSKaxSWd
   g==;
X-CSE-ConnectionGUID: qw9wntcTQBO39aR+udE0Kg==
X-CSE-MsgGUID: HSi88XVaQ2W7a2O1v/3AXQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11617"; a="76175551"
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="76175551"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 22:11:45 -0800
X-CSE-ConnectionGUID: UvEHt3taRbescpBnug5UgA==
X-CSE-MsgGUID: do5WT3c0SquA69LBXFv00w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="228298919"
Received: from ettammin-desk.ger.corp.intel.com (HELO localhost) ([10.245.246.170])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 22:11:42 -0800
Date: Wed, 19 Nov 2025 08:11:38 +0200
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	"Kirill A. Shutemov" <kas@kernel.org>, kvm@vger.kernel.org,
	x86@kernel.org, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Jon Kohler <jon@nutanix.com>
Subject: Re: [PATCH v2 2/4] KVM: VMX: Handle #MCs on VM-Enter/TD-Enter
 outside of the fastpath
Message-ID: <aR1fmtagimoLw_5U@tlindgre-MOBL1>
References: <20251118222328.2265758-1-seanjc@google.com>
 <20251118222328.2265758-3-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251118222328.2265758-3-seanjc@google.com>

On Tue, Nov 18, 2025 at 02:23:26PM -0800, Sean Christopherson wrote:
> Handle Machine Checks (#MC) that happen on VM-Enter (VMX or TDX) outside
> of KVM's fastpath so that as much host state as possible is re-loaded
> before invoking the kernel's #MC handler.  The only requirement is that
> KVM invokes the #MC handler before enabling IRQs (and even that could
> _probably_ be related to handling #MCs before enabling preemption).
> 
> Waiting to handle #MCs until "more" host state is loaded hardens KVM
> against flaws in the #MC handler, which has historically been quite
> brittle. E.g. prior to commit 5567d11c21a1 ("x86/mce: Send #MC singal from
> task work"), the #MC code could trigger a schedule() with IRQs and
> preemption disabled.  That led to a KVM hack-a-fix in commit 1811d979c716
> ("x86/kvm: move kvm_load/put_guest_xcr0 into atomic context").
> 
> Note, vmx_handle_exit_irqoff() is common to VMX and TDX guests.

Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>

