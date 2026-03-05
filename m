Return-Path: <kvm+bounces-72787-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0HANL0UJqWlc0gAAu9opvQ
	(envelope-from <kvm+bounces-72787-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 05:40:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4253820ADEB
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 05:40:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 83172308826A
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 04:38:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2E3A287257;
	Thu,  5 Mar 2026 04:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hcc1g+78"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A9D26C385;
	Thu,  5 Mar 2026 04:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772685534; cv=none; b=HwRDS7XruuZ0sNcn94ZyM9pedYyHCtVC3FR66zHvgNVBwyKmoBZFQeBZx7kmw4ekQBFDIF96cdFHbVXuhOi8bJMwGGy0taai2f6B5IOTr19KwgXjOLKdTwuKWvTGzcggCtcW3FEFthsoVei+EpRuWvtxxUKRbwBBtHTNgsvRVDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772685534; c=relaxed/simple;
	bh=+6kadK7R1G4J1Sw7qOre4rFtDtMgkwL1GzpUsB+xwpA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NEqXR8HtjS49fxI2Afcgry61FGaDVXUO0FCEHqgXh3hpLi5qP6FjZ3eLsEQGG0nXTs8duhSkQjb0LlY1Szhkn44NtKldgpfA7I1voQsLNReP6QCOIObvrmc8Wb0UYSvjB/qsTXv/EHqVOMVILXXSTWDwCkJApK4mQk1Zbrt/mjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hcc1g+78; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772685533; x=1804221533;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+6kadK7R1G4J1Sw7qOre4rFtDtMgkwL1GzpUsB+xwpA=;
  b=hcc1g+78ilhDxqQyeVbpVLmbmKBSHkfBkd4k19S0jsqha3b1n4qh0hiF
   Uf0IqCs5CSaLr+ZAc8KZ4vexA0b4o1w517TNG1PqQHQtxNhIXsjXILoKb
   ztFSIgsGSSTFy0uxL8mgCnJzqkDS3iQ7+HlAGSfGtB2JdxnpdK3eCAc4F
   pZGDLV3I1tcSXLYvKDOVzrXFZon9SEob3Z05PDqJP/PVeNahmSL8YisGX
   OG+PeU3fmMCyxmrL9mirCkQMEFN2jnhixQp7gcG3yZUrXuWYkuiPJ+jB+
   h6tHyKDHhpbnIlfqr5/ZBJQ8MvqCulDNUjHlEi0VeLOwpdMyc10amJCWG
   g==;
X-CSE-ConnectionGUID: VtUr4i8vR4aWR4QNColL6g==
X-CSE-MsgGUID: mm3Qup0WTuWlFjCBskNQeA==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="84846177"
X-IronPort-AV: E=Sophos;i="6.21,325,1763452800"; 
   d="scan'208";a="84846177"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 20:38:53 -0800
X-CSE-ConnectionGUID: /16M6/E4SZGNSS+PXpPHVQ==
X-CSE-MsgGUID: JpsB0YAIRxy9CynKvf/FpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,325,1763452800"; 
   d="scan'208";a="249031894"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa002.jf.intel.com with ESMTP; 04 Mar 2026 20:38:47 -0800
Date: Thu, 5 Mar 2026 12:18:54 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, x86@kernel.org, reinette.chatre@intel.com,
	ira.weiny@intel.com, kai.huang@intel.com, dan.j.williams@intel.com,
	sagis@google.com, vannapurve@google.com, paulmck@kernel.org,
	nik.borisov@suse.com, zhenzhong.duan@intel.com, seanjc@google.com,
	rick.p.edgecombe@intel.com, kas@kernel.org,
	dave.hansen@linux.intel.com, vishal.l.verma@intel.com,
	binbin.wu@linux.intel.com, tony.lindgren@linux.intel.com,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v4 15/24] x86/virt/seamldr: Log TDX Module update failures
Message-ID: <aakELtvQm1j+9vd0@yilunxu-OptiPlex-7050>
References: <20260212143606.534586-1-chao.gao@intel.com>
 <20260212143606.534586-16-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260212143606.534586-16-chao.gao@intel.com>
X-Rspamd-Queue-Id: 4253820ADEB
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72787-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yilun.xu@linux.intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Thu, Feb 12, 2026 at 06:35:18AM -0800, Chao Gao wrote:
> Currently, there is no way to restore a TDX Module from shutdown state to
> running state. This means if errors occur after a successful module
> shutdown, they are unrecoverable since the old module is gone but the new
> module isn't installed. All subsequent SEAMCALLs to the TDX Module will
> fail, so TDs will be killed due to SEAMCALL failures.
> 
> Log a message to clarify that SEAMCALL errors are expected in this
> scenario. This ensures that after update failures, the first message in
> dmesg explains the situation rather than showing confusing call traces from
> various code paths.
> 
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>
> ---
> v4:
>  - Use pr_warn_once() instead of reinventing it [Yilun]
> v3:
>  - Rephrase the changelog to eliminate the confusing uses of 'i.e.' and 'e.g.'
>    [Dave/Yilun]
> ---
>  arch/x86/virt/vmx/tdx/seamldr.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/seamldr.c b/arch/x86/virt/vmx/tdx/seamldr.c
> index c59cdd5b1fe4..4e0a98404c7f 100644
> --- a/arch/x86/virt/vmx/tdx/seamldr.c
> +++ b/arch/x86/virt/vmx/tdx/seamldr.c
> @@ -223,6 +223,11 @@ static void ack_state(void)
>  		set_target_state(tdp_data.state + 1);
>  }
>  
> +static void print_update_failure_message(void)
> +{
> +	pr_err_once("update failed, SEAMCALLs will report failure until TDs killed\n");
> +}

The wrapper seems redundant but maybe too much indent if put the print
in the loop. Anyway, either is good to me, up to you.

Reviewed-by: Xu Yilun <yilun.xu@linux.intel.com>

