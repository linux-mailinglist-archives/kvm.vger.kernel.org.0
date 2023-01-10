Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88374663666
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 01:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237550AbjAJAr4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 19:47:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235646AbjAJArw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 19:47:52 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9DB91903F;
        Mon,  9 Jan 2023 16:47:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673311671; x=1704847671;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kJrgFIiO0EJ7JBX4KpNKPUFXIMxxSwX89FkEpf5AOOc=;
  b=U1OiVHT90IM7+p7rMWHVtWKogsBDAtNufpF+eHkHD7Mp4/+K6hD6jgpM
   1M44XuA1KfFCxM0BfMrI1Eoex9upIPrT5Isk2uxJRZ+s0ttIUOyi1BBlG
   PHbcS+vDp36YHKp5aSXhIl5p+qvRX0zl/P6jFEm1CinqW0B1WzsABGEJZ
   JBPoluUKdc16reg4D1lE0huCt13sj1YegW9TT8H5o2gXpHiYG9Q1sFiQ/
   RcxFMIy43DjeH1E9th01Wf1tlMH0qBcB8kkEvRWoUg+fataIobdThFpga
   M3yu5PBgn8M05UB/UKxVedOFWT6+boWAsYI7Qj++AHBqv0unlIfEaS2pG
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="321722859"
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="321722859"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 16:47:51 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="656856149"
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="656856149"
Received: from swapnadi-mobl2.amr.corp.intel.com (HELO [10.209.29.117]) ([10.209.29.117])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 16:47:50 -0800
Message-ID: <92aba287-c839-8841-a9f7-28a2c0b3097a@intel.com>
Date:   Mon, 9 Jan 2023 16:47:50 -0800
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
 <ef6fe9247007ee8e15272de01ded1e0a9152be02.1670566861.git.kai.huang@intel.com>
 <c70c30fb-073f-4355-c6a6-052d013a99da@intel.com>
 <81b814f096513e69e3099ab2b54034deadf8d7fd.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <81b814f096513e69e3099ab2b54034deadf8d7fd.camel@intel.com>
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

On 1/9/23 16:40, Huang, Kai wrote:
> On Fri, 2023-01-06 at 11:24 -0800, Dave Hansen wrote:
...
>> Also, tdmr_sz and max_tdmrs can both be derived from 'sysinfo'.  Do they
>> really need to be stored here?
> 
> It's not mandatory to keep them here.  I did it mainly because I want to avoid
> passing 'sysinfo' as argument for almost all functions related to constructing
> TDMRs.

I don't think it hurts readability that much.  On the contrary, it makes
it more clear what data is needed for initialization.

>> If so, I think I'd probably do something
>> like this with the structure:
>>
>> struct tdmr_info_list {
>>       struct tdmr_info *tdmrs;
>>       int nr_consumed_tdmrs; // How many @tdmrs are in use
>>
>>       /* Metadata for freeing this structure: */
>>       int tdmr_sz;   // Size of one 'tdmr_info' (has a flex array)
>>       int max_tdmrs; // How many @tdmrs are allocated
>> };
>>
>> Modulo whataver folks are doing for comments these days.
> 
> Looks nice to me.  Will use.  A slight thing is 'tdmr_sz' is also used to get
> the TDMR at a given index, but not just freeing the structure.
> 
> Btw, is C++ style comment "//" OK in kernel code?

It's OK with me, but I don't think there's much consensus on it.
Probably best to stick with normal arch/x86 style for now.



