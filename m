Return-Path: <kvm+bounces-57691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id CBC8DB58F5D
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 09:40:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8F97F4E29F3
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 07:40:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCB492EA158;
	Tue, 16 Sep 2025 07:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UWyz34Tn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08B11B87F0;
	Tue, 16 Sep 2025 07:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758008442; cv=none; b=iD98pSolvCPWJjmXix+C/MfJVG8cQzba1+A49zERp1yCoyG8ebMeUS/2XDCjVqWsPBlavBJhc7sbbW/rQXAHF1HwYBmjTFMzWYXjC/jwGWuUBA4U4WciA1ysuW+QPgbFVKjug0XJ7AEmyJSwA6NieT7ylGjNQtwyVkwGPEgdqC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758008442; c=relaxed/simple;
	bh=KiapAhcGf6MR2VSW5jiczDJk3pSyghDU4jqmvZ8AoFk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QjDnMuIDkkuWALcwXeI2iH4OrrfOC1D31FepMnMu8qxZcDGM41gT8qASD1YzfzWNQ0XtdRSaxEFf0x4KB1WJSQ0mE3i7aqfqGgvLTIecAdsryvUU8Sf5K49tVdzJ3loWBBmMH/NauEsAkMlGOKhSBXjzxdSWP79OKUFKwrwXs2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UWyz34Tn; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758008441; x=1789544441;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=KiapAhcGf6MR2VSW5jiczDJk3pSyghDU4jqmvZ8AoFk=;
  b=UWyz34Tn6+wa81Av4qijtpvFwkNRTRw+LBlAM3MKnkLZMAPkJQ5fRVuE
   8HX1oqHRmQPSaAneAmWnA9j6GXOvmJRMeYBwr6jPepui/t0eF6ZCA2vnh
   LfklhrTgGFBJEv68XjWjl+uWbzF42YMQkLjvJyHg4sGAkhHHcRVR61QTF
   KKYr1XwCLjkUI71lZzN1UWWIQ5dDuJ15p4wO2rUqM+fEDurnsGRoiiBrm
   sZoCHhaQ6u4qX06g23C9KwIFXkNMqACYdn3KspSkn6JddrsNlSUg+hBbe
   ywjb54P4KcdWDQciXGhIQ5PZr2FjOo5SGxum61tpMEIaNlXs4Bf7M4jts
   A==;
X-CSE-ConnectionGUID: fs94aOATThauZb8j0REgbA==
X-CSE-MsgGUID: moGqq8IkT0eYbHlKmgZ+5g==
X-IronPort-AV: E=McAfee;i="6800,10657,11554"; a="60208412"
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="60208412"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 00:40:40 -0700
X-CSE-ConnectionGUID: 6jtt4niXQ8G1rlEHJwhpuQ==
X-CSE-MsgGUID: 5PxV8ZkwQ+yaQiT6eRRVqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="179153577"
Received: from junlongf-mobl.ccr.corp.intel.com (HELO [10.238.1.52]) ([10.238.1.52])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 00:40:36 -0700
Message-ID: <254ecddb-1bc3-4126-8256-9ef7044865de@intel.com>
Date: Tue, 16 Sep 2025 15:40:33 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 16/41] KVM: VMX: Set up interception for CET MSRs
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-17-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250912232319.429659-17-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/13/2025 7:22 AM, Sean Christopherson wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
> 
> Enable/disable CET MSRs interception per associated feature configuration.
> 
> Pass through CET MSRs that are managed by XSAVE, as they cannot be
> intercepted without also intercepting XSAVE. However, intercepting XSAVE
> would likely cause unacceptable performance overhead.
> MSR_IA32_INT_SSP_TAB is not managed by XSAVE, so it is intercepted.
> 
> Note, this MSR design introduced an architectural limitation of SHSTK and
> IBT control for guest, i.e., when SHSTK is exposed, IBT is also available
> to guest from architectural perspective since IBT relies on subset of SHSTK
> relevant MSRs.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

