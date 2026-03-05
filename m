Return-Path: <kvm+bounces-72784-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yJ7JGr8GqWlW0QAAu9opvQ
	(envelope-from <kvm+bounces-72784-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 05:29:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2273720ACCB
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 05:29:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EC8F53046097
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 04:29:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E40232868A7;
	Thu,  5 Mar 2026 04:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ugkqsr9j"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC39288AD;
	Thu,  5 Mar 2026 04:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772684986; cv=none; b=oofncvRZEkff1mhskrkOKmhJxEm6FWeay/sVFCFPeBS4ahLHXaCF1uiQq8fQNZ61QEyaVt46IvPBI+z3BbSGRDil0Sbg7gg3uEIS0eWtAV7z45PhKGPkkm4AwsWB0MJej5QNG0C6/Z5HXBripXZioqMKddCwyfDERta36H1Kn4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772684986; c=relaxed/simple;
	bh=6Chbtbh91JQswn6MUozfrBBtYQHYxdhIh4GFF8DHSbQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FGQ1orVVEXuQgxDi+Zw+Wgnbuc9eCzNADvYzIOhgYHS31phruOfNuL2TMTjiYo0D2Aqiwjf7zgRb7LUda6hFaUy7TlMS1e5AuZswY1oQ8eCxdS+sf9a3z4sB5+APRt4zbc1Q5+Gk3BP6xG6B9TEN9kstlHtnfcxWoMzAXp7ZXBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ugkqsr9j; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772684986; x=1804220986;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6Chbtbh91JQswn6MUozfrBBtYQHYxdhIh4GFF8DHSbQ=;
  b=Ugkqsr9j/jtg4obzq43ncSLx3S1wJEax6EOuz9KnqkKr9Wc1dqGntgQx
   es1742aET4rUpJQ3mnPj6UPSwXb1aKVVGyuQmx1cA/IQ1bcn6C1Sc3m9/
   tvjCK7JwaHohPXT4lLIKjrJfreugNTxEVTL3lQafp3Z8FeVMwCqczSigH
   2mpqpe2tfFFWId4kgRv2mRA/sVz+IFraeMVUF6CN/p55yKO7IxWvuN7F9
   WajVlyuBtFBG3KE1t8Lg3LDv4UdG0GC9ZEeqi89e89/WBTqq9hGBscL/r
   vtDy5gdbt/TG0lDwShO8rVlZcbakTPOCkG0+VH+4NG7XLVKKqMC1wYUMo
   A==;
X-CSE-ConnectionGUID: gTfR8UlDRbCipxERM734gQ==
X-CSE-MsgGUID: Edphk48aT6GBN9YRI2PpEA==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="85233160"
X-IronPort-AV: E=Sophos;i="6.21,325,1763452800"; 
   d="scan'208";a="85233160"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 20:29:45 -0800
X-CSE-ConnectionGUID: s4U3BI54Sk6/QBIZSOJy4g==
X-CSE-MsgGUID: 0fsv4OblQDKlhJeyEOmozQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,325,1763452800"; 
   d="scan'208";a="215836413"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa010.fm.intel.com with ESMTP; 04 Mar 2026 20:29:39 -0800
Date: Thu, 5 Mar 2026 12:09:46 +0800
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
Subject: Re: [PATCH v4 09/24] x86/virt/seamldr: Check update limit before TDX
 Module updates
Message-ID: <aakCCudhc/P+4cJh@yilunxu-OptiPlex-7050>
References: <20260212143606.534586-1-chao.gao@intel.com>
 <20260212143606.534586-10-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260212143606.534586-10-chao.gao@intel.com>
X-Rspamd-Queue-Id: 2273720ACCB
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
	TAGGED_FROM(0.00)[bounces-72784-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:email,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Thu, Feb 12, 2026 at 06:35:12AM -0800, Chao Gao wrote:
> TDX maintains a log about each TDX Module which has been loaded. This
> log has a finite size which limits the number of TDX Module updates
> which can be performed.
> 
> After each successful update, the remaining updates reduces by one. Once
> it reaches zero, further updates will fail until next reboot.
> 
> Before updating the TDX Module, verify that the update limit has not been
> exceeded. Otherwise, P-SEAMLDR will detect this violation after the old TDX
> Module is gone and all TDs will be killed.
> 
> Note that userspace should perform this check before updates. Perform this
> check in kernel as well to make the update process more robust.
> 
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>

Reviewed-by: Xu Yilun <yilun.xu@linux.intel.com>

