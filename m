Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 618DB6C72CE
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 23:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbjCWWM3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 18:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbjCWWM1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 18:12:27 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BCCF233DA;
        Thu, 23 Mar 2023 15:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679609541; x=1711145541;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EnfZCJwEr26LuV84t2yJLMX9tU08wBX0EGiJmK5z7Uc=;
  b=Ra8yaGKyEd5PCEIdN/T9g864K96sBJFy9n800Y/uhI6Qv8hVZQq5dRz0
   6d30ktYdwGAdYPoGbBcn17M4yAtJQy0iIRZgCbzhwiL+vtKBTpXbZ7TsO
   x/BeG/PSvy+acbbxtGuBHWZgmC6kjbN5JuTOOukBUkAiqMAfaA4uk+c+t
   wXoSIVops39q4hTabMwFYPG7UDIwirjuOPzh7B8w9X58EuPjPs6iSLeEB
   0NcI1O5G9/TETWcgNXg7Wvt2uTPU5Ceym1MiG9U6GBK+1K/mYJ/YmsDwg
   t6WeT2GTdKlPd4lnn+Uf72Crs8JMcJilc1ACwO0wA0VlMzIF+gPpHdYLc
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="319297868"
X-IronPort-AV: E=Sophos;i="5.98,286,1673942400"; 
   d="scan'208";a="319297868"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 15:12:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="659806468"
X-IronPort-AV: E=Sophos;i="5.98,286,1673942400"; 
   d="scan'208";a="659806468"
Received: from jball6-mobl.amr.corp.intel.com (HELO [10.209.105.116]) ([10.209.105.116])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 15:12:17 -0700
Message-ID: <1e1bec34-36bd-a719-7d3b-23ab268f7092@intel.com>
Date:   Thu, 23 Mar 2023 15:12:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v10 05/16] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
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
 <5c4a28c8-f17d-7395-cc63-3cbd9b31befb@intel.com>
 <a02f304ea0e62180e07e2eb63eaf2411b702c672.camel@intel.com>
 <141def31-dcbb-70ae-2935-4fb06a986036@intel.com>
 <6be93d78e01906ff5c3714005170d761e5b40d41.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <6be93d78e01906ff5c3714005170d761e5b40d41.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/23/23 15:09, Huang, Kai wrote:
> 1) In TDH.SYS.INIT, ask TDX module team to return TDX_RND_NO_ENTROPY instead of
> TDX_SYS_BUSY when running out of entropy.
> 
> 2) In TDH.SYS.KEY.CONFIG, ask TDX module to return TDX_RND_NO_ENTROPY instead of
> TDX_KEY_GENERATION_FAILED when running out of entropy.  Whether
> TDX_KEY_GENERATION_FAILED should be still kept is  up to TDX module team
> (because it looks running concurrent PCONFIGs is also related).
> 
> 3) Ask TDX module to always return TDX_RND_NO_ENTROPY in _ALL_ SEAMCALLs and
> keep this behaviour for future TDX modules too.

Yes, that's all fine.

> 4) In the common seamcall(), retry on TDX_RND_NO_ENTROPY.
> 
> In terms of how many times to retry, I will use a fixed value for now, similar
> to the kernel code below:
> 
> #define RDRAND_RETRY_LOOPS      10

Heck, you could even just use RDRAND_RETRY_LOOPS directly.  It's
hard(er) to bikeshed your choice of a random number that you didn't even
pick.
