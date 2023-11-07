Return-Path: <kvm+bounces-1058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A38C47E4918
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 20:20:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE66F1C209CF
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 19:20:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C0C636AF0;
	Tue,  7 Nov 2023 19:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Mcjp72gf"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA0A36AE1;
	Tue,  7 Nov 2023 19:20:18 +0000 (UTC)
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6016910A;
	Tue,  7 Nov 2023 11:20:17 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 6476340E01A4;
	Tue,  7 Nov 2023 19:20:14 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 95wN8euUxzc8; Tue,  7 Nov 2023 19:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1699384812; bh=45+Y4ZldnKZEWvtvZx7/+i+9LPa3k5MrmiBFv7on6aw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Mcjp72gfr5TIXzL3LOnywlS0Oc7dftWQNXzRJinscdoNgSnV/MTK4g3JQZUhvheZu
	 KZSGTEjsek7HFioitGZaeM/aDsoGq7jNrfj1Fn2PvpK/gD+rzuE0clPUobE3fBBV83
	 +ByJ0SkyLFRFnnP/ddJ5ZCZ1lrVrUX4//6slNDkugyJruEPBitwnckl09v7MMjP11d
	 wFKpPSTopH31YMCMfQmVzO4FjxNtCE47XLH4mjlSJlszErJWtjqlslGkOh3MxCrPae
	 FYThLNAJc2xof/XXXLlJpGJxGzs0lvhtKRiwxHNDYyqlDYkPR4y3bCwn/7JbeHjiGr
	 47rNQGUtzeKjYQPpF5OKU0sSoIpY5hodnA58uyFFMEMeTgN+FDfKiuZHaFqRW1U46P
	 CJWMGLWuRqhFYqgUaXvBGN9/VGmkF9kDiuLpt0iegWRSlKGG8qAhAe11tp0UbPZn5y
	 WRTZBx7Wdx+v52nrsWkZgytOrM+OiKPkKdZHFbLyh/1hkOLmcZGvceTPsYQ7cDChME
	 sYEzyM3+fZTULAVQIUJfxdk5szlVClAIH1HWpNchhR0zNpq8seYmwXpPf45vb2o1pz
	 4R4jSwqVR7gxmBqkznhzfEh2Su2UPQe7qddaicycaE6MZR9m4Xvd9gy0dvvawof5uB
	 bC9MB+QAvPpbJxnkQuUuxom4=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C822D40E0191;
	Tue,  7 Nov 2023 19:19:31 +0000 (UTC)
Date: Tue, 7 Nov 2023 20:19:31 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Kalra, Ashish" <ashish.kalra@amd.com>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
	linux-coco@lists.linux.dev, linux-mm@kvack.org,
	linux-crypto@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
	ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
	tony.luck@intel.com, marcorr@google.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
	jarkko@kernel.org, nikunj.dadhania@amd.com, pankaj.gupta@amd.com,
	liam.merwick@oracle.com, zhi.a.wang@intel.com,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v10 06/50] x86/sev: Add the host SEV-SNP initialization
 support
Message-ID: <20231107191931.GCZUqNwxP8JcSbjZ0/@fat_crate.local>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-7-michael.roth@amd.com>
 <20231107163142.GAZUpmbt/i3himIf+E@fat_crate.local>
 <4a2016d6-dc1f-ff68-9827-0b72b7c8eac2@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4a2016d6-dc1f-ff68-9827-0b72b7c8eac2@amd.com>

On Tue, Nov 07, 2023 at 01:00:00PM -0600, Kalra, Ashish wrote:
> > First of all, use the APM bit name here pls: MtrrFixDramModEn.
> > 
> > And then, for the life of me, I can't find any mention in the APM why
> > this bit is needed. Neither in "15.36.2 Enabling SEV-SNP" nor in
> > "15.34.3 Enabling SEV".
> > 
> > Looking at the bit defintions of WrMem an RdMem - read and write
> > requests get directed to system memory instead of MMIO so I guess you
> > don't want to be able to write MMIO for certain physical ranges when SNP
> > is enabled but it'll be good to have this properly explained instead of
> > a "this must happen" information-less sentence.
> 
> This is a per-requisite for SNP_INIT as per the SNP Firmware ABI
> specifications, section 8.8.2:

Did you even read the text you're responding to?

> > This looks backwards. AFAICT, the IOMMU code should call arch code to
> > enable SNP at the right time, not the other way around - arch code
> > calling driver code.
> > 
> > Especially if the SNP table enablement depends on some exact IOMMU
> > init_state:
> > 
> >          if (init_state > IOMMU_ENABLED) {
> > 		pr_err("SNP: Too late to enable SNP for IOMMU.\n");
> > 
> > 
> 
> This is again as per SNP_INIT requirements, that SNP support is enabled in
> the IOMMU before SNP_INIT is done. The above function snp_rmptable_init()
> only calls the IOMMU driver to enable SNP support when it has detected and
> enabled platform support for SNP.
>v
> It is not that IOMMU driver has to call the arch code to enable SNP at the
> right time but it is the other way around that once platform support for SNP
> is enabled then the IOMMU driver has to be called to enable the same for the
> IOMMU and this needs to be done before the CCP driver is loaded and does
> SNP_INIT.

You again didn't read the text you're responding to.

Arch code does not call drivers - arch code sets up the arch and
provides facilities which the drivers use.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

