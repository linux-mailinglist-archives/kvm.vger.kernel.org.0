Return-Path: <kvm+bounces-48443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0723AACE47E
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 20:46:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 402C117767A
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 18:46:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 744091FF1C4;
	Wed,  4 Jun 2025 18:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X7+UYnXH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3697440C;
	Wed,  4 Jun 2025 18:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749062757; cv=none; b=ehQ5JfiYiDJFpLLAIwXorIFN6a+6+0yRtEZODQPDkCJE/bhigPGsRcQHd0DCuN70rdj3ntWeLbQowt+pzmBgIsIUuxXcjONz+QBaTDfg93D19ESS6AsybU+Gns9ByuD9j1mNRvxxrdTifXKzFeQF1P2gC+uMmTrGgXiACmL7bss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749062757; c=relaxed/simple;
	bh=gUiPdu88U079tUvhIDDSrfJd45DnCHI40z4srI8P3aI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZLNycnyKR5oP8/+7k6JdL2kk7SJmtIYE4wYtzC31OUYNkDJJHltv0IDs4JCeqQZvXlv9lIjEjOrzPYOHGe36SpMVpaTARqbSp1+TpN9Rg+5V5WDSAVcoxlDAcKEvySbQ9TGGC81lArvLHI+XNLdl+wzgyBCmdV9fRCIzYF8vJhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X7+UYnXH; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749062756; x=1780598756;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gUiPdu88U079tUvhIDDSrfJd45DnCHI40z4srI8P3aI=;
  b=X7+UYnXHlPslxKmtf0W97rAx+YMz9D50065sIoYPYE7G93G/STu2UWbF
   Gnxpt9BJSRrUJZvRPbODElIXEWVNJYMnjmyxgxl13qm8jkGGVz+OUU96j
   xpwz5ChaF+iBYh1Kzx+6wRMsvIXqR/zTgEazoUSWzp8+I+qFZfAPxoMvE
   SueMVKJ0jD5WHCxKnQS515ZeRVlTH3Us0mDxr7cW9fWNNzl3007G+m5YL
   rhNsYYX+v9+1BpJu44rQwE/YHVJm7oEKO2cqQ6Fd+7w/jVFCYm90uVtF1
   J0swReDrhHAZ6P4a8vN9ChRkXuVglIUagU6Rfo4nX7j60ozrkAv5y2JAH
   A==;
X-CSE-ConnectionGUID: pwmMWkRnRWGQNJsZqk6v6w==
X-CSE-MsgGUID: kGzXnxW7Q8eyudHiwD+EkQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11454"; a="51231841"
X-IronPort-AV: E=Sophos;i="6.16,209,1744095600"; 
   d="scan'208";a="51231841"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 11:45:55 -0700
X-CSE-ConnectionGUID: HCyK7ksfRburl64kIzc/0g==
X-CSE-MsgGUID: 7dFytqEuSEir+ISGjDlhcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,209,1744095600"; 
   d="scan'208";a="146209963"
Received: from puneetse-mobl.amr.corp.intel.com (HELO [10.125.110.229]) ([10.125.110.229])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 11:45:54 -0700
Message-ID: <a2639c00-ddbb-4e74-afd4-2ab74f6d3397@intel.com>
Date: Wed, 4 Jun 2025 11:45:53 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/6] Introduce CET supervisor state support
To: Chao Gao <chao.gao@intel.com>, x86@kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, tglx@linutronix.de,
 seanjc@google.com, pbonzini@redhat.com
Cc: peterz@infradead.org, rick.p.edgecombe@intel.com,
 weijiang.yang@intel.com, john.allen@amd.com, bp@alien8.de,
 chang.seok.bae@intel.com, xin3.li@intel.com,
 Dave Hansen <dave.hansen@linux.intel.com>, Eric Biggers
 <ebiggers@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Kees Cook <kees@kernel.org>,
 Maxim Levitsky <mlevitsk@redhat.com>, Mitchell Levy
 <levymitchell0@gmail.com>, Nikolay Borisov <nik.borisov@suse.com>,
 Oleg Nesterov <oleg@redhat.com>, Sohil Mehta <sohil.mehta@intel.com>,
 Stanislav Spassov <stanspas@amazon.de>,
 Vignesh Balasubramanian <vigbalas@amd.com>
References: <20250522151031.426788-1-chao.gao@intel.com>
 <aD+ZrBoJcrGRzjy0@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <aD+ZrBoJcrGRzjy0@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/3/25 17:56, Chao Gao wrote:
> On Thu, May 22, 2025 at 08:10:03AM -0700, Chao Gao wrote:
>> Dear maintainers and reviewers,
>>
>> I kindly request your consideration for merging this series. Most of
>> patches have received Reviewed-by/Acked-by tags.
> Looks like we now have AMD RB and the other issue (reported by Sean) was
> pre-existing. x86 maintainers, please consider applying.

Hi Chao,

You might want to take a look at this:

https://docs.kernel.org/process/maintainer-tip.html#merge-window

Specifically:

> Please do not expect patches to be reviewed or merged by tip
> maintainers around or during the merge window. The trees are closed
> to all but urgent fixes during this time. They reopen once the merge
> window closes and a new -rc1 kernel has been released.

In other words, your mail to ask us to consider applying is going to get
ignored for at least a week. Best case, it gets put on one of our lists
to go look at later.

My suggestion to you and all other submitters of non-critical fixes is
to spend the time between now and -rc1 reviewing *others* code and
making sure yours is 100% ready once -rc1 is released. The week after
the -rc1 release is a great time to send these emails, not now.

