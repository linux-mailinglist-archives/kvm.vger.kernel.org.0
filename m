Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2ED766604C
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 17:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239235AbjAKQWy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 11:22:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238924AbjAKQW0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 11:22:26 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FBF136306;
        Wed, 11 Jan 2023 08:19:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673453973; x=1704989973;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iulAX5B5LcGBjvNPrRdZ2p5me0aPi4T1H+C2nWRMmDo=;
  b=UtJirCrWzoDD8upG00sl3ZEQWPfaV4p/qoxR4LdTZ0On+3Ma9+D/1q/W
   p0lWTyHlV+SKGDS1NpJC84vAFVrFg3hRX97x3tTa2CdTyjTb7zlOpYNtM
   jhem0DmKrCsYiucLZl4QJdJKIxWB2fJmGmloNw9FyvAMXuincwfgyRXQp
   WetH8+5JnEibTIZx6pG/qO6/V9/IpUeNeF0ZfmLgVFoZDq/jhtzFeFq6Z
   9LJ9LCGVlAFvU8kX5Fi957aKspFtSpQ61cWtSgjl1JWSB+FMqdzgAy4Rv
   wyp7podf9S98E92a5T1yPm4JdpeMFiBv6ftRXLeZhIY5pk2CwZPPLX44O
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="311272188"
X-IronPort-AV: E=Sophos;i="5.96,317,1665471600"; 
   d="scan'208";a="311272188"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2023 08:16:38 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="765202756"
X-IronPort-AV: E=Sophos;i="5.96,317,1665471600"; 
   d="scan'208";a="765202756"
Received: from pchoi7-mobl1.amr.corp.intel.com (HELO [10.212.194.225]) ([10.212.194.225])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2023 08:16:36 -0800
Message-ID: <0293d72e-e03f-03d7-5982-29b4f11006a9@intel.com>
Date:   Wed, 11 Jan 2023 08:16:36 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v8 11/16] x86/virt/tdx: Designate reserved areas for all
 TDMRs
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
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
 <27dcd2781a450b3f77a2aec833de6a3669bc0fb8.1670566861.git.kai.huang@intel.com>
 <2d7d2824-7aa7-5f96-d79b-b44ff7fe2ef9@intel.com>
 <b971cd8b4e6ce9e96c6b4c6192adb74cc6722d54.camel@intel.com>
 <778a6c80-a955-620d-a82a-c2ca82f26363@intel.com>
 <24ea02aa4db7d470adeb7a64b7692d8bd5a428ca.camel@intel.com>
 <3bfe283e-6a90-54cb-1ba2-45ce6d022206@intel.com>
 <a7f8c807df3bbe1923f21e30817b23e785776260.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <a7f8c807df3bbe1923f21e30817b23e785776260.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/11/23 02:57, Huang, Kai wrote:
> On Tue, 2023-01-10 at 07:19 -0800, Dave Hansen wrote:
>> On 1/10/23 03:01, Huang, Kai wrote:
>>> On Mon, 2023-01-09 at 17:22 -0800, Dave Hansen wrote:
>>>> On 1/9/23 17:19, Huang, Kai wrote:
>>>>>> It's probably also worth noting *somewhere* that there's a balance to be
>>>>>> had between TDMRs and reserved areas.  A system that is running out of
>>>>>> reserved areas in a TDMR could split a TDMR to get more reserved areas.
>>>>>> A system that has run out of TDMRs could relatively easily coalesce two
>>>>>> adjacent TDMRs (before the PAMTs are allocated) and use a reserved area
>>>>>> if there was a gap between them.
>>>>> We can add above to the changelog of this patch, or the patch 09 ("x86/virt/tdx:
>>>>> Fill out TDMRs to cover all TDX memory regions").  The latter perhaps is better
>>>>> since that patch is the first place where the balance of TDMRs and reserved
>>>>> areas is related.
>>>>>
>>>>> What is your suggestion?
>>>> Just put it close to the code that actually hits the problem so the
>>>> potential solution is close at hand to whoever hits the problem.
>>>>
>>> Sorry to double check: the code which hits the problem is the 'if (idx >=
>>> max_reserved_per_tdmr)' check in tdmr_add_rsvd_area(), so I think I can add
>>> right before this check?
>>
>> Please just hack together how you think it should look and either reply
>> with an updated patch, or paste the relevant code snippet in your reply.
>>  That'll keep me from having to go chase this code back down.
>>
> 
> Thanks for the tip.  How about below?
> 
> static int tdmr_add_rsvd_area(struct tdmr_info *tdmr, int *p_idx, u64 addr,
>                               u64 size, u16 max_reserved_per_tdmr)
> {
>         struct tdmr_reserved_area *rsvd_areas = tdmr->reserved_areas;
>         int idx = *p_idx;
> 
>         /* Reserved area must be 4K aligned in offset and size */
>         if (WARN_ON(addr & ~PAGE_MASK || size & ~PAGE_MASK))
>                 return -EINVAL;
> 
>         /*
>          * The TDX module supports only limited number of TDMRs and
>          * limited number of reserved areas for each TDMR.  There's a
>          * balance to be had between TDMRs a2nd reserved areas.  A system
>          * that is running out of reserved areas in a TDMR could split a
>          * TDMR to get more reserved areas.  A system that has run out
>          * of TDMRs could relatively easily coalesce two adjacent TDMRs
>          * (before the PAMTs are allocated) and use a reserved area if
>          * there was a gap between them.
>          */
>         if (idx >= max_reserved_per_tdmr) {
>                 pr_warn("too many reserved areas for TDMR [0x%llx, 0x%llx)\n",
>                                 tdmr->base, tdmr_end(tdmr));
>                 return -ENOSPC;
>         }

This isn't really converging on a solution.  At this point, I just see
my verbatim text being copied and pasted into these functions without
really anything additional.

This comment, for instance, just blathers about what could be done but
doesn't actually explain what it is doing here.

But, again, this isn't converging.  It's just thrashing and not getting
any better.  I guess I'll just fix it up best I can when I apply it.
