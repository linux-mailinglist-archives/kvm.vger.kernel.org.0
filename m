Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60A6C664694
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 17:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238716AbjAJQxK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 11:53:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238613AbjAJQxJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 11:53:09 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E4412A83;
        Tue, 10 Jan 2023 08:53:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673369588; x=1704905588;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rEES0+SUoHFkcH8Z6v8rAA+KM4jcHAZ+ixFgViD/AqE=;
  b=hXOV3BsWQVVT/yzudiqTqQQZnsWTR+Gf4fgjF8fITkbNv+IfteUKCkdC
   wE18GD78p+AVHK7s0XsBMyDUtm9BLQZ4nQZRPnmllc3AlecduG2Q1PH9Y
   WXIZlhdjtzfMFX9wAO6Z6J8sVsgQrZUu3wTJT4avTpAtikgnCkvbHAlk1
   nXgD4wZTAYM5yC3K7QfJUd81iS24sdS7yUwykrPartiJtOL1Ga70UzFmg
   mgKlAVWOIHvX5meBKcV9yqXjM710pbHmLnmsL8k1x9QhSFDVfVt1Pqz3Q
   bjq8GTerNKn+OU0fcA2ukfdHZVQ1mbmAGKNU+8YGhvXb8LDkUpiDLd57m
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="409434914"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="409434914"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 08:53:07 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="831061276"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="831061276"
Received: from svenka7-mobl1.amr.corp.intel.com (HELO [10.209.63.27]) ([10.209.63.27])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 08:53:07 -0800
Message-ID: <0f8acf9b-42a4-c079-7985-c5db4919c310@intel.com>
Date:   Tue, 10 Jan 2023 08:53:06 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v8 13/16] x86/virt/tdx: Configure global KeyID on all
 packages
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
 <383a2fb52a36d1e772bc547c289c5aeb8ea5d9cb.1670566861.git.kai.huang@intel.com>
 <9dca3a1d-eace-07ed-4cd2-09621912314a@intel.com>
 <d5134f59dcffdf5842a811c89dc336486885ea0b.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <d5134f59dcffdf5842a811c89dc336486885ea0b.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/10/23 02:15, Huang, Kai wrote:
> On Fri, 2023-01-06 at 14:49 -0800, Dave Hansen wrote:
>> On 12/8/22 22:52, Kai Huang wrote:
...
>>> + * Note:
>>> + *
>>> + * This function neither checks whether there's at least one online cpu
>>> + * for each package, nor explicitly prevents any cpu from going offline.
>>> + * If any package doesn't have any online cpu then the SEAMCALL won't be
>>> + * done on that package and the later step of TDX module initialization
>>> + * will fail.  The caller needs to guarantee this.
>>> + */
>>
>> *Does* the caller guarantee it?
>>
>> You're basically saying, "this code needs $FOO to work", but you're not
>> saying who *provides* $FOO.
> 
> In short, KVM can do something to guarantee but won't 100% guarantee this.
> 
> Specifically, KVM won't actively try to bring up cpu to guarantee this if
> there's any package has no online cpu at all (see the first lore link below).
> But KVM can _check_ whether this condition has been met before calling
> tdx_init() and speak out if not.  At the meantime, if the condition is met,
> refuse to offline the last cpu for each package (or any cpu) during module
> initialization.
> 
> And KVM needs similar handling anyway.  The reason is not only configuring the
> global KeyID has such requirement, creating/destroying TD (which involves
> programming/reclaiming one TDX KeyID) also require at least one online cpu for
> each package.
> 
> There were discussions around this on KVM how to handle.  IIUC the solution is
> KVM will:
> 1) fail to create TD if any package has no online cpu.
> 2) refuse to offline the last cpu for each package when there's any _active_ TDX
> guest running.
> 
> https://lore.kernel.org/lkml/20221102231911.3107438-1-seanjc@google.com/T/#m1ff338686cfcb7ba691cd969acc17b32ff194073
> https://lore.kernel.org/lkml/de6b69781a6ba1fe65535f48db2677eef3ec6a83.1667110240.git.isaku.yamahata@intel.com/
> 
> Thus TDX module initialization in KVM can be handled in similar way.
> 
> Btw, in v7 (which has per-lp init requirement on all cpus), tdx_init() does
> early check on whether all machine boot-time present cpu are online and simply
> returns error if condition is not met.  Here the difference is we don't have any
> check but depend on SEAMCALL to fail.  To me there's no fundamental difference.

So, I'm going to call shenanigans here.

You say:

	The caller needs to guarantee this.

Then, you go and tell us how the *ONE* caller of this function doesn't
actually guarantee this.  Plus, you *KNOW* this.

Those are shenanigans.

Let's do something like this instead of asking for something impossible
and pretending that the callers are going to provide some fantasy solution.

/*
 * Attempt to configure the global KeyID on all physical packages.
 *
 * This requires running code on at least one CPU in each package.  If a
 * package has no online CPUs, that code will not run and TDX module
 * initialization (TDH.whatever) will fail.
 *
 * This code takes no affirmative steps to online CPUs.  Callers (aka.
 * KVM) can ensure success by ensuring sufficient CPUs are online for
 * this to succeed.
 */

Now, since this _is_ all imperfect, what will our users see if this
house of cards falls down?  Will they get a nice error message like:

     TDX: failed to configure module, no online CPUs in package 12

Or, will they see:

     TDX: Hurr, durr, I'm confused and you should be too

?
