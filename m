Return-Path: <kvm+bounces-50981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 77B7EAEB537
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 12:43:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 163D318930EE
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 10:43:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB5C8299AAB;
	Fri, 27 Jun 2025 10:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XrLb+DbR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A62F298CAC;
	Fri, 27 Jun 2025 10:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751020981; cv=none; b=HrgEaoF49zqU+f04OMetQb/NlcCBf81cUCJa6NbYgHdd1a7Ji7dcg25mzwl+rv3cSzGKy3kDY7rmYvCk9esuI0DxnjBWQXhQgNh/6QFNNW8DwxTcWQvlWMq4IMfr3Z/Yu9UcC6n+7fgra3xAa1e8pzL657/hcVQNmJVVuMqL/vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751020981; c=relaxed/simple;
	bh=qNksC/J273mwaUsS2m9EuF7nQt6hX6JNW0TM/GFGmsg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MAb/AMXf/VtRddoccRDxjOJekTcNiIGYI0P0Y26IxM7KNHvaS1erYC3g6BTdxVyVUeY7rVTYByRduoN67ya+aVHvFqCqWEY2Y7JygmPSh9GyTyB9epjkiVzQVrcstdUCZl/4p4maN6gVWA19BwjoN1VxQ5iUE3a2OA4KqIgH4LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XrLb+DbR; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751020980; x=1782556980;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qNksC/J273mwaUsS2m9EuF7nQt6hX6JNW0TM/GFGmsg=;
  b=XrLb+DbR/aQAvGiUSIDUi5BTqTufJ1EOLWDAJuK6vldA/zCpCQRSMhMq
   OAkqa4bsKBCaALZ3G1b9vuOLDTyDWfGpK4Vb3lYZZ5E2jEYlYAtCCAj2u
   CB4x9Kixsoe4Fxh8KkAS4ni9eydfIqmwT9nOsnHlxsWcpjS+vNzNx2oFz
   S6EAIAgdwvPDV5kyBhY3Z1u1RhMc88nu5cMp+JeTOCvuaLH+abA6ZGqZP
   d75hlvtM/EWreQNFyWy9TCQwh8rMku+fufTvfpoX2oY1+TpeLq0VVw3q5
   HxHSHXjaEIVylGnKP3eA06EaVgXcaYFiwrv9LxB7ZCRH4dTru+yfUIMm8
   w==;
X-CSE-ConnectionGUID: SArEhh7VTEK1iv/uHh7wKA==
X-CSE-MsgGUID: /vgISep/Tju2xA8ohC1GBA==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="53479673"
X-IronPort-AV: E=Sophos;i="6.16,270,1744095600"; 
   d="scan'208";a="53479673"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2025 03:42:59 -0700
X-CSE-ConnectionGUID: hL5zg9NaSGu2+cYvtYCUhw==
X-CSE-MsgGUID: wcmBj/BQTdulu6WwKYYoaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,270,1744095600"; 
   d="scan'208";a="152298286"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa006.jf.intel.com with ESMTP; 27 Jun 2025 03:42:56 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id AC4A26A; Fri, 27 Jun 2025 13:42:54 +0300 (EEST)
Date: Fri, 27 Jun 2025 13:42:54 +0300
From: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"seanjc@google.com" <seanjc@google.com>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 02/12] x86/virt/tdx: Allocate page bitmap for Dynamic
 PAMT
Message-ID: <4ahv7uvjtsabon6e3amc26lkv7saxovzxlo6hldtqne7lpegx6@autbetdzmu4l>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
 <20250609191340.2051741-3-kirill.shutemov@linux.intel.com>
 <cb164ed520e0921ff525db73754759a5c1d135c3.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb164ed520e0921ff525db73754759a5c1d135c3.camel@intel.com>

On Thu, Jun 26, 2025 at 11:08:07AM +0000, Huang, Kai wrote:
> On Mon, 2025-06-09 at 22:13 +0300, Kirill A. Shutemov wrote:
> > With Dynamic PAMT, the kernel no longer needs to allocate PAMT_4K on
> > boot, but instead must allocate a page bitmap. 
> 
> PAMTs are not allocated on boot, but when module gets initialized.
> 
> So perhaps:
> 
> "on boot" -> "when TDX module gets initialized"
 
Ack.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

