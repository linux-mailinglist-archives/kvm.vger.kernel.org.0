Return-Path: <kvm+bounces-30544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA2889BB605
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 14:27:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 248BF1C21CFB
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 13:27:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96A37224F0;
	Mon,  4 Nov 2024 13:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eJepfHr5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855F8C2FB
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 13:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730726773; cv=none; b=NkkEWrApHRBfIcwV6ShoGiz3jzQoY1QYZ2B7KuRJBBJsaBIAM0x11KA2XJQLXZfSlLlOmbEY9lZDtMocPAoHBOcUjGNMuY66Cg+x9nm17HSpR/zjzdV4OhJvSsOpYo9tDVmNJit8aUoV+W6/3m8UrTmjlVMOnZonu6WQ6EyMp80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730726773; c=relaxed/simple;
	bh=7VEBP+NmFy6er0IkJMuDyZ7/UsPBRGSDCt2+JrIwiOE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fB8TOlycV2UbLmGFXUoaDFLjGjvw7T/osBzreljUy0cNYzKeRWzIMg/yvJbreAoBnIu1yH0Ne4sleQJsu5mGWbMEAW45GVaCAUbN+rkWG/Vc7dh1dwAJu0hxlBNpHrTUGthOGGmOyvzOAlUYDMk/FiPlfQBgma36y4pRuctwNBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eJepfHr5; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730726772; x=1762262772;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7VEBP+NmFy6er0IkJMuDyZ7/UsPBRGSDCt2+JrIwiOE=;
  b=eJepfHr5PjiYV2K0jdcPpkX4LLrBm7Cx92zxfHbYiufvD4RV03/8TCVS
   4QtdJ5YkrhIF+G4V74N0p5dagAyLyOIza4gU/5m/YLAnmcWYO4kWMbsNe
   vTZ7e10V9Z9ywbXNQUtDDzdsHofQscTlQwInvztlkVu94Y7yy0JBooI67
   cI7V7ngKW3uY0WMVEEj8l+kAALEcClnF6INGAmnr8vW/7lDaczGlmNBgx
   j32FyMvnvtyE0UWhIkdxe8fYOG7r/4wNb6gHK9N32Szn51NwjGd8PRBYI
   gnSyN1BEM/6FYN0IR4+m8memMDHpFygyphCO4DW8P+rFow4rjmSUCYwnb
   g==;
X-CSE-ConnectionGUID: TToCIqFYQT2wx5957M8jLA==
X-CSE-MsgGUID: BfplXr4tTwy+SoIi8HNoDQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="30528583"
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="30528583"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 05:26:12 -0800
X-CSE-ConnectionGUID: hcSzQxmHTnibkYfho1nGjw==
X-CSE-MsgGUID: OtModQK9TdC/6G1TsguaBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="83772091"
Received: from linux.bj.intel.com ([10.238.157.71])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 05:26:10 -0800
Date: Mon, 4 Nov 2024 21:21:02 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: kvm@vger.kernel.org, x86@kernel.org, seanjc@google.com,
	pbonzini@redhat.com, dave.hansen@linux.intel.com,
	chao.gao@intel.com, xiaoyao.li@intel.com, jiaan.lu@intel.com,
	xuelian.guo@intel.com
Subject: Re: [PATCH 0/4] Advertise CPUID for new instructions in Clearwater
 Forest
Message-ID: <ZyjKPkrFXrMnqbdS@linux.bj.intel.com>
References: <20241104063559.727228-1-tao1.su@linux.intel.com>
 <20241104065147.GAZyhvAyYCD0GdSMD5@fat_crate.local>
 <ZyhyCU16iZysIFSc@linux.bj.intel.com>
 <20241104095834.GBZyiaytJCvXylJgc2@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241104095834.GBZyiaytJCvXylJgc2@fat_crate.local>

On Mon, Nov 04, 2024 at 10:58:34AM +0100, Borislav Petkov wrote:
> On Mon, Nov 04, 2024 at 03:04:41PM +0800, Tao Su wrote:
> > Would it be better if I attach rev, chapter and section?
> 
> Put enough information from the document so that one can find it doing a web
> search. So that even if the vendor URL changes, a search engine will index it
> shortly after again.
> 

Sure, I agree with you.

> > I mainly referred to the previous patch set [*] which is very similar to
> > this one.
> 
> That patch set is doing more than just adding bits although I still would've
> merged patches 3-8 as they're simply adding feature bits and are obvious.
> 

Got it.

> > If you think a patch is better, I can send a v2 with only one
> > patch.
> 
> Yes please.

Will do, thanks!

