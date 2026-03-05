Return-Path: <kvm+bounces-72786-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yNrELtQHqWlW0QAAu9opvQ
	(envelope-from <kvm+bounces-72786-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 05:34:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 40DD420AD68
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 05:34:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8987B30479D3
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 04:34:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CC83283C9D;
	Thu,  5 Mar 2026 04:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gSG84/4W"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2C97262B;
	Thu,  5 Mar 2026 04:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772685245; cv=none; b=o62f/QNpd+0px9BAVL3gdREx/C1fOLPO2pENKcCoG6xbFNRxcG03CPJjdodbmNYX+U7aRMicbMLodbGlrJwEdGA5EAo9RMc6FeNqoROlOpynyXfj6QXJTb2avtWaDEelQdR2dZbzhjVRMGeB7GqZmQKTZ4aJRZVBBe6an0TAXWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772685245; c=relaxed/simple;
	bh=eEz5/0jovylPA//uVZYAy/Ene0IoTQrrdKDJa+cuFGA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BeMGEAbL26JUIEs/L1NeWMpC9NZ2QvsCpWtjvJReF4ASaHDm+qWNn/rd261hlyXIO2kSsKUV1I0xulHw3sBiV58DSWTR7alUvvCEpumOsQSSfVxiUzc9/BwlOwEp0LSSWcWt0Sc7Lg2pO7IzTmKcV3GTs8CvwqzDjKy81H+e0Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gSG84/4W; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772685244; x=1804221244;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=eEz5/0jovylPA//uVZYAy/Ene0IoTQrrdKDJa+cuFGA=;
  b=gSG84/4WAKeC82nhNuv7aWkdQZBCmyZgqWKFzvURgoijMe8BWtEZENp1
   VL83qX1tXe3ztig9SoVYulkkA5ViweguxnybR6DiSDhCDA08jyCypXvU7
   oI9+S7NF10wskOsUa8NtueYKcJJT9KZ195H/fWJY0N1MUzUOLUDk674+A
   Zq1/fufTmy3+QS3naUm16udqzStlImUou5lF28R7eLmCesSNNskjWwme3
   FNHE3EhJODMXhJ08Kjxew6j87V7lzB9oN8YCa3twFUfRWZdrRsjTOKLQ3
   fOjSeWb4BVAVdyj4cNTq3Q4miROIa3ARoHzAOoR2rk9qcDKvT+ove9sVH
   A==;
X-CSE-ConnectionGUID: Tnr0nck6S+ujNBH0iWGH2w==
X-CSE-MsgGUID: SsQZGD8YTmSvIzpE98kVqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="84096462"
X-IronPort-AV: E=Sophos;i="6.21,325,1763452800"; 
   d="scan'208";a="84096462"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 20:34:04 -0800
X-CSE-ConnectionGUID: ybLtseiyTMK1KYU6Ywsymg==
X-CSE-MsgGUID: afjerOnpSzatybJ4UCZw4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,325,1763452800"; 
   d="scan'208";a="218550152"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa008.jf.intel.com with ESMTP; 04 Mar 2026 20:33:57 -0800
Date: Thu, 5 Mar 2026 12:14:04 +0800
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
Subject: Re: [PATCH v4 13/24] x86/virt/seamldr: Shut down the current TDX
 module
Message-ID: <aakDDKqpmXdKCrYm@yilunxu-OptiPlex-7050>
References: <20260212143606.534586-1-chao.gao@intel.com>
 <20260212143606.534586-14-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260212143606.534586-14-chao.gao@intel.com>
X-Rspamd-Queue-Id: 40DD420AD68
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72786-lists,kvm=lfdr.de];
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

On Thu, Feb 12, 2026 at 06:35:16AM -0800, Chao Gao wrote:
> The first step of TDX Module updates is shutting down the current TDX
> Module. This step also packs state information that needs to be
> preserved across updates as handoff data, which will be consumed by the
> updated module. The handoff data is stored internally in the SEAM range
> and is hidden from the kernel.
> 
> To ensure a successful update, the new module must be able to consume
> the handoff data generated by the old module. Since handoff data layout
> may change between modules, the handoff data is versioned. Each module
> has a native handoff version and provides backward support for several
> older versions.
> 
> The complete handoff versioning protocol is complex as it supports both
> module upgrades and downgrades. See details in Intel® Trust Domain
> Extensions (Intel® TDX) Module Base Architecture Specification, Revision
> 348549-007, Chapter 4.5.3 "Handoff Versioning".
> 
> Ideally, the kernel needs to retrieve the handoff versions supported by
> the current module and the new module and select a version supported by
> both. But, since the Linux kernel only supports module upgrades, simply
> request the current module to generate handoff data using its highest
> supported version, expecting that the new module will likely support it.
> 
> Note that only one CPU needs to call the TDX Module's shutdown API.
> 
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>

Reviewed-by: Xu Yilun <yilun.xu@linux.intel.com>

