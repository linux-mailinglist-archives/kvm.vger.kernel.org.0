Return-Path: <kvm+bounces-69100-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4M1LOHo9d2mMdQEAu9opvQ
	(envelope-from <kvm+bounces-69100-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 11:10:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FB4986758
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 11:10:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 26F5A305D854
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 10:05:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EC9A32E750;
	Mon, 26 Jan 2026 10:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SnMqmKOF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EADD32D7F3;
	Mon, 26 Jan 2026 10:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769421937; cv=none; b=tEeJjhimHmI3+HwtyG7u5f6DeBxWZvPmPzcPOvekTM5Y/eUqV0jpjBAodmYisKKPGOV2S914t3jW0rxFppqVCAaWCsy7+K8iH0T9CZmYTLPU8lKl75eooudkzmvLiImwIiZsnNkwAOvkGAM3zKl4gIpz0KS1zICw4Fgsfzq4vMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769421937; c=relaxed/simple;
	bh=nwre8qDTyZou/IUnISFnT1IEmC8Z4soACb1PPUSqHIs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=is66n/h7qDtsHOxaqJ1Orc2YCDl7yV44dwoLWHktL7yhL8mtKJh/TXo8UAGzf5QpgBd/EvZmcuPJGGu/FtRq5xoMaSd0scWsJAlY7sP344vDoHdp8wR8z3xY/+83VcILHgqcMBPVsFr+bwsut4usJOnSqqxIz/gnK/qMoIZj0s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SnMqmKOF; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769421935; x=1800957935;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nwre8qDTyZou/IUnISFnT1IEmC8Z4soACb1PPUSqHIs=;
  b=SnMqmKOFrD8I0+IzZwGNLmKI6Fz3yhmTXDS1IN1TWVjgrNQUxcmi4WCz
   7XfmaRQddt7Im0JdLEeYPwKQYkmK8d0qZgX36BLedfaCFT9aiEaK6eSUJ
   54AHDO9OV26fm6KBDvTqNi4MOGk2SHSj704qV2Aq8u2FCLHiAnPkbeQ0a
   pQSBeTGNcmikQwZx2jm5Pk5zxTs7wDA8jAS4sJ94kpqFY9orSCK3dMCYk
   bu08lOfyXSJ1jRp4Uug0A505UfgqMECFPH7Z1zgSN23YJxomz/cYUKkHw
   2buyKS4BGneZqMyuJKrb+oOk9OEhUEhVuHxudEw/VvHfli3PVSjZN43EZ
   A==;
X-CSE-ConnectionGUID: GGSBH4USSxOgsP2BZL4tRw==
X-CSE-MsgGUID: GFDzEe7PRMCfoOVzE6Jmjw==
X-IronPort-AV: E=McAfee;i="6800,10657,11682"; a="96060198"
X-IronPort-AV: E=Sophos;i="6.21,254,1763452800"; 
   d="scan'208";a="96060198"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 02:05:35 -0800
X-CSE-ConnectionGUID: DdECOedfR6igMO+j3qbajg==
X-CSE-MsgGUID: hSdRYevzTx6T22WMUR+gIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,254,1763452800"; 
   d="scan'208";a="207699104"
Received: from krybak-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.246.55])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 02:05:27 -0800
Date: Mon, 26 Jan 2026 12:05:24 +0200
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, x86@kernel.org, reinette.chatre@intel.com,
	ira.weiny@intel.com, kai.huang@intel.com, dan.j.williams@intel.com,
	yilun.xu@linux.intel.com, sagis@google.com, vannapurve@google.com,
	paulmck@kernel.org, nik.borisov@suse.com, zhenzhong.duan@intel.com,
	seanjc@google.com, rick.p.edgecombe@intel.com, kas@kernel.org,
	dave.hansen@linux.intel.com, vishal.l.verma@intel.com,
	Farrah Chen <farrah.chen@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3 06/26] x86/virt/tdx: Prepare to support P-SEAMLDR
 SEAMCALLs
Message-ID: <aXc8ZOufsyWWsBw4@tlindgre-MOBL1>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-7-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123145645.90444-7-chao.gao@intel.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69100-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tony.lindgren@linux.intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8FB4986758
X-Rspamd-Action: no action

On Fri, Jan 23, 2026 at 06:55:14AM -0800, Chao Gao wrote:
> P-SEAMLDR is another component alongside the TDX module within the
> protected SEAM range. P-SEAMLDR can update the TDX module at runtime.
> Software can talk with P-SEAMLDR via SEAMCALLs with the bit 63 of RAX
> (leaf number) set to 1 (a.k.a P-SEAMLDR SEAMCALLs).
> 
> P-SEAMLDR SEAMCALLs differ from SEAMCALLs of the TDX module in terms of
> error codes and the handling of the current VMCS.
> 
> In preparation for adding support for P-SEAMLDR SEAMCALLs, do the two
> following changes to SEAMCALL low-level helpers:
> 
> 1) Tweak sc_retry() to retry on "lack of entropy" errors reported by
>    P-SEAMLDR because it uses a different error code.
> 
> 2) Add seamldr_err() to log error messages on P-SEAMLDR SEAMCALL failures.

Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>

