Return-Path: <kvm+bounces-5436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BC3A821EC9
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 16:35:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5D2E01C22506
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 15:35:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B56614AAA;
	Tue,  2 Jan 2024 15:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="d8TtmPOA"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7609B14F60;
	Tue,  2 Jan 2024 15:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8709340E0171;
	Tue,  2 Jan 2024 15:34:57 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id E4pJd0VlcEXb; Tue,  2 Jan 2024 15:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1704209694; bh=AFlNAs1eTyy0BO95pQ2N7wyFVzTaEas2yI1v/Adat8k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d8TtmPOAiItQ4yR0tJO0GMvu0OoyPQwEUd5BFlrnpX8H7UdXl82/LACGiyqsrOsPP
	 HG4wHYqNoXUWPAZ02jeYSaysgqwVHotJBk4GL954LxUvMd8aty8Bx0Z18h+mQkFCom
	 WfqPrMr+rDCFaZjkU3Va3Ig0rdHwEe1FS/C/WURxOJZCnPNqcKeHB510oyqWEY1e1q
	 DF7uPwIfh8Qb7wnzAaGaWLRCgDetMJKMaeS71XEcFxH9eOwyYNH9XTn1YKCzzHKEVE
	 gicvKn8vIBGHvBCkU8aQ5IiHWdbSsUBym1NzBrExwAt3xxSi7PUvtP/e1KlMOhfeEg
	 cGD71cet6qH2D8gjTMdwtK3i29cI71MVQCa2P/F/hKf/KjhG9pYs51oai7RYWAcVLg
	 Jks2gnt/TFS17V/nUewsNAAbrepP0EZBfAmsoMopLzFQUdxsn6kAsRhb+mUI0rFp2y
	 T8ioePBl5ZQq0MkZS8KIb6b7acGAMzigjd9xu5x+P1/LCXGnfBS9vnDQBSPpygAWFZ
	 G8ywQ9Ez+SvCBQcHqYoBE4VxV1yYRd1nJktrtxaVPBpiaOY3p5wNRsi+bo33MuQnJd
	 VjGqKbCIrCBdsphTPg0PiCGge+AkwjuGqyujKUXD6Mk/1GqTjnUxre6DtuWbmZvusm
	 b6tfbgHO44zTLM5K+pBI+cvM=
Received: from zn.tnic (pd9530f8c.dip0.t-ipconnect.de [217.83.15.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 661D840E0191;
	Tue,  2 Jan 2024 15:34:31 +0000 (UTC)
Date: Tue, 2 Jan 2024 16:34:26 +0100
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
	nik.borisov@suse.com, shan.kang@intel.com
Subject: Re: [PATCH v13 01/35] x86/cpufeatures,opcode,msr: Add the WRMSRNS
 instruction support
Message-ID: <20240102153426.GBZZQtAiWSdGAgKoIL@fat_crate.local>
References: <20231205105030.8698-1-xin3.li@intel.com>
 <20231205105030.8698-2-xin3.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231205105030.8698-2-xin3.li@intel.com>

On Tue, Dec 05, 2023 at 02:49:50AM -0800, Xin Li wrote:

> Subject: Re: [PATCH v13 01/35] x86/cpufeatures,opcode,msr: Add the WRMSRNS instruction support

Or simply "x86/fred: Add ... "

Other than that,

Acked-by: Borislav Petkov (AMD) <bp@alien8.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

