Return-Path: <kvm+bounces-33736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1299E9F11DF
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 17:16:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A9A6F169433
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 16:16:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04F2A1E3DC8;
	Fri, 13 Dec 2024 16:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nLC3q/qp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C6E186294;
	Fri, 13 Dec 2024 16:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734106605; cv=none; b=u7UCHwURObMgVjDB1F4zpxNK36gz+Cicg/06ekX0zNi1Ru2nWQM2nH6KsKsTLaYPPYxOQ17W6OWBf6gFc+rqlucqBkqEaCBcqyHhkFhAYLMcD8al9xPr7WqkVC9pqenojKVM4mdvkj8yLa+WopSmgxPHHnJL40P1Cki8mUJbQ1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734106605; c=relaxed/simple;
	bh=fX5gu/hkKZaIngvj8H3e5UY6gR5FA2hO0+Op5lrqLvk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ujH4tee/zaRu1i5w0Mtx1tXhOnT/DlosXiYW7nj/g1SBxrj146bVjS2y6Xsqi/35c5+7IfTVQR0aKYVWGViaNptmIDVQgeZos3pk3iVevqwmxzzWbKhtuvw9yA7DjhNWJgU7dDQjGZJ/8iKTG1GvKMOsqc/eeOweoLtKkAUYqCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nLC3q/qp; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734106603; x=1765642603;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fX5gu/hkKZaIngvj8H3e5UY6gR5FA2hO0+Op5lrqLvk=;
  b=nLC3q/qpLBjh9Czmt/DwtQh5FqSD7xMLCty765KmYW6245e/xm46KCE0
   RAQH+GnyQMGugOu7RQFeLPr+6/dYguL+B0t3vGd5LYKlQOCI5dPB1fe3+
   aNJfZ7rdnwAnsMLqJW+fWMlQ1Qd0Buww/qu7LYA+QSj5ELXCIbGDOM/nx
   zPsCCcibkMkprPQnntlxPNb4qiQIz8Sd6wncDT6O0psflLKcbElJULsoD
   1SbB5KaMY0vzKEp7rPzXRzMjHZ8LzqG9pCaOSFXpd0QoWQD4+6tA8PAMN
   Z/Het9MHnQcWWlqBf9ULbBON7qvxItNh8393ZdlyTBJwCHumcGc4jRxGj
   g==;
X-CSE-ConnectionGUID: dd5QvgwMQdilbeJTAHGEmw==
X-CSE-MsgGUID: zYo6lpIkT3KTJiMXsnBTiQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11285"; a="52084136"
X-IronPort-AV: E=Sophos;i="6.12,231,1728975600"; 
   d="scan'208";a="52084136"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2024 08:16:41 -0800
X-CSE-ConnectionGUID: 7T2cVA0VS3+6oEPa63a+IQ==
X-CSE-MsgGUID: pWVh0CHpROichN4ZZmmdRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,231,1728975600"; 
   d="scan'208";a="96803742"
Received: from philliph-desk.amr.corp.intel.com (HELO [10.124.223.121]) ([10.124.223.121])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2024 08:16:42 -0800
Message-ID: <d1b0323f-2458-420b-800e-a26ba6550de7@intel.com>
Date: Fri, 13 Dec 2024 08:16:40 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/7] x86/virt/tdx: Add SEAMCALL wrapper to enter/exit
 TDX guest
To: Adrian Hunter <adrian.hunter@intel.com>, pbonzini@redhat.com,
 seanjc@google.com, kvm@vger.kernel.org, dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com, kai.huang@intel.com,
 reinette.chatre@intel.com, xiaoyao.li@intel.com,
 tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com,
 dmatlack@google.com, isaku.yamahata@intel.com, nik.borisov@suse.com,
 linux-kernel@vger.kernel.org, x86@kernel.org, yan.y.zhao@intel.com,
 chao.gao@intel.com, weijiang.yang@intel.com
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <20241121201448.36170-2-adrian.hunter@intel.com>
 <fa817f29-e3ba-4c54-8600-e28cf6ab1953@intel.com>
 <0226840c-a975-42a5-9ddf-a54da7ef8746@intel.com>
 <56db8257-6da2-400d-8306-6e21d9af81f8@intel.com>
 <d1952eb7-8eb0-441b-85fc-3075c7b11cb9@intel.com>
 <6af0f1c3-92eb-407e-bb19-6aeca9701e41@intel.com>
 <ff4d5877-52ad-4e12-94a0-dfbe01a7a8a0@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <ff4d5877-52ad-4e12-94a0-dfbe01a7a8a0@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/11/24 10:43, Adrian Hunter wrote:
...
> -	size = tdvmcall_a0_read(vcpu);
> -	write = tdvmcall_a1_read(vcpu);
> -	port = tdvmcall_a2_read(vcpu);
> +	size  = tdx->vp_enter_out.io_size;
> +	write = tdx->vp_enter_out.io_direction == TDX_WRITE;
> +	port  = tdx->vp_enter_out.io_port;
...> +	case TDVMCALL_IO:
> +		out->io_size		= args.r12;
> +		out->io_direction	= args.r13 ? TDX_WRITE : TDX_READ;
> +		out->io_port		= args.r14;
> +		out->io_value		= args.r15;
> +		break;

I honestly don't understand the need for the abstracted structure to sit
in the middle. It doesn't get stored or serialized or anything, right?
So why have _another_ structure?

Why can't this just be (for instance):

	size = tdx->foo.r12;

?

Basically, you hand around the raw arguments until you need to use them.

