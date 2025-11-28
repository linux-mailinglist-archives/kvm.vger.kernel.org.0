Return-Path: <kvm+bounces-64918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 973D0C90A54
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 03:40:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5E0F234C048
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 02:40:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DBD328469F;
	Fri, 28 Nov 2025 02:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a+tYS2rk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF112773E3;
	Fri, 28 Nov 2025 02:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764297623; cv=none; b=DKb8VmLMFO6GdormnJ5D+A+ELimsSUDhWf1tBP3YhOiDBpbVbTwyM5Oaf/9Y0MXUeUTZj+4kI9hHghj10/JkoZjQqtlPy4tWzG22+2LkW0c63iGlwOFvEObvT5UlDY174I5flWfF4gy+g2QXGr6N3/9TUg1LDSzqfsRLxkmoXsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764297623; c=relaxed/simple;
	bh=K95wxhobgGglZOYGcyFGoJ32RHrTOrROXG0t0U1dRY0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nIs0ZSIKvXQl79eNbEXAXHkq8I4KtuoUDPLpcQIOmUzHny2fZjXKfDuxnQlM+ZHNfR9K/qyukHr43yDLOWxcycBaQOUXS84mARhaXMeTLATdreiwPLgLMhLgPaI05/GQN4gDUWC+XQzmaomaMurmbXZm4gXoXY9LkrhsiQjuEpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a+tYS2rk; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764297622; x=1795833622;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=K95wxhobgGglZOYGcyFGoJ32RHrTOrROXG0t0U1dRY0=;
  b=a+tYS2rkHYY/bVCMYkrGzVCNLBBFi7wNvXqJZL6MbjOncyxc6fGOTzVi
   nD2JSHfiJgS8LZzXF0GKwJMQHbxwZOkPTIDYbB6F/hbdogIt5dVpbfOjB
   6ZueiwiLZDsRqY/JiJby8BY2QBiqfejKIWCNVBjvyDBTC04W81jjKn2W2
   X2Ug3d3qAnQq3cCR8APrNjkJ0iwlaQIuvPMZMDhXF6lXE38n/eIBNnxfP
   AaN8j/y06RWgibTSf43phXEbxoIwBX1LivO4qqwbRhxIHLiXHPBEoUXMp
   toH0ad5uthyznbHUCfFE3strILy1bx12xuGe7lWYu9Rbt9buDHIEGTns4
   A==;
X-CSE-ConnectionGUID: zNl7wYVvSgaectPApwRKhg==
X-CSE-MsgGUID: DgvIom9NQcqeh0qZO91MMg==
X-IronPort-AV: E=McAfee;i="6800,10657,11626"; a="65521551"
X-IronPort-AV: E=Sophos;i="6.20,232,1758610800"; 
   d="scan'208";a="65521551"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2025 18:40:21 -0800
X-CSE-ConnectionGUID: DaWShDwySy6lXC8TH3WCSQ==
X-CSE-MsgGUID: Rz9tTB3nTMqYD02/o7xlKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,232,1758610800"; 
   d="scan'208";a="224054390"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.173]) ([10.124.240.173])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2025 18:40:17 -0800
Message-ID: <6105befe-cb9c-45d3-8536-c0aab63e1b57@intel.com>
Date: Fri, 28 Nov 2025 10:40:14 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] x86/split_lock: Don't try to handle user split lock
 in TDX guest
To: Andrew Cooper <andrew.cooper3@citrix.com>, kas@kernel.org
Cc: bp@alien8.de, chao.p.peng@intel.com, chenyi.qiang@intel.com,
 dave.hansen@linux.intel.com, hpa@zytor.com, kvm@vger.kernel.org,
 linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, mingo@redhat.com,
 reinette.chatre@intel.com, rick.p.edgecombe@intel.com, tglx@linutronix.de,
 x86@kernel.org
References: <f2hkqt5xtmej7cfnuytigcfszr3qja4l6ywww4qrqxjbqmlko2@r75b6deae2hd>
 <4676722f-98a3-4217-a357-068440dc6e14@citrix.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <4676722f-98a3-4217-a357-068440dc6e14@citrix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Andrew,

On 11/28/2025 12:55 AM, Andrew Cooper wrote:
>> I am not sure. Leaving it as produces produces false messages which is
>> not good, but not critical.
>>
>> Maybe just clear X86_FEATURE_BUS_LOCK_DETECT and stop pretending we
>> control split-lock behaviour from the guest?
> 
> (Having just played with this mess for another task) you're talking
> about two different things.
> 
> Sapphire Rapids has an architectural BUS_LOCK_DETECT (trap semantics,
> #DB or VMExit), and a model-specific BUS_LOCK_DISABLE.
> 
> It's BUS_LOCK_DISABLE which generates #AC, with fault semantics,
> preventing forward progress.  It also means the Bus Lock didn't happen,
> and there's nothing to trigger the BUS_LOCK_DETECT (trap) behaviour.
> 
> Given that TDX is enabling BUS_LOCK_DISABLE, it's probably also enabling
> UC_LOCK_DISABLE (causes #GP) too.

Well, more accurate, it's SPLIT_LOCK_DISABLE, not BUS_LOCK_DISABLE.(bus 
lock have two types: split lock and uc lock)

No, it's not TDX who is enabling SPLIT_LOCK_DISABLE, but the host. The 
default mode of Linux is "warn", so that by default the host Linux 
enables SPLIT_LOCK_DISABLE. And TDX module doesn't context switch 
MSR_TEST_CTRL when entering into the TDX vCPU because MSR_TEST_CTRL is 
not virtualizable. Thus SPLIT_LOCK_DISABLE remains enabled when TDX vCPU 
is running.

Regarding UC_LOCK_DISABLE, Linux doesn't enable it. Not sure if BIOS 
enables it or not (as far as I know, I don't see any bios enables it)

> Looking at the backtrace:
> 
>    x86/split lock detection: #AC: split_lock/1176 took a split_lock trap at address: 0x5630b30921f9
>    unchecked MSR access error: WRMSR to 0x33 (tried to write 0x0000000000000000) at rIP: 0xffffffff812a061f (native_write_msr+0xf/0x30)
> 
> 
> First, "took a split_lock trap" is wrong.  It's a fault, not a trap.

Hi x86 maintainers,

Should we fix it?

> Second, because the attempt to disable BUS_LOCK_DISABLE was blocked,
> simply retrying the instruction will generate a new #AC and livelock.
> Linux probably ought to raise SIGSEGV with userspace, for want of
> anything better to do.

This patch is just achieving this, while it raises the SIGBUS to userspace.

> It looks like software in a TDX VM will simply have to accept that it
> cannot cause a bus lock.

If the host doesn't enable SPLIT_LOCK_DISABLE, then split lock might not 
be fatal to TDX guests.

> ~Andrew


