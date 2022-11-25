Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B42B663820F
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 02:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiKYBSQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 20:18:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiKYBSO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 20:18:14 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D7615A1E;
        Thu, 24 Nov 2022 17:18:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669339093; x=1700875093;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CoI48b71D2FMu4pWXHed6vmIDB7C2XvjCrv4WvChyA8=;
  b=cja0ixiGh6qSQ2pFSOTuJXqPWCVyYdX5fotMlqJa9bTl1UW5VhERa0KV
   p1Y3jhP+A7FC8WPJt7Zgj3BQD2I9jD4BP9AJ6DLyFKPa0TefMjQpNQF57
   SacoecZdUsD4rUrWh5iE16PCbWnM3G3qnaTfQ9uW2okLNwN1Qoe0BGdyJ
   ucleOcM7fZHkyiX1EPtW+aPiXx73CBenuU2M0UiXHEOCdJVcDA8j17OEv
   ZVxJXPIiF/sc1bZ7otWg56SWcQF2O6qsfeZGzjNXafY2rwH94Z5o1jqPN
   +Vgmg67PlGL62GpswSlNAPGVcn7EyWIxCXcbLooSgtzRXCSB8S3GFdoan
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="378646515"
X-IronPort-AV: E=Sophos;i="5.96,191,1665471600"; 
   d="scan'208";a="378646515"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 17:18:13 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="642544539"
X-IronPort-AV: E=Sophos;i="5.96,191,1665471600"; 
   d="scan'208";a="642544539"
Received: from stechane-mobl2.amr.corp.intel.com (HELO [10.212.146.33]) ([10.212.146.33])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 17:18:12 -0800
Message-ID: <89a746cc-8f60-8472-0d0b-71a459e2dd64@intel.com>
Date:   Thu, 24 Nov 2022 17:18:11 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 16/20] x86/virt/tdx: Configure TDX module with TDMRs
 and global KeyID
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
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
 <344234642a5eb9dc1aa34410f641f596ec428ea5.1668988357.git.kai.huang@intel.com>
 <301184ce-05e5-871c-7a6c-4298a0cbd1ae@intel.com>
 <cb83246f93281138f0e970bfccea4b13f2a64046.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <cb83246f93281138f0e970bfccea4b13f2a64046.camel@intel.com>
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

On 11/24/22 16:59, Huang, Kai wrote:
> On Wed, 2022-11-23 at 15:56 -0800, Dave Hansen wrote:
>> On 11/20/22 16:26, Kai Huang wrote:
>>> +   array_sz = ALIGN(tdmr_num * sizeof(u64), TDMR_INFO_PA_ARRAY_ALIGNMENT);
>>> +   tdmr_pa_array = kzalloc(array_sz, GFP_KERNEL);
>>
>> Just to be clear, all that chatter about alignment is because the
>> *START* of the array has to be aligned.  Right?
> 
> Correct.
> 
>> I see alignment for
>> 'array_sz', but that's not the start of the array.
>>
>> tdmr_pa_array is the start of the array.  Where is *THAT* aligned?
> 
> The alignment is assumed to be guaranteed based on the Documentation you quoted
> below.

I'm feeling kinda dense today, being Thanksgiving and all.  Could you
please walk me through, step-by-step how you get kzalloc() to give you
an allocation where the start address is 512-byte aligned?

...
> Perhaps I should just allocate one page so it must be 512-byte aligned?
> 
>         /*
>          * TDMR_INFO entries are configured to the TDX module  via an array
>          * of physical address of each TDMR_INFO.  The TDX module requires
>          * the array itself to be 512-byte aligned.  Just allocate a page
>          * to use it as the array so the alignment can be guaranteed.  The
>          * page will be freed after TDH.SYS.CONFIG anyway.
>          */

Kai, I just plain can't believe at this point that comments like this
are still being written.  I _thought_ I was very clear before that if
you have a constant, say:

#define FOO_ALIGN 512

and you want to align foo, you can just do:

	foo = ALIGN(foo, FOO_ALIGN);

You don't need to mention the 512-byte alignment again.  The #define is
good enough.


