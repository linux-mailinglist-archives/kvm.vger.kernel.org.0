Return-Path: <kvm+bounces-69109-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IDYZO4NFd2mMdQEAu9opvQ
	(envelope-from <kvm+bounces-69109-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 11:44:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A92687277
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 11:44:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CE429301D692
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 10:44:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B95E8330660;
	Mon, 26 Jan 2026 10:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ddVCVCO9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF78221FDE;
	Mon, 26 Jan 2026 10:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769424246; cv=none; b=dPJMTnDgWW5QdLtkKj3H584iAk603i32/Fo0tSN/V22DImC7B/Bii6G+AkLuq/vGPUdlVo5MzP/7nvkuAoaQu6aslO/e2XfBHrhIMDIyq2HHcOCDGMtxiAxSWyEIdDGVcK8/WecuEgCN53P5aLEd5zrSSXf3dmu2DAxEWyuvfts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769424246; c=relaxed/simple;
	bh=U2UTPE8HWyvKd7zXMUADMYjgA7PLSffTGeUQ8cgJlvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cau9oWO/CmJaLFsCm/RNCmBIKpyxFx+39EECleQw53TS6XBn/vCW9gavHDK6LI2IKsuYKoPnZD/nRoKYpLJUQZaeY3TQZe4ETG6F6NaT8FUdeMfqHpvxV2Ev3qBgMpg/JQ0sAMwKBXUgy23/aWYxNBAvCKbULoxz1MTDNZoadDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ddVCVCO9; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769424245; x=1800960245;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=U2UTPE8HWyvKd7zXMUADMYjgA7PLSffTGeUQ8cgJlvQ=;
  b=ddVCVCO9fv509fZUt2TxglOECF2OAwlI4BDSVRNee5cv8ZCBalf6RpUQ
   OK6I51xzcrDmJMU2keAlCFbOX+Spd7k0Gr0FIgEzunCK9XGtgn47760lK
   fJCoZuwNxV6kak4sYiQUAfF0aRD2UsF7xjaRTDamN6YSSUOnSI3wgcRcA
   7nvr+6yJsrkFaAKSJ7/TvvBQVdYMD2vA5MC9Mg6iAu61dstb50CyhcgLt
   p4qbdevO8diwfpLvcgi6eOWmq78IQ6l7YixGGRncyP3HhzY8HFAtaCN8w
   1RbqR5rgFED5FBGr0+U42r19QufoWQ3Ku8wQElCx90KhSwBw10e5m1MCI
   w==;
X-CSE-ConnectionGUID: Y6W5A3GKQyWZebq9jw3I3A==
X-CSE-MsgGUID: o5uvQphSQZKG2C36X12Dzg==
X-IronPort-AV: E=McAfee;i="6800,10657,11682"; a="70503428"
X-IronPort-AV: E=Sophos;i="6.21,255,1763452800"; 
   d="scan'208";a="70503428"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 02:44:04 -0800
X-CSE-ConnectionGUID: IYG1ntXhSFGVsXE3YH6Hhg==
X-CSE-MsgGUID: 7YQHbNZ6QPOJgAb8TSXsxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,255,1763452800"; 
   d="scan'208";a="211740554"
Received: from krybak-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.246.55])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 02:43:56 -0800
Date: Mon, 26 Jan 2026 12:43:52 +0200
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
Subject: Re: [PATCH v3 17/26] x86/virt/tdx: Reset software states after TDX
 module shutdown
Message-ID: <aXdFaITue7OiVaHH@tlindgre-MOBL1>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-18-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123145645.90444-18-chao.gao@intel.com>
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
	TAGGED_FROM(0.00)[bounces-69109-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:email,intel.com:dkim]
X-Rspamd-Queue-Id: 9A92687277
X-Rspamd-Action: no action

On Fri, Jan 23, 2026 at 06:55:25AM -0800, Chao Gao wrote:
> The TDX module requires a one-time global initialization (TDH.SYS.INIT) and
> per-CPU initialization (TDH.SYS.LP.INIT) before use. These initializations
> are guarded by software flags to prevent repetition.
> 
> After TDX module updates, the new TDX module requires the same global and
> per-CPU initializations, but the existing software flags prevent
> re-initialization.
> 
> Reset all software flags guarding the initialization flows to allow the
> global and per-CPU initializations to be triggered again after updates.

Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>

