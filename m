Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDB3728234
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 16:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236809AbjFHOGc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 10:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234375AbjFHOG3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 10:06:29 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B32702726;
        Thu,  8 Jun 2023 07:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686233188; x=1717769188;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=TmBDcLd5Xfp9VvdnTTxpDHAil2WXF25OsQyhgty2URs=;
  b=W8zaLGNrbX5K3lUAv0/7t79jQ6TQtpv7mwnyTyAekgWH97G7qT3nxVR0
   vURnS0O7XkvDAbESWuAU7wg/XQGKhSuOHl2K6UjRGxzHgZ3EDGM/iGy3n
   HENUbjI0SRfh2B3SdipAz/QwUeTSGGQsLZ5RBQrwMGcJfZ3Ap9tCLD9z0
   tQGQ30VwWLN6AJcV5x4u2yuHq3pXs5qLlUR7N5GOI02MSeLUYs/7MbRqG
   O0fsItPePMVkrjQsmHl1Eu6NzYo9UVhffIJTgCLFpGdyWMXu6JfpPdBo3
   iHYjgejl4bY9FisNUruvglDXxGO/Q3pZHPBpSUTQNbPA+CIFxbmJjp5zs
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="420887667"
X-IronPort-AV: E=Sophos;i="6.00,226,1681196400"; 
   d="scan'208";a="420887667"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 06:43:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="854354478"
X-IronPort-AV: E=Sophos;i="6.00,226,1681196400"; 
   d="scan'208";a="854354478"
Received: from swalker-mobl1.amr.corp.intel.com (HELO [10.209.22.184]) ([10.209.22.184])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 06:43:30 -0700
Message-ID: <d2b3bc5e-1371-0c50-8ecb-64fc70917d42@intel.com>
Date:   Thu, 8 Jun 2023 06:43:29 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v11 07/20] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
 <21b3a45cb73b4e1917c1eba75b7769781a15aa14.1685887183.git.kai.huang@intel.com>
 <e7c21694-d31b-4dbe-f75b-5a7c0127f5c8@intel.com>
 <963deb7f6bcadbf2848ef54540ba1758b43731d6.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <963deb7f6bcadbf2848ef54540ba1758b43731d6.camel@intel.com>
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

On 6/7/23 19:10, Huang, Kai wrote:
> On Wed, 2023-06-07 at 08:22 -0700, Dave Hansen wrote:
>> On 6/4/23 07:27, Kai Huang wrote:
>> ...
>>> +static int try_init_module_global(void)
>>> +{
>>> +   unsigned long flags;
>>> +   int ret;
>>> +
>>> +   /*
>>> +    * The TDX module global initialization only needs to be done
>>> +    * once on any cpu.
>>> +    */
>>> +   raw_spin_lock_irqsave(&tdx_global_init_lock, flags);
>>
>> Why is this "raw_"?
>>
>> There's zero mention of it anywhere.
> 
> Isaku pointed out the normal spinlock_t is converted to sleeping lock for
> PREEMPT_RT kernel.  KVM calls this with IRQ disabled, thus requires a non-
> sleeping lock.
> 
> How about adding below comment here?
> 
>         /*
>          * Normal spinlock_t is converted to sleeping lock in PREEMPT_RT
>          * kernel.  Use raw_spinlock_t instead so this function can be called
>          * even when IRQ is disabled in any kernel configuration.
>          */

Go look at *EVERY* *OTHER* raw_spinlock_t in the kernel.  Do any of them
say this?

Comment the function, say that it's always called with interrupts and
preempt disabled.  Leaves it at that.  *Maybe* add on that it needs raw
spinlocks because of it.  But don't (try to) explain the background of
the lock type.




>>> +int tdx_cpu_enable(void)
>>> +{
>>> +   unsigned int lp_status;
>>> +   int ret;
>>> +
>>> +   if (!platform_tdx_enabled())
>>> +           return -EINVAL;
>>> +
>>> +   lp_status = __this_cpu_read(tdx_lp_init_status);
>>> +
>>> +   /* Already done */
>>> +   if (lp_status & TDX_LP_INIT_DONE)
>>> +           return lp_status & TDX_LP_INIT_FAILED ? -EINVAL : 0;
>>> +
>>> +   /*
>>> +    * The TDX module global initialization is the very first step
>>> +    * to enable TDX.  Need to do it first (if hasn't been done)
>>> +    * before doing the per-cpu initialization.
>>> +    */
>>> +   ret = try_init_module_global();
>>> +
>>> +   /*
>>> +    * If the module global initialization failed, there's no point
>>> +    * to do the per-cpu initialization.  Just mark it as done but
>>> +    * failed.
>>> +    */
>>> +   if (ret)
>>> +           goto update_status;
>>> +
>>> +   /* All '0's are just unused parameters */
>>> +   ret = seamcall(TDH_SYS_LP_INIT, 0, 0, 0, 0, NULL, NULL);
>>> +
>>> +update_status:
>>> +   lp_status = TDX_LP_INIT_DONE;
>>> +   if (ret)
>>> +           lp_status |= TDX_LP_INIT_FAILED;
>>> +
>>> +   this_cpu_write(tdx_lp_init_status, lp_status);
>>> +
>>> +   return ret;
>>> +}
>>> +EXPORT_SYMBOL_GPL(tdx_cpu_enable);
>>
>> You danced around it in the changelog, but the reason for the exports is
>> not clear.
> 
> I'll add one sentence to the changelog to explain:
> 
>         Export both tdx_cpu_enable() and tdx_enable() as KVM will be the kernel
>         component to use TDX.

Intel doesn't pay me by the word.  Do you get paid that way?  If not,
please just say:

	Export both tdx_cpu_enable() and tdx_enable() for KVM use.
