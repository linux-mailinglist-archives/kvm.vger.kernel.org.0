Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD6D728297
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 16:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237028AbjFHOYW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 10:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236523AbjFHOYT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 10:24:19 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1279F198B;
        Thu,  8 Jun 2023 07:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686234259; x=1717770259;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SG3mTD2g3/LZaDpzuaBaKk2YaeV+yYIzM94X6+j2SrM=;
  b=jfhLkHcRAfFYwQH8f6I52LVSgEQkAsrlbl5yUn7SNIcVNwnUU7qsvnzS
   yZHWIQAXg2EIBAwXbnAaTt+riPAMhvykyEk6tVv/HCryvdfhJq3ALW+cJ
   uTjPKn9VptcJhWqoUqo2EEJXHB94FIf4wc2331iM27xmHc/Um8zMTUlql
   WWfLy30PdJFtHiC0Y9uBZvwIlICQqnLqHhbSOVQASJBOa8iFb9j1lu0b4
   EfmlzC9zoaAEflzo2p4jIHl02s26vQG+wwXF+Wd1JkMhjoczQMoL/WayZ
   g9uPPjXXkGyZB4Y509fDSYq/9lroYJ044owNR+IY+ekpTVjxlNtp6pmM6
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="423183128"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="423183128"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 07:05:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="709998313"
X-IronPort-AV: E=Sophos;i="6.00,226,1681196400"; 
   d="scan'208";a="709998313"
Received: from swalker-mobl1.amr.corp.intel.com (HELO [10.209.22.184]) ([10.209.22.184])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 07:05:49 -0700
Message-ID: <f51a1ea4-178c-1af7-99bc-865c12780e15@intel.com>
Date:   Thu, 8 Jun 2023 07:05:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v11 05/20] x86/virt/tdx: Add SEAMCALL infrastructure
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
 <ec640452a4385d61bec97f8b761ed1ff38898504.1685887183.git.kai.huang@intel.com>
 <92e19d74-447f-19e0-d9ec-8a3f12f04927@intel.com>
 <7fa434207dfbe2a88ac7f6f6830d2f8a0f31a253.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <7fa434207dfbe2a88ac7f6f6830d2f8a0f31a253.camel@intel.com>
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

On 6/7/23 15:56, Huang, Kai wrote:
> It's not just for the "BIOS buggy" case.  The main purpose is to give an error
> message when the caller mistakenly calls tdx_enable().

It's also OK to oops when there's a kernel bug, aka. caller mistake.

> Also, now the machine check handler improvement patch also calls SEAMCALL to get
> a given page's page type.  It's totally legal that a machine check happens when
> the CPU isn't in VMX operation (e.g. KVM isn't loaded), and in fact we use the
> SEAMCALL return value to detect whether CPU is in VMX operation and handles such
> case accordingly.

Listen, I didn't say there wasn't a reason for it.  I said that this
patch lacked the justification.  So, stop throwing things at the wall,
pick the *REAL* reason, and go rewrite the patch, please.
