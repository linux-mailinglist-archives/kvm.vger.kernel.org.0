Return-Path: <kvm+bounces-30825-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A74779BDB41
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 02:38:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65EE6284865
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 01:38:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13A05188A18;
	Wed,  6 Nov 2024 01:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nskBNwSs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C78E17B50E
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 01:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730857120; cv=none; b=LuDLgZX7B0/jdG9ACzHtllCQ0agZebtwNqlgnoaFQliFv/rv+AVkF9DYdUHoD/SDSzd7RtSHxIRFHikjeLi6Fub/K4rS7Ds56ptyUggaNtYQlu3qsR7zVwXenHgrPa+eBQCnW7Yt/yk6HIb1O09v/2Ftq8t0eADVtIUO+CXXJLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730857120; c=relaxed/simple;
	bh=tPRFNaKPEicvx6Pu2FMYGhCu8omtRaZM7BmqKmrKu/A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YgraSBRM5XI+WpI8AncoBZqFNhrEMF4N2IciHnxpV85Tc7bhf+eESdL2ZXT5SQs9AQNQGePW5y/RRPpzHQBnFZqh8eHpVVUEyvk1h0AabmOtIClugJHCDM34RCUnggwaqZHrJVXB7+h4+3tTtezMLgo4/OWGsvJLeiQ0Z7PV6sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nskBNwSs; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730857119; x=1762393119;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tPRFNaKPEicvx6Pu2FMYGhCu8omtRaZM7BmqKmrKu/A=;
  b=nskBNwSs4u2VekKafbMj2ZpQUajcYnsygxuYZPTSANWmu0vUVGfIxfqp
   2Q/yow0i5oauNSQvIrE04CIhBfzOj5E9q1uOxo8iwXqaVn7016Ct1lXJV
   eXA/5x9IuD7QVBWT6QTWGLJGV3mnDIPbbrUlScM3HvJMt3fGmRGeVOMqI
   ShwWkRyhdMSYIyN7uB5ik6AkD29oCd6CgvpyRXwWb5qIPCYoVV62sE3G5
   VU/5ANOCVbnXLCxz9ZNX2Rc7E6um1GrXC9Q2zDpDGEk/R7kfe/zpIdCzG
   CApmlCuZusfIwni/WPNcfcLEmN0nNe2sfHpdVzpaRccsWbOcSnms13Mym
   g==;
X-CSE-ConnectionGUID: Q0hQfLwGQaiURfkxBs5hvg==
X-CSE-MsgGUID: DFTGdphSTRqTqJVTCEdjLw==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="30752125"
X-IronPort-AV: E=Sophos;i="6.11,261,1725346800"; 
   d="scan'208";a="30752125"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 17:38:38 -0800
X-CSE-ConnectionGUID: VtImLotQSI2a516wWfDHcg==
X-CSE-MsgGUID: IzcenzUFR1ih90v0KRtW4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,261,1725346800"; 
   d="scan'208";a="88815774"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 17:38:32 -0800
Message-ID: <4b28eb7d-e600-4e83-b067-7f4f52691564@intel.com>
Date: Wed, 6 Nov 2024 09:38:29 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 13/60] i386/tdx: Validate TD attributes
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "riku.voipio@iki.fi" <riku.voipio@iki.fi>,
 "imammedo@redhat.com" <imammedo@redhat.com>, "Liu, Zhao1"
 <zhao1.liu@intel.com>,
 "marcel.apfelbaum@gmail.com" <marcel.apfelbaum@gmail.com>,
 "anisinha@redhat.com" <anisinha@redhat.com>, "mst@redhat.com"
 <mst@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "richard.henderson@linaro.org" <richard.henderson@linaro.org>
Cc: "armbru@redhat.com" <armbru@redhat.com>,
 "philmd@linaro.org" <philmd@linaro.org>,
 "cohuck@redhat.com" <cohuck@redhat.com>,
 "mtosatti@redhat.com" <mtosatti@redhat.com>,
 "eblake@redhat.com" <eblake@redhat.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "wangyanan55@huawei.com" <wangyanan55@huawei.com>,
 "berrange@redhat.com" <berrange@redhat.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-14-xiaoyao.li@intel.com>
 <1e6cd4c21496452c7dae254ae80fe16a712d0d21.camel@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <1e6cd4c21496452c7dae254ae80fe16a712d0d21.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/6/2024 4:56 AM, Edgecombe, Rick P wrote:
> On Tue, 2024-11-05 at 01:23 -0500, Xiaoyao Li wrote:
>> -static void setup_td_guest_attributes(X86CPU *x86cpu)
>> +static int tdx_validate_attributes(TdxGuest *tdx, Error **errp)
>> +{
>> +    if ((tdx->attributes & ~tdx_caps->supported_attrs)) {
>> +            error_setg(errp, "Invalid attributes 0x%lx for TDX VM "
>> +                       "(supported: 0x%llx)",
>> +                       tdx->attributes, tdx_caps->supported_attrs);
>> +            return -1;
>> +    }
>> +
>> +    if (tdx->attributes & TDX_TD_ATTRIBUTES_DEBUG) {
> 
> What is going on here? It doesn't look like debug attribute could be set in this
> series, so this is dead code I guess. If there is some concern that attributes
> that need extra qemu support could be set in QEMU somehow, it would be better to
> have a mask of qemu supported attributes and reject any not in the mask.

Good catch and good idea!

Will maintain a mask of supported attributes in QEMU.

>> +        error_setg(errp, "Current QEMU doesn't support attributes.debug[bit 0] "
>> +                         "for TDX VM");
>> +        return -1;
>> +    }
>> +
>> +    return 0;
>> +}
> 


