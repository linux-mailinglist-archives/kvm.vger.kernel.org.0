Return-Path: <kvm+bounces-58621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0823FB98B5B
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 09:58:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A93E2172483
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 07:58:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65CCB28000A;
	Wed, 24 Sep 2025 07:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VVSyi0wn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7641016132A;
	Wed, 24 Sep 2025 07:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758700711; cv=none; b=asyHuVY7a50qESYixAVuDOt6/xzWJxJurjcD2ajBCZn/NKzACTt4ytmFnZGAkuSnYQ5RUqeDz3wPRv+qzHboW84IeoE/aMoVP5zZWJ9Wx24VlGGI3sF1zQEOIOGL8cwtEqJGW/yLuSXQbJEiLa90WuI4ZZCif4Usqb/tmqGWvGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758700711; c=relaxed/simple;
	bh=mt8gJKDFaSad5gUaiDqQw9QnDOAcy7k6tffysTTxn2c=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=HyKvenQXEuFDNiXgQ2yMHGiMvdOSEuaM+oYgAe4XKEiQqYbLf9oRwHSG5rkcY99d+6rCNqeMI/ilQ0a0ZJhOgFFWXsmZWJ8qSMKp8agpPi8KgNVyoCSDXjBFj62qzilSV+UO/hoZ30lOX0/rA9gtAaF79jvmw8Rv1RzHMxz8m5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VVSyi0wn; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758700710; x=1790236710;
  h=message-id:date:mime-version:subject:to:references:from:
   cc:in-reply-to:content-transfer-encoding;
  bh=mt8gJKDFaSad5gUaiDqQw9QnDOAcy7k6tffysTTxn2c=;
  b=VVSyi0wnPghGodAuXQwIJWAP56W7BHkljTFztFUe0Ry50bsF+L1u6Qnm
   tswR0JNU1HPpe8HzPewRxkywzYWqUHnwDB+CJw3Nvp6g9sQdEx1Y3aJTB
   HMxU8d3501gT9VZI17rpvuim7LJxLLwKM8viLQjAc0fcoVBiudQGRRKL1
   aC/fMWxoQr+LI4tb7GUUBTiVQ/p/LVj5gvjJgdqIfnqbPF92Kv+NHhk+t
   oWG0bTHw9bpXLl1ehY9RYctb9W++t9oyfCBTIYeZ0WoIPinRqdR3VHsRO
   EX1xFZ93Xes1DUeF5aBugWTun9MXGHE2/0gvxHAG3ZW0MPLRke5xEjVer
   g==;
X-CSE-ConnectionGUID: LEk7PHaMTHCTeQoQ3FsGMA==
X-CSE-MsgGUID: tPpIZu7FSi+H2GZrBqcQVA==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="60031994"
X-IronPort-AV: E=Sophos;i="6.18,290,1751266800"; 
   d="scan'208";a="60031994"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 00:58:27 -0700
X-CSE-ConnectionGUID: JnF9D1UOTTGUFmF0/Td7rg==
X-CSE-MsgGUID: 4gOqglb/Rn279KnsyfamHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,290,1751266800"; 
   d="scan'208";a="207716846"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 00:58:23 -0700
Message-ID: <c605f6d7-8d9b-473d-a6d5-a38ddccc1a83@linux.intel.com>
Date: Wed, 24 Sep 2025 15:58:21 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/16] KVM: TDX: Add x86 ops for external spt cache
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
 <20250918232224.2202592-12-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
Cc: kas@kernel.org, bp@alien8.de, chao.gao@intel.com,
 dave.hansen@linux.intel.com, isaku.yamahata@intel.com, kai.huang@intel.com,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com,
 seanjc@google.com, tglx@linutronix.de, x86@kernel.org, yan.y.zhao@intel.com,
 vannapurve@google.com
In-Reply-To: <20250918232224.2202592-12-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 9/19/2025 7:22 AM, Rick Edgecombe wrote:
> Move mmu_external_spt_cache behind x86 ops.
>
> In the mirror/external MMU concept, the KVM MMU manages a non-active EPT
> tree for private memory (the mirror). The actual active EPT tree the
> private memory is protected inside the TDX module. Whenever the mirror EPT
> is changed, it needs to call out into one of a set of x86 opts that
> implement various update operation with TDX specific SEAMCALLs and other
> tricks. These implementations operate on the TDX S-EPT (the external).
>
> In reality these external operations are designed narrowly with respect to
> TDX particulars. On the surface, what TDX specific things are happening to
> fulfill these update operations are mostly hidden from the MMU, but there
> is one particular area of interest where some details leak through.
>
> The S-EPT needs pages to use for the S-EPT page tables. These page tables
> need to be allocated before taking the mmu lock, like all the rest. So the
> KVM MMU pre-allocates pages for TDX to use for the S-EPT in the same place
> where it pre-allocates the other page tables. It’s not too bad and fits
> nicely with the others.
>
> However, Dynamic PAMT will need even more pages for the same operations.
> Further, these pages will need to be handed to the arch/86 side which used
arch/86 -> arch/x86

> them for DPAMT updates, which is hard for the existing KVM based cache.
> The details living in core MMU code start to add up.
>
>
[...]

