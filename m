Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 360AB633110
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 00:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiKUX61 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 18:58:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232128AbiKUX5x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 18:57:53 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC6D554F2;
        Mon, 21 Nov 2022 15:57:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669075069; x=1700611069;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ttMStxsbDlpMEs1D2wUgm8OuQh/Ime21MOFXRosoXV4=;
  b=iGsIpxgSk69LxRvCs7aQJbg+brvTXpv4/eAVI1egitYvyCeZRTOQU/8/
   nB61p/R6GQ7zbvVP1KhsMjSn9yyOfiAhl+pUYCj9e7EpUNJkam2KdSBnZ
   uMN92IGt9xI0UfXWfSOO28ZtvdP2IwupKKUhh26orqJ0AW1JfoXlgZuT/
   sDve7nht8lz3qTo1AwznK2x6XY7iahz85uaMqyJRiZhglnnJIlHhWb+hZ
   szSXM/CFWYtGqMLMCcBoyYD+nd8pLpRGuO+q5DXgRxrWESxf6P/2Nrfek
   ZioCmdgxRHffmrUzALdOQ0VcfgZnPu30x+T2WwwtmhlvXWuDoRec9RZe7
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="301237765"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="301237765"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 15:57:49 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="730201151"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="730201151"
Received: from dylanhol-mobl.amr.corp.intel.com (HELO [10.212.242.103]) ([10.212.242.103])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 15:57:47 -0800
Message-ID: <42bb1385-0c7f-6a87-43bb-ea4b12c48427@linux.intel.com>
Date:   Mon, 21 Nov 2022 15:57:45 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.2
Subject: Re: [PATCH v7 02/20] x86/virt/tdx: Detect TDX during kernel boot
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
 <aaee2d5332a97c840ad401ba935842a998a877ec.1668988357.git.kai.huang@intel.com>
 <3e4644e4-d939-7f15-02e1-a6be1ed7f932@linux.intel.com>
 <827adb3d1610f43ce71b1491db8c680dbe095035.camel@intel.com>
From:   Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <827adb3d1610f43ce71b1491db8c680dbe095035.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/21/22 1:37 AM, Huang, Kai wrote:
>> Also why is this global variable? At least in this patch, there seems to
>> be no use case.
> Platform_tdx_enabled() uses tdx_keyid_num to determine whether TDX is enabled by
> BIOS.
> 
> Also, in the changlog I can add "both initializing the TDX module and creating
> TDX guest will need to use TDX private KeyID".
> 
> But I also have a comment saying something similar around ...
> 

I am asking about the tdx_keyid_start. It mainly used in detect_tdx(). Maybe you
declared it as global as a preparation for next patches. But it is not explained
in change log.

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
