Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB8686636A7
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 02:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235239AbjAJBWS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 20:22:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235582AbjAJBWN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 20:22:13 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7902240C27;
        Mon,  9 Jan 2023 17:22:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673313730; x=1704849730;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4lDBthtxkF9BK72Tb/F4AAov7TFWGXDqWmGMUa8+rYs=;
  b=JsWcNHSYbs2ma1mrg78d3pWp3Le1Bg7307W0R6DZlmC5ZSANIlPgf1e7
   YvPZrVXTQeWHH7KTYngy8LWtVi6NG4XPtzslMrijBWChKfMCHCfkPxkDc
   r6kYs1lGWVchceJR4S3/rrEazGer8vmyqzEnhg/lScOvfBrrjCzoI3I35
   ZVSKOjaK+8ju1ZjkN0sEf799n2Om72hM2VKDtJA6S2fmFaTiEh8WaZKXV
   aHYMw5rkzJUlCjAZnFhc18ZsGXR7tiJCQzVNLA3wDeNazX1ICyydE/6iB
   oNTlY2X6G9YAdT+Ui44/RFBMeQHheOPzvUesHL/RVwVB2bVD/Htz587wW
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="303391988"
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="303391988"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 17:22:10 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="902198111"
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="902198111"
Received: from swapnadi-mobl2.amr.corp.intel.com (HELO [10.209.29.117]) ([10.209.29.117])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 17:22:08 -0800
Message-ID: <778a6c80-a955-620d-a82a-c2ca82f26363@intel.com>
Date:   Mon, 9 Jan 2023 17:22:08 -0800
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
 <27dcd2781a450b3f77a2aec833de6a3669bc0fb8.1670566861.git.kai.huang@intel.com>
 <2d7d2824-7aa7-5f96-d79b-b44ff7fe2ef9@intel.com>
 <b971cd8b4e6ce9e96c6b4c6192adb74cc6722d54.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <b971cd8b4e6ce9e96c6b4c6192adb74cc6722d54.camel@intel.com>
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

On 1/9/23 17:19, Huang, Kai wrote:
>> It's probably also worth noting *somewhere* that there's a balance to be
>> had between TDMRs and reserved areas.  A system that is running out of
>> reserved areas in a TDMR could split a TDMR to get more reserved areas.
>> A system that has run out of TDMRs could relatively easily coalesce two
>> adjacent TDMRs (before the PAMTs are allocated) and use a reserved area
>> if there was a gap between them.
> We can add above to the changelog of this patch, or the patch 09 ("x86/virt/tdx:
> Fill out TDMRs to cover all TDX memory regions").  The latter perhaps is better
> since that patch is the first place where the balance of TDMRs and reserved
> areas is related.
> 
> What is your suggestion?

Just put it close to the code that actually hits the problem so the
potential solution is close at hand to whoever hits the problem.

