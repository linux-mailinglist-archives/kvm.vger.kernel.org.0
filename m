Return-Path: <kvm+bounces-69057-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CAjoDDfGdWlGIgEAu9opvQ
	(envelope-from <kvm+bounces-69057-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 08:28:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8ADCA7FFB2
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 08:28:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0334F300D31D
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 07:28:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E7402DB799;
	Sun, 25 Jan 2026 07:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WBjE4ROr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235013EBF2D;
	Sun, 25 Jan 2026 07:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769326119; cv=none; b=rl1bbHT4KPIBJoFCTAQsauYGkk+lDzUkjQKwr7w4ZF7iFtRd9KyOo7jCZPihfHivQK2pgPVOuaEYMf7Sd8bZid50SU2CWWvoYsaaac1ab5i6xRnJ2KTk5pZVh0ld47pVv9xQj+ldTHaS8QYo+PIhKBcbupNW8oqElRPGxOD/VK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769326119; c=relaxed/simple;
	bh=CW8peoVGz0XZGP6gE/B1j4lm7i9MbD3d/1JHccc5L+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tu7Y5w93tFbPOg4tGJq27Dxsg2fC+XCJg9Mug120pDIStYzV4WsI3Xz0IylePUvIWKbU6J6Qi7zYrA39ZnMfeT7xrhQgdOx2K7Y7Tpv0TirpggLLv/BLIWF4nwp0H3rUO2E3krspNrfFxDEa/zXWSMPtZ36eUhI9PjHR1gKYx8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WBjE4ROr; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769326118; x=1800862118;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CW8peoVGz0XZGP6gE/B1j4lm7i9MbD3d/1JHccc5L+Q=;
  b=WBjE4ROrqbeqHG4WLQex7DXSCSPLC3LWLPvEzjgoau0A1uysQW6shTmr
   3wRFXbu0ASUivXw9WkUGs+1eIoRFB4pNoMRCmzJ/Ptx9Hf0P4Y0YIs9aA
   +efH5z6++KAosRNN7e2k115Pwx9JSWCTsP/oFJ8/QbrkCx8Fp0+F42ivA
   i1cj+9bEMNlJb96DCx7CD+eeJa4vtNqunqLNDTpOiaVPhZ2SF+jDocsB0
   sl5QxDekj2eBuui6XXLbpQCsuZXhQqx/M1jBLtGoXwGEFJmxH4dmowqZ5
   +ShOjRnk+cWOCQEmnwbdcwfWRYLKBo77FUMqTOHoi6kMcwGYXO2n8L/D/
   w==;
X-CSE-ConnectionGUID: A8Gori7eRVqN5SfoeJkfyQ==
X-CSE-MsgGUID: scIUbrDsRDW5K07shP1c7A==
X-IronPort-AV: E=McAfee;i="6800,10657,11681"; a="70497514"
X-IronPort-AV: E=Sophos;i="6.21,252,1763452800"; 
   d="scan'208";a="70497514"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 23:28:38 -0800
X-CSE-ConnectionGUID: x2c8jcjfRMKKfNad0db2sw==
X-CSE-MsgGUID: jfTTWpt9RomcffeXmCrRpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,252,1763452800"; 
   d="scan'208";a="238050330"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa002.jf.intel.com with ESMTP; 24 Jan 2026 23:28:35 -0800
Date: Sun, 25 Jan 2026 15:54:08 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
	Xudong Hao <xudong.hao@intel.com>
Subject: Re: [PATCH 2/4] KVM: x86: Advertise AMX CPUIDs in subleaf 0x1E.0x1
 to userspace
Message-ID: <aXXMIFNoy7cUu+3o@intel.com>
References: <20251120050720.931449-1-zhao1.liu@intel.com>
 <20251120050720.931449-3-zhao1.liu@intel.com>
 <aXO4qPQlkqKeW6Sz@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXO4qPQlkqKeW6Sz@google.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	TAGGED_FROM(0.00)[bounces-69057-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[zhao1.liu@intel.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8ADCA7FFB2
X-Rspamd-Action: no action

On Fri, Jan 23, 2026 at 10:06:32AM -0800, Sean Christopherson wrote:
> Date: Fri, 23 Jan 2026 10:06:32 -0800
> From: Sean Christopherson <seanjc@google.com>
> Subject: Re: [PATCH 2/4] KVM: x86: Advertise AMX CPUIDs in subleaf 0x1E.0x1
>  to userspace
> 
> On Thu, Nov 20, 2025, Zhao Liu wrote:
> > Define and pass AMX CPUIDs (0x1E.0x1) through to userspace.
> 
> Similar to the PASSTHROUGH_F() thing in the first patch, these aren't strictly
> being passed through.  In practice, they are passed through as of the current
> code base due to the features residing in KVM-only words, but I'd like to avoid
> stating that features are being passed through unless KVM very deliberately wants
> to ignore the kernel.

Good point, thanks for your reminder!

> As before, I'll tweak when applying.  Same goes for patches 3 and 4.

Thanks!

-Zhao

