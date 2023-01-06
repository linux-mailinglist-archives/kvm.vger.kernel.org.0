Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 319256606E2
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 20:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234565AbjAFTEV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 14:04:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjAFTES (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 14:04:18 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0258A26F0;
        Fri,  6 Jan 2023 11:04:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673031858; x=1704567858;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WwfW0k23SLCZLwN6PinORxikUQrfSUhqjMfNwCyAJNE=;
  b=EqE5lo+zliSfVPcqkqwyiJj9lfq0dMRUDL0V+GOWuqE2h3mmXdaO5oBY
   3HKnyceD+EasDvVhz+Pt6TaXW0j8q1uMj3ENzSWHbezXu7yfC6Glgy7Km
   MraKZpIwNWZNh8mvb8EjmtLGYXWCZaat12JiQCtRYb9Cwtice8t+c7QgE
   oB46qm14f64dIJcOwF9LyOSffcmG9h15UHjrm+MQIWk2DzdiPZ7AjDpi7
   MPwSBJ+0Bb/tQaiYrQL/bTEcKCypf/SNSkjdsJES4RIWIdo8a9RWIFE5i
   xANTIrNTy6qSXaXqv5QY1t4mTjpzE598LGMaW5wCXKqrnin6/lzG5609x
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="323786215"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="323786215"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 11:04:17 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="656020399"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="656020399"
Received: from xiangyuy-mobl.amr.corp.intel.com (HELO [10.212.251.186]) ([10.212.251.186])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 11:04:16 -0800
Message-ID: <ea1f7a5b-e617-8466-51b2-7196a018f4c0@intel.com>
Date:   Fri, 6 Jan 2023 11:04:16 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v8 01/16] x86/tdx: Define TDX supported page sizes as
 macros
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, peterz@infradead.org, tglx@linutronix.de,
        seanjc@google.com, pbonzini@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1670566861.git.kai.huang@intel.com>
 <2436106b4de8df75ab304c43128fe5b174bb0bf4.1670566861.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <2436106b4de8df75ab304c43128fe5b174bb0bf4.1670566861.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/22 22:52, Kai Huang wrote:
> TDX supports 4K, 2M and 1G page sizes.  The corresponding values are
> defined by the TDX module spec and used as TDX module ABI.  Currently,
> they are used in try_accept_one() when the TDX guest tries to accept a
> page.  However currently try_accept_one() uses hard-coded magic values.
> 
> Define TDX supported page sizes as macros and get rid of the hard-coded
> values in try_accept_one().  TDX host support will need to use them too.
> 
> Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>

Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>

