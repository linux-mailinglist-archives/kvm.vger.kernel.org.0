Return-Path: <kvm+bounces-5911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8288F828F72
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 23:08:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 06A29B21AA3
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 22:08:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A75703DBBB;
	Tue,  9 Jan 2024 22:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="NCRmx0F1"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34DDF3DB98;
	Tue,  9 Jan 2024 22:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 2EB3A40E01B2;
	Tue,  9 Jan 2024 22:08:34 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id KiOhwCe-g0qp; Tue,  9 Jan 2024 22:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1704838112; bh=worxUdT9KOJEranFxZps6GXVgd62mc3IxDyhlGzs0cY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NCRmx0F1AvON411bFZmisI9EYkIitCHfOHXNYd/eCzvNPdZfDISwu7fxP5jInn05r
	 Y7lHFxA3DeKeTHPE930sls+OiWOCmJluo7488AyOZIeKFkRBkXl2iUXCM8GGAreu2s
	 nFVP+KSf04QKZX8XUej+18buuwurHIpE5XqekAMmpz6b5D4hIg7C9Vq8JnfDSvK7Sy
	 qU7lJntAy1iA9V0KB54lFK7akmoJKnPsdVXl5AolCQBWq9w9WIZwHY6WUxvlUroeg0
	 diJ9wGF38YnE3SZilIAzaW5qNKm2F9v1diPgYGTnNwzJXVyHBtrRIfSRqsapjUEATl
	 CgmEb2dNA4CxcF/AJXsFTCxWsREDxUH2GiD+OhVGLIRJyKhH66wOWD01MkSsnjfjM5
	 AkSZF01kqKAu+GP9zgYSV8pKHeGnbktYaoFbibduOXOGpbiutLCXU2O9aHjtJ//yYM
	 qfekQTSH0ZeRz8qcU6k66AkfK9KgngakBU6iZQwadHQM9UkvyqXiu7tX4RYyPA641c
	 T+xwcwaFrEkuXAle/ZJdyJlEWyG42lZfjFyclRehF8GfV6jAqmGNWv26aQm0zdHwn4
	 Cc+99gALtyJcjitB/MLC0x+ZYPEpwh4qBL7mc4fL8Kfm7T4aQubP2IeUc2hPA7eLVs
	 D5BX6VxTFc2YtIkwtP3VCTyY=
Received: from zn.tnic (pd9530f8c.dip0.t-ipconnect.de [217.83.15.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7C72340E016C;
	Tue,  9 Jan 2024 22:07:52 +0000 (UTC)
Date: Tue, 9 Jan 2024 23:07:46 +0100
From: Borislav Petkov <bp@alien8.de>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org,
	linux-crypto@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
	ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
	tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
	alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com,
	nikunj.dadhania@amd.com, pankaj.gupta@amd.com,
	liam.merwick@oracle.com, zhi.a.wang@intel.com,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v10 07/50] x86/sev: Add RMP entry lookup helpers
Message-ID: <20240109220746.GAZZ3DsouxpiUPeBVN@fat_crate.local>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-8-michael.roth@amd.com>
 <20231114142442.GCZVODKh03BoMFdlmj@fat_crate.local>
 <20231219033150.m4x6yh6udupkdqaa@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231219033150.m4x6yh6udupkdqaa@amd.com>

On Mon, Dec 18, 2023 at 09:31:50PM -0600, Michael Roth wrote:
> I've moved this to sev.h, but it RMP_PG_SIZE_4K is already defined there
> and used by a bunch of guest code so it's a bit out-of-place to update
> those as part of this patchset. I can send a follow-up series to clean up
> some of the naming and get rid of sev-common.h

Yap, good idea.

> Doesn't seem like it would be an issue, maybe some fallout from any
> files that previously only included sev-common.h and now need to pull in
> guest struct definitions as well, but those definitions don't have a lot
> of external dependencies so don't anticipate any header include
> hellishness. I'll send that as a separate follow-up, along with some of
> the renames you suggested above since they'll touch guest code and
> create unecessary churn for SNP host support.

OTOH, people recently have started looking at including only that stuff
which is really used so having a single header would cause more
preprocessing effort. I'm not too crazy about it as the preprocessing
overhead is barely measurable so might as well have a single header and
then split it later...

Definitely something for the after-burner and not important right now.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

