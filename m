Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFD9723386
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 01:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232516AbjFEXIL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 19:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjFEXIJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 19:08:09 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0AFBD2;
        Mon,  5 Jun 2023 16:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686006486; x=1717542486;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1fCn/T37XYukBsWn+R2C9u8f4VCJGtjpUA8uepPPiao=;
  b=ENxqC8MJHkYoX52ofdcSsWRHam4vToAjEq+wqS39Wim8r5csczHD0yFj
   2eTWRxpL0OR6H/mWwUjGFSjVgJEZkcUlGzUajIUAxFZfHM22zHgmWlUQ7
   4enK8pVWXyipOMqQutnsZnIlUnOrNDY6fAQ4fYZqAvn/nB+YR3R5eGKmz
   uQMJq8WkSx9iZGlxUENCTgmOostDtUnqImCmvQASphVrJzCkHvP/87j9r
   jwvPoZH1LWLRAaXmKwh30Jc6biH7jXnajUZ0OYTi+y2/DE0kg+oU/rBiv
   GHUn/ev9g10mcIR0lx6FKLpkhWpbd8scHo43/uMoMSOXj1WAFN2LoduMm
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="422332536"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="422332536"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 16:08:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="778751161"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="778751161"
Received: from pmudgal-mobl1.amr.corp.intel.com (HELO [10.209.41.254]) ([10.209.41.254])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 16:08:03 -0700
Message-ID: <8dffbea1-0c9b-498b-c270-409835377e90@intel.com>
Date:   Mon, 5 Jun 2023 16:08:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v11 07/20] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
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
References: <cover.1685887183.git.kai.huang@intel.com>
 <21b3a45cb73b4e1917c1eba75b7769781a15aa14.1685887183.git.kai.huang@intel.com>
 <20230605212303.GA2244082@ls.amr.corp.intel.com>
 <733d0d042f39f099caa35af9b517b6c50ebac12f.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <733d0d042f39f099caa35af9b517b6c50ebac12f.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/5/23 16:04, Huang, Kai wrote:
> I've changed to -ENODEV which doesn't cause build error in my test.
> 
> I agree it's better to include errno.h explicitly but IMHO it's a problem in the
> existing upstream code (tdx_kvm_hypercall() returns -ENODEV when INTEL_TDX_GUEST
> is off), thus should be addressed in a separate patch but not folded into this
> one.
> 
> Since now there's no build error, I hesitated to added such patch.  I can do it
> separately if it should be addressed.

Yes, it should be addressed.



