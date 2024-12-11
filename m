Return-Path: <kvm+bounces-33463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F0B29EC182
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 02:31:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B9EE3188A730
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 01:31:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40BA97DA93;
	Wed, 11 Dec 2024 01:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JQQnkSS9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90DD52451E2;
	Wed, 11 Dec 2024 01:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733880676; cv=none; b=drzr9+IrhpPu62Bur2fcl9MACW+oe/pDs2zUUjFjNZZ/iUBJrcwQ8U4b/XwSy9hwf/SjUkxEwpc8mVgu93m7gnTcWpAsLuEuT+Z2obLnPvJ6N7/U/RjTeRkYR8AJESkSCBvp8GQKAvAo+cs9LyrFgERd8pzCeATpMrl3WqVmxdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733880676; c=relaxed/simple;
	bh=yaftARiUbVgBvmlunQ3xyF3c9wGFVBGc/49CctniBO4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LfGS+gpe95q8PGF8GwGK31DKwl4gGib10S0KtQTRw0MFv4HhxDAucZIjFJkGuAqzpZZamvrQIaCa08Iv7BzbgAWCcOg4Gv0DsirgAvMYlTztD5nsWawbmgdUjYS8wRfx4nilwgLd4ICaqhDwlS09qQJ/XCpFDcK/Fi/muLsw4Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JQQnkSS9; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733880675; x=1765416675;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yaftARiUbVgBvmlunQ3xyF3c9wGFVBGc/49CctniBO4=;
  b=JQQnkSS9whdnpkPGMz7H3q4GImuTr6+kMWUOZitqoxxBhG1mzLqZSqta
   UOlWtqEWVhXybSVUlq4aStBeol/ylUchvbJoUhlOhnyz42kRs+Tln2o6c
   dzHWgBAEwI72wSCGfa5eVPcXtN9p8fgirHYkxc1cRFYEZSMS/kNNLrdRo
   xDjU8R37/SWBla6R+zcY44OIgHNUwtVsNxP19ElvsnBkjAswGTSlgvsrP
   t458eDYqx/aSvZh3tZSMepXMP4ASCCYbNzltLtc2XlRlEZ+RNlydalzpu
   lCnVBD8owaBZQMrgyCkXUqBCEOPLiYx1+PBF2e9K9OL1iAHurvP3zilqN
   A==;
X-CSE-ConnectionGUID: eQsdeC+kSbCsgLMw7R1xig==
X-CSE-MsgGUID: yTBluM0xQuqwi6lT1SKD1A==
X-IronPort-AV: E=McAfee;i="6700,10204,11282"; a="33583246"
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="33583246"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 17:31:14 -0800
X-CSE-ConnectionGUID: kqN5becJTOK3I2HK628D+Q==
X-CSE-MsgGUID: +2W1NSC9QkSfNVJdHlqNpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="100658085"
Received: from unknown (HELO [10.238.9.154]) ([10.238.9.154])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 17:31:10 -0800
Message-ID: <6251ba39-bc90-44ad-bdf3-8de2222dcb72@linux.intel.com>
Date: Wed, 11 Dec 2024 09:31:08 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/18] KVM: TDX: TDX "the rest" part
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: seanjc@google.com, kvm@vger.kernel.org, rick.p.edgecombe@intel.com,
 kai.huang@intel.com, adrian.hunter@intel.com, reinette.chatre@intel.com,
 xiaoyao.li@intel.com, tony.lindgren@linux.intel.com,
 isaku.yamahata@intel.com, yan.y.zhao@intel.com, chao.gao@intel.com,
 linux-kernel@vger.kernel.org
References: <20241210182512.252097-2-pbonzini@redhat.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20241210182512.252097-2-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit




On 12/11/2024 2:25 AM, Paolo Bonzini wrote:
> Applied to kvm-coco-queue, thanks.  For now I used v1 of "TDX vCPU
> enter/exit" as it was posted, but I will check out the review comments
> later.
>
> Paolo
Hi Paolo,

The the following two fixup patches to v1 of "TDX vCPU enter/exit" related
to the later sections.

One is https://github.com/intel/tdx/commit/22b7001fbb58771bf133a64e1b22fb9e47d8a11f
, make tdx_vcpu_enter_exit() noinstr based on the discussion:
https://lore.kernel.org/kvm/Z0SVf8bqGej_-7Sj@google.com/


The other is https://github.com/intel/tdx/commit/13828e0b586eed6618ccdef9e4f58b09358564d2
, move the check of VCPU_TD_STATE_INITIALIZED from tdx_vcpu_run() to
tdx_vcpu_pre_run() based on the discussion:
https://lore.kernel.org/kvm/837bbbc7-e7f3-4362-a745-310fe369f43d@intel.com/
So the check for VCPU_TD_STATE_INITIALIZED in tdx_handle_exit() is dropped in
"TDX hypercalls may exit to userspace"

