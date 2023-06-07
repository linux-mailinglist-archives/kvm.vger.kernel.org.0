Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF02726543
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 17:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241531AbjFGP5V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 11:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240958AbjFGP5M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 11:57:12 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C571BEA;
        Wed,  7 Jun 2023 08:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686153431; x=1717689431;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4WSpnJiCcc25uako5vnysuv35mXObG2rTQvLgVdCHmc=;
  b=Wsc8cfUffaC+8gbkuNyME9z/7kPxfrbkiMuo8kaomjh5iBwZi/u9Xtkk
   QpDWcerSd+sEFFZvdJrIJhPdcjowETaGbJhK7ifnAUEGEQEuW9oIg3jbK
   u74blBWqmEVXyakqHObOrZ6yDmyRSyZD8ZZVUidabjsjtOsukfxj5GoAn
   JH2vBB8lwsag7woxWxK61bABCe/LEEvasIjlYbbiu8odnxoQ3aZ5Buy7b
   P/cIfb8s7DNYKjRGquea/vIRHE5t/4XKgYgwK2QIdDr0MBeBRGncRGZXQ
   KMqKRSBtpE30Xtk9dYh222BfSToyV0Lu42YwOzElyVo5ZH/uay6XffcRB
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="360360133"
X-IronPort-AV: E=Sophos;i="6.00,224,1681196400"; 
   d="scan'208";a="360360133"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 08:57:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="739335890"
X-IronPort-AV: E=Sophos;i="6.00,224,1681196400"; 
   d="scan'208";a="739335890"
Received: from vsmyers-mobl2.amr.corp.intel.com (HELO [10.212.146.233]) ([10.212.146.233])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 08:57:09 -0700
Message-ID: <c1f6322a-eb27-3a3c-5d96-f0601c004a8d@intel.com>
Date:   Wed, 7 Jun 2023 08:57:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v11 10/20] x86/virt/tdx: Add placeholder to construct
 TDMRs to cover all TDX memory regions
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, kirill.shutemov@linux.intel.com,
        tony.luck@intel.com, peterz@infradead.org, tglx@linutronix.de,
        seanjc@google.com, pbonzini@redhat.com, david@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        chao.gao@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
References: <cover.1685887183.git.kai.huang@intel.com>
 <f9148e67e968d7aed4707b67ea9b1aa761401255.1685887183.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <f9148e67e968d7aed4707b67ea9b1aa761401255.1685887183.git.kai.huang@intel.com>
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

On 6/4/23 07:27, Kai Huang wrote:
> +struct tdmr_info_list {
> +	void *tdmrs;	/* Flexible array to hold 'tdmr_info's */
> +	int nr_consumed_tdmrs;	/* How many 'tdmr_info's are in use */

I'm looking back here after seeing the weird cast in the next patch.

Why is this a void* instead of a _real_ type?
