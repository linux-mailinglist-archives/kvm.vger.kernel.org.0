Return-Path: <kvm+bounces-21454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA3D992F1F9
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 00:32:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 83E992814CA
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 22:32:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 734F51A0719;
	Thu, 11 Jul 2024 22:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eQkGZH53"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13C815098E;
	Thu, 11 Jul 2024 22:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720737040; cv=none; b=JKa6sFzOok8ErQRLEgpGoLn/822c7vQgYQfJAsXTl3NGtPJnxXtV2LiIwxz2yKr1P+xwx9sSndmLULD3KU/IDMsioI7GL45sRUTmR7ltJwU1IwPgDZpkX+VnxmuTwWgWZilM2naHBYhiLzKa06i9v9fEVuFcBv2WE/587PmRCn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720737040; c=relaxed/simple;
	bh=pUc/vap2hH0RXSmRacWVhQXdqKkWXpFXzBZZAR7Rb+Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hTDq6gRNSorRiCiiIDI1FekqDwnk60ob1wCNEEp3K6eOtIdiIFeogsgOqF7UBpmsT1UWT6iQHSdQL2h/J4lDgNLfKfKmvwR0/s72g3qQXf01XN18JmpiyZbbjysgOVyYDQU4g773rGI55KAKkFBAX0Xg9FH39CP+8y2JTLbEfWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eQkGZH53; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720737039; x=1752273039;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=pUc/vap2hH0RXSmRacWVhQXdqKkWXpFXzBZZAR7Rb+Y=;
  b=eQkGZH53B6CtKPmYeXGs5XgaIILV//hxAryNsTIcdB37d+N0ExLTwBTg
   LQVPAx0urjhJc+3YYX3Zy7R1TKUGxTlTcWCW7gD77fdN3EFJqcUsozIzY
   pIrHwPCKg1SgndtuV4HEXcp/T8sY/6E+ltTIgwDVVhTLxLxomLR/Qugni
   n7mfZzNIahztfZt/NY9FFpOevVgYLLCe72hY7u+0KJLyOPJMbOJgaXAze
   FRa79fGB832+XpWvVZTXfoqm2hpDCpQegqaUuGie54AziXXhQbW3qTTiL
   oSE9HT/qqPAQuOYmW8SCkOYk7hkQ7WHrnk/SyAeYQG7Qx9ZNf3Z2/jnKv
   Q==;
X-CSE-ConnectionGUID: Ro5Hf7ZFRQKzctoUZtVgFw==
X-CSE-MsgGUID: +EjAXw1bQiS3ph8xPMW9IQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11130"; a="28830606"
X-IronPort-AV: E=Sophos;i="6.09,201,1716274800"; 
   d="scan'208";a="28830606"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2024 15:30:38 -0700
X-CSE-ConnectionGUID: GfOzNDmMSoGQDY6CfG5tlg==
X-CSE-MsgGUID: 3tsDK+TjTyW6sjrNIh/kuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,201,1716274800"; 
   d="scan'208";a="49129533"
Received: from unknown (HELO [10.124.221.144]) ([10.124.221.144])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2024 15:30:38 -0700
Message-ID: <4bba0c20-0cd0-4c1a-abf0-511ba6940a57@intel.com>
Date: Thu, 11 Jul 2024 15:30:35 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] Introduce CET supervisor state support
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "Yang, Weijiang" <weijiang.yang@intel.com>,
 "seanjc@google.com" <seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>
Cc: "john.allen@amd.com" <john.allen@amd.com>,
 "peterz@infradead.org" <peterz@infradead.org>, "Gao, Chao"
 <chao.gao@intel.com>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>
References: <20240531090331.13713-1-weijiang.yang@intel.com>
 <67c5a358-0e40-4b2f-b679-33dd0dfe73fb@intel.com>
 <1c2fd06e-2e97-4724-80ab-8695aa4334e7@intel.com>
 <7df3637c85517f5bc4e3583249f919c1b809f370.camel@intel.com>
Content-Language: en-US
From: Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <7df3637c85517f5bc4e3583249f919c1b809f370.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/11/24 15:11, Edgecombe, Rick P wrote:
> On Thu, 2024-07-11 at 13:58 -0700, Dave Hansen wrote:
>> So we're down to choosing between
>>
>>  * $BYTES space in 'struct fpu' (on hardware supporting CET-S)
>>
>> or
>>
>>  * ~100 loc
>>
>> $BYTES is 24, right?  Did I get anything wrong?
> 
> Do we know what the actual memory use is? It would increases the size asked of
> of the allocator by 24 bytes, but what amount of memory actually gets reserved?
> 
> It is sometimes a slab allocated buffer, and sometimes a vmalloc, right? I'm not
> sure about slab sizes, but for vmalloc if the increase doesn't cross a page
> size, it will be the same size allocation in reality. Or if it is close to a
> page size already, it might use a whole extra 4096 bytes.

Man, I hope I don't have this all mixed up in my head.  Wouldn't be the
first time.  I _think_ you might be confusing thread_info and
thread_struct, though.  I know I've gotten them confused before.

But we get to the 'struct fpu' via:

	current->thread.fpu

Where current is a 'task_struct' which is in /proc/slabinfo and 'struct
thread_struct thread' and 'struct fpu' are embedded in 'task_struct',
not allocated on their own:

	task_struct         2958   3018  10048  3 8 ...

So my current task_struct is 10048 bytes and 3 of them fit in each
8-page slab, leaving 2624 bytes to spare.

I don't think we're too dainty about adding thing to task_struct.  Are we?

> So we might be looking at a situation where some tasks get an entire extra page
> allocated per task, and some get no difference. And only the average is 24 bytes
> increase.

I think you're right here, at least when it comes to large weirdly-sized
slabs.  But _so_ many things affect task_struct that I've never seen
anyone sweat it too much.

