Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF1D26365FA
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 17:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238951AbiKWQl2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 11:41:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236447AbiKWQl0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 11:41:26 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 776CBBA5A3;
        Wed, 23 Nov 2022 08:41:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669221685; x=1700757685;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=blO4q9CHjwlTLq8BfvWLfz9x3xTEUCmlfYlE/Q+m6is=;
  b=MmfUQKvjHArSMCC8I9ZX4rquWSsSagcbDH+53ZvSa4aMNGNHKE0p0vBX
   AiJ9cDIRunTi769bMoiyNjSUBMqiHfFmuUhOfWhJhq8gLlTWfsxGQmxxE
   Vv1mSEv5YzfHCBmxue4Q9jIpwka3hlU9SuZZGuJ1WSRkDVQnuPJfgZBai
   bjwiQY6SAUzb+tHP2EFYi311HRUXNJ43/vSt+UWOlbnhrl3Cd6kk8q4DY
   DvabwLFFGoEpK/Odia92Hfw110ENATMuQ1tOS6tfIUTZEsEx9UkYDYPFN
   sm5F1I/5IgBDLmcyFxI6IeD2HthjXZHIPpEuondLlrYYZ81HROTW3im0f
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="315259518"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="315259518"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 08:41:25 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="816537366"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="816537366"
Received: from vcbudden-mobl3.amr.corp.intel.com (HELO [10.212.129.67]) ([10.212.129.67])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 08:41:24 -0800
Message-ID: <168ca2b3-ffac-31c4-0b83-2d0ee75f34a5@intel.com>
Date:   Wed, 23 Nov 2022 08:41:22 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 06/20] x86/virt/tdx: Shut down TDX module in case of
 error
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        "Huang, Kai" <kai.huang@intel.com>
Cc:     "peterz@infradead.org" <peterz@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
 <48505089b645019a734d85c2c29f3c8ae2dbd6bd.1668988357.git.kai.huang@intel.com>
 <Y3ySxEr64HkUaEDq@hirez.programming.kicks-ass.net>
 <52b2be9b-defd-63ce-4cb2-96cd624a95a6@intel.com>
 <Y30fUS5/JClpBHVc@hirez.programming.kicks-ass.net>
 <b3938f3a-e4f8-675a-0c0e-4b4618019145@intel.com>
 <da7ae78c2d9fed125f160744af5be75f34b1b1d7.camel@intel.com>
 <791bf9a2-a079-3cd6-90a3-42dbb332a38c@intel.com>
 <9f1ea2639839305dd8b82694b3d8c697803f43a1.camel@intel.com>
 <Y35IW/PnbxinKHOL@google.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <Y35IW/PnbxinKHOL@google.com>
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

On 11/23/22 08:20, Sean Christopherson wrote:
>>> Why is it done that way?
>>>
>>> Can it be changed to delay TDX initialization until the first TDX guest
>>> needs to run?
>>>
>> Sean suggested.
>>
>> Hi Sean, could you commenet?
> Waiting until the first TDX guest is created would result in false advertising,
> as KVM wouldn't know whether or not TDX is actually supported until that first
> VM is created.  If we can guarantee that TDH.SYS.INIT will fail if and only if
> there is a kernel bug, then I would be ok deferring the "enabling" until the
> first VM is created.

There's no way we can guarantee _that_.  For one, the PAMT* allocations
can always fail.  I guess we could ask sysadmins to fire up a guest to
"prime" things, but that seems a little silly.  Maybe that would work as
the initial implementation that we merge, but I suspect our users will
demand more determinism, maybe a boot or module parameter.

 * Physical Address Metadata Table, a large physically contiguous data
   structure, the rough equivalent of 'struct page' for the TDX module
