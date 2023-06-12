Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76C4672B58F
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 05:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233871AbjFLDBH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Jun 2023 23:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjFLDBF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 11 Jun 2023 23:01:05 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A656CE42;
        Sun, 11 Jun 2023 20:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686538862; x=1718074862;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xaf+6IVAFPikf9k8jHuBKGigqxwE6g9BXBfNHh9Lt8Q=;
  b=GMljJlGhuXOeWq6I0c3GgwriQUYPQOy2jh32JkLI4IOE70pTUsO0lyqj
   FQv9ykV5lgcFoTgjH0SjVIkM6WuiAkxV8uilmh2uuubUIPj4Ka9rQeRni
   LtBhURgQGL7SP0nMOseIq3jx4isHX/7jzwkbeBH2II2CFwyB3V/Y3+PX1
   TNWShbs9KwZCjvinwnPXsfhvbByyauLGsgf+Ngq/+WGtrb4Yx1llsDiEk
   PBjOH45DchM+37wuRnV3PmsUbUvujiDDKYfiBjKsLmkG7ZjB2GcfBidFd
   1VcYE+vZdmuT/yGnWkszkamy1lRg+u2H8P27arpOx67iHwJyYt1R6+UEW
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="421527153"
X-IronPort-AV: E=Sophos;i="6.00,235,1681196400"; 
   d="scan'208";a="421527153"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2023 20:01:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="714237378"
X-IronPort-AV: E=Sophos;i="6.00,235,1681196400"; 
   d="scan'208";a="714237378"
Received: from dpricket-mobl.amr.corp.intel.com (HELO [10.209.52.25]) ([10.209.52.25])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2023 20:00:58 -0700
Message-ID: <758c2dfa-642c-278a-331f-7a90384ab9b2@intel.com>
Date:   Sun, 11 Jun 2023 20:01:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v11 10/20] x86/virt/tdx: Add placeholder to construct
 TDMRs to cover all TDX memory regions
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
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
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
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
References: <cover.1685887183.git.kai.huang@intel.com>
 <f9148e67e968d7aed4707b67ea9b1aa761401255.1685887183.git.kai.huang@intel.com>
 <20230608225245.rvygi5zkr2niolsj@box>
 <2ae5cfb17ed0a6caa235e49086ac233972400ddc.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <2ae5cfb17ed0a6caa235e49086ac233972400ddc.camel@intel.com>
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

On 6/11/23 19:21, Huang, Kai wrote:
> Should I change the name to "tdmr_info_array"?

If foo[bar] works on it, then it's an array.  If not, then it's not an
array.


