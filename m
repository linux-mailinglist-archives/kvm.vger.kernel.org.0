Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46521776893
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 21:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233665AbjHITWb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 15:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233765AbjHITVu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 15:21:50 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F0B26BD;
        Wed,  9 Aug 2023 12:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691608892; x=1723144892;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=RPCvfRl23d2L1nYNQQH4NIOWqFFH/+dk6SzTlpFkZYM=;
  b=JhAe+vjch8HjQbYuJolHe2OOprb7k022fC4y6ktAHjElbz45tYF6/k0T
   V0jqT0KOBRXipYjSjnbqBoIXqK5JkaKmxXQuvtUsPHFeETwsBxR6y3HL3
   rjSndH4FTjPgiJNLvgEHvFYOb7tMH56iQLRNa+PfrZi1AhjS+weHNooaF
   yRi4c/rP0WH4aKKp4SbdJa4wZxiPqvvRN6aM43L87kjFmjEgOOVic0us/
   HSktOvuAXViHtffZ/eXH4+h21EmvJjpJ+F/JhOBHG6fpmP9CWxZH9wF0S
   EGbU1GD2VsaRXmLehK2tX0/cXZVHUtT6wTQGG0ECznFzL+AF3ufzgqdC7
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="350787522"
X-IronPort-AV: E=Sophos;i="6.01,160,1684825200"; 
   d="scan'208";a="350787522"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2023 12:20:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="821967486"
X-IronPort-AV: E=Sophos;i="6.01,160,1684825200"; 
   d="scan'208";a="821967486"
Received: from sakkired-mobl1.amr.corp.intel.com (HELO [10.212.9.77]) ([10.212.9.77])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2023 12:20:54 -0700
Message-ID: <44e18e24-c965-adbb-b18d-2507b6de45b3@linux.intel.com>
Date:   Wed, 9 Aug 2023 12:20:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 2/2] x86: move gds_ucode_mitigated() declaration to header
Content-Language: en-US
From:   Daniel Sneddon <daniel.sneddon@linux.intel.com>
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
 <d6df6a1b-e05c-39ef-3398-9450b9492841@linux.intel.com>
In-Reply-To: <d6df6a1b-e05c-39ef-3398-9450b9492841@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/9/23 12:16, Daniel Sneddon wrote:
> On 8/9/23 11:26, Arnd Bergmann wrote:
>> On Wed, Aug 9, 2023, at 18:54, Daniel Sneddon wrote:
>>> HI Arnd,
>>>
>>> On 8/9/23 06:05, Arnd Bergmann wrote:
>>>> From: Arnd Bergmann <arnd@arndb.de>
>>>>
>>>> The declaration got placed in the .c file of the caller, but that
>>>> causes a warning for the definition:
>>>>
>>>> arch/x86/kernel/cpu/bugs.c:682:6: error: no previous prototype for 'gds_ucode_mitigated' [-Werror=missing-prototypes]
>>>
>>> When I build with gcc 9.4 and the x86_64_defconfig I don't see this warning even
>>> without this patch. I'm curious why you're seeing it and I'm not. Any ideas?
>>
>> The warning is currently disabled by default, unless you build with
>> 'make W=1'. I'm in the process of getting my last patches out to
>> change this so the warning is enabled by default though, so I was
>> phrasing this based on the future behavior. Sorry if this was confusing.
>>
>>     Arnd
> 
> That explains why I wasn't seeing it.
> 
> Feel free to add:
> Tested-by: Daniel Sneddon <daniel.sneddon@linux.intel.com>
> 
> Thanks,
> Dan

To be clear, that applies to both patches in the series.

BR,
Dan

