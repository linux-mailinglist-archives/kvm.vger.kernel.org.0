Return-Path: <kvm+bounces-48150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D101AC9F4E
	for <lists+kvm@lfdr.de>; Sun,  1 Jun 2025 18:12:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A86F3AF5BB
	for <lists+kvm@lfdr.de>; Sun,  1 Jun 2025 16:12:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02E681EE02F;
	Sun,  1 Jun 2025 16:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FDIpp2r7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7842DCBE3
	for <kvm@vger.kernel.org>; Sun,  1 Jun 2025 16:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748794363; cv=none; b=me/Iu3nTsCNLlrnH4zfPLjLLSN4u4uaaBb3vJHQ2EEyZGRUqU85+KJjzOp1d675byabzTvWRY1vfIxLk1JnGGRump3urgnsaqJvGIkTXPz5D0aOFOSZBTVnZfhGKoWEMhO70pFuvygZDonE2X6VN4i5m7uU0iCx6J/1ays4S7Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748794363; c=relaxed/simple;
	bh=uhTtleqo95gO/Gi5XU8tDu5c2ETuSOVKc9aFuBKmNyY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QubNnO5A76QyrB6BpT6xdVs5INYp1m5OvM+PiFfSrGDxBZcnUi5eqfq8JRKLxSy4Y3wZ8G26FfO5qRCio0o0UP+1Y7Th2TpF+iMwxv4tQU/exJdBnbRsW8N5tEVtREQGZhd64C2kPjkwwN/YNxl1t0swiew6OYGC10cPNFRC1fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FDIpp2r7; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748794361; x=1780330361;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=uhTtleqo95gO/Gi5XU8tDu5c2ETuSOVKc9aFuBKmNyY=;
  b=FDIpp2r7QQQ4gCAESMaqRxWIVR26TNeHhqLO9P9dD7D0hSBDIsR0cy4F
   813OuvXJtEa2nJMt64byDbDMemv8xG3X5gluIMHtC3GwBAHo6Jxb/BgL/
   riUBiU9GKoCUckwPygz7Uft+rgpy6I5xFgcODQB41xiGQWspVKsddjJsa
   mNFX0fIgAWgDwZ4mFbU7BfYEhwvFRFKrFfqLRKUG3lJU96vVhZLvMSWvC
   DPPHid+GiDEBOKJOMUYuPT5H2izvmKbtvzAvuDfYs6VyPhc12kHI9BWOM
   2Q3pn4ahUbbzZgwKQd5TJtZcWFVvpyjvp38bBhsiWmQ3QbsIHFIRjNrea
   Q==;
X-CSE-ConnectionGUID: d7A9IdsPTIuAGH3bCvIlnQ==
X-CSE-MsgGUID: 4oqlfMw7QRqQu7vWmTV9fA==
X-IronPort-AV: E=McAfee;i="6700,10204,11450"; a="54618084"
X-IronPort-AV: E=Sophos;i="6.16,201,1744095600"; 
   d="scan'208";a="54618084"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2025 09:12:41 -0700
X-CSE-ConnectionGUID: aIHRi0hFR/+is+cp14Hs7g==
X-CSE-MsgGUID: EVbOSF0hTB6B6ezHVXDTcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,201,1744095600"; 
   d="scan'208";a="144653807"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2025 09:12:36 -0700
Message-ID: <e2046aa5-13cd-456d-a093-b021a9182532@intel.com>
Date: Mon, 2 Jun 2025 00:12:33 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/5] memory: Unify the definiton of ReplayRamPopulate()
 and ReplayRamDiscard()
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>,
 Peter Xu <peterx@redhat.com>, Gupta Pankaj <pankaj.gupta@amd.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
 <clg@kaod.org>, Alex Williamson <alex.williamson@redhat.com>
References: <20250530083256.105186-1-chenyi.qiang@intel.com>
 <20250530083256.105186-4-chenyi.qiang@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250530083256.105186-4-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/30/2025 4:32 PM, Chenyi Qiang wrote:
> Update ReplayRamDiscard() function to return the result and unify the
> ReplayRamPopulate() and ReplayRamDiscard() to ReplayRamDiscardState() at
> the same time due to their identical definitions. This unification
> simplifies related structures, such as VirtIOMEMReplayData, which makes
> it cleaner.
> 
> Reviewed-by: David Hildenbrand<david@redhat.com>
> Signed-off-by: Chenyi Qiang<chenyi.qiang@intel.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

