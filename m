Return-Path: <kvm+bounces-69101-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gCO+Kjs+d2mMdQEAu9opvQ
	(envelope-from <kvm+bounces-69101-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 11:13:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BC8D867F7
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 11:13:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 639483013A7C
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 10:13:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58F0132ED3C;
	Mon, 26 Jan 2026 10:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JFAZX/Zh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BDBF30BF79;
	Mon, 26 Jan 2026 10:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769422386; cv=none; b=u01WpSW9Eu4Xe7HMovBK25LlvQgNI9ALQWpj5LxtMxuqNyWClFYQ/cD2R5DxXNtfO3HGEAkWh8m6oV3ohLN46Ns/IZlmZc9Vke+J/MNL3y6Exhk80LN0r14580eOQrGaCEv1QiEHIiqemCXDVS0X8ZB/26WDDi39y3MIFf21jnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769422386; c=relaxed/simple;
	bh=J6A7ySS6HYk0DsnK8Q23En9VRiQYoCADqpenMan2tko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aHDiaq1r7bCDz0AxciRoE0sVHb0OkcMym90C492Yn0iGWK0WPu7pDm4UWG/xK35hvMHmMtYDlbxnXcoJh3bV0MhmzdtFKySOwn2YXiRiWUYPK0eoV5wUs/d6ka64ufeedOJxtG5Euk0He0m1JUVEez9AJCJZugRav8ZLbif9dtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JFAZX/Zh; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769422384; x=1800958384;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=J6A7ySS6HYk0DsnK8Q23En9VRiQYoCADqpenMan2tko=;
  b=JFAZX/ZhHMayaqzuvElgInsxctigvnU0p4LOBka55n8msnaNL8AfCUTF
   pwtsJEt9lBzGjkedFaxvvaNNMkq14QhuYmCQdC18AS2/2qDMtZY1jjB65
   rejYJxd+zlggKxDGtkUL+dsGfjXC8LV+mAPyVzbXQoRQ+EcOIuqs4Z48T
   fog1KRRiMkOWbuwiU08QSpiOSdAhfxYft0tW49RET0wEOJ8nizuTXHptf
   3djvLDX+IDSIiRqzf9+mfrVc7DEl5v2bbU9Xkj5+8wwtQlwLQEWuHaV5S
   e9I4gTJ6XjhXDrvt7mr8liQoS1RrZSIVRG5o37ERYHb6sP+2v0pX92ulV
   A==;
X-CSE-ConnectionGUID: nB8TB3rWRwW9TjC3MFyOAg==
X-CSE-MsgGUID: cHU5+8TOT5G/G6w+UzsflA==
X-IronPort-AV: E=McAfee;i="6800,10657,11682"; a="74464532"
X-IronPort-AV: E=Sophos;i="6.21,254,1763452800"; 
   d="scan'208";a="74464532"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 02:13:04 -0800
X-CSE-ConnectionGUID: n0apX0F+T26KP9yjpxDjVg==
X-CSE-MsgGUID: 42ocGnlFRa2ng8X5TKXaBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,254,1763452800"; 
   d="scan'208";a="207447142"
Received: from krybak-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.246.55])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 02:12:56 -0800
Date: Mon, 26 Jan 2026 12:12:52 +0200
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
Subject: Re: [PATCH v3 07/26] x86/virt/seamldr: Introduce a wrapper for
 P-SEAMLDR SEAMCALLs
Message-ID: <aXc-JEhy3Quwe7r8@tlindgre-MOBL1>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-8-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123145645.90444-8-chao.gao@intel.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69101-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3BC8D867F7
X-Rspamd-Action: no action

On Fri, Jan 23, 2026 at 06:55:15AM -0800, Chao Gao wrote:
> --- a/drivers/virt/coco/tdx-host/Kconfig
> +++ b/drivers/virt/coco/tdx-host/Kconfig
> @@ -8,3 +8,13 @@ config TDX_HOST_SERVICES
>  
>  	  Say y or m if enabling support for confidential virtual machine
>  	  support (CONFIG_INTEL_TDX_HOST). The module is called tdx_host.ko
> +
> +config INTEL_TDX_MODULE_UPDATE
> +	bool "Intel TDX module runtime update"
> +	depends on TDX_HOST_SERVICES
> +	help
> +	  This enables the kernel to support TDX module runtime update. This
> +	  allows the admin to update the TDX module to another compatible
> +	  version without the need to terminate running TDX guests.
> +
> +	  If unsure, say N.

How about leave out the first "This" above:

	 Enable the kernel to support TDX module runtime update. This
	 allows the admin to update the TDX module to another compatible
	 version without the need to terminate running TDX guests.

Other than that:

Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>


