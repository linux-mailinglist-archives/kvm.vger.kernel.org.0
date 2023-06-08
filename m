Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91EFF7280F5
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 15:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236637AbjFHNPJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 09:15:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236592AbjFHNPH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 09:15:07 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3FE210C;
        Thu,  8 Jun 2023 06:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686230106; x=1717766106;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=a3E93K6hoxZKC9yt31Lu/vhy/OxQU5XWodnX5xa9HOg=;
  b=Nh5OdVb99IHtx0O9zRXmcmqclkfSIEIzvcf6c9ghy4Ac6v6zKwrEzvvC
   2++PlcF+L3Ssgn+N083wsfOCYRQSra2/3LBeZ3TMdSDVD9Ila7q08fmby
   33VvV7qgwo2TkIjII1BLyJBo0QGaUPVY3YatGSZdLZH0Tx76gcq3mPXAl
   m3JnbWEChiHbFgvYa1GjLfdxvBpPc/6HmgF2JWXzPQIwSAMCy+RyB7DgQ
   mdbTD3IXRxJRNYk9WyXz8dC67aQ1oN+Dwpbiu7lHCn31L8XbOdccJMndr
   uG/ylrMbq7iVMyj0PskDriBK0m/9JT9kT5LQ3QWetNBL1JBbHgbGtxFi1
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="337660734"
X-IronPort-AV: E=Sophos;i="6.00,226,1681196400"; 
   d="scan'208";a="337660734"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 06:11:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="854335641"
X-IronPort-AV: E=Sophos;i="6.00,226,1681196400"; 
   d="scan'208";a="854335641"
Received: from swalker-mobl1.amr.corp.intel.com (HELO [10.209.22.184]) ([10.209.22.184])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 06:11:18 -0700
Message-ID: <201af662-f700-9145-c113-563e378074ad@intel.com>
Date:   Thu, 8 Jun 2023 06:11:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v11 11/20] x86/virt/tdx: Fill out TDMRs to cover all TDX
 memory regions
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
 <927ec9871721d2a50f1aba7d1cf7c3be50e4f49b.1685887183.git.kai.huang@intel.com>
 <0600959d-9e10-fb1f-b3a9-862a51b9d8e1@intel.com>
 <ddbcadf36016bb60a695f54b28f5c9e9af53a07f.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <ddbcadf36016bb60a695f54b28f5c9e9af53a07f.camel@intel.com>
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

On 6/8/23 03:48, Huang, Kai wrote:
>> Let's also put a pr_warn() in here if we exceed, say 1/2 or maybe 3/4 of
>> the 64.  We'll hopefully start to get reports somewhat in advance if
>> systems get close to the limit.
> May I ask why this is useful?  TDX module can only be initialized once, so if
> not considering module runtime update case, the kernel can only get two results
> for once:
> 
> 1) Succeed to initialize: consumed TDMRs doesn't exceed maximum TDMRs
> 2) Fail to initialize: consumed TDMRs exceeds maximum TDMRs
> 
> What's the value of pr_warn() user when consumed TDMRs exceeds some threshold?

Today, we're saying, "64 TMDRs out to be enough for anybody!"

I'd actually kinda like to know if anybody starts building platforms
that get anywhere near using 64.  That way, we won't get a bug report
that TDX is broken and we'll have a fire drill.  We'll get a bug report
that TDX is complaining and we'll have some time to go fix it without
anyone actually being broken.

Maybe not even a pr_warn(), but something that's a bit ominous and has a
chance of getting users to act.
