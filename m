Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93E447A252E
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 19:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235549AbjIORuh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 13:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231822AbjIORuH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 13:50:07 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33CBA10C9;
        Fri, 15 Sep 2023 10:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694800202; x=1726336202;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=wizTBMvramdWYVRWKtAoXVDeMUGQ6tlGs6W4BGlccTQ=;
  b=l/Km/WquuA7y+0dEX10zEuXcFJ5wXxj9lD0efMBX4o4tFW8Az+KpR5Ap
   /HjLtrnlQDLkIroodgGnBguO/9kGfbTP25r2zB4eqf09ID2wRYoCw4T0f
   aaWMbRDer3sHu0MnA4GQpH68kfd4qMVjrmZ4T9IErAtKHIbA3UzKq9+ep
   z8cPRUUpWCXdbk5epPATMqi9nh2H3mIxzA4EfaCX87OGO0j8TUlJ+cNSj
   RPe1yktVJY9xNcWO0sC4A2S5fd9rJEBmis/2uw+yq81Ya0/TwZYQUxgZt
   6L6mcK5pnj0m/YTWgqpGSk64+iyteH8Yc+eds4jGzsyhNw6bPAVKHUKIW
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10834"; a="445780168"
X-IronPort-AV: E=Sophos;i="6.02,149,1688454000"; 
   d="scan'208";a="445780168"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2023 10:50:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10834"; a="721773898"
X-IronPort-AV: E=Sophos;i="6.02,149,1688454000"; 
   d="scan'208";a="721773898"
Received: from spswartz-mobl.amr.corp.intel.com (HELO [10.209.21.97]) ([10.209.21.97])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2023 10:50:00 -0700
Message-ID: <52e9ae7e-2e08-5341-99f7-b68eb62974df@intel.com>
Date:   Fri, 15 Sep 2023 10:50:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v13 17/22] x86/kexec: Flush cache of TDX private memory
To:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Kai" <kai.huang@intel.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
References: <cover.1692962263.git.kai.huang@intel.com>
 <1fa1eb80238dc19b4c732706b40604169316eb34.1692962263.git.kai.huang@intel.com>
 <fb70d8c29ebc91dc63e524a5d5cdf1f64cdbec73.camel@intel.com>
Content-Language: en-US
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <fb70d8c29ebc91dc63e524a5d5cdf1f64cdbec73.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/15/23 10:43, Edgecombe, Rick P wrote:
> On Sat, 2023-08-26 at 00:14 +1200, Kai Huang wrote:
>> There are two problems in terms of using kexec() to boot to a new 
>> kernel when the old kernel has enabled TDX: 1) Part of the memory
>> pages are still TDX private pages; 2) There might be dirty
>> cachelines associated with TDX private pages.
> Does TDX support hibernate?
No.

There's a whole bunch of volatile state that's generated inside the CPU
and never leaves the CPU, like the ephemeral key that protects TDX
module memory.

SGX, for instance, never even supported suspend, IIRC.  Enclaves just
die and have to be rebuilt.
