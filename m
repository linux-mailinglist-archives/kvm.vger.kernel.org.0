Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3CA06633B8
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 23:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237573AbjAIWLX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 17:11:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237358AbjAIWLV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 17:11:21 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6703DFD32;
        Mon,  9 Jan 2023 14:11:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673302280; x=1704838280;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Ln9UmdvPEfCHFUK0OjSflAkT5ICnYz1pheD9irb6dlY=;
  b=R/pENgKetfJv/OnxB3SlOyKXWD5JfpCb4DPOdTOgwiuCv8P2d5uNUp0x
   mSRUamdT5HkqQ+TWNdxo6WuQA81ZTFfv+a05OsupGdQammfB8E2db0qwi
   ZGHLTroCKF9SXMNbglN/HTYbxfzYFC2Bc/DI9UXRIc1Z2VSFds13rN5C5
   7wMM+FxBy1zgSFuSpvaHhtAVq/lvNgTj0tB9asxs+EVuqbCJCq8sDhmvH
   HuNiox94Bvk5KlXSqyztDwew10YjF0hMB7mes6CQUS9aa7h79+y3/7FZx
   1m3gvRaVNEY9QpiybwS11eaMXbhZvcYn+ZqHYowcTZESuzQZ0OENLgQN+
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="409242544"
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="409242544"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 14:11:20 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="745528697"
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="745528697"
Received: from swapnadi-mobl2.amr.corp.intel.com (HELO [10.209.29.117]) ([10.209.29.117])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 14:11:18 -0800
Message-ID: <7086ac3c-5eee-18c4-8c19-ae75eaa2e01a@intel.com>
Date:   Mon, 9 Jan 2023 14:11:17 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v8 06/16] x86/virt/tdx: Get information about TDX module
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
 <7c21a3de810397901bade0b1021912bbbf2d18bd.1670566861.git.kai.huang@intel.com>
 <d1093b3e-cdab-b138-d488-19b9456be978@intel.com>
 <e605ce95f1b92fae630bf6abb801774bc28d8072.camel@intel.com>
 <bea7dbd0-f6ec-5103-9d00-9617154d6be9@intel.com>
 <95de773544dfe4e13c3599a5f83f6fcad3c00e11.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <95de773544dfe4e13c3599a5f83f6fcad3c00e11.camel@intel.com>
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

On 1/9/23 14:07, Huang, Kai wrote:
>>
>>       The 'tdsysinfo_struct' is fairly large (1k) and contains a lot
>>       of info about the TD.  Fully define the entire structure, but
>                           ^
>                 should be: "about the TDX module"?
> 

Yes, of course.  Thinko on my part.
