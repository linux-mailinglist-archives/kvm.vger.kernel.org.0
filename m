Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C85D66446C
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 16:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238202AbjAJPTw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 10:19:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238428AbjAJPTs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 10:19:48 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433585BA34;
        Tue, 10 Jan 2023 07:19:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673363988; x=1704899988;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=19LiZ+HqQL5Doh9UbMQEiLpyHqyJB3yalB7IXIegZGI=;
  b=gjX7z5yBGt34xq4qz63go6fFcIC9psG+T/ZWHTieHmV7wu3qS4LmbYf2
   pzoLb1+TazcwoprG4zrNMSxzQjBNzuzmb1/X8TrMojUfA6sT6o/Yy2Ucn
   6dpGM+36Un1qiDgPqF/RtSXwU5aSHH2/Kc3tITomvfGBEqqw7aIiuauXk
   hPd0+22l9a+FMQt91o5lr6hA08hPHmvNFSueWStEKF0dXBzWPKQO4sK96
   683RX7V5/kXqXPTYUCFz2J4Q8QUs8IoKjVX/dmf6gRIQmfdKBh9OGEZGc
   rJiuEvYUyxFUQq4zCJzr8zPDpoSlXk525l7U0dlum9qEbdMKfEpTKP8Ib
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="310969213"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="310969213"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 07:19:47 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="657088890"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="657088890"
Received: from svenka7-mobl1.amr.corp.intel.com (HELO [10.209.63.27]) ([10.209.63.27])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 07:19:47 -0800
Message-ID: <3bfe283e-6a90-54cb-1ba2-45ce6d022206@intel.com>
Date:   Tue, 10 Jan 2023 07:19:46 -0800
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
 <27dcd2781a450b3f77a2aec833de6a3669bc0fb8.1670566861.git.kai.huang@intel.com>
 <2d7d2824-7aa7-5f96-d79b-b44ff7fe2ef9@intel.com>
 <b971cd8b4e6ce9e96c6b4c6192adb74cc6722d54.camel@intel.com>
 <778a6c80-a955-620d-a82a-c2ca82f26363@intel.com>
 <24ea02aa4db7d470adeb7a64b7692d8bd5a428ca.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <24ea02aa4db7d470adeb7a64b7692d8bd5a428ca.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/10/23 03:01, Huang, Kai wrote:
> On Mon, 2023-01-09 at 17:22 -0800, Dave Hansen wrote:
>> On 1/9/23 17:19, Huang, Kai wrote:
>>>> It's probably also worth noting *somewhere* that there's a balance to be
>>>> had between TDMRs and reserved areas.  A system that is running out of
>>>> reserved areas in a TDMR could split a TDMR to get more reserved areas.
>>>> A system that has run out of TDMRs could relatively easily coalesce two
>>>> adjacent TDMRs (before the PAMTs are allocated) and use a reserved area
>>>> if there was a gap between them.
>>> We can add above to the changelog of this patch, or the patch 09 ("x86/virt/tdx:
>>> Fill out TDMRs to cover all TDX memory regions").  The latter perhaps is better
>>> since that patch is the first place where the balance of TDMRs and reserved
>>> areas is related.
>>>
>>> What is your suggestion?
>> Just put it close to the code that actually hits the problem so the
>> potential solution is close at hand to whoever hits the problem.
>>
> Sorry to double check: the code which hits the problem is the 'if (idx >=
> max_reserved_per_tdmr)' check in tdmr_add_rsvd_area(), so I think I can add
> right before this check?

Please just hack together how you think it should look and either reply
with an updated patch, or paste the relevant code snippet in your reply.
 That'll keep me from having to go chase this code back down.

