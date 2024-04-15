Return-Path: <kvm+bounces-14695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1805D8A5C94
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 23:04:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4968E1C21067
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 21:04:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C57A15698C;
	Mon, 15 Apr 2024 21:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BDwMsiy0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650AB154452;
	Mon, 15 Apr 2024 21:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713215065; cv=none; b=cK8mszBGXkZWw2rS8hFrkGkFWwrXDHm1sjN0iI2xJsdiXkuWGztV6ZxNZCfjoND4ZitxvPv0L6E7hibJ4nrz4ziVlqeiGv6iPZ3t38iewtBK1sG0E8Dz76RAVhWvcsLn03OSzrPUfDYVLeLbn1SSulj7GQssZYzKmU9cBtfqcBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713215065; c=relaxed/simple;
	bh=VpPrKnE1wFfYyYjI+JUAov+nmTrCKmnuaVcVs7IYrWI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qmkCwf0M3vzBImqNbTaA/cqfLeQRPfNinW5c/FXR0+O7sDu+qFkcw3Giud3j7l261qLlA8Ztd4eGLNmtw6AEyMCHkOa8aKhUstJCB4gJjwQmTgUXdKXhkpcFlBsPy+hVhqjfWDNPA/hcNo7/moJawSczr4gBC5cZa4quEfchtEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BDwMsiy0; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713215063; x=1744751063;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=VpPrKnE1wFfYyYjI+JUAov+nmTrCKmnuaVcVs7IYrWI=;
  b=BDwMsiy0qMv8EadcMCgoT/cW4uuKzSQQKQIK5W/VKt+6OaDsODn3xVV/
   V6dhpM89j8IA2dK44y3khVU8djxXJJIscE6Udgv66JyAE8feckD9pWzkq
   quDhSZvoGIdAaW3RlPNSa/NukmQ8t7OCQlRHkF/SFkAnmk+mgzRBGFGMo
   vIVWa6JbUVy85rpEyUfgjvn0I39RPlzEx5+IV+D+4NHjAjjtw9WKVIEIb
   l6WjSDd3ULRdYp4axAnZoIWuk5A3hIyzLvwo6tAMrBNh0yQ7NdYIeMapP
   INNBNqgZqCQZ5PWPvM1k8GeqN1QLYf3Xiuf72T1MHrUQ+AQZgdcI3gpIa
   Q==;
X-CSE-ConnectionGUID: BswEnQteQV6icV7abXBqcA==
X-CSE-MsgGUID: cgr6bRbvQVyjaI66husH1Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11045"; a="19777620"
X-IronPort-AV: E=Sophos;i="6.07,203,1708416000"; 
   d="scan'208";a="19777620"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 14:04:22 -0700
X-CSE-ConnectionGUID: wdffhhFcT7OeJ0YYEK1nTA==
X-CSE-MsgGUID: Apb0PJ5FSi2E4qA8FJDV0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,203,1708416000"; 
   d="scan'208";a="52982151"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 14:04:23 -0700
Date: Mon, 15 Apr 2024 14:04:21 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"davidskidmore@google.com" <davidskidmore@google.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"srutherford@google.com" <srutherford@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pankaj.gupta@amd.com" <pankaj.gupta@amd.com>,
	"Wang, Wei W" <wei.w.wang@intel.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>
Subject: Re: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
Message-ID: <20240415210421.GR3039520@ls.amr.corp.intel.com>
References: <4ae4769a6f343a2f4d3648e4348810df069f24b7.camel@intel.com>
 <ZhVsHVqaff7AKagu@google.com>
 <b1d112bf0ff55073c4e33a76377f17d48dc038ac.camel@intel.com>
 <ZhfyNLKsTBUOI7Vp@google.com>
 <2c11bb62-874e-4e9e-89b1-859df5b560bc@intel.com>
 <ZhgBGkPTwpIsE6P6@google.com>
 <437e0da5de22c0a1e77e25fcb7ebb1f052fef754.camel@intel.com>
 <19a0f47e-6840-42f8-b200-570a9aa7455d@intel.com>
 <20240412173935.GH3039520@ls.amr.corp.intel.com>
 <a5dd127e9f13fb012edea4a02492abe34fd3c259.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a5dd127e9f13fb012edea4a02492abe34fd3c259.camel@intel.com>

On Fri, Apr 12, 2024 at 08:05:44PM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> > We can use device attributes as discussed at
> > https://lore.kernel.org/kvm/CABgObfZzkNiP3q8p=KpvvFnh8m6qcHX4=tATaJc7cvVv2QWpJQ@mail.gmail.com/
> > https://lore.kernel.org/kvm/20240404121327.3107131-6-pbonzini@redhat.com/
> > 
> > Something like
> > 
> > #define KVM_X86_GRP_TDX         2
> > ioctl(fd, KVM_GET_DEVICE_ATTR, (KVM_X86_GRP_TDX, metadata_field_id))
> 
> This would be instead of ATTRIBUTES and XFAM?

This is to replace KVM_TDX_CAPABILITIES.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

