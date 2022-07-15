Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D07B57640A
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 17:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232477AbiGOPE5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 11:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232296AbiGOPEx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 11:04:53 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43AC522289;
        Fri, 15 Jul 2022 08:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657897491; x=1689433491;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7CJJdeLyKxz97YNZKtxxG3SsfUPcSChfHIJSt0wgaIA=;
  b=nrbM7SI+LcecaoyYS1N2u3S7tlNUkQ/sbAIebJhU+wj+TedOWH/07IHh
   yZ3vFYETuvW/QnV0tu7rG0brMgSbBxdVOlyyEulh8d69ebxBavvhMsnhh
   i4eWc8CVUj/TkDILuSL7NBGkfAKSVce1G4LD58kEeXNq7vYVGorev+tap
   34o1jIvd6faLLQ/A5Z9tJbyVn6Zocfg0/D1LlKzOUePFe1XRg8tM5HVSC
   tNCpcuhVygg78bbCs6OIyAaFiTMEKjt03uedVeZgycjVOn+CKfDEAvA/b
   M57fJMtMjlIiQgphsYcb6CC2RW2jlhxNY5pJcCngqMpJPDj2ol5sRXDz7
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="266227244"
X-IronPort-AV: E=Sophos;i="5.92,274,1650956400"; 
   d="scan'208";a="266227244"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 08:04:50 -0700
X-IronPort-AV: E=Sophos;i="5.92,274,1650956400"; 
   d="scan'208";a="623884439"
Received: from yangweij-mobl.ccr.corp.intel.com (HELO [10.249.173.193]) ([10.249.173.193])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 08:04:47 -0700
Message-ID: <950988cd-708c-af25-9d0e-47062aded504@intel.com>
Date:   Fri, 15 Jul 2022 23:04:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 00/19] Refresh queued CET virtualization series
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rick.p.edgecombe@intel.com
References: <20220616084643.19564-1-weijiang.yang@intel.com>
 <YqsB9upUystxvl+d@hirez.programming.kicks-ass.net>
 <62d4f7f0-e7b2-83ad-a2c7-a90153129da2@redhat.com>
 <Yqs7qjjbqxpw62B/@hirez.programming.kicks-ass.net>
 <8a38488d-fb6e-72f9-3529-b098a97d8c97@redhat.com>
 <2855f8a9-1f77-0265-f02c-b7d584bd8990@intel.com>
 <YtBwRIiZi262hHiE@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <YtBwRIiZi262hHiE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/15/2022 3:36 AM, Sean Christopherson wrote:
> On Sat, Jun 18, 2022, Yang, Weijiang wrote:
>> On 6/16/2022 11:28 PM, Paolo Bonzini wrote:
>>> If you build with !X86_KERNEL_IBT, KVM can still rely on the FPU state
>>> for U_CET state, and S_CET is saved/restored via the VMCS independent of
>>> X86_KERNEL_IBT.
>> A fundamental question is, should KVM always honor host CET enablement
>> before expose the feature to guest? i.e., check X86_KERNEL_IBT and
>> X86_SHADOW_STACK.
> If there is a legitimate use case to NOT require host enablement and it's 100%
> safe to do so (within requiring hacks to the core kernel), then there's no hard
> requirement that says KVM can't virtualize a feature that's not used by the host.

Yeah, CET definitely can be virtualized without considering host usages, 
but to make things

easier, still back on some kind of host side support, e.g., xsaves.

>
> It's definitely uncommon; unless I'm forgetting features, LA57 is the only feature
> that KVM fully virtualizes (as opposed to emulates in software) without requiring
> host enablement.  Ah, and good ol' MPX, which is probably the best prior are since
> it shares the same XSAVE+VMCS for user+supervisor state management.  So more than
> one, but still not very many.

Speaking of MPX, is it really active in recent kernel? I can find little 
piece of code at native side,

instead, more code in KVM.

>
> But, requiring host "support" is the de facto standard largely because features
> tend to fall into one of three categories:
>
>    1. The feature is always available, i.e. doesn't have a software enable/disable
>       flag.
>
>    2. The feature isn't explicitly disabled in cpufeatures / x86_capability even
>       if it's not used by the host.  E.g. MONITOR/MWAIT comes to mind where the
>       host can be configured to not use MWAIT for idle, but it's still reported
>       as supported (and for that case, KVM does have to explicitly guard against
>       X86_BUG_MONITOR).
>
>    3. Require some amount of host support, e.g. exposing XSAVE without the kernel
>       knowing how to save/restore all that state wouldn't end well.

CET may fall into one of the three or combination of them :-), depending 
on the complexity

of the implementation.

>
> In other words, virtualizing a feature if it's disabled in the host is allowed,
> but it's rare because there just aren't many features where doing so is possible
> _and_ necessary.

I'm thinking of tweaking the patches to construct a safe yet flexible 
solution based on

a bunch of MSRs/CPUIDs/VMCS fields/XSAVES elements + a few host side 
constraints.

Thanks for the enlightenment!


