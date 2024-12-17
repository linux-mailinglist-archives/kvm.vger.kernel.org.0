Return-Path: <kvm+bounces-33916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F25609F4966
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 11:58:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2B81E7A47F4
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 10:58:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AEDF1E885A;
	Tue, 17 Dec 2024 10:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="BIatcVsz"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D32F81DFE0F;
	Tue, 17 Dec 2024 10:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734433084; cv=none; b=oQzUBFfJgZXSluyUwc5kOT2qJSb4VYcfblBYCAH1mrC5wPc80pDPQQo4+8xRmwLYRZKj1vt1t3Q5ws4HhsXx6f5iip9Y5DF7T05KmvGg7dpZoudKpucCnEWkx1iaJN4cCiLHV55BmlLzvX9VLVtmW66Sy0+7K9/EJDUYRZXSpd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734433084; c=relaxed/simple;
	bh=Ynn3KEd6VXbperLx0etyV2GIzi+vg12blUgv7h59RDM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I98XlxMeAxQlOkAPCIuBvpkWgkkA8YoJr4F4UhNcZS88QMQgd99nFyS8v1G0EIcWHd0PRzT32+BAdlwDmQc3KSvYcyaQ1bkM1SDIu67cRvdFj0sWWOJHiBfS8B/IyEr8wSKxN7gxzYIAxYKUsKiEG8ZC4FIdUkHkM5S1lWIMr+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=BIatcVsz; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8177A40E0286;
	Tue, 17 Dec 2024 10:57:59 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id gaNELxTXkS_1; Tue, 17 Dec 2024 10:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1734433076; bh=L8mLTUS2CcBsfFYSbVwZzOGQMdLZJ/dkkA/G9b1qC3g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BIatcVszqXOxCFQ8HQZw4wbZSRE7rgyeGlcUrFSbg8pYL5foPVJ+zzY/G7WCgdtZi
	 dO+uOgoFwBA4kr3tq1slmerZfvq9gTRNO/OCVlfO2TvvebuA2IpoNIlfd0umCnb3T4
	 4hf3tWhvIgJ7RFredNbiq+uWkLRDi5GCGK7vPc0In8MsQMzGl8oqxKv+N1oNiuqa+Z
	 /uEUcHzNO+rzKBMrl1RD06Znx5wQUVL2Xe/XYJG9ONFI8thJHSnXm6m6XNyHIOclIJ
	 KecnVQ1jxPWA45jtaO4XeecbkEb4mFBb8km+9zVHqTXjSji0p2XP2rnNwNfS29kY1d
	 oZg9p0d4HE2IMjC8/OkwyYk/7vY6wbPA2IoRN4To9svpCqQW+qs12xqiBF4S8a4wI4
	 0pIFjRqY+vpeQv6OCC3eYoM4bxURpIv1ppkvhFTM6ommsLmJzFOhcm9FQqN58uAxD2
	 xaNdzLpJD4xqdVjOx6EutNq+zYZFQqVzMQHvgO4LKA/Oj/KeTAb5XDM9Sg9NVBaGzs
	 c1rcJYI7dUMYQ14lusXUQ/7G8UGW7Pa/SVV+RRzxP+q+GjHfDf5p2QxLQueEm18pGq
	 fym9A38o3vR0JM20aVdyixDyWhYkc5pw8TQoXeZMXNt0EfYVmmZNwuhu/+LDNrqjcl
	 4TqpakgIeGlqgpkCo34rWT1Q=
Received: from zn.tnic (p200300ea971f937D329C23FfFEa6A903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:937d:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 413BC40E0288;
	Tue, 17 Dec 2024 10:57:45 +0000 (UTC)
Date: Tue, 17 Dec 2024 11:57:39 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v15 06/13] x86/sev: Prevent GUEST_TSC_FREQ MSR
 interception for Secure TSC enabled guests
Message-ID: <20241217105739.GBZ2FZI0V8pAIy-kZ8@fat_crate.local>
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-7-nikunj@amd.com>
 <20241210121127.GBZ1gv74Q6IRtAS1pl@fat_crate.local>
 <b1d90372-ed95-41ce-976f-3f119735707c@amd.com>
 <20241210171858.GKZ1h4Apb2kWr6KAyL@fat_crate.local>
 <ff7226fa-683f-467b-b777-8a091a83231e@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ff7226fa-683f-467b-b777-8a091a83231e@amd.com>

On Thu, Dec 12, 2024 at 10:23:01AM +0530, Nikunj A. Dadhania wrote:
> @@ -1477,19 +1480,13 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
>  	case MSR_SVSM_CAA:
>  		return __vc_handle_msr_caa(regs, write);
>  	case MSR_IA32_TSC:
> -		return __vc_handle_msr_tsc(regs, write);
> +	case MSR_AMD64_GUEST_TSC_FREQ:
> +		if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
> +			return __vc_handle_msr_tsc(regs, write);

Now push that conditional inside the function too.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

