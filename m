Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD0D77689B
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 21:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233815AbjHITXz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 15:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbjHITXk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 15:23:40 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5AD4201;
        Wed,  9 Aug 2023 12:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691608641; x=1723144641;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=JIrvQbWkCGHaD1FbqNpWcpoCsdM1hU8OGLnCu18TVvM=;
  b=QRCQTVHVS7vzeUTk5FMP/GK4Q9WgrRpDSToA/b0nNvCcM1eKzv/99glU
   mmeXCuitpkNSXb2rfa/SkkcuymukXBdJKFupkQwDyaWRPrqsI/BY1iMvM
   VdMYbpXUn+/cZDg9ETAzsgr+feehrW5fKP7ZxpziGfnRAiAunjrnlukAr
   6G5zfGwwG0F1YSeUvlYpwsqtIZyTc/krsbGLzG24rXSb6Yt1bWOFv5WRz
   saRlrgE+uIFn87jkK1KOn8yWm48+FQspqRqh08FOo95Mram9kKgEFStRZ
   Ue7YMCNvmXPtbxLMbo5TzlufaG5tPQ9N+6hmwFudp2m18nzjr84RGUX+X
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="402170570"
X-IronPort-AV: E=Sophos;i="6.01,160,1684825200"; 
   d="scan'208";a="402170570"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2023 12:16:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="708843770"
X-IronPort-AV: E=Sophos;i="6.01,160,1684825200"; 
   d="scan'208";a="708843770"
Received: from sakkired-mobl1.amr.corp.intel.com (HELO [10.212.9.77]) ([10.212.9.77])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2023 12:16:18 -0700
Message-ID: <d6df6a1b-e05c-39ef-3398-9450b9492841@linux.intel.com>
Date:   Wed, 9 Aug 2023 12:16:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     Arnd Bergmann <arnd@arndb.de>, Arnd Bergmann <arnd@kernel.org>,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Michal Luczaj <mhal@rbox.co>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20230809130530.1913368-1-arnd@kernel.org>
 <20230809130530.1913368-2-arnd@kernel.org>
 <f66ef6d0-18f7-ebef-0297-ad2f2d578aff@linux.intel.com>
 <c67fa35a-590f-404c-8104-5afbf14ad282@app.fastmail.com>
From:   Daniel Sneddon <daniel.sneddon@linux.intel.com>
Subject: Re: [PATCH 2/2] x86: move gds_ucode_mitigated() declaration to header
In-Reply-To: <c67fa35a-590f-404c-8104-5afbf14ad282@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,T_SPF_TEMPERROR,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/9/23 11:26, Arnd Bergmann wrote:
> On Wed, Aug 9, 2023, at 18:54, Daniel Sneddon wrote:
>> HI Arnd,
>>
>> On 8/9/23 06:05, Arnd Bergmann wrote:
>>> From: Arnd Bergmann <arnd@arndb.de>
>>>
>>> The declaration got placed in the .c file of the caller, but that
>>> causes a warning for the definition:
>>>
>>> arch/x86/kernel/cpu/bugs.c:682:6: error: no previous prototype for 'gds_ucode_mitigated' [-Werror=missing-prototypes]
>>
>> When I build with gcc 9.4 and the x86_64_defconfig I don't see this warning even
>> without this patch. I'm curious why you're seeing it and I'm not. Any ideas?
> 
> The warning is currently disabled by default, unless you build with
> 'make W=1'. I'm in the process of getting my last patches out to
> change this so the warning is enabled by default though, so I was
> phrasing this based on the future behavior. Sorry if this was confusing.
> 
>     Arnd

That explains why I wasn't seeing it.

Feel free to add:
Tested-by: Daniel Sneddon <daniel.sneddon@linux.intel.com>

Thanks,
Dan
