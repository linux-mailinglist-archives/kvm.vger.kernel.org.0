Return-Path: <kvm+bounces-57513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE43BB5703E
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 08:29:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 63113167F66
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 06:29:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A5D3280334;
	Mon, 15 Sep 2025 06:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W6kCdIpg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0ADE17C21E;
	Mon, 15 Sep 2025 06:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757917748; cv=none; b=joum+oKK3vXoBSkJBq1vJdX3trvLZQ96Gb46OU0g/5HNSXDhOKlyu3EQSLreslO1sm7CLEmxyZAKKdy0nZ7Bcg30ANVSoBdTk+ljyuA+qWERSnTeRuZhC8H32gbwBIZAbuVQu3mfGMZL57xGvej6tRQPwY3nsHcVbC7mD/HUszs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757917748; c=relaxed/simple;
	bh=piW19FiZACKRsxhgOH5XKTA2SE5fqfb/eQ8PMSGuMfM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tBz0pP4k1YM51fr/29e4XnAgaswOs8L7OzN0TzXckZot+KtJ2Ut3iCVZphnMvPQ7hZiN4gzknMfPRz+l3Q8l1teskIhGRe3YWoAw7y8pbiKUFCBTDyzLtsY186jy8JwNKeaAsNOfamUsIhSgYKblRJfrPLcJbQdJuavIXV9eR/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W6kCdIpg; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757917746; x=1789453746;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=piW19FiZACKRsxhgOH5XKTA2SE5fqfb/eQ8PMSGuMfM=;
  b=W6kCdIpg6TvZrZ3TIv55DtF7Pex1gb5BOZRe5BQqZ7r76BkpAwkIWCg+
   uMA+XZVdoK46/l+iEoQCFsOu/Inyd7TmEBEY/eOoFp5yP8eTsh8wsoI9w
   2fwu7rRHwBSeZY9xcdIG8pncg6W0O96/6Fbs2EQRqxzjMHQU0oEXTLNlj
   ruIC2llfnJHRucsyH94d7bywDu+iMgWuOWCd74GhVaBl7W0AMcBl7jlo0
   tQhwBowebQIc/daBGjHd3hkMPVe1eQpB6HUkIDF+e2epI4dGq4MYOffdA
   3UR7nhvcU8FEmigLnzOLg/b2DGkU4QnQEAkQRxnoU08fKkz7zu63X470k
   g==;
X-CSE-ConnectionGUID: N2UxVss5TJ6tlJiGBPUASQ==
X-CSE-MsgGUID: LVIpFrvdSnGnqhOq4XrtjQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11553"; a="63983345"
X-IronPort-AV: E=Sophos;i="6.18,265,1751266800"; 
   d="scan'208";a="63983345"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2025 23:29:06 -0700
X-CSE-ConnectionGUID: yR8u5o4jRKqpolLqI25Tcg==
X-CSE-MsgGUID: 0KTlnC2LQu6WH/vg3O7mbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,265,1751266800"; 
   d="scan'208";a="178885191"
Received: from junlongf-mobl.ccr.corp.intel.com (HELO [10.238.1.52]) ([10.238.1.52])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2025 23:29:03 -0700
Message-ID: <b328aae7-ba4f-4710-a65a-79e670f92ca2@intel.com>
Date: Mon, 15 Sep 2025 14:29:00 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 04/41] KVM: x86: Introduce KVM_{G,S}ET_ONE_REG uAPIs
 support
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-5-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250912232319.429659-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/13/2025 7:22 AM, Sean Christopherson wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
> 
> Enable KVM_{G,S}ET_ONE_REG uAPIs so that userspace can access MSRs and
> other non-MSR registers through them, along with support for
> KVM_GET_REG_LIST to enumerate support for KVM-defined registers.
> 
> This is in preparation for allowing userspace to read/write the guest SSP
> register, which is needed for the upcoming CET virtualization support.
> 
> Currently, two types of registers are supported: KVM_X86_REG_TYPE_MSR and
> KVM_X86_REG_TYPE_KVM. All MSRs are in the former type; the latter type is
> added for registers that lack existing KVM uAPIs to access them. The "KVM"
> in the name is intended to be vague to give KVM flexibility to include
> other potential registers.  More precise names like "SYNTHETIC" and
> "SYNTHETIC_MSR" were considered, but were deemed too confusing (e.g. can
> be conflated with synthetic guest-visible MSRs) and may put KVM into a
> corner (e.g. if KVM wants to change how a KVM-defined register is modeled
> internally).
> 
> Enumerate only KVM-defined registers in KVM_GET_REG_LIST to avoid
> duplicating KVM_GET_MSR_INDEX_LIST, and so that KVM can return _only_
> registers that are fully supported (KVM_GET_REG_LIST is vCPU-scoped, i.e.
> can be precise, whereas KVM_GET_MSR_INDEX_LIST is system-scoped).
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Link: https://lore.kernel.org/all/20240219074733.122080-18-weijiang.yang@intel.com [1]
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

