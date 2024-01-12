Return-Path: <kvm+bounces-6159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EB0F82C639
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 21:10:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EE7D2B24E4C
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 20:10:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A76F016439;
	Fri, 12 Jan 2024 20:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="KNNfilfS"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53BC616410;
	Fri, 12 Jan 2024 20:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 77B0540E01BB;
	Fri, 12 Jan 2024 20:08:33 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 8kA7_vDH_yh5; Fri, 12 Jan 2024 20:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1705090111; bh=e1SfatK6kMuNuuwBDPnqHfNy3+Q98jf/weW6sPVIkD0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KNNfilfSV90nTYo01g8OipC9QBf4EsV5uS9Xh50yk1Yr/QWJAE4vpzA35JE3Nm9jG
	 K0Q0RGMJS81gbue1mMgxIQPF8PZ9hs45zU2p05e8jyHqp5+5F385NOYXSI7LSGnyfw
	 VodDIr+WPeasUIY4n93LC1K/wYVm8GHl2vfE9zBKj7PAkAocnwrYzjeWzldE2R29Go
	 oMH30Yk1lxnm5za+ZQ1ShL1YQ4x5+Bd6Hd2X8lp7YLVJPHGCOtSExwNftBX/22cgWT
	 Jb+R+FkOZGi1ibwlHJ8CDX67dOtESWRxXAHL3wjLzxxJ15WlLJD7dOBUUPSlI011pt
	 YNYY+FUeS5kK2E3roloMIFvGd9F0ASqwfkms7Tgi94Np8PV8o/dmv/41axAi3xEqXc
	 bMFohTfAYalOMlv/MRyfLsm6FhqzZg/0b/iiPmNyIJ9krTZUOkVYjkubIGTEjq59/4
	 OkhtzKGnhXsA9rWEKO/KX1QZ9AhzRtZ1Kqioqkdg7qjPjq5SxqXYUZQezqU2groGuN
	 T/8uiUWLxQhK86uU3X7YZb3PpoAnWJ+jrGnu35UajKR2lGck6bvk7b8VvNDqVEB9d0
	 BvFgn/IBTM8lchd34kUpkgHg1dIl6e7ldu/5XcXG0HhNmap/MhQ383+sgVTB3IictL
	 9g8wUqDg3EIOHRw8iFm8pukE=
Received: from zn.tnic (pd9530f8c.dip0.t-ipconnect.de [217.83.15.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id F3A4240E00C5;
	Fri, 12 Jan 2024 20:07:51 +0000 (UTC)
Date: Fri, 12 Jan 2024 21:07:51 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Michael Roth <michael.roth@amd.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
	thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
	pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
	jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
	slp@redhat.com, pgonda@google.com, peterz@infradead.org,
	srinivas.pandruvada@linux.intel.com, rientjes@google.com,
	tobin@ibm.com, vbabka@suse.cz, kirill@shutemov.name,
	ak@linux.intel.com, tony.luck@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v1 11/26] x86/sev: Invalidate pages from the direct map
 when adding them to the RMP table
Message-ID: <20240112200751.GHZaGcF0-OZVJiIB7y@fat_crate.local>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-12-michael.roth@amd.com>
 <cb604c37-aeb5-45bd-b6db-246ae724e4ca@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cb604c37-aeb5-45bd-b6db-246ae724e4ca@intel.com>

On Fri, Jan 12, 2024 at 12:00:01PM -0800, Dave Hansen wrote:
> On 12/30/23 08:19, Michael Roth wrote:
> > If the kernel uses a 2MB directmap mapping to write to an address, and
> > that 2MB range happens to contain a 4KB page that set to private in the
> > RMP table, that will also lead to a page-fault exception.
> 
> I thought we agreed long ago to just demote the whole direct map to 4k
> on kernels that might need to act as SEV-SNP hosts.  That should be step
> one and this can be discussed as an optimization later.

What would be the disadvantage here? Higher TLB pressure when running
kernel code I guess...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

