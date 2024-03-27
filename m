Return-Path: <kvm+bounces-12761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 14BA788D6C2
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 07:41:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4A58A1F226F7
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 06:41:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0414F241E1;
	Wed, 27 Mar 2024 06:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SGiQ55l2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02609E574;
	Wed, 27 Mar 2024 06:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711521649; cv=none; b=JXlxJuk+f8rLJ0BC+qtMrfDuM5tJPp1hHKnWAKRNeCExniZswdP2XPCNy+0Og8PpPY4lrROZelBB4wbMpi5PFligWiII02hw4ueKhqTw+acL0+aSDssEdeNZ2yh6kkaN/0elLrnPxOcTVbAjUtC9rNZs1+is8JCAAev+8zYZ5TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711521649; c=relaxed/simple;
	bh=sJSXWPv7y3LAtlgAf4xNkAZyP7p6P6pUlbW8YJObejY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NXyHtPOMmySxLlVgA5hs+7EhgmwO4HH838tN4ni3D0Fkm6f7q9xjF9E+qqGmVDjc1eibhVHWTiuTL82WOy7M3Zw8xNJFPPd8b4VFB+ztS1UP2UklzxmOj3g2sBZlfAhwI6jpzsOdn34PH68wQtuKzMD9L9ZyXDhp5dxE0Ju2ehI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SGiQ55l2; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711521647; x=1743057647;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=sJSXWPv7y3LAtlgAf4xNkAZyP7p6P6pUlbW8YJObejY=;
  b=SGiQ55l2Kez/KwuQArBfWGA+KU4nObNUpTQ7Kd8sBfs/Xl1eeg+9+nf0
   Yc1jviMv1M+iuCUh3q22dw+rgpLP8CjHjB51wg0Fy0+mcvsoNe9RJOy3C
   aJRxZqfreUAzGh112YP+KCzrJhKcfQX47b+q+lHigrqjl0+Q5HbeSbjH9
   yFNSMI9ZfeGumvXImvLxUTRHdbfg4UiOJesvksgWjhBILEol6S6EcoVlA
   7vhno58B7DOmvJhfXwpka0HN8/9ziZh4SGuBqr5D0gPXBEC8ByVvhcuK+
   p1hChCD/G+4ncR+8EG8tPEU3JZBzRJAnRjWMEDc3g3FlfG+pnqfv3l190
   w==;
X-CSE-ConnectionGUID: bP4EfQunQrSz2H+HVIWyFA==
X-CSE-MsgGUID: f+uys+qiSgWKzCQXEe+hWQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11025"; a="24094012"
X-IronPort-AV: E=Sophos;i="6.07,158,1708416000"; 
   d="scan'208";a="24094012"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2024 23:40:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,158,1708416000"; 
   d="scan'208";a="53666527"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.125.242.198]) ([10.125.242.198])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2024 23:40:43 -0700
Message-ID: <715a9591-a913-4b79-a07b-9599a67e60e7@linux.intel.com>
Date: Wed, 27 Mar 2024 14:40:25 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests Patch v3 02/11] x86: pmu: Enlarge cnt[] length to
 64 in check_counters_many()
To: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>,
 Zhang Xiong <xiong.y.zhang@intel.com>, Mingwei Zhang <mizhang@google.com>,
 Like Xu <like.xu.linux@gmail.com>, Jinrong Liang <cloudliang@tencent.com>,
 Dapeng Mi <dapeng1.mi@intel.com>
References: <20240103031409.2504051-1-dapeng1.mi@linux.intel.com>
 <20240103031409.2504051-3-dapeng1.mi@linux.intel.com>
 <CALMp9eSsF22203ZR6o+qMxySDrPpjVNYe-nBRjf1vSRq9aBLDA@mail.gmail.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <CALMp9eSsF22203ZR6o+qMxySDrPpjVNYe-nBRjf1vSRq9aBLDA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 3/26/2024 5:41 AM, Jim Mattson wrote:
> On Tue, Jan 2, 2024 at 7:09 PM Dapeng Mi <dapeng1.mi@linux.intel.com> wrote:
>> Considering there are already 8 GP counters and 4 fixed counters on
>> latest Intel processors, like Sapphire Rapids. The original cnt[] array
>> length 10 is definitely not enough to cover all supported PMU counters on these
>> new processors even through currently KVM only supports 3 fixed counters
>> at most. This would cause out of bound memory access and may trigger
>> false alarm on PMU counter validation
>>
>> It's probably more and more GP and fixed counters are introduced in the
>> future and then directly extends the cnt[] array length to 64 once and
>> for all.
>>
>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>> ---
>>   x86/pmu.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/x86/pmu.c b/x86/pmu.c
>> index 0def28695c70..a13b8a8398c6 100644
>> --- a/x86/pmu.c
>> +++ b/x86/pmu.c
>> @@ -254,7 +254,7 @@ static void check_fixed_counters(void)
>>
>>   static void check_counters_many(void)
>>   {
>> -       pmu_counter_t cnt[10];
>> +       pmu_counter_t cnt[64];
> I think 48 should be sufficient, based on the layout of
> IA32_PERF_GLOBAL_CTRL and IA32_PERF_GLOBAL_STATUS.
>
> In any event, let's bump this up!
>
> Reviewed-by: Jim Mattson <jmattson@google.com>

Yeah, would shrink to 48.

Thanks Jim. I'm glad you have time to review this patchset. Not sure if 
you have time to review other patches?


