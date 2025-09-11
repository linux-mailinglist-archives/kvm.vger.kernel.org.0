Return-Path: <kvm+bounces-57342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A28FBB539E8
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 19:05:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E51087B0147
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 17:03:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB6293568F9;
	Thu, 11 Sep 2025 17:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kvp7u1Rq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261C03629BF;
	Thu, 11 Sep 2025 17:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757610250; cv=none; b=TobDBB4X3sDigCJTIY6BSm8nXyy9yEzO/XsyiW17DBQgTJScWLNGng5pcNKiXoM/QMfzzXqYRDKjOt4x1PMJAul2RcWuk2Wg9cFBORjHD6ZPuDOz+XxuFi9KlkHwZdvR9sY/fdrfKgsWnqAR5kVuBcLQY3F64EukN+LxEqVkW0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757610250; c=relaxed/simple;
	bh=8N5mMv5fgjhOxzGZxcBurgKWa9BbFN4aElChqaQqGVY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wl60VvgftciLGX1JdJjTq/AOcjSWARGSYSDMovukkpzJuHi7SyOWM6Lg1ivkFLLZ2EBUYB68ulYc0B+gRfZScOhDizM9KNpEbNM7CylZ9JrttMKavrI1JytEJZvT8+hvFJ6D4rFnsMys1UcZkAMECPmNnYoe8hD6fWAKYYQamwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kvp7u1Rq; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757610249; x=1789146249;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8N5mMv5fgjhOxzGZxcBurgKWa9BbFN4aElChqaQqGVY=;
  b=kvp7u1RqJluH09PbsXGIsB24rq7mJ91s/wlrzRh2zJMlqU2cuNUWMAf9
   OrdKIxY2Vx/xEKgCqmJV17PaRLFvi74+PU9XwwSk9/na4JvMSPhxyLOlx
   atcdAm7IW5VSYxFPHvBT2A9xFWkA8+6aMT4WlBfuz26yqQg+tWcyReDx/
   vdA5EPJ9I/8VnjZx9KFMORaJDsXzLMCRxq09Ggr0PBcL1TtH5X2/GQZTU
   JXoF8CU9SUvBX2NE/YmGebLuLt7U8EQNHvoXxMqQ5sDifW3CaEf/5BNE8
   OjJiXU2ztArdpm/Ey3BqH97mGgaGKhgbzXKAkjzIuQQGvWmQw51eMlddT
   Q==;
X-CSE-ConnectionGUID: PcuEYZEuSfGYg0hYQcRjyw==
X-CSE-MsgGUID: L6HlqJr1RyWtGZG+gMqCww==
X-IronPort-AV: E=McAfee;i="6800,10657,11549"; a="59648038"
X-IronPort-AV: E=Sophos;i="6.18,257,1751266800"; 
   d="scan'208";a="59648038"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2025 10:04:08 -0700
X-CSE-ConnectionGUID: iJ5GcUU5Ss2brvz9na/HsQ==
X-CSE-MsgGUID: yEmzrzcgTpOhZcWOpOmV6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,257,1751266800"; 
   d="scan'208";a="173308384"
Received: from unknown (HELO [10.125.180.152]) ([10.125.180.152])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2025 10:04:06 -0700
Message-ID: <0387b08a-a8b0-4632-abfc-6b8189ded6b4@linux.intel.com>
Date: Thu, 11 Sep 2025 10:04:04 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 0/5] x86/boot, KVM: Move VMXON/VMXOFF handling from
 KVM to CPU lifecycle
To: Sean Christopherson <seanjc@google.com>, "Xin Li (Intel)" <xin@zytor.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-pm@vger.kernel.org, pbonzini@redhat.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, rafael@kernel.org, pavel@kernel.org, brgerst@gmail.com,
 david.kaplan@amd.com, peterz@infradead.org, andrew.cooper3@citrix.com,
 kprateek.nayak@amd.com, chao.gao@intel.com, rick.p.edgecombe@intel.com,
 dan.j.williams@intel.com
References: <20250909182828.1542362-1-xin@zytor.com>
 <aMLakCwFW1YEWFG4@google.com>
Content-Language: en-US
From: Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <aMLakCwFW1YEWFG4@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
> I also want to keep the code as a module, both to avoid doing VMXON unconditionally,

can you expand on what the problem is with having VMXON unconditionally enabled?
A lot of things are much simpler if it's on at cpu up, and turned off only at the
down path (be it offline of kexec).. no refcounting, no locking, etc...
so would be good to understand what the problem would be with having it always on



