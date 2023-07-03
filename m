Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC26746257
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 20:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbjGCS0s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 14:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjGCS0q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 14:26:46 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04947D7;
        Mon,  3 Jul 2023 11:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688408806; x=1719944806;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=loPr+dzJ18Fhw1+ezR3lKISk94Z2wAYPGf8y4ACIrKE=;
  b=kWtc2nsl+9L+/nOEZXpTFwYRvliVyo3wZ46DdDLeLmwlVNvZbZBwFIpt
   +dr3BbEDZYiH4VUfhMCuou6XCCqQL1si5//5u9M/4gbu65ijc6QMtPp7d
   OCSpRvZNbnZrtB0oBDMDOk2io65OFHeR38TcbdC/+e4IuQsgk17H8V+wH
   7Gq7/AXflJHC/q0n1aZDCu2TLo709g1yXRNFKo8TSsFWn0TLQ/4/zInRD
   JbZCyyfgLQn8QAKhQfXc6ad3ERN37FdeEjEIXtVb1AUco9DrPRv3kQWGY
   pEkRHfAy6/ILF81TuK9D9azvplAWM186+LBNbEdyfPu7G5GrLlT5ed85B
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10760"; a="428985376"
X-IronPort-AV: E=Sophos;i="6.01,178,1684825200"; 
   d="scan'208";a="428985376"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2023 11:26:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10760"; a="712635074"
X-IronPort-AV: E=Sophos;i="6.01,178,1684825200"; 
   d="scan'208";a="712635074"
Received: from lbates-mobl.amr.corp.intel.com (HELO [10.212.242.115]) ([10.212.242.115])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2023 11:26:44 -0700
Message-ID: <f29fb57f-f59f-9101-74b6-e48e738963c5@intel.com>
Date:   Mon, 3 Jul 2023 11:26:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Content-Language: en-US
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Ashok Raj <ashok.raj@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Rafael J Wysocki <rafael.j.wysocki@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>, Sagi Shahar <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, Chao Gao <chao.gao@intel.com>,
        Len Brown <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Ying Huang <ying.huang@intel.com>,
        Dan J Williams <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
References: <20230628131717.GE2438817@hirez.programming.kicks-ass.net>
 <0c9639db604a0670eeae5343d456e43d06b35d39.camel@intel.com>
 <20230630092615.GD2533791@hirez.programming.kicks-ass.net>
 <2659d6eef84f008635ba300f4712501ac88cef2c.camel@intel.com>
 <20230630183020.GA4253@hirez.programming.kicks-ass.net>
 <20230630190514.GH3436214@ls.amr.corp.intel.com>
 <ZJ9IKALhz1Q6ogu1@google.com>
 <20230703104942.GG4253@hirez.programming.kicks-ass.net>
 <eb83e722-0379-1451-9c9c-9b9de33cb4cb@intel.com>
 <20230703150330.GA83892@hirez.programming.kicks-ass.net>
 <20230703175556.nn5xozz7dzxjocqm@box.shutemov.name>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230703175556.nn5xozz7dzxjocqm@box.shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/3/23 10:55, kirill.shutemov@linux.intel.com wrote:
>> I'm thikning we want something along the lines of the Xen preemptible
>> hypercalls, except less crazy. Where the caller does:
>>
>> 	for (;;) {
>> 		ret = tdcall(fn, args);
>> 		if (ret == -EAGAIN) {
>> 			cond_resched();
>> 			continue;
>> 		}
>> 		break;
>> 	}
>>
>> And then the TDX black box provides a guarantee that any one tdcall (or
>> seamcall or whatever) never takes more than X ns (possibly even
>> configurable) and we get to raise a bug report if we can prove it
>> actually takes longer.
> TDG.VP.VMCALL TDCALL can take arbitrary amount of time as it handles over
> control to the host/VMM.
> 
> But I'm not quite follow how it is different from the host stopping
> scheduling vCPU on a random instruction. It can happen at any point and
> TDCALL is not special from this PoV.

Well, for one, if the host stops the vCPU on a random instruction the
host has to restore all the vCPU state.  *ALL* of it.  That means that
after the host hands control back, the guest is perfectly ready to take
all the interrupts that are pending.

These TDCALLs are *VERY* different.  The guest gets control back and has
some amount of its state zapped, RBP being the most annoying current
example of state that is lost.  So the guest resumes control here and
must handle all of its interrupts with some of its state (and thus
ability to cleanly handle the interrupt) gone.

The instructions after state is lost are very much special.  Just look
at the syscall gap.
