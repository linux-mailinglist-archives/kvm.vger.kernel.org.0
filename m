Return-Path: <kvm+bounces-49369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BB9BAD82EF
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 08:08:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 40FCF164C14
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 06:08:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00725256C9E;
	Fri, 13 Jun 2025 06:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZXy4EPCD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEF91DB346;
	Fri, 13 Jun 2025 06:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749794907; cv=none; b=hxcjUfIqCO2PgAWL2SFTyA19aznMtEHQi9UjekzkWumZqMgdMb4F3b/80JVFm0TP/pt7jqfhAdfHqDlipJHb4QBvL+lt/XhdSud3FDhbioFoXrbw3EwESJ7DqtGmq6Zkh/LFGOiIKpV9Mjb4mDxP3oUUyhBfSOHFtHqVVLmgdB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749794907; c=relaxed/simple;
	bh=Ywmm9R+GsAveGJwXVIrNHVPW7WvotiSTP68Nk6SyG18=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=iM7QeVi8lofgTA8UaPT0+mTdqIpGalkzMiEzQdbk1wPFZJX97oebH2SvSaouTele/tt8QkgP+JYRMIjfEDK/FdaK0oas5VfE8l093ONk5B+EVOkDocOYLzV4uowhfNXBvsR9fOR/JLKjlc2UhJ0FaziHRWLQtcy0UOjrgqZTDBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZXy4EPCD; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749794906; x=1781330906;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=Ywmm9R+GsAveGJwXVIrNHVPW7WvotiSTP68Nk6SyG18=;
  b=ZXy4EPCDEJskoTz8A+hhROAhlAzZ+LT/4y668WScN59Bu/2QffbV6FZu
   rwOQJQU+YXcVg+HT/opcu7RMAgr2YSjvHsHaAAyGBytankfVFThClWy0M
   psHQnO30p8v28etLOoGT0XICJgAyogsI4Ir+IpNgtRzDnyaF03yQ6UuP3
   meh9+KsEAv8HbS/cZB4lzeusEtLe1A2KL70904qPIYRWADLLve6K7UkW7
   FVYI/JYlcJxU0IRn0lXmSfgEU3eYAj7pwQz1k8VsuFK4fG86e83E/atok
   q9qGey6fAdFdSM+X2K7O5fkvK7muo2lc8VTyOlkbmgAsHTqFAAtijGF+8
   w==;
X-CSE-ConnectionGUID: EsB2yo0dStOtPsltoe4r0Q==
X-CSE-MsgGUID: zwiFiisDSAyomzT+EFr2bg==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="62608523"
X-IronPort-AV: E=Sophos;i="6.16,232,1744095600"; 
   d="scan'208";a="62608523"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 23:08:25 -0700
X-CSE-ConnectionGUID: G0hxtRfHSYuwNg3sTxOFkw==
X-CSE-MsgGUID: c4+Dep8ES0GYtSvStebAbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,232,1744095600"; 
   d="scan'208";a="147646095"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 23:08:17 -0700
Message-ID: <0020abc9-73ac-4dee-b643-b21e9283c26e@intel.com>
Date: Fri, 13 Jun 2025 14:08:14 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
To: Yan Zhao <yan.y.zhao@intel.com>, Sean Christopherson <seanjc@google.com>,
 Kai Huang <kai.huang@intel.com>,
 Rick P Edgecombe <rick.p.edgecombe@intel.com>,
 Kirill Shutemov <kirill.shutemov@intel.com>, Fan Du <fan.du@intel.com>,
 Dave Hansen <dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
 Zhiquan Li <zhiquan1.li@intel.com>,
 "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
 "tabba@google.com" <tabba@google.com>,
 "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Ira Weiny <ira.weiny@intel.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 "michael.roth@amd.com" <michael.roth@amd.com>,
 "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>,
 Chao P Peng <chao.p.peng@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 Vishal Annapurve <vannapurve@google.com>, "jroedel@suse.de"
 <jroedel@suse.de>, Jun Miao <jun.miao@intel.com>,
 "pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
References: <c19b4f450d8d079131088a045c0821eeb6fcae52.camel@intel.com>
 <aCcIrjw9B2h0YjuV@yzhao56-desk.sh.intel.com>
 <c98cbbd0d2a164df162a3637154cf754130b3a3d.camel@intel.com>
 <aCrsi1k4y8mGdfv7@yzhao56-desk.sh.intel.com>
 <f9a2354f8265efb9ed99beb871e471f92adf133f.camel@intel.com>
 <aCxMtjuvYHk2oWbc@yzhao56-desk.sh.intel.com>
 <119e40ecb68a55bdf210377d98021683b7bda8e3.camel@intel.com>
 <aEmVa0YjUIRKvyNy@google.com>
 <3a7e883a-440f-4bec-a592-ac3af4cb1677@intel.com>
 <aEubI/6HkEw/IkUr@yzhao56-desk.sh.intel.com>
 <aEu4iPq7o0wXgy/E@yzhao56-desk.sh.intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aEu4iPq7o0wXgy/E@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/13/2025 1:35 PM, Yan Zhao wrote:
> To avoid confusion, here's the full new design:
> 
> 1.when an EPT violation carries an ACCEPT level info
>    (This occurs when TD performs ACCEPT before it accesses memory),
>    KVM maps the page at map level <= the specified level.
>    Guest's ACCEPT will succeed or return PAGE_SIZE_MATCH if map level < the
>    specified level.
> 
> 2.when an EPT violation does not carry ACCEPT level info
>    (This occurs when TD accesses memory before invoking ACCEPT),
> 
>    1) if the TD is configured to always accept VMM's map level,
>       KVM allows to map at 2MB.
>       TD's later 4KB ACCEPT will return PAGE_SIZE_MATCH.
>       TD can either retry with 2MB ACCEPT or explictly invoke a TDVMCALL for
>       demotion.
>    2) if the TD is not configured to always accept VMM's map level,
>       KVM always maps at 4KB.

Is it the decision derived from the discussion of this series to make 
the design simple and avoid the demotion on ACCEPT?

It looks like KVM's own design preference that if the TD doesn't opt-in 
the proposed new feature "always accept VMM's map level', the only way 
it can get the page mapped by EPT as hugepage is always trying to accept 
the page before first access and trying accept starting from biggest 
page size.

I'm OK with it.

>       TD's 2MB ACCEPT will return PAGE_SIZE_MATCH.
> 
> Please let me know if anything does not look right.


