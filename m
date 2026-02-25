Return-Path: <kvm+bounces-71901-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cFgxOL+Dn2mVcgQAu9opvQ
	(envelope-from <kvm+bounces-71901-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 00:20:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 632A519EB74
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 00:20:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BF89C306CDC8
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 23:20:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2419F3806B1;
	Wed, 25 Feb 2026 23:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uhzn4w6U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56417366839
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 23:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772061618; cv=none; b=Af/jiRjxtP6sBNU+b38LYym7SljDFzmsuRkVrqqtzeWCrf1Ugwv9++Z9nHFxWHICzGR/4rDAGADpYmFOQ9wo1GM3f5DReurDZvstGGH0tTjdLqoOYaxdSfUqz+QqbtzgwZHYMxrrXEn5wxtlNMFscMIt12553u5uOjmv8REsT90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772061618; c=relaxed/simple;
	bh=ncJ/yZrFQwmQDLQRu5VuYVpooUS7GC0HT5ZYkkiWhy4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h7IAj5dwwpsoW217WdMcFTv0wm8XcgsGwNwYdzD8ggZv6EJZZwj96zP8ZfZVt0kLT/b7ZdQCEfJsE/tKZWRT9dNbcmHXJyrT6N/vZ1aUJisQhm24weTt2mstMU59TJi86PDvIXtADJQTm6GfE6DpuelCQrLts7rkztSl17yDxDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uhzn4w6U; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-81df6a302b1so327281b3a.2
        for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 15:20:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772061617; x=1772666417; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aEWfuL1WgCP/eH/o3qO74sPfk+Pg3+xsCKw2mq2gLYE=;
        b=uhzn4w6UtRIAbnLkkRvfqKWxBco+JaWGwiRza1DyJHeGRsQPcwqUw/970G9aidfPJB
         mZbdRLAhnelthWtXAM066H0ITzo931/rXkSCh69hexdD2OHYrTbdKJlhKIhprEmP7w/b
         rdddN8iQOeNU9st4sqX59824wjd8ufl7mLW0cssGI4D/bDvqtJsRQqxFdJIJ3WTtKIHm
         qc6NKD8dG52/9IkgsB+Vj1v6QZTk5/LgnyXMn08D/0xnIx6K2VYpmHTPCUmEHzHN4dMl
         EerY3NyQyRZA07tRMRN0OSocjAxMABPEh4iUXLFHvJwdvP4D9d+//76ht8k2auMf9DHp
         1h4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772061617; x=1772666417;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aEWfuL1WgCP/eH/o3qO74sPfk+Pg3+xsCKw2mq2gLYE=;
        b=Q16jKvE3x9gRsiXYhsVJcF0iTc0ijHmGksEgRRD8INN4NJlJB684FlHYB986kEkYmF
         +4qHT8o3jB1KihrYhvH9yfkcvRf7VKLQGUEnChorQubZTlD6CeNfoj2S1PZEz//8hpyn
         ySZ8Hj8f2fBLxDjaNTy7JsgTOyuoXWnGl9ACgDLJFA27YW4o6t4hAyyS+vC+gKzOGEiI
         h1D9x9c5VKGEdZwRot1P3pkaL3245IJrRWSknU/Utks2QwmxGBtNFO5Nyt7hTxfsJpzb
         D/9ma8QhaEZdO+Od3tFXSCUcWy5ZMbogwS5vMEDrCBO02b+LsHd/nH7mVWzfoqh01Op6
         36Gg==
X-Forwarded-Encrypted: i=1; AJvYcCVio6sfkJITUKGmTx7bFWePJN7cCIGGkxhfFaDR7Tw0Vwgk6ZN2VV2/YxO9IjNb0XKSXQw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMcHLduW/7i0HRXT0fKO0MGQdvF1kA1uCg/InJlBVm8fC/oOOQ
	D5jCcidfhTkYESV79q46z/E2mR0SaLd3KesIu5H99sII5el4wt3jzpern2CvdyY0EQ==
X-Gm-Gg: ATEYQzyK6sUNtSvJam3wMybBQcgtxM+OaMqFg6eA7w+sQgyXLmMi+BOkTruuisvqGre
	17tlF7if2n/kT9+u66Gv178mro5kMwb0SAuRz14ZP+i1ioiXEMUpuQTOfUD7oj9Js/p1uA/r7fr
	nEA+l6El3C1YlsaCR9s8s3W7134iDh7FshZvP3erDp0W7JUJbOvIvpDfM0cfXmMLCnF7y/jw+hH
	y2wmB97qmzwV+1R6XlMrT7Fc6Cm+uBascHfItaHoUn8lW0ND/yufh8kxcWQOejBdB6HrEd/dLzN
	BgKLoKUbr2KvDI05tNWU6q097GvInMJpKrM4JH2V88WDubWspS5/6qMK8oHEV6086QSpnMmkEP/
	0RQGEAeLWmtu8R9JzX8ljUooi5QhA1MOKta9OU7/ckGNGKrw4bkV067zBnfOEWdGNESivFCf+Vg
	wP1vvqUcjWW2RVWR7U7h7nGaPtJy3V4RFNK1dJfbSgvur8alPG4IBnh/ikWRO9fA==
X-Received: by 2002:a05:6a00:18a7:b0:81f:852b:a91c with SMTP id d2e1a72fcca58-8273390dcc3mr1547131b3a.64.1772061616376;
        Wed, 25 Feb 2026 15:20:16 -0800 (PST)
Received: from google.com (239.23.105.34.bc.googleusercontent.com. [34.105.23.239])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82739ff37f1sm347240b3a.40.2026.02.25.15.20.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 15:20:14 -0800 (PST)
Date: Wed, 25 Feb 2026 23:20:10 +0000
From: David Matlack <dmatlack@google.com>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Alex Williamson <alex@shazbot.org>,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org,
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Lukas Wunner <lukas@wunner.de>,
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Tomita Moeko <tomitamoeko@gmail.com>,
	Vipin Sharma <vipinsh@google.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 03/22] PCI: Inherit bus numbers from previous kernel
 during Live Update
Message-ID: <aZ-Dqi782aafiE_-@google.com>
References: <20260129212510.967611-4-dmatlack@google.com>
 <20260225224746.GA3714478@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225224746.GA3714478@bhelgaas>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[shazbot.org,nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev];
	TAGGED_FROM(0.00)[bounces-71901-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_TWELVE(0.00)[45];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 632A519EB74
X-Rspamd-Action: no action

On 2026-02-25 04:47 PM, Bjorn Helgaas wrote:
> On Thu, Jan 29, 2026 at 09:24:50PM +0000, David Matlack wrote:
> > Inherit bus numbers from the previous kernel during a Live Update when
> > one or more PCI devices are being preserved. This is necessary so that
> > preserved devices can DMA through the IOMMU during a Live Update
> > (changing bus numbers would break IOMMU translation).
> 
> I think changing bus numbers would break DMA regardless of whether an
> IOMMU is involved.  Completions carrying the data for DMA reads are
> routed back to the Requester ID of the read.

Ahh, makes sense. I'll clarify the commit message in the next version.

