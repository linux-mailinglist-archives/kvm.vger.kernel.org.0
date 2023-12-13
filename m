Return-Path: <kvm+bounces-4342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 536D981137D
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 14:51:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D75E9B2109E
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 13:51:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83AB32E648;
	Wed, 13 Dec 2023 13:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Zh2JIwjN"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [IPv6:2a01:4f9:3051:3f93::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 254361B9;
	Wed, 13 Dec 2023 05:50:38 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A2C0A40E018F;
	Wed, 13 Dec 2023 13:50:34 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id i88IOi2JMIP8; Wed, 13 Dec 2023 13:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1702475432; bh=aPSRuKMITa7Cc04zdSSoRjDp8M/sOyV9isILVL2dpxM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zh2JIwjNhEuU6UNW4jpj1WcsJZSLPxOaFicta9Psufsx9qAiE0r5LUQti9ME31hhC
	 DE15ssH/tHgk+EjXOIL69aAwLvIztbuMyvEm/xhcCfkitMa7YX48EPIzHcjgG8SXKJ
	 djNpCWRKKecB+7Y+QTTBu5xNHqGC5N4mEr1NHKgK67j8G4+Ymn/r4ZBBkT/dXYbg/y
	 u1SQ6sTGYqL1JDig8iSogrNe/1VsiOOYtlDAr5nqpZCtiDvbXCPcA4z00t21bnYBB+
	 aYR3DVTGd5+cUWArW12JZW4yWJYKu8pgzQ7lNMFxHH/cucbIBcH8VHShFO6MtJcpC5
	 tsqnEeBcr/wvld/PiLufaUCx/qxIotPqY2VXm7Im3S+7naD1gtzxu2BaiWiOIKM+71
	 EmQeXG9lqA/cBXyxM61wdxf58GPsmR26zgrSY4y1yuuwBCdA0cTB1PqN9+U4mZ9NvX
	 bt6veq/0RGM3aTeL8+8YD/b5UeM2flqSFQdEZa3vAmVlFU5Jek5IqkrGevhLbLwmPU
	 A3GN0fLzLPuLG3D+gq0mwgS5YJeusNaY5u0MUSJkV9TUh2Xc+GeLNuRDHk8cBR6DDT
	 Sh9aGpsuBJ4YVla14l5AMsD/LOj+e78E/nMoo5Nk14yUfMr3dZu/Jm0QrUhHXxIjAO
	 R5+IdtjclU4WcsUHLSOjuC/g=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D2C5140E00CD;
	Wed, 13 Dec 2023 13:49:50 +0000 (UTC)
Date: Wed, 13 Dec 2023 14:49:45 +0100
From: Borislav Petkov <bp@alien8.de>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
	linux-coco@lists.linux.dev, linux-mm@kvack.org,
	linux-crypto@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
	ardb@kernel.org, seanjc@google.com, vkuznets@redhat.com,
	jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
	slp@redhat.com, pgonda@google.com, peterz@infradead.org,
	srinivas.pandruvada@linux.intel.com, rientjes@google.com,
	dovmurik@linux.ibm.com, tobin@ibm.com, vbabka@suse.cz,
	kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
	marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
	alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com,
	nikunj.dadhania@amd.com, pankaj.gupta@amd.com,
	liam.merwick@oracle.com, zhi.a.wang@intel.com,
	Brijesh Singh <brijesh.singh@amd.com>,
	Jarkko Sakkinen <jarkko@profian.com>
Subject: Re: [PATCH v10 04/50] x86/cpufeatures: Add SEV-SNP CPU feature
Message-ID: <20231213134945.GFZXm2eTkd+IfdsjVE@fat_crate.local>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-5-michael.roth@amd.com>
 <0b2eb374-356c-46c6-9c4a-9512fbfece7a@redhat.com>
 <20231213131324.GDZXmt9LsMmJZyzCJw@fat_crate.local>
 <40915dc3-4083-4b9f-bc64-7542833566e1@redhat.com>
 <20231213133628.GEZXmzXFwA1p+crH/5@fat_crate.local>
 <9ac2311c-9ccc-4468-9b26-6cb0872e207f@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9ac2311c-9ccc-4468-9b26-6cb0872e207f@redhat.com>

On Wed, Dec 13, 2023 at 02:40:24PM +0100, Paolo Bonzini wrote:
> Why are they dead code?  X86_FEATURE_SEV_SNP is set automatically based on
> CPUID, therefore patch 5 is a performance improvement on all processors that
> support SEV-SNP.  This is independent of whether KVM can create SEV-SNP
> guests or not.

No, it is not. This CPUID bit means:

"RMP table can be enabled to protect memory even from hypervisor."

Without the SNP host patches, it is dead code.

And regardless, arch/x86/kvm/ patches go through the kvm tree. The rest
of arch/x86/ through the tip tree. We've been over this a bunch of times
already.

If you don't agree with this split, let's discuss it offlist with all
tip and kvm maintainers, reach an agreement who picks up what and to put
an end to this nonsense.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

