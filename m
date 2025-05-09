Return-Path: <kvm+bounces-46033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CFC6CAB0E1E
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 11:03:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4CCC216B4BF
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 09:03:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6367B274665;
	Fri,  9 May 2025 09:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i9CbWqeQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE7414F98
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 09:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746781402; cv=none; b=iMFgIdLogcRi8fTLZEaT1T8kkvyaFwem9cV0ILdTmIwK6M/bnBCWl6E5019kdRYKwb7KHmxdkKMrg6pDUyvnUh9ClSUH/ZhsjNyrmIyYQVUppQfzwvde9iPB82YjHhGmHVxtGCFrPveXm/NpE/NSg4DmKtu/MUJF4XGJZP12CZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746781402; c=relaxed/simple;
	bh=l8JyMGZ0zcKsAe3qZtfcs7BWyCr+6rRWirZwK992pLE=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=lH6rJ0xx165zPXIEXkY/7VmBFxWuHp0TGjQ4cJ62JuscnZbMAkBxhpokLNK3RCh0UzmtTkGtctCdzweoYjx52Yc0o9AHcnV6eN4a3yXU0/1xBfFT2GX5z002JG3VvLD1GdOaTMGeqEEVPGIc9yys3TTMpbx7SgtZp3ULGpF0KBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i9CbWqeQ; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746781401; x=1778317401;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=l8JyMGZ0zcKsAe3qZtfcs7BWyCr+6rRWirZwK992pLE=;
  b=i9CbWqeQi1b8vBwhH5zUbqWeMgDycNVfOiYbZUJshQme90aGMr9BJlVJ
   5Lpjkt0wxaPqnDTqSlgKvJ9p5dA+LF0JNaPtCJShgkv/DlPMos36l63dp
   crBvblcjZoqMkMdWnOiuGPkxG6Onu7zKdq9zxOjW++kVzyYgkaeyKX7c+
   kuz9ftMz8IyCl99R+cVWrbHxyCMB0iwjartsF1+41vK7n7zIPbg0d1uev
   DG4lj1pF/1ch7l+9LJw4dFuL2P9OU2iUYWJTjyvxhG2+iWZlwKAgxh/Mk
   zT5TKiWuTXF+9Ad9WhtH8xZSue4dCZv1USYYwMt0HNcm5EbzbgTUKlOA0
   A==;
X-CSE-ConnectionGUID: NKj9bljJTxeHzwutjOh4Lw==
X-CSE-MsgGUID: ux9tNinaT+2uirXGqDv0QQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="47710668"
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="47710668"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 02:03:19 -0700
X-CSE-ConnectionGUID: uinuH+qaQ/6OZxWPwkGL1g==
X-CSE-MsgGUID: AmgzoiFRRviovWwpyWw7RQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="141663661"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.124.240.236]) ([10.124.240.236])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 02:03:15 -0700
Message-ID: <f6b9c107-4f6c-43d5-99f9-c5663cffb0cf@linux.intel.com>
Date: Fri, 9 May 2025 17:03:13 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
Subject: Re: [PATCH v4 11/13] KVM: Introduce CVMPrivateSharedListener for
 attribute changes during page conversions
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>,
 Peter Xu <peterx@redhat.com>, Gupta Pankaj <pankaj.gupta@amd.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-12-chenyi.qiang@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20250407074939.18657-12-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/7/2025 3:49 PM, Chenyi Qiang wrote:
> With the introduction of the RamBlockAttribute object to manage
> RAMBlocks with guest_memfd and the implementation of
> PrivateSharedManager interface to convey page conversion events, it is
> more elegant to move attribute changes into a PrivateSharedListener.
> 
> The PrivateSharedListener is reigstered/unregistered for each memory
> region section during kvm_region_add/del(), and listeners are stored in
> a CVMPrivateSharedListener list for easy management. The listener
> handler performs attribute changes upon receiving notifications from
> private_shared_manager_state_change() calls. With this change, the
> state changes operations in kvm_convert_memory() can be removed.
> 
> Note that after moving attribute changes into a listener, errors can be
> returned in ram_block_attribute_notify_to_private() if attribute changes
> fail in corner cases (e.g. -ENOMEM). Since there is currently no rollback
> operation for the to_private case, an assert is used to prevent the
> guest from continuing with a partially changed attribute state.

 From the kernel IOMMU subsystem's perspective, this lack of rollback
might not be a significant issue. Currently, converting memory pages
from shared to private involves unpinning the pages and removing the
mappings from the IOMMU page table, both of which are typically non-
failing operations.

But, in the future, when it comes to partial conversions, there might be
a cut operation before the VFIO unmap. The kernel IOMMU subsystem cannot
guarantee an always-successful cut operation.

Thanks,
baolu

