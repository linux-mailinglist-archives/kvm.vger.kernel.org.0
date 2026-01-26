Return-Path: <kvm+bounces-69103-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KC2NBMg/d2mMdQEAu9opvQ
	(envelope-from <kvm+bounces-69103-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 11:19:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A51C486B2B
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 11:19:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DC2BF303CD25
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 10:16:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D66332ED51;
	Mon, 26 Jan 2026 10:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EoHtafBL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840E0304BBF;
	Mon, 26 Jan 2026 10:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769422596; cv=none; b=uTr8gO7RYVMKu7OmDw6huctzJgRlF/CjSLNJypj0ghq2NlNJWtyHH0Rm0hE0VOgJIRIWZwe7Sy3NQOvlhdZJiAFtNh4R2ujCdheKI7/ky8gI38mMcwSP3WQE7DODf6twB3hI1I3WwcyMeKdMKJUrZxsaf3r6VaJawMwpLKhOcwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769422596; c=relaxed/simple;
	bh=upqJG0mb/UgBMLpqOxXHyNZDH9RXuWR+enIz3PWmenU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MGyDfPDcvYo0o6WsPEjDZ6AdKgcl2k+tl+pk6vffWCXH5R74DRDxR0zxMWZIUBLbe8/doooCaY9ZK+KadHStjlHW+Sr48II5pU/bKZxY5s1jH/W4Uhzl8qPdNyiJxx4gupvVLYeIHkeTwRx6DF+u2g+9kG7W76Yv+4ixrI7a9PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EoHtafBL; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769422595; x=1800958595;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=upqJG0mb/UgBMLpqOxXHyNZDH9RXuWR+enIz3PWmenU=;
  b=EoHtafBLsgAmbs/zU4dE+m4RZNP2b/cFYlMxmOLmMM6xpVJwPjRuaGZq
   H2blrKWKvrObtMWk0lqTkHpJXfqt0N/nQCvUnuHhiypyBFGq9KEd2ANsZ
   eAU4f37nin9r73xvNqHsIx4uJgynP5y1eA6+2MawR8IBSg/QY2FxzWjTa
   /LVzvprjfGOU7KW9fxRrwdTugrZJ+uTES/BH41ULq/QKVdSlQZTpr1Eif
   ekrpNfkyuD2wHZy1QgakaNPoPalMZyfj+eifRWIXONT16h2iTALcvy9WC
   I12XEuMtRpgG4h8HZzfs4A7xKrpb6QsCx0eTAJYueuOt4SVJbK3zQNwgg
   g==;
X-CSE-ConnectionGUID: uz9miwtRSSWYqEfh8R9cyA==
X-CSE-MsgGUID: tbZ9C/blTv+QfEIONhVn0A==
X-IronPort-AV: E=McAfee;i="6800,10657,11682"; a="96060841"
X-IronPort-AV: E=Sophos;i="6.21,254,1763452800"; 
   d="scan'208";a="96060841"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 02:16:35 -0800
X-CSE-ConnectionGUID: rLYSWDcASnelEJ8i4nDXLA==
X-CSE-MsgGUID: fxnPEguqTQWzt5RCiktQbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,254,1763452800"; 
   d="scan'208";a="212118051"
Received: from krybak-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.246.55])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 02:16:27 -0800
Date: Mon, 26 Jan 2026 12:16:24 +0200
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, x86@kernel.org, reinette.chatre@intel.com,
	ira.weiny@intel.com, kai.huang@intel.com, dan.j.williams@intel.com,
	yilun.xu@linux.intel.com, sagis@google.com, vannapurve@google.com,
	paulmck@kernel.org, nik.borisov@suse.com, zhenzhong.duan@intel.com,
	seanjc@google.com, rick.p.edgecombe@intel.com, kas@kernel.org,
	dave.hansen@linux.intel.com, vishal.l.verma@intel.com,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3 11/26] x86/virt/seamldr: Block TDX Module updates if
 any CPU is offline
Message-ID: <aXc--OlFUhlgf6vm@tlindgre-MOBL1>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-12-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123145645.90444-12-chao.gao@intel.com>
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
	TAGGED_FROM(0.00)[bounces-69103-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A51C486B2B
X-Rspamd-Action: no action

On Fri, Jan 23, 2026 at 06:55:19AM -0800, Chao Gao wrote:
> P-SEAMLDR requires every CPU to call the SEAMLDR.INSTALL SEAMCALL during
> updates.  So, every CPU should be online.
> 
> Check if all CPUs are online and abort the update if any CPU is offline at
> the very beginning. Without this check, P-SEAMLDR will report failure at a
> later phase where the old TDX module is gone and TDs have to be killed.

Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>

