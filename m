Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F14CB6B9A57
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 16:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbjCNPvE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 11:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbjCNPvB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 11:51:01 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9CFA4B0E;
        Tue, 14 Mar 2023 08:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678809039; x=1710345039;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LODTs5J/Ldf21oLCNOWXgtPcYDGXjb8p8WX8cEw7TVc=;
  b=gbFLoTSC/nL2nulJEkDfyhjHWMUZCAAnin3qwoO3hiABApXwpmGzR4Gl
   HSGllqVcxiq2sxqVuPzg+9BfupR7pIiwhCccOvIro5puZrD5KK73GgRvd
   eSD0f1sKWeY+PbnYX69HdugrmT47Q6XNOE3nQ9A30XgLvoGHpJSpWQy/w
   UDlQftm2qfkbdh4kUlNrjWpUjSA0OdmCYPpL80kU8EjuIyizzhxYsfRiF
   jarBPAx2jXonzGDvLNIYh4qs5u+KDqRjt8XgBeJiCGBCJKRmhAtZzX8Yb
   91vLc8b1g91nlnkZwHn3SgJdi5Mmdyg+66+hpqjw4oSurkzZEmCPN8dkb
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="317857340"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="317857340"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 08:48:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="681470328"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="681470328"
Received: from jstavrid-mobl.amr.corp.intel.com (HELO [10.212.216.78]) ([10.212.216.78])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 08:48:39 -0700
Message-ID: <5c4a28c8-f17d-7395-cc63-3cbd9b31befb@intel.com>
Date:   Tue, 14 Mar 2023 08:48:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v10 05/16] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <cover.1678111292.git.kai.huang@intel.com>
 <f150316b975b5ca22c6c4016ffd90db79d657bbf.1678111292.git.kai.huang@intel.com>
 <20230308222738.GA3419702@ls.amr.corp.intel.com>
 <96b56c5b8a5876aaf6d5ccbb81bab334b10983eb.camel@intel.com>
 <20230313234916.GC3922605@ls.amr.corp.intel.com>
 <a62497059fc3f31706a532b822d6c966bd981468.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <a62497059fc3f31706a532b822d6c966bd981468.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/13/23 18:50, Huang, Kai wrote:
> On Mon, 2023-03-13 at 16:49 -0700, Isaku Yamahata wrote:
>> On Sun, Mar 12, 2023 at 11:08:44PM +0000,
>> "Huang, Kai" <kai.huang@intel.com> wrote:
>>
>>> On Wed, 2023-03-08 at 14:27 -0800, Isaku Yamahata wrote:
>>>>> +
>>>>> +static int try_init_module_global(void)
>>>>> +{
>>>>> +       int ret;
>>>>> +
>>>>> +       /*
>>>>> +        * The TDX module global initialization only needs to be done
>>>>> +        * once on any cpu.
>>>>> +        */
>>>>> +       spin_lock(&tdx_global_init_lock);
>>>>> +
>>>>> +       if (tdx_global_init_status & TDX_GLOBAL_INIT_DONE) {
>>>>> +               ret = tdx_global_init_status & TDX_GLOBAL_INIT_FAILED ?
>>>>> +                       -EINVAL : 0;
>>>>> +               goto out;
>>>>> +       }
>>>>> +
>>>>> +       /* All '0's are just unused parameters. */
>>>>> +       ret = seamcall(TDH_SYS_INIT, 0, 0, 0, 0, NULL, NULL);
>>>>> +
>>>>> +       tdx_global_init_status = TDX_GLOBAL_INIT_DONE;
>>>>> +       if (ret)
>>>>> +               tdx_global_init_status |= TDX_GLOBAL_INIT_FAILED;
>>>>
>>>> If entropy is lacking (rdrand failure), TDH_SYS_INIT can return TDX_SYS_BUSY.
>>>> In such case, we should allow the caller to retry or make this function retry
>>>> instead of marking error stickily.
>>>
>>> The spec says:
>>>
>>> TDX_SYS_BUSY        The operation was invoked when another TDX module
>>>             operation was in progress. The operation may be retried.
>>>
>>> So I don't see how entropy is lacking is related to this error.  Perhaps you
>>> were mixing up with KEY.CONFIG?
>>
>> TDH.SYS.INIT() initializes global canary value.  TDX module is compiled with
>> strong stack protector enabled by clang and canary value needs to be
>> initialized.  By default, the canary value is stored at
>> %fsbase:<STACK_CANARY_OFFSET 0x28>
>>
>> Although this is a job for libc or language runtime, TDX modules has to do it
>> itself because it's stand alone.
>>
>> From tdh_sys_init.c
>> _STATIC_INLINE_ api_error_type tdx_init_stack_canary(void)
>> {
>>     ia32_rflags_t rflags = {.raw = 0};
>>     uint64_t canary;
>>     if (!ia32_rdrand(&rflags, &canary))
>>     {
>>         return TDX_SYS_BUSY;
>>     }
>> ...
>>     last_page_ptr->stack_canary.canary = canary;
>>
>>
> 
> Then it is a hidden behaviour of the TDX module that is not reflected in the
> spec.

This is true.  Could you please go ask the TDX module folks to fix this up?

> I am not sure whether we should handle because:
> 
> 1) This is an extremely rare case.  Kernel would be basically under attack if
> such error happened.  In the current series we don't handle such case in
> KEY.CONFIG either but just leave a comment (see patch 13).

Rare, yes.  Under attack?  I'm not sure where you get that from.  Look
at the SDM:

> Under heavy load, with multiple cores executing RDRAND in parallel, it is possible, though unlikely, for the demand
> of random numbers by software processes/threads to exceed the rate at which the random number generator
> hardware can supply them. This will lead to the RDRAND instruction returning no data transitorily. The RDRAND
> instruction indicates the occurrence of this rare situation by clearing the CF flag.

That doesn't talk about attacks.

> 2) Not sure whether this will be changed in the future.
> 
> So I think we should keep as is.

TDX_SYS_BUSY really is missing some nuance.  You *REALLY* want to retry
RDRAND failures.  But, if you have VMM locking and don't expect two
users calling into the TDX module then TDX_SYS_BUSY from a busy *module*
is a bad (and probably fatal) signal.

I suspect we should just throw a few retries in the seamcall()
infrastructure to retry in the case of TDX_SYS_BUSY.  It'll take care of
RDRAND failures.  If a retry loop fails to resolve it, then we should
probably dump a warning and return an error.

Just do this once, in common code.
