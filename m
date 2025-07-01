Return-Path: <kvm+bounces-51184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 470FCAEF63E
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 13:13:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D5C891C017EB
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 11:13:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96823272804;
	Tue,  1 Jul 2025 11:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FICxFd9O"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE49270EDD
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 11:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751368371; cv=none; b=BVYjLRNFoiCMrDGlpDFJbbcnWPm7gzYRunRUXjPJdNEMI6PYiWYuI8nBnLoSg/SxVaadxSTcVRg2A2N8bOJBWxoMxCzhzpRfu360iJ5MbJUd0uL2zpaIaoI8vQ7ExiOYmdZpn83HzBPRQKEX10Nse4QUVDwei6YFquVnlZ84m/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751368371; c=relaxed/simple;
	bh=xFhPSyGkeq1HsapYZVzfhrWmcZVtRpfUOIl6ai+xeUs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YFl9G3GoKgPCshxn+pbpiRJ7l/0U3+a79MamgsrV/cKBiJDh1xWShBooivv5+fzxcihrm2+wcUqJEXyCgrc3wU+8e56cEBNro9LSQWUndy1rf1kaf/w6JvaQhE/ZNUhc7AvevdlUH+tZEb28s68L1QsWg9svomkukhM5fxMVoBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FICxFd9O; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751368370; x=1782904370;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xFhPSyGkeq1HsapYZVzfhrWmcZVtRpfUOIl6ai+xeUs=;
  b=FICxFd9O+6XD87++6BUUEnA3GmaldGWQ5q8Gfg6EMJP69f/Fyv5BJUud
   QqrQatKUh9y59cXoCwKG45ocdilYkIGPwgosFASqwwEKXq3eNHDJ5u4Yf
   oVIxC0AN1vRRYMBwu2Mf9Cyu+i2crIqDQopRxcX3EanYSy/1rYmxYW4WF
   xhU8JZb1yc1of0OE15JPhk1hhxH7M6SUnB0iqrwWlz1gv3AaSu9ZiNixC
   TQojNzBiCvi3hh1IuTmW6W+xZ9nfUaSfyy9wUiAe+dkapv44UIFh3DfPt
   YTH+sUYdl8nDUkk5xV0E1LZKjV903L9Fj589HjDd5Tm+b+wucd57HRc2z
   g==;
X-CSE-ConnectionGUID: f8PQQPGYQRCdd/wcS+IQ2A==
X-CSE-MsgGUID: 7OG0yOmfT6SYqQqZLxGyqw==
X-IronPort-AV: E=McAfee;i="6800,10657,11480"; a="53350492"
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="53350492"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 04:12:49 -0700
X-CSE-ConnectionGUID: 98BTe/sSTTyiYlmlyG8Eyg==
X-CSE-MsgGUID: 0C+mcSFoTUu017pGnoEkVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="153906309"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 04:12:47 -0700
Message-ID: <c6a79077-024f-4d2f-897c-118ac8bb9b58@intel.com>
Date: Tue, 1 Jul 2025 19:12:44 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] i386/cpu: ARCH_CAPABILITIES should not be advertised on
 AMD
To: Zhao Liu <zhao1.liu@intel.com>,
 Alexandre Chartre <alexandre.chartre@oracle.com>
Cc: qemu-devel@nongnu.org, pbonzini@redhat.com, qemu-stable@nongnu.org,
 konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
 maciej.szmigiero@oracle.com, Sean Christopherson <seanjc@google.com>,
 kvm@vger.kernel.org
References: <20250630133025.4189544-1-alexandre.chartre@oracle.com>
 <aGO3vOfHUfjgvBQ9@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aGO3vOfHUfjgvBQ9@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/1/2025 6:26 PM, Zhao Liu wrote:
>> unless it was explicitly requested by the user.
> But this could still break Windows, just like issue #3001, which enables
> arch-capabilities for EPYC-Genoa. This fact shows that even explicitly
> turning on arch-capabilities in AMD Guest and utilizing KVM's emulated
> value would even break something.
> 
> So even for named CPUs, arch-capabilities=on doesn't reflect the fact
> that it is purely emulated, and is (maybe?) harmful.

It is because Windows adds wrong code. So it breaks itself and it's just 
the regression of Windows.

KVM and QEMU are not supposed to be blamed.

