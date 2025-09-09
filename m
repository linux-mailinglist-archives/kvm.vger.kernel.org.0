Return-Path: <kvm+bounces-57095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15F6CB4AA52
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 12:21:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C292342F70
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 10:21:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1E7A31771E;
	Tue,  9 Sep 2025 10:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JjZoAvdb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9FD23F424
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 10:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757413217; cv=none; b=Rz5OKm2AZdjsCFaY6VyYxJYyg4nt5JCC/S64CMse4Tu58SgW2Yxk3hR9f9hdyexZB581RR8KUQTx54qKAn4YoU8gqMU3jauMNNhcjSROnroJUmQ6xZby88yGkOg9rAnNfCHyVQbvYXNs67v4f+ERO4TAYrIY/7WxuZADUsAE5pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757413217; c=relaxed/simple;
	bh=KtyqYgtGj2IeeYynI6Giopf7W60NMs6eGQQ3PdrzYUg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IaLLitUr1bgPO2nxCHtXTjZKgcN5M1ypBu3Hfn1eQE2q6xT/KPDeKtoiv6yrOLKx68Phu9KOY7bTwwso5FFly9g9zO30uhsOHca6W79I67BoMsYXbT+AsoO8sGzHXUh8cXCxK5uJ9bWSl3dbZmyAqVlNieXDWChJM9UxJph/OOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JjZoAvdb; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757413216; x=1788949216;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KtyqYgtGj2IeeYynI6Giopf7W60NMs6eGQQ3PdrzYUg=;
  b=JjZoAvdbjr4Okf3T92+MnmZ8sFFefPZ/A9niYKJcST069eCy852BbGA7
   bBOP60krXn0jwzi8MpgxSUjgAEkwqVs4bKb5D0HWShoCsEo9ANGiUL3eY
   0Cf343NlGAV6m4jIxM/W7zGZOJODcgy+TbXet8YZjfKvZJ1iPI2keSkgF
   6rH7fR3d7s1FGRcUwo3EatmFi5j4LvUIOPUlnHb0ZcVb3nIU2jxI+hBvZ
   05E+PvXjF2u53esYMc4R9TjvEnWBisZq8zOzomWlcIsJgOVQL0XJMeDcC
   UN/4zBFNBYtXH10EBobywvVh3it/e1UofpwSQ/gwD1EcBH/HV3rvclrtJ
   Q==;
X-CSE-ConnectionGUID: RBBsgtWOR5aZR6Qlud+J+g==
X-CSE-MsgGUID: MAQHPEXJS/2KiZ6x/4jHXw==
X-IronPort-AV: E=McAfee;i="6800,10657,11547"; a="47266484"
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="47266484"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 03:20:13 -0700
X-CSE-ConnectionGUID: yQDDTrDSR2ip42H5YSN/0g==
X-CSE-MsgGUID: BV/n25wxSBqt1TL+pgmUpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="172642549"
Received: from carterle-desk.ger.corp.intel.com (HELO localhost) ([10.245.246.29])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 03:20:11 -0700
Date: Tue, 9 Sep 2025 13:20:07 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org
Subject: Re: [bug report] KVM: TDX: Get system-wide info about TDX module on
 initialization
Message-ID: <aL__V4cVjiUZnK26@tlindgre-MOBL1>
References: <aL_lNXLD3XG496lW@stanley.mountain>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aL_lNXLD3XG496lW@stanley.mountain>

Hi,

On Tue, Sep 09, 2025 at 11:28:37AM +0300, Dan Carpenter wrote:
> Commit 61bb28279623 ("KVM: TDX: Get system-wide info about TDX module
> on initialization") from Oct 30, 2024 (linux-next), leads to the
> following Smatch static checker warning:
> 
> 	arch/x86/kvm/vmx/tdx.c:3464 __tdx_bringup()
> 	warn: missing error code 'r'

Thanks fix sent:

https://lore.kernel.org/kvm/20250909101638.170135-1-tony.lindgren@linux.intel.com/

Regards,

Tony

