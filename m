Return-Path: <kvm+bounces-13038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2180890C47
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 22:10:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F2D5F1C2B6F8
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 21:10:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9D2413AA23;
	Thu, 28 Mar 2024 21:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gt8adpfT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0894B52F62;
	Thu, 28 Mar 2024 21:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711660240; cv=none; b=BDceeqXebqQbDXPBKvZ1Y8vem3UmZZZsgBnJEpb0W7vN5H+BpnfPG2OHRKvFgCDp9GTQLgzXLEXImFWW2sNkkEIi9hPmcALxDplnMmQBxQh92PJVkPTlidk417eAeG1BOZEkqjFPkVM+3mXSIv7gcn0sMvG4jFhWEceL60U5NZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711660240; c=relaxed/simple;
	bh=GR+8vhdZaMF0jMh5JD8q+n8JbP3PzmlEhT9CqXSNA70=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HuYUeb/3rdE9eXEEAw0VzGqee1fOXQqPiJQCh/0zQzmlJgPOUDQYgBa9eZAeesdHddUtzwW+5FQTTMDQvHZ8ByQucB6bF3ZtZAPa8aInVkKeQB2cjSTRXryll7rYsH8iu1252N2vRgb7NzOYebBCbk1+3+76cclG8RZevBXV8vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gt8adpfT; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711660238; x=1743196238;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GR+8vhdZaMF0jMh5JD8q+n8JbP3PzmlEhT9CqXSNA70=;
  b=Gt8adpfThIuDKUzLWYmz0pj5cTq+D0mMwFD7vxmNd/1O8AJd/mgG1rs9
   1XQL2vxh3/jTMiNT47ju0WI2kVrOdVF1nRQcL0WNBw47soy4Z0ujcTubh
   yDlLKRI3zkvac/QvEV8zirmVRP4AvShabdFC0oeGetU1WfASb9IRjjUXF
   w/+Qzy4nyzPa4KqFOsmpkvg7+bJOhJ1k82Qkhtsn746gMnlw/sNubVKPm
   15otbGuVTFFU1I2txFkhqIQQQYgvdHtO4X6qAXDG4e8IkS/WhVoMHt3Fb
   7q78ShxrxC4sddjc8CfsjEAOmgWHL1jGjBw88E/CDZtoX4bSCXdIxoGtZ
   w==;
X-CSE-ConnectionGUID: a6FstP4gSNmV1iT1kg7uDQ==
X-CSE-MsgGUID: KBNOV1JLTYiy0CIBGCkCbQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="6956294"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="6956294"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 14:10:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16824858"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 14:10:37 -0700
Date: Thu, 28 Mar 2024 14:10:36 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 091/130] KVM: TDX: remove use of struct vcpu_vmx from
 posted_interrupt.c
Message-ID: <20240328211036.GS2444378@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <6c7774a44515d6787c9512cb05c3b305e9b5855c.1708933498.git.isaku.yamahata@intel.com>
 <ZgUmdIM67dybDTCn@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZgUmdIM67dybDTCn@chao-email>

On Thu, Mar 28, 2024 at 04:12:36PM +0800,
Chao Gao <chao.gao@intel.com> wrote:

> On Mon, Feb 26, 2024 at 12:26:33AM -0800, isaku.yamahata@intel.com wrote:
> >@@ -190,7 +211,8 @@ static bool vmx_needs_pi_wakeup(struct kvm_vcpu *vcpu)
> > 	 * notification vector is switched to the one that calls
> > 	 * back to the pi_wakeup_handler() function.
> > 	 */
> >-	return vmx_can_use_ipiv(vcpu) || vmx_can_use_vtd_pi(vcpu->kvm);
> >+	return (vmx_can_use_ipiv(vcpu) && !is_td_vcpu(vcpu)) ||
> >+		vmx_can_use_vtd_pi(vcpu->kvm);
> 
> It is better to separate this functional change from the code refactoring.

Agreed. Let's split this patch.


> > }
> > 
> > void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
> >@@ -200,7 +222,8 @@ void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
> > 	if (!vmx_needs_pi_wakeup(vcpu))
> > 		return;
> > 
> >-	if (kvm_vcpu_is_blocking(vcpu) && !vmx_interrupt_blocked(vcpu))
> >+	if (kvm_vcpu_is_blocking(vcpu) &&
> >+	    (is_td_vcpu(vcpu) || !vmx_interrupt_blocked(vcpu)))
> 
> Ditto.
> 
> This looks incorrect to me. here we assume interrupt is always enabled for TD.
> But on TDVMCALL(HLT), the guest tells KVM if hlt is called with interrupt
> disabled. KVM can just check that interrupt status passed from the guest.

That's true.  We can complicate this function and HLT emulation.  But I don't
think it's worthwhile because HLT with interrupt masked is rare.  Only for
CPU online.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

