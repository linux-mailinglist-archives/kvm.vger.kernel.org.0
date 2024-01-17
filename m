Return-Path: <kvm+bounces-6383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D972D830262
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 10:35:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B7451C2128E
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 09:35:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A187E1401F;
	Wed, 17 Jan 2024 09:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="KdAVQFGo"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742F867C6E;
	Wed, 17 Jan 2024 09:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705484091; cv=none; b=C043eFWyUWSCUdHTpCtFrrtUB73pER1HwM99YlvxWi3CsA5KVv1OoRVYdh1r8kgbWbBFmoJbNgrsPJc22XhWu9xMIszAxSMHZiVTuGrMvmYCx69+Z3CXx2LrK/u6WkdEENNyLkHnj5KfJlxT4gNLiEFhVNDuGpY3hMk2FlZ5AXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705484091; c=relaxed/simple;
	bh=orkT7LXixbgsPn4N1XEWMynXnZfNfGpgiHmaG+54rCs=;
	h=Received:X-Virus-Scanned:Received:DKIM-Signature:Received:Date:
	 From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=kLy1m08iwpaMEXHfgRaZOUhNMnKuhr3fjldNW+Ed/I+CrCxJyzbf0XUQOOfcMHVWlfgT22bFO5LHx/n2fv7bcLPs6UNC06Dea1aO4xgm9ucder047xDWGHQfzf4TgRdWCCVQ5/GnYEJp9tAjGp3IS79z4l5YzHPk1RNnxXD/BS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=KdAVQFGo; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 74C1F40E01B2;
	Wed, 17 Jan 2024 09:34:45 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 99Y-ZDDsaapm; Wed, 17 Jan 2024 09:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1705484083; bh=g7EGo61gChdLMP36XWtArwGzH5MicsbmHMpZGITpmKE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KdAVQFGoTvsWN62JBRPJezAYAZfo8NF2KyS2AonnfT+RG0XFDyq8MfgsErfXeU7Gt
	 Bui+OlYhX5nd4ek3sMMd5eV68mrnAAcrZ1s5ql4H3gbIdld/MM1RzveihPFqHbSBwv
	 7MFY2oSU7CDbVvkO3n0x4Sv2VBi4PrnmrID92Cm35IWGgYlKIYJ/YIV1bdkoHDFRB4
	 8DDYPJhsWmJ63kdlCdCgj2SPftoE7SlpSPcxFkSd3MlmFn0UpgOy6csxSIho7jV0WH
	 6W9HI2eoa3bOc3cXkQ885tvXh8YCaInBNjKf0dLufJkzHROHFQ46Kub2WsGCvV/yDg
	 Iu5gb2nJ9sKw+XXGwpAgVC1EHo7OHdEinBfVwTVmpphvYSW8eS+pyauYU/ci6ot50a
	 pdXVqm2/SU1fJWxsn1x2tA0+aZagIqflybxH7Atsy5sIpvpefJBHs4JNo1iJzpgdoO
	 bEyD0iN3pQ7t7gy+ysHcO8iOTGyQwROfItCc1G8CKRnDD+h6ZqwE5jjadlj2z8hqr0
	 K79POhg4+w0lNuYjeLHanEmPGI5HkRvoCHLSnIdW5j9pmV5Svhf3ypTWJk4UXg1rSh
	 OSeS9wz5SVZtC0oefYlC+s5GGubs3hVSMb9nBVWbM7poXtsAc4F1jNGrGo1cvb9tzi
	 EuzDPL1X0OBKUl4NwVtIQyH4=
Received: from zn.tnic (pd9530f8c.dip0.t-ipconnect.de [217.83.15.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9122640E0177;
	Wed, 17 Jan 2024 09:34:05 +0000 (UTC)
Date: Wed, 17 Jan 2024 10:34:00 +0100
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
	pankaj.gupta@amd.com, liam.merwick@oracle.com
Subject: Re: [PATCH v1 11/26] x86/sev: Invalidate pages from the direct map
 when adding them to the RMP table
Message-ID: <20240117093341.GBZaee9f614RSBhXi0@fat_crate.local>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-12-michael.roth@amd.com>
 <cb604c37-aeb5-45bd-b6db-246ae724e4ca@intel.com>
 <20240115090948.GBZaT2XKw00PokD-WJ@fat_crate.local>
 <6ecc4517-9a4f-4d7e-a630-2b8357b7be05@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6ecc4517-9a4f-4d7e-a630-2b8357b7be05@intel.com>

On Tue, Jan 16, 2024 at 08:21:09AM -0800, Dave Hansen wrote:
> The problem will be the first time someone sees a regression when their
> direct-map-fracturing kernel feature (secret pages, SNP host, etc...)
> collides with some workload that's sensitive to kernel TLB pressure.

Yeah, and that "workload" will be some microbenchmark crap which people
would pay too much attention to, without it having any relevance to
real-world scenarios. Completely hypothetically speaking, ofc.

:-)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

