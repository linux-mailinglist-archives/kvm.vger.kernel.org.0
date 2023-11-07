Return-Path: <kvm+bounces-1086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E8227E4AAE
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 22:28:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BD475B21103
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 21:28:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C90DA21;
	Tue,  7 Nov 2023 21:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="QorMM4Su"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386D22A1D0;
	Tue,  7 Nov 2023 21:28:32 +0000 (UTC)
Received: from mail.alien8.de (mail.alien8.de [IPv6:2a01:4f9:3051:3f93::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ABBCD7A;
	Tue,  7 Nov 2023 13:28:31 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id D92F740E014B;
	Tue,  7 Nov 2023 21:28:28 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id FJ3LN0HSu5qX; Tue,  7 Nov 2023 21:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1699392506; bh=bD4Og8jExEEHYDDGD4aZjJ2Y/F4MpIKryEXuaQivTig=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QorMM4SuZdiKp7t2nZwe81UY7vOudNKGUcUY+TlNg43O9zYwwHCB7pozpT9nnl6q7
	 C/9DBfHFH7707N+ejUdjvjHyZllhX7kFCBjKoWk16nzMPlB2BAx+9SirMdgaWjLq4q
	 GZCIhpj5To82xighWq74IFenape1WM3joOJuPmKsRTErh0iRJjKt2sxvxpQRol7vxS
	 pHfJnnQGyq5L2W0OKXy0tcOO3oqw57IuzP7tLT0yis/CkXSGt1rp6miiOUMp7NGt69
	 9FornBvMJX5oj7URL8rY6jBvJ55f8LubZ9LR/Mhb2Svr3H57LsKQ8s6bv3C3isgv+R
	 CkJlDmrwArgtzgFYsAISBw4FPh5DWOrTMVBNk+ZDXRZwaUxfixd5IfXXMXFzAkR2KJ
	 5SYifm7Ha0z0OLS/FEiuAhta0XbUky8UtoyodNL9OOtOCy/A2/n7EMWgCHQrKiGfqj
	 qsl8iQptQLX56l5VUfaKv9pTlF/WwoIzeLXS96gjdBq71S/LFfc6SGaTlhFN9pM+9u
	 9h0iHI7asY53l9+P6SAeHxtynHF+/j/xMAwG+PpOtSPwAVjef6j95Y20t96CQufTOa
	 LHb0OkqGowP6Rma1TpewhEYi6LnIvvZfhAgvm3A7/QIAQImr1nIPZa1usK5EloRu/e
	 7JIp4HZbQd3iCQjhw3NydAg8=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2926A40E0192;
	Tue,  7 Nov 2023 21:27:46 +0000 (UTC)
Date: Tue, 7 Nov 2023 22:27:40 +0100
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
Message-ID: <20231107212740.GFZUqrzK7yzy41dRKp@fat_crate.local>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-7-michael.roth@amd.com>
 <20231107163142.GAZUpmbt/i3himIf+E@fat_crate.local>
 <4a2016d6-dc1f-ff68-9827-0b72b7c8eac2@amd.com>
 <20231107191931.GCZUqNwxP8JcSbjZ0/@fat_crate.local>
 <20231107202757.GEZUqdzYyzVBHTBhZX@fat_crate.local>
 <250f5513-91c0-d0b5-cb59-439e26ba16dc@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <250f5513-91c0-d0b5-cb59-439e26ba16dc@amd.com>

On Tue, Nov 07, 2023 at 03:21:29PM -0600, Kalra, Ashish wrote:
> No, this is not correct as this will always enable SNP support on
> IOMMU even when SNP support is not supported and enabled on the
> platform,

You see that we set or clear X86_FEATURE_SEV_SNP depending on support,
right?

Which means, you need to test that bit in amd_iommu_snp_enable() first.

> And isn't IOMMU driver always going to be built-in and isn't it part of the
> platform support (not arch code, but surely platform specific code)?
> (IOMMU enablement is requirement for SNP).

Read the note again about the fragile ordering in my previous mail.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

