Return-Path: <kvm+bounces-63677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id CA311C6CF6A
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 07:40:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D85FD4F393C
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 06:39:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59E07318125;
	Wed, 19 Nov 2025 06:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NTkABr6Y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC69316192;
	Wed, 19 Nov 2025 06:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763534378; cv=none; b=QEntHcFkTeSXsKza8l9dJE8UMLpSIW5wB4drdZYIWOqDVNf0xroUdaq8GxmA+55jPCodBnR/D9evx4U3xoWurjHtFF5WAXPmM1C1UkRE4zwgfqdY5GVC+1t86Ritwb1LhoxlzHQIznU7ZHhvpujG/ja9Cn4dOWLeXe2g2jAYY/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763534378; c=relaxed/simple;
	bh=nddBFBcPovzz3C7HF1n0k9bjNAx+6gBnK0OvdKQTIEY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R4Z5wi6b0e/HW8Jk1a1VT/53R8P1rZMND1CEJazoYIwpF914y9ZoAS4gqt82MyZCxyNzvGxQ0Hghd5yVKDqt/vjOZQhntRrVtvLgTnpX0BYf59MIIviqI2beFFJUP+SKuCDnaYLJay5iZgsqiqN0tekcsCyYWY/JwDGBTmEiU+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NTkABr6Y; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763534376; x=1795070376;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nddBFBcPovzz3C7HF1n0k9bjNAx+6gBnK0OvdKQTIEY=;
  b=NTkABr6YXe4aEGlt0b6akXvCnjq9ws02RDIQxQyoZFq5oLYoBA5vs05t
   LRlpdHhsL9CALEwz7f31stdf58uWPMV6jd39/BVVAzQnI1QOO6y2twVMb
   V+Xu7WYCiE1pBMG9i12sVkOd4NevQ8ZSIlOqWVObHvB1J7cvZ9jq1RKl7
   SM00sNxI39us5Hk9TJIKdcqCi+DJBiysQBG+Dwkw/zL08NVxSCW3jhio+
   KGwX5mAetAl1GrTgP6fSNbxrP6/4EkEkW60aaf2/0orwwbsqNL00Nallq
   m71ElMFEGn3G7k1lQ2WTaHTNfh/cKkxtQ9kKleqlkhLeSQHQs+6EWzr8T
   g==;
X-CSE-ConnectionGUID: 4/6niEX7RuudSmZeHIGsTw==
X-CSE-MsgGUID: 1fbhztEVT7meHfwcbRxDpQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11617"; a="88221153"
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="88221153"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 22:39:35 -0800
X-CSE-ConnectionGUID: qSxevqoTTb23NYKmGPqzGw==
X-CSE-MsgGUID: a/xHd/tuRYqO76u0US4EDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="190762232"
Received: from yinghaoj-desk.ccr.corp.intel.com (HELO [10.238.1.225]) ([10.238.1.225])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 22:39:30 -0800
Message-ID: <4a2a75d2-05b5-4132-a3ea-fb2ec876b7c2@linux.intel.com>
Date: Wed, 19 Nov 2025 14:39:28 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 14/23] KVM: TDX: Split and inhibit huge mappings if
 a VMExit carries level info
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com,
 dave.hansen@intel.com, kas@kernel.org, tabba@google.com,
 ackerleytng@google.com, michael.roth@amd.com, david@redhat.com,
 vannapurve@google.com, vbabka@suse.cz, thomas.lendacky@amd.com,
 pgonda@google.com, fan.du@intel.com, jun.miao@intel.com,
 ira.weiny@intel.com, isaku.yamahata@intel.com, xiaoyao.li@intel.com,
 chao.p.peng@intel.com
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094423.4644-1-yan.y.zhao@intel.com>
 <141fd258-e561-4646-8d86-280b14e7ca32@linux.intel.com>
 <aR1j5SlA/YlOL8zo@yzhao56-desk.sh.intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <aR1j5SlA/YlOL8zo@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/19/2025 2:29 PM, Yan Zhao wrote:
[...]
>>> +static inline int tdx_check_accept_level(struct kvm_vcpu *vcpu, gfn_t gfn)
>> The function name sounds like it is just doing check, but it may split a
>> hugepage on mismatch.
>>
>> How about tdx_enforce_accept_level_mapping() or something else to reflect
>> the change could be make?
> What about tdx_honor_guest_accept_level()?

It looks good to me.

