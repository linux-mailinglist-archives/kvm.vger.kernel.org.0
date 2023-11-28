Return-Path: <kvm+bounces-2595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7648B7FB695
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 11:03:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 324A5282869
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 10:03:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89B594D11F;
	Tue, 28 Nov 2023 10:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="LrsHuw3t"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [IPv6:2a01:4f9:3051:3f93::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954C1DD;
	Tue, 28 Nov 2023 02:03:11 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 7B76F40E014B;
	Tue, 28 Nov 2023 10:03:08 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id SID4tgJZ7OsS; Tue, 28 Nov 2023 10:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1701165785; bh=h2VptRIJH9KOO+IwbuL3eYqIqKxO/mh8KoaUWSFZjt4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LrsHuw3t4TRk1vKx1R4oNXWQRszA/il7mXgXvmSRkFX7MLMc8EA7kH45Ofwub0aYJ
	 k9WIQsGexFOtjYLmD5QComShETDc0A3xNC8zBHYQCBpskVCiNsW4AjJYAsIqkToe/M
	 PTC9bv7xVCvMEC0BTBtHcqfnJsHmo2AM5ifbgOpNJU9NKl0hbC2gc1WbiRHs+ds0/p
	 FcksNIiJwpRhm3rcqN6lAo0npJ81kQaSyOAegLt/yo5ZNJNpyOVEMpxIS2GCdVCcpf
	 g/R9AjTlgQmHLimosVwy3QTkx/pHIxcXwdE6Qx3rHugoWMLRzma7LDu7rblzrpSzSr
	 FRiNnAYffB1BQi1/qEXcNflYy7mORkZPE8FNJ4D7G9nfLJfGoL4UGoMChVyZdfLiPV
	 j4Q5N13fU3XBcEnRIO2tiyqefV07YQPy2HlUQe1sJY9PbAib8C4pucCTSsX/TzneqV
	 qalF45E6X8Mq2XJ/rWN/13jMo+HIRlz+CoeTrwQ7m/fv2TMj/PbS9kdPwOjsMaorYK
	 Eka0w4ohlprCzcRyhlCgsOtE9UtOJZAwIAiyITAQd5bhvU28uj+C3QNIUiMzGJkf9e
	 fZgbtRugg35qB6j1g9XZrhIrxBqcCbZC2zufIvrGiK9sEDQudbymn/Zw+xKdIeYyK6
	 TwabAh4ml3j5rkvp1FGYztU8=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 86DCE40E0031;
	Tue, 28 Nov 2023 10:02:43 +0000 (UTC)
Date: Tue, 28 Nov 2023 11:02:42 +0100
From: Borislav Petkov <bp@alien8.de>
To: Xin Li <xin3.li@intel.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
	kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
	tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, luto@kernel.org, pbonzini@redhat.com,
	seanjc@google.com, peterz@infradead.org, jgross@suse.com,
	ravi.v.shankar@intel.com, mhiramat@kernel.org,
	andrew.cooper3@citrix.com, jiangshanlai@gmail.com,
	nik.borisov@suse.com
Subject: Re: [PATCH v12 23/37] x86/fred: Make exc_page_fault() work for FRED
Message-ID: <20231128100242.GRZWW6wqU9IvyXO0cm@fat_crate.local>
References: <20231003062458.23552-1-xin3.li@intel.com>
 <20231003062458.23552-24-xin3.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231003062458.23552-24-xin3.li@intel.com>

On Mon, Oct 02, 2023 at 11:24:44PM -0700, Xin Li wrote:
> From: "H. Peter Anvin (Intel)" <hpa@zytor.com>
> 
> On a FRED system, the faulting address (CR2) is passed on the stack,
> to avoid the problem of transient state. Thus we get the page fault
						^^

Please use passive voice in your commit message: no "we" or "I", etc,
and describe your changes in imperative mood.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

