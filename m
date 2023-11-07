Return-Path: <kvm+bounces-1057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6E377E4909
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 20:14:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 913922812DD
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 19:14:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 080E336AE8;
	Tue,  7 Nov 2023 19:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="bxqakIgK"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DD13158C;
	Tue,  7 Nov 2023 19:14:14 +0000 (UTC)
Received: from mail.alien8.de (mail.alien8.de [IPv6:2a01:4f9:3051:3f93::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91F8410A;
	Tue,  7 Nov 2023 11:14:13 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id B051340E0192;
	Tue,  7 Nov 2023 19:14:09 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id iFnUvtCdkqc2; Tue,  7 Nov 2023 19:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1699384447; bh=rjOtFeaNHpOrWagWwdPrXv1lywypy0gt2wnO9HYjDMg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bxqakIgKJXLvskHTp9n0kAcoxBGPd4qfa5IcthADTAYfkStA0E6pi4QMMhKL06gjy
	 f8zAf/8RicwZPLymzq9ZsvN33++Ey758DzbHN9hVX6oAmGNwEcVoaWo/H1ldCgkcKC
	 HJ8VLETimjnUYXBfin417xyvBP4EN38+0sR+ltZfbllvSdqP5eRgQEMjOErKcWzSVB
	 zpyqewOSkOCZZPJxUi75pN8fEGZ3y2J4eijXn7NTb6p1BNrDJsn2vbo6inR81p6h5M
	 pt9GzRx07Pvo3LfOSKUYlsFR403+wVPcsPC+LiU9J1K5FS8/WSbuB9SDri8rLuct+k
	 +SSREFKcdV873SXvM+Oq0hT8lVHywvQTgFXAz5WpGRue7OWnLlevd0L0fERclE6iEr
	 mvjaj2b+NS6RyDReRAwI3qcK5GOn5jI7xw3NyMTMDOVmtCMM5k5DlA5vWPJxoMVQja
	 36deXxlzh2h0T4X+/nnY1GRPAr6cNRHESVsEjdN8diqNG7o4H8jnnCCJ8ApJlONcmV
	 uPmEYJEh+yCsMlVSlo+07g8UI/X7dFP6esHrFwMehkDs0D8lripyVyDg8OKzsbVhnH
	 LMgXdUn+O4MMv01KKXV6mDb6L/qUlcsR6ha21apKa2sqeLLQSR9r5iPsbYi0zumP6G
	 S/HnHPXoM9koJGsaceJecymg=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BF8BE40E014B;
	Tue,  7 Nov 2023 19:13:26 +0000 (UTC)
Date: Tue, 7 Nov 2023 20:13:21 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
	linux-coco@lists.linux.dev, linux-mm@kvack.org,
	linux-crypto@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	jroedel@suse.de, hpa@zytor.com, ardb@kernel.org,
	pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
	jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
	slp@redhat.com, pgonda@google.com, peterz@infradead.org,
	srinivas.pandruvada@linux.intel.com, rientjes@google.com,
	dovmurik@linux.ibm.com, tobin@ibm.com, vbabka@suse.cz,
	kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
	marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
	alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com,
	nikunj.dadhania@amd.com, pankaj.gupta@amd.com,
	liam.merwick@oracle.com, zhi.a.wang@intel.com,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v10 06/50] x86/sev: Add the host SEV-SNP initialization
 support
Message-ID: <20231107191321.GBZUqMUQPMLOqhl+RH@fat_crate.local>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-7-michael.roth@amd.com>
 <20231107163142.GAZUpmbt/i3himIf+E@fat_crate.local>
 <8ec38db1-5ccf-4684-bc0d-d48579ebf0d0@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8ec38db1-5ccf-4684-bc0d-d48579ebf0d0@amd.com>

On Tue, Nov 07, 2023 at 12:32:58PM -0600, Tom Lendacky wrote:
> It needs to be called early enough to allow for AutoIBRS to not be disabled
> just because SNP is supported. By calling it where it is currently called,
> the SNP feature can be cleared if, even though supported, SNP can't be used,
> allowing AutoIBRS to be used as a more performant Spectre mitigation.

So far so good.

However, early_rmptable_check -> snp_get_rmptable_info is unnecessary
work which happens on every AP for no reason whatsoever. That's reading
RMP_BASE and RMP_END, doing the same checks which it did on the BSP and
then throwing away the computed rmp_base and rmp_sz, all once per AP.

I don't mind doing early work which needs to be done only once.

I mind doing work which needs to be done only once, on every AP.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

