Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE913640C1D
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 18:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233673AbiLBRZ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 12:25:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233609AbiLBRZ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 12:25:58 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F5310A1;
        Fri,  2 Dec 2022 09:25:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670001957; x=1701537957;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UAxenKvkDH4wwIwcRyi4RJ3isQRBDPM97pG5KlxBFRI=;
  b=BuqcTn23yL+2Nua+JdsV9MJnJWaDlZfl/+Yjy7YedpNFl3/ZHYEIWFJJ
   UOz2BZaz/PjOlZjiQpOik0qwobA7CHUzgOO1CGPrVstc33TruzZoxgBYn
   ZlZbE5AaWUXx4Y+T5yHf1w6stEGrKWekIta+IFm+YwbHxXud7QEmMj5v/
   B5EvOLSkyV0p1ROkRM7hXjxJp81S3uJ/6hshVQKNSg7wTdFOqyFmqBYuS
   J59CqPghzEdg97EKnwzUhbO/lUdJF46vAAVLAmZcXRQaQ5lZLHMmx1l7a
   zsh89pMN9Af6ueNzqpgMemdr+QQKwi38/YOWhAFeeNlcWljJa3RAuzihY
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="402282411"
X-IronPort-AV: E=Sophos;i="5.96,213,1665471600"; 
   d="scan'208";a="402282411"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2022 09:25:57 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="638813719"
X-IronPort-AV: E=Sophos;i="5.96,213,1665471600"; 
   d="scan'208";a="638813719"
Received: from rsnyder-mobl.amr.corp.intel.com (HELO [10.209.68.71]) ([10.209.68.71])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2022 09:25:56 -0800
Message-ID: <0decd051-a247-3f92-2df7-c7684ed18c75@intel.com>
Date:   Fri, 2 Dec 2022 09:25:56 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 09/20] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
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
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
 <cd23a9583edcfa85e11612d94ecfd2d5e862c1d5.1668988357.git.kai.huang@intel.com>
 <850e0899-d54e-6a49-851e-56f4d353905c@intel.com>
 <57af0b96f8a827828b1d64031774962972bfb060.camel@intel.com>
 <1c6580f7-3abb-03ba-dd98-367ddb9bf23b@intel.com>
 <a5e0f218e911a4ad207da55e21fdeb6d8035fed0.camel@intel.com>
 <7be59cd82bc3f3c26e835980eb74a8d92c6d67d6.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <7be59cd82bc3f3c26e835980eb74a8d92c6d67d6.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/2/22 03:19, Huang, Kai wrote:
> Probably I forgot to mention the "r9" in practice always returns 32, so there
> will be empty CMRs at the tail of the cmr_array[].

Right, so the r9 value is basically useless.  I bet the code gets
simpler if you just ignore it.

>> But we can also do nothing here, but just skip empty CMRs when comparing the
>> memory region to it (in next patch).
>>
>> Or, we don't even need to explicitly check memory region against CMRs. If the
>> memory regions that we provided in the TDMR doesn't fall into CMR, then
>> TDH.SYS.CONFIG will fail. We can just depend on the SEAMCALL to do that.
> 
> Sorry to ping, but do you have any comments here?
> 
> How about we just don't do any check of TDX memory regions against CMRs, but
> just let the TDH.SYS.CONFIG SEAMCALL to determine?

Right, if we screw it up TDH.SYS.CONFIG SEAMCALL will fail.  We don't
need to add more code to detect that failure ourselves.  TDX is screwed
either way.
