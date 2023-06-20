Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3647370CB
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 17:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbjFTPpB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 11:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233165AbjFTPoy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 11:44:54 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D3E10C2;
        Tue, 20 Jun 2023 08:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687275892; x=1718811892;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1bkJ3ipFHamETkUDcBjYCsABo3+BsqpoidFMtVCS97c=;
  b=djMU42Jl/grQDGt0KTgHNm0TlNCTc103kV5AwiR9nV7+Ttr1KgH9GndS
   h8k1bU3ZHIMqUH6vZO0e1P/UgAhsYMQUYec2yySprCN5wInlVULT6Z25J
   kdiw0+PoN4fl/0xEksWzlKxDvr+9YJo0KdbPMLozih0bxQH+5E72fQdlW
   sBKj2457vwUlrXgROVBECf1TLkB/VgYcGWN0mAcX+OQMfWRqECfAuBTdw
   2muLsqxXQR1Du8g84/xY3Ud9RoSJbZXt85wMMx+t5yh+aQmjqeHtt2RIm
   Rd/Hk/BMsQaI3nDFzee5jPLQVH503boKGKf3/sgRZelommdkob8+iJcpV
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10747"; a="423559114"
X-IronPort-AV: E=Sophos;i="6.00,257,1681196400"; 
   d="scan'208";a="423559114"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2023 08:44:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10747"; a="960823238"
X-IronPort-AV: E=Sophos;i="6.00,257,1681196400"; 
   d="scan'208";a="960823238"
Received: from rashmigh-mobl.amr.corp.intel.com (HELO [10.255.228.28]) ([10.255.228.28])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2023 08:44:49 -0700
Message-ID: <f4e0edf5-540b-6ebf-2cc4-3b0941fb901b@intel.com>
Date:   Tue, 20 Jun 2023 08:44:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v11 04/20] x86/cpu: Detect TDX partial write machine check
 erratum
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
 <86f2a8814240f4bbe850f6a09fc9d0b934979d1b.1685887183.git.kai.huang@intel.com>
 <bf797bc6-e264-02b0-12ee-c2ebf7c92d22@intel.com>
 <9cb242a0f5a6638770753b24ebd09e09ca047766.camel@intel.com>
 <15a06a50557335e0bbdb5edf228de6f8acb13513.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <15a06a50557335e0bbdb5edf228de6f8acb13513.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/19/23 04:37, Huang, Kai wrote:
> Please let me know for any comments?

Can you please go look at where most of the X86_BUG_* bits are set?  Can
you set yours near one of the existing sites instead of plopping a new
one into the code?

