Return-Path: <kvm+bounces-64347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id B6054C8018F
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 12:08:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 37150346FAE
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 11:07:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 120892FB962;
	Mon, 24 Nov 2025 11:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G7eAzWb7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5500E2F3609;
	Mon, 24 Nov 2025 11:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763982433; cv=none; b=KRRIMmWNAIf1csyV8dR2aHgnURb6YplMUGp2BBWTGGj2//Iiv252rDypkoSKquD8MYj6mOBAPTRbhkvQXVDqoD3ARHVBcnIchrA4PU2hMFO6prmxkM4r5+GkHoZSc997AwcWI9o47cwbWOWdHChM3/CYzGfqkK2htIcuR5R8ouc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763982433; c=relaxed/simple;
	bh=1zHIvNEf+NEropyB/UiSTJ/BYa9+kSRseH9TJzhz5aY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L8TUCGnsqtCweVgf/oXjGMUiqZAz9x8xAq2M3B8JdTIXhjCElKIG194GK3lLbGO6xEXrWNQ6h+sCZmSXIKMHe3Kkxii7Sc39H1zeBS3ytIaQaq2O+oY0omTTPx64rg+SfhwFK7JAI+Eq8AeDFzkyKFPe7pSIXtHrw/RVki0MgR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G7eAzWb7; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763982431; x=1795518431;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1zHIvNEf+NEropyB/UiSTJ/BYa9+kSRseH9TJzhz5aY=;
  b=G7eAzWb7IocJdC9N91G6A7b2CeSfEGC3i8djQ32L0XxqRzO5trXaXtHz
   fKnRmGdkhEjPd5VY0dlqSCa9UdCn1ffHl6KUsfboEfuseuhCvecwsFUeQ
   ObaAwdLO7nvrbIjoK8x534mOznHK30Np12ANJ3ozu2sH6WC/s+nIYtZc5
   zF6FbjnD4B1uidMmNx7mMnn1m8wMMjEfG/bKXLLK49tBpEhAxVYVkZcOR
   3C/1V8lgRcJ5VeaBwlHdN8tmWdHmQCkceopXZBnD1xw+hSjY0DCS7edQf
   scefYXK8ufEJwFay+d6yKIfVkWjDmj/bP2ZBLfJZAJ873L10+dXRn4hBl
   w==;
X-CSE-ConnectionGUID: uqUv6Bd3Q2KuuLEVzvcHMg==
X-CSE-MsgGUID: FPGGdLc+SKq15fNIYJ1OSw==
X-IronPort-AV: E=McAfee;i="6800,10657,11622"; a="66139180"
X-IronPort-AV: E=Sophos;i="6.20,222,1758610800"; 
   d="scan'208";a="66139180"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 03:07:11 -0800
X-CSE-ConnectionGUID: pegE1URWRviKK6oQP8pXLg==
X-CSE-MsgGUID: d3x5067aS+SRVZGCOqU64w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,222,1758610800"; 
   d="scan'208";a="197230778"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa004.fm.intel.com with ESMTP; 24 Nov 2025 03:07:07 -0800
Date: Mon, 24 Nov 2025 18:52:05 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-coco@lists.linux.dev, linux-pci@vger.kernel.org,
	chao.gao@intel.com, dave.jiang@intel.com, baolu.lu@linux.intel.com,
	yilun.xu@intel.com, zhenzhong.duan@intel.com, kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com, dave.hansen@linux.intel.com,
	dan.j.williams@intel.com, kas@kernel.org, x86@kernel.org
Subject: Re: [PATCH v1 08/26] x86/virt/tdx: Add tdx_enable_ext() to enable of
 TDX Module Extensions
Message-ID: <aSQ41bTeYKo29Zim@yilunxu-OptiPlex-7050>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
 <20251117022311.2443900-9-yilun.xu@linux.intel.com>
 <cfcfb160-fcd2-4a75-9639-5f7f0894d14b@intel.com>
 <aRyphEW2jpB/3Ht2@yilunxu-OptiPlex-7050>
 <62bec236-4716-4326-8342-1863ad8a3f24@intel.com>
 <aR6ws2yzwQumApb9@yilunxu-OptiPlex-7050>
 <13e894a8-474f-465a-a13a-5d892efbfadb@intel.com>
 <aSBg+5rS1Y498gHx@yilunxu-OptiPlex-7050>
 <ca331aa3-6304-4e07-9ed9-94dc69726382@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca331aa3-6304-4e07-9ed9-94dc69726382@intel.com>

> A few more nits, though. Please don't talk about things in terms of
> number of pages. Just give the usage in megabytes.

Yes.

...

> >  -#define TDH_SYS_CONFIG                 45
> >  +#define TDH_SYS_CONFIG                 (45 | (1ULL << TDX_VERSION_SHIFT))
> 
> That's my theory: we don't need to keep versions.

Good to know.

...

> > The TDX Module can only accept one root page (i.e. 512 HPAs at most), while
> > struct tdx_page_array contains the whole EXT memory (12800 pages). So we
> > can't populate all pages into one root page then tell TDX Module. We need to
> > populate one batch, tell tdx module, then populate the next batch, tell
> > tdx module...
> 
> That is, indeed, the information that I was looking for. Can you please
> ensure that makes it into code comments?

Yes.

