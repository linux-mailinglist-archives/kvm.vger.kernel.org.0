Return-Path: <kvm+bounces-34581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C03DEA02378
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 11:51:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 528263A46AA
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 10:51:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFD651DC1BA;
	Mon,  6 Jan 2025 10:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eKymy5NA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C331D8E06;
	Mon,  6 Jan 2025 10:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736160682; cv=none; b=UIEPthfP5e8DV9QeGPUIZo1beXjyc+0xvWtrER1Kfs6CUew7ncA5s2hS4ROH7dWdjZVppEq6CV5PpBV7Ie6nlmgXCkyC2ATo9wQSGsbUUGOqBLv2adyTTxxeSLzf4wpAsAPVCu8z+76XrP7teHVuUbMsxVG86VsnVjJaL1erc6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736160682; c=relaxed/simple;
	bh=TPeY/JM1f9CQLCX8R8m6iizmmy81cmTo366j/gz58rg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ENC2ScQNoDuW6uOwJtZKq/T8xGH14G+6KkRVoe3P1hHnEAefTLKuGre9InL5d3JCgmeoP+Budk+ajwG6gxiJAQzKTOBsjiwHMNRDuYH6t1FCE0Ugf1AmDt4ijpX7LeAGXrP5lteRyX7xM0Zq+qftGQMg2dhUlNrrGpfuJnkRZZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eKymy5NA; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736160681; x=1767696681;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=TPeY/JM1f9CQLCX8R8m6iizmmy81cmTo366j/gz58rg=;
  b=eKymy5NAUwe5rbYyhzAmI7n0DlwTHgFsxgEE3flZY+k/3czJlcGFFVyW
   FWtFi+4wd0fmLZOQyIEJ0jcfdYGX52msUC9K7JvjcoP8bOpYNKT9s39lk
   1UkjncMSeVjzybtYYRgW+nXhTktRADs9wFMQbVXRdluMxdbZXKpLesSyg
   JMQmnEqlQH246y6Skb/mn26sGUNLMbUIEX+rQQ/LrQGeUacCQugr5LqiD
   Gn9r2W76esfo6h5P4oFImvrwYbsIo+QLI/preqkP4PUgzHepCxwE7QTT4
   0J/kLj8BRuEkpIjeSV1M7IyCQ3ECPZzbm6CiUAV4QPfWsFc0+N5S18dvb
   w==;
X-CSE-ConnectionGUID: 6W4m1YieQm+aoR9vJ8tORA==
X-CSE-MsgGUID: hsLQR5qWQLKqvZxe5lVnlA==
X-IronPort-AV: E=McAfee;i="6700,10204,11307"; a="46976627"
X-IronPort-AV: E=Sophos;i="6.12,292,1728975600"; 
   d="scan'208";a="46976627"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2025 02:51:19 -0800
X-CSE-ConnectionGUID: 5ZdqgnQUQduTQXeQdXfsDQ==
X-CSE-MsgGUID: HK4ySL+ISTyv6Qfzn4Qd7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="139754639"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2025 02:51:17 -0800
Message-ID: <af89758d-d029-419e-bcb5-713b2460163d@intel.com>
Date: Mon, 6 Jan 2025 18:51:13 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/16] KVM: TDX: TDX interrupts
To: Binbin Wu <binbin.wu@linux.intel.com>, pbonzini@redhat.com,
 seanjc@google.com, kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, tony.lindgren@linux.intel.com,
 isaku.yamahata@intel.com, yan.y.zhao@intel.com, chao.gao@intel.com,
 linux-kernel@vger.kernel.org
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/9/2024 9:07 AM, Binbin Wu wrote:
> Hi,
> 
> This patch series introduces the support of interrupt handling for TDX
> guests, including virtual interrupt injection and VM-Exits caused by
> vectored events.
>

(I'm not sure if it is the correct place to raise the discussion on 
KVM_SET_LAPIC and KVM_SET_LAPIC for TDX. But it seems the most related 
series)

Should KVM reject KVM_GET_LAPIC and KVM_SET_LAPIC for TDX?

