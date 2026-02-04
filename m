Return-Path: <kvm+bounces-70249-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cCy2Kmh9g2mHnwMAu9opvQ
	(envelope-from <kvm+bounces-70249-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 18:10:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 12122EAD9B
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 18:09:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 4FE0C3028D5A
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 17:02:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A103E347FC3;
	Wed,  4 Feb 2026 17:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JISMdvW1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94AB0345CA3;
	Wed,  4 Feb 2026 17:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770224564; cv=none; b=IsGGeOZUKlowbbG4jcnHQ0Txa34th66mdNiKv2jUPfikiGPJffXTLYj/MD4Y5MP36Oes4t6F6mMFpqB9QpUvWI6jwOexrR+IraVLbNRmxO84xjIZLRkiTIoGdEoLgP685EQXq/yG6BaeOTEVLldA/2ev/8qfdVAQq9NToDTpC7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770224564; c=relaxed/simple;
	bh=5ynZ3iQKPYgC5X2aYv9XL2Pl/DYGcELm20/gbGjjHeQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W/w58TExhkNSVOVrfiUlbkoYaiIaM6Z4RMPtXx8ZH5znS/eaqzwOC6KeeHagEzCFnsiOIjpOlrBGQX77w+B/SuRG4C165PdbERqvfKlNm7YNH0HAqft0BzusjbvPw6J06KKqkSbRRBfvJ//NBG55ZOLnb+H5NW0CyBRN+CHtKBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JISMdvW1; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770224564; x=1801760564;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5ynZ3iQKPYgC5X2aYv9XL2Pl/DYGcELm20/gbGjjHeQ=;
  b=JISMdvW1oW7g8l1LAtPc59Av7yw7woj0ZOEWI1Bf3DVKjCocqA6+JFgQ
   C9pwyQb8CVfDQ4ekzSIgeo64TZIpktRHx6WzQAd4Gmb6LoicJl9u7MxNu
   445nhnzg2r4a+3S8k051dO/ywiHW26MQCwTWHTMsWI8G5dxefEOHhJkq8
   K1MLq4n1JfDakwZX7s8rZHUj09xrtld+nt2sE15SZBeVTnsrMZOMpvIZF
   X8I84OisoyyEQKh4ceWa01VfZogVeQ16zdEF2UwhdDAVaDqeEYNoa8GvT
   Sbch2haBpi65Tt4/l0rUcMNqtxXdh/IJem8gRoMeJSHrHeqKUpNpMyYnl
   g==;
X-CSE-ConnectionGUID: 3fOCQzK+S4S+y/WwSo4eDA==
X-CSE-MsgGUID: //Hxdfp+T3W7USuNwQEHWg==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="71581182"
X-IronPort-AV: E=Sophos;i="6.21,272,1763452800"; 
   d="scan'208";a="71581182"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2026 09:02:44 -0800
X-CSE-ConnectionGUID: bljzlKohRIuiGP1t0rXOEw==
X-CSE-MsgGUID: UkUKYhCITxGb4N6+7xgzlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,272,1763452800"; 
   d="scan'208";a="210314400"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.222.18])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2026 09:02:44 -0800
Date: Wed, 4 Feb 2026 09:02:43 -0800
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	rick.p.edgecombe@intel.com
Subject: Re: [PATCH 00/32] KVM: VMX APIC timer virtualization support
Message-ID: <aYN7s_WTAp9Nr3U6@iyamahat-desk>
References: <cover.1770116050.git.isaku.yamahata@intel.com>
 <aYNP5kuRwT33yU8Z@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aYNP5kuRwT33yU8Z@google.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[intel.com,vger.kernel.org,gmail.com,redhat.com];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70249-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[7];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 12122EAD9B
X-Rspamd-Action: no action

On Wed, Feb 04, 2026 at 05:55:50AM -0800,
Sean Christopherson <seanjc@google.com> wrote:

> > [1] Intel Architecture Instruction Set Extensions and Future Features
> > September 2025 319433-059
> > Chapter 8 APIC-TIMER VIRTUALIZATION
> > https://cdrdv2.intel.com/v1/dl/getContent/671368
> 
> What CPU generation is expected to have APIC-timer virtualization?  DMR?

CWF.


> > base-commit: 63804fed149a6750ffd28610c5c1c98cce6bd377
> 
> Please base the next version on `kvm-x86 next`, everything in here is KVM x86
> specific, and using a vanilla -rc is all but guaranteed to have conflicts.

Sure, will do.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

