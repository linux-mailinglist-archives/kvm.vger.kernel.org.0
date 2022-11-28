Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6B4563AD1F
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 16:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbiK1P7H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 10:59:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbiK1P7F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 10:59:05 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A22FBD4;
        Mon, 28 Nov 2022 07:59:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669651145; x=1701187145;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3tU9/Uz/QDW6gglhWujOCtVfQoXZYicKEy0KruTmQC4=;
  b=gzQzd5E9Jw0ljae6qw2RYqT3OSS2EjDq+3is2gcTs3wMQ+rPAoPWCWi8
   l2r1aUdJpRuX74ybJLGQ38tVN+h/wnoEbIBsJn1ewLFHEGzUcy3RFid3v
   G3z8i803bqOcGrlBCeNM2HioIe5g9DkYkO2HUWhcTEkaCngZnS3jBBkoC
   cQEv3p+IP9hAmnM3SgX0ESrAhETBLBcCLImn7GOoOb393llAOOCn5fO5x
   rI+Nrl/VV4U6ObRj6Q9/s1Wxf9KKmhnNJqOIVeMnkYuIXDfGcWZnfEYNJ
   1FUPkPYTb5h+2sPJYNGJxyMTlcgoFnJsff9Uh6pTrz9PypnaEo5P43KHC
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="401159356"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="401159356"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 07:59:05 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="676088566"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="676088566"
Received: from nroy-mobl1.amr.corp.intel.com (HELO [10.212.209.4]) ([10.212.209.4])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 07:59:03 -0800
Message-ID: <9a653cd2-70df-8c55-ac7d-5ddcb3b18b0c@intel.com>
Date:   Mon, 28 Nov 2022 07:59:03 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 11/20] x86/virt/tdx: Add placeholder to construct TDMRs
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
 <32c1968fe34c8cf3cb834e3a9966cd2a201efc5b.1668988357.git.kai.huang@intel.com>
 <6d4d429a-ade2-771d-0e4c-788bef45041a@intel.com>
 <35aee96c1bb56322191ae442f3928d7dff064a92.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <35aee96c1bb56322191ae442f3928d7dff064a92.camel@intel.com>
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

On 11/24/22 04:02, Huang, Kai wrote:
> On Wed, 2022-11-23 at 14:17 -0800, Dave Hansen wrote:
>> First, I think 'tdx_sysinfo' should probably be a local variable in
>> init_tdx_module() and have its address passed in here.  Having global
>> variables always makes it more opaque about who is initializing it.
> Sorry I missed to respond this.
> 
> Using local variable for 'tdx_sysinfo' will cause a build warning:
> 
> https://lore.kernel.org/lkml/a6694c81b4e96a22557fd0af70a81bd2c2e4e3e7.camel@intel.com/

Having it be local scope is a lot more important than having it be on
stack.  Just declare it local to the function but keep it off the stack.
 No need to dynamically allocate it, even.
