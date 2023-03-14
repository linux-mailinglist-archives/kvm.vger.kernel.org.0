Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33B306B9D31
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 18:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbjCNRit (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 13:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjCNRis (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 13:38:48 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C87683C05;
        Tue, 14 Mar 2023 10:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678815526; x=1710351526;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VgVMyqR52hv/pd5q0qh+OTN2bW5UJL20CGoQOlOBteg=;
  b=kBbrr82Qu5e5RxNFdXQQW4nrhnG8kwmD0zRZ8spgT8F8ybHhmdfyzxoz
   NXhULyLw6eBsMlTm+f+L5+BZTyuN0TI7THSkz1Cwb1W1gBUqN61KjV9JD
   UqykbfVJsZJBaG2lvAv88UN6zA/RQ/dnuP3wCVhwkfiXnnCnH8g/NYQl4
   IX93Sj82GVBUqoZ/RDxF0UK4bZGWCzhHghC+VixUFBmJTYCqXQAy0uq/t
   JVwuQtUZ7VmX9uN9riEHJC9ml5CkjR508bxoStw6tDWAHXORms002NnFu
   pGSktr00x9f0tIstUW4zplt0BopjScQ0jMEAawzpqxMBN7eU1aCBghvJE
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="339862613"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="339862613"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 10:38:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="789458862"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="789458862"
Received: from jstavrid-mobl.amr.corp.intel.com (HELO [10.212.216.78]) ([10.212.216.78])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 10:38:33 -0700
Message-ID: <082f3086-b5e1-1842-6039-fb6710df6ca8@intel.com>
Date:   Tue, 14 Mar 2023 10:38:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v10 05/16] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Content-Language: en-US
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
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
 <20230314040200.GD3922605@ls.amr.corp.intel.com>
 <902b0166-6156-8def-a7a3-f0ce8995fa9c@intel.com>
 <20230314171603.GE3922605@ls.amr.corp.intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230314171603.GE3922605@ls.amr.corp.intel.com>
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

On 3/14/23 10:16, Isaku Yamahata wrote:
>>> TDX 1.5 spec introduced TDX_RND_NO_ENTROPY status code.  For TDX 1.0, let's
>>> postpone it to TDX 1.5 activity.
>> What the heck does this mean?
>>
>> I don't remember seeing any code here that checks for "TDX 1.0" or "TDX
>> 1.5".  That means that this code needs to work with _any_ TDX version.
>>
>> Are features being added to new versions that break code written for old
>> versions?
> No new feature, but new error code. TDX_RND_NO_ENTROPY, lack of entropy.
> For TDX 1.0, some APIs return TDX_SYS_BUSY. It can be contention(lock failure)
> or the lack of entropy.  The caller can't distinguish them.
> For TDX 1.5, they return TDX_RND_NO_ENTROPY instead of TDX_SYS_BUSY in the case
> of rdrand/rdseed failure.
> 
> Because both TDX_SYS_BUSY and TDX_RND_NO_ENTROPY are recoverable error
> (bit 63 error=1, bit 62 non_recoverable=0), the caller can check error bit and
> non_recoverable bit for retry.

Oh, that's actually really nice.  It separates out the "RDRAND is empty"
issue from the "the VMM should have had a lock here" issue.

For now, let's consider TDX_SYS_BUSY to basically indicate a non-fatal
kernel bug: the kernel called TDX in a way that it shouldn't have.
We'll treat it in the kernel as non-recoverable.  We'll return an error,
WARN_ON(), and keep on running.

A follow-on patch can add generic TDX_RND_NO_ENTROPY retry support to
the seamcall infrastructure.
