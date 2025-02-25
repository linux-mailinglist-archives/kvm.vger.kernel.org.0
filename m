Return-Path: <kvm+bounces-39104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E7BAA43EBC
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 13:06:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44EA7420648
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 11:59:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9323267B73;
	Tue, 25 Feb 2025 11:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aQ3BqpjO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E125C262D2D
	for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 11:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740484758; cv=none; b=OLDtPkSohhk/RQxf+0CrwjFm1YW15gGZJdv2vBVN2WCb7KNvT3nWrWKWw9xHZ+8Im70I8ZON2aNhbn1XTjnWVNe9j1KIH29Pah0FL9K/qO4jmMuXO4U4NxAb5TtmlJp5R3e2LxrKaBluca2VBy7vxXBcoAa4pjlTpIPVfikyu1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740484758; c=relaxed/simple;
	bh=mA6pHmi/N+Ky9+mjncvYzVZG397aZLL5f2QGdgF5e7A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MLrH9vuuHqOjVmgUFFftmbk5J/tHIDVSsqkbDa1eTeUf1yeCXq7YrvzeoH+3VUsWnO1clfypoCqzfw54JzMCjoZYZj7vLQUBp0diItk9IYCJFxf8mPegfEawoGoxnbfDrVGR/1jO/I0R0+7iLkU/PGh0I8f8O0ePkpx5JQJjw7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aQ3BqpjO; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740484756; x=1772020756;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mA6pHmi/N+Ky9+mjncvYzVZG397aZLL5f2QGdgF5e7A=;
  b=aQ3BqpjOQaCYXgv/u4JyTLfDCHo4onJtcgHbhYFnyJkWSyHPlDCSe9RZ
   LEOC8/EDvCGo4ojg4l7za7nMiO8U8aOGOOxEwoa5lGHHjaxGs9cchYCac
   MXMWRoV2yaU+FtkM220M452+h8NVzYM9O9wHnRWkoH9XY51fqhiK4ZMaG
   FoysyZeelNWwBmsjkicUfz/MxlbemegUHSuH936eVuAT9uGphmREQ/0oA
   CXVR70eqhhXUxULYBKBY7B3BU2xNti7rJeXzz8XOSijbGMcMC5ubgGr0B
   2EioyKlTF9rvirFyJCLx0BIjttJPUx/n+lOhd/xMdCMH/airJ7tPgO2z5
   w==;
X-CSE-ConnectionGUID: vHwAz6mGT5+YXT8BYBvdBA==
X-CSE-MsgGUID: HZhxhCVHSf+1LiBXJkox1g==
X-IronPort-AV: E=McAfee;i="6700,10204,11356"; a="52283438"
X-IronPort-AV: E=Sophos;i="6.13,314,1732608000"; 
   d="scan'208";a="52283438"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2025 03:59:14 -0800
X-CSE-ConnectionGUID: fNFZR8OlRwmvMiuJ5BAJSQ==
X-CSE-MsgGUID: Pn2KFix6RoWQfI5zatZD4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,314,1732608000"; 
   d="scan'208";a="116855098"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2025 03:59:10 -0800
Message-ID: <d21b66b9-2334-42fc-8087-37667bceba99@intel.com>
Date: Tue, 25 Feb 2025 19:59:07 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 16/52] i386/tdvf: Introduce function to parse TDVF
 metadata
To: Francesco Lavra <francescolavra.fl@gmail.com>,
 Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Igor Mammedov <imammedo@redhat.com>
Cc: Zhao Liu <zhao1.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>,
 Marcelo Tosatti <mtosatti@redhat.com>, Huacai Chen <chenhuacai@kernel.org>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
 <20250124132048.3229049-17-xiaoyao.li@intel.com>
 <7e8ef2dc3958bf9ea68ac3feb68fc216a9107411.camel@gmail.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <7e8ef2dc3958bf9ea68ac3feb68fc216a9107411.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/19/2025 6:58 PM, Francesco Lavra wrote:
> On Fri, 2025-01-24 at 08:20 -0500, Xiaoyao Li wrote:
>> +int tdvf_parse_metadata(TdxFirmware *fw, void *flash_ptr, int size)
>> +{
>> +    g_autofree TdvfSectionEntry *sections = NULL;
>> +    TdvfMetadata *metadata;
>> +    ssize_t entries_size;
>> +    int i;
>> +
>> +    metadata = tdvf_get_metadata(flash_ptr, size);
>> +    if (!metadata) {
>> +        return -EINVAL;
>> +    }
>> +
>> +    /* load and parse metadata entries */
>> +    fw->nr_entries = le32_to_cpu(metadata->NumberOfSectionEntries);
>> +    if (fw->nr_entries < 2) {
>> +        error_report("Invalid number of fw entries (%u) in TDVF
>> Metadata",
>> +                     fw->nr_entries);
>> +        return -EINVAL;
>> +    }
>> +
>> +    entries_size = fw->nr_entries * sizeof(TdvfSectionEntry);
>> +    if (metadata->Length != sizeof(*metadata) + entries_size) {
>> +        error_report("TDVF metadata len (0x%x) mismatch, expected
>> (0x%x)",
>> +                     metadata->Length,
>> +                     (uint32_t)(sizeof(*metadata) + entries_size));
>> +        return -EINVAL;
>> +    }
>> +
>> +    fw->entries = g_new(TdxFirmwareEntry, fw->nr_entries);
>> +    sections = g_new(TdvfSectionEntry, fw->nr_entries);
>> +
>> +    if (!memcpy(sections, (void *)metadata + sizeof(*metadata),
>> entries_size)) {
>> +        error_report("Failed to read TDVF section entries");
> 
> memcpy() cannot fail...
> 

you are right. I will delete the error handling.

