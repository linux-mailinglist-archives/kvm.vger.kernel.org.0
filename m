Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06843632AE2
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 18:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbiKURYO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 12:24:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiKURYG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 12:24:06 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836ACD103;
        Mon, 21 Nov 2022 09:24:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669051445; x=1700587445;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Ui2/1nweO0WhZb/0PgpLblEbGS0RJrQ9SrFTuasbInA=;
  b=ZFeQqpR05jYZaftn6Iw3dLQdy85GGnmZhwDgUDc4m+WmXe2LpgY1NPOV
   RHWTsjfbECPDpqN/jF3pm1zadvDW8Ccau329DOHSsNJuxGz5i2Fj80xQ8
   z+gs9/7PRYS2MIB+Q/wJZ8+4lvCXTEJBdwI4Ub9wOqkelLWCP7EITUdPG
   ESBuBLGUidVF2/HuqiVA26LNZVRHVoFLiF9c0DUzifaqDj0n7VD8XYXGY
   Di5qmj0fFBqSALT0PNgZmoamtDfkHLZVEd+1agCBtnzpBDbbTNEENBYZC
   HCEO6SEPyDyvaD8aRNAKUlxqDdGG2DkSGLtAXdU9L7qLEm0l11MZopj2C
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="313643556"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="313643556"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 09:24:03 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="704637056"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="704637056"
Received: from dylanhol-mobl.amr.corp.intel.com (HELO [10.212.242.103]) ([10.212.242.103])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 09:24:00 -0800
Message-ID: <750471f7-4cd4-5ebb-2790-ab0e153f4337@linux.intel.com>
Date:   Mon, 21 Nov 2022 09:23:58 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.2
Subject: Re: [PATCH v7 01/20] x86/tdx: Define TDX supported page sizes as
 macros
To:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
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
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
 <d6c6e664c445e9ccf1528625f0e21bbb8471d35f.1668988357.git.kai.huang@intel.com>
 <2eedfcff-e8c1-79af-63f4-c852af7b7e77@linux.intel.com>
 <088c54c9eacefde34c905c813facfceeb4d13b0d.camel@intel.com>
Content-Language: en-US
From:   Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <088c54c9eacefde34c905c813facfceeb4d13b0d.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/21/22 1:15 AM, Huang, Kai wrote:
> On Sun, 2022-11-20 at 18:52 -0800, Sathyanarayanan Kuppuswamy wrote:
>>
>> On 11/20/22 4:26 PM, Kai Huang wrote:
>>> +/*
>>> + * TDX supported page sizes (4K/2M/1G).
>>> + *
>>> + * Those values are part of the TDX module ABI.  Do not change them.
>>
>> It would be better if you include specification version and section
>> title.
>>
> 
> Such as below?
> 
> "Those values are part of the TDX module ABI (section "Physical Page Size", TDX
> module 1.0 spec).  Do not change them."

Yes.

> 
> Btw, Dave mentioned we should not put the "section numbers" to the comment:
> 
> https://lore.kernel.org/lkml/2a1886e7-fa5d-99e2-b1da-55ed7c0d024b@intel.com/
> 
> I was trying to follow.

Yes. That's why suggested to put section title.

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
