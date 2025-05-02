Return-Path: <kvm+bounces-45200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C2476AA6C6D
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 10:19:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 67CB71BA5BDE
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 08:19:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEFCA229B2A;
	Fri,  2 May 2025 08:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U/TX4Mf5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0BA8828;
	Fri,  2 May 2025 08:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746173922; cv=none; b=c7spS0+srjKBstkuctxbUFp3w05HUXca4BapjUSeMvqPQ/nM7lWHQdT46DL7FrKr3unKamw31D2scID3DNYV2qlAFrGO2YENLQE0XX7VBWtqbZxvMQTJ/kJimFn2Wj0Fj84a8p3ByDT2HSrR3mRC5M2xp+k7SCn1YEZtPTf84dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746173922; c=relaxed/simple;
	bh=cceIUw9EX6CJ615GNdppXNrElVMTPwJztPtsbm/5hy8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vt7Jc/sIw8Fqc2xhbOrNLzkm5euA3Z4bFUVAjgY7NxG72qDQVoJf3NW9EC7+Z+h0s8qq3nrY/2JBhLolVntT14n2AOxgOvCXGUuNDPPk3Ui3DNcDkRl0YutnCDiA/jTRN1TY68VIjZSTeDHDT91VV8rwvF6i2n/j4np4evQcfkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U/TX4Mf5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3FCDC4CEE9;
	Fri,  2 May 2025 08:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746173921;
	bh=cceIUw9EX6CJ615GNdppXNrElVMTPwJztPtsbm/5hy8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U/TX4Mf5qkn+d5eWIgqv7vIk75zfM6yrIPmHLSfaOvilB1TMJCOwX6UxaLi3/4ntF
	 CTdvcW24sQjGFvj/AXsOJGncvakw6Z4p8ZclsEDe2hknFU+ckPt2/qHvdPIyk59xbo
	 rV1pq8QWA/qTkpUObp899r1foJ9LRWGoqI6CTS1V0Cu+JCa9JAJtB9a+QLyuX858V2
	 70a22IBVEVB0MRp2wD32EPcEnvbH3GYXu7Ra0oeU+V0Ro/eudlwhxrpwk5f5KAdfqv
	 vheM2b3e+KJz5ez4AHrUsoRTaS6WvSOsjRrAmUB93Bp+mNMmxeQYuTcRVRzY5U5RIz
	 AD+AuPXxVZ3PA==
Date: Fri, 2 May 2025 10:18:30 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Xin Li (Intel)" <xin@zytor.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
	virtualization@lists.linux.dev, linux-pm@vger.kernel.org,
	linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org,
	linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org,
	netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	acme@kernel.org, jgross@suse.com, andrew.cooper3@citrix.com,
	peterz@infradead.org, namhyung@kernel.org, mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com, jolsa@kernel.org,
	irogers@google.com, adrian.hunter@intel.com,
	kan.liang@linux.intel.com, wei.liu@kernel.org,
	ajay.kaher@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
	tony.luck@intel.com, pbonzini@redhat.com, vkuznets@redhat.com,
	seanjc@google.com, luto@kernel.org, boris.ostrovsky@oracle.com,
	kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com,
	dapeng1.mi@linux.intel.com, ilpo.jarvinen@linux.intel.com
Subject: Re: [PATCH v4 02/15] x86/msr: Move rdtsc{,_ordered}() to <asm/tsc.h>
Message-ID: <aBR_1oQN-gKCREBD@gmail.com>
References: <20250427092027.1598740-1-xin@zytor.com>
 <20250427092027.1598740-3-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250427092027.1598740-3-xin@zytor.com>


* Xin Li (Intel) <xin@zytor.com> wrote:

> For some reason, there are some TSC-related functions in the MSR
  ^^^^^^^^^^^^^^^
> header even though there is a tsc.h header.

The real reason is that the rdtsc{,_ordered}() methods use the 
EAX_EDX_*() macros to optimize their EDX/EAX assembly accessors, which 
is why these methods were in <asm/msr.h>.

Your followup patch tacitly acknowledges this by silently creating 
duplicate copies of these facilities in both headers ...

I've cleaned it all up in tip:x86/msr via these preparatory patches:

  x86/msr: Improve the comments of the DECLARE_ARGS()/EAX_EDX_VAL()/EAX_EDX_RET() facility
  x86/msr: Rename DECLARE_ARGS() to EAX_EDX_DECLARE_ARGS
  x86/msr: Move the EAX_EDX_*() methods from <asm/msr.h> to <asm/asm.h>

Thanks,

	Ingo

