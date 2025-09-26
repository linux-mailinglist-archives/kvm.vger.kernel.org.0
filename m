Return-Path: <kvm+bounces-58845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F233BA268F
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 06:52:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 39D1C4E210C
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 04:52:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57154274B48;
	Fri, 26 Sep 2025 04:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MAhzkNoW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A89817597;
	Fri, 26 Sep 2025 04:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758862339; cv=none; b=RqaqSEchqJbotkVPdL+EnsjdygrJX8LL4Vb6OPKf9FwUlE4bBrV1jvxt2nggYUShnBH/c1emjUk+x6iKPc5CQpyN/P+jlRp3xO82l4N0hBC2kY97tJaci2CSWIPlBP8lmi3ZCSXTZQHOYdcfAD73VolktbnUWhRrC6Lpw9MAI4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758862339; c=relaxed/simple;
	bh=pi/qxE7z3rXc4YQAphl1XI6jyYFay+KjD9vofv+0N4A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h7+KNhyHfAtZFElIvAcfdYyDgdzWZApO/69hQ2Eo2AGS55umsMSmrfTT1VZLgXa9XVntGNNKqSGQMWJCQ7bM4onPTPEPSzJBUUUTLi/bKY8YBKWsouwxUOkeASC/rcoeM9X05/Mc0ALa8GXhWYepsUJGo/9cb841pemc5p9KQas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MAhzkNoW; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758862338; x=1790398338;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=pi/qxE7z3rXc4YQAphl1XI6jyYFay+KjD9vofv+0N4A=;
  b=MAhzkNoWo6QvIE3dS9LqHiPRo0U5KC230tnf23NRYGuBBjcVHnMan/LH
   TZBfkj4Fm8seqWkkQNLIQT9siKx2DzIIVTIRb9vM/z9PCyaZbOZKWWS60
   X067QkJ+y9F3/r0FiPBuSO+kw1zoOUMOT0Y7KdflkA0xK7VV2zTH8QARS
   D+hNNfO1sDEV2ChAA7ZDP8YlqN+awv4sjil/8rxTBGuJzjyyiDg12zw8E
   JkeN6yRjnrdRLYGN/MbZN1vQy/1cnp0U70WTZKtXbJrza80PQkFlExLXS
   +DuffldxROHl5T5NW1t9vDHBR/wiCFrAaXbnVTnpwaegICViryQx/6dF7
   w==;
X-CSE-ConnectionGUID: OE07OH/gTFCUltZgFYDtFw==
X-CSE-MsgGUID: oeUELk1XS3y5Q7auQLo3Ag==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="78832491"
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="78832491"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 21:52:17 -0700
X-CSE-ConnectionGUID: 4V2GSJqpTPedKDw4GCOpTg==
X-CSE-MsgGUID: XMMJGNDCS9qfljpRetNJ7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="177563189"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 21:52:11 -0700
Message-ID: <34a98a69-8ce2-447a-91b1-7c0232acdc46@intel.com>
Date: Fri, 26 Sep 2025 12:52:08 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/16] x86/tdx: Move all TDX error defines into
 <asm/shared/tdx_errno.h>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, kas@kernel.org,
 bp@alien8.de, chao.gao@intel.com, dave.hansen@linux.intel.com,
 isaku.yamahata@intel.com, kai.huang@intel.com, kvm@vger.kernel.org,
 linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, mingo@redhat.com,
 pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de, x86@kernel.org,
 yan.y.zhao@intel.com, vannapurve@google.com
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
 <20250918232224.2202592-2-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250918232224.2202592-2-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/19/2025 7:22 AM, Rick Edgecombe wrote:
> From: "Kirill A. Shutemov"<kirill.shutemov@linux.intel.com>
> 
> Today there are two separate locations where TDX error codes are defined:
>           arch/x86/include/asm/tdx.h
>           arch/x86/kvm/vmx/tdx.h

it's "arch/x86/kvm/vmx/tdx_errno.h" actually.

> They have some overlap that is already defined similarly. Reduce the
> duplication and prepare to introduce some helpers for these error codes in
> the central place by unifying them. Join them at:
>          asm/shared/tdx_errno.h
> ...and update the headers that contained the duplicated definitions to
> include the new unified header.
> 
> Opportunistically massage some comments. Also, adjust
> _BITUL()->_BITULL() to address 32 bit build errors after the move.


