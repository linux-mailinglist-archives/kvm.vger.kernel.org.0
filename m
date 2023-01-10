Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91A47664C17
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 20:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239665AbjAJTMe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 14:12:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239820AbjAJTMZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 14:12:25 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 296364F103;
        Tue, 10 Jan 2023 11:12:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673377936; x=1704913936;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=idaSyTc/ks4CE89dkqypMQwFMcAUjyVafAw9EG5/p1Y=;
  b=SPHSRtPLj9bckQDAopi8zfmjK/c9fRfTq/9QBKhgv5Nj/8vEJJ3vOMA6
   Dtd/IbuMDHfo2avI92Vf0Dmdla/FrqeejBhTDr+7ByjzkrRWh3PfcmM6v
   0dA1eOf4utWkLgGd50JRMOiJUhkAJmDHbYvEoA0+Dk3f3NlPjxmP5njvf
   G9koVM5i9dUgPfGx+SfwwJRCg92lwXNNNZ7Rldu2jT4uXXE0EgKwJwAJa
   y1TkOP4IbVZOBGyhkKeKoh/lfz+rJoOxm+ZHjV79z2+P3IFzJ7Dqcwd43
   09in4hRLWEKwTMe11Jx2InohKllfz5Arj7Tn4+mvKA5D9awKkY+fKUP93
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="350458233"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="350458233"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 11:12:14 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="607086563"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="607086563"
Received: from svenka7-mobl1.amr.corp.intel.com (HELO [10.209.63.27]) ([10.209.63.27])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 11:12:13 -0800
Message-ID: <56cdb6e6-e25c-aba9-7bb3-323281e65249@intel.com>
Date:   Tue, 10 Jan 2023 11:12:13 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v8 08/16] x86/virt/tdx: Add placeholder to construct TDMRs
 to cover all TDX memory regions
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
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
 <ef6fe9247007ee8e15272de01ded1e0a9152be02.1670566861.git.kai.huang@intel.com>
 <c70c30fb-073f-4355-c6a6-052d013a99da@intel.com>
 <81b814f096513e69e3099ab2b54034deadf8d7fd.camel@intel.com>
 <92aba287-c839-8841-a9f7-28a2c0b3097a@intel.com>
 <cba4c7295b157dc5d0d88b73f335899f0aa5a21c.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <cba4c7295b157dc5d0d88b73f335899f0aa5a21c.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/9/23 18:23, Huang, Kai wrote:
> On Mon, 2023-01-09 at 16:47 -0800, Dave Hansen wrote:
>> On 1/9/23 16:40, Huang, Kai wrote:
>>> On Fri, 2023-01-06 at 11:24 -0800, Dave Hansen wrote:
>> ...
>>>> Also, tdmr_sz and max_tdmrs can both be derived from 'sysinfo'.  Do they
>>>> really need to be stored here?
>>>
>>> It's not mandatory to keep them here.  I did it mainly because I want to avoid
>>> passing 'sysinfo' as argument for almost all functions related to constructing
>>> TDMRs.
>>
>> I don't think it hurts readability that much.  On the contrary, it makes
>> it more clear what data is needed for initialization.
> 
> Sorry one thing I forgot to mention is if we keep 'tdmr_sz' in 'struct
> tdmr_info_list', it only needs to be calculated at once when allocating the
> buffer.  Otherwise, we need to calculate it based on sysinfo-
> max_reserved_per_tdmr each time we want to get a TDMR at a given index.

What's the problem with recalculating it?  It is calculated like this:

	tdmr_sz = ALIGN(constant1 + constant2 * variable);

So, what's the problem?  You're concerned about too many multiplications?

> To me putting relevant fields (tdmrs, tdmr_sz, max_tdmrs, nr_consumed_tdmrs)
> together makes how the TDMR list is organized more clear.  But please let me
> know if you prefer removing 'tdmr_sz' and 'max_tdmrs'.
> 
> Btw, if we remove 'tdmr_sz' and 'max_tdmrs', even nr_consumed_tdmrs is not
> absolutely necessary here.  It can be a local variable of init_tdx_module() (as
> shown in v7), and the 'struct tdmr_info_list' will only have the 'tdmrs' member
> (as you commented in v7):
> 
> https://lore.kernel.org/linux-mm/cc195eb6499cf021b4ce2e937200571915bfe66f.camel@intel.com/T/#mb9826e2bcf8bf6399c13cc5f95a948fe4b3a46d9
> 
> Please let me know what's your preference?

I dunno.  My gut says that passing sysinfo around and just deriving the
sizes values from that with helpers is the best way.  'struct
tdmr_info_list' isn't a horrible idea in and of itself, but I think it's
a confusing structure because it's not clear how the pieces fit together
when half of it is *required* and the other half is just for some kind
of perceived convenience.

