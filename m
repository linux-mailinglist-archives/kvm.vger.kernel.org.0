Return-Path: <kvm+bounces-6194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F420082D41B
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 07:11:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8D5C11F21540
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 06:11:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09E272572;
	Mon, 15 Jan 2024 06:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DqFJR9Ap"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7238A23C5
	for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 06:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705299086; x=1736835086;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lp6RHB/0UONK9P55OMMDkjSfi/yWfaQppIedH9O1BQ4=;
  b=DqFJR9ApFKSXxc2uPUMsPngRIBde8u9sMu9QT0TQvlzpNf174KBl3C9x
   OQD933ZgKGMnllru+2SzOG50Ix9t2a1RDai52x6/kqisCX2J/pXGhCVDk
   sm+H4RR+nL+IbUJlxMY2bOM0EbgZK+MctpWvtLFiDKHwYvkdMqPSBPqOW
   JGs65W8usIRSWPMd0t4E7p06EYcLmK56alQwdZgvik8KviQfkOCvxxfga
   l3/wFfqxTvMZQGZv1pY2NxF5SRLBF/nClJhlSQL7cnLNgjWWwduZ0I7Ol
   Cu9jrSXrUdV8+RUmvo7u1rAk0fuESTq3KVta/sc+YBajhQXsMqZ9eMtFb
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="485701980"
X-IronPort-AV: E=Sophos;i="6.04,195,1695711600"; 
   d="scan'208";a="485701980"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2024 22:11:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="817719589"
X-IronPort-AV: E=Sophos;i="6.04,195,1695711600"; 
   d="scan'208";a="817719589"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.22.149]) ([10.93.22.149])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2024 22:11:20 -0800
Message-ID: <78168ef8-2354-483a-aa3b-9e184de65a72@intel.com>
Date: Mon, 15 Jan 2024 14:11:17 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 08/16] i386: Expose module level in CPUID[0x1F]
Content-Language: en-US
To: Zhao Liu <zhao1.liu@linux.intel.com>
Cc: Yuan Yao <yuan.yao@linux.intel.com>, Eduardo Habkost
 <eduardo@habkost.net>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 "Michael S . Tsirkin" <mst@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Zhenyu Wang <zhenyu.z.wang@intel.com>,
 Zhuocheng Ding <zhuocheng.ding@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Babu Moger <babu.moger@amd.com>, Yongwei Ma <yongwei.ma@intel.com>
References: <20240108082727.420817-1-zhao1.liu@linux.intel.com>
 <20240108082727.420817-9-zhao1.liu@linux.intel.com>
 <20240115032524.44q5ygb25ieut44c@yy-desk-7060> <ZaSv51/5Eokkv5Rr@intel.com>
 <336a4816-966d-42b0-b34b-47be3e41446d@intel.com> <ZaTM5njcfIgfsjqt@intel.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZaTM5njcfIgfsjqt@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/15/2024 2:12 PM, Zhao Liu wrote:
> Hi Xiaoyao,
> 
> On Mon, Jan 15, 2024 at 12:34:12PM +0800, Xiaoyao Li wrote:
>> Date: Mon, 15 Jan 2024 12:34:12 +0800
>> From: Xiaoyao Li <xiaoyao.li@intel.com>
>> Subject: Re: [PATCH v7 08/16] i386: Expose module level in CPUID[0x1F]
>>
>>> Yes, I think it's time to move to default 0x1f.
>>
>> we don't need to do so until it's necessary.
> 
> Recent and future machines all support 0x1f, and at least SDM has
> emphasized the preferred use of 0x1f.

The preference is the guideline for software e.g., OS. QEMU doesn't need 
to emulate cpuid leaf 0x1f to guest if there is only smt and core level. 
because in this case, they are exactly the same in leaf 0xb and 0x1f. we 
don't need to bother advertising the duplicate data.

> Thanks,
> Zhao
> 


