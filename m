Return-Path: <kvm+bounces-29965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EEC939B5013
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 18:06:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B4F01C22AF8
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 17:06:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 509EF1D9664;
	Tue, 29 Oct 2024 17:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="D5pzNTYW"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673C119DF95;
	Tue, 29 Oct 2024 17:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730221564; cv=none; b=Z8pGRAeBdWLcT4LGyJO/xgf4DSNWPr7pBt7xL9wUJRE6GglEs0N2Zuf8JPSOqtTEePToPce4Z7o2ITo7s1Yvv+OrZCaHZN134/wG5jiIcjTIF24q/nAEI0jx6K+0ho+6LCJ5DEYKAKnpX6DWRq0SBwRljBuZ3NI85sQeHkjeYSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730221564; c=relaxed/simple;
	bh=5OSLIWoI0afbbt6I6QukKcG0+ty8hyZ1hr6/B+7jZHU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oLeWkLj8BGzeqrBBP3jFkGzLlCFXsMNPkMvN93ER1fFcMkUIjRZnsPU3Fq8xKVFTmJiTnyBBD5rHcFu7S9A82QrVCgjAbb5InFhiMFpdo4etfnGDRGtD4X2swUw2gFdihwNGJ7ku0JzARKacfcnFcxQ6m+oDnFHqvdJOPHbuyBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=D5pzNTYW; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 70B8C40E0192;
	Tue, 29 Oct 2024 17:05:59 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 6IeqeX2DA753; Tue, 29 Oct 2024 17:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1730221555; bh=3/duPCC4yyCjEl3TITfG8wwdhtdVYazbXSnsECdzI3I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D5pzNTYWYYt+dePhhVQxW6Aoi3Ro5RGshewLaT3KuctEl6hY4O4vcTmmcCbBtnU6g
	 w4W76nQ7l7EtXaKm3AzpUmqybQPBqNBCRUlb9znfWWfcEGPWYfj2NnNFkQxxpVCM+9
	 GGXYlR33avHPyVytyTC/Nmc+00wkSZmNdH9g4dsNCsw7eRG7eXXvDxBCPoFy5rir7u
	 iSNm3fHnfraJAdcIBt5qzwP95GWvnNu3fixiYtooGXGOSz7ENIZdMTDQ6vxaNTigaN
	 5LPAx4FA4ux7+D4ljIyNEEnhdsISJEIqsp1WbUiPo0v7IpLcDBlrDHmHRmI5Tb9Q3w
	 FARo60/rjRurWp4VFhmuc6rHRZKXsz8Hbp3qREfCEYYb2oMPc2SctBlxxhWicSMEIB
	 2oruO2CPNWD1Yxjup7aUhjtdFfhFtP0SAgWVO8CuWSOMl+jBS//YCuVPfXrjo+XES1
	 0V1VrlCZfIgis4jPqmsmeOp5bju/TFpCod0kfLNYjjP48WbB04uCXH2t80duoDB5k4
	 IIaWGMiPZ0DuDLh1cco3gpZmaJ0CvGnfTCdSHj4Gu9g0vudZq0nlxCepzHj6Ha7xdS
	 jGWPgPH1lu+PfKArYiAUWPL+CLPi76XDiLbFaDCwOWBGv0HifrAAWr32Qyix3sFvUo
	 ZlkaMMAjeH2STXy52L20pSZE=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D5C6340E01A5;
	Tue, 29 Oct 2024 17:05:41 +0000 (UTC)
Date: Tue, 29 Oct 2024 18:05:36 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	"Nikunj A. Dadhania" <nikunj@amd.com>, linux-kernel@vger.kernel.org,
	thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
	mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
	pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
Subject: Re: [PATCH v14 03/13] x86/sev: Add Secure TSC support for SNP guests
Message-ID: <20241029170536.GQZyEV4I5duinLh2KC@fat_crate.local>
References: <20241028053431.3439593-1-nikunj@amd.com>
 <20241028053431.3439593-4-nikunj@amd.com>
 <3ea9cbf7-aea2-4d30-971e-d2ca5c00fb66@intel.com>
 <56ce5e7b-48c1-73b0-ae4b-05b80f10ccf7@amd.com>
 <3782c833-94a0-4e41-9f40-8505a2681393@intel.com>
 <20241029142757.GHZyDw7TVsXGwlvv5P@fat_crate.local>
 <ef4f1d7a-cd5c-44db-9da0-1309b6aeaf6c@intel.com>
 <20241029150327.GKZyD5P1_tetoNaU_y@fat_crate.local>
 <59084476-e210-4392-b73b-1038a2956e31@intel.com>
 <caef0899-0e8a-435d-9583-c52bb81d7e8d@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <caef0899-0e8a-435d-9583-c52bb81d7e8d@intel.com>

On Tue, Oct 29, 2024 at 09:50:11AM -0700, Dave Hansen wrote:
> The code looks fine to me as-is.  If anyone sees a better way to
> refactor it and stash it elsewhere to make it cleaner and simpler, I'd
> love to see the patch.

You basically read my mind!

:-)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

