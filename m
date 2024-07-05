Return-Path: <kvm+bounces-21029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 615EC9280D4
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 05:01:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 928FA1C244BA
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 03:01:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5B7B3B1A1;
	Fri,  5 Jul 2024 03:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VBeSt32j"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1B424B28;
	Fri,  5 Jul 2024 03:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720148428; cv=none; b=cf4Gr81MhIQApoxet4nDx7tYjuE7Wy1lOgnZ7IuHPKGobiKdmpgTzq8rQ/nRZZc4xYPBbxjooGXlhx8UqoQHY5qw7XAIU+fhgsk+dsDN+8SRzeLsPQtQCdkyzFOGpe6aqBcr1jUqT9a6Tv918ITlRVPGDam0aNyTqsozVFuANE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720148428; c=relaxed/simple;
	bh=FMMqsuxbmm40KqOqln2jI8V0GzRXHS9cPlxEjc+3CjI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r0N30gNowZWbDmWWl6l//QoiLBNxKDG8iTd9yOeWc/4vaKX1v4ievm9XY/HJI3CIgVU8Y1blQzetkaY+Px/Nbne4fEoDak4JSLZOoBeEUWJVaCSKJGmQHJXzW2uhE+kJlP0kGz+Jfx8dKvabkAX42lQMOr5Pk8FltuJWEOFJkzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VBeSt32j; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720148427; x=1751684427;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FMMqsuxbmm40KqOqln2jI8V0GzRXHS9cPlxEjc+3CjI=;
  b=VBeSt32jWW6xdYqzbDROo63GKlO3eNJuNL+9WN8+llHfC/JyzoyEmlWY
   R8riseyOEyS8iCsFvkBHQZmEROse9+RL1xeL45ck97BswxUQ84l+ghn2+
   wsUmIuJt2uJXiJAnGXKQyT3PM7EscNBhj44XLnTKjRLoqovDBaBBjeslV
   1fsSNVQ3/kap5KevRyPdd44O0Aer3ZJavwNtvLRMyWPRr+WveJcxCoviC
   vMXlZzGyYoMvRajLg/HHTm3+iov+9mJImqoGcaBezJSi1RfNkMysGzZs3
   qGKZrnX6chui+o800iEmCkrOqv0vQ3YBjNN6mYHG7iah6ykxvy0ccR+HS
   g==;
X-CSE-ConnectionGUID: 2HfAP6I7R/+wpFuaOlDteg==
X-CSE-MsgGUID: p/FbjV7KR6C1j6XtXtWZlw==
X-IronPort-AV: E=McAfee;i="6700,10204,11123"; a="17644496"
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="17644496"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2024 20:00:26 -0700
X-CSE-ConnectionGUID: msur0iLoTqeARkg/MuKINw==
X-CSE-MsgGUID: lo+ytsjFTAm3QMI0YnZ/YA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="51353451"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.241.187]) ([10.124.241.187])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2024 20:00:23 -0700
Message-ID: <5c3c81dc-ec15-4f7a-9807-a308082c9fc8@linux.intel.com>
Date: Fri, 5 Jul 2024 11:00:20 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/9] x86/virt/tdx: Exclude memory region hole within CMR
 as TDMR's reserved area
To: "Huang, Kai" <kai.huang@intel.com>,
 "nik.borisov@suse.com" <nik.borisov@suse.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "Hansen, Dave" <dave.hansen@intel.com>, "bp@alien8.de" <bp@alien8.de>,
 "x86@kernel.org" <x86@kernel.org>,
 "peterz@infradead.org" <peterz@infradead.org>, "hpa@zytor.com"
 <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
 "Williams, Dan J" <dan.j.williams@intel.com>,
 "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "seanjc@google.com" <seanjc@google.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>
References: <cover.1718538552.git.kai.huang@intel.com>
 <cfbed1139887416b6fe0d130883dbe210e97d598.1718538552.git.kai.huang@intel.com>
 <7809a177-e170-46f5-b463-3713b79acf22@suse.com>
 <717ba4c65ba9f1243facfcced207404c910f2410.camel@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <717ba4c65ba9f1243facfcced207404c910f2410.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/19/2024 9:23 AM, Huang, Kai wrote:
[...]
>
>> furthermore the alignement checks
>> suggest it's actually some sanity checking function. Furthermore if we
>> have:"
>>
>> ORDINARY_CMR,EMPTY_CMR,ORDINARY_CMR
>>
>> (Is such a scenario even possible), in this case we'll ommit also the
>> last ordinary cmr region?
> It cannot happen.
>
> The fact is:
>
> 1) CMR base/size are 4KB aligned.  This is architectural behaviour.
> 2) TDX architecturally supports 32 CMRs maximumly;
Do you think it's worth a comment to the definition of TDX_MAX_CMRS that 
the number is architectural?

> 3) In practice, TDX can just report the 'NUM_CMRS' metadata field as 32,
> but there can be empty/null CMRs following valid CMRs.
> 4) A empty/null CMR between valid CMRs cannot happen.
>
>

