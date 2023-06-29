Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51467741D71
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 03:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbjF2BBb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 21:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbjF2BB3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 21:01:29 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7DAF212F;
        Wed, 28 Jun 2023 18:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688000488; x=1719536488;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wvcp0oNxhAZF/jxUcax6I76yc5ZgM67abJCJcCMwEVU=;
  b=Dua44uzStFNn/I53Kgp9FOoplvE9I2dt2fRTT+57MfImjDk9VMvkUh+3
   Tpp66o8u0OpQwoV7xSK3eo/2RUAPSv4cFVuRd6aGh2juUoRF+CJFxQuLS
   I4NXivDNXCakXlhXiMBLUPsDzR9SyLA3nfbC3JBz0PY2c2WA0hFTSg+kx
   ehk2I6SjZt7EJiWt2V8d4am04LgVXbNFbLx+uWqtp75oU00qcHgIwTqLh
   ZfQi16jVn43xJw2EedCRJAeJuQqvUcxGxRdF/ox4Y2832JJHFbZiZce6m
   MJtl8D90OMzLOuZVIjIyJw3+/9ro8JREJDEXJuvKr/5hx6Jgraw+tdCmU
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="362038594"
X-IronPort-AV: E=Sophos;i="6.01,167,1684825200"; 
   d="scan'208";a="362038594"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 18:01:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="1047600854"
X-IronPort-AV: E=Sophos;i="6.01,167,1684825200"; 
   d="scan'208";a="1047600854"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga005.fm.intel.com with ESMTP; 28 Jun 2023 18:01:21 -0700
Date:   Thu, 29 Jun 2023 09:01:20 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
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
Subject: Re: [PATCH v12 00/22] TDX host kernel support
Message-ID: <20230629010120.odlfyf7ka7oexdls@yy-desk-7060>
References: <cover.1687784645.git.kai.huang@intel.com>
 <20230628070418.6dky65allycok4us@yy-desk-7060>
 <cd5dbba41bee8ad679607a18409863054e5fbdcc.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd5dbba41bee8ad679607a18409863054e5fbdcc.camel@intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 28, 2023 at 08:12:55AM +0000, Huang, Kai wrote:
> > >
> > > 2. CPU hotplug
> > >
> > > DX doesn't support physical (ACPI) CPU hotplug.  A non-buggy BIOS should
> >   ^^
> >
> > Need T here.
>
> Thanks!
>
> >
> [...]
>
> > > 4. Memory Hotplug
> > >
> > > After the kernel passes all "TDX-usable" memory regions to the TDX
> > > module, the set of "TDX-usable" memory regions are fixed during module's
> > > runtime.  No more "TDX-usable" memory can be added to the TDX module
> > > after that.
> > >
> > > To achieve above "to guarantee all pages in the page allocator are TDX
> > > pages", this series simply choose to reject any non-TDX-usable memory in
> > > memory hotplug.
> > >
> > > 5. Physical Memory Hotplug
> > >
> > > Note TDX assumes convertible memory is always physically present during
> > > machine's runtime.  A non-buggy BIOS should never support hot-removal of
> > > any convertible memory.  This implementation doesn't handle ACPI memory
> > > removal but depends on the BIOS to behave correctly.
> > >
> > > Also, if something insane really happened, 4) makes sure either TDX
> >
> > Please remove "4)" if have no specific meaning here.
> >
>
> It means the mechanism mentioned in "4. Memory hotplug".

Ah I see, it's fine to me, thanks.

> >
