Return-Path: <kvm+bounces-40315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DADD9A562B7
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 09:40:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 51A3A1895449
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 08:41:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 436FD1C8637;
	Fri,  7 Mar 2025 08:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OhVbB7Uw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7BD1A5B91
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 08:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741336849; cv=none; b=RPbBzjvlMCRoxk9eyxfLuyEIuy6TpRAt4fzvkQjxisutN9uc7cCMwTRqL7rj1/PIuON15RALQXaIZ7q0DL6mL+LPYN8CPyt6r+9zJGV5GWEYwBM9l4BznqqZ13fwv0oIBVmbG8BztDjk6kpz1/H940+5G5AGEZKuRWs7jJY8LU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741336849; c=relaxed/simple;
	bh=HSEx1h7Wj2hEuSbAVMCuuoZ/xzSn15mJMjAE6PL4bZ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NV97N906fA+ReN0Xa5FtO1tQ+uoHz0LKI4Ci3x/4KAN6ZBNJLtCgOGW4nF+h0h1TZiHSY4Qja/1IL18GC+sMh7opqUftd+Lug9VJ3fG1lr6HD8w/190Qt8Ar1DEivetnQpeIgsWjGblMeds+diiydCnjualbYTtYlWjSg7FxzJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OhVbB7Uw; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741336844; x=1772872844;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HSEx1h7Wj2hEuSbAVMCuuoZ/xzSn15mJMjAE6PL4bZ4=;
  b=OhVbB7Uwvj5L+DrVCaD0kO91yBe4E0yrNUyuRdLb+8lDNkBEAmJyc6Yx
   axeZZZldVymRxHZWLgHfWrRW79Fqim5u/uj7xYBDZp4AfGNP2FzOg0RX0
   0GKRtUB5C5mc675Qqq8PwAhaRZIwK27e41iBmasjRyyfddg2I3EnuA2x+
   xn650Bmv7MX0PiYDrnFYkc7iEMWYrJQnopGibl9Oretl83vgO5nABVhjV
   bX2iN1F/ziuEtOTvsapk+5jGN8ntZcEumZu3iyp2AGSPL81ncCfgg9qsl
   LjNz3QE9TV/SLltVCLQBwPZ6P4HkM0sJl6Z80erh/wGq+u1vDnduZzsbL
   Q==;
X-CSE-ConnectionGUID: PYrKsjtBRSm/QcL76Crqbw==
X-CSE-MsgGUID: CWs3APTbRHSI3CrsY9qpaQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11365"; a="46306005"
X-IronPort-AV: E=Sophos;i="6.14,228,1736841600"; 
   d="scan'208";a="46306005"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 00:40:42 -0800
X-CSE-ConnectionGUID: MQYHKvbeSKWtjt9XPsXJGA==
X-CSE-MsgGUID: n3gH5xQhR5ChX39nvWcjmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="150217523"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 00:40:38 -0800
Message-ID: <01e203cf-6bed-4939-8881-7fb552daadd7@intel.com>
Date: Fri, 7 Mar 2025 16:40:34 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/10] [DO NOT MERGE] kvm: Introduce
 kvm_arch_pre_create_vcpu()
To: Zhao Liu <zhao1.liu@intel.com>, dongli.zhang@oracle.com
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
 mtosatti@redhat.com, sandipan.das@amd.com, babu.moger@amd.com,
 likexu@tencent.com, like.xu.linux@gmail.com, zhenyuw@linux.intel.com,
 groug@kaod.org, khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
 den@virtuozzo.com, davydov-max@yandex-team.ru, dapeng1.mi@linux.intel.com,
 joe.jin@oracle.com
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-4-dongli.zhang@oracle.com> <Z8hjy/8OBTXEA1kp@intel.com>
 <acef41fc-9eb1-4df7-b7b6-61995a76fcc4@oracle.com>
 <Z8qlrjciHEbdnqaA@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <Z8qlrjciHEbdnqaA@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/7/2025 3:52 PM, Zhao Liu wrote:
>> I didn't know if I would need to wait until this patch is merged into
>> mainline QEMU. That's why I didn't add my signed-off.
> 
> No problem if Xiaoyao is okay with it (copyright of patches need to
> honor the original author & signed-off). IMO, if your series is accepted
> first, it also helps to reduce the size of the TDX series, and it helps
> the subsequent PMU development (like mediated PMU). Conversely, it's
> also not a big deal; you can simply rebase and remove this patch at that
> time.

Hi Dongli,

Usually, if my TDX series is going to be merged soon, or you think this 
series won't be accepted soon before TDX series, you can just mention in 
the cover letter that this series has a dependency on other patch.

For the case that your series might be accepted earlier, it's better to 
just grab the patches needed by this series from others' series. Just 
like what you did here.

Like Zhao mentioned, when you grab a patch from others and post with 
your series, you need keep the original patch as is (the unchanged 
authorship and signed-off-by chain), in addition to add your 
signed-off-by at last in the chain.

> Even I'm thinking that my KVM PMU filter should perhaps base on your work.
> 
>> I will add in v3 and remove "DO NOT MERGE" if the patch isn't in QEMU when
>> I am sending out v3.

Be sure to add your signed-off-by, which tells you are involved.

> Okay.
> 
> Thanks,
> Zhao
> 


