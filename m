Return-Path: <kvm+bounces-33087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42FCB9E45E5
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 21:39:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3DB6CB30796
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 20:03:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F81C1F03DF;
	Wed,  4 Dec 2024 20:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="K2VUz5Vy"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419001531C1;
	Wed,  4 Dec 2024 20:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733342603; cv=none; b=pVWHxQbhQP2i1RIexIyzWEqh4MdVkIqBjjD96/8h3ly26E4rE3XB2DK6FCprbOvK2rjEKTs5oXJ76au/PG64q8K2/CUz3xUbt4DLlADZqZjS5XeRw/M9Y+WHLX84Wbsq0IsvuqND4obKtIZb5hArkY+kkrxPkL4+cRTohLAnTw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733342603; c=relaxed/simple;
	bh=2M7uRz2BBNPKwPDf3dd58a9lU6iILrU8/npc7OhOqnM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HaRY6JIAosFT45334RdbnTGU8rqJQTBuaO3U3rywp/7eReEYOyMuSyrfZ1s7VCM0tR+TsAeDEim30jpyAHvoXYkRrYkhC71nw7EAzJEtPpYHeULbyfjOUyKrQN4B0rsAiTYre5dPhte8GBC/k87cCn1gVj6sXv51YleMhQt50yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=K2VUz5Vy; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 984AA40E0286;
	Wed,  4 Dec 2024 20:03:16 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 0mvLpFChjbae; Wed,  4 Dec 2024 20:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1733342592; bh=N3RioEMALy81DolBlUwEFWVsjxc+/QqKKebdk5ubV1A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K2VUz5VyE9r7vkrHxoAtB3De7AADB8qn8cWJOo4B2ydvwFfNTtRpxWFNHerxockM7
	 +MpRDJ+PmtH1FCIV6EFKplXfD1brJIaq3aIP6GCfiej0m6b2xmQkErrRKgwZ7ela1U
	 4bSOiSCnETBnQWlnXqGhz5Zp5FEEv5NyBC3bveF/3CT60vMShKkr9qMcfvmTwCuzXF
	 okCYE1IQCncOKmU/MUOb4SsQ0mthO6CFWGC9gaO6x9cYCAPfO/psXREuD6ZXeH7fgw
	 rKRKjN8C5Fmx9YdREYrPbg2CLKijUs2wqzpnjfigCMpG7OjUQjTSnmqrkRWTG4T7gY
	 2dU+5goiU8d80R+91PyKsAqj4qgRxsAJO+mAU911Pg8W7VLo+kDJ1+3jGdKEp+QDWU
	 yMKHQDu0FEAyRgqQC3Gmzazm8KcqWR5774tuTL6I0x7NrCSlvShzI8Q10oWbwzjAcj
	 0druu8owfGbA1OCHOQUs1m46HufNaY8nU35gIBSuMdTb6gP5vAnJBr9zC6zAsRae0H
	 +4yrRbD32Tp06PZydldoQmoR0FWnfWDVHUwmRpAtklcXlv99H6TyFBIlXw0dkkzba7
	 HC1btMa6MJor4sqqJHFIaRlFVw+THEuahqVPHEo91HX5WC92fmX3fvPGEV8e6GBgMR
	 Sbrf1pPWFM8CuxyRysh21spU=
Received: from zn.tnic (p200300ea9736a14b329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9736:a14b:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A185640E0269;
	Wed,  4 Dec 2024 20:03:01 +0000 (UTC)
Date: Wed, 4 Dec 2024 21:02:55 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v15 01/13] x86/sev: Carve out and export SNP guest
 messaging init routines
Message-ID: <20241204200255.GCZ1C1b3krGc_4QOeg@fat_crate.local>
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-2-nikunj@amd.com>
 <20241203141950.GCZ08ThrMOHmDFeaa2@fat_crate.local>
 <fef7abe1-29ce-4818-b8b5-988e5e6a2027@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fef7abe1-29ce-4818-b8b5-988e5e6a2027@amd.com>

On Wed, Dec 04, 2024 at 03:30:13PM +0530, Nikunj A. Dadhania wrote:
> The above ones I have retained old code.

Right.

> GFP_KERNEL_ACCOUNT allocation are accounted in kmemcg and the below note from[1]
> ----------------------------------------------------------------------------
> Untrusted allocations triggered from userspace should be a subject of kmem
> accounting and must have __GFP_ACCOUNT bit set. There is the handy
> GFP_KERNEL_ACCOUNT shortcut for GFP_KERNEL allocations that should be accounted.
> ----------------------------------------------------------------------------

Interesting.

> For mdesc, I had kept it similar to snp_dev allocation, that is why it is 
> having GFP_KERNEL.
> 
>         snp_dev = devm_kzalloc(&pdev->dev, sizeof(struct snp_guest_dev), GFP_KERNEL);
>         if (!snp_dev)
> -               goto e_unmap;
> -
> -       mdesc = devm_kzalloc(&pdev->dev, sizeof(struct snp_msg_desc), GFP_KERNEL);
> 
> Let me know if mdesc allocation need to be GFP_KERNEL_ACCOUNT.

Let's audit that thing:

* snp_init_crypto - not really untrusted allocation. It is on the driver probe
path.

* get_report - I don't think so:

        /*      
         * The intermediate response buffer is used while decrypting the
         * response payload. Make sure that it has enough space to cover the
         * authtag.
         */
        resp_len = sizeof(report_resp->data) + mdesc->ctx->authsize;
        report_resp = kzalloc(resp_len, GFP_KERNEL_ACCOUNT);

That resp_len is limited and that's on the guest_ioctl path which cannot
happen concurrently?

* get_ext_report - ditto

* alloc_shared_pages - all the allocations are limited but I guess that could
remain _ACCOUNT as a measure for future robustness.

And that was it.

So AFAICT, only one use case is semi-valid.

So maybe we should convert those remaining ones to boring GFP_KERNEL...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

