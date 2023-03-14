Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E972C6B8AC7
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 06:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjCNFpt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 01:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCNFpr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 01:45:47 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6489C6507C;
        Mon, 13 Mar 2023 22:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678772746; x=1710308746;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=epevocZi6+E2W/gaN32HI3R84I7en7SETUEfrcRwoM4=;
  b=L56UdPYeyZEHfLOpoA4cIf+JjM2U1d/YsCIATO3RlG8O3ec1kSpuFPwt
   7GW+GmAfPgK+4gLk7CDKOcbGqeIoWK7ki0IHGfaP0cFrdBi5en8wWAVIz
   QBXqtrwTs3Ww6ZnafRpz6QJ4ei3aS1+zbXyve/GipYPhpUqPaDVouOzHA
   qcJe5z+W+ZoefRFACe5LcP/7+vKQbdT2FzqbDdjcS5LvBphnoUaPgBmRT
   t/A6MuuDvJ8FbzOVltbDaGFUTxyj28Vm2Uo/1H18PnFrWIoH4eAKRcCe6
   dz+vH/pi3MfDQhHsHSNcRU68MVgWpHssVUIP6mTjW57fVOYzSY8M8wtru
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="339703246"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="339703246"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 22:45:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="711382097"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="711382097"
Received: from rahulmur-mobl3.amr.corp.intel.com (HELO [10.212.195.84]) ([10.212.195.84])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 22:45:45 -0700
Message-ID: <902b0166-6156-8def-a7a3-f0ce8995fa9c@intel.com>
Date:   Mon, 13 Mar 2023 22:45:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v10 05/16] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Content-Language: en-US
To:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
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
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230314040200.GD3922605@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/13/23 21:02, Isaku Yamahata wrote:
>> Then it is a hidden behaviour of the TDX module that is not reflected in the
>> spec.  I am not sure whether we should handle because: 
>>
>> 1) This is an extremely rare case.  Kernel would be basically under attack if
>> such error happened.  In the current series we don't handle such case in
>> KEY.CONFIG either but just leave a comment (see patch 13).
>>
>> 2) Not sure whether this will be changed in the future.
>>
>> So I think we should keep as is.
> TDX 1.5 spec introduced TDX_RND_NO_ENTROPY status code.  For TDX 1.0, let's
> postpone it to TDX 1.5 activity.

What the heck does this mean?

I don't remember seeing any code here that checks for "TDX 1.0" or "TDX
1.5".  That means that this code needs to work with _any_ TDX version.

Are features being added to new versions that break code written for old
versions?
