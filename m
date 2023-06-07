Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4CA725310
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 06:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234120AbjFGEze (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 00:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232478AbjFGEzd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 00:55:33 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6B8E49;
        Tue,  6 Jun 2023 21:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686113732; x=1717649732;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mhccuDVE7SPuvKA7LXWdrtyc6wtaKFhxLy133B99hgc=;
  b=AxM4TpmnY9j7EfobSlEupMlxSsO2i3IeALg4g5fO/Lrj13aZ3CB+jFks
   CPQSU0DojhiPCx9mYmy0Xjcc3N/iXGvOxMp4EHw+6/x6MWsRIBnFe8+U2
   r+b26vbw0wJRK2SsxrGGwluukvrTbxItIZOhngQUtOYRKF0Nrywdsx3lU
   l2MpUEviSwvUoikCxcehrR8YZBQ5ZLS1+a2H6prj5rklc9Chmu86RrRja
   RRZU/4rVbX0mVrrgcWmpBceQBt+l0tlGYvmlSTD1g61Kk46hYorJJ9mjR
   nHcuqQNP+sKXOCEajhErUA7YPIYRSEynE2aMAhAoZqTtx7ZMSkIZjBXBh
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="337240723"
X-IronPort-AV: E=Sophos;i="6.00,222,1681196400"; 
   d="scan'208";a="337240723"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 21:55:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="833502919"
X-IronPort-AV: E=Sophos;i="6.00,222,1681196400"; 
   d="scan'208";a="833502919"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.9.17]) ([10.238.9.17])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 21:55:28 -0700
Message-ID: <4c8c0d6e-8bb4-495f-3f41-6dee8c358124@linux.intel.com>
Date:   Wed, 7 Jun 2023 12:55:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v9 2/6] KVM: x86: Virtualize CR4.LAM_SUP
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "David.Laight@ACULAB.COM" <David.Laight@ACULAB.COM>
References: <20230606091842.13123-1-binbin.wu@linux.intel.com>
 <20230606091842.13123-3-binbin.wu@linux.intel.com>
 <fbc522e315d261607869b1996adc05e3646e535e.camel@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <fbc522e315d261607869b1996adc05e3646e535e.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/7/2023 11:40 AM, Huang, Kai wrote:
> On Tue, 2023-06-06 at 17:18 +0800, Binbin Wu wrote:
>> Move CR4.LAM_SUP out of CR4_RESERVED_BITS and its reservation depends on vcpu
>> supporting LAM feature or not. Leave the bit intercepted to avoid vmread every
>> time when KVM fetches its value, with the expectation that guest won't toggle
>> the bit frequently.
> KVM only needs to do vmread once to cache guest's CR4, and presumable vmread is
> a lot cheaper than a VMEXIT.  So I don't see the value of intercepting it if
> there's no need to do.
Here is the discussion about the general rule of interception of CR4 bit.
Sean mentioned:  "As a base
rule, KVM intercepts CR4 bits unless there's a reason not to, e.g. if 
the CR4 bit
in question is written frequently by real guests and/or never consumed 
by KVM."
https://lore.kernel.org/all/Y7xA53sLxCwzfvgD@google.com/

And CR4.LAM_SUP value will be used to determin the LAM mode when apply 
LAM masking in instruction emulations / VMExit handlers,
and if the bit is passed-through, it will be a vmread in these pathes.

>
> But presumably I think we cannot allow guest to own this bit because KVM wants
> to return a valid CR4 if LAM isn't exposed to guest?  Otherwise guest can still
> set this bit even LAM isn't exposed to guest.
>
> Am I missing something?
Right, this is also a reason why the CR4.LAM_SUP bit should be intercepted.
Will update the justification.
I suppose this reason is enough for justification, will remove the 
performance part in changelog.

Thanks.
>
> If not, your justification of intercepting this bit isn't correct and needs
> update.
>

