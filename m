Return-Path: <kvm+bounces-68672-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yMmaMp0ocGmyWwAAu9opvQ
	(envelope-from <kvm+bounces-68672-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 02:15:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 58A4B4EEF7
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 02:15:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 460AD86C5DF
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 01:15:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DB702F6169;
	Wed, 21 Jan 2026 01:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LTrNK4w6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4A82D5C74;
	Wed, 21 Jan 2026 01:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768958093; cv=none; b=DNH5za2iag+uOz0uQUiaDW2sNG0bhRIrCXjfaKOBvzHAaMoNddfC+XN3rczDwWfbIdnq9J8YLKoXVcOX+P0poklSF6nomBfHMNKPkW/sfh5sMC/h9YDkeDdT9ITNZI4RT1OIhOrYWuJbrDrJtWNCZKGX9j2l2fi2mrp1sy83GT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768958093; c=relaxed/simple;
	bh=Uo9YNSqVD98k/7m1rWk+o15ESyHRV4gc6ubY2koFvpI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zndy+ol0LBMqPQGLhwBk2vc3aj7bgcqM6J1fU6C4WyyQg2ewWSEXfH/JrVHMbAiOqJdhTmg1BAbXPGu65lFenKf4H2jzqPiNRq+qgv+T8DLEeRxhEukrTLatIAKQ2LDhakZY9rEMEJ1Izh7eGuQItEWazG4Uws82/F74E41Kj9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LTrNK4w6; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768958091; x=1800494091;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Uo9YNSqVD98k/7m1rWk+o15ESyHRV4gc6ubY2koFvpI=;
  b=LTrNK4w6SfwtzOIQqKoB89+b2jBv3lc7mVc1peHgA7I4BDWotSCJgPFb
   og22gDKKyosPJVZn+FVtfQi2XOLU+ONu6H+KG1qsKTnjdxcaJlUlauwrB
   H9TAX4v9FBuR0lYSlEY5lMCJ2zfxHE9jj1AES667aT5dx3/i6dfCOEA1G
   8GgUkUeEvGvD6VEB9F/AhKFtHgwZncT5l9WUC4eOHaFVjGAw+Q3v7D/TT
   Bn4UXVlH9U7cpe+bB+Mjxzj29HTqejtbm1KZMrs5T63K1Pupm8wjNJka4
   lIoivwf1LcycQJL9gsyc3+ZzFtWlxv/JoaZ2hiMJO7JXxlKBbVUEbuDJm
   w==;
X-CSE-ConnectionGUID: eZ2JRnqVSxawu46hExnkXg==
X-CSE-MsgGUID: PU4ADml1S4KbpoteYoE8kA==
X-IronPort-AV: E=McAfee;i="6800,10657,11677"; a="74033660"
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="74033660"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 17:14:51 -0800
X-CSE-ConnectionGUID: Q5VfYE5jQrKPMHvFNBtAaA==
X-CSE-MsgGUID: Ihu2hYhSQ7m0mAa7LaRCYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="206620856"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa010.fm.intel.com with ESMTP; 20 Jan 2026 17:14:48 -0800
Date: Wed, 21 Jan 2026 09:40:19 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH 0/4] KVM: x86: Advertise new instruction CPUIDs for Intel
 Diamond Rapids
Message-ID: <aXAug39EuFG7QAB+@intel.com>
References: <20251120050720.931449-1-zhao1.liu@intel.com>
 <20251218175430.894381-2-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218175430.894381-2-pbonzini@redhat.com>
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DMARC_POLICY_ALLOW(0.00)[intel.com,none];
	DKIM_TRACE(0.00)[intel.com:+];
	TAGGED_FROM(0.00)[bounces-68672-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[zhao1.liu@intel.com,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 58A4B4EEF7
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi Paolo and maintainers,

> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Thanks!

> I think these can wait for the next merge window since the corresponding
> QEMU code will be released around the same time as 6.20.

May I ask if this patch series can now be a candidate materials for v6.20?


Regards,
Zhao


