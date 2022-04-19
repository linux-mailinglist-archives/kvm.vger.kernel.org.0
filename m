Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00A995063F1
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 07:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348648AbiDSFmn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 01:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232889AbiDSFmk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 01:42:40 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D568821833;
        Mon, 18 Apr 2022 22:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650346798; x=1681882798;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Wrm933wE0UyR3JQbOl6vuHnq4loKSYSGKxzEqBkuPtw=;
  b=kkXm7pSMr3YYD/DAH2Z8yMYPyh5FtGuVGFb+82AWw/wpI+PgbrZYXlGN
   X8Vrf5fYM4k4mrThTuBRENq75OYsQ7goNpDHabxbK78GyQl2pyy9WpX7T
   1TXGB8P2M/IbeD40uFb/pvmRjC3T55KeJSYtz93+MkcmJTL7icmZZJC1Z
   pZRgLRa1J82p9iSPxmJLaS6JkF9MtO7IT12w8bt7YWkCcyOkOjv+SkJ+O
   85xPFdfNDKi7njFlJNIE9afLR4FIwgrYIcMKyTEisjVMVLUb1uNgu2ZPv
   okrkmT3y90vXrg+SDaRRbcYoteYFkwbNlXJoSmMs0G5UAnUFia7lSFq+l
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10321"; a="324122559"
X-IronPort-AV: E=Sophos;i="5.90,271,1643702400"; 
   d="scan'208";a="324122559"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2022 22:39:58 -0700
X-IronPort-AV: E=Sophos;i="5.90,271,1643702400"; 
   d="scan'208";a="657510723"
Received: from chferrer-mobl.amr.corp.intel.com (HELO [10.209.37.31]) ([10.209.37.31])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2022 22:39:57 -0700
Message-ID: <9b3fbb8f-47fc-82df-dc1f-e99649b18d85@linux.intel.com>
Date:   Mon, 18 Apr 2022 22:39:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [PATCH v3 02/21] x86/virt/tdx: Detect TDX private KeyIDs
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com, isaku.yamahata@intel.com
References: <cover.1649219184.git.kai.huang@intel.com>
 <2fb62e93734163d2f367fd44e3335cd8a2bf2995.1649219184.git.kai.huang@intel.com>
From:   Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <2fb62e93734163d2f367fd44e3335cd8a2bf2995.1649219184.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/5/22 9:49 PM, Kai Huang wrote:
> + * Intel Trusted Domain CPU Architecture Extension spec:

In TDX guest code, we have been using TDX as "Intel Trust Domain
Extensions". It also aligns with spec. Maybe you should change
your patch set to use the same.

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
