Return-Path: <kvm+bounces-71900-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wM34GbyCn2lrcgQAu9opvQ
	(envelope-from <kvm+bounces-71900-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 00:16:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BFD1F19EA83
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 00:16:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9E5D83070B31
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 23:15:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6A0337A489;
	Wed, 25 Feb 2026 23:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SAzDj0cM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F4C3806A2
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 23:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772061350; cv=none; b=Kpx0j1Cmm75mtL+0+bxJ4IGasDo2KFDf5OzqcVAFZFwEdaMbZbGHChot+3tG6Usx6LBiqvUJo2tWE7vyBHuEjo5oWeDGeA/dkZ7mCtOZ+ENHrbHIeN5Wx+ZQoKCj1efx7pVOnyhUmSWdfBEgEN0nf8tKmgUjPMWNUjoJh7ffUiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772061350; c=relaxed/simple;
	bh=5WhoQCUa24yhiUF/WAnlscnk6BtiGnEv65SGVktgBo8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EiDMPPUp4NNNln9FtPZSwwjH3V4oGWhq0DtI4s5Odk0NTtDhUGnRfhqrK8mquIpNPnQH4xmoRZwpxf797cyAyV/EDPCJGWjRdtpeoF3vY5M/rdBKLM4gzvtRMeJ22x7AK8kkyIkvQ53R3CmBF0lFhtqVuFDTP3YIlwUjcBczWko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SAzDj0cM; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-827390e8a3cso154514b3a.0
        for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 15:15:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772061349; x=1772666149; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+aqTMCmmaBlC6BgaLKDJu82UvyrNA1bTtUP5fONJU9U=;
        b=SAzDj0cMcnIVDVrDDPPeF9qTI17Q90maO4BP4ziO34L6rUv6mL1YVRMwWENMo6UhoK
         S78EAj0tAdojwdpSjIA1UkcviDGE+9Lxu3qaHYDAc05L/iXb9ov7ebzJsisQrXP+7LBB
         QVHvs0lTdzYR0O90hbeUPUchlgS7775rDPTxygZUTyBZ3kfpKOm6XJ0Tt5imThS0a3sN
         wpGGuuvNGcQ+rBhHIy7hUPDjjGOFLsJGRKM0AyKSXOOc6Bb3Ybn1ReYri10kI2GEZEoD
         k9znRzQvb6GWXEr+5SAaHM1IYk2QE/OuzpOz/R81m/aBLtCV0eXShGkNMvVBmBfptHuz
         v9Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772061349; x=1772666149;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+aqTMCmmaBlC6BgaLKDJu82UvyrNA1bTtUP5fONJU9U=;
        b=mis1s2xX/J4XTnJOd/qXKBv23TzXan5HwfKgtCf3RjAGhbl7UyARjkZ/m7wcr8RkH0
         vIJLDYA9NAAwqaMtNtVQ5QureTp4Q1KZ7g9Zaw5n+W9HQHNeZYB7hLS1J8IQRLOZinen
         uR8Pzbivosfd+IXsMXZb7G5E8NfiH6KcLUf+5szTNcHrJObet7EXfkl1y1D4azHLw91f
         /+teYdFOn16zioEGhMGdz+RK3iIbjxxQt2eFEZQG4bVjlpvzC8QZ1hvp5em668Jb8TcG
         dyamQoyiARrGAhVlVu8Xna6nXkFeChPDJc6mZZW7AKsj3t/UtxmUQph/OdiB1x3ZEe+Q
         pYVA==
X-Forwarded-Encrypted: i=1; AJvYcCWluisXKJwwgk0J7zxQduu+U0NZxfT0aGxNSkNOfh306shxlizyQn6x251G4cVI9namGdk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxP5+gn0upC0bdysASflgSLXuSwNF0C02CxSIOr66Ff2472l1RW
	PYxPbzOKTxk5Q+9WrJsxzLIl6T0XFmqSHZaPnNCu2NNY3RGeo4DjtmKbTx2cdpsX3A==
X-Gm-Gg: ATEYQzyGjjkU3FnVeLZXKSW6OhDtkYuRsdSnGY0zLHaJBEJpHd6zOfg5Bw1MgbwFGgH
	6IjnhitAPbyAnpd+iN+0BZoptB7LjWbk3XE+kBH0St+aeW8L3XaRZNOUBi6VMr1pnLBffc9LD3o
	9jG2FOz3m56I4SNFjtkE+Sg27GVjj6eFcOlBnXu1S9CqOi0u/oGDGo1b0UadsAm9zcOyAcW9i64
	996LL1Bgn4jCS+5c9UKuse1cqX5H0tPweBi5TQ+XTLI4Vf9Alija7P1kxkkx9Gc62lB0PK3CAaU
	PtJcRGr6cnjXDLE8Lx3FcBu1IHrVs4/kBePrHec5dWCEDsLmLvXc6NZYWwR9XYdTQtQ71s+xK+W
	zf3xyQRsehvDUNsLownMdQWyXmNkKtCbaZm2o9AVPMN9raNwTNV+JUDEjfz3KMNC4eugUWKL3FH
	wswyk9k/C7w0+ZdGQbBRiAfC6qavcHH1K6GRsKsiauVZYEU8v+8kLz0w90xvKvNg==
X-Received: by 2002:a05:6a21:7e0c:b0:395:46aa:4467 with SMTP id adf61e73a8af0-395b1d39ecdmr623014637.14.1772061348571;
        Wed, 25 Feb 2026 15:15:48 -0800 (PST)
Received: from google.com (239.23.105.34.bc.googleusercontent.com. [34.105.23.239])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c70fa8479aasm89953a12.31.2026.02.25.15.15.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 15:15:47 -0800 (PST)
Date: Wed, 25 Feb 2026 23:15:43 +0000
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>,
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
Subject: Re: [PATCH v2 04/22] vfio/pci: Register a file handler with Live
 Update Orchestrator
Message-ID: <aZ-CnywNgMnr6f1k@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-5-dmatlack@google.com>
 <20260225143328.35be89f6@shazbot.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225143328.35be89f6@shazbot.org>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev];
	TAGGED_FROM(0.00)[bounces-71900-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_TWELVE(0.00)[44];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BFD1F19EA83
X-Rspamd-Action: no action

On 2026-02-25 02:33 PM, Alex Williamson wrote:
> On Thu, 29 Jan 2026 21:24:51 +0000
> David Matlack <dmatlack@google.com> wrote:

> > +int __init vfio_pci_liveupdate_init(void)
> > +{
> > +	if (!liveupdate_enabled())
> > +		return 0;
> > +
> > +	return liveupdate_register_file_handler(&vfio_pci_liveupdate_fh);
> > +}
> 
> liveupdate_register_file_handler() "pins" vfio-pci with a
> try_module_get().  Since this is done in our module_init function and
> unregister occurs in our module_exit function, rather than relative
> to any actual device binding or usage, this means vfio-pci CANNOT be
> unloaded.  That seems bad.  Thanks,

Good point. So a better approach that would allow vfio-pci to be
unloaded would be to register the file handler when the number of
devices bound to vfio-pci goes from 0->1 and then unregister on 1->0.

